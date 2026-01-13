---
description: "Crea un nuevo proyecto con estructura, brief y research opcional"
argument-hint: '"<nombre>" [--from-note <nota>] [--research] [--brief]'
allowed-tools:
  - Glob
  - Read
  - Write
  - Grep
  - Bash
  - Edit
  - WebSearch
  - AskUserQuestion
---

# Comando: /new-project

Crea un nuevo proyecto completo en el vault con estructura de carpetas, brief consolidado y research opcional.

**NOTA:** Este comando lee `.claude/vault-config.yml` para:
- Ubicación de PROJECTS (puede ser personalizada)
- Esquema de frontmatter personalizado
- Carpetas para buscar recursos (KNOWLEDGE, RECURSOS)

## Argumentos

- `"<nombre>"`: Nombre del proyecto (requerido)
- `--from-note <ruta>`: Consolidar ideas desde una nota existente (ej: nota en INBOX)
- `--research`: Buscar recursos relacionados (papers, videos, articulos)
- `--brief`: Generar brief estructurado del proyecto

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

2. Leer configuración:
```bash
cat .claude/vault-config.yml
```

3. Extraer valores:
```yaml
folders:
  projects: "PROJECTS/"     # Donde crear proyectos
  knowledge: "KNOWLEDGE/"   # Buscar notas relacionadas
  recursos: "RECURSOS/"     # Buscar recursos
  inbox: "INBOX/"           # Si viene --from-note de inbox

frontmatter_schema:
  required_fields: [id, created, tipo, estado]
  optional_fields: [disciplinas, proyectos, tags, tiene-todos]

categories: [...]           # Disciplinas disponibles
```

4. Guardar en variables:
- `$PROJECTS_FOLDER`
- `$KNOWLEDGE_FOLDER`
- `$RECURSOS_FOLDER`
- `$FRONTMATTER_FIELDS`
- `$CATEGORIES`

5. Si PROJECTS no existe en config, error:
   ```
   ❌ Este vault no tiene carpeta de proyectos configurada.
   /new-project requiere una carpeta de proyectos.
   ```

### PASO 1: Obtener información del proyecto

1. Si se proporciono `--from-note`:
   - Lee la nota especificada con Read
   - Extrae ideas, requisitos, contexto

2. Si NO se proporciono nota, haz preguntas interactivas con AskUserQuestion:
   - "Describe brevemente el proyecto en 2-3 oraciones"
   - "¿Cual es el objetivo principal?"
   - "¿Que disciplinas involucra?" (usar `$CATEGORIES` del config, o lista default)
   - "¿Tienes ideas iniciales o requisitos?"

3. Confirma entendimiento: "Entendi que quieres crear [proyecto] para [objetivo]. ¿Correcto?"

### PASO 2: Crear estructura de carpetas

1. Genera nombre de carpeta en kebab-case desde el nombre del proyecto
2. Verifica que no exista un proyecto con el mismo nombre en `$PROJECTS_FOLDER`:
```bash
if [ -d "$PROJECTS_FOLDER/nombre-proyecto" ]; then
  echo "Ya existe un proyecto con ese nombre"
  exit 1
fi
```

3. Crea estructura usando Bash:
```bash
mkdir -p "$PROJECTS_FOLDER/nombre-proyecto"
```

### PASO 3: Crear README del proyecto

Genera `$PROJECTS_FOLDER/nombre-proyecto/README.md` con esta estructura, usando `$FRONTMATTER_FIELDS`:

```markdown
---
# Campos requeridos (según vault config):
id: proyecto-nombre
created: YYYY-MM-DD
modified: YYYY-MM-DD
tipo: proyecto
estado: activo

# Campos opcionales (según vault config):
disciplinas: [disciplinas-relevantes]   # si está en optional_fields
proyectos: []                            # si está en optional_fields
tags: [tags-del-proyecto]                # si está en optional_fields
tiene-todos: true                        # siempre true para proyectos
---

# Nombre del Proyecto

## Descripcion
[Descripcion consolidada del proyecto]

## Objetivo
[Objetivo principal]

## Ideas Iniciales
[Ideas capturadas del usuario o de la nota]

## Requisitos
- [ ] Requisito 1
- [ ] Requisito 2

## Proximos Pasos
- [ ] Definir arquitectura
- [ ] Investigar tecnologias
- [ ] Crear primer prototipo

## Recursos
[Se llenara con research si --research]

## Notas
[Espacio para notas adicionales]
```

### PASO 4: Generar Brief (si --brief)

Si se paso `--brief`, genera un brief estructurado adicional:

1. Crea `$PROJECTS_FOLDER/nombre-proyecto/BRIEF.md`:

```markdown
---
# Frontmatter según vault config
id: brief-nombre-proyecto
created: YYYY-MM-DD
tipo: recurso
# ... otros campos según config
---

# Brief: Nombre del Proyecto

## Resumen Ejecutivo
[1 parrafo que capture la esencia del proyecto]

## Problema a Resolver
[Que problema soluciona este proyecto]

## Solucion Propuesta
[Como el proyecto resuelve el problema]

## Alcance
### Incluido
- [Feature 1]
- [Feature 2]

### Excluido (fuera de alcance)
- [Lo que NO se hara]

## Stakeholders
- Desarrollador principal: [Usuario del vault]
- Usuarios objetivo: [quien usara esto]

## Metricas de Exito
- [Como medimos si el proyecto fue exitoso]

## Riesgos
- [Riesgo 1]: [Mitigacion]
- [Riesgo 2]: [Mitigacion]

## Timeline (estimado)
- Fase 1: [descripcion]
- Fase 2: [descripcion]
```

### PASO 5: Research (si --research)

Si se paso `--research`:

1. Extrae 3-5 terminos clave del proyecto
2. Busca en el vault existente con Grep (usar carpetas del config):
   - Notas relacionadas en `$KNOWLEDGE_FOLDER/`
   - Recursos existentes en `$RECURSOS_FOLDER/`

3. Busca externamente con WebSearch:
   - Papers relevantes
   - Videos tutoriales
   - Articulos tecnicos
   - Repositorios GitHub

4. Compila recursos en seccion "Recursos" del README:

```markdown
## Recursos

### En el Vault
- [[$KNOWLEDGE_FOLDER/IA-ML/nota-relacionada]]
- [[$RECURSOS_FOLDER/Papers/paper-relevante]]

### Externos (investigar)
- [Paper: Titulo](url) - Descripcion breve
- [Video: Titulo](url) - Canal, duracion
- [Articulo: Titulo](url) - Descripcion
- [GitHub: Repo](url) - Descripcion
```

### PASO 6: Buscar conexiones

1. Usa Grep para buscar notas relacionadas en todo el vault (todas las carpetas del config)
2. Sugiere conexiones potenciales:
   - "Este proyecto podria conectar con [[nota-existente]]"
   - "Encontre conocimiento relacionado en [[$KNOWLEDGE_FOLDER/area/]]"

### PASO 7: Resumen final

Muestra resumen de lo creado:

```
Proyecto creado: NOMBRE DEL PROYECTO

Ubicación: $PROJECTS_FOLDER/nombre-proyecto/

Archivos generados:
- README.md
[Si --brief:]
- BRIEF.md

[Si --research:]
Recursos encontrados:
- X notas relacionadas en el vault
- Y recursos externos sugeridos

Conexiones sugeridas:
- [[nota1]]
- [[nota2]]

Proximos pasos:
1. Revisar y ajustar el README
2. Empezar con [primer paso sugerido]

Tip: Usa /project-status nombre-proyecto para ver el progreso
```

## Ejemplos de uso

### Ejemplo 1: Proyecto basico
```
Usuario: /new-project "AppSalud"

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Carpeta de proyectos: MIS-PROYECTOS/
        
        Creando proyecto "AppSalud"...

        Algunas preguntas para entender mejor:
        
        1. Describe brevemente el proyecto en 2-3 oraciones:
```

### Ejemplo 2: Desde nota existente con research
```
Usuario: /new-project "Sistema Vision" --from-note CAPTURA/_quick-notes/ideas-vision.md --research --brief

Claude: Leyendo configuración...
        Carpeta proyectos: PROYECTOS/
        
        Leyendo nota: CAPTURA/_quick-notes/ideas-vision.md
        
        Encontre las siguientes ideas:
        - Deteccion de objetos en tiempo real
        - Integracion con Jetson Nano
        ...

        Creando proyecto con brief y research...
        
        Buscando recursos en el vault...
        - Encontré [[CONOCIMIENTO/IA-ML/yolo]]
        - Encontré [[RECURSOS/Papers/object-detection]]
        
        Buscando externamente...
        [recursos web]
        
        Proyecto creado: PROYECTOS/sistema-vision/
```

### Ejemplo 3: Proyecto rapido
```
Usuario: /new-project "App Clientes" --brief

Claude: Leyendo config...
        
        Creando proyecto "App Clientes" en PROJECTS/...

        ¿Puedes darme un poco mas de contexto?
        [hace preguntas]

        Generando brief estructurado...
```

## Notas importantes

- **Lee vault-config.yml primero** para adaptar a carpetas del usuario
- SIEMPRE confirma el entendimiento antes de crear
- Si hay ambiguedad, pregunta
- El research con WebSearch puede tardar, avisa al usuario
- Busca PRIMERO en el vault antes de buscar externamente
- Sugiere conexiones con conocimiento existente
- El proyecto se crea en estado "activo" por defecto
- **Usa frontmatter según el esquema del vault config**
- **Busca en las carpetas configuradas** ($KNOWLEDGE_FOLDER, $RECURSOS_FOLDER, etc.)
- Si una carpeta no existe en el config (null), skip esa funcionalidad

---

*Versión adaptativa - Lee vault-config.yml - Frontmatter dinámico - 2026-01-12*
