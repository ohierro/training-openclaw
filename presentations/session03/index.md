---
marp: true
theme: default
paginate: true
---

# Sesión 3
## Model Context Protocol (MCP)

> *Conectando el cerebro a los datos de la empresa*

---

## 🗺️ Agenda

| Bloque | Tema | Tiempo |
|--------|------|--------|
| 🧩 1 | Introducción a MCP | 30 min |
| 🚀 2 | Despliegue de un Servidor MCP | 45 min |
| 🔍 3 | Pruebas de Inferencia | 45 min |

**Objetivo:** Dar al agente acceso seguro y en tiempo real a los datos corporativos sin inyectar todo en el prompt.

---

## Recordatorio: ¿Dónde estamos?

```
Sesión 1 ✅  →  Agente con identidad y memoria en Telegram
Sesión 2 ✅  →  Agente que consulta datos y ejecuta acciones (Skills)
Sesión 3 🔴  →  Agente con acceso seguro a datos corporativos (MCP)
Sesión 4     →  Orquestación multi-agente
```

> Las Skills sirven para acciones puntuales.
> ¿Qué pasa cuando el agente necesita leer **toda** la base de datos?

---

# Bloque 1
## 🧩 Introducción a MCP

*Por qué nace el Model Context Protocol*

---

## El problema del contexto corporativo

Imagina que quieres que tu agente conozca:

- 📦 El inventario completo (10.000 productos en SQLite)
- 📄 Los manuales de soporte técnico (50 PDFs)
- 📋 Las políticas internas de devolución (Markdown)
- 🗂️ El historial de tickets de clientes

**Opciones sin MCP:**

| Opción | Problema |
|--------|----------|
| Meter todo en el System Prompt | El contexto tiene límite de tokens. Caro. Lento. |
| Hacer una Skill por cada tabla | Explosión de Skills. Frágil. Difícil de mantener. |
| No dar acceso al agente | El agente alucina o dice "no sé" continuamente. |

---

## La solución: Model Context Protocol

**MCP** es un estándar abierto (creado por Anthropic, 2024) que define cómo los agentes de IA pueden **solicitar datos externos de forma estructurada**:

```
┌─────────────────┐        MCP         ┌─────────────────────┐
│                 │ ←── "Dame los      │                     │
│  OpenClaw       │     productos      │  Servidor MCP       │
│  (cliente MCP)  │     talla M"  ──→  │  (fuente de datos)  │
│                 │ ←── [{id:1, ...}]  │                     │
└─────────────────┘                    └─────────────────────┘
```

El agente **no tiene acceso directo** a la base de datos.
Pide lo que necesita al servidor MCP, que actúa de intermediario seguro.

---

## Skill vs. Resource: la diferencia clave

| | Skill (Sesión 2) | Resource (MCP) |
|-|------------------|----------------|
| **Propósito** | Ejecutar una acción | Consultar datos |
| **Dirección** | Agente → Mundo | Mundo → Agente |
| **Ejemplo** | Registrar un lead | Leer el inventario |
| **Quién lo controla** | Tú (código Python) | Servidor MCP externo |
| **Escala** | Una función | Miles de registros |

> 💡 **Regla mental:** Skills = *verbos* (hacer algo). Resources = *sustantivos* (conocer algo).

---

## La arquitectura MCP

```
                     ┌──────────────────────────────┐
                     │        Servidor MCP           │
                     │                              │
                     │  ┌──────────┐  ┌──────────┐ │
                     │  │  SQLite  │  │  Ficheros│ │
                     │  │inventario│  │ PDF / MD │ │
                     │  └──────────┘  └──────────┘ │
                     └──────────────┬───────────────┘
                                    │ protocolo MCP
               ┌────────────────────▼──────────────────┐
               │            OpenClaw (cliente)          │
               │  ┌─────────┐  ┌──────────┐            │
               │  │   LLM   │  │  Memory  │            │
               │  └─────────┘  └──────────┘            │
               └────────────────────┬──────────────────┘
                                    │
                             Canal Telegram
```

---

## ¿Qué puede exponer un Servidor MCP?

Un servidor MCP puede ofrecer tres tipos de capacidades:

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Resources** | Datos que el agente puede leer | Tabla de productos, ficheros |
| **Tools** | Funciones que el servidor expone | Buscar en base de datos |
| **Prompts** | Plantillas reutilizables | "Analiza este ticket de soporte" |

En esta sesión usaremos **Tools MCP** (búsqueda en SQLite) y **Resources** (ficheros Markdown).

---

## Servidores MCP open source disponibles

Ya existen docenas de servidores MCP listos para usar:

| Servidor | Fuente de datos |
|----------|-----------------|
| `mcp-server-sqlite` | Base de datos SQLite |
| `mcp-server-filesystem` | Ficheros locales (PDF, MD, TXT) |
| `mcp-server-postgres` | PostgreSQL |
| `mcp-server-github` | Repositorios GitHub |
| `mcp-server-slack` | Mensajes de Slack |
| `mcp-server-google-drive` | Google Drive |

> En esta sesión usaremos `mcp-server-sqlite` y `mcp-server-filesystem`.

---

# Bloque 2
## 🚀 Despliegue de un Servidor MCP

*De cero a un servidor MCP local en 15 minutos*

---

## Preparar los datos de ejemplo

Vamos a crear una base de datos de inventario ficticia:

```python
# setup/create_inventory.py
import sqlite3

conn = sqlite3.connect("data/inventory.db")
conn.executescript("""
CREATE TABLE IF NOT EXISTS products (
    id       INTEGER PRIMARY KEY,
    name     TEXT,
    category TEXT,
    color    TEXT,
    size     TEXT,
    stock    INTEGER,
    price    REAL
);
INSERT INTO products VALUES
  (1, 'Camiseta básica', 'ropa', 'rojo',  'M',  12, 19.99),
  (2, 'Camiseta básica', 'ropa', 'rojo',  'L',   5, 19.99),
  (3, 'Pantalón chino',  'ropa', 'azul',  'M',   8, 49.99),
  (4, 'Zapatillas run',  'calzado','blanco','42', 3, 89.99);
""")
conn.commit()
```

---

## Preparar los documentos de políticas

```markdown
<!-- data/policies/devoluciones.md -->
# Política de Devoluciones — TechCorp

## Productos sin abrir
El cliente puede devolver cualquier producto sin abrir en un plazo
de **30 días** desde la compra con reembolso completo.

## Productos abiertos
Los productos abiertos solo pueden devolverse si presentan un
**defecto de fabricación**. El cliente debe contactar con soporte
adjuntando foto del defecto.

## Excepciones
- Ropa interior y artículos de higiene: **no admiten devolución**.
- Artículos en promoción con etiqueta "Sin devolución".
```

---

## Instalar el servidor MCP SQLite

```bash
# Instalar el servidor MCP para SQLite
pip install mcp-server-sqlite

# Verificar la instalación
python -m mcp_server_sqlite --help
```

```bash
# Instalar el servidor MCP para ficheros
pip install mcp-server-filesystem

# Verificar
python -m mcp_server_filesystem --help
```

> Ambos servidores hablan el protocolo MCP estándar.
> OpenClaw se conecta a ellos como **cliente MCP**.

---

## Arrancar los servidores MCP

```bash
# Terminal 1: Servidor de inventario (SQLite)
python -m mcp_server_sqlite \
  --db-path data/inventory.db \
  --port 8001

# Salida:
# ✅ MCP Server SQLite escuchando en localhost:8001
# 📦 Base de datos: data/inventory.db (4 tablas)
```

```bash
# Terminal 2: Servidor de documentos (Filesystem)
python -m mcp_server_filesystem \
  --root data/policies \
  --port 8002

# Salida:
# ✅ MCP Server Filesystem escuchando en localhost:8002
# 📁 Directorio raíz: data/policies (3 ficheros)
```

---

## Conectar OpenClaw a los servidores MCP

```yaml
# agent.yaml
name: asistente-tienda
llm:
  provider: openai
  model: gpt-4o-mini

mcp:
  servers:
    - name: inventario
      url: http://localhost:8001
      description: "Inventario de productos de la tienda TechCorp"
    - name: politicas
      url: http://localhost:8002
      description: "Políticas internas: devoluciones, garantías, envíos"

system_prompt: |
  Eres el asistente de TechCorp, una tienda de ropa y calzado.
  Tienes acceso al inventario en tiempo real y a las políticas internas.
  Responde siempre con datos exactos. Nunca inventes stock ni precios.
```

---

## ¿Cómo negocia OpenClaw con MCP?

Cuando el agente necesita un dato, el LLM:

```
1. Identifica que necesita datos externos
   ("¿Cuántas camisetas rojas talla M hay?")
       ↓
2. Consulta el catálogo de Tools del servidor MCP
   (qué puede preguntar: query_table, search_products...)
       ↓
3. Llama a la Tool MCP adecuada con parámetros precisos
   query_table("SELECT stock FROM products WHERE color='rojo' AND size='M'")
       ↓
4. Recibe el resultado estructurado
   [{"stock": 12}]
       ↓
5. Formula la respuesta natural al usuario
   "Tenemos 12 camisetas rojas talla M en stock."
```

---

# Bloque 3
## 🔍 Pruebas de Inferencia

*El agente que nunca alucina (porque tiene los datos reales)*

---

## Consultas de inventario en tiempo real

```
Usuario: ¿Cuántas camisetas rojas talla M nos quedan en el almacén?

Bot: Según el inventario actualizado, actualmente tenemos
     12 camisetas rojas talla M en stock. ✅

Usuario: ¿Y en talla L?

Bot: En talla L solo quedan 5 unidades. Si necesitas
     reaprovisionar, te recomiendo hacer el pedido pronto.

Usuario: ¿Cuánto cuestan las zapatillas de running?

Bot: Las zapatillas de running (talla 42) están a 89,99€.
     Actualmente quedan 3 pares en stock.
```

---

## Consultas sobre políticas de empresa

```
Usuario: ¿Cuál es la política si un cliente devuelve
         un producto abierto?

Bot: Según nuestra política de devoluciones:
     Los productos abiertos solo se aceptan si presentan
     un defecto de fabricación. El cliente debe contactar
     con soporte adjuntando una foto del defecto. 📋

Usuario: ¿Y si no lo ha abierto?

Bot: En ese caso, el cliente tiene 30 días desde la compra
     para devolver el producto y recibir un reembolso completo,
     sin necesidad de justificación.
```

---

## Consultas mixtas (inventario + política)

```
Usuario: Un cliente quiere devolver unas zapatillas talla 42
         que compró hace 2 semanas y las ha abierto.
         ¿Qué le digo y cuántas tenemos en stock por si
         hay que reponerlas?

Bot: Para la devolución: al estar abiertas, solo procede si
     hay un defecto de fabricación. Pídele una foto del defecto.

     Respecto al stock: actualmente tenemos 3 pares de zapatillas
     de running talla 42. Si la devolución procede, subirían a 4.
```

> 🎯 El agente combina **dos fuentes MCP** (inventario + políticas) en una sola respuesta coherente.

---

## Comparativa: con y sin MCP

```
Pregunta: "¿Cuántas camisetas rojas talla M quedan?"

Sin MCP:
  "Actualmente tenemos aproximadamente entre 10 y 20 unidades..."
   ❌ Dato inventado. Inútil para operaciones reales.

Con MCP:
  "Según el inventario, hay exactamente 12 unidades."
   ✅ Dato real extraído de la base de datos en tiempo real.
```

```
Pregunta: "¿Puedo devolver un producto abierto?"

Sin MCP:
  "Generalmente las tiendas permiten devoluciones en 14 días..."
   ❌ Política genérica inventada. Puede crear conflictos legales.

Con MCP:
  "Según nuestra política: solo si hay defecto de fabricación."
   ✅ Política exacta de la empresa.
```

---

## Seguridad: el servidor MCP como guardián

El servidor MCP controla **qué datos** puede ver el agente:

```yaml
# config del servidor MCP (ejemplo)
permissions:
  tables:
    - products     # ✅ acceso permitido
    - orders       # ✅ acceso permitido
    - employees    # ❌ acceso denegado (datos RRHH)
    - salaries     # ❌ acceso denegado (datos confidenciales)

  operations:
    - SELECT       # ✅ solo lectura
    - INSERT       # ❌ el agente no puede escribir en la BD
    - UPDATE       # ❌
    - DELETE       # ❌
```

> El agente nunca ve más de lo que el servidor MCP le permite.

---

## MCP en producción: patrones comunes

| Caso de uso | Servidor MCP | Beneficio |
|-------------|--------------|-----------|
| Soporte técnico | Filesystem (manuales PDF) | Respuestas basadas en documentación real |
| Ventas | SQLite/PostgreSQL (catálogo) | Stock y precios siempre actualizados |
| RRHH interno | Filesystem (políticas MD) | Políticas correctas sin pasar por RRHH |
| Onboarding | GitHub (docs del repo) | El agente conoce el código de la empresa |
| Atención al cliente | CRM vía MCP | Histórico real del cliente en cada conversación |

---

## 🧪 Ejercicio 3A — Servidor MCP SQLite

1. Ejecuta `setup/create_inventory.py` para crear la base de datos
2. Arranca `mcp-server-sqlite` apuntando a `data/inventory.db`
3. Añade la sección `mcp.servers` a tu `agent.yaml`
4. Pregunta al bot: *"¿Cuántas camisetas rojas talla M tenemos?"*
5. Verifica que el número coincide con lo que hay en la BD

---

## 🧪 Ejercicio 3B — Servidor MCP Filesystem

1. Crea `data/policies/devoluciones.md` con la política de devoluciones
2. Arranca `mcp-server-filesystem` apuntando a `data/policies/`
3. Añade el segundo servidor MCP al `agent.yaml`
4. Pregunta al bot: *"¿Qué pasa si un cliente devuelve un producto abierto?"*
5. **Bonus:** Modifica el fichero de políticas y comprueba que el bot refleja el cambio en tiempo real (sin reiniciar)

---

## Resumen de la sesión

✅ Entendemos por qué nacen MCP y la diferencia entre Skill y Resource

✅ Desplegamos un servidor MCP SQLite con datos de inventario

✅ Desplegamos un servidor MCP Filesystem con políticas en Markdown

✅ El agente responde con datos exactos sin alucinar

✅ Aprendemos a controlar qué datos puede ver el agente (seguridad)

---

## Próxima sesión: Multi-Agente 🤖🤖🤖

> *"Un solo agente generalista se vuelve torpe si le pedimos demasiado. Es hora de crear especialistas."*

En la **Sesión 4** construiremos un sistema de agentes que colaboran:

- 🚦 **Enrutador:** clasifica y delega conversaciones
- 🔧 **Soporte Técnico:** conectado al MCP de manuales
- 💼 **Ventas:** equipado con la Skill de registro de leads
- 🔄 Handoffs con contexto compartido entre agentes

---

## Referencias y recursos

- 📖 MCP Specification: `modelcontextprotocol.io`
- 🔌 Servidores MCP open source: `github.com/modelcontextprotocol/servers`
- 🗄️ mcp-server-sqlite: `github.com/modelcontextprotocol/servers/tree/main/src/sqlite`
- 📁 mcp-server-filesystem: `github.com/modelcontextprotocol/servers/tree/main/src/filesystem`
- 📐 Introducción oficial a MCP — Anthropic: `anthropic.com/news/model-context-protocol`
