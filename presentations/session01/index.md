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
| 📱 3 | Acceso al panel web y TUI | 30 min |
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
Además, soporta MCP, Hooks... etc
-->

---

## Peter Steinberger — El Clawdfather

📍 Viena ↔ Londres · [@steipete](https://x.com/steipete)

- 🏢 **2011–2021:** Fundó **PSPDFKit**, el SDK de PDF líder para iOS/Android
  — bootstrapped hasta millones en ARR, exit en 2021 ($116M ronda de financiación)
- 📱 **13+ años** desarrollando apps nativas iOS: conocido por *Aspects* (AOP en Objective-C, 10k+ ⭐) e *InterposeKit*
- 🔬 Contribuidor activo en la comunidad open source; ponente internacional sobre AI y desarrollo ágil
- 🤖 **2024:** Volvió del retiro para **"mess with AI"** — y creó OpenClaw

> *"Ship beats perfect"* — su filosofía de siempre

---

## De PSPDFKit a OpenClaw: el salto a los agentes

Tras el exit de PSPDFKit, Peter exploró el ecosistema AI y detectó un hueco:

> *"Todos los LLMs generan texto — nadie construía agentes que realmente actuasen"*

---

## De PSPDFKit a OpenClaw: el salto a los agentes

- 🛠️ Empezó construyendo **herramientas para sí mismo**: CLIs, MCPs, automatizaciones
  — más de 50 repos públicos en un año (*Peekaboo*, *VibeTunnel*, *Terminator MCP*...)
- 🦞 Nació **OpenClaw**: el agente que *"actually does things"*
  — identidad via Markdown, memoria persistente, skills, canales, multi-modelo
- 🌍 Proyecto **open source** desde el primer día, con comunidad de sponsors activa
- 📣 Divulga su workflow AI en [steipete.me](https://steipete.me) y conferencias internacionales

> 💡 *El nombre «Clawdfather» en su GitHub lo dice todo.*




---


![bg](img/architecture.jpg)


<!-- ---

## Instalación

![alt text](img/openclaw/demo.png) -->

---

## Posibilidades de instalación

| | **VPS** | **Local + Docker** | **Local nativo** |
|---|:---:|:---:|:---:|
| **Seguridad** | ⭐⭐⭐⭐☆ | ⭐⭐⭐⭐☆ | ⭐⭐☆☆☆ |
| **Facilidad** | ⭐⭐☆☆☆ | ⭐⭐⭐☆☆ | ⭐⭐⭐⭐☆ |
| **Coste** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐☆☆ | ⭐⭐⭐☆☆ |
| **Mantenimiento** | ⭐⭐☆☆☆ | ⭐⭐⭐☆☆ | ⭐⭐☆☆☆ |
| **Escalabilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐☆☆ | ⭐⭐☆☆☆ |

---

## Posibilidades de instalación

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

## Conceptos básicos
* Modelos
* Sesiones
* Canales

---

# Modelos

---

## ¿Qué son los modelos en OpenClaw?

Los **modelos** son los **Large Language Models (LLMs)** que impulsan la inteligencia del agente:

- 🤖 **Proveedores principales:** OpenAI (GPT), Anthropic (Claude), Google (Gemini), Meta (Llama)
- 🏠 **Modelos locales:** Ollama, LM Studio (para privacidad o sin internet)
- 🔧 **Configuración:** Se definen en `openclaw.json` con API keys y parámetros en lugar seguro

---

**Ejemplo básico:**
```json
"model": {
  "primary": "openrouter/minimax/minimax-m2.5:free"
}
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
 
---

**Ejemplo comparativo:**
- GPT-3.5: Rápido y barato, pero limitado en complejidad
- GPT-4: Más inteligente, pero más caro y lento
- Claude: Excelente en ética y seguridad
- Gemini, Minimax, Qwen...

---

## Múltiples modelos

OpenClaw nos va a permitir configurar múltiples modelos, incluso nos permitirá asignar modelos por canal, sesión, tarea...etc



> 💡 **Es importante configurar siempre, al menos, un modelo de fallback.**
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

# Sesiones 

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

---

# Canales

---

## ¿Qué son los canales en OpenClaw?

Un **canal** es la vía por la que los usuarios se comunican con el agente:

- 💬 **Entrada:** Recibe los mensajes del usuario (texto, comandos, eventos)
- 🤖 **Procesamiento:** El agente genera la respuesta
- 📤 **Salida:** Devuelve la respuesta por el mismo canal

---

**Canales soportados:**

| Canal | Tipo | Caso de uso |
|-------|------|-------------|
| **Terminal (TUI)** | Local | Desarrollo y pruebas |
| **Web** | HTTP | Panel de administración |
| **Discord** | Mensajería | Comunidades, equipos técnicos |
| **Telegram** | Mensajería | Bots de atención, demos |
| **Slack** | Mensajería | Entornos corporativos |
| **API REST** | Programático | Integración en otras apps |
| **...** | ... | ... |

---

![bg left](img/openclaw/channels.png)

- Integraciones
A día de hoy: BlueBubbles, Discord, Feishu, Google Chat, iMessage (legacy), IRC, LINE, Matrix, Mattermost, Microsoft Teams, Nextcloud Talk, Nostr, Signal, Slack, Synology Chat, Telegram, Tlon, Twitch, Voice Call, WebChat, WhatsApp, Zalo, Zalo Personal.

---

## ¿Por qué son importantes los canales?

Los canales son la **interfaz entre el agente y el mundo real**:

- 🌍 **Alcance:** El mismo agente puede estar en Discord, Telegram y la web simultáneamente
- 🎯 **Contexto:** Cada canal puede tener su propia identidad o comportamiento
- 🔒 **Control:** Puedes restringir qué usuarios o canales tienen acceso
- 📊 **Trazabilidad:** Cada sesión queda asociada al canal de origen

> 💡 **Sin canales, el agente solo existe en local — los canales son los que lo llevan a producción.**

---

## Cómo funciona un canal

El flujo de un mensaje en cualquier canal es siempre el mismo:

```
Usuario escribe mensaje
        ↓
  Canal lo recibe
        ↓
OpenClaw crea/recupera sesión
        ↓
  Carga workspace (SOUL, IDENTITY, TOOLS...)
        ↓
  LLM genera respuesta
        ↓
  Canal devuelve la respuesta
        ↓
   Usuario la recibe
```

**Clave:** El canal es transparente — el agente no sabe si habla por Discord o Telegram.

---

## Configuración de canales

Los canales se configuran en `openclaw.json`:

```json
"channels": {
  "discord": {
    "enabled": true,
    "token": "${DISCORD_BOT_TOKEN}",
    "guildId": "${DISCORD_GUILD_ID}"
  },
  "telegram": {
    "enabled": true,
    "token": "${TELEGRAM_BOT_TOKEN}"
  },
  ...
}
```

> 💡 **Puedes tener múltiples canales activos a la vez** — cada uno con su propia configuración de acceso.

---

## Local + docker

+ VirtualBox

---

## Variables de entorno

Crear el fichero `.env` en la raíz del proyecto

**Importante: Debes establecer el TimeZone (OPENCLAW_TZ) adecuado para evitar problemas con la aplicación web**


> 💡 **Nunca subas el `.env` a Git.** Está en el `.gitignore` por defecto.

---

## Instalación en windows 

Instalar subsistema wsl

```
# Install OpenClaw
# iwr -useb https://openclaw.ai/install.ps1 | iex

# Install daemon
# openclaw onboard --install-daemon

# Execution policy (powershell)
# Set-ExecutionPolicy -Scope CurrentUser Unrestricted

wsl --update
wsl --install Ubuntu

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
nvm install 24

npm install -g openclaw@2026.4.12

openclaw onboard --install-daemon
  *  configurar modelo (deepseek)
  *  configurar canal

Estado de openclaw: openclaw status
Instalación: openclaw onboard --install-daemon
Reinicio del gateway: openclaw gateway restart
Configuración: openclaw configure

Instalar brew?
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

---

Acceso a webUI
```
    "controlUi": {
      "allowInsecureAuth": true,
      "allowedOrigins": ["*"],
      "dangerouslyDisableDeviceAuth": true,
    },
```


---

# Primeros pasos


## Acceso básico

* Arquitectura final (MI PC > Virtual Box > Docker > OpenClaw)
* Acceso a los contenedores
* Acceso a TUI (*Terminal User Interface*)

---

## Acceso básico

SSH Tunneling: https://iximiuz.com/en/posts/ssh-tunnels/

![alt text](img/ssh/ssh-tunnels.png)

---
## Acceso básicos

Comandos habituales:
* Lanzar comandos: `docker compose run -it openclaw-cli <COMANDO>`
* Conectar con la máquina: `docker compose exec -it openclaw-gateway bash`
* Configurar openclaw `openclaw configure`
* Abrir TUI `openclaw tui`

---

## TUI — Terminal User Interface

La **TUI** es la interfaz de texto interactiva de OpenClaw, accesible desde el terminal:

```bash
openclaw tui
```

- ⌨️ **Sin necesidad de navegador** — todo desde la terminal
- 💬 **Chat directo** con el agente en tiempo real
- 🗂️ **Gestión de sesiones** — ver historial, cambiar agente activo
- 📁 **Acceso al workspace** — editar `SOUL.md`, `IDENTITY.md`... sin salir
- 🔧 **Diagnóstico rápido** — ver logs, estado del modelo, errores

> 💡 **La TUI es la herramienta ideal para hacer la primera configuración del agente.**

---

## TUI — Primera conversación

Al abrir la TUI por primera vez, el agente usa los valores por defecto del workspace:

1. **Abre la TUI:** `openclaw tui`
2. **Escribe un mensaje** — el agente responde con su identidad actual
3. **Edita `SOUL.md`** para darle instrucciones base (quién es, cómo responde)
4. **Edita `IDENTITY.md`** para definir nombre, empresa, tono
5. **Reinicia la sesión** — los cambios se aplican en la siguiente conversación
---
## TUI — Primera conversación

Pantalla de presentación

```
┌─ OpenClaw TUI ─────────────────────────────────┐
│ Sesión: abc123  │  Modelo: minimax-m2.5         │
│                                                 │
│ Tú: Hola, ¿quién eres?                          │
│ Agente: Soy tu asistente. ¿En qué te ayudo?     │
│                                                 │
│ > _                                             │
└─────────────────────────────────────────────────┘
```

---

## Web


![bg left](img/openclaw/web_panel.png)


* Nos permite configurar lo mismo que por configure
* Acceso simplificado y seguro
* Permite un "acceso totalmente remoto"

<!-- Peticiones pendientes: `openclaw devices approve` -->



# Nuestro Primer canal  

---

## 💻 Hola Mundo en Consola

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

---

# Ejercicios adicionales

---

## 🧪 Ejercicio 1 — La lista de la compra

**Objetivo:** Que el agente gestione una lista de la compra persistente, modificable desde cualquier canal.

**Cómo funciona:**
- El agente guarda la lista en `workspace/lista_compra.md`
- La lee al arrancar cada conversación
- Puede añadir, tachar y listar ítems mediante lenguaje natural

---

**Pasos:**
1. Edita `SOUL.md` para indicar al agente que gestiona una lista de la compra (opcional)
2. Dile: *"Añade leche, pan y huevos a la lista"*
3. Dile: *"Ya compré el pan, márcalo"*
4. Dile: *"¿Qué me falta comprar?"*
5. Prueba desde **Web** y comprueba que la lista persiste entre canales

> 💡 Abre `workspace/lista_compra.md` y verifica que el fichero se ha actualizado.

---

## 🧪 Ejercicio 2 — La lista de la compra (cont.)

**Ejemplo de `SOUL.md`:**
```markdown
Eres un asistente doméstico que gestiona la lista de la compra.
La lista se guarda en workspace/lista_compra.md.
Cuando el usuario añada algo, actualiza el fichero con - [ ] ítem.
Cuando diga que ya lo compró, cámbialo a - [x] ítem.
Al preguntar qué falta, muestra solo los ítems sin tachar.
```
---

**Ejemplo de conversación:**
```
Tú:     Añade leche y café
Agente: ✅ Añadidos. Tu lista ahora tiene: leche, café, pan...

Tú:     Ya compré el café
Agente: ✅ Marcado. Te queda: leche, pan...

Tú:     ¿Qué me falta?
Agente: 🛒 Pendiente: leche, pan
```

---

## Resumen de la sesión

✅ Entendemos la diferencia entre LLM puro y agente inteligente

✅ Sabemos instalar y configurar OpenClaw

✅ Creamos un System Prompt efectivo con identidad y restricciones

✅ El agente mantiene memoria de la conversación

---

## Próxima sesión: Skills 🛠️

> *"El agente ya sabe hablar... ahora le damos manos."*

En la próxima sesión aprenderemos a crear **Skills** (herramientas) para que el agente:

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