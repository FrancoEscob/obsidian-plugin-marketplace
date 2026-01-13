---
description: "Crea la daily note del dia con contexto inteligente de proyectos y tasks"
argument-hint: "[<fecha>] [--minimal] [--focus <proyecto>]"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Comando: /daily-note

Crea o abre la daily note del dia, con contexto inteligente basado en proyectos activos, tasks pendientes y trabajo del dia anterior.

**NOTA:** Este comando lee `.claude/vault-config.yml` para usar las carpetas configuradas por el usuario.

## Argumentos

- `<fecha>` (opcional): Fecha especifica en formato YYYY-MM-DD (default: hoy)
- `--minimal`: Solo crear estructura basica sin analisis de contexto
- `--focus <proyecto>`: Enfocar el dia en un proyecto especifico

## Instrucciones

### PASO 0: Leer configuración del vault

1. Verificar que existe `.claude/vault-config.yml`:
```bash
if [ ! -f .claude/vault-config.yml ]; then
  echo "❌ No se encontró vault-config.yml"
  echo "Ejecuta /setup-vault primero para configurar tu vault"
  exit 1
fi
```

2. Leer configuración usando Read:
```bash
cat .claude/vault-config.yml
```

3. Extraer valores necesarios (parsear YAML):
```yaml
# Necesitamos:
folders:
  productivity: "PRODUCTIVITY/"  # Donde van las daily notes
  inbox: "INBOX/"                # Para contar notas sin procesar
  projects: "PROJECTS/"          # Para listar proyectos activos
  
# También leer (si existen):
frontmatter_schema:
  required_fields: [id, created, tipo, estado]
  optional_fields: [disciplinas, proyectos, tags, tiene-todos]
```

4. Guardar en variables:
- `$PRODUCTIVITY_FOLDER`
- `$INBOX_FOLDER` 
- `$PROJECTS_FOLDER`
- `$FRONTMATTER_FIELDS`

5. Si alguna carpeta no existe en el config (es null), ajustar comportamiento:
   - Si no hay PRODUCTIVITY: crear en raíz `daily-notes/`
   - Si no hay INBOX: skip el conteo de inbox
   - Si no hay PROJECTS: skip análisis de proyectos

### PASO 1: Determinar fecha y ruta

1. Si se paso `<fecha>`:
   - Usar esa fecha
   - Validar formato YYYY-MM-DD
2. Si no:
   - Usar fecha actual

3. Construir ruta usando la carpeta del config:
   ```
   [$PRODUCTIVITY_FOLDER]/daily-notes/[YYYY]/[MM-MES]/[YYYY-MM-DD].md
   ```
   
   Ejemplo: Si $PRODUCTIVITY_FOLDER es "PRODUCTIVIDAD", la ruta será:
   ```
   PRODUCTIVIDAD/daily-notes/2026/01-ENE/2026-01-12.md
   ```

4. Verificar si ya existe:
   - Si existe, leer contenido actual
   - Preguntar: "Ya existe daily note para hoy. Abrir y actualizar?"

**Meses en español:**
- 01-ENE, 02-FEB, 03-MAR, 04-ABR, 05-MAY, 06-JUN
- 07-JUL, 08-AGO, 09-SEP, 10-OCT, 11-NOV, 12-DIC

### PASO 2: Recopilar contexto (si no --minimal)

**INBOX:**
1. Si `$INBOX_FOLDER` existe en config:
   - Usa Glob para contar archivos en `$INBOX_FOLDER/_quick-notes/*.md`
   - Guarda el conteo
2. Si no existe: skip esta sección

**Proyectos activos:**
1. Si `$PROJECTS_FOLDER` existe en config:
   - Usa Glob para listar `$PROJECTS_FOLDER/*/README.md`
   - Por cada proyecto, lee el README y busca tasks pendientes
   - Extrae las 2-3 tasks mas importantes por proyecto
2. Si no existe: skip esta sección

**Daily anterior:**
1. Calcula fecha de ayer
2. Busca daily note de ayer en `$PRODUCTIVITY_FOLDER/daily-notes/`
3. Si existe:
   - Lee la seccion "Para Mañana"
   - Lee tasks no completadas (- [ ])
   - Estas se migraran a hoy

**Tasks vencidas:**
1. Usa Grep para buscar checkboxes con fechas pasadas:
   ```
   - \[ \].*due::[fecha-pasada]
   ```
2. O busca en Kanban tasks en columna "Atrasado"

**Si --focus:**
1. Prioriza info del proyecto especificado
2. Incluye todas las tasks de ese proyecto

### PASO 3: Generar contenido

**Frontmatter:**
Usar los campos definidos en `frontmatter_schema`:

```yaml
---
id: daily-YYYY-MM-DD
created: YYYY-MM-DD
tipo: daily
estado: activo
# Si optional_fields incluye más campos, agregarlos:
# proyectos: []
# tags: [daily-note]
---
```

**Estructura del contenido:**

```markdown
# [emoji-dia] [Dia de la semana] [DD] de [Mes], [YYYY]

## Foco del Dia

> [Sugerencia basada en proyectos activos o --focus]

[Si hay proyecto prioritario, explicar por que enfocarse ahi]

## Tasks del Dia

### De ayer (migradas)
- [ ] [Task no completada de ayer 1]
- [ ] [Task no completada de ayer 2]

### [Proyecto 1]
- [ ] [Task prioritaria 1]
- [ ] [Task prioritaria 2]

### [Proyecto 2]
- [ ] [Task prioritaria 1]

### Otras
- [ ] [Tasks generales]

[Si INBOX_FOLDER existe:]
## INBOX

[[$INBOX_FOLDER/_quick-notes/|[N] notas sin procesar]] → `/process-inbox`

[Si PROJECTS_FOLDER existe:]
## Quick Links

- [[$PROJECTS_FOLDER/Proyecto1/README|Proyecto1]]
- [[$PROJECTS_FOLDER/Proyecto2/README|Proyecto2]]
- [[$PRODUCTIVITY_FOLDER/kanban-global|Kanban Global]]

## Notas del Dia

[Espacio libre para escribir durante el dia]

## Para Mañana

[Llenar al final del dia con tasks para mañana]

```

**Emojis por dia:**
- Lunes: 🌅
- Martes: ⚡
- Miércoles: 🌊
- Jueves: 🚀
- Viernes: 🎯
- Sábado: 🌴
- Domingo: ☀️

### PASO 4: Crear estructura de carpetas

1. Verifica si existe `$PRODUCTIVITY_FOLDER/daily-notes/[YYYY]/`
   - Si no, crea con Bash: `mkdir -p "$PRODUCTIVITY_FOLDER/daily-notes/[YYYY]"`

2. Verifica si existe `$PRODUCTIVITY_FOLDER/daily-notes/[YYYY]/[MM-MES]/`
   - Si no, crea con Bash: `mkdir -p "$PRODUCTIVITY_FOLDER/daily-notes/[YYYY]/[MM-MES]"`

### PASO 5: Guardar y reportar

1. Guarda la nota con Write

2. Muestra resumen:
```
Daily note creada: $PRODUCTIVITY_FOLDER/daily-notes/2026/01-ENE/2026-01-12.md

Resumen del dia:
[Si INBOX existe:]
- INBOX: 5 notas sin procesar

[Si PROJECTS existe:]
- Tasks migradas de ayer: 2
- Proyectos activos: Proyecto1, Proyecto2
- Foco sugerido: Proyecto1 (3 tasks prioritarias)

Tips:
[Si INBOX existe:]
- /process-inbox para limpiar el inbox
[Si PROJECTS existe:]
- /project-status Proyecto1 para ver detalle
```

### Modo --minimal

Si se paso --minimal, solo crea la estructura basica usando frontmatter del config:

```markdown
---
[campos según frontmatter_schema]
---

# [Dia de la semana] [DD] de [Mes], [YYYY]

## Foco del Dia

>

## Tasks del Dia

- [ ]

## Notas del Dia



## Para Mañana


```

Sin analisis de contexto, sin busqueda de proyectos.

## Ejemplo de uso

```
Usuario: /daily-note

Claude: Leyendo configuración del vault...
        ✅ Config encontrada

        Carpetas configuradas:
        - Daily notes: PRODUCTIVIDAD/
        - Inbox: CAPTURA/
        - Projects: MIS-PROYECTOS/

        Creando daily note para Domingo 12 de Enero, 2026...

        Analizando contexto...
        - CAPTURA: 3 notas sin procesar
        - Proyectos activos: AppSalud, Jarvis
        - Ayer: 2 tasks no completadas
        - Tasks vencidas: 1

        ---
        id: daily-2026-01-12
        created: 2026-01-12
        tipo: daily
        estado: activo
        ---

        # ☀️ Domingo 12 de Enero, 2026

        ## Foco del Dia

        > AppSalud tiene 3 tasks de alta prioridad pendientes.
        > Sugerencia: enfocarse en "Integrar API de wearables"

        ## Tasks del Dia

        ### De ayer (migradas)
        - [ ] Revisar PR de Jarvis
        - [ ] Responder email universidad

        ### AppSalud
        - [ ] Integrar API de wearables (pendiente hace 1 semana)
        - [ ] Diseñar dashboard

        ### Jarvis
        - [ ] Investigar Jetson Nano

        ## CAPTURA

        [[CAPTURA/_quick-notes/|3 notas sin procesar]] → `/process-inbox`

        ## Quick Links

        - [[MIS-PROYECTOS/AppSalud/README|AppSalud]]
        - [[MIS-PROYECTOS/Jarvis/README|Jarvis]]

        ## Notas del Dia



        ## Para Mañana



        ---

        Daily note creada: PRODUCTIVIDAD/daily-notes/2026/01-ENE/2026-01-12.md

        Tip: Tenes 3 notas en CAPTURA. Procesar? (/process-inbox)
```

## Notas importantes

- **Lee vault-config.yml primero** para adaptar a carpetas custom del usuario
- NUNCA sobrescribas una daily note existente sin confirmar
- Migra tasks no completadas del dia anterior automaticamente
- El campo "Para Mañana" se usa para planificar el proximo dia
- Si el usuario renombró carpetas (ej: INBOX → CAPTURA), usar esos nombres
- Si una carpeta no existe en el config (null), skip esa funcionalidad
- Los Quick Links deben usar los nombres reales de los proyectos y carpetas
- Si es fin de semana, el tono puede ser mas relajado

---

*Versión adaptativa - Lee vault-config.yml - 2026-01-12*
