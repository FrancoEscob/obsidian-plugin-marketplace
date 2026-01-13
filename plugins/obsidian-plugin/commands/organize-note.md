---
description: "Clasifica y mueve una nota especifica a su ubicacion correcta"
argument-hint: "<ruta-nota> [--destination <ruta>] [--type <tipo>]"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Comando: /organize-note

Clasifica y mueve UNA nota especifica a su ubicacion correcta en el vault, generando o actualizando su frontmatter.

**NOTA:** Este comando lee `.claude/vault-config.yml` para:
- Carpetas de destino personalizadas
- Esquema de frontmatter
- Categorías/disciplinas disponibles

## Argumentos

- `<ruta-nota>` (requerido): Ruta de la nota a organizar
- `--destination <ruta>`: Forzar destino especifico (ignora clasificacion automatica)
- `--type <tipo>`: Forzar tipo (estudio, idea, recurso, proyecto)

## Instrucciones

### PASO 0: Leer configuración del vault

1. Verificar `.claude/vault-config.yml`:
```bash
cat .claude/vault-config.yml
```

2. Extraer valores:
```yaml
folders:
  knowledge: "KNOWLEDGE/"
  ideas: "IDEAS/"
  recursos: "RECURSOS/"
  projects: "PROJECTS/"

frontmatter_schema:
  required_fields: [id, created, tipo, estado]
  optional_fields: [disciplinas, proyectos, tags, tiene-todos]

categories: [...]  # Disciplinas disponibles
```

3. Guardar en variables:
- `$KNOWLEDGE_FOLDER`, `$IDEAS_FOLDER`, `$RECURSOS_FOLDER`, `$PROJECTS_FOLDER`
- `$FRONTMATTER_FIELDS`
- `$CATEGORIES`

### PASO 1: Validar nota

1. Verifica que el archivo existe usando Read
2. Si no existe:
   - Usa Glob para buscar archivos similares
   - Sugiere: "No encontre esa nota. Quisiste decir: [sugerencias]?"
3. Verifica que es un archivo .md

### PASO 2: Analizar nota

1. Lee el contenido completo
2. Detecta si ya tiene frontmatter (busca `---` al inicio)
3. Si tiene frontmatter, extrae los valores existentes
4. Analiza el contenido para determinar:

**Tipo** (si no se paso --type):
- `estudio`: Conceptos, tutoriales, apuntes de clase, teoria
- `idea`: Brainstorming, conceptos de productos, ideas sueltas
- `recurso`: Referencias a videos, papers, libros, links externos
- `proyecto`: Relacionado directamente a un proyecto activo

**Disciplina/Categoría**:
- Usar `$CATEGORIES` del config si existen
- Inferir del contenido si no están en config
- Default: "General"

**Proyecto relacionado** (si aplica):
- Buscar proyectos activos en `$PROJECTS_FOLDER/`
- Ver si el contenido menciona algún proyecto

**Tags**: 3-5 tags relevantes en kebab-case

### PASO 3: Generar/Actualizar frontmatter

Genera el frontmatter completo usando `$FRONTMATTER_FIELDS`:

```yaml
---
# Campos requeridos (siempre):
id: [nombre-kebab-case-descriptivo]
created: [fecha-original-o-actual]
modified: [fecha-actual-YYYY-MM-DD]
tipo: [tipo-detectado-o-forzado]
estado: activo

# Campos opcionales (si están en config):
disciplinas: [lista-de-disciplinas]   # si está en optional_fields
proyectos: [lista-de-proyectos]       # si está en optional_fields
tags: [lista-de-tags]                 # si está en optional_fields
tiene-todos: [true/false]             # si está en optional_fields
---
```

**Reglas para frontmatter**:
- Si ya existe `created`, preservarlo
- Siempre actualizar `modified` a hoy
- Si ya existen tags, mergear con los nuevos (sin duplicados)
- `tiene-todos` es true si el contenido tiene `- [ ]` o `- [x]`

### PASO 4: Determinar destino

Si NO se paso --destination:

1. Segun el tipo (usar carpetas del config):
   - `estudio` → `$KNOWLEDGE_FOLDER/[disciplina]/` (si existe)
   - `idea` → `$IDEAS_FOLDER/` (si existe)
   - `recurso` → `$RECURSOS_FOLDER/[subtipo]/` (si existe)
   - `proyecto` → `$PROJECTS_FOLDER/[proyecto]/` (si existe)

2. **Fallback si carpetas no existen:**
   - Si no hay carpeta destino: mover a raíz con prefijo apropiado

3. Genera nombre de archivo en kebab-case:
   - Maximo 50 caracteres
   - Descriptivo del contenido
   - Sin caracteres especiales

Si se paso --destination:
- Usa el destino especificado directamente

### PASO 5: Confirmar y ejecutar

1. Muestra preview:

```
Nota: [ruta-original]

Frontmatter generado:
---
id: pytorch-cnn-tutorial
created: 2026-01-12
modified: 2026-01-12
tipo: estudio
estado: activo
[... campos según config ...]
---

Destino: $KNOWLEDGE_FOLDER/IA-ML/pytorch-cnn-tutorial.md

Confirmar? (s/n/editar)
```

2. Si el usuario dice "editar":
   - Pregunta que campo quiere cambiar
   - Permite modificar tipo, destino, tags, disciplina

3. Si confirma:
   - Actualiza la nota con el nuevo frontmatter usando Write
   - Crea carpeta destino si no existe: `mkdir -p "$DESTINO"`
   - Mueve la nota al destino usando Bash: `mv "origen" "destino"`
   - Reporta: "Nota organizada: origen → destino"

### PASO 6: Buscar conexiones (opcional)

1. Extrae 3-5 terminos clave del contenido
2. Usa Grep para buscar esos terminos en todas las carpetas del config
3. Si encuentra matches, sugiere:
   "Notas relacionadas encontradas: [[nota1]], [[nota2]]"
4. Pregunta si agregar links

## Ejemplo de uso

```
Usuario: /organize-note INBOX/_quick-notes/apuntes-pytorch.md

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Carpetas: CONOCIMIENTO/, IDEAS/, RECURSOS/, PROYECTOS/
        
        Analizando: INBOX/_quick-notes/apuntes-pytorch.md

        Contenido detectado:
        - Tema: Tutorial de PyTorch para CNNs
        - Tipo sugerido: estudio
        - Disciplina: IA-ML (según categorías del vault)
        - Tags: pytorch, cnn, deep-learning, tutorial

        Frontmatter generado:
        ---
        id: pytorch-cnn-tutorial
        created: 2026-01-12
        modified: 2026-01-12
        tipo: estudio
        estado: activo
        disciplinas: [IA-ML]
        tags: [pytorch, cnn, deep-learning, tutorial]
        tiene-todos: false
        ---

        Destino: CONOCIMIENTO/IA-ML/pytorch-cnn-tutorial.md

        Confirmar? (s/n/editar)

Usuario: s

Claude: Creando carpeta: CONOCIMIENTO/IA-ML/
        
        Nota organizada:
        INBOX/_quick-notes/apuntes-pytorch.md
        → CONOCIMIENTO/IA-ML/pytorch-cnn-tutorial.md

        Notas relacionadas encontradas:
        - [[transformers]] menciona "deep learning"
        - [[cuda-setup]] menciona "PyTorch"

        Agregar links? (s/n)
```

## Ejemplo con flags

```
Usuario: /organize-note notas/random.md --type idea --destination IDEAS/

Claude: Leyendo config...
        
        Usando tipo forzado: idea
        Usando destino forzado: IDEAS/

        Frontmatter generado:
        ---
        id: random-idea
        ...
        tipo: idea
        ---

        Destino: IDEAS/random-idea.md

        Confirmar? (s/n)
```

## Notas importantes

- **Lee vault-config.yml primero** para adaptar a carpetas del usuario
- NUNCA pierdas contenido de la nota original
- Si el destino ya existe, pregunta antes de sobrescribir
- Preserva el campo `created` si ya existia
- Actualiza `modified` siempre
- Valida que la estructura de carpetas destino existe (crearla si no)
- **Usa categorías del config** si existen
- **Genera frontmatter según el esquema del config**
- Si una carpeta no existe (null), usa fallback a raíz

---

*Versión adaptativa - Lee vault-config.yml - Frontmatter dinámico - 2026-01-12*
