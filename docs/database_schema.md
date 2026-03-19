# Database Schema: Finzenn (Solo & Couple Mode)

## 1. Table: profiles
- id: uuid (references auth.users)
- email: text
- full_name: text
- avatar_url: text
- current_couple_id: uuid (references couples.id, nullable)

## 2. Table: couples
- id: uuid (primary key)
- created_at: timestamp
- code: text (unique 6-digit code for pairing)
- user_1_id: uuid (references profiles.id)
- user_2_id: uuid (references profiles.id)

## 3. Table: transactions
- id: uuid (primary key)
- user_id: uuid (who created it)
- couple_id: uuid (null if personal, id if shared)
- amount: decimal
- category: text
- description: text
- date: timestamp
- type: text (income / expense)
- source: text (manual / voice / ocr)
- receipt_url: text (nullable)

## 4. Table: budgets
- id: uuid
- owner_id: uuid (user or couple id)
- category: text
- limit_amount: decimal
- period: text (monthly / weekly)
