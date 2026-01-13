---
description: "Muestra resumen completo del estado de un proyecto"
argument-hint: "<nombre-proyecto> [--detailed] [--update-readme] [--canvas]"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - AskUserQuestion
---

# Comando: /project-status

Muestra un resumen completo del estado de un proyecto, incluyendo progreso, tasks, notas relacionadas y proximos pasos sugeridos.

**NOTA:** Este comando lee `.claude/vault-config.yml` para:
- Ubicación de PROJECTS (puede ser personalizada)
- Si generar dashboard Canvas (workflows.canvas.enabled)
- Esquema de frontmatter

## Argumentos

- `<nombre-proyecto>` (requerido): Nombre del proyecto
- `--detailed`: Incluir contenido resumido de todas las notas del proyecto
- `--update-readme`: Actualizar el README.md del proyecto con el status generado
- `--canvas`: Generar dashboard visual en Canvas (si está habilitado en config)

## Instrucciones

### PASO 0: Leer configuración del vault

1. Verificar `.claude/vault-config.yml`:
```bash
cat .claude/vault-config.yml
```

2. Extraer valores:
```yaml
folders:
  projects: "PROJECTS/"
  knowledge: "KNOWLEDGE/"
  canvas: "CANVAS/"

workflows:
  canvas:
    enabled: true      # ⭐ Si es true, el flag --canvas funciona

categories: [...]      # Para agrupar notas relacionadas
```

3. Guardar en variables:
- `$PROJECTS_FOLDER`
- `$KNOWLEDGE_FOLDER`
- `$CANVAS_FOLDER`
- `$CANVAS_ENABLED` (true/false)
- `$CATEGORIES`

4. Si PROJECTS no existe, error:
   ```
   ❌ Este vault no tiene carpeta de proyectos configurada.
   ```

### PASO 1: Localizar proyecto

1. Busca en `$PROJECTS_FOLDER/` una carpeta que coincida con el nombre:
   - Match exacto primero
   - Match parcial si no hay exacto
2. Si no encuentra:
   - Lista proyectos disponibles con Glob: `$PROJECTS_FOLDER/*/`
   - Pregunta: "No encontre [nombre]. Proyectos disponibles: [lista]. Cual querias?"
3. Verifica que existe README.md en la carpeta del proyecto

### PASO 2: Escanear contenido del proyecto

1. Usa Glob para listar todos los .md en `$PROJECTS_FOLDER/[nombre]/`

2. Por cada archivo, lee y extrae:
   - Frontmatter (estado, tipo, tiene-todos)
   - Checkboxes: cuenta `- [ ]` (pendiente) y `- [x]` (completado)
   - Fecha de modificacion (del frontmatter `modified`)

3. Identifica archivos especiales:
   - `README.md` - Descripcion general
   - `Kanban.md` - Board de tareas
   - `BRIEF.md` - Brief del proyecto
   - Archivos `.canvas` - Diagramas (si `$CANVAS_FOLDER` existe)

4. Calcula estadisticas:
   - Total de notas
   - Tasks totales, pendientes, completadas
   - Porcentaje de progreso = (completadas / totales) * 100

### PASO 3: Buscar conocimiento relacionado

1. Usa Grep para buscar en `$KNOWLEDGE_FOLDER/` (si existe):
   ```
   proyectos:.*[nombre-proyecto]
   ```
   Esto encuentra notas en KNOWLEDGE/ que mencionan este proyecto.

2. Busca menciones del proyecto en todo el vault:
   ```
   [[$PROJECTS_FOLDER/[nombre]
   ```

3. Agrupa por disciplina/categoría (usar `$CATEGORIES` si existen):
   - IA-ML: [lista de notas]
   - Electronica: [lista de notas]
   - etc.

### PASO 4: Generar reporte

Genera el siguiente reporte estructurado:

```
======================================================
           ESTADO DEL PROYECTO: [NOMBRE]
======================================================

Ubicacion: $PROJECTS_FOLDER/[nombre]/

------------------------------------------------------
                    RESUMEN
------------------------------------------------------
Estado:          [emoji] [En progreso/Activo/Pausado/Completado]
Progreso:        [X]% ([completadas]/[total] tasks)
Ultima actividad: [fecha o "hace X dias"]
Notas:           [numero] archivos

------------------------------------------------------
                     TASKS
------------------------------------------------------
Pendientes ([numero]):
  - [ ] Task 1 (alta prioridad si >1 semana pendiente)
  - [ ] Task 2
  - [ ] Task 3
  ... (+N mas)

Completadas ([numero]):
  - [x] Task completada 1
  - [x] Task completada 2
  ... (mostrar últimas 5)

------------------------------------------------------
               NOTAS DEL PROYECTO
------------------------------------------------------
| Archivo              | Modificado  | Estado   |
|---------------------|-------------|----------|
| README.md           | 2026-01-09  | activo   |
| Kanban.md           | 2026-01-09  | activo   |
| architecture.md     | 2026-01-08  | draft    |

[Si $KNOWLEDGE_FOLDER existe:]
------------------------------------------------------
            CONOCIMIENTO RELACIONADO
------------------------------------------------------
Notas en $KNOWLEDGE_FOLDER/ que mencionan [proyecto]:

[Si $CATEGORIES existe, agrupar por categoría:]
IA-ML:
  - [[transformers]] - Para NLP del asistente
  - [[speech-recognition]] - STT options

Electronica:
  - [[jetson-nano]] - Hardware candidato

[Si no hay categorías, listar plano]

------------------------------------------------------
              PROXIMOS PASOS SUGERIDOS
------------------------------------------------------
1. [Task mas vieja pendiente] - pendiente hace [X] dias
2. [Nota en draft] - finalizar?
3. [Sugerencia basada en contenido]

======================================================
```

### PASO 5: Opciones post-reporte

Pregunta al usuario:
```
Opciones:
1. Actualizar README con este status
[Si $CANVAS_ENABLED == true:]
2. Generar dashboard Canvas
3. Ver detalle de una nota especifica
4. Salir

[Si $CANVAS_ENABLED == false:]
2. Ver detalle de una nota especifica
3. Salir

Que hacer? (1-4 o 1-3)
```

**Si elige 1 (--update-readme):**

Agrega o actualiza seccion en README.md:

```markdown
## Status

*Actualizado: [FECHA]*

- **Progreso:** [X]% ([completadas]/[total] tasks)
- **Estado:** [En progreso/Activo/Pausado]
- **Proxima tarea:** [Task prioritaria]

### Tasks Pendientes Prioritarias
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3
```

**Si elige 2 y Canvas está habilitado (--canvas):**

1. Verifica que `$CANVAS_ENABLED == true`:
   - Si false, mostrar: "Canvas no está habilitado. Edita vault-config.yml para activarlo."

2. Genera archivo Canvas JSON en `$CANVAS_FOLDER/`:

Estructura básica de un dashboard Canvas:
```json
{
  "nodes": [
    {
      "id": "project-title",
      "type": "text",
      "text": "# [Nombre Proyecto]\n\n**Progreso:** [X]%\n**Estado:** [Estado]",
      "x": 0,
      "y": 0,
      "width": 400,
      "height": 200,
      "color": "5"
    },
    {
      "id": "tasks-pending",
      "type": "text",
      "text": "## Tasks Pendientes\n- [ ] Task 1\n- [ ] Task 2",
      "x": 450,
      "y": 0,
      "width": 350,
      "height": 300,
      "color": "3"
    },
    {
      "id": "next-step",
      "type": "text",
      "text": "## Próximo Paso\n\n[Task prioritaria]",
      "x": 0,
      "y": 250,
      "width": 400,
      "height": 150,
      "color": "1"
    }
  ],
  "edges": [
    {
      "id": "edge-1",
      "fromNode": "project-title",
      "toNode": "tasks-pending",
      "fromSide": "right",
      "toSide": "left"
    }
  ]
}
```

3. Guarda el canvas en: `$CANVAS_FOLDER/[proyecto]-dashboard.canvas`

4. Reporta: "Dashboard Canvas creado: $CANVAS_FOLDER/[proyecto]-dashboard.canvas"

### PASO 6: Modo detallado (--detailed)

Si se paso `--detailed`, incluir despues de la tabla de notas:

```
------------------------------------------------------
               DETALLE DE NOTAS
------------------------------------------------------

### README.md
Descripcion general del proyecto [nombre], un sistema
para [objetivo]...
[primeras 5 lineas o resumen]

### architecture.md (DRAFT)
Arquitectura propuesta con modulos separados para:
- Vision (camara + modelo)
- NLP (speech-to-text + LLM)
[primeras 5 lineas o resumen]

[... para cada nota ...]
```

## Ejemplo de uso

```
Usuario: /project-status AppSalud

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Carpeta proyectos: MIS-PROYECTOS/
        Canvas habilitado: ✅ Sí
        
        Buscando proyecto "AppSalud" en MIS-PROYECTOS/...
        ✅ Encontrado: MIS-PROYECTOS/AppSalud/
        
        Escaneando contenido...
        
        ======================================================
                   ESTADO DEL PROYECTO: APPSALUD
        ======================================================

        Ubicacion: MIS-PROYECTOS/AppSalud/

        ------------------------------------------------------
                            RESUMEN
        ------------------------------------------------------
        Estado:          🚀 En progreso
        Progreso:        48% (12/25 tasks)
        Ultima actividad: hace 2 dias
        Notas:           5 archivos

        ------------------------------------------------------
                             TASKS
        ------------------------------------------------------
        Pendientes (13):
          - [ ] Integrar API de wearables (hace 1 semana)
          - [ ] Diseñar dashboard
          - [ ] Testing con usuarios
          ... (+10 mas)

        Completadas (12):
          - [x] Definir concepto general
          - [x] Crear estructura de proyecto
          ... (+10 mas)

        ------------------------------------------------------
                       NOTAS DEL PROYECTO
        ------------------------------------------------------
        | Archivo              | Modificado  | Estado   |
        |---------------------|-------------|----------|
        | README.md           | 2026-01-10  | activo   |
        | BRIEF.md            | 2026-01-09  | activo   |
        | api-integration.md  | 2026-01-08  | draft    |

        ------------------------------------------------------
                    CONOCIMIENTO RELACIONADO
        ------------------------------------------------------
        Notas en CONOCIMIENTO/ que mencionan AppSalud:

        IA-ML:
          - [[machine-learning-basics]] - Para predicciones
        
        Salud:
          - [[health-apis]] - APIs de wearables

        ------------------------------------------------------
                      PROXIMOS PASOS SUGERIDOS
        ------------------------------------------------------
        1. "Integrar API de wearables" pendiente hace 1 semana
        2. api-integration.md esta en draft - finalizar?
        3. Hacer testing con 5 usuarios

        ======================================================

        Opciones:
        1. Actualizar README con este status
        2. Generar dashboard Canvas
        3. Ver detalle de una nota
        4. Salir

Usuario: 2

Claude: Generando dashboard Canvas...
        
        Canvas habilitado: ✅
        
        Creando CANVAS/appsalud-dashboard.canvas...
        
        Dashboard incluye:
        - Título y progreso (48%)
        - Tasks pendientes (13)
        - Próximo paso prioritario
        - Conexiones a notas

        ✅ Dashboard creado: CANVAS/appsalud-dashboard.canvas
        
        Ábrelo en Obsidian para ver visualización.
```

## Ejemplo sin Canvas

```
Usuario: /project-status Jarvis --canvas

Claude: Leyendo configuración...
        Canvas habilitado: ❌ No
        
        El flag --canvas requiere workflows.canvas.enabled: true
        
        Edita .claude/vault-config.yml para activar Canvas.
        
        Mostrando reporte de texto...
        
        [... reporte normal sin canvas ...]
```

## Notas importantes

- **Lee vault-config.yml primero** para carpetas y canvas
- Detecta tasks viejas (>1 semana) y marcalas como prioritarias
- Detecta notas en estado "draft" y sugiere finalizarlas
- Si el proyecto no tiene README.md, sugerir crearlo
- El estado se infiere: >80% = "Casi listo", 50-80% = "En progreso", <50% = "Inicial"
- Usa emojis para estados: 🚀 = En progreso, ⏸️ = Pausado, ✅ = Completado, 🚧 = Bloqueado
- **Canvas solo funciona si está habilitado en el config**
- Si Canvas no está habilitado, informar al usuario
- **Busca en las carpetas configuradas** (KNOWLEDGE, CANVAS, etc.)

---

*Versión adaptativa - Lee vault-config.yml - Canvas condicional - 2026-01-12*
