#!/usr/bin/env bash
# Arnés de verificación de ppto-ventas — HTC21-PLAN-PRUEBAS.md
#
# Uso:
#   ./scripts/verify.sh [L1|L2|L3|L4|L5|L6|all]
#
# Salida: una línea por check —
#   PASS|<capa>|<check>|<observado>
#   FAIL|<capa>|<check>|<esperado>|<observado>
# Exit code 0 = todo verde, 1 = al menos un FAIL, 2 = uso incorrecto.
#
# Variables de entorno (default de producción del proyecto):
#   CONTAINER_NAME (default: ppto-ventas-iris)
#   NAMESPACE      (default: USER)
#   WEB_PORT       (default: 52774)
#   ENV_FILE       (default: .env.docker)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

CONTAINER_NAME="${CONTAINER_NAME:-ppto-ventas-iris}"
NAMESPACE="${NAMESPACE:-USER}"
WEB_PORT="${WEB_PORT:-52774}"
ENV_FILE="${ENV_FILE:-.env.docker}"
BASE="http://localhost:${WEB_PORT}/csp/store-console"

FAILED=0

pass() { printf 'PASS|%s|%s|%s\n' "$1" "$2" "$3"; }
fail() { printf 'FAIL|%s|%s|%s|%s\n' "$1" "$2" "$3" "$4"; FAILED=1; }

run_os() {
  docker exec -i "${CONTAINER_NAME}" bash -lc "/home/irisowner/bin/iris session IRIS -U ${NAMESPACE}"
}

sql_count() {
  local sql="$1"
  local out
  out="$(run_os <<EOF
Set r=##class(%SQL.Statement).%ExecDirect(,"${sql}")
Do r.%Next()
Write "COUNT=",r.%GetData(1),!
Halt
EOF
)"
  echo "${out}" | sed -n 's/^COUNT=\([0-9-]*\).*/\1/p' | tail -1
}

l1() {
  local cap=L1
  docker compose --env-file "${ENV_FILE}" up -d >/dev/null 2>&1
  local insp
  insp="$(docker inspect "${CONTAINER_NAME}" 2>/dev/null)"
  if [[ -z "${insp}" ]]; then
    fail "$cap" "contenedor-existe" "docker inspect ${CONTAINER_NAME} devuelve datos" "sin datos / contenedor no existe"
    return
  fi
  local status mem restart nets
  status="$(docker inspect -f '{{.State.Status}}' "${CONTAINER_NAME}")"
  mem="$(docker inspect -f '{{.HostConfig.Memory}}' "${CONTAINER_NAME}")"
  restart="$(docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' "${CONTAINER_NAME}")"
  nets="$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}' "${CONTAINER_NAME}")"

  [[ "${status}" == "running" ]] && pass "$cap" "estado" "running" || fail "$cap" "estado" "running" "${status}"
  [[ "${mem}" == "4294967296" ]] && pass "$cap" "mem_limit" "4294967296" || fail "$cap" "mem_limit" "4294967296" "${mem}"
  [[ "${restart}" == "unless-stopped" ]] && pass "$cap" "restart_policy" "unless-stopped" || fail "$cap" "restart_policy" "unless-stopped" "${restart}"
  [[ "${nets}" == *htc21-net* ]] && pass "$cap" "red" "incluye htc21-net" "${nets}" || fail "$cap" "red" "incluye htc21-net" "${nets}"

  local ports
  ports="$(docker port "${CONTAINER_NAME}" 2>/dev/null)"
  if echo "${ports}" | grep -q "52773/tcp -> 127.0.0.1:${WEB_PORT}"; then
    pass "$cap" "puerto_web" "127.0.0.1:${WEB_PORT}"
  else
    fail "$cap" "puerto_web" "127.0.0.1:${WEB_PORT}" "$(echo "${ports}" | tr '\n' ';')"
  fi
}

l2() {
  local cap=L2
  local table="MD.SKU"
  local antes despues
  antes="$(sql_count "SELECT COUNT(*) FROM ${table}")"
  if [[ -z "${antes}" ]]; then
    fail "$cap" "conteo_antes" "un número" "vacío — ¿namespace ${NAMESPACE} sin datos cargados (correr L3 primero)?"
    return
  fi

  docker compose --env-file "${ENV_FILE}" down >/dev/null 2>&1
  docker compose --env-file "${ENV_FILE}" up -d >/dev/null 2>&1
  sleep 90

  despues="$(sql_count "SELECT COUNT(*) FROM ${table}")"
  if [[ -z "${despues}" ]]; then
    fail "$cap" "namespace_sobrevive" "namespace ${NAMESPACE} accesible tras down/up" "consulta falló — namespace no existe o durable %SYS no tomó"
    return
  fi
  if [[ "${antes}" == "${despues}" ]]; then
    pass "$cap" "persistencia_${table}" "ANTES=${antes} DESPUES=${despues}"
  else
    fail "$cap" "persistencia_${table}" "ANTES=DESPUES" "ANTES=${antes} DESPUES=${despues}"
  fi
}

l3() {
  local cap=L3
  local repo_count compiled_count
  repo_count="$(find "${REPO_ROOT}/src" -name '*.cls' | wc -l | tr -d ' ')"
  compiled_count="$(sql_count "SELECT COUNT(*) FROM %Dictionary.ClassDefinition WHERE System=0 AND (Name LIKE 'MD.%' OR Name LIKE 'Bronze.%' OR Name LIKE 'Silver.%' OR Name LIKE 'Gold.%' OR Name LIKE 'Config.%' OR Name LIKE 'Ops.%' OR Name LIKE 'Service.%' OR Name LIKE 'API.%')")"
  if [[ "${repo_count}" == "${compiled_count}" ]]; then
    pass "$cap" "clases_compiladas" "${compiled_count} (repo=${repo_count})"
  else
    fail "$cap" "clases_compiladas" "${repo_count}" "${compiled_count}"
  fi

  local categories stores skus pos
  categories="$(sql_count "SELECT COUNT(*) FROM MD.Category")"
  stores="$(sql_count "SELECT COUNT(*) FROM MD.Store")"
  skus="$(sql_count "SELECT COUNT(*) FROM MD.SKU")"
  pos="$(sql_count "SELECT COUNT(*) FROM Bronze.POSEvent")"
  [[ -n "${categories}" && "${categories}" -gt 0 ]] 2>/dev/null && pass "$cap" "maestros_categorias" "${categories} (>0)" || fail "$cap" "maestros_categorias" ">0" "${categories:-vacío}"
  [[ -n "${stores}" && "${stores}" -gt 0 ]] 2>/dev/null && pass "$cap" "maestros_tiendas" "${stores} (>0)" || fail "$cap" "maestros_tiendas" ">0" "${stores:-vacío}"
  [[ -n "${skus}" && "${skus}" -gt 0 ]] 2>/dev/null && pass "$cap" "maestros_skus" "${skus} (>0)" || fail "$cap" "maestros_skus" ">0" "${skus:-vacío}"
  [[ -n "${pos}" && "${pos}" -gt 0 ]] 2>/dev/null && pass "$cap" "mes_mock_mayo_2026" "${pos} eventos POS (>0)" || fail "$cap" "mes_mock_mayo_2026" ">0" "${pos:-vacío}"
}

curl_status() { curl -s -o /dev/null -w '%{http_code}' "$@"; }

l4() {
  local cap=L4
  local code

  code="$(curl_status "${BASE}/health")"
  [[ "${code}" == "200" ]] && pass "$cap" "GET /health" "200" || fail "$cap" "GET /health" "200" "${code}"

  code="$(curl_status "${BASE}/categories")"
  [[ "${code}" == "200" ]] && pass "$cap" "GET /categories" "200" || fail "$cap" "GET /categories" "200" "${code}"

  code="$(curl_status "${BASE}/budgets")"
  [[ "${code}" == "200" ]] && pass "$cap" "GET /budgets" "200" || fail "$cap" "GET /budgets" "200" "${code}"
}

check_page() {
  local cap="$1" check="$2" url="$3" marker="$4"
  local body code
  body="$(curl -s -w '\n%{http_code}' "${url}")"
  code="$(echo "${body}" | tail -1)"
  body="$(echo "${body}" | sed '$d')"
  if [[ "${code}" != "200" ]]; then
    fail "$cap" "$check" "200" "${code}"
    return
  fi
  if echo "${body}" | grep -qF "${marker}"; then
    pass "$cap" "$check" "200 + marcador '${marker}'"
  else
    fail "$cap" "$check" "200 + marcador '${marker}'" "200 sin el marcador"
  fi
}

l5() {
  local cap=L5
  check_page "$cap" "store-console (UI)" "http://localhost:${WEB_PORT}/csp/store-console/" "Consola de acci"
}

l6() {
  local cap=L6
  local out rc

  out="$(IRIS_CONTAINER_NAME="${CONTAINER_NAME}" IRIS_NAMESPACE="${NAMESPACE}" ./scripts/replay_pos_batch.sh apply 2>&1)"
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    pass "$cap" "replay_pos_batch.sh apply" "exit 0"
  else
    fail "$cap" "replay_pos_batch.sh apply" "exit 0" "exit ${rc} — $(echo "${out}" | tail -3 | tr '\n' ' ')"
  fi

  out="$(IRIS_CONTAINER_NAME="${CONTAINER_NAME}" ./scripts/run_tests.sh all 2>&1)"
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    pass "$cap" "run_tests.sh all" "exit 0"
  else
    fail "$cap" "run_tests.sh all" "exit 0" "exit ${rc} — $(echo "${out}" | tail -3 | tr '\n' ' ')"
  fi
}

case "${1:-all}" in
  L1) l1 ;;
  L2) l2 ;;
  L3) l3 ;;
  L4) l4 ;;
  L5) l5 ;;
  L6) l6 ;;
  all) l1; l2; l3; l4; l5; l6 ;;
  *) echo "uso: $0 [L1|L2|L3|L4|L5|L6|all]" >&2; exit 2 ;;
esac

exit "${FAILED}"
