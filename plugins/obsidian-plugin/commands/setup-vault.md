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

### PASO 0: Validación

1. Verifica que el vault esté vacío o casi vacío:
```bash
# Contar archivos .md en el vault
find . -maxdepth 2 -name "*.md" -type f | wc -l
```

2. Si hay más de 5 archivos .md, preguntar:
   ```
   Este vault parece tener contenido existente.
   /setup-vault está diseñado para vaults nuevos.
   
   ¿Continuar de todas formas? (s/n)
   ```

3. Si hay `.claude/vault-config.yml` existente:
   ```
   Ya existe una configuración en .claude/vault-config.yml
   
   Opciones:
   1. Reconfigurar (sobrescribe config actual)
   2. Cancelar y mantener config actual
   
   ¿Qué hacer? (1/2)
   ```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## FASE 1: Bienvenida + Contexto
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mostrar:

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

⏱️  Tiempo estimado: 5-7 minutos (8 pasos)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primero, déjame explicarte cómo funciona esto...
```

Usar AskUserQuestion: "¿Listo para empezar? (s/n)"

Si responde "n", terminar con: "Cuando estés listo, ejecuta /setup-vault nuevamente."

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
```

Usar Write para crear `.claude/vault-config.yml`

### PASO 6.3: Generar hooks.json

Basado en hooks elegidos en Fase 5:

```json
{
  "hooks": [
    // Si eligió session-start:
    {
      "event": "SessionStart",
      "type": "prompt",
      "prompt": "Al iniciar sesión, haz un resumen rápido del vault. Verifica: 1) Notas en [INBOX_NAME] usando Glob, 2) Si existe daily note para hoy, 3) Si hay tasks pendientes. Formato: '🌅 Resumen: • 📥 X notas en inbox • 📅 Daily note: [existe/no] • ⚠️ X tasks pendientes'. Solo UNA vez por sesión."
    },
    
    // Si eligió session-end:
    {
      "event": "Stop",
      "type": "prompt", 
      "prompt": "Antes de terminar la sesión: 1) Pregunta: '¿Quieres agregar notas antes de que guarde el contexto?', 2) Genera resumen de la sesión (qué se hizo, qué falta, próximo paso EXACTO), 3) Guarda en [CONTEXT_FOLDER]/sessions/YYYY-MM-DD.md usando template session.md, 4) Actualiza [CONTEXT_FOLDER]/LAST_SESSION.md. Usa formato markdown con frontmatter."
    },
    
    // Si eligió frontmatter-helper:
    {
      "event": "PostToolUse",
      "type": "prompt",
      "matcher": "Write",
      "prompt": "Si se creó archivo .md SIN frontmatter válido, sugerir brevemente: '💡 Sugerencia: [mostrar frontmatter según vault-config.yml]. ¿Agregar? (s/n)'. Si ya tiene frontmatter, no hacer nada."
    },
    
    // Si eligió link-suggester:
    {
      "event": "PostToolUse",
      "type": "prompt",
      "matcher": "Write",
      "prompt": "Si se creó nota NUEVA en KNOWLEDGE/ o PROJECTS/, extraer 2-3 términos clave y usar Grep para buscar notas relacionadas (máx 3 búsquedas). Si hay matches: '🔗 Posibles conexiones: [[nota1]], [[nota2]]'. Máximo 2 líneas."
    }
  ]
}
```

Usar Write para crear `.claude/hooks/hooks.json`

**Importante:** Reemplazar `[INBOX_NAME]`, `[CONTEXT_FOLDER]`, etc. con los nombres reales de las carpetas.

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
