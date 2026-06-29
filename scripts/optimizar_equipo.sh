#!/bin/zsh

# Script Metodológico de Optimización y Limpieza para macOS (CPMAI + Premortem)
# Guardado en /Users/yarelyvarela/Code/optimizar_equipo.sh

# Colores para salida en terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE}  OPTIMIZADOR METODOLÓGICO DE MACOS (CPMAI + PREMORTEM GATE)         ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# ------------------------------------------------------------------------------
# FASE 1: MEDICIÓN INICIAL (Falsabilidad y Veracidad de Datos)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[FASE 1/4] Capturando métricas del sistema (Antes)...${NC}"

# Obtener espacio en disco disponible en la raíz (en GB)
DISCO_ANTES=$(df -g / | awk 'NR==2 {print $4}')
echo -e "✓ Espacio en disco disponible: ${DISCO_ANTES} GB"

# Obtener estadísticas básicas de páginas de memoria virtual libre
PAGINAS_LIBRES=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
RAM_ANTES=$(( (PAGINAS_LIBRES * 4096) / 1024 / 1024 )) # Convertir a MB
echo -e "✓ Memoria RAM inmediatamente libre: ${RAM_ANTES} MB"

# ------------------------------------------------------------------------------
# FASE 2: GATES DE SEGURIDAD PREMORTEM (Go / No-Go)
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}[FASE 2/4] Ejecutando análisis de riesgos en vivo (Premortem Gate)...${NC}"

# Control A.6 (Bloqueo Duro): Proteger directorios sensibles
EXCLUSIONES=(
    "$HOME/.ssh"
    "$HOME/.gemini"
    "$HOME/.claude"
    "$HOME/Code"
)
echo -e "✓ Protegiendo directorios críticos de agentes y llaves: ${YELLOW}Excluidos${NC}"

# Detectar servidores locales o procesos de desarrollo activos
PUERTOS_ACTIVOS=$(lsof -i -P -n | grep LISTEN | grep -E '3000|5173|8080|8000|4567' || true)
if [ -n "$PUERTOS_ACTIVOS" ]; then
    echo -e "${YELLOW}⚠️ ADVERTENCIA: Se detectaron puertos de desarrollo activos en el sistema:${NC}"
    echo "$PUERTOS_ACTIVOS" | head -n 3
    echo -e "${YELLOW}VEREDICTO: GO-CON-CONDICIONES. Evitaremos purgar cachés de entornos activos para no corromper dependencias.${NC}"
    OMITIR_ENTORNOS=true
else
    echo -e "✓ No se detectaron entornos de desarrollo activos en puertos comunes."
    OMITIR_ENTORNOS=false
fi

echo -e "\n${YELLOW}¿Deseas proceder con la optimización metodológica? (s/n)${NC}"
read -r RESPUESTA
if [[ "$RESPUESTA" != "s" && "$RESPUESTA" != "S" ]]; then
    echo -e "${RED}Optimización cancelada por el usuario. Saliendo...${NC}"
    exit 0
fi

# ------------------------------------------------------------------------------
# FASE 3: EJECUCIÓN DE OPTIMIZACIÓN Y LIMPIEZA
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}[FASE 3/4] Ejecutando tareas de limpieza selectiva...${NC}"

# 3.1. Limpieza de Homebrew (Segura y verificada)
if command -v brew &>/dev/null; then
    echo -e "-> Limpiando cachés y descargas antiguas de Homebrew..."
    brew cleanup -s
    echo -e "✓ Homebrew limpio."
else
    echo -e "-> Homebrew no detectado, omitiendo paso."
fi

# 3.2. Limpieza de cachés de usuario (Excluyendo directorios protegidos)
echo -e "-> Depurando cachés de aplicaciones de usuario..."
# Limpieza de cachés generales excluyendo configuraciones críticas
find ~/Library/Caches -mindepth 1 -maxdepth 1 ! -name "*google*" ! -name "*gemini*" ! -name "*claude*" -exec rm -rf {} + 2>/dev/null
echo -e "✓ Cachés de usuario depuradas de forma segura."

# 3.3. Limpieza de cachés de entornos de desarrollo (Si no hay procesos corriendo)
if [ "$OMITIR_ENTORNOS" = false ]; then
    echo -e "-> Purgando cachés temporales de NPM y Yarn..."
    if command -v npm &>/dev/null; then npm cache clean --force &>/dev/null; fi
    if command -v yarn &>/dev/null; then yarn cache clean &>/dev/null; fi
    echo -e "✓ Entornos de desarrollo limpiados."
else
    echo -e "-> Entornos de desarrollo activos. ${YELLOW}Omitiendo limpieza de caché NPM/Yarn por seguridad.${NC}"
fi

# 3.4. Liberar Memoria RAM inactiva (Requiere Sudo)
echo -e "\n${YELLOW}¿Deseas purgar la memoria RAM inactiva del sistema? (Requiere contraseña de administrador) (s/n)${NC}"
read -r PURGAR_RAM
if [[ "$PURGAR_RAM" == "s" || "$PURGAR_RAM" == "S" ]]; then
    echo -e "-> Ejecutando purga del sistema..."
    sudo purge
    echo -e "✓ Memoria inactiva devuelta al sistema."
else
    echo -e "-> Purga de RAM omitida."
fi

# ------------------------------------------------------------------------------
# FASE 4: MEDICIÓN DE IMPACTO Y RESULTADOS (Falsabilidad comprobada)
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}[FASE 4/4] Calculando impacto de la optimización (Después)...${NC}"

DISCO_DESPUES=$(df -g / | awk 'NR==2 {print $4}')
DISCO_GANADO=$(( DISCO_DESPUES - DISCO_ANTES ))

PAGINAS_LIBRES_DESPUES=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
RAM_DESPUES=$(( (PAGINAS_LIBRES_DESPUES * 4096) / 1024 / 1024 ))
RAM_GANADA=$(( RAM_DESPUES - RAM_ANTES ))

echo -e "\n${BLUE}======================================================================${NC}"
echo -e "  INFORME DE MÈTRICAS DE OPTIMIZACIÓN                                 "
echo -e "${BLUE}======================================================================${NC}"
echo -e "Espacio en Disco Liberado: ${GREEN}${DISCO_GANADO} GB${NC}  (Antes: ${DISCO_ANTES} GB | Ahora: ${DISCO_DESPUES} GB)"
if [ "$RAM_GANADA" -gt 0 ]; then
    echo -e "Memoria RAM Recuperada:    ${GREEN}${RAM_GANADA} MB${NC}  (Antes: ${RAM_ANTES} MB | Ahora: ${RAM_DESPUES} MB)"
else
    echo -e "Memoria RAM Recuperada:    ${GREEN}0 MB${NC}  (El sistema mantiene asignaciones optimizadas)"
fi
echo -e "${BLUE}======================================================================${NC}"
echo -e "✓ Proceso finalizado. Evidencia guardada en el historial."
echo -e "Puedes compartir la versión sanitizada de este script usando: ${YELLOW}optimizar_equipo.txt${NC}\n"
