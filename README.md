# docker nginx php-8 phalcon-5

Docker image Nginx + PHP 8 multi-version (PHP 8.5 & PHP 8.3) dengan Phalcon (5.23 & 5.8), IonCube, SQL Server (sqlsrv, pdo_sqlsrv), Node.js, dan NPM berbasis `webdevops/php-nginx`.

## Tag Image

| Versi PHP | Versi Phalcon | Tag Docker Hub | Tag GHCR | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| **8.5** | `5.23.0` | `nimdasx/nginx-php8-phalcon5:8.5`, `latest` | `ghcr.io/nimdasx/nginx-php8-phalcon5:8.5`, `latest` | Default / Latest |
| **8.3** | `5.23.0` | `nimdasx/nginx-php8-phalcon5:8.3` | `ghcr.io/nimdasx/nginx-php8-phalcon5:8.3` | Stable PHP 8.3 + Phalcon 5.23 |
| **8.3** | `5.8.0`  | `nimdasx/nginx-php8-phalcon5:8.3-phalcon5.8` | `ghcr.io/nimdasx/nginx-php8-phalcon5:8.3-phalcon5.8` | Stable PHP 8.3 + Phalcon 5.8 |

---

## Catatan
- Phalcon 5.23 kompatibel dengan PHP 8.3 dan PHP 8.5.
- Phalcon 5.8 kompatibel dengan PHP 8.3.
- Base image menggunakan Debian (`webdevops/php-nginx`) karena Alpine crash ketika mengaktifkan IonCube Loader.
- Multibuilder lokal dan remote cek [panduan docker buildx](https://github.com/nimdasx/gits/blob/main/docker.md#lokal-builder-for-amd64-remote-builder-for-arm64).

---

## Cara Menjalankan (Run)

```bash
docker run -d -p 80:80 -v /path/to/app:/app --name myapp nimdasx/nginx-php8-phalcon5:latest
```

---

## Cara Build

### 1. Menggunakan Script Helper (`build.sh`)

Tersedia script `build.sh` untuk mempermudah proses build:

```bash
# Tampilkan bantuan
./build.sh --help

# Build lokal (load ke docker images lokal)
./build.sh 8.5                 # Hanya build PHP 8.5 (Phalcon 5.23.0)
./build.sh 8.3                 # Hanya build PHP 8.3 (Phalcon 5.23.0)
./build.sh 8.3-phalcon5.8      # Hanya build PHP 8.3 (Phalcon 5.8.0)
./build.sh all                 # Build semua varian (8.5, 8.3, 8.3-phalcon5.8)

# Build multi-platform (linux/amd64,linux/arm64) dan push ke registry
./build.sh 8.5 --push
./build.sh 8.3 --push
./build.sh 8.3-phalcon5.8 --push
./build.sh all --push
```

### 2. Manual dengan `docker buildx`

#### PHP 8.5 (Default / Latest)
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg PHP_VERSION=8.5 \
  --build-arg PHALCON_VERSION=5.23.0 \
  -t ghcr.io/nimdasx/nginx-php8-phalcon5:8.5 \
  -t ghcr.io/nimdasx/nginx-php8-phalcon5:latest \
  -t nimdasx/nginx-php8-phalcon5:8.5 \
  -t nimdasx/nginx-php8-phalcon5:latest \
  --push .
```

#### PHP 8.3 (Phalcon 5.23.0)
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg PHP_VERSION=8.3 \
  --build-arg PHALCON_VERSION=5.23.0 \
  -t ghcr.io/nimdasx/nginx-php8-phalcon5:8.3 \
  -t nimdasx/nginx-php8-phalcon5:8.3 \
  --push .
```

#### PHP 8.3 (Phalcon 5.8.0)
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg PHP_VERSION=8.3 \
  --build-arg PHALCON_VERSION=5.8.0 \
  -t ghcr.io/nimdasx/nginx-php8-phalcon5:8.3-phalcon5.8 \
  -t nimdasx/nginx-php8-phalcon5:8.3-phalcon5.8 \
  --push .
```

---

## CI/CD (GitHub Actions)

Repositori ini dilengkapi dengan workflow GitHub Actions (`.github/workflows/docker-build.yml`) yang otomatis melakukan matrix build (PHP 8.5 & 8.3 baik Phalcon 5.23 maupun 5.8) untuk arsitektur `linux/amd64` dan `linux/arm64`:
- Terpicu saat push ke branch `master`, `main`, atau membuat release tag `v*`.
- Mendukung trigger manual via **Actions -> Run workflow**.
- Memerlukan secret `DOCKERHUB_USERNAME` dan `DOCKERHUB_TOKEN` jika ingin otomatis push ke Docker Hub (push ke GHCR otomatis aktif via `GITHUB_TOKEN`).
