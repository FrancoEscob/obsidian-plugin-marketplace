---
description: "Wizard interactivo para configurar tu Obsidian vault desde cero con Claude"
argument-hint: "[--skip-intro]"
allowed-tools:
  - AskUserQuestion
  - Write
  - Read
  - Edit
  - Bash
  - Grep
  - Glob
---

# Comando: /setup-vault

Wizard interactivo que configura tu Obsidian vault desde cero, adaptándose a tu forma de trabajar.

## Argumentos

- `--skip-intro` (opcional): Saltar la explicación de PKM y empezar directo con las preguntas

## Instrucciones

### PASO 0: Selección de Idioma

**PRIMER MENSAJE DEL WIZARD:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    👋 WELCOME / BIENVENIDO / BIENVENUE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Let's start by choosing your language.
Comencemos eligiendo tu idioma.

Choose your language / Elige tu idioma:

1. 🇪🇸 Español
2. 🇬🇧 English  
3. 🌍 Other (specify / especificar)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Usar AskUserQuestion:
```
Your choice / Tu elección (1/2/3):
```

**Si elige 1:** 
- Guardar `$LANGUAGE = "español"` 
- **TODO el wizard se ejecuta en español**

**Si elige 2:** 
- Guardar `$LANGUAGE = "english"`
- **TODO el wizard se ejecuta en inglés**

**Si elige 3:** 
- Preguntar: `Please specify your language / Especifica tu idioma:`
- Guardar respuesta en `$LANGUAGE`
- Intentar responder en ese idioma, si no es posible usar inglés

**IMPORTANTE:** A partir de aquí, todos los mensajes deben adaptarse al idioma elegido.

---

### PASO 1: Validación

1. Verifica que el vault esté vacío o casi vacío:
```bash
# Contar archivos .md en el vault
find . -maxdepth 2 -name "*.md" -type f | wc -l
```

2. Si hay más de 5 archivos .md, preguntar:

[Español:]
```
Este vault parece tener contenido existente.
/setup-vault está diseñado para vaults nuevos.

¿Continuar de todas formas? (s/n)
```

[English:]
```
This vault seems to have existing content.
/setup-vault is designed for new vaults.

Continue anyway? (y/n)
```

3. Si hay `.claude/vault-config.yml` existente:

[Español:]
```
Ya existe una configuración en .claude/vault-config.yml

Opciones:
1. Reconfigurar (sobrescribe config actual)
2. Cancelar y mantener config actual

¿Qué hacer? (1/2)
```

[English:]
```
Configuration already exists in .claude/vault-config.yml

Options:
1. Reconfigure (overwrites current config)
2. Cancel and keep current config

What to do? (1/2)
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 1: Bienvenida + Contexto
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mostrar bienvenida **EN EL IDIOMA ELEGIDO**:

[Si $LANGUAGE = "español":]
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🌟 Bienvenido al Setup de tu Obsidian Vault + Claude
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Este wizard va a:

1. Explicarte cómo funciona un sistema PKM (Personal Knowledge Management)
2. Entender cómo trabajas TÚ
3. Crear una configuración personalizada
4. Adaptar comandos y automatizaciones a tu estilo
5. Generar la estructura de carpetas

Idioma: Español 🇪🇸
⏱️  Tiempo estimado: 5-7 minutos (8 pasos)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primero, déjame explicarte cómo funciona esto...
```

Usar AskUserQuestion: "¿Listo para empezar? (s/n)"

[Si $LANGUAGE = "english":]
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🌟 Welcome to Your Obsidian Vault + Claude Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This wizard will:

1. Explain how a PKM (Personal Knowledge Management) system works
2. Understand how YOU work
3. Create a personalized configuration
4. Adapt commands and automations to your style
5. Generate the folder structure

Language: English 🇬🇧
⏱️  Estimated time: 5-7 minutes (8 steps)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

First, let me explain how this works...
```

Usar AskUserQuestion: "Ready to start? (y/n)"

---

**IMPORTANTE:** De aquí en adelante, el wizard debe usar el idioma elegido para TODOS los mensajes.

Si responde "n", terminar con mensaje en su idioma.

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 1.5: Educación PKM
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Si NO se pasó `--skip-intro`, mostrar:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      📚 CÓMO FUNCIONA UN VAULT OBSIDIAN + CLAUDE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Un vault bien organizado tiene 9 carpetas principales:

1. 📥 INBOX/
   Para: Captura rápida de ideas, notas sin procesar
   Ejemplo: "Idea: app de meditación", "Link interesante"
   → Se procesa diariamente con /process-inbox

2. 📚 KNOWLEDGE/
   Para: Tu base de conocimiento organizada por temas
   Ejemplo: KNOWLEDGE/IA-ML/transformers.md
   → Notas permanentes, bien desarrolladas

3. 🚀 PROJECTS/
   Para: Proyectos activos (cada uno con su carpeta)
   Ejemplo: PROJECTS/AppSalud/README.md
   → Trackear progreso, tasks, recursos

4. 📦 RECURSOS/
   Para: Material externo (Papers, Videos, Libros)
   Ejemplo: RECURSOS/Papers/attention-is-all-you-need.md
   → Referencias que consultas

5. 💡 IDEAS/
   Para: Brainstorming libre, ideas sin forma
   Ejemplo: "Qué pasaría si..."
   → No requiere organización, solo captura

6. 🎨 CANVAS/
   Para: Diagramas visuales, mapas mentales
   Ejemplo: CANVAS/arquitectura-sistema.canvas
   → Pensamiento visual

7. 📊 PRODUCTIVITY/
   Para: Daily notes, kanban, goals, reviews
   Ejemplo: PRODUCTIVITY/daily-notes/2026/01-ENE/2026-01-12.md
   → Gestión del día a día

8. 🧠 AGENT-MEMORIES/
   Para: Memoria persistente de Claude entre sesiones
   Ejemplo: AGENT-MEMORIES/project-context/app-salud.md
   → Claude recuerda contexto

9. ⚙️ _SYSTEM/
   Para: Templates, configuraciones internas
   Ejemplo: _SYSTEM/templates/daily-note.md
   → Infraestructura del vault

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                FLUJO DE TRABAJO TÍPICO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📥 Captura rápida → INBOX/
     ↓
📋 Procesar inbox → clasificar y mover
     ↓ 
📚 Notas permanentes → KNOWLEDGE/
🚀 Notas de proyectos → PROJECTS/
💡 Ideas sueltas → IDEAS/
     ↓
🔗 Conectar notas (links, MOCs, Canvas)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Usar AskUserQuestion con opciones:
- Pregunta: "¿Te queda claro el sistema?"
- Opciones:
  1. "Sí, entiendo (continuar)"
  2. "Explícame más con ejemplos"
  3. "Saltear esto y empezar"

Si elige opción 2, dar ejemplo detallado:

```
📝 EJEMPLO PRÁCTICO:

Digamos que estás desarrollando una app de salud.

DÍA 1: CAPTURA
- Tienes una idea: "Integrar wearables para tracking"
- Creas: INBOX/_quick-notes/idea-wearables.md
- Solo escribes la idea, sin pensar en organización

DÍA 2: PROCESAR
- Ejecutas: /process-inbox
- Claude lee tu nota y determina:
  * Tipo: idea de proyecto
  * Destino: PROJECTS/AppSalud/ (o IDEAS/ si aún no es proyecto)
- Claude mueve la nota y agrega frontmatter automáticamente

DÍA 3: DESARROLLAR
- Ejecutas: /new-project "AppSalud"
- Claude crea estructura completa
- Trabajas en el proyecto, Claude ayuda a codear
- Al final: Claude auto-guarda el contexto

DÍA 4: RETOMAR
- Abres Claude
- Claude dice: "La última vez trabajábamos en AppSalud. 
  Habías implementado la API de wearables. Siguiente: 
  integrar con la base de datos."
- NUNCA pierdes el hilo 🎯

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

¿Ahora sí queda claro? (s/n)
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 2: Perfil del Usuario (5 Preguntas Clave)
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mostrar:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          📋 PASO 2: Entender tu forma de trabajar
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Te voy a hacer 5 preguntas para recomendarte la mejor configuración.
```

### Pregunta 1: Perfil
Usar AskUserQuestion:
- Pregunta: "¿Cómo te describes mejor?"
- Opciones:
  1. "Técnico/Ingeniero (me gusta el detalle y la estructura)"
  2. "Creativo/Diseñador (prefiero visual y simple)"
  3. "Investigador/Académico (trabajo con papers, citas, referencias)"
  4. "Generalista (un poco de todo)"

Guardar respuesta en variable: `perfil`

### Pregunta 2: Desafío principal
Usar AskUserQuestion:
- Pregunta: "¿Cuál es tu MAYOR desafío al trabajar?"
- Opciones:
  1. "Perder el contexto / olvidar dónde quedé"
  2. "Organizar información técnica compleja"
  3. "Gestionar múltiples proyectos simultáneos"
  4. "Capturar ideas rápido sin fricción"
  5. "Conectar conocimiento (linking, relaciones entre notas)"

Guardar respuesta en variable: `desafio`

### Pregunta 3: Estilo de trabajo
Usar AskUserQuestion:
- Pregunta: "¿Cómo prefieres trabajar?"
- Opciones:
  1. "Con estructura clara y categorías bien definidas"
  2. "Fluido, sin muchas reglas ni categorías"
  3. "Visual (diagramas, canvas, mapas mentales)"
  4. "Texto minimalista (sin distracciones)"

Guardar respuesta en variable: `estilo`

### Pregunta 4: Nivel de automatización
Usar AskUserQuestion:
- Pregunta: "¿Cuánta automatización quieres?"
- Opciones:
  1. "Mínima - Yo controlo todo manualmente"
  2. "Media - Sugerencias que puedo aceptar/rechazar"
  3. "Máxima - Automatiza todo lo posible (zero friction)"

Guardar respuesta en variable: `automatizacion`

### Pregunta 5: ADHD / Contexto
Usar AskUserQuestion:
- Pregunta: "¿Tienes TDAH/ADHD o dificultad para mantener contexto entre sesiones?"
- Opciones:
  1. "Sí (necesito ayuda para no perder el hilo)"
  2. "No (mantengo contexto bien)"

Guardar respuesta en variable: `adhd`

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 3: Recomendación de Config Base
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### PASO 3.1: Lógica de Decisión

Basándote en las respuestas, determina la config recomendada:

```python
# Pseudocódigo para la lógica:

if adhd == "Sí" and desafio == "Perder el contexto":
    config_recomendada = "creative-adhd"
    razon = "Tienes ADHD + tu mayor desafío es perder contexto"
    
elif perfil == "Técnico/Ingeniero" and estilo == "Con estructura clara":
    config_recomendada = "francovault"
    razon = "Eres técnico y prefieres estructura detallada"
    
elif perfil == "Investigador/Académico":
    config_recomendada = "researcher"
    razon = "Trabajo académico requiere organización de referencias"
    
elif estilo == "Texto minimalista" and automatizacion == "Mínima":
    config_recomendada = "minimal"
    razon = "Prefieres simplicidad y control manual"
    
else:
    # Default: creative-adhd si automatización máxima, sino minimal
    if automatizacion == "Máxima":
        config_recomendada = "creative-adhd"
        razon = "Prefieres máxima automatización"
    else:
        config_recomendada = "minimal"
        razon = "Balance entre simplicidad y funcionalidad"
```

### PASO 3.2: Leer Config Recomendada

Usa Read para leer el archivo de config:
```bash
cat FranEscob/plugins/obsidian-plugin/config-examples/[config_recomendada]-config.yml
```

Parsea el YAML para extraer:
- Carpetas incluidas
- Carpetas excluidas (comparando con base completa)
- Workflows configurados
- Frontmatter schema

### PASO 3.3: Mostrar Recomendación Detallada

Según la config recomendada, mostrar:

#### Si es "creative-adhd":

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
             ✨ CONFIGURACIÓN RECOMENDADA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Según tus respuestas, recomiendo: 🧠 Creative ADHD

¿Por qué?
[razon personalizada basada en respuestas]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       QUÉ INCLUYE LA CONFIG "CREATIVE ADHD"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Carpetas (solo 3, ultra-simple):
  ✅ _INBOX/        - Captura rápida sin fricción
  ✅ _PROJECTS/     - Proyectos activos
  ✅ _CONTEXT/      - Sesiones auto-guardadas ⭐

Carpetas NO incluidas (para simplificar):
  ❌ KNOWLEDGE/     - Demasiado estructurado para ADHD
  ❌ RECURSOS/      - Se mezcla con proyectos
  ❌ CANVAS/        - Generado automáticamente
  ❌ IDEAS/         - Va todo a INBOX (más simple)
  ❌ PRODUCTIVITY/  - Auto-generado según necesidad
  ❌ AGENT-MEMORIES/ - _CONTEXT/ cumple esa función

Automatizaciones incluidas:
  ✅ Auto-clasificación (sin preguntar, decide automático)
  ✅ Session-end hook (guarda contexto al terminar) ⭐
  ✅ Session-start hook (muestra dónde quedaste)
  ✅ Frontmatter helper (agrega metadata automático)

Frontmatter:
  Simple - Solo 4 campos obligatorios:
    • id, created, tipo, estado

Verbosidad de Claude:
  Casual, no técnico, directo al grano

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         COMPARACIÓN CON OTRAS CONFIGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 MINIMAL: 
   Carpetas: INBOX, PROJECTS, KNOWLEDGE
   Auto: No
   Hooks: Solo session-start
   Para: Minimalistas que quieren control total

🔬 RESEARCHER:
   Carpetas: INBOX, KNOWLEDGE, RECURSOS, PROJECTS
   Auto: Media
   Hooks: Session-start + frontmatter helper
   Para: Trabajo académico con papers/citas

🛠️ FRANCOVAULT:
   Carpetas: Todas las 9 (completo)
   Auto: Media-Alta
   Hooks: Todos
   Para: Técnicos que quieren máximo control

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### Adaptar para otras configs

Para "francovault", "minimal", "researcher": usar el mismo formato pero ajustar:
- Carpetas incluidas/excluidas
- Nivel de automatización
- Descripción de hooks
- Frontmatter (simple vs detallado)

### PASO 3.4: Elegir Config

Usar AskUserQuestion:
- Pregunta: "¿Qué quieres hacer?"
- Opciones:
  1. "Usar [config_recomendada] (recomendado para ti)"
  2. "Ver otra configuración"
  3. "Customizar (agregar/quitar carpetas de [config_recomendada])"

Guardar respuesta en variable: `eleccion`

Si elige opción 2 "Ver otra":
- Mostrar lista de las 4 configs disponibles
- Permitir elegir una
- Mostrar detalle de la elegida (formato del PASO 3.3)
- Volver a preguntar: usar/customizar

Si elige opción 3 "Customizar":
- Continuar a FASE 4

Si elige opción 1 "Usar recomendada":
- Saltar FASE 4, ir directo a FASE 5

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 4: Customizar Estructura
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Esta fase solo se ejecuta si el usuario eligió "Customizar" en la Fase 3.

### PASO 4.1: Si eligió "Usar recomendada" (sin customizar)

Preguntar solo:
```
Perfecto, usaremos [config_recomendada] con estas carpetas:
[listar carpetas de la config]

¿Quieres cambiar los NOMBRES de las carpetas?
Ejemplo: INBOX → CAPTURA, PROJECTS → MIS-PROYECTOS

(s/n)
```

Si responde "s":
- Por cada carpeta, preguntar: "¿Nuevo nombre para [carpeta]? (Enter para mantener)"
- Guardar mapeo: `carpeta_original → nuevo_nombre`

Si responde "n":
- Continuar a FASE 5 sin cambios

### PASO 4.2: Si eligió "Customizar" (agregar/quitar carpetas)

Mostrar:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
           🔧 CUSTOMIZAR ESTRUCTURA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Config base: [config_recomendada]
Carpetas actuales: [listar carpetas incluidas en la config]

Ahora puedes:
1. Agregar carpetas de la base completa
2. Quitar carpetas de las actuales
3. Cambiar nombres

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### Sub-paso 4.2.1: Agregar Carpetas

Determinar carpetas disponibles para agregar (las que NO están en la config):

```python
# Pseudocódigo:
base_completa = [
    "INBOX",
    "KNOWLEDGE", 
    "PROJECTS",
    "RECURSOS",
    "IDEAS",
    "CANVAS",
    "PRODUCTIVITY",
    "AGENT-MEMORIES",
    "_SYSTEM"
]

carpetas_config_actual = [leer del config elegido]
carpetas_disponibles = base_completa - carpetas_config_actual
```

Si hay carpetas disponibles, usar AskUserQuestion:
```
¿Qué carpetas AGREGAR?
(Recuerda la explicación de la Fase 1.5)

Disponibles:
```

Por cada carpeta disponible, mostrar:
```
[numero]. [NOMBRE]/ - [descripción breve de Fase 1.5]
```

Ejemplo:
```
1. KNOWLEDGE/ - Base de conocimiento por temas
2. RECURSOS/ - Papers, videos, libros
3. IDEAS/ - Brainstorming libre
4. CANVAS/ - Diagramas visuales
5. PRODUCTIVITY/ - Daily notes, kanban
6. AGENT-MEMORIES/ - Memoria de Claude
7. Ninguna (continuar sin agregar)
```

Preguntar: "Ingresa números separados por coma (ej: 1,2,5) o '7' para ninguna:"

Parsear respuesta y agregar carpetas elegidas a la lista.

#### Sub-paso 4.2.2: Quitar Carpetas

Mostrar carpetas actuales (incluyendo las recién agregadas):

```
Config actualizada:
✅ [carpeta1]/
✅ [carpeta2]/
✅ [carpeta3]/
[... todas las carpetas actuales ...]
```

Usar AskUserQuestion:
```
¿Quieres QUITAR alguna carpeta? (s/n)
```

Si responde "s":
- Enumerar carpetas actuales
- Preguntar: "¿Cuál(es) quitar? (números separados por coma)"
- Remover carpetas elegidas

**Validación importante:**
- No permitir quitar _SYSTEM/ (es necesaria)
- Si quedan menos de 2 carpetas, advertir:
  ```
  ⚠️  Advertencia: Solo quedan [N] carpetas.
  Un vault necesita al menos INBOX o PROJECTS para ser funcional.
  ¿Seguro que quieres continuar? (s/n)
  ```

#### Sub-paso 4.2.3: Cambiar Nombres

Preguntar igual que en PASO 4.1:
```
¿Quieres cambiar los NOMBRES de las carpetas? (s/n)
```

Si "s", por cada carpeta:
```
Carpeta: [CARPETA_ACTUAL]/
Nuevo nombre (Enter para mantener): _____
```

Guardar mapeo de nombres.

#### Sub-paso 4.2.4: Confirmar Customización

Mostrar resumen final:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
           📋 RESUMEN DE TU CONFIGURACIÓN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Carpetas que se crearán:
  ✅ CAPTURA/ (antes: INBOX)
  ✅ MIS-PROYECTOS/ (antes: PROJECTS)
  ✅ CONOCIMIENTO/ (agregada)
  ✅ _SYSTEM/ (requerida)

Carpetas NO incluidas:
  ❌ RECURSOS/
  ❌ IDEAS/
  ❌ CANVAS/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

¿Confirmar esta estructura? (s/n/editar)
```

- Si "s": continuar a FASE 5
- Si "n": cancelar wizard
- Si "editar": volver a Sub-paso 4.2.1

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 5: Customizar Workflows
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mostrar:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        ⚙️  PASO 5: Configurar Automatizaciones
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ahora vamos a configurar CÓMO trabajará Claude en tu vault.
```

### Pregunta 1: Auto-clasificación de notas

Si el vault tiene INBOX, preguntar:

Usar AskUserQuestion:
```
Cuando proceses INBOX (con /process-inbox), ¿cómo quieres clasificar?

1. Automático - Claude clasifica basado en contenido (ADHD-friendly)
2. Manual - Claude pregunta siempre antes de mover

¿Cuál prefieres? (1/2)
```

Guardar en variable: `auto_classify = true/false`

### Pregunta 2: Hooks (Automatizaciones)

Mostrar explicación:
```
Los "hooks" son automatizaciones que se activan en ciertos momentos:

• session-start: Resumen al abrir Claude (ej: "Tienes 3 notas en INBOX")
• session-end: Auto-guarda contexto al cerrar ⭐ (ADHD feature)
• frontmatter-helper: Sugiere metadata al crear notas
• link-suggester: Sugiere conexiones entre notas
```

Leer config recomendada para ver hooks sugeridos:

```
Config [config_recomendada] recomienda estos hooks:
[listar hooks de la config]

¿Quieres usar estos hooks recomendados? (s/n/customizar)
```

Si responde "s":
- Usar hooks de la config tal cual

Si responde "n":
- `hooks = []` (sin hooks)

Si responde "customizar":
- Mostrar cada hook individualmente:
  ```
  ¿Activar "session-start" (resumen al iniciar)? (s/n)
  ¿Activar "session-end" (auto-guarda contexto)? (s/n)
  ¿Activar "frontmatter-helper" (sugiere metadata)? (s/n)
  ¿Activar "link-suggester" (sugiere conexiones)? (s/n)
  ```

Guardar lista de hooks elegidos.

### Pregunta 3: Dashboard Visual (Canvas)

Si el vault tiene PROJECTS, preguntar:

```
¿Generar dashboard visual (Canvas) con tus proyectos y próximos pasos?

El dashboard se actualiza automáticamente con /project-status --canvas

(s/n)
```

Guardar en variable: `canvas_dashboard = true/false`

### Pregunta 4: Frontmatter Schema

Mostrar:
```
El "frontmatter" es metadata al inicio de cada nota (YAML).

Opciones:
1. Simple - Solo 4 campos (id, created, tipo, estado)
2. Detallado - 8 campos (+ disciplinas, proyectos, tags, tiene-todos)

¿Cuál prefieres? (1/2)
```

Guardar en variable: `frontmatter_type = "simple"/"detailed"`

### Resumen de Workflows

Mostrar:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
           📋 RESUMEN DE CONFIGURACIÓN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Workflows:
  • Auto-clasificación: [Sí/No]
  • Dashboard Canvas: [Sí/No]

Hooks activos ([N]):
  [listar hooks elegidos]

Frontmatter:
  [Simple/Detallado]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

¿Todo correcto? (s/n/editar)
```

Si "editar", volver a Pregunta 1.
Si "s", continuar a FASE 6.

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 6: Generar y Aplicar Configuración
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mostrar:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        🔨 PASO 6: Creando tu vault...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Esto tomará unos segundos...
```

### PASO 6.1: Crear Directorio .claude/

```bash
mkdir -p .claude/hooks
```

### PASO 6.2: Generar vault-config.yml

Basado en todas las respuestas, generar el archivo YAML:

```yaml
vault_name: "Mi Vault Personalizado"
version: "1.0"
generated_by: "obsidian-plugin-wizard"
generated_date: "2026-01-12"

folders:
  inbox: "[nombre_inbox o INBOX]/"
  projects: "[nombre_projects o PROJECTS]/"
  knowledge: "[nombre_knowledge o null]/"
  recursos: "[nombre_recursos o null]/"
  ideas: "[nombre_ideas o null]/"
  canvas: "[nombre_canvas o null]/"
  productivity: "[nombre_productivity or null]/"
  agent_memories: "[nombre_agent_memories o null]/"
  system: "_SYSTEM/"

categories:
  # Si es francovault o tiene KNOWLEDGE
  [agregar categorías si aplica]

workflows:
  inbox:
    auto_classify: [true/false según Fase 5]
    batch_mode: [true si auto_classify, false si no]
    
  canvas:
    enabled: [true/false según Fase 5]

frontmatter_schema:
  required_fields:
    - id
    - created
    - tipo
    - estado
  optional_fields:
    # Si frontmatter_type == "detailed"
    - disciplinas
    - proyectos
    - tags
    - tiene-todos

automation_level: "[minimal/medium/high según elección]"

# Metadata para comandos
preferences:
  verbosity: "[casual si ADHD, technical si francovault, balanced default]"
  confirmation_prompts: [true si auto_classify=false, false si true]
  language: "$LANGUAGE"
```

Usar Write para crear `.claude/vault-config.yml`

### PASO 6.3: Generar Scripts de Hooks

**IMPORTANTE:** SessionStart y SessionEnd hooks usan scripts bash, NO prompts.

#### Si eligió session hooks:

1. **Crear directorio de hooks:**
```bash
mkdir -p .claude/hooks
```

2. **Copiar template session-start.sh:**
```bash
# Leer template
Read([plugin-dir]/templates/hooks/session-start.sh)

# Reemplazar {{CONTEXT_FOLDER}} con el nombre real
# Guardar en .claude/hooks/session-start.sh
Write(".claude/hooks/session-start.sh", $SESSION_START_CONTENT)

# Dar permisos de ejecución
Execute("chmod +x .claude/hooks/session-start.sh")
```

3. **Copiar template session-end.sh:**
```bash
# Leer template
Read([plugin-dir]/templates/hooks/session-end.sh)

# Reemplazar {{CONTEXT_FOLDER}} con el nombre real
# Guardar en .claude/hooks/session-end.sh
Write(".claude/hooks/session-end.sh", $SESSION_END_CONTENT)

# Dar permisos de ejecución
Execute("chmod +x .claude/hooks/session-end.sh")
```

### PASO 6.4: Generar hooks.json

Basado en hooks elegidos en Fase 5:

```json
{
  "hooks": {
    // Si eligió session-start:
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-start.sh"
          }
        ]
      }
    ],
    
    // Si eligió session-end:
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-end.sh"
          }
        ]
      }
    ],
    
    // OPCIONAL: Si eligió smart-save (ADHD feature):
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Analyze the user's last message. If it contains farewell words like 'adiós', 'hasta luego', 'me voy', 'bye', 'goodbye', etc., generate a session summary with this format:\n\n## Session Summary\n\n**Date:** [date]\n**Worked on:** [project/task]\n\n### ✅ Accomplishments\n- [list achievements]\n\n### 🎯 Next Step\n[Exact description of next step]\n\n### 🧠 Important Context\n[Context to remember for next session]\n\nSave this summary to [CONTEXT_FOLDER]/sessions/[date].md AND update [CONTEXT_FOLDER]/LAST_SESSION.md.\n\nIf NO farewell detected, do nothing (continue normally)."
          }
        ]
      }
    ],
    
    // Si eligió frontmatter-helper:
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "If a .md file was created WITHOUT valid frontmatter, suggest briefly: '💡 Suggestion: [show frontmatter based on vault-config.yml]. Add it? (y/n)'. If it already has frontmatter, do nothing."
          }
        ]
      }
    ],
    
    // Si eligió link-suggester (agregar a PostToolUse existente):
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "If a NEW note was created in KNOWLEDGE/ or PROJECTS/, extract 2-3 key terms and use Grep to find related notes (max 3 searches). If matches found: '🔗 Possible connections: [[note1]], [[note2]]'. Maximum 2 lines."
          }
        ]
      }
    ]
  }
}
```

Usar Write para crear `.claude/hooks/hooks.json`

**CRÍTICO:** 
- Reemplazar `[CONTEXT_FOLDER]` en el prompt de Stop con el nombre real de la carpeta
- SessionStart y SessionEnd DEBEN usar `type: "command"` con scripts bash
- Stop puede usar `type: "prompt"` para detección inteligente

### PASO 6.4: Crear Estructura de Carpetas

Por cada carpeta elegida (con nombres customizados si aplica):

```bash
mkdir -p "[nombre_carpeta]"
```

Carpetas especiales:
```bash
# Si tiene INBOX:
mkdir -p "[INBOX]/_quick-notes"

# Si tiene PRODUCTIVITY:
mkdir -p "[PRODUCTIVITY]/daily-notes"

# Si tiene _CONTEXT (ADHD):
mkdir -p "_CONTEXT/sessions"

# Si tiene KNOWLEDGE y tiene categorías:
for categoria in [categorias]:
  mkdir -p "[KNOWLEDGE]/$categoria"

# Siempre crear:
mkdir -p "_SYSTEM/templates"
```

### PASO 6.5: Copiar Templates

Determinar qué templates copiar según la config base:

```bash
# Templates base siempre:
cp FranEscob/plugins/obsidian-plugin/templates/[config_base]/daily-note.md _SYSTEM/templates/
cp FranEscob/plugins/obsidian-plugin/templates/[config_base]/quick-note.md _SYSTEM/templates/

# Si config es creative-adhd:
cp FranEscob/plugins/obsidian-plugin/templates/creative-adhd/*.md _SYSTEM/templates/

# Si config es francovault:
cp FranEscob/plugins/obsidian-plugin/templates/francovault/*.md _SYSTEM/templates/

# Si config es researcher:
cp FranEscob/plugins/obsidian-plugin/templates/francovault/note-estudio.md _SYSTEM/templates/
cp FranEscob/plugins/obsidian-plugin/templates/francovault/note-recurso.md _SYSTEM/templates/
```

**Nota:** Adaptar paths en templates si se cambiaron nombres de carpetas.

### PASO 6.6: Progreso Visual

Mientras se ejecutan los pasos, mostrar progreso:

```
[1/6] ✅ Configuración generada (.claude/vault-config.yml)
[2/6] ✅ Hooks configurados (.claude/hooks/hooks.json)
[3/6] ✅ Carpetas creadas (5 carpetas)
[4/6] ✅ Subcarpetas configuradas
[5/6] ✅ Templates copiados (6 archivos)
[6/6] ✅ Configuración aplicada
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 7: Confirmación + Tutorial
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### PASO 7.1: Generar Archivo BIENVENIDA.md

Crear archivo personalizado en la raíz del vault:

```markdown
---
id: bienvenida-vault
created: [FECHA_HOY]
tipo: recurso
estado: activo
---

# 👋 Bienvenida a tu Vault

Este vault está configurado con **[Config Elegida]**.

## 📁 Tu Estructura

[Listar carpetas creadas con su propósito]

## 🔄 Cómo Trabajar

### 1. Captura Rápida
Tienes una idea → Abre [INBOX]/_quick-notes/ → Crea nota.md
No te preocupes por organizar, solo escribe.

### 2. Procesar [Si tiene INBOX]
Comando: `/process-inbox`
Claude lee tus notas y las [clasifica automáticamente / te pregunta dónde moverlas].

### 3. Trabajar en Proyectos [Si tiene PROJECTS]
Comando: `/new-project "nombre"`
Claude crea estructura + brief + research opcional.

### 4. Ver Progreso [Si tiene PROJECTS]
Comando: `/project-status nombre`
Claude muestra tasks, progreso, next steps.

## ⭐ Features Especiales

[Si tiene session-end hook:]
### Memoria Persistente

Tu config tiene **session-end hook** activado.

¿Qué hace?
- Al terminar sesión, Claude guarda contexto automáticamente
- Próxima sesión, Claude muestra exactamente dónde quedaste
- NUNCA pierdes el hilo 🎯

Archivos guardados en: [CONTEXT_FOLDER]/sessions/

[Si tiene canvas_dashboard:]
### Dashboard Visual

Tu vault puede generar dashboards Canvas automáticos:
- Comando: `/project-status nombre --canvas`
- Crea visualización de proyectos, tasks, y próximos pasos

[Si tiene frontmatter simple:]
### Frontmatter Simple

Tus notas usan metadata mínima (4 campos):
- id, created, tipo, estado
- Sin complejidad innecesaria

## 📋 Próximos Pasos

1. [ ] `/daily-note` - Crea tu nota del día
2. [ ] `/new-project "Tu Proyecto"` - Crea tu primer proyecto
3. [ ] Captura 3 ideas en [INBOX]/_quick-notes/
4. [ ] `/process-inbox` - Clasifica tus ideas

## 🆘 Ayuda

**Comandos disponibles:**
- `/daily-note` - Nota diaria con contexto
- `/new-project "nombre"` - Nuevo proyecto
- `/process-inbox` - Organizar inbox
- `/project-status nombre` - Ver progreso

**¿Preguntas?** 
Pregúntame a Claude directamente. Estoy aquí para ayudarte.

---

*Generado por /setup-vault - [Config] - [Fecha]*
```

Usar Write para crear `BIENVENIDA.md`

### PASO 7.2: Mostrar Confirmación Detallada

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            ✅ CONFIGURACIÓN COMPLETADA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Tu vault está listo para usar!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                ARCHIVOS CREADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Configuración:
  ✅ .claude/vault-config.yml (tu configuración)
  ✅ .claude/hooks/hooks.json ([N] hooks activos)

Carpetas ([N] creadas):
  [Listar cada carpeta con emoji]

Templates ([N] archivos):
  ✅ _SYSTEM/templates/daily-note.md
  ✅ _SYSTEM/templates/quick-note.md
  [... otros templates ...]

Documentación:
  ✅ BIENVENIDA.md (tutorial interactivo)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
               COMANDOS DISPONIBLES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Listar comandos relevantes según carpetas]

/daily-note
  Crea tu nota del día con contexto automático

/new-project "nombre"
  Crea un nuevo proyecto con estructura

/process-inbox
  Organiza todas las notas de [INBOX]/

/project-status nombre
  Ve el progreso de un proyecto

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
             TU PRIMER DÍA - TUTORIAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Paso 1: Crear tu daily note
   Comando: /daily-note
   → Esto crea tu nota del día y muestra contexto

Paso 2: Crear tu primer proyecto
   Comando: /new-project "Mi Primer Proyecto"
   → Claude te guiará con preguntas

Paso 3: Capturar una idea rápida
   Abre: [INBOX]/_quick-notes/
   Crea: mi-idea.md
   Escribe lo que se te ocurra (sin frontmatter, sin reglas)

Paso 4: Procesar inbox
   Comando: /process-inbox
   → Claude [clasificará automáticamente / te preguntará]

[Si tiene session-end hook:]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ⭐ FEATURE ESPECIAL: AUTO-SAVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Al terminar tu sesión con Claude:
1. Claude preguntará: "¿Notas antes de terminar?"
2. Escribe brevemente qué hiciste
3. Claude guardará automáticamente en:
   [CONTEXT_FOLDER]/sessions/[FECHA].md

Próxima sesión:
1. Claude mostrará automáticamente:
   "La última vez estabas trabajando en X..."
2. NUNCA pierdes el contexto ⭐

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Tip: Lee BIENVENIDA.md para tutorial completo

🎉 ¡Disfruta tu nuevo vault!
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 7.5: Generar Instrucciones para Agentes
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### PASO 7.5.1: Cargar Template

1. **Leer template base:**
```bash
Read([plugin-dir]/templates/agent-instructions/CLAUDE.md.template)
```

2. **Guardar contenido en variable** `$TEMPLATE`

### PASO 7.5.2: Preparar Datos Dinámicos

**Recopilar información generada en fases anteriores:**

```python
# Datos del vault-config.yml generado
vault_data = {
    # Básicos
    "VAULT_NAME": [nombre del directorio del vault, ej: "FrancoVault"],
    "VAULT_PATH": [ruta absoluta, usar pwd],
    "CONFIG_NAME": [nombre elegido: "FrancoVault Full" / "Minimal Setup" / "Creative ADHD" / "Academic Researcher"],
    "DATE": "YYYY-MM-DD" [fecha actual],
    
    # Carpetas (usar nombres EXACTOS del vault-config.yml)
    "FOLDER_TREE": """├── $INBOX_FOLDER/_quick-notes/
├── $KNOWLEDGE_FOLDER/
├── $PROJECTS_FOLDER/
├── $IDEAS_FOLDER/
├── $RECURSOS_FOLDER/
├── $PRODUCTIVITY_FOLDER/
├── $CANVAS_FOLDER/
[Si ADHD: ├── $CONTEXT_FOLDER/sessions/]
[Si tiene: ├── $AGENT_MEMORIES_FOLDER/]""",
    
    "FOLDER_DETAILS": """**$INBOX_FOLDER/_quick-notes/**
- Purpose: Quick capture for unprocessed notes
- Usage: Drop ideas here without thinking about organization
[Si auto_classify: - ⚡ Auto-processed by `/process-inbox` (no confirmations)]

**$KNOWLEDGE_FOLDER/**
- Purpose: [Descripción según config]
- Usage: Organized knowledge by [categories/disciplines]

[... para cada carpeta del config...]""",
    
    # Comportamientos especiales
    "ADHD_WARNING": [Si creative-adhd config:]
"""**⚠️ ADHD-Optimized Vault:**
- Auto-classification is ENABLED (no confirmations needed)
- Session context is AUTO-SAVED after each session (never lose track)
- Maximum automation, zero friction workflows"""
[sino: ""],
    
    "INBOX_BEHAVIOR": [Si auto_classify true:]
"⚡ Auto-classifies without asking when config has auto_classify: true (ADHD mode)"
[sino:]
"Shows classification table and asks for confirmation before moving",
    
    "CANVAS_BEHAVIOR": [Si canvas enabled:]
"Can generate visual dashboards with --canvas flag. Saves to $CANVAS_FOLDER/"
[sino:]
"Canvas generation disabled in config",
    
    # Workflows
    "WORKFLOWS_SECTION": [Si auto_classify true:]
"""### 📥 Auto-Classification (ENABLED)

When you run `/process-inbox`:
- ❌ DO NOT ask for confirmation
- ✅ Automatically classify notes based on content analysis
- ✅ Move to correct destination folder
- ✅ Generate proper frontmatter
- ⚡ Zero friction workflow (ADHD-friendly)

**Classification logic:**
- Study/learning content → `$KNOWLEDGE_FOLDER/[category]/`
- Ideas and brainstorming → `$IDEAS_FOLDER/`
- Resources (videos, papers) → `$RECURSOS_FOLDER/[type]/`
- Project-specific notes → `$PROJECTS_FOLDER/[project-name]/`"""

[Si canvas enabled, agregar:]
"""
### 🎨 Canvas Dashboards (ENABLED)

`/project-status project-name --canvas` generates visual project dashboards:
- Saved to: `$CANVAS_FOLDER/[project]-dashboard.canvas`
- Shows: project progress, active tasks, next steps
- Auto-updates each time you run the command
- Open in Obsidian to see visual diagram"""

[Si session-end hook, agregar:]
"""
### 💾 Session Context Auto-Save (ENABLED) ⭐

**ADHD Feature - Never Lose Your Train of Thought:**

When you end a Claude session:
1. Claude asks: "Notes before we finish?"
2. Automatically generates comprehensive session summary
3. Saves to: `$CONTEXT_FOLDER/sessions/YYYY-MM-DD.md`
4. Updates: `$CONTEXT_FOLDER/LAST_SESSION.md` with latest context

Next session:
- Claude reads LAST_SESSION.md automatically
- Shows: "Last time you were working on [X]..."
- Exact next step preserved
- **You NEVER lose context between sessions** 🎯"""

[Sino workflows mínimos:]
"""### 📥 Manual Classification

When you run `/process-inbox`:
- Shows classification table with suggested destinations
- Asks: "Proceed with this classification? (y/n/edit)"
- You confirm before any notes are moved
- Full control over organization""",
    
    # Frontmatter
    "FRONTMATTER_SCHEMA": [Si simple/minimal:]
"""id: note-title
created: YYYY-MM-DD
tipo: proyecto | estudio | recurso | idea | daily
estado: activo | archivado | draft"""

[Si detailed/francovault:]
"""id: tipo-descripcion-corta
created: YYYY-MM-DD
modified: YYYY-MM-DD
tipo: estudio | proyecto | recurso | idea | daily | review
estado: activo | archivado | draft | en-revision
disciplinas: [IA-ML, Electronica, ...]
proyectos: [ProjectName, ...]
tags: [tag1, tag2]
tiene-todos: false""",
    
    "FRONTMATTER_RULES": [Si detailed:]
"- Set `tiene-todos: true` if note contains TODO checkboxes\n- Use `disciplinas` array for knowledge categorization\n- Use `proyectos` array to link to active projects"
[sino: ""],
    
    # Búsquedas
    "EXAMPLE_FOLDER": $KNOWLEDGE_FOLDER [o primera carpeta que exista],
    "EXAMPLE_TYPE": "estudio" [o primer tipo del frontmatter],
    
    "SEARCH_PATTERNS": [Si tiene projects:]
"| By project | `grep \"proyectos:.*ProjectName\" --type md` |"
[Si tiene categories/disciplinas:]
"| By category | `grep \"disciplinas:.*CategoryName\" --type md` |"
[Si tiene tiene-todos:]
"| Notes with TODOs | `grep \"tiene-todos: true\" --type md` |",
    
    # Agent Memory
    "AGENT_MEMORY_SECTION": [Si tiene agent_memories folder:]
"""## 🧠 AGENT MEMORY

**Location:** `$AGENT_MEMORIES_FOLDER/`

### When to Save Memories
- Research findings that required significant effort
- User preferences and workflow discoveries
- Architectural decisions and their rationale
- Solutions to complex problems
- Work in progress to resume in future sessions

### When to Consult Memories
- Before starting research on a topic
- When resuming work from previous sessions
- When user asks questions that might have been answered before

### Search Memories
```bash
# View memory categories
ls $AGENT_MEMORIES_FOLDER/

# Search by summary (fast)
grep "^summary:.*keyword" "$AGENT_MEMORIES_FOLDER/" -r -i

# Search full content
grep "keyword" "$AGENT_MEMORIES_FOLDER/" -r -i
```

### Create Memory
```bash
mkdir -p $AGENT_MEMORIES_FOLDER/category/
# Create .md file with frontmatter: summary, created, tags
```"""
[Sino:]
"""## 🧠 AGENT MEMORY

**Note:** This vault doesn't have a dedicated agent memory folder.

Consider using `$PRODUCTIVITY_FOLDER/` or [context folder si existe] for session notes and persistent context.""",
    
    # Hooks
    "HOOKS_SECTION": [Si tiene session hooks activos:]
"""### 📥 SessionStart Hook (ENABLED)

**How it works:**
1. When you open Claude Code, a bash script runs automatically
2. It reads `{{context_folder}}/LAST_SESSION.md`  
3. The content is injected SILENTLY into Claude's context
4. **When you send your first message**, Claude already has this context loaded

**Example flow:**
```
You: "hello"

Claude: "🌅 Hello! I see from the last session you were working on AppSalud.
         You had created the database models. The next step was to add
         email validation to the User model. Should we continue?"
```

**Important:**
- Claude does NOT respond automatically when you open
- Context is loaded SILENTLY in the background
- Your first message triggers the response with context

### 💾 SessionEnd Hook (ENABLED)

**How it works:**
1. When you close Claude Code (/exit, Ctrl+C), a bash script runs automatically
2. It saves a timestamp to `{{context_folder}}/sessions/YYYY-MM-DD.md`
3. It updates `{{context_folder}}/LAST_SESSION.md` for next session

**For best results:**
BEFORE closing, ask Claude:
```
"Summarize what we worked on today and what the exact next step is"
```

Claude will generate a complete summary that gets saved automatically.

[Si tiene Stop hook:]
### ⚡ Smart Save Hook (ENABLED) ⭐

**How it works:**
When you say farewell words like "adiós", "goodbye", "bye", "me voy", etc.:
1. Claude automatically detects you're about to close
2. Generates a session summary automatically
3. Saves it to `{{context_folder}}/sessions/` and `LAST_SESSION.md`
4. Confirms: "✅ Summary saved!"

**Simply say "goodbye" and Claude does everything.**

### 💡 Recommended Flow

1. **When starting:** Say "hello" or any message
   → Claude shows you where you left off

2. **While working:** Use commands normally
   → Example: `/new-project`, `/process-inbox`

3. **When finishing:** Say "goodbye" or "me voy"
   → Claude generates and saves summary automatically

4. **Next session:** Say "hello"
   → Claude shows exactly where you left off"""
[Sino:]
"""No session hooks configured for this vault.

To enable session context preservation:
- Re-run `/setup-vault` and choose session hooks
- Or manually configure hooks in `.claude/hooks/hooks.json`""",
    
    # Main Workflows
    "MAIN_WORKFLOWS": """### Process Inbox

**Command:** `/process-inbox`

**Steps:**
1. Read notes in `$INBOX_FOLDER/_quick-notes/`
2. Analyze content → determine type, category, project
3. Generate appropriate frontmatter
4. [Si auto: Move automatically | Sino: Show table and ask confirmation]
5. Report results

[Si auto_classify:]
**Automation:** Auto-classification enabled (no confirmations)

### Create Daily Note

**Command:** `/daily-note`

**Steps:**
1. Generate date: YYYY-MM-DD
2. Create in: `$PRODUCTIVITY_FOLDER/daily-notes/YYYY/MM-MONTH/`
3. Include context from inbox
4. Show recent activity
5. Set up daily tasks section

[Si tiene projects:]
### New Project

**Command:** `/new-project "project-name"`

**Steps:**
1. Create project folder in `$PROJECTS_FOLDER/`
2. Generate README.md with project brief
3. [Si research enabled: Optional research phase]
4. Create initial structure
5. Link to productivity dashboard

### Project Status

**Command:** `/project-status project-name`

**Steps:**
1. Read project README and notes
2. Extract tasks and progress
3. Analyze next steps
4. [Si canvas: Generate visual dashboard with --canvas flag]
5. Show comprehensive report
""",
    
    # Content Mappings
    "CONTENT_MAPPINGS": [Dinámico según carpetas:]
"""| Content Type | Location |
|--------------|----------|
| Study notes | `$KNOWLEDGE_FOLDER/[category]/` |
| Quick ideas | `$INBOX_FOLDER/_quick-notes/` |
[Si projects: | Project files | `$PROJECTS_FOLDER/[project-name]/` |]
[Si ideas: | Brainstorming | `$IDEAS_FOLDER/` |]
[Si recursos: | Papers/Videos | `$RECURSOS_FOLDER/[type]/` |]
| Daily notes | `$PRODUCTIVITY_FOLDER/daily-notes/` |
[Si canvas: | Diagrams | `$CANVAS_FOLDER/` |]
[Si agent_memories: | Agent memories | `$AGENT_MEMORIES_FOLDER/[category]/` |]""",
    
    # Additional Rules
    "ADDITIONAL_RULES": [Si tiene agent_memories:]
"6. **Save useful findings** to $AGENT_MEMORIES_FOLDER/ for future reference"
[Si auto_classify:]
"6. **Trust auto-classification** - it's enabled for a reason (reduces friction)"
[sino: ""],
    
    # Troubleshooting
    "TROUBLESHOOTING_CONTEXT": [Si tiene session-end hook:]
"""
### If you lose context between sessions:
- Check `$CONTEXT_FOLDER/LAST_SESSION.md` for latest summary
- Review `$CONTEXT_FOLDER/sessions/` folder for historical context
- Session summaries are automatically generated on exit"""
[sino:]
"""
### If you lose context:
- Consider re-running `/setup-vault` and enabling session hooks
- Use `/daily-note` to maintain daily context
- Keep active work notes in `$PRODUCTIVITY_FOLDER/`""",
    
    # Settings
    "AUTOMATION_LEVEL": [minimal/medium/high según config],
    "AUTO_CLASSIFY": [true/false],
    "CANVAS_ENABLED": [true/false],
    "FRONTMATTER_TYPE": [simple/detailed]
}
```

### PASO 7.5.3: Renderizar Template

**Proceso de reemplazo:**

1. Copiar `$TEMPLATE` a `$RENDERED`

2. Reemplazar todos los placeholders:
```python
# Reemplazos directos
$RENDERED = str_replace($RENDERED, "{{VAULT_NAME}}", vault_data["VAULT_NAME"])
$RENDERED = str_replace($RENDERED, "{{CONFIG_NAME}}", vault_data["CONFIG_NAME"])
$RENDERED = str_replace($RENDERED, "{{DATE}}", vault_data["DATE"])
$RENDERED = str_replace($RENDERED, "{{VAULT_PATH}}", vault_data["VAULT_PATH"])

# Folders
$RENDERED = str_replace($RENDERED, "{{FOLDER_TREE}}", vault_data["FOLDER_TREE"])
$RENDERED = str_replace($RENDERED, "{{FOLDER_DETAILS}}", vault_data["FOLDER_DETAILS"])
$RENDERED = str_replace($RENDERED, "{{EXAMPLE_FOLDER}}", vault_data["EXAMPLE_FOLDER"])

# Warnings y behaviors
$RENDERED = str_replace($RENDERED, "{{ADHD_WARNING}}", vault_data["ADHD_WARNING"])
$RENDERED = str_replace($RENDERED, "{{INBOX_BEHAVIOR}}", vault_data["INBOX_BEHAVIOR"])
$RENDERED = str_replace($RENDERED, "{{CANVAS_BEHAVIOR}}", vault_data["CANVAS_BEHAVIOR"])

# Sections dinámicas
$RENDERED = str_replace($RENDERED, "{{WORKFLOWS_SECTION}}", vault_data["WORKFLOWS_SECTION"])
$RENDERED = str_replace($RENDERED, "{{FRONTMATTER_SCHEMA}}", vault_data["FRONTMATTER_SCHEMA"])
$RENDERED = str_replace($RENDERED, "{{FRONTMATTER_RULES}}", vault_data["FRONTMATTER_RULES"])
$RENDERED = str_replace($RENDERED, "{{AGENT_MEMORY_SECTION}}", vault_data["AGENT_MEMORY_SECTION"])
$RENDERED = str_replace($RENDERED, "{{HOOKS_SECTION}}", vault_data["HOOKS_SECTION"])
$RENDERED = str_replace($RENDERED, "{{MAIN_WORKFLOWS}}", vault_data["MAIN_WORKFLOWS"])
$RENDERED = str_replace($RENDERED, "{{CONTENT_MAPPINGS}}", vault_data["CONTENT_MAPPINGS"])

# Search patterns
$RENDERED = str_replace($RENDERED, "{{EXAMPLE_TYPE}}", vault_data["EXAMPLE_TYPE"])
$RENDERED = str_replace($RENDERED, "{{SEARCH_PATTERNS}}", vault_data["SEARCH_PATTERNS"])

# Rules y troubleshooting
$RENDERED = str_replace($RENDERED, "{{ADDITIONAL_RULES}}", vault_data["ADDITIONAL_RULES"])
$RENDERED = str_replace($RENDERED, "{{TROUBLESHOOTING_CONTEXT}}", vault_data["TROUBLESHOOTING_CONTEXT"])

# Settings
$RENDERED = str_replace($RENDERED, "{{AUTOMATION_LEVEL}}", vault_data["AUTOMATION_LEVEL"])
$RENDERED = str_replace($RENDERED, "{{AUTO_CLASSIFY}}", vault_data["AUTO_CLASSIFY"])
$RENDERED = str_replace($RENDERED, "{{CANVAS_ENABLED}}", vault_data["CANVAS_ENABLED"])
$RENDERED = str_replace($RENDERED, "{{FRONTMATTER_TYPE}}", vault_data["FRONTMATTER_TYPE"])
```

3. **Limpiar líneas vacías excesivas** (más de 2 seguidas)

4. **Resultado:** CLAUDE.md completo y personalizado

### PASO 7.5.4: Escribir CLAUDE.md

```bash
# Guardar en la raíz del vault
Write("CLAUDE.md", $RENDERED)
```

**Confirmar creación:**
```
✅ CLAUDE.md creado en la raíz del vault
   (Instrucciones personalizadas para agentes IA)
```

### PASO 7.5.5: Preguntar por AGENTS.md

Usar AskUserQuestion:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

¿Usarás otros agentes de IA además de Claude Code?

Ejemplos: Cursor, Windsurf, Cline, Aider, Continue, etc.

Si dices "sí", crearemos AGENTS.md (copia de CLAUDE.md)
para que todos los agentes tengan las mismas instrucciones.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Respuesta (s/n):
```

**Si responde "s" o "S" o "yes" o "sí":**
```bash
# Copiar CLAUDE.md → AGENTS.md
cp CLAUDE.md AGENTS.md
echo "✅ AGENTS.md creado (copia idéntica de CLAUDE.md)"
echo "   Otros agentes podrán leer las mismas instrucciones"
```

**Si responde "n" o "N" o "no":**
```bash
echo "Solo CLAUDE.md creado."
echo "💡 Tip: Puedes crear AGENTS.md después con: cp CLAUDE.md AGENTS.md"
```

### PASO 7.5.6: Reportar

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        📖 INSTRUCCIONES PARA AGENTES GENERADAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ CLAUDE.md creado en la raíz del vault
[Si AGENTS.md creado:]
✅ AGENTS.md creado (para otros agentes IA)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
           ¿QUÉ CONTIENEN ESTOS ARCHIVOS?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Estructura de tu vault (con nombres exactos de carpetas)
🛠️  Comandos disponibles y cómo usarlos
⚙️  Workflows y automatizaciones activas
📝 Frontmatter schema personalizado
🔍 Patrones de búsqueda optimizados
⚠️  Reglas importantes y buenas prácticas
🎯 Workflows principales explicados

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                  ¿CÓMO FUNCIONA?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claude Code lee CLAUDE.md automáticamente al iniciar
cada sesión en este directorio.

[Si AGENTS.md:]
Otros agentes (Cursor, Windsurf, etc.) pueden leer
AGENTS.md para tener el mismo contexto.

Esto asegura que los agentes:
- Conozcan tu estructura de carpetas
- Usen los comandos correctamente
- Respeten tus preferencias de automatización
- Sigan tu schema de frontmatter
- Entiendan tus workflows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Puedes editar CLAUDE.md manualmente si quieres
   agregar instrucciones personalizadas adicionales.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 8: Post-Setup Opcional
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usar AskUserQuestion:
```
¿Quieres que te guíe en tu primera daily note ahora? (s/n)
```

Si responde "s":
```
Perfecto, vamos a crear tu primera daily note...

[Ejecutar internamente /daily-note]
```

Usar el comando `/daily-note` (si está implementado) o simular su comportamiento:
1. Crear carpeta para hoy
2. Generar daily note con template
3. Mostrar la nota creada

Si responde "n":
```
Perfecto! Cuando estés listo, ejecuta /daily-note

Recuerda: Claude está aquí para ayudarte en cada paso.
```

---

## MANEJO DE ERRORES

### Error: Vault no vacío
```
⚠️  Este vault tiene [N] archivos markdown.
/setup-vault está diseñado para vaults nuevos.

Riesgo: Puede sobrescribir archivos existentes.

¿Continuar de todas formas? (s/n)
```

### Error: Ya existe .claude/vault-config.yml
```
⚠️  Ya existe configuración en .claude/vault-config.yml

Opciones:
1. Sobrescribir (perderás config actual)
2. Cancelar (mantener config actual)
3. Hacer backup primero

¿Qué hacer? (1/2/3)
```

Si elige "3":
```bash
mv .claude/vault-config.yml .claude/vault-config.yml.backup-[TIMESTAMP]
echo "✅ Backup creado: .claude/vault-config.yml.backup-[TIMESTAMP]"
```

### Error: No se puede crear carpeta
```bash
# Si mkdir falla:
echo "❌ Error al crear carpeta [nombre]"
echo "Verifica permisos de escritura en el vault"
exit 1
```

### Error: Template no encontrado
```
⚠️  No se encontró template: [template_path]
Continuando sin ese template...
```

---

## NOTAS FINALES

### Para el Desarrollador

Este wizard está diseñado para ser:
- **Educativo:** Explica antes de preguntar
- **Adaptativo:** Modifica config según respuestas
- **Iterativo:** Permite editar decisiones
- **Completo:** Genera todo lo necesario para empezar

### Próximos Pasos Post-Wizard

Después de implementar este wizard, los siguientes comandos necesitan:
1. Leer `.claude/vault-config.yml` para rutas dinámicas
2. Respetar el nivel de automatización elegido
3. Usar el frontmatter schema del config

Comandos a adaptar:
- `/daily-note` - Usar folders del config
- `/new-project` - Usar folders del config
- `/process-inbox` - Respetar auto_classify
- `/project-status` - Usar folders del config
- Y otros...

---

*Comando completado - Versión: 1.0 - 2026-01-12*
