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
| 🏗️ 1 | Arquitectura de una Skill | 30 min |
| 🌐 2 | Skill de Lectura — API externa | 45 min |
| 📝 3 | Skill de Escritura — Acción corporativa | 45 min |

**Objetivo:** Que el agente deje de ser una caja de texto y empiece a actuar en el mundo real.

---

## Recordatorio: ¿Dónde estamos?

```
Sesión 1 ✅  →  Agente con identidad y memoria en Telegram
Sesión 2 🔴  →  Agente que consulta datos y ejecuta acciones
Sesión 3     →  Agente con acceso seguro a datos corporativos (MCP)
Sesión 4     →  Orquestación multi-agente
```

> El agente ya **sabe hablar**. Ahora le damos **manos**.

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

## Anatomía de una Skill en OpenClaw

```python
from openclaw import skill

@skill(
    name="get_weather",
    description="Consulta el tiempo actual de una ciudad.",
    parameters={
        "city": {
            "type": "string",
            "description": "Nombre de la ciudad (ej: Madrid, Zaragoza)"
        }
    }
)
def get_weather(city: str) -> dict:
    # Aquí va el código real
    response = requests.get(f"https://api.weather.com/?q={city}")
    return response.json()
```

**La `description` es crítica**: el LLM la lee para decidir si usar esta Skill.

---

## Los tres elementos que el LLM necesita

| Elemento | Para qué sirve | Ejemplo |
|----------|---------------|---------|
| `name` | Identificar la skill | `get_weather` |
| `description` | Decidir *cuándo* usarla | `"Consulta el tiempo actual..."` |
| `parameters` | Saber *qué datos* pedir al usuario | `city: string` |

> ✍️ **Escribe la `description` como si fuera para un humano.**
> El LLM no infiere: necesita instrucciones claras.

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

## Registrar Skills en agent.yaml

```yaml
# agent.yaml
name: recepcionista
llm:
  provider: openai
  model: gpt-4o-mini

skills:
  - path: skills/get_weather.py
  - path: skills/register_lead.py

system_prompt: |
  Eres el asistente de TechCorp.
  Cuando alguien pregunte por el tiempo, usa la herramienta disponible.
  Cuando alguien muestre interés en comprar, registra sus datos.
```

---

# Bloque 2
## 🌐 Skill de Lectura — API externa

*El agente aprende a consultar datos en tiempo real*

---

## Objetivo del bloque

Crear una Skill que consulte una **API pública gratuita** y permita al agente:

- Responder con datos actualizados al segundo
- No alucinar información que no conoce

**Dos opciones de práctica:**
- 🌤️ Clima de una ciudad (OpenWeatherMap — gratis)
- ₿ Precio actual del Bitcoin (CoinGecko — sin API key)

---

## Skill: Precio de Bitcoin

```python
# skills/get_bitcoin_price.py
import requests
from openclaw import skill

@skill(
    name="get_bitcoin_price",
    description=(
        "Obtiene el precio actual del Bitcoin en tiempo real. "
        "Úsala cuando el usuario pregunte por el precio, valor o "
        "cotización del Bitcoin o BTC."
    ),
    parameters={}   # No necesita parámetros
)
def get_bitcoin_price() -> dict:
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {"ids": "bitcoin", "vs_currencies": "usd,eur"}
    resp = requests.get(url, params=params, timeout=5)
    data = resp.json()["bitcoin"]
    return {
        "usd": data["usd"],
        "eur": data["eur"]
    }
```

---

## Skill: Clima de una ciudad

```python
# skills/get_weather.py
import requests, os
from openclaw import skill

@skill(
    name="get_weather",
    description=(
        "Consulta el tiempo meteorológico actual de cualquier ciudad. "
        "Úsala cuando el usuario pregunte por la temperatura, el clima "
        "o el tiempo que hace en un lugar."
    ),
    parameters={
        "city": {
            "type": "string",
            "description": "Ciudad sobre la que consultar el tiempo"
        }
    }
)
def get_weather(city: str) -> dict:
    key = os.getenv("OPENWEATHER_API_KEY")
    url = "https://api.openweathermap.org/data/2.5/weather"
    resp = requests.get(url, params={"q": city, "appid": key, "units": "metric", "lang": "es"})
    data = resp.json()
    return {"city": city, "temp": data["main"]["temp"], "desc": data["weather"][0]["description"]}
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

---

## Probando en Telegram

```
Usuario: ¿Cuánto vale el Bitcoin ahora?

Bot: ¡Claro! Déjame consultarlo...
     El precio actual del Bitcoin es:
     • 💵 $67,420 USD
     • 💶 €62,100 EUR
     (Dato en tiempo real, actualizado hace segundos)

Usuario: ¿Y qué tiempo hace en Zaragoza?

Bot: En Zaragoza ahora mismo hay 14°C
     con cielo parcialmente nublado. 🌤️
```

---

## Manejo de errores en Skills

Siempre contempla fallos de red o API:

```python
@skill(name="get_bitcoin_price", description="...", parameters={})
def get_bitcoin_price() -> dict:
    try:
        resp = requests.get("https://api.coingecko.com/...", timeout=5)
        resp.raise_for_status()
        return resp.json()["bitcoin"]
    except requests.Timeout:
        return {"error": "La API tardó demasiado. Inténtalo de nuevo."}
    except requests.HTTPError as e:
        return {"error": f"Error de la API: {e}"}
```

> El LLM leerá el `error` y lo comunicará al usuario de forma natural.

---

## 🧪 Ejercicio 2A — Skill de Lectura

1. Crea `skills/get_bitcoin_price.py` en tu proyecto
2. Regístrala en `agent.yaml`
3. Inicia el bot y en Telegram pregunta: *"¿Cuánto vale el Bitcoin?"*
4. Verifica que el dato es real (compáralo con Google)

**Bonus:** Añade soporte para Ethereum. ¿Qué cambias en el código?

---

# Bloque 3
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

```python
# skills/register_lead.py
import csv, os
from datetime import datetime
from openclaw import skill

@skill(
    name="register_lead",
    description=(
        "Registra un cliente potencial (lead) en la base de datos. "
        "Úsala cuando el usuario muestre interés en comprar, pida "
        "información comercial o deje sus datos de contacto."
    ),
    parameters={
        "nombre":  {"type": "string", "description": "Nombre del contacto"},
        "email":   {"type": "string", "description": "Email del contacto"},
        "interes": {"type": "string", "description": "Producto o servicio de interés"}
    }
)
def register_lead(nombre: str, email: str, interes: str) -> dict:
    filepath = "data/leads.csv"
    os.makedirs("data", exist_ok=True)
    is_new = not os.path.exists(filepath)
    with open(filepath, "a", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["fecha","nombre","email","interes"])
        if is_new:
            writer.writeheader()
        writer.writerow({"fecha": datetime.now().isoformat(), "nombre": nombre,
                         "email": email, "interes": interes})
    return {"status": "ok", "message": f"Lead de {nombre} registrado correctamente."}
```

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
  3. Usa la herramienta 'register_lead' para guardar sus datos.
  4. Confirma al usuario que el equipo comercial le contactará.

  Nunca inventes precios ni hagas promesas específicas de descuentos.
```

---

## Conversación completa en Telegram

```
Usuario: Buenas, ¿tenéis alguna solución para gestión de inventario?

Bot: ¡Hola! Sí, TechCorp tiene una solución específica para gestión
     de inventario con integración en tiempo real. ¿Te gustaría que
     nuestro equipo comercial te enviara más información?

Usuario: Sí, me interesa. Soy Marcos.

Bot: ¡Perfecto, Marcos! ¿Cuál es tu email de contacto para que el
     equipo pueda escribirte?

Usuario: marcos@miempresa.com

Bot: ¡Listo! He registrado tus datos. 📋
     El equipo de TechCorp se pondrá en contacto contigo pronto.
     ¿Hay algo más en lo que pueda ayudarte?
```

---

## Verificar los datos guardados

```bash
# Ver los leads registrados
cat data/leads.csv
```

```csv
fecha,nombre,email,interes
2026-03-18T10:23:41,Marcos,marcos@miempresa.com,gestión de inventario
2026-03-18T11:05:12,Laura,laura@empresa.es,software de gestión
```

> En producción, esto se puede reemplazar por Google Sheets, Airtable,
> un CRM como HubSpot, o directamente una base de datos.

---

## Variante: Guardar en Google Sheets

```python
import gspread
from google.oauth2.service_account import Credentials

@skill(name="register_lead", description="...", parameters={...})
def register_lead(nombre: str, email: str, interes: str) -> dict:
    creds = Credentials.from_service_account_file(
        "credentials.json",
        scopes=["https://spreadsheets.google.com/feeds"]
    )
    gc = gspread.authorize(creds)
    sheet = gc.open("TechCorp Leads").sheet1
    sheet.append_row([datetime.now().isoformat(), nombre, email, interes])
    return {"status": "ok"}
```

> Solo cambia la función `register_lead`. El agente y el YAML son idénticos.

---

## 🧪 Ejercicio 2B — Skill de Escritura

1. Crea `skills/register_lead.py` con la versión CSV
2. Regístrala en `agent.yaml` junto al System Prompt de captación
3. Simula en Telegram ser un cliente interesado en un producto
4. Verifica que `data/leads.csv` contiene tus datos

**Bonus:** ¿Qué pasa si no das el email? ¿El bot lo pide?
Prueba a decirle solo tu nombre y observa el comportamiento.

---

## Skills: buenas prácticas

| ✅ Hacer | ❌ Evitar |
|----------|-----------|
| Descripciones claras y específicas | Nombres genéricos (`tool1`, `doStuff`) |
| Retornar `dict` con `status` y datos | Lanzar excepciones sin capturar |
| Tipar bien los parámetros | Parámetros ambiguos o sin descripción |
| Una Skill = una responsabilidad | Skills que hacen demasiadas cosas |
| Confirmar la acción al usuario | Actuar en silencio sin feedback |

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