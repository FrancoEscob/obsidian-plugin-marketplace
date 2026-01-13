---
description: "Procesa todas las notas en INBOX, las clasifica y mueve a su ubicacion correcta"
argument-hint: "[--dry-run] [--auto]"
allowed-tools:
  - Glob
  - Read
  - Write
  - Grep
  - Bash
  - Edit
  - AskUserQuestion
---

# Comando: /process-inbox

Procesa todas las notas en INBOX, analizando su contenido para clasificarlas y moverlas a la ubicacion correcta del vault.

**NOTA:** Este comando lee `.claude/vault-config.yml` para:
- Ubicación de INBOX (puede ser personalizada)
- Nivel de automatización (`auto_classify`)
- Esquema de frontmatter
- Carpetas de destino

## Argumentos

- `--dry-run`: Solo muestra que haria, sin ejecutar cambios
- `--auto`: Fuerza auto-clasificación (ignora config, no pregunta)

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

3. Extraer valores necesarios:
```yaml
folders:
  inbox: "INBOX/"           # Donde están las notas sin procesar
  knowledge: "KNOWLEDGE/"   # Destino para notas de estudio
  projects: "PROJECTS/"     # Destino para notas de proyecto
  ideas: "IDEAS/"           # Destino para ideas
  recursos: "RECURSOS/"     # Destino para recursos

workflows:
  inbox:
    auto_classify: true     # ⭐ CLAVE: si es true, no pregunta confirmación
    batch_mode: true        # Si procesar todas juntas o una por una

frontmatter_schema:
  required_fields: [id, created, tipo, estado]
  optional_fields: [disciplinas, proyectos, tags, tiene-todos]

categories: [...]           # Si el vault tiene categorías/disciplinas
```

4. Guardar en variables:
- `$INBOX_FOLDER`
- `$KNOWLEDGE_FOLDER`
- `$PROJECTS_FOLDER`
- `$IDEAS_FOLDER`
- `$RECURSOS_FOLDER`
- `$AUTO_CLASSIFY` (true/false)
- `$FRONTMATTER_FIELDS`
- `$CATEGORIES` (lista de disciplinas/categorías disponibles)

5. Si INBOX no existe en config, error:
   ```
   ❌ Este vault no tiene carpeta INBOX configurada.
   /process-inbox requiere una carpeta INBOX.
   ```

### PASO 1: Escanear INBOX

1. Usa Glob para listar todos los archivos `.md` en `$INBOX_FOLDER/_quick-notes/`
2. Si no hay archivos, responde: "INBOX vacio, nada que procesar" y termina
3. Cuenta el total: "Encontre X notas para procesar"

### PASO 2: Analizar cada nota

Por cada nota encontrada:

1. Lee el contenido completo con Read
2. Analiza el contenido para determinar:
   - **Tipo**: estudio | idea | recurso | proyecto
   - **Disciplina/Categoría**: Usar `$CATEGORIES` del config si existen, sino "General"
   - **Proyecto relacionado**: Buscar en `$PROJECTS_FOLDER/` para listar proyectos activos
   - **Tags sugeridos**: 3-5 tags relevantes en kebab-case

3. Determina el destino según el tipo (usar carpetas del config):
   - `estudio` → `$KNOWLEDGE_FOLDER/[disciplina]/` (si existe)
   - `idea` → `$IDEAS_FOLDER/` (si existe)
   - `recurso` → `$RECURSOS_FOLDER/[subtipo]/` (si existe)
   - `proyecto` → `$PROJECTS_FOLDER/[proyecto]/` (si existe)

4. **Fallback si carpetas no existen:**
   - Si no hay KNOWLEDGE: mover a raíz con prefijo `note-`
   - Si no hay IDEAS: mover a INBOX procesadas o raíz
   - Si no hay RECURSOS: mover a raíz con prefijo `resource-`

5. Genera nombre de archivo en kebab-case basado en el contenido

### PASO 3: Mostrar plan Y decidir según AUTO_CLASSIFY

**Si `$AUTO_CLASSIFY == true` o se pasó `--auto`:**

1. Mostrar plan brevemente:
```
Procesando 3 notas automáticamente...

Plan:
• apuntes.md → $KNOWLEDGE_FOLDER/IA-ML/pytorch-tutorial.md
• idea-app.md → $IDEAS_FOLDER/app-salud-idea.md  
• video-3b1b.md → $RECURSOS_FOLDER/Videos/3b1b-linear-algebra.md

Ejecutando...
```

2. **NO preguntar confirmación**, ir directo a PASO 4

**Si `$AUTO_CLASSIFY == false`:**

1. Muestra tabla resumen con todas las notas:

```
Encontre 3 notas para procesar:

| # | Archivo Original | Tipo | Destino | Tags |
|---|------------------|------|---------|------|
| 1 | apuntes.md | estudio | $KNOWLEDGE_FOLDER/IA-ML/ | pytorch, cnn |
| 2 | idea-app.md | idea | $IDEAS_FOLDER/ | startup, saas |
| 3 | video.md | recurso | $RECURSOS_FOLDER/Videos/ | youtube, math |
```

2. Pregunta: "Procedo con estos cambios? (s/n/editar)"
3. Si el usuario dice "editar", permite modificar destinos individuales
4. Si el usuario dice "n", cancela la operacion

**Si se pasó `--dry-run`:**
- Muestra el plan y termina sin ejecutar (ignora AUTO_CLASSIFY)

### PASO 4: Ejecutar cambios

Por cada nota:

1. **Generar frontmatter** usando `$FRONTMATTER_FIELDS`:

```yaml
---
# Campos requeridos (siempre):
id: [nombre-kebab-case]
created: [fecha-actual-YYYY-MM-DD]
modified: [fecha-actual-YYYY-MM-DD]
tipo: [tipo-detectado]
estado: activo

# Campos opcionales (si están en frontmatter_schema):
disciplinas: [lista-disciplinas]  # solo si está en optional_fields
proyectos: [lista-proyectos]      # solo si está en optional_fields
tags: [lista-tags]                # solo si está en optional_fields
tiene-todos: [true/false]         # solo si está en optional_fields
---
```

2. **Actualizar la nota** con el frontmatter usando Write
3. **Crear carpeta destino si no existe:**
   ```bash
   mkdir -p "$DESTINO"
   ```
4. **Mover la nota** al destino usando Bash: `mv "origen" "destino"`
5. Reporta cada movimiento: 
   - Si AUTO_CLASSIFY: "✅ Movido: X → Y"
   - Si manual: "Movido: X → Y"

### PASO 5: Buscar conexiones

Después de mover todas las notas:

1. Por cada nota movida, usa Grep para buscar términos clave en el vault
2. Si encuentra notas relacionadas, sugiere:
   "Esta nota podría conectar con [[nota-relacionada]]"
3. Pregunta si agregar los links sugeridos

### PASO 6: Resumen final

Muestra resumen:

```
[Si AUTO_CLASSIFY:]
✅ Procesadas 3 notas automáticamente:

[Si manual:]
Procesadas 3 notas:

• apuntes.md → $KNOWLEDGE_FOLDER/IA-ML/pytorch-tutorial.md
• idea-app.md → $IDEAS_FOLDER/app-salud-idea.md
• video-3b1b.md → $RECURSOS_FOLDER/Videos/3b1b-linear-algebra.md

Conexiones sugeridas:
• pytorch-tutorial.md ↔ [[transformers]]

[Si AUTO_CLASSIFY:]
Tip: Tus notas se clasifican automáticamente (auto_classify: true)
     Para cambiar esto, edita .claude/vault-config.yml
```

## Ejemplo de uso (AUTO_CLASSIFY = true)

```
Usuario: /process-inbox

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Modo: Clasificación automática (auto_classify: true)
        
        Escaneando CAPTURA/_quick-notes/...
        Encontré 3 notas para procesar.
        
        Procesando automáticamente...
        
        ✅ apuntes-pytorch.md → CONOCIMIENTO/IA-ML/pytorch-tutorial.md
        ✅ idea-app.md → IDEAS/app-salud-wearables.md
        ✅ video-3b1b.md → RECURSOS/Videos/3b1b-linear-algebra.md
        
        Conexiones encontradas:
        • pytorch-tutorial.md podría conectar con [[transformers]]
        
        ¿Agregar conexión? (s/n)

Usuario: s

Claude: Agregada conexión en pytorch-tutorial.md
        
        ✅ Procesadas 3 notas automáticamente.
        
        Tip: Clasificación automática activa. Edita vault-config.yml para cambiar.
```

## Ejemplo de uso (AUTO_CLASSIFY = false)

```
Usuario: /process-inbox

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Modo: Clasificación manual (auto_classify: false)
        
        Escaneando INBOX/_quick-notes/...
        Encontré 3 notas para procesar.
        
        Analizando contenido...
        
        | # | Archivo | Tipo | Destino | Tags |
        |---|---------|------|---------|------|
        | 1 | apuntes.md | estudio | KNOWLEDGE/IA-ML/ | pytorch, cnn |
        | 2 | idea-app.md | idea | IDEAS/ | startup, saas |
        | 3 | video.md | recurso | RECURSOS/Videos/ | youtube |
        
        ¿Procedo con estos cambios? (s/n/editar)

Usuario: s

Claude: Procesando...
        
        Movido: apuntes.md → KNOWLEDGE/IA-ML/pytorch-tutorial.md
        Movido: idea-app.md → IDEAS/app-salud-idea.md
        Movido: video.md → RECURSOS/Videos/3b1b-linear-algebra.md
        
        Conexiones encontradas: [[transformers]]
        
        Procesadas 3 notas.
```

## Ejemplo de uso (--dry-run)

```
Usuario: /process-inbox --dry-run

Claude: Leyendo configuración...
        
        Modo: DRY RUN (sin cambios reales)
        
        Plan de procesamiento:
        
        | Nota | Tipo | Destino |
        |------|------|---------|
        | apuntes.md | estudio | KNOWLEDGE/IA-ML/pytorch-tutorial.md |
        | idea-app.md | idea | IDEAS/app-salud-idea.md |
        
        ⚠️  Esto es un dry run. No se hicieron cambios.
        
        Para ejecutar, usa: /process-inbox
```

## Notas importantes

- **Lee vault-config.yml primero** para adaptar comportamiento
- **Respeta auto_classify:** Si es true, NO preguntar confirmación
- SIEMPRE preserva el contenido original de la nota
- SIEMPRE genera frontmatter válido con campos del config
- Usa kebab-case para nombres de archivo
- Si hay ambigüedad sobre el destino, pregunta al usuario (incluso en auto mode)
- El campo `modified` se actualiza a la fecha actual
- **Crea carpetas destino si no existen** (mkdir -p)
- Si una carpeta no está en el config (null), usa fallback a raíz

---

*Versión adaptativa - Lee vault-config.yml - Respeta auto_classify - 2026-01-12*
