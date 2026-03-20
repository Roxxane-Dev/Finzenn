-- 1. Create table for Subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL, -- Logical reference to user.id OR couple.id
  name TEXT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  billing_cycle period_type NOT NULL, -- leverages enum from 0000 migration
  next_billing_date DATE,
  is_active BOOLEAN DEFAULT TRUE,
  alert_on_increase BOOLEAN DEFAULT TRUE
);
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their subscriptions" 
  ON subscriptions FOR ALL 
  USING (owner_id = auth.uid() OR owner_id IN (SELECT id FROM couples WHERE user_1_id = auth.uid() OR user_2_id = auth.uid()));

-- 2. Create table for AI Insights
CREATE TABLE ai_insights (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  couple_id UUID REFERENCES couples(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  insight_type TEXT NOT NULL, -- e.g., 'anomaly', 'saving_opportunity', 'trend'
  severity TEXT, -- 'low', 'medium', 'high'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_read BOOLEAN DEFAULT FALSE
);
ALTER TABLE ai_insights ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own and shared insights" 
  ON ai_insights FOR ALL 
  USING ((user_id = auth.uid() AND couple_id IS NULL) OR (couple_id IN (SELECT id FROM couples WHERE user_1_id = auth.uid() OR user_2_id = auth.uid())));

-- 3. Create table for Academy Progress
CREATE TABLE academy_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  module_id TEXT NOT NULL,
  status TEXT DEFAULT 'not_started', -- 'in_progress', 'completed'
  score INTEGER DEFAULT 0,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, module_id)
);
ALTER TABLE academy_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own academy progress" 
  ON academy_progress FOR ALL 
  USING (user_id = auth.uid());

-- 4. Create table for AI Chat History Memory
CREATE TABLE ai_chat_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role TEXT NOT NULL, -- 'user', 'assistant'
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE ai_chat_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own chat history" 
  ON ai_chat_history FOR ALL 
  USING (user_id = auth.uid());
