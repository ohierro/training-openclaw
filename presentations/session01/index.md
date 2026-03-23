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
| 🧠 1 | Teoría y Setup | 30 min |
| 💻 2 | Hola Mundo en Consola | 45 min |
| 📱 3 | Despliegue en Discord | 45 min |

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

## TUI

* Qué es? 
* Primera conversación (definiendo SOUL.MD e IDENTITY.md)

## Web

* Cómo abro el panel?
* Problema con el timezone del docker (está en UTC)

## Estructura de archivos
* Qué ficheros son relevantes? 
  * openclaw.json
  * workspace/

## Contexto

AGENTS.md  BOOTSTRAP.md  HEARTBEAT.md  IDENTITY.md  SOUL.md  TOOLS.md  USER.md

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

## Arrancar el agente en consola

```bash
# Iniciar el agente en modo interactivo
python -m openclaw run --config agent.yaml

# Verás algo así:
# ✅ OpenClaw v1.x iniciado
# 🤖 Agente: recepcionista (TechCorp)
# 💬 Escribe tu mensaje (Ctrl+C para salir)
#
# Tú: Hola, ¿a qué se dedica TechCorp?
# Alex: ¡Hola! TechCorp es una empresa de software especializada
#       en soluciones empresariales. ¿En qué puedo ayudarte hoy?
```

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

* Pairing


cambiar para discord
1. Crea tu bot en BotFather y obtén el token
2. Actualiza tu `.env` con `TELEGRAM_BOT_TOKEN`
3. Añade la sección `channels.telegram` a tu `agent.yaml`
4. Arranca OpenClaw y prueba desde tu móvil
5. Comparte el username de tu bot con un compañero para que lo pruebe

**Bonus:** Edita el System Prompt para que el bot se presente con tu nombre de empresa ficticia.

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