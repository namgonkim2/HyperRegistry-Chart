#!/bin/bash
set -e


REG="docker.io/bitnami"
IMGS=( "redis:6.2.4-debian-10-r13" "redis-sentinel:6.2.4-debian-10-r14" "redis-exporter:1.24.0-debian-10-r9" "redis-sentinel-exporter:1.7.1-debian-10-r161"  "bitnami-shell:10-debian-10-r112" )
CLIENT=${CLI:=podman}

function usage() {
  echo "[Usage]: CLI=<registry_client(default: podman)> ./redis-download.sh <save_dir>(default: downloads)"
  echo "    ex): CLI=docker ./redis-download.sh archive"
}

function check_client() {
  if [ ! -e "$(which ${CLIENT})" ]
  then
    echo "${CLIENT} is not installed."
    exit 1
  fi
}

function check_savedir() {
  if [ ! -e $SAVEDIR ]
  then
    echo "no save directory found. create new one... "
    mkdir $SAVEDIR
  fi
}

SAVEDIR=${1=downloads}

check_client
check_savedir

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

for IMG in "${IMGS[@]}"; do
  echo -e  "${BLUE}Pulling image ${REG}/${IMG}${NC}"
  ${CLIENT} pull "${REG}/${IMG}"
  echo -e ${IMG/:/-}
  ${CLIENT} save "${REG}/${IMG}" -o "${SAVEDIR}/${IMG/:/_}.tar"
  echo -e  "${RED}Saved to ${SAVEDIR}/${SAVEIMG}.tar${NC}"
done
