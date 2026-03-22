-- Migration 0003: Onboarding Fields
-- Run this in your Supabase SQL Editor to prepare the database for the Smart Setup

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS financial_goal TEXT,
ADD COLUMN IF NOT EXISTS tracking_preference TEXT,
ADD COLUMN IF NOT EXISTS income_range TEXT,
ADD COLUMN IF NOT EXISTS primary_expenses TEXT[];

-- Aseguramos que los usuarios tengan una política para leer y actualizar su profile completo
-- (Esto ya existía en 0000_finzenn_schema, pero no está de más recalcarlo si da fallos en RLS).
