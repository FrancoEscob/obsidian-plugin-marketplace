---
description: "Busca conexiones entre notas y sugiere o agrega wikilinks"
argument-hint: "[<ruta-nota>] [--auto] [--scan-all]"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Edit
  - AskUserQuestion
---

# Comando: /link-notes

Busca conexiones entre notas del vault y sugiere o agrega wikilinks para crear un grafo de conocimiento conectado.

**NOTA:** Este comando lee `.claude/vault-config.yml` para saber qué carpetas escanear.

## Argumentos

- `<ruta-nota>` (opcional): Nota especifica a analizar. Si no se pasa, pregunta cual nota analizar.
- `--auto`: Agregar links automaticamente sin confirmar cada uno
- `--scan-all`: Escanear todo el vault buscando notas huerfanas (sin links)

## Instrucciones

### PASO 0: Leer configuración del vault

1. Leer `.claude/vault-config.yml`:
```bash
cat .claude/vault-config.yml
```

2. Extraer carpetas a escanear:
```yaml
folders:
  knowledge: "KNOWLEDGE/"
  projects: "PROJECTS/"
  ideas: "IDEAS/"
  recursos: "RECURSOS/"
```

3. Guardar en array: `$SCAN_FOLDERS` = [knowledge, projects, ideas, recursos, etc.]
   - Solo las carpetas que existen (no null)
   - Estas son las carpetas donde buscar conexiones

## Modo 1: Analizar nota individual (default)

### PASO 1: Determinar nota objetivo

1. Si se paso `<ruta-nota>`:
   - Verificar que existe
   - Leer contenido
2. Si NO se paso ruta:
   - Preguntar: "Que nota quieres analizar?"
   - Sugerir notas recientes o en INBOX

### PASO 2: Extraer terminos clave

1. Lee el contenido completo de la nota
2. Identifica wikilinks existentes `[[...]]` para excluirlos
3. Extrae terminos clave:
   - Sustantivos tecnicos (ej: "backpropagation", "transformer")
   - Nombres de conceptos (ej: "attention mechanism")
   - Nombres de tecnologias (ej: "PyTorch", "ROS2")
   - Acronimos (ej: "CNN", "NLP", "API")
4. Excluye palabras comunes y stopwords
5. Lista de 5-10 terminos principales

### PASO 3: Buscar conexiones

Por cada termino clave:

1. Usa Grep para buscar en `$SCAN_FOLDERS` (las carpetas del config):
```bash
for folder in $SCAN_FOLDERS; do
  grep -r "término" "$folder/"
done
```

2. Filtrar resultados:
   - Excluir la nota actual
   - Excluir notas ya linkeadas
   - Rankear por numero de matches
   - Mantener top 3 por termino

3. Identifica la linea donde aparece el termino en la nota original

### PASO 4: Mostrar sugerencias

Muestra tabla de conexiones sugeridas:

```
Analizando: CONOCIMIENTO/IA-ML/transformers.md

Carpetas escaneadas: CONOCIMIENTO/, PROYECTOS/, IDEAS/, RECURSOS/

Terminos clave encontrados:
- attention mechanism (5 menciones)
- self-attention (3 menciones)
- BERT (2 menciones)
- encoder-decoder (2 menciones)

Conexiones sugeridas:

| # | Termino | Conectar con | Linea | Contexto |
|---|---------|--------------|-------|----------|
| 1 | attention mechanism | [[attention-mechanism]] | 12 | "...the attention mechanism allows..." |
| 2 | BERT | [[bert-model]] | 34 | "...models like BERT use..." |
| 3 | encoder | [[seq2seq]] | 45 | "...the encoder part..." |
| 4 | self-attention | [[attention-mechanism]] | 18 | "...self-attention computes..." |

Que links agregar? (1,2,3,4 / all / none)
```

### PASO 5: Insertar links

Si el usuario selecciona links:

1. Por cada link seleccionado:
   - Encuentra la primera mencion del termino en la nota
   - Reemplaza el termino por `[[nota-destino|termino]]` o `[[nota-destino]]`
   - Usa Edit para hacer el reemplazo

2. Si `--auto` esta activo:
   - Agrega todos los links sugeridos automaticamente

3. Reporta cambios:
   "Agregados 3 links a transformers.md"

### PASO 6: Sugerir notas a crear

Si hay terminos sin notas existentes:

```
Terminos sin notas existentes:
- "scaled dot-product attention" → Crear [[scaled-dot-product-attention]]?
- "layer normalization" → Crear [[layer-normalization]]?

Crear alguna? (escribi el nombre o 'skip')
```

---

## Modo 2: Escanear todo el vault (--scan-all)

### PASO 1: Escanear vault

1. Usa Glob para listar todos los .md en `$SCAN_FOLDERS`:
```bash
for folder in $SCAN_FOLDERS; do
  find "$folder" -name "*.md"
done
```

2. Por cada nota:
   - Cuenta wikilinks salientes `[[...]]`
   - Detecta si tiene terminos tecnicos sin linkear

### PASO 2: Generar reporte

```
Escaneando vault completo...
Carpetas: CONOCIMIENTO/, PROYECTOS/, IDEAS/

=== REPORTE DE CONEXIONES ===

Notas huerfanas (0 links salientes):
| Nota | Ubicacion | Terminos potenciales |
|------|-----------|---------------------|
| resistencias.md | CONOCIMIENTO/Electronica/ | ohm, circuito |
| gradient-descent.md | CONOCIMIENTO/IA-ML/ | loss function, optimizer |
| startup-ideas.md | IDEAS/ | saas, agentes |

Notas con conexiones potenciales:
| Nota | Links actuales | Potenciales | Terminos |
|------|----------------|-------------|----------|
| transformers.md | 2 | 5 | attention, BERT, encoder |
| backpropagation.md | 0 | 3 | gradient, chain rule |

Total:
- Notas escaneadas: 45
- Notas huerfanas: 8
- Conexiones potenciales: 32

Analizar alguna nota? (escribi el nombre o 'skip')
```

### PASO 3: Analisis individual

Si el usuario elige una nota:
- Ejecuta el Modo 1 para esa nota

---

## Ejemplo de uso (Modo individual)

```
Usuario: /link-notes KNOWLEDGE/IA-ML/backpropagation.md

Claude: Leyendo configuración del vault...
        ✅ Config encontrada
        
        Carpetas a escanear: CONOCIMIENTO/, PROYECTOS/, IDEAS/
        
        Analizando: CONOCIMIENTO/IA-ML/backpropagation.md

        Terminos clave (8):
        - gradient descent
        - chain rule
        - loss function
        - neural network

        Wikilinks existentes: 0

        Buscando conexiones en el vault...

        Conexiones sugeridas:

        | # | Termino | Conectar con | Linea |
        |---|---------|--------------|-------|
        | 1 | gradient descent | [[gradient-descent]] | 5 |
        | 2 | neural network | [[neural-networks-intro]] | 8 |
        | 3 | loss function | [[loss-functions]] | 23 |

        Que links agregar? (1,2,3 / all / none)

Usuario: all

Claude: Agregados 3 links a backpropagation.md:
        - Linea 5: "gradient descent" → [[gradient-descent|gradient descent]]
        - Linea 8: "neural network" → [[neural-networks-intro|neural network]]
        - Linea 23: "loss function" → [[loss-functions|loss function]]

        Terminos sin nota existente:
        - "chain rule" → Crear nota?

        Crear alguna? (nombre / skip)

Usuario: skip

Claude: Listo! backpropagation.md ahora tiene 3 conexiones.
```

## Ejemplo de uso (--scan-all)

```
Usuario: /link-notes --scan-all

Claude: Leyendo configuración...
        Carpetas: CONOCIMIENTO/, PROYECTOS/, IDEAS/
        
        Escaneando vault completo...

        === REPORTE DE CONEXIONES ===

        Notas huerfanas (0 links): 5
        - CONOCIMIENTO/IA-ML/gradient-descent.md
        - IDEAS/startup-ideas.md

        Notas con alto potencial de conexion:
        - transformers.md: 2 links, 5 potenciales
        - backpropagation.md: 0 links, 4 potenciales

        Total: 45 notas, 5 huerfanas, ~30 conexiones potenciales

        Analizar alguna? (nombre / skip)

Usuario: gradient-descent.md

Claude: [ejecuta analisis individual de esa nota]
```

## Notas importantes

- **Lee vault-config.yml primero** para saber qué carpetas escanear
- NUNCA modifiques el contenido semantico de la nota
- Solo reemplaza terminos por wikilinks, no agregues texto nuevo
- Usa el formato `[[nota|texto-original]]` para preservar el texto visible
- Si un termino aparece multiples veces, solo linkea la primera mencion
- No linkees dentro de bloques de codigo o frontmatter
- Excluye terminos muy genericos ("data", "model", "system")
- **Escanea solo las carpetas que existen en el config**
- Si una carpeta no existe (null), no la escanees

---

*Versión adaptativa - Lee vault-config.yml - Escanea carpetas del config - 2026-01-12*
