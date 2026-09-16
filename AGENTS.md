# Reglas para agentes en este repo

## El código se carga siempre desde `src/`

Nunca compilar o modificar código directo contra la instancia IRIS y dejarlo solo ahí:
así fue como el módulo `MANTEN` (repo `manten`) terminó cuatro meses viviendo dentro de
un contenedor sin que ningún repo lo reflejara.

Este repo monta `src/`, `data/`, `tests/` y `frontend/` como volúmenes del contenedor
(ver `docker-compose.yml`), o se cargan con `scripts/load_classes.sh`, que compila cada
clase vía `iris session` por stdin. Editar siempre en el repo, no dentro del contenedor.

```bash
./scripts/load_classes.sh
```

## Los datos se regeneran desde los scripts de poblado

No restaurar datos desde exports ni backups. El poblado vive en `scripts/`:

```bash
./scripts/load_mock_master_data.sh
./scripts/load_may_2026_mock_data.sh   # generate_may_2026_mock_data.py + carga
```

Un `docker rm` del contenedor no debe ser un evento que preocupe: los datos se
regeneran desde acá.

## Nada de `.env` en git

`.env.docker` y cualquier archivo con credenciales quedan fuera de git (`.gitignore`).
Se versiona solo `.env.docker.example`, con placeholders y **sin rutas absolutas de
máquina** (`WORKSPACE_DIR` no va fijo: `docker-compose.yml` ya resuelve
`${WORKSPACE_DIR:-.}` al directorio del proyecto). Si un agente necesita agregar una
variable de entorno nueva, la agrega al `.example`, nunca al archivo real.
