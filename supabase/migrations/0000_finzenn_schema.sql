-- Enable necessary extensions if not present
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Types
CREATE TYPE period_type AS ENUM ('monthly', 'weekly');
CREATE TYPE transaction_type AS ENUM ('income', 'expense');
CREATE TYPE transaction_source AS ENUM ('manual', 'voice', 'ocr');

-- 2. Tables

-- couples: Stores paired instances for Couple Mode
CREATE TABLE couples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  code TEXT UNIQUE NOT NULL, -- 6-digit grouping code
  user_1_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  user_2_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- profiles: Public representation extending auth.users
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  current_couple_id UUID REFERENCES couples(id) ON DELETE SET NULL
);

-- transactions: Both Solo and Shared
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  couple_id UUID REFERENCES couples(id) ON DELETE CASCADE, -- NULL if Personal
  amount DECIMAL(12,2) NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  date TIMESTAMPTZ DEFAULT NOW(),
  type transaction_type NOT NULL,
  source transaction_source NOT NULL,
  receipt_url TEXT
);

-- budgets: Threshold logic per owner (user or couple)
CREATE TABLE budgets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL, -- Logical reference mapping to either user_id or couple_id
  category TEXT NOT NULL,
  limit_amount DECIMAL(12,2) NOT NULL,
  period period_type NOT NULL
);


-- 3. Row Level Security (RLS)

ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;


-- 4. Policies

-- Profiles
CREATE POLICY "Users can view their own profile." 
  ON profiles FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile." 
  ON profiles FOR UPDATE 
  USING (auth.uid() = id);

-- Couples
CREATE POLICY "Users can view couples they belong to." 
  ON couples FOR SELECT 
  USING (auth.uid() = user_1_id OR auth.uid() = user_2_id);

CREATE POLICY "Users can update couples they belong to." 
  ON couples FOR UPDATE 
  USING (auth.uid() = user_1_id OR auth.uid() = user_2_id);

-- Transactions: 
-- Condition: user created it OR it belongs to a couple where the user is a member
CREATE POLICY "Users can view their personal and shared transactions." 
  ON transactions FOR SELECT 
  USING (
    (user_id = auth.uid() AND couple_id IS NULL) OR 
    (couple_id IN (SELECT id FROM couples WHERE user_1_id = auth.uid() OR user_2_id = auth.uid()))
  );

CREATE POLICY "Users can insert their personal and shared transactions." 
  ON transactions FOR INSERT 
  WITH CHECK (
    (user_id = auth.uid() AND couple_id IS NULL) OR 
    (couple_id IN (SELECT id FROM couples WHERE user_1_id = auth.uid() OR user_2_id = auth.uid()))
  );

-- Budgets
-- Condition: The owner_id is either the User's UID or the User's Couple ID
CREATE POLICY "Users can manage budgets (Solo/Shared)." 
  ON budgets FOR ALL 
  USING (
    owner_id = auth.uid() OR 
    owner_id IN (SELECT id FROM couples WHERE user_1_id = auth.uid() OR user_2_id = auth.uid())
  );
