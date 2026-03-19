# Finzenn

Finzenn is a next-generation local and shared personal finance application.
It features two fundamental modes: **Solo Mode** and **Couple Mode**.

## Aesthetic & UI
The application uses a **Premium Glass Finance** aesthetic built with Flutter.
- Dark theme baseline (`#1E1E2C`).
- Vibrant gradients and neon-purple highlights (`#6B48FF`).
- Glassmorphism UI components using `BackdropFilter` implementations.

## Database Schema (Supabase)
The Supabase data models are centralized around shared `couple_id`s, ensuring zero front-end logic coupling.
See `/docs/database_schema.md` for full implementation details, including:
1. **profiles**: References `auth.users` with personal data and an optional `current_couple_id`.
2. **couples**: Represents a paired instance.
3. **transactions**: Holds financial records. Shared records possess a `couple_id`.
4. **budgets**: Implements limits for specific entities (Solo or Couple).
