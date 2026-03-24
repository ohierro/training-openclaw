---
marp: true
theme: default
paginate: true
---

# Sesión 1
## Fundamentos, Instalación y Primer Despliegue

> *El nacimiento del agente*

---

## 🗺️ Agenda

| Bloque | Tema | Tiempo |
|--------|------|--------|
| 🧠 1 | Presentación, teoría y Setup | 40 min |
|    | Descanso | 20 min |
| 💻 2 | Hola Mundo en Consola | 40 min |
|    | Descanso | 20 min |
| 📱 3 | Despliegue en Discord | 30 min |
| 🖊️ 4 | Ejemplos prácticos | 15 min |
| ❔  | Preguntas | 15 min |

**Objetivo:** Pasar de cero a tener un agente conversacional en producción.

---

# Bloque 1
## 🧠 Teoría y Setup

*¿Qué es OpenClaw y por qué existe?*

---

## ¿Qué es un LLM?

Un **Large Language Model** (LLM) es un modelo de lenguaje entrenado con grandes cantidades de texto que puede:

- Responder preguntas
- Generar texto
- Resumir documentos
- Traducir idiomas
- Generar video
...

> ⚠️ **Pero un LLM solo no puede hacer nada en el mundo real.**
> No tiene memoria, no puede llamar a APIs, no puede actuar.

---

## LLM vs. Agente Inteligente

|  | LLM puro | Agente (OpenClaw) |
|--|----------|-------------------|
| Memoria | ❌ Sin memoria entre sesiones | ✅ Historial persistente |
| Acciones | ❌ Solo genera texto | ✅ Ejecuta Skills/Tools |
| Integración | ❌ API sin estado | ✅ Telegram, Slack, Web... |
| Contexto | ❌ Prompt manual | ✅ MCP / RAG automático |
| Orquestación | ❌ Un solo modelo | ✅ Multi-agente |


---
## ¿Qué es OpenClaw?

---
![bg left](img/openclaw/openclaw.png)

**OpenClaw** es un framework open source para construir agentes conversacionales que

- 🔌 Se conecta a **múltiples canales** (Telegram, web, terminal...)
- 🛠️ Ejecutan **Skills personalizadas** (APIs, bases de datos, scripts)
- 🧠 Mantienen **memoria** de la conversación
- 🤖 Admiten **múltiples modelos** (OpenAI, Anthropic, modelos locales)

<!--
**OpenClaw** es un framework open source para construir agentes conversacionales que

Además, soporta MCP

-->

---


![bg](img/architecture.jpg)


---

## Instalación

![alt text](img/openclaw/demo.png)

---

## Posibilidades de instalación

| Opción | Seguridad | Facilidad | Coste | Mantenimiento | Escalabilidad |
|---|---:|---:|---:|---:|---:|
| **VPS** | ⭐⭐⭐⭐☆ | ⭐⭐☆☆☆ | ⭐⭐☆☆☆ | ⭐⭐☆☆☆ | ⭐⭐⭐⭐⭐ |
| **Local + Docker** | ⭐⭐⭐⭐☆ | ⭐⭐⭐⭐☆ | ⭐⭐⭐⭐☆ | ⭐⭐⭐☆☆ | ⭐⭐⭐☆☆ |
| **Local nativo** | ⭐⭐☆☆☆ | ⭐⭐⭐☆☆ | ⭐⭐⭐⭐⭐ | ⭐⭐☆☆☆ | ⭐⭐☆☆☆ |

<!-- 
**VPS**  
Ventajas: Disponible 24/7, acceso remoto, ideal para demos/prod  
Inconvenientes: Requiere administración de servidor y monitorización  

**Local + Docker**  
Ventajas: Setup reproducible, dependencias controladas, fácil de compartir  
Inconvenientes: Consumo local de recursos, depende del equipo del alumno  

**Local nativo**  
Ventajas: Arranque rápido para pruebas simples, menos capas  
Inconvenientes: "Funciona en mi máquina", conflictos de versiones y más mantenimiento  
-->

**Lectura rápida**
- **VPS:** mejor para producción y acceso remoto 24/7
- **Local + Docker:** mejor equilibrio para formación y demos controladas
- **Local nativo:** útil para pruebas rápidas, menos recomendable para equipos

---

## Local + docker

+ VirtualBox

---

## Variables de entorno

Crear el fichero `.env` en la raíz del proyecto

**Importante: Debes establecer el TimeZone (OPENCLAW_TZ) adecuado para evitar problemas con la aplicación web**


> 💡 **Nunca subas el `.env` a Git.** Está en el `.gitignore` por defecto.

---

## Go live!

---

# Primeros pasos

## Acceso básico

* Arquitectura final (MI PC > Virtual Box > Docker > OpenClaw)
* Acceso a los contenedores
* Acceso a TUI (*Terminal User Interface*)
---
## Acceso básicos

Comandos habituales:
Lanzar comandos: `docker compose run -it openclaw-cli <COMANDO>`

Conectar con la máquina: `docker compose exec -it openclaw-gateway bash`

---

## Acceso básico

SSH Tunneling: https://iximiuz.com/en/posts/ssh-tunnels/

![alt text](img/ssh/ssh-tunnels.png)

---

## TUI

* Qué es? 
* Primera conversación (definiendo SOUL.MD e IDENTITY.md)

## Web

* Cómo abro el panel?
* Problema con el timezone del docker (está en UTC)

Peticiones pendientes: `openclaw devices approve`
---

---

## ¿Qué es una sesión en OpenClaw?

Una **sesión** es una conversación continua entre un usuario y el agente:

- 🔄 **Estado persistente:** El agente recuerda el contexto a lo largo de la interacción
- 📝 **Historial completo:** Todos los mensajes previos se incluyen en cada petición al LLM
- 🆔 **Identificador único:** Cada sesión tiene un ID para rastrear y gestionar
- ⏰ **Tiempo de vida:** Las sesiones pueden expirar o reiniciarse según configuración

> 💡 **Sin sesiones, cada mensaje sería independiente — como un LLM básico.**

---

## Gestión de sesiones

OpenClaw gestiona las sesiones automáticamente:

| Aspecto | Cómo funciona |
|---------|---------------|
| **Creación** | Primera interacción inicia una nueva sesión |
| **Persistencia** | Historial guardado en base de datos o memoria |
| **Expiración** | Configurable (ej: 24h inactivas) |
| **Reinicio** | Comando `/reiniciar` o manual en web |
| **Multi-usuario** | Sesiones separadas por canal/usuario |

**Ejemplo de configuración en `agent.yaml`:**
```yaml
sessions:
  max_age: 86400  # 24 horas en segundos
  storage: "memory"  # o "database"
```

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

## Modelos

---

## ¿Qué son los modelos en OpenClaw?

Los **modelos** son los **Large Language Models (LLMs)** que impulsan la inteligencia del agente:

- 🤖 **Proveedores principales:** OpenAI (GPT), Anthropic (Claude), Google (Gemini), Meta (Llama)
- 🏠 **Modelos locales:** Ollama, LM Studio (para privacidad o sin internet)
- 🔧 **Configuración:** Se definen en `agent.yaml` con API keys y parámetros

**Ejemplo básico:**
```yaml
model:
  provider: openai
  model: gpt-4
  api_key: "${OPENAI_API_KEY}"
```

> 💡 **El modelo es el "cerebro" — determina calidad, velocidad y capacidades del agente.**

---

## Por qué elegir un buen modelo

Un buen modelo impacta directamente en la experiencia del usuario:

| Aspecto | Importancia |
|---------|-------------|
| **Calidad de respuesta** | Comprensión precisa, respuestas coherentes |
| **Velocidad** | Tiempo de respuesta (crucial para chat en tiempo real) |
| **Costo** | Tokens consumidos vs. presupuesto |
| **Capacidades** | Razonamiento, creatividad, manejo de contexto largo |
| **Fiabilidad** | Disponibilidad y estabilidad del servicio |

**Ejemplo comparativo:**
- GPT-3.5: Rápido y barato, pero limitado en complejidad
- GPT-4: Más inteligente, pero más caro y lento
- Claude: Excelente en ética y seguridad

---

## La importancia del fallback

**¿Por qué un fallback?** Porque ningún proveedor es infalible:

- 🚨 **Downtime:** OpenAI ha tenido outages (ej: incidentes de 2023-2024)
- 📈 **Límites de rate:** Cuotas diarias/mensuales pueden agotarse
- 💰 **Costos variables:** Cambios en pricing sin aviso
- 🌍 **Regulaciones:** Restricciones geográficas o compliance
- 🔄 **Diversidad:** Diferentes modelos para diferentes tareas

> ⚠️ **Sin fallback, tu agente queda "mudo" si el proveedor principal falla.**

---

## Configuración de fallback en OpenClaw

OpenClaw soporta **múltiples modelos con fallback automático:**

```yaml
 "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/minimax/minimax-m2.5:free"
      },
      "models": {
        "minimax/MiniMax-M2.5": {},
        "minimax/MiniMax-M2.5-highspeed": {},
        "openrouter/auto": {
          "alias": "OpenRouter"
        },
        "openrouter/minimax/minimax-m2.5:free": {}
      },
      "workspace": "/home/node/.openclaw/workspace"
    },
    "list": [
      {
        "id": "main",
        "model": {
          "primary": "openrouter/minimax/minimax-m2.5:free",
          "fallbacks": [
            "minimax/MiniMax-M2.5-highspeed"
          ]
        }
      }
    ]
  },


```

**Cómo funciona:**
1. Intenta el modelo primary
2. Si falla (error, rate limit), pasa al fallbacks (en orden)
3. Transición transparente para el usuario

---

## Modelos recomendados para empezar

| Modelo | Proveedor | Ventajas | Desventajas | Costo aproximado |
|--------|-----------|----------|-------------|------------------|
| **GPT-4** | OpenAI | Inteligente, versátil | Caro, rate limits | $0.03/1K tokens |
| **Claude 3** | Anthropic | Ético, creativo | Menos herramientas | $0.015/1K tokens |
| **Gemini Pro** | Google | Gratuito para pruebas | Menos maduro | $0.001/1K tokens |
| **Llama 2 7B** | Meta (local) | Privado, sin costo | Requiere hardware | $0 (una vez descargado) |

**Recomendación inicial:**
- **Producción:** GPT-4 + Claude como fallback
- **Desarrollo:** Gemini o local para ahorrar costos
- **Privacidad:** Siempre incluir opción local

---

## Mejores prácticas con modelos

- 🔄 **Monitorea uso:** Tokens consumidos, latencia, errores
- 💸 **Presupuesto:** Establece límites para evitar sorpresas
- 🧪 **Testea:** Prueba prompts en diferentes modelos
- 🔄 **Actualiza:** Nuevos modelos salen regularmente
- 🌐 **Multi-región:** Usa proveedores con datacenters cercanos

**Comando útil:**
```bash
# Ver métricas de uso
openclaw models status
```

---

## Estructura de archivos
* Qué ficheros son relevantes? 
  * openclaw.json
  * workspace/

## Contexto

AGENTS.md  BOOTSTRAP.md  HEARTBEAT.md  IDENTITY.md  SOUL.md  TOOLS.md  USER.md

---

## El Workspace: el cerebro del agente

El **workspace** es el directorio central donde OpenClaw almacena toda la configuración y contexto del agente:

- 📁 **Ubicación:** Por defecto en `~/.openclaw/workspace/` (o configurable)
- 📝 **Formato:** Archivos Markdown simples y editables
- 🔄 **Lectura dinámica:** Se lee **cada vez que arranca una conversación**
- 🛠️ **Personalización:** Modifica archivos sin reiniciar el sistema

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

**Ventajas de usar Markdown para configuración:**

- ✏️ **Fácil edición:** Cualquier editor de texto basta
- 👥 **Colaborativo:** Versionable con Git, editable por no-técnicos
- 📖 **Legible:** Formato humano-friendly
- 🔧 **Flexible:** Soporta texto, listas, tablas, código
- 🤖 **Parseable:** OpenClaw lo convierte automáticamente a configuración

**Ejemplo de edición en tiempo real:**
```bash
# Editar personalidad del agente
nano ~/.openclaw/workspace/IDENTITY.md

# El cambio se aplica en la siguiente conversación
# ¡Sin reiniciar servicios!
```

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

**Ejemplo — lista de la compra:**
```
Usuario: Añade leche a mi lista de la compra

→ El agente actualiza workspace/lista_compra.md:
  - [x] Pan
  - [ ] Leche   ← añadido ahora
  - [ ] Huevos
```

> 💡 **El workspace es la "memoria en disco" del agente — lee al arrancar, escribe cuando necesita recordar.**

---

## Los archivos clave en OpenClaw

OpenClaw usa archivos Markdown en el directorio `workspace/` para definir el comportamiento y contexto del agente. Cada archivo tiene un propósito específico:

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

---

## AGENTS.md — Definición de agentes

**Propósito:** Especifica qué agentes existen y sus configuraciones.

**Ejemplo:**
```markdown
# Agentes disponibles

## Recepcionista
- Modelo: GPT-4
- Canales: Telegram, Web
- Rol: Atención al cliente

## Asistente Técnico  
- Modelo: Claude-3
- Canales: Slack, Email
- Rol: Soporte técnico
```

**Papel:** Permite tener múltiples agentes especializados en un solo sistema.

---

## IDENTITY.md — La personalidad del agente

**Propósito:** Define quién es el agente y cómo se comporta.

**Ejemplo:**
```markdown
# Identidad del Agente

**Nombre:** Alex
**Empresa:** TechCorp
**Rol:** Recepcionista virtual
**Tono:** Amable, profesional, conciso
**Restricciones:** No compartir info sensible, derivar ventas al equipo comercial
```

**Papel:** Crea consistencia en todas las interacciones.

---

## SOUL.md — El corazón del agente

**Propósito:** Contiene el System Prompt que guía todas las respuestas.

**Ejemplo:**
```markdown
Eres Alex, recepcionista de TechCorp.
Horario: L-V 9:00-18:00
Teléfono: 900 123 456
Sé amable pero directo. Máximo 3 frases por respuesta.
Si preguntan precios, deriva a ventas.
```

**Papel:** Define la "alma" — qué sabe y cómo responde el agente.

---

## TOOLS.md — Las habilidades del agente

**Propósito:** Lista las herramientas y APIs que el agente puede usar.

**Ejemplo:**
```markdown
# Herramientas disponibles

## Consultar clima
- Comando: weather_api
- Parámetros: ciudad
- Descripción: Obtiene pronóstico del tiempo

## Enviar email
- Comando: send_email
- Parámetros: destinatario, asunto, cuerpo
- Descripción: Envía correos corporativos
```

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

## Primer canal  💻 Hola Mundo en Consola

![alt text](img/openclaw/first_run.png)

---

## El archivo de configuración

OpenClaw se configura con un fichero `agent.json`, pero también podemos editar la configuración mediante:
* `openclaw configure`
* Web

---

## El System Prompt: el alma del agente

El **System Prompt** es la instrucción base que define la *identidad* del agente:

```
Eres el recepcionista de TechCorp.
Tu nombre es Alex.
Responde siempre en español.
Sé conciso: máximo 3 frases por respuesta.

Información que conoces:
- Horario: Lunes a Viernes, 9:00 - 18:00
- Teléfono de soporte: 900 123 456
- Email: hola@techcorp.es
```

> 🎯 Un buen System Prompt hace el 80% del trabajo.
> Define **quién es**, **qué sabe** y **cómo debe responder**.

---

## Anatomía de un buen System Prompt

```
[ROL] Eres X, trabajas para Y.
[COMPORTAMIENTO] Eres amable / técnico / formal...
[RESTRICCIONES] No hagas A, no compartas B.
[CONOCIMIENTO] Información relevante del dominio.
[FORMATO] Responde en bullets / máx N palabras / en idioma X.
```

**Ejemplo de restricciones útiles:**
- "Si te preguntan por precios, deriva al equipo comercial."
- "No inventes información. Si no sabes, dilo."
- "No respondas sobre temas que no sean de TechCorp."

---

## La memoria de la conversación

OpenClaw mantiene el **historial** de la sesión automáticamente:

```
Tú: Me llamo Carlos.
Alex: ¡Encantado, Carlos! ¿En qué puedo ayudarte?

Tú: ¿Recuerdas cómo me llamo?
Alex: Claro, te llamas Carlos. ¿Hay algo más en lo que pueda ayudarte?
```

Esto es posible porque cada mensaje incluye el historial previo al LLM:

```
[system] Eres el recepcionista de TechCorp...
[user]   Me llamo Carlos.
[assistant] ¡Encantado, Carlos!...
[user]   ¿Recuerdas cómo me llamo?   ← el LLM "ve" todo lo anterior
```



## 🧪 Ejercicio 1 — Hola Mundo

1. Crea tu `agent.yaml` con el System Prompt del recepcionista
2. Personaliza la empresa con un nombre ficticio tuyo
3. Inicia el agente en consola
4. Comprueba que recuerda tu nombre entre turnos
5. Prueba a preguntarle algo que *no debería saber*: ¿cómo responde?

**Objetivo:** Sentir la diferencia entre un LLM genérico y un agente con identidad propia.

---

# Bloque 3
## 📱 Despliegue en Telegram

*Del terminal al mundo real en 15 minutos*

---

## ¿Por qué Telegram?

- ✅ API de bots **gratuita y estable**
- ✅ No requiere servidor web ni HTTPS para empezar (long polling)
- ✅ OpenClaw tiene integración **nativa** — sin código extra
- ✅ Los alumnos pueden probarlo desde su **móvil** en tiempo real
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

```yaml
# agent.yaml
name: recepcionista
# ... resto de configuración ...

channels:
  telegram:
    enabled: true
    token: "${TELEGRAM_BOT_TOKEN}"   # leer del .env
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

## Comandos útiles del bot

Puedes definir **comandos Telegram** en el `agent.yaml`:

```yaml
channels:
  telegram:
    enabled: true
    token: "${TELEGRAM_BOT_TOKEN}"
    commands:
      - command: start
        description: Iniciar conversación
      - command: ayuda
        description: Ver qué puedo hacer
      - command: reiniciar
        description: Borrar historial y empezar de nuevo
```

---

## 🧪 Ejercicio 2 — Bot en Discord

> *En pairing — un alumno comparte pantalla*

**Paso 1: Crear la aplicación en Discord Developer Portal**
1. Ve a [discord.com/developers/applications](https://discord.com/developers/applications)
2. Clic en **New Application** → ponle un nombre (ej: `TechCorp Bot`)
3. Ve a la sección **Bot** → clic en **Add Bot**
4. En **Token**, clic en **Reset Token** y cópialo

**Paso 2: Obtener el Guild ID (servidor)**
1. Activa el **Modo Desarrollador** en Discord (Ajustes → Avanzado)
2. Click derecho sobre tu servidor → **Copiar ID del servidor**

---

## 🧪 Ejercicio 2 — Bot en Discord (cont.)

**Paso 3: Configurar OpenClaw**

En `.env`:
```bash
DISCORD_BOT_TOKEN=tu_token_aquí
DISCORD_GUILD_ID=tu_guild_id_aquí
```

**Paso 4: Invitar el bot al servidor**
1. En el portal, ve a **OAuth2 → URL Generator**
2. Scopes: `bot` · Permissions: `Send Messages`, `Read Message History`
3. Copia la URL generada y ábrela para invitar el bot

**Paso 5: Arrancar y probar**
- Inicia OpenClaw y escribe en el canal del servidor
- Comparte el servidor con un compañero para que lo pruebe

**Bonus:** Cambia `SOUL.md` para que el bot se presente con tu empresa ficticia.

---

## Ejercicio 3 - La lista de la compra

--- 

## Ejercicio 4 - Resumen de documentos

---

## Ejercicio 5 - Cron jobs

---

## Resumen de la sesión

✅ Entendemos la diferencia entre LLM puro y agente inteligente

✅ Sabemos instalar y configurar OpenClaw

✅ Creamos un System Prompt efectivo con identidad y restricciones

✅ El agente mantiene memoria de la conversación

✅ El bot está desplegado y funcional en Telegram

---

## Próxima sesión: Skills 🛠️

> *"El agente ya sabe hablar... ahora le damos manos."*

En la **Sesión 2** aprenderemos a crear **Skills** (herramientas) para que el agente:

- 🌐 Consulte APIs en tiempo real (clima, precios, datos...)
- 📝 Registre leads en una hoja de cálculo
- ⚡ Ejecute acciones en el mundo real de forma autónoma

---

## Referencias y recursos

- 📖 Documentación oficial de OpenClaw: `github.com/tu-org/openclaw`
- 🤖 API de Telegram Bots: `core.telegram.org/bots/api`
- 🔑 OpenAI API Keys: `platform.openai.com/api-keys`
- 🔑 Anthropic API Keys: `console.anthropic.com`
- 🦙 Ollama (modelos locales): `ollama.ai`
- 📐 Guía de System Prompts: *"The Art of the System Prompt"* — Anthropic Blog