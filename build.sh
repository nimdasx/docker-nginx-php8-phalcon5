#!/usr/bin/env bash
set -e

# ==============================================================================
# Script Build Docker Multi-Version (PHP 8.5 & PHP 8.3)
# Repositori: docker-nginx-php8-phalcon5
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PHALCON_VERSION_DEFAULT="5.23.0"
REGISTRY_DOCKERHUB="nimdasx/nginx-php8-phalcon5"
REGISTRY_GHCR="ghcr.io/nimdasx/nginx-php8-phalcon5"

print_usage() {
    echo -e "${BLUE}Penggunaan:${NC}"
    echo "  $0 [versi] [opsi]"
    echo ""
    echo -e "${BLUE}Pilihan Versi:${NC}"
    echo "  8.5               Build image PHP 8.5 (Phalcon default: 5.23.0)"
    echo "  8.3               Build image PHP 8.3 (Phalcon default: 5.23.0)"
    echo "  8.3-phalcon5.8    Build image PHP 8.3 dengan Phalcon 5.8.0"
    echo "  all               Build semua varian (8.5, 8.3, 8.3-phalcon5.8)"
    echo ""
    echo -e "${BLUE}Opsi Tambahan:${NC}"
    echo "  --push       Push ke Docker Hub dan GHCR (multi-platform: linux/amd64,linux/arm64)"
    echo "  --no-cache   Build ulang tanpa menggunakan cache Docker"
    echo "  -h, --help   Tampilkan panduan ini"
    echo ""
    echo -e "${BLUE}Contoh:${NC}"
    echo "  $0 8.5                     # Build lokal PHP 8.5 untuk platform lokal"
    echo "  $0 8.3 --push              # Build multi-platform dan push PHP 8.3"
    echo "  $0 8.3-phalcon5.8          # Build lokal PHP 8.3 dengan Phalcon 5.8.0"
    echo "  $0 all --push              # Build multi-platform dan push semua versi"
    echo "  PHALCON_VERSION=5.23.0 $0 all"
}

# Parsing argumen
TARGET_VERSION=""
PUSH_FLAG=false
NO_CACHE_FLAG=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        8.5|8.3|8.3-phalcon5.8|8.3-5.8|all)
            TARGET_VERSION="$1"
            shift
            ;;
        --push)
            PUSH_FLAG=true
            shift
            ;;
        --no-cache)
            NO_CACHE_FLAG=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Argumen tidak dikenal: $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

if [[ -z "$TARGET_VERSION" ]]; then
    echo -e "${YELLOW}Versi target belum ditentukan. Menggunakan target default: all${NC}"
    TARGET_VERSION="all"
fi

build_single_version() {
    local php_ver="$1"
    local phalcon_ver="$2"
    local tag_name="$3"
    local is_latest="$4"

    echo -e "\n${BLUE}============================================================${NC}"
    echo -e "${GREEN}Memulai build PHP ${php_ver} (Phalcon: ${phalcon_ver}) [Tag: ${tag_name}]${NC}"
    echo -e "${BLUE}============================================================${NC}"

    local tags=()
    tags+=("-t" "${REGISTRY_DOCKERHUB}:${tag_name}")
    tags+=("-t" "${REGISTRY_GHCR}:${tag_name}")

    if [[ "$is_latest" == "true" ]]; then
        tags+=("-t" "${REGISTRY_DOCKERHUB}:latest")
        tags+=("-t" "${REGISTRY_GHCR}:latest")
    fi

    local build_opts=()
    if [[ "$NO_CACHE_FLAG" == "true" ]]; then
        build_opts+=("--no-cache")
    fi

    if [[ "$PUSH_FLAG" == "true" ]]; then
        echo -e "${YELLOW}Mode: Multi-Platform (linux/amd64,linux/arm64) + PUSH ke registry${NC}"
        docker buildx build \
            --platform linux/amd64,linux/arm64 \
            --build-arg PHP_VERSION="${php_ver}" \
            --build-arg PHALCON_VERSION="${phalcon_ver}" \
            "${tags[@]}" \
            "${build_opts[@]}" \
            --push .
    else
        echo -e "${YELLOW}Mode: Lokal build (--load ke docker images lokal)${NC}"
        docker buildx build \
            --build-arg PHP_VERSION="${php_ver}" \
            --build-arg PHALCON_VERSION="${phalcon_ver}" \
            "${tags[@]}" \
            "${build_opts[@]}" \
            --load .
    fi

    echo -e "${GREEN}✓ Selesai build PHP ${php_ver} (Phalcon: ${phalcon_ver})!${NC}"
}

default_phalcon="${PHALCON_VERSION:-$PHALCON_VERSION_DEFAULT}"

case "$TARGET_VERSION" in
    8.5)
        build_single_version "8.5" "${default_phalcon}" "8.5" "true"
        ;;
    8.3)
        build_single_version "8.3" "${default_phalcon}" "8.3" "false"
        ;;
    8.3-phalcon5.8|8.3-5.8)
        build_single_version "8.3" "5.8.0" "8.3-phalcon5.8" "false"
        ;;
    all)
        build_single_version "8.5" "${default_phalcon}" "8.5" "true"
        build_single_version "8.3" "${default_phalcon}" "8.3" "false"
        build_single_version "8.3" "5.8.0" "8.3-phalcon5.8" "false"
        ;;
esac

echo -e "\n${GREEN}🎉 Semua proses build selesai!${NC}"
