

## 🧪 Ejercicio 4 — Resumen de documentos

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

## 🧪 Ejercicio 4 — Resumen de documentos (cont.)

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