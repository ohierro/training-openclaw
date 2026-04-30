---
marp: true
theme: default
paginate: true
---

# Sesión 2
## Interacción con el Mundo a través de "Skills"

> *Dándole manos al agente*

---

## 🗺️ Agenda

| Bloque | Tema | Tiempo |
|--------|------|--------|
|  ❓  | ¿Dónde estamos? | 5 mins |  
| 🧠 1 | El contexto (la memoria del agente) | 60 min |
|      | Descanso | 20 min |
| 📱 2 | Despliegue en Discord | 40 min |
|      | Descanso | 20 min |
| 🌐 3 | Skill de Lectura/Escritura con Notion — API externa | 30 min |
|  ❓  | Dudas y preguntas | 5 min |

**Objetivo:** Que el agente deje de ser una caja de texto y empiece a actuar en el mundo real.

---

## Recordatorio: ¿Dónde estamos?

```
Sesión 1 ✅  →  Agente básico. Acceso con TUI y Web.
Sesión 2 🔴  →  Acceso con discord y telegram a nuestro agente. Agente que consulta datos y ejecuta acciones
Sesión 3     →  Agente con acceso seguro a datos corporativos (MCP). Planificación de tareas
Sesión 4     →  Orquestación multi-agente
```

> El agente ya **sabe hablar**. Ahora vamos a darle **manos**.


---

# 📱 Despliegue en Telegram

*Del terminal al mundo real en 15 minutos*

---

## ¿Por qué Telegram?

- ✅ API de bots **gratuita y estable**
- ✅ No requiere servidor web ni HTTPS para empezar (long polling)
- ✅ OpenClaw tiene integración **nativa** — sin código extra
- ✅ Es posible probarlo desde un terminal **móvil** en tiempo real
- ✅ Ideal para **demos** y **prototipos** corporativos

---

## Paso 1: Crear el bot en BotFather

1. Abre Telegram y busca **@BotFather**
2. Envía `/newbot`
3. Elige un nombre para tu bot: `TechCorp Recepcionista`
4. Elige un username (debe terminar en `bot`): `techcorp_recep_bot`
5. BotFather te dará un **token**:

```
Done! Congratulations on your new bot.
Use this token to access the HTTP API:
7123456789:AAF8xQ3mN...Zk9
```

> 🔐 **Guarda este token. Es la llave de tu bot.**

---

## Paso 2: Conectar el token a OpenClaw

Añade la configuración de Telegram en tu `agent.yaml`:

```json
.openclaw/openclaw.json

"channels": {
    "telegram": {
        "enabled": true,
        "groups": {
        "*": {
            "requireMention": true
        }
        },
        "botToken": "${TELEGRAM_BOT_TOKEN}"
    }
}
```

Y en tu `.env`:

```bash
TELEGRAM_BOT_TOKEN=7123456789:AAF8xQ3mN...Zk9
```

---

## Paso 3: Arrancar el bot

```bash
# Iniciar OpenClaw con canal Telegram
python -m openclaw run --config agent.yaml

# Verás:
# ✅ OpenClaw v1.x iniciado
# 📱 Telegram: escuchando (long polling)
# 🤖 Bot activo: @techcorp_recep_bot
```

Ahora abre Telegram, busca tu bot por su username y envía `/start`.

---

## ¡El bot responde! 🎉

```
Tú: /start

Bot: ¡Hola! Soy Alex, el asistente virtual de TechCorp.
     ¿En qué puedo ayudarte hoy?

Tú: Quiero información sobre vuestros productos

Bot: Con mucho gusto. TechCorp ofrece soluciones de software
     empresarial. Para información detallada sobre productos
     y precios, puedo conectarte con nuestro equipo comercial.
     ¿Quieres que lo haga?
```
---

# Configuración de los canales

```
 "telegram": {
      "enabled": true,
      "dmPolicy": "pairing",
      "botToken": "......",
      "groups": {
        "-id": {
          "allowFrom": [
            "*"
          ],
          "enabled": true,
          "requireMention": false
        },
      },
      "groupAllowFrom": [
        "-5270964807",
        "-5270091283"
      ],
      "groupPolicy": "allowlist",
    }
```


---

# 📢 Nuestro segundo canal: Discord 

---

## Paso 1: Crear la aplicación en Discord Developer Portal

1. Ve a [discord.com/developers/applications](https://discord.com/developers/applications)
2. Clic en **New Application** → ponle un nombre (ej: `TechCorp Bot`)
3. Ve a la sección **Bot** → clic en **Add Bot**
4. En **Token**, clic en **Reset Token** y cópialo

-- 

## Paso 2: Paso 2: Obtener el Guild ID (servidor)
1. Activa el **Modo Desarrollador** en Discord (Ajustes → Avanzado)
2. Click derecho sobre tu servidor → **Copiar ID del servidor**

---

## Paso 3: Configurar OpenClaw

En `.env`:
```bash
DISCORD_BOT_TOKEN=tu_token_aquí
DISCORD_GUILD_ID=tu_guild_id_aquí
```

A partir de aquí, utilizamos `openclaw configure`


---

## Paso 4: Invitar el bot al servidor
1. En el portal, ve a **OAuth2 → URL Generator**
2. Scopes: `bot` · Permissions: `Send Messages`, `Read Message History`
3. Copia la URL generada y ábrela para invitar el bot

---

## Paso 5: Arrancar y probar
- Inicia OpenClaw y escribe en el canal del servidor
- Comparte el servidor con un compañero para que lo pruebe

**Bonus:** Cambia `SOUL.md` para que el bot se presente con tu empresa ficticia.

---

# Contexto

---

## Cómo entiende el contexto

El agente "entiende" el contexto mediante:

- 🧠 **Historial de mensajes:** Incluye todos los turnos previos
- 📋 **Metadatos de sesión:** Usuario, canal, timestamp
- 🔍 **RAG (Retrieval-Augmented Generation):** Busca info relevante en docs externos
- 🏷️ **Etiquetas y estado:** Variables personalizadas por sesión

**Ventaja clave:** No es solo memoria temporal, sino **contexto inteligente** que evoluciona.

---

## Ejemplo de sesión multi-turno

```
Sesión ID: abc123
Usuario: Juan Pérez
Canal: Telegram

[Turno 1]
User: Hola, quiero info sobre productos
Agent: ¡Hola Juan! ¿Qué tipo de productos te interesan?

[Turno 2]  
User: Los de software empresarial
Agent: Excelente. Ofrecemos soluciones ERP y CRM. ¿Quieres detalles técnicos?

[Turno 3]
User: Sí, y precios aproximados
Agent: Los precios parten desde 500€/mes. Te paso con ventas para cotización exacta.
```

> 🎯 **El agente adapta respuestas basándose en el historial completo.**

---

## Limitaciones y mejores prácticas

**Limitaciones:**
- 📏 **Longitud máxima:** Los LLMs tienen límites de tokens (ej: 4096)
- ⏳ **Expiración:** Sesiones viejas se pierden
- 🔒 **Privacidad:** Historial sensible debe manejarse con cuidado

**Mejores prácticas:**
- 🔄 **Reinicio periódico:** Para conversaciones largas o temas nuevos
- 📝 **Resúmenes:** El agente puede resumir historial largo
- 🏷️ **Etiquetas:** Usar para categorizar sesiones (soporte, ventas, etc.)

---

## Estructura de archivos
* Qué ficheros son relevantes? 
  * Configuración general: **openclaw.json**
  * Espacio de trabajo: **workspace/**
  
---

## El Workspace: el cerebro del agente

El **workspace** es el directorio central donde OpenClaw almacena toda la configuración y contexto del agente:

- 📁 **Ubicación:** Por defecto en `~/.openclaw/workspace/` (o configurable)
- 📝 **Formato:** Archivos Markdown simples y editables
- 🔄 **Lectura dinámica:** Se lee **cada vez que arranca una conversación**
- 🛠️ **Personalización:** Modifica archivos sin reiniciar el sistema

---

**Estructura típica:**
```
workspace/
├── AGENTS.md      # Definición de agentes
├── IDENTITY.md    # Personalidad del agente
├── SOUL.md        # System Prompt
├── TOOLS.md       # Herramientas disponibles
├── USER.md        # Contexto del usuario
├── BOOTSTRAP.md   # Inicialización
└── HEARTBEAT.md   # Estado del sistema
```

> 💡 **El workspace permite actualizar el agente en tiempo real editando texto plano.**

---

## ¿Por qué Markdown?

Markdown: https://www.markdownguide.org/

**Ventajas de usar Markdown para configuración:**

- ✏️ **Fácil edición:** Cualquier editor de texto basta
- 👥 **Colaborativo:** Versionable con Git, editable por no-técnicos
- 📖 **Legible:** Formato humano-friendly
- 🔧 **Flexible:** Soporta texto, listas, tablas, código
- 🤖 **Parseable:** OpenClaw lo convierte automáticamente a configuración

---

**📔 Ejemplo de edición en tiempo real:**
```bash
# Editar personalidad del agente
nano ~/.openclaw/workspace/IDENTITY.md

# El cambio se aplica en la siguiente conversación
# ¡Sin reiniciar servicios!

```
<!-- Vemos 2 tipos de agentes: técnico vs no técnico -->
<!-- Técnico: Eres un experto consultor informático. Deberás utilizar un lenguaje formal y, podrás utilizar acrónimos. Además, podrás entrar en detalles muy técnicos, ya que tu interlocutor será un perfil muy técnico.-->
<!-- Profesor: Deberás utilizar un lenguaje cercano y no formal. Eres un profesor de informática, para alumnos sin conocimientos técnicos. Deberás intentar hacer metáforas sobre los temas más complejos y evitar lenguaje muy técnico. -->
---

## Lectura en cada conversación

OpenClaw **lee el workspace cada vez que inicia una nueva sesión**:

1. **Arranque de conversación:** Carga todos los archivos Markdown
2. **Parsing automático:** Convierte MD a estructuras de datos
3. **Configuración dinámica:** Aplica identidad, tools, prompts
4. **Actualización en vivo:** Cambios en archivos afectan conversaciones futuras

**Ventaja clave:** **Personalización sin downtime** — edita y el agente adapta inmediatamente.

---

## El workspace también escribe

El workspace no es solo de lectura — el agente **también puede crear y modificar ficheros** para persistir información:

- 📝 **Memoria persistente:** Si el agente necesita recordar algo entre sesiones, crea un fichero en el workspace
- 📋 **Listas y registros:** Una lista de la compra, tareas, notas... se guardan como `.md`
- 📊 **Estado de usuario:** Preferencias o datos aprendidos se persisten en `USER.md`
- 📁 **Ficheros propios:** El agente puede crear ficheros nuevos para organizarse

---

## 🧪 Ejercicio — Resumen de documentos

**Objetivo:** Que el agente lea documentos de alumnos desde el workspace, genere un resumen por alumno y cree un informe consolidado con citas guardado en disco.

**Cómo funciona:**
- Los documentos están en `workspace/alumnos/` (uno por alumno)
- El agente los lee al arrancar la conversación
- Genera resúmenes individuales y un informe final con citas

---

**Pasos:**
1. Copia los ficheros de alumnos en `workspace/alumnos/` (ya están en `session01/data/`)
2. Actualiza `SOUL.md` para indicar al agente que es un evaluador académico
3. Pide: *"Haz un resumen del trabajo de cada alumno"*
4. Pide: *"Genera un informe consolidado con citas y guárdalo en workspace/informe_final.md"*
5. Abre `workspace/informe_final.md` y verifica el resultado

---

## 🧪 Ejercicio — Resumen de documentos (cont.)

**Ejemplo de `SOUL.md`:**
```markdown
Eres un evaluador académico. Tienes acceso a los trabajos de los
alumnos en workspace/alumnos/. Al resumir, sé objetivo y conciso.
Usa el formato: ## Alumno X · [título del trabajo]
Cuando generes el informe final, incluye citas textuales entre
comillas y guárdalo en workspace/informe_final.md.
```

---

**Ejemplo de conversación:**
```
Tú:     Resume el trabajo de cada alumno

Agente: ## Alumno 01 · Redes Neuronales
        Analiza arquitecturas CNN aplicadas a visión...

        ## Alumno 02 · NLP con Transformers
        Compara BERT y GPT en tareas de clasificación...

Tú:     Genera el informe consolidado y guárdalo

Agente: ✅ Informe guardado en workspace/informe_final.md
        Incluye resúmenes y citas de 5 trabajos.
```

> 💡 Comprueba que `workspace/informe_final.md` existe y contiene las citas correctas.

---

## Los archivos clave en OpenClaw

OpenClaw usa archivos Markdown en el directorio `workspace/` para definir el comportamiento y contexto del agente. Cada archivo tiene un propósito específico:

---

| Archivo | Propósito | Ejemplo |
|---------|-----------|---------|
| **AGENTS.md** | Define agentes disponibles y configuración | Lista de agentes con modelos asignados |
| **BOOTSTRAP.md** | Instrucciones de inicialización | Pasos para setup inicial |
| **HEARTBEAT.md** | Monitoreo de salud del sistema | Métricas de uptime y estado |
| **IDENTITY.md** | Identidad y personalidad del agente | Nombre, tono, restricciones |
| **SOUL.md** | System Prompt principal | Instrucciones base del agente |
| **TOOLS.md** | Herramientas disponibles | APIs, scripts, integraciones |
| **USER.md** | Contexto del usuario actual | Preferencias, historial |

> 💡 **Estos archivos permiten personalizar el agente sin tocar código.**

<!-- BOOTSTRAP desaparece una vez generado todo -->

---

## AGENTS.md — Definición de agentes

**Propósito:** Especifica qué agentes existen y sus configuraciones.

https://docs.openclaw.ai/reference/templates/AGENTS

* Instrucciones de funcionamiento para el agente y cómo debe usar la memoria.
* Se carga al inicio de cada sesión.
* Buen lugar para reglas, prioridades y detalles de “cómo comportarse”

<!-- Cada agente, dispone de su fichero propio. -->

---
AGENTD.md
```
# AGENTS.md - Your Workspace

This folder is home. Treat it that way.

## First Run

If `BOOTSTRAP.md` exists, that's your birth certificate. Follow it, figure out who you are, then delete it. You won't need it again.

## Session Startup

Before doing anything else:

1. Read `SOUL.md` — this is who you are
2. Read `USER.md` — this is who you're helping
3. Read `memory/YYYY-MM-DD.md` (today + yesterday) for recent context
4. **If in MAIN SESSION** (direct chat with your human): Also read `MEMORY.md`

Don't ask permission. Just do it.

```
---
AGENTD.md (cont)
```
## Memory

You wake up fresh each session. These files are your continuity:

- **Daily notes:** `memory/YYYY-MM-DD.md` (create `memory/` if needed) — raw logs of what happened
- **Long-term:** `MEMORY.md` — your curated memories, like a human's long-term memory

Capture what matters. Decisions, context, things to remember. Skip the secrets unless asked to keep them.

```
---
AGENTD.md (cont)
```
### 🧠 MEMORY.md - Your Long-Term Memory

- **ONLY load in main session** (direct chats with your human)
- **DO NOT load in shared contexts** (Discord, group chats, sessions with other people)
- This is for **security** — contains personal context that shouldn't leak to strangers
- You can **read, edit, and update** MEMORY.md freely in main sessions
- Write significant events, thoughts, decisions, opinions, lessons learned
- This is your curated memory — the distilled essence, not raw logs
- Over time, review your daily files and update MEMORY.md with what's worth keeping

```
---
AGENTD.md (cont)
```
### 📝 Write It Down - No "Mental Notes"!

- **Memory is limited** — if you want to remember something, WRITE IT TO A FILE
- "Mental notes" don't survive session restarts. Files do.
- When someone says "remember this" → update `memory/YYYY-MM-DD.md` or relevant file
- When you learn a lesson → update AGENTS.md, TOOLS.md, or the relevant skill
- When you make a mistake → document it so future-you doesn't repeat it
- **Text > Brain** 
```
---
AGENTD.md (cont)
```
## Red Lines

- Don't exfiltrate private data. Ever.
- Don't run destructive commands without asking.
- `trash` > `rm` (recoverable beats gone forever)
- When in doubt, ask.

```
---
AGENTD.md (cont)
```

## External vs Internal

**Safe to do freely:**

- Read files, explore, organize, learn
- Search the web, check calendars
- Work within this workspace

**Ask first:**

- Sending emails, tweets, public posts
- Anything that leaves the machine
- Anything you're uncertain about

```
---

## IDENTITY.md — La personalidad del agente

**Propósito:** Define quién es el agente (nombre, vibe, emoji) 

https://docs.openclaw.ai/reference/templates/IDENTITY

**Ejemplo:**
```markdown
# Identidad del Agente

**Nombre:** Alex
**Empresa:** TechCorp
**Rol:** Recepcionista virtual
**Tono:** Amable, profesional, conciso
**Restricciones:** No compartir info sensible, derivar ventas al equipo comercial
```

<!-- **Papel:** Crea consistencia en todas las interacciones. -->

---

## SOUL.md — El corazón del agente

**Propósito:** Contiene el System Prompt que guía todas las respuestas.

Define la persona, el tono y los límites

https://docs.openclaw.ai/reference/templates/SOUL

**Ejemplo:**
```markdown
Eres Alex, recepcionista de TechCorp.
Horario: L-V 9:00-18:00
Teléfono: 900 123 456
Sé amable pero directo. Máximo 3 frases por respuesta.
Si preguntan precios, deriva a ventas.
```

**Papel:** Define la "alma" — qué sabe y cómo responde el agente.

Guía de personalidad: https://docs.openclaw.ai/concepts/soul

--- 

## Ejercicio: Jugando con la pesonalidad del agente

Cambia la configuración del fichero SOUL.md para reflejar estas 2 personalidades:
* Eres un experto desarrollador de software, con altos conocimientos de IA. No tengas problemas en explicar conceptos de arquitectura de software utilizando términos complejos.
* Eres un profesor de informática de instituto. Cualquier concepto complejo de informática, deberás explicarlo con metáforas y adaptado a gente sin muchos conocimientos técnicos.

**Probar a pedirle en ambos casos que te de información sobre los LLMS**

---

## Ejercicio: Canal-aware soul

Modificar `SOUL.md` para que el agente adapte su comportamiento según el canal desde el que se le habla.

Edita tu `SOUL.md` e incluye instrucciones distintas para cada canal:

```markdown
## Comportamiento por canal

- Si el usuario escribe desde **Telegram**: responde de forma
  concisa, usa emojis y limita las respuestas a 2-3 frases.
- Si el usuario escribe desde **Discord**: puedes ser más
  detallado, usa bloques de código y listas cuando sea útil.
```

Luego prueba enviando el mismo mensaje desde ambos canales y observa la diferencia.

---

## Preguntas para reflexionar

- ¿Respeta el agente las instrucciones del canal de forma consistente?
- ¿Qué pasa si no especificas el canal en el `SOUL.md`?
- ¿Podrías hacer lo mismo para distinguir usuarios o roles?

---
## TOOLS.md — Las habilidades del agente

**Propósito:** Lista las herramientas y APIs que el agente puede usar.

![left](img/openclaw/tools.png)

**Papel:** Extiende capacidades del agente más allá del texto.

---

## USER.md — Contexto del usuario

**Propósito:** Información específica del usuario actual para personalización.

**Ejemplo:**
```markdown
# Usuario: Juan Pérez

**Preferencias:**
- Idioma: Español
- Canal favorito: Telegram
- Temas de interés: ERP, CRM

**Historial reciente:**
- Consultó precios de software
- Interesado en demo técnica
```

**Papel:** Hace interacciones más relevantes y personalizadas.

---

## BOOTSTRAP.md y HEARTBEAT.md

**BOOTSTRAP.md:**
- Instrucciones para inicializar el agente
- Configuraciones iniciales, dependencias

**Ejemplo:**
```markdown
# Inicialización
1. Verificar conexión a APIs
2. Cargar modelos de IA
3. Iniciar canales de comunicación
```
---

**HEARTBEAT.md:**
- Estado de salud del sistema
- Métricas de rendimiento

**Ejemplo:**
```markdown
# Estado del sistema
- Uptime: 99.9%
- Respuestas por hora: 150
- Errores: 0.1%
```

**Papel:** Aseguran estabilidad y monitoreo operativo.

---

# Skills

---

# Bloque 1

## 🏗️ Arquitectura de una Skill

*¿Cómo decide el agente cuándo usar una herramienta?*

---

## El problema del LLM sin herramientas

```
Usuario: ¿Cuánto vale el Bitcoin ahora mismo?

Agente (sin Skills):
  "El precio actual del Bitcoin es aproximadamente $45,000."
  ← ❌ INVENTADO. El LLM no tiene acceso a datos en tiempo real.
```

Sin herramientas el agente solo puede:
- Recordar lo que vio en el entrenamiento (datos desactualizados)
- **Alucinar** datos que no conoce

---

## La solución: Skills / Tools

Una **Skill** (también llamada *Tool* o *Function*) es una función de código que:

1. El desarrollador **define y registra** en OpenClaw
2. El LLM **decide autónomamente** cuándo llamarla
3. OpenClaw **ejecuta** el código y devuelve el resultado al LLM
4. El LLM **responde** al usuario con datos reales

> 🧠 El LLM no ejecuta código. Solo decide *qué herramienta usar* y *con qué argumentos*.

---

## El ciclo completo de una Skill

```
Usuario: "¿Cómo está el tiempo en Zaragoza?"
         │
         ▼
┌─────────────────────┐
│  LLM analiza        │  "El usuario quiere el tiempo.
│  la intención       │   Tengo disponible 'get_weather'.
└────────┬────────────┘   Voy a llamarla con city='Zaragoza'."
         │
         ▼
┌─────────────────────┐
│  OpenClaw ejecuta   │  → llama a la API meteorológica
│  get_weather()      │  ← recibe { temp: 18, desc: "Nublado" }
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  LLM formula        │  "En Zaragoza ahora mismo hay 18°C
│  la respuesta       │   y está nublado. ¡Lleva paraguas!"
└─────────────────────┘
```
---

AQUI NOS QUEDAMOS

<!-- 
Prueba:
- Pedimos info
- Analizamos el tool output
- Deshabilitamos la tool de websearch
- Volvemos a pedir (ojo tiene memoria!!)
- Nueva sesión
- Si tiene tools de exec, las utiliza y si no, las de session...



-->


---

## Anatomía de una Skill en OpenClaw

workspace/skills/my_skill/SKILL.md

```
---
name: hello_world
description: A simple skill that says hello.
---

# Hello World Skill

When the user asks for a greeting, use the `echo` tool to say
"Hello from your custom skill!".
```

**La `description` es crítica**: el LLM la lee para decidir si usar esta Skill.

---

## Los tres elementos que el LLM necesita

| Elemento | Para qué sirve | Ejemplo |
|----------|---------------|---------|
| `name` | Identificar la skill | `get_weather` |
| `description` | Decidir *cuándo* usarla | `"Consulta el tiempo actual..."` |
| `metadata` | Datos extra (herramientas, parámetros) | `...` |

> ✍️ **Escribe la `description` como si fuera para un humano.**
> El LLM no infiere: necesita instrucciones claras.


--- 
## Metadatos

Opciones adicionales de nuestra skill

```
metadata:
  {
    "openclaw":
      {
        "requires": { "bins": ["uv"], "env": ["GEMINI_API_KEY"], "config": ["browser.enabled"] },
        "primaryEnv": "GEMINI_API_KEY",
      },
  }
```

---

## ¿Cuándo llama el LLM a una Skill?

El LLM hace **Function Calling** cuando:

1. El mensaje del usuario **encaja** con la descripción de la Skill
2. El LLM tiene todos los **parámetros necesarios** (o puede pedirlos)
3. La Skill es la opción **más adecuada** entre las disponibles

```
"¿Qué temperatura hace en Madrid?" → ✅ llama a get_weather(city="Madrid")
"¿Cuánto es 2 + 2?"               → ❌ no llama a get_weather
"Cuéntame un chiste"               → ❌ no llama a ninguna Skill
```

--- 
## Nuestra primera skill

```
---
name: lista_compra
description: Skill para gestionar la lista de la compra del usuario
---

# Lista de la compra Skill

Gestionas la lista de la compra en un fichero lista_compra.md. Si no existe deberás crearlo.

Si el usuario pregunta por los elementos de la lista, lee el fichero y muestralo.

Cada vez que el usuario añada un elemento, añadirás el elemento como una lista de elementos check (- [ ]  elemento).

Si el usuario te dice que ha comprado un elemento de la lista, deberás marcarlo como hecho (- [x] elemento).

Si el usuario te dice que borres un elemento de la lista, elimina esa línea.
```

---

## Revisar si está instalado

```yaml
openclaw skills list

│               │                       │ normal user chats).                                                                                      │                    │
│ ✓ ready       │ ☔ weather            │ Get current weather and forecasts via wttr.in or Open-Meteo. Use when: user asks about weather,          │ openclaw-bundled   │
│               │                       │ temperature, or forecasts for any location. NOT for: historical weather data, severe weather alerts, or  │                    │
│               │                       │ detailed meteorological analysis. No API key needed.                                                     │                    │
│ △ needs setup │ 🐦 xurl               │ A CLI tool for making authenticated requests to the X (Twitter) API. Use this skill when you need to     │ openclaw-bundled   │
│               │                       │ post tweets, reply, quote, search, read posts, manage followers, send DMs, upload media, or interact     │                    │
│               │                       │ with any X API v2 endpoint.                                                                              │                    │
│ ✓ ready       │ 📦 lista_compra       │ Skill para gestionar la lista de la compra del usuario                                                   │ openclaw-workspace │
│ ⏸ disabled   │ 📦 priceforagent      │ Get real-time prices for crypto, stocks, and commodities. Use when the user asks about asset prices,     │ openclaw-workspace │
│               │                       │ market data, or needs to check the value of Bitcoin, Ethereum, stocks like NVDA/AAPL, or commodities     │                    │
│               │                       │ like gold/silver. Supports natural language queries ("What's the price of Bitcoin?") and direct lookups. │                    │
└───────────────┴───────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────┴────────────────────┘

Tip: use `openclaw skills search`, `openclaw skills install`, and `openclaw skills update` for ClawHub-backed skills.
```
---

## El poder de una buena `description`

Comparación entre descripciones ❌ malas y ✅ buenas:

```
❌ description: "Obtiene el clima."

✅ description: "Consulta el tiempo meteorológico actual de cualquier
                ciudad. Úsala cuando el usuario pregunte por la
                temperatura, el clima o el tiempo que hace en un lugar."
```

```
❌ description: "Bitcoin price."

✅ description: "Obtiene el precio actual del Bitcoin en tiempo real.
                Úsala cuando el usuario pregunte por el precio, valor
                o cotización del Bitcoin o BTC."
```

> La descripción responde a: **¿cuándo** debe el LLM usar esta Skill?

## 📝 Skill de Escritura — Acción corporativa

*El agente que capta y registra leads de forma autónoma*

---

## El caso de uso

```
Usuario (Telegram):
  "Hola, me interesa mucho vuestro software de gestión.
   Mi nombre es Laura y podéis contactarme en laura@empresa.es"

Bot (sin Skill de escritura):
  "¡Gracias por tu interés, Laura! ¿En qué más puedo ayudarte?"
  ← La lead se pierde. No hay rastro.

Bot (con Skill de escritura):
  "¡Gracias, Laura! He registrado tus datos en nuestro sistema.
   El equipo comercial se pondrá en contacto contigo pronto. 🎉"
  ← La lead queda guardada. El equipo comercial la ve.
```

---

## Arquitectura: Extracción + Acción

El LLM hace **dos cosas** de forma autónoma:

```
Mensaje: "Me interesa comprar, mi email es hola@test.com"
          │
          ▼
    [LLM extrae datos]
      nombre: (no indicado → preguntar)
      email: hola@test.com
      interés: compra
          │
          ▼
    [Llama a register_lead(email, nombre, interes)]
          │
          ▼
    [Guarda en CSV / Google Sheets]
          │
          ▼
    [LLM confirma al usuario]
```

---

## Skill: Registrar Lead en CSV

---

## El System Prompt define el comportamiento

Para que el agente actúe como un captador de leads, ajusta el System Prompt:

```yaml
system_prompt: |
  Eres el asistente comercial de TechCorp.
  Tu objetivo principal es ayudar a los visitantes y captar leads.

  Cuando alguien muestre interés en los productos:
  1. Pregunta su nombre si no lo has indicado.
  2. Pregunta su email de contacto.
  3. Usa la skill 'register_lead' para guardar sus datos.
  4. Confirma al usuario que el equipo comercial le contactará.

  Nunca inventes precios ni hagas promesas específicas de descuentos.
```

---

## Resumen de la sesión

✅ Entendemos el ciclo de Function Calling: usuario → LLM → Skill → respuesta

✅ Creamos una Skill de Lectura que consulta datos en tiempo real (Bitcoin / clima)

✅ Creamos una Skill de Escritura que registra leads de forma autónoma

✅ Aprendemos a escribir buenas `descriptions` para guiar al LLM

✅ El bot de Telegram ya puede **actuar en el mundo real**

---

## Próxima sesión: MCP 🔗

> *"Las Skills sirven para acciones puntuales. ¿Y si el agente necesita leer toda la base de datos de la empresa?"*

En la **Sesión 3** aprenderemos el estándar **Model Context Protocol (MCP)**:

- 📦 Conectar el agente a bases de datos SQLite
- 📄 Dar acceso a documentos internos (PDFs, Markdown)
- 🔐 Compartir contexto corporativo de forma segura y controlada

---

## Referencias y recursos

- 📖 OpenAI Function Calling: `platform.openai.com/docs/guides/function-calling`
- 🌤️ OpenWeatherMap API: `openweathermap.org/api` (free tier disponible)
- ₿ CoinGecko API: `docs.coingecko.com` (sin API key para endpoints básicos)
- 📊 gspread (Google Sheets): `docs.gspread.org`
- 📐 Guía de Tool Use — Anthropic: `docs.anthropic.com/tool-use`