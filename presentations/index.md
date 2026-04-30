---
marp: true
---



## Sesión 1: Fundamentos, Instalación y Primer Despliegue (El nacimiento del agente)

En esta sesión pasamos de cero a tener un agente funcional interactuando en el mundo real.

🎯 Objetivo: Entender la arquitectura básica de OpenClaw, preparar el entorno y desplegar un bot conversacional con memoria.

📝 Ejemplo Práctico: Configurar OpenClaw en local y conectarlo a un bot de Discord que actuará como el "Recepcionista" de nuestra empresa ficticia.

---

## Sesión 2: Interacción con el Mundo a través de "Skills" (Dándole manos al agente)

El agente ya sabe hablar, pero ahora necesita poder ejecutar acciones. Introducimos el concepto de "Tools/Skills".

🎯 Objetivo: Aprender a programar e integrar Skills personalizadas para que OpenClaw pueda consumir APIs y ejecutar código.

📝 Ejemplo Práctico: Enseñar al bot de Telegram a revisar el clima/calendario y a registrar "Leads" (clientes potenciales) en una hoja de cálculo o base de datos ligera.

---
## Sesión 3: Model Context Protocol (MCP) (Conectando el cerebro a los datos de la empresa)

Las Skills sirven para acciones puntuales, pero ¿qué pasa cuando el agente necesita leer toda la base de datos de productos o manuales internos de la empresa de forma segura? Aquí entra MCP.

Veremos también cómo planificar tareas de forma periódica con el uso de cron.

🎯 Objetivo: Entender y desplegar el estándar MCP para dar contexto seguro y en tiempo real a OpenClaw sin tener que inyectar todo en el prompt inicial. Utilizar las apis de búsqueda web.

📝 Ejemplo Práctico: Conectar el agente a un Servidor MCP local que contiene el inventario de la empresa (SQLite) y las políticas de devolución (archivos PDF/Markdown).

---

## Sesión 4: Orquestación Multi-Agente (El sistema nervioso corporativo)

Un solo agente generalista se vuelve torpe si le pedimos demasiado. Es hora de crear especialistas que colaboren entre sí.

🎯 Objetivo: Dominar los patrones de enrutamiento (routing) y paso de mensajes entre múltiples agentes de OpenClaw. Entender y comprender el uso de las tareas programadas.

📝 Ejemplo Práctico: Sustituir el agente único por un sistema de "Triage" (Clasificación) y resolución.