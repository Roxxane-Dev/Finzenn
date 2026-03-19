# 🏡 Finzen – Hogar Financiero Inteligente

---

## 🎯 Visión del Producto
Finzen es una app móvil AI-first que permite a usuarios individuales o parejas gestionar su vida financiera como si hablaran con un asesor personal.

Incluye:
- Registro de gastos (manual, voz, OCR)
- Análisis inteligente
- Presupuestos y metas
- Dashboard emocional ("hogar financiero")
- Asistente conversacional

---

# 🧠 SYSTEM PROMPT: EL ASESOR FINANCIERO INTELIGENTE

## Role: Senior Personal Finance Advisor (AI)

### 👤 Personalidad
- Tono: Profesional, empático, claro y directo.
- Objetivo: Ayudar a tomar mejores decisiones financieras sin juzgar.
- Estilo: Lenguaje simple pero preciso.

---

### 🗣️ Instrucciones de Respuesta

#### General
- Nunca juzgar al usuario
- Siempre basarse en datos
- Explicar de forma clara y accionable

#### Voz
- Máximo 2 frases
- Directo y natural

#### Chat
- Usar bullets para montos
- Respuestas estructuradas

---

### ✅ Reglas Clave

1. **Confirmación Activa**
Ej:
"Entendido, registro $25.00 en 'Cena' para ambos"

2. **Contexto de Pareja**
Ej:
"Esto deja el presupuesto de 'Salidas' en $100.00"

3. **Insight Proactivo**
Ej:
"He notado que el gasto en suscripciones subió 10% este mes"

---

### 🚫 Restricciones

- No redondear montos
- No dar consejos de inversión (crypto, bolsa)
- Si input es ambiguo → preguntar antes de registrar

---

# 🛠️ WORKFLOWS POR CANAL

---

## 🎙️ 1. VOICE → ACTION

### Trigger
Usuario activa micrófono

### Flujo
1. Capturar voz
2. Transcribir
3. Extraer intención + entidades
4. Clasificar gasto
5. Guardar
6. Confirmar

### Prompt inicial
"Hola, ¿qué gasto o ingreso quieres que anote hoy?"

### Ejemplo

Input:
"Oye, apunta 15 euros de gasolina para los dos"

Output:
"He registrado 15,00€ en transporte. Dividido entre ambos."

---

## 💬 2. CHAT → ANÁLISIS

### Flujo
1. Obtener contexto financiero
2. Ejecutar tool (analytics)
3. Generar respuesta estructurada

### Ejemplo

"Muéstrame cómo vamos este mes"

Respuesta:

- Ingresos: $4,500.00  
- Gastos fijos: $2,100.00  
- Gastos variables: $850.00  

Insight:
Van por debajo en ocio por $120.00.

---

## 📸 3. OCR → FEEDBACK

### Flujo
1. Imagen → OCR
2. Extraer total, comercio
3. Clasificar
4. Confirmar

### Ejemplo

"He detectado un gasto de Starbucks por $12.50.  
¿Lo asigno a cuenta personal o compartida?"

---

# 🤖 AI AGENT ARCHITECTURE

## Tools

- registrar_gasto
- analizar_gastos
- detectar_anomalias
- calcular_safe_to_spend
- generar_reporte

---

## Flujo MCP

User → Intent Detection → Tool → Response

---

## 🏗️ Architecture Overview (Clean Architecture + AI-First)

Finzenn sigue una arquitectura **Clean Architecture + AI-native**, separando claramente responsabilidades entre capas para lograr escalabilidad, mantenibilidad y un sistema inteligente desacoplado.

---

## 🧱 1. 📱 Presentation Layer (Flutter)

Framework: Flutter  

Responsable de toda la interacción con el usuario.

### Inputs multimodales:
- Texto (chat)
- Voz (speech-to-text)
- Imagen (OCR)

### Responsabilidades:
- UI/UX (Glassmorphism)
- Manejo de estado (Provider / Riverpod)
- Navegación
- Render de insights generados por AI
- Envío de inputs al dominio (use cases)

---

## 🧠 2. Domain Layer (Core Business + AI Orchestration)

Contiene:
- Entidades (Entities)
- Casos de uso (Use Cases)
- Interfaces (Repositories)

### Responsabilidades:
- Definir lógica de negocio pura
- Orquestar comportamiento AI (MCP-style)
- Decidir qué acción ejecutar

### Casos de uso principales:
- register_expense
- analyze_expenses
- detect_anomalies
- safe_to_spend
- split_expense

### Flujo interno del dominio:
- input → detectar_intent → ejecutar_use_case → respuesta


---

## 🔌 3. Application Layer (AI Processor)

Actúa como puente entre el dominio y la infraestructura.

### Componentes:
- AI Processor
- Prompt Engineering
- Integración con LLM

### LLM Provider:
- OpenAI / Gemini

### Responsabilidades:
- Detectar intención (intent classification)
- Extraer entidades (monto, categoría, tipo)
- Mapear input → use case
- Generar respuestas naturales

---

## 🗄️ 4. Infrastructure Layer (Supabase)

Servicios:
- Supabase Auth
- PostgreSQL
- Realtime
- Edge Functions

### Responsabilidades:
- Persistencia de datos
- Seguridad (Row Level Security)
- Ejecución de lógica serverless (tools)
- Sincronización en tiempo real

---

## 📦 5. Storage Layer

- Supabase Storage

### Responsabilidades:
- Almacenamiento de imágenes (tickets)
- Soporte para OCR

---

## 🔄 Flujo de Datos (Clean Flow)

- Usuario (Flutter UI)
- ↓
- Presentation Layer
- ↓
- Application Layer (AI Processor)
- ↓
- Domain Layer (Use Case Execution)
- ↓
- Infrastructure Layer (Supabase / Edge Functions)
- ↓
- Database / Storage
- ↓
- AI genera respuesta
- ↓
- UI renderiza insight


---

## 🧩 Separación de responsabilidades

- Presentation → solo UI
- Domain → lógica pura (independiente)
- Application → AI + orquestación
- Infrastructure → base de datos y servicios externos

---

## 📁 Directory Structure

### 🧠 AI Workspace (Antigravity)

.agents/
├── rules/              # Reglas del agente (intent, tools, behavior)
├── workflows/          # Flujos (core-workflow, expense-flow, etc.)

Finzenn.md              # Contexto global del proyecto (arquitectura, guidelines)

---

### 📱 Flutter (Frontend)

lib/
├── core/
│   ├── services/
│   │   ├── ai_processor.dart
│   │   ├── supabase_service.dart
│   │   └── ocr_service.dart
│
├── features/
│   ├── chat/
│   ├── dashboard/
│   ├── voice/
│   ├── scanner/
│
├── domain/
│   ├── entities/
│   │   ├── transaction.dart
│   │   ├── user.dart
│   │   └── couple.dart
│   │
│   ├── usecases/
│   │   ├── register_expense.dart
│   │   ├── analyze_expenses.dart
│   │   └── detect_anomalies.dart
│   │
│   ├── repositories/
│   │   └── finance_repository.dart
│
├── data/
│   ├── repositories/
│   │   └── finance_repository_impl.dart
│
├── providers/
│   ├── auth_provider.dart
│   └── finance_provider.dart
│
└── main.dart

---

### 🗄️ Supabase (Backend)

supabase/
├── functions/
│   ├── ai-processor/
│   ├── register-expense/
│   ├── analyze-expenses/
│   ├── detect-anomalies/
│
├── migrations/
│   ├── users.sql
│   ├── transactions.sql
│   ├── couples.sql

## 🤖 AI Tools (Edge Functions)

Cada acción del sistema es una tool desacoplada:

- register_expense
- analyze_expenses
- detect_anomalies
- safe_to_spend
- split_expense

Estas functions son ejecutadas desde el AI Processor.

---

## 🔐 Seguridad

- Row Level Security (RLS)
- Autenticación obligatoria
- Separación por user_id y couple_id
- API keys protegidas en backend

---

## 🚀 Principios clave

- AI-first (no es solo CRUD)
- Clean Architecture
- Serverless
- Modular y escalable

# 🎨 UI STYLE: PREMIUM GLASS FINANCE

## Estilo general
- Glassmorphism
- Bordes redondeados (24px+)
- Sombras suaves

---

## 🌈 Color Tokens

- Primary Gradient: linear-gradient(135deg, #6366F1, #A855F7)
- Income: #00D084
- Expense: #FF4D4D
- Background: #F8FAFC
- Text Primary: #1E293B
- Text Secondary: #94A3B8

---

## UI Reglas

- Cards con blur:
  backdrop-filter: blur(10px)
  background: rgba(255,255,255,0.7)

- Tipografía:
  Inter / SF Pro
  Montos → Semibold

---

# 🎤 UX INTELIGENTE

## Voz
- Mostrar ondas con gradient
- Feedback en tiempo real

## OCR
- Resaltar TOTAL detectado
- Color según tipo:
  - ingreso → verde
  - gasto → neutro

## Parejas
- Indicador visual por usuario:
  - Usuario A → azul
  - Usuario B → violeta

---

# 📊 ANALYTICS WORKFLOW

1. Obtener datos
2. Agrupar
3. Detectar patrones
4. Generar insights AI
5. Mostrar en dashboard

---

# 👫 MODO PAREJA

- Shared account
- División automática de gastos
- Insights conjuntos

---

# 🔐 SEGURIDAD

- JWT
- Encriptación de datos
- Manejo seguro de sesiones

---

# 🔄 GITHUB WORKFLOW

## Branching
- main
- develop
- feature/*

## Flujo
feature → PR → review → develop → main

## Commits
- feat:
- fix:
- refactor:
- docs:

---

# 🚀 ROADMAP

## MVP
- Registro manual
- Chat básico
- Dashboard simple

## V1
- Voz + OCR
- Analytics
- Parejas

## V2
- Open Banking
- Score financiero real
- IA predictiva

---

# 🧠 REGLAS CORE DEL SISTEMA

1. Todo feature debe poder ser usado vía chat
2. Todo input debe ser multimodal
3. Toda acción genera data
4. Toda data genera insight
5. Toda respuesta debe ayudar a decidir