#!/usr/bin/env bash
# install_rgbds.sh — Download & install RGBDS pre-built binaries
# Auto-detects OS and architecture.
# Supports:
#   Linux   — x86_64 only  (Debian/Ubuntu, Fedora, Arch, Alpine, Void, openSUSE, Gentoo)
#   macOS   — Intel x86_64 + Apple Silicon arm64  (universal binary)
#   Windows — MSYS2 (MINGW64, UCRT64, CLANG64, MINGW32), Cygwin, Git Bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────
RGBDS_VERSION="1.0.0"
RGBDS_DIR="rgbds"
BASE_URL="https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VERSION}"

# Asset filenames — version number intentionally absent (upstream convention since v0.9.3)
ASSET_WIN64="rgbds-win64.zip"
ASSET_WIN32="rgbds-win32.zip"
ASSET_MACOS="rgbds-macos.zip"
ASSET_LINUX="rgbds-linux-x86_64.tar.xz"

# ── Pretty logging ────────────────────────────────────────────────────────────
info() { printf '\033[1;34m=>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m  %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
step() { printf '\n\033[1;37m── %s\033[0m\n' "$*"; }

# ═════════════════════════════════════════════════════════════════════════════
# 1. OS + ARCH DETECTION
# ═════════════════════════════════════════════════════════════════════════════
step "Detecting platform"

OS=""
ARCH="$(uname -m)"

# ── Windows (MSYS2 / MINGW / Cygwin / Git Bash) ───────────────────────────────
# $MSYSTEM is checked first — it is the most reliable signal inside MSYS2 and
# is populated regardless of how the terminal was launched (Git Bash, VS Code, CI…).
if [[ -n "${MSYSTEM:-}" ]]; then
    case "${MSYSTEM}" in
        MINGW64 | UCRT64 | CLANG64 | CLANGARM64)
            OS="win64" ;;
        MINGW32 | CLANG32)
            OS="win32" ;;
        MSYS)
            # Plain MSYS shell — still a Windows host; default to 64-bit binary
            OS="win64" ;;
        *)
            warn "Unknown MSYSTEM='${MSYSTEM}'; assuming win64."
            OS="win64" ;;
    esac
fi

# ── Fallback: inspect uname -s ────────────────────────────────────────────────
if [[ -z "${OS}" ]]; then
    KERNEL="$(uname -s)"
    case "${KERNEL}" in
        Linux*)
            [[ "${ARCH}" == "x86_64" ]] \
                || die "Only x86_64 is supported for Linux pre-built binaries (got: ${ARCH}).
Build from source instead: https://rgbds.gbdev.io/install/source"
            OS="linux"
            ;;
        Darwin*)
            # Universal binary — covers both Intel (x86_64) and Apple Silicon (arm64)
            OS="mac"
            ;;
        MINGW64_NT* | UCRT64_NT*)  OS="win64" ;;
        MINGW32_NT*)                OS="win32" ;;
        MSYS_NT* | CYGWIN_NT*)
            # Treat as 64-bit Windows (32-bit Cygwin is essentially extinct)
            OS="win64" ;;
        *)
            die "Unsupported operating system: ${KERNEL}" ;;
    esac
fi

# ── Resolve asset + label ─────────────────────────────────────────────────────
case "${OS}" in
    win64) ASSET="${ASSET_WIN64}" ; OS_LABEL="Windows 64-bit (MSYS2/MINGW/Cygwin)" ;;
    win32) ASSET="${ASSET_WIN32}" ; OS_LABEL="Windows 32-bit (MSYS2/MINGW)" ;;
    mac)   ASSET="${ASSET_MACOS}" ; OS_LABEL="macOS — universal (Intel + Apple Silicon)" ;;
    linux) ASSET="${ASSET_LINUX}" ; OS_LABEL="Linux x86_64" ;;
    *)     die "Unhandled OS variant: ${OS}" ;;
esac

ok "Platform : ${OS_LABEL}"
ok "Asset    : ${ASSET}"

# ═════════════════════════════════════════════════════════════════════════════
# 2. DEPENDENCY CHECK + INSTALL
# ═════════════════════════════════════════════════════════════════════════════
step "Checking dependencies"

install_linux_deps() {
    local pkgs="libpng flex bison unzip"
    if   command -v apt-get      >/dev/null 2>&1; then
        info "Using apt-get…"; sudo apt-get install -y ${pkgs}
    elif command -v dnf          >/dev/null 2>&1; then
        info "Using dnf…";     sudo dnf install -y ${pkgs}
    elif command -v zypper       >/dev/null 2>&1; then
        info "Using zypper…";  sudo zypper install -y ${pkgs}
    elif command -v pacman       >/dev/null 2>&1; then
        info "Using pacman…";  sudo pacman -Sy --noconfirm ${pkgs}
    elif command -v apk          >/dev/null 2>&1; then
        info "Using apk…";     sudo apk add --no-cache libpng flex bison unzip
    elif command -v xbps-install >/dev/null 2>&1; then
        info "Using xbps…";    sudo xbps-install -Sy libpng flex bison unzip
    elif command -v emerge       >/dev/null 2>&1; then
        info "Using emerge…";  sudo emerge --ask=n media-libs/libpng sys-devel/flex sys-devel/bison app-arch/unzip
    elif command -v pkg          >/dev/null 2>&1; then
        info "Using pkg…";     pkg install -y ${pkgs}
    else
        warn "No supported package manager found. Please install manually: ${pkgs}"
    fi
}

ensure_unzip() {
    command -v unzip >/dev/null 2>&1 && return
    info "unzip not found — attempting install…"
    if   command -v pacman  >/dev/null 2>&1; then pacman -S --noconfirm unzip  # MSYS2
    elif command -v brew    >/dev/null 2>&1; then brew install unzip            # macOS Homebrew
    elif command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y unzip
    else die "Could not install unzip automatically. Please install it and retry."
    fi
}

ensure_downloader() {
    command -v curl >/dev/null 2>&1 && return
    command -v wget >/dev/null 2>&1 && return
    info "Neither curl nor wget found — attempting to install curl…"
    if   command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y curl
    elif command -v dnf     >/dev/null 2>&1; then sudo dnf install -y curl
    elif command -v pacman  >/dev/null 2>&1; then sudo pacman -Sy --noconfirm curl
    elif command -v apk     >/dev/null 2>&1; then sudo apk add --no-cache curl
    else die "No downloader available. Please install curl or wget and retry."
    fi
}

case "${OS}" in
    linux) install_linux_deps ;;
    mac)   ensure_unzip ;;
    win*)  ensure_unzip ;;
esac
ensure_downloader
ok "Dependencies satisfied."

# ═════════════════════════════════════════════════════════════════════════════
# 3. DOWNLOAD
# ═════════════════════════════════════════════════════════════════════════════
step "Downloading RGBDS ${RGBDS_VERSION}"

if [[ -d "${RGBDS_DIR}" ]]; then
    info "Removing existing '${RGBDS_DIR}' directory…"
    rm -rf "${RGBDS_DIR}"
fi
mkdir -p "${RGBDS_DIR}"

DOWNLOAD_URL="${BASE_URL}/${ASSET}"
DOWNLOAD_DEST="${RGBDS_DIR}/${ASSET}"

info "  ${DOWNLOAD_URL}"

if command -v curl >/dev/null 2>&1; then
    curl -fsSL --retry 3 --retry-delay 2 -o "${DOWNLOAD_DEST}" "${DOWNLOAD_URL}"
else
    wget -q --tries=3 -O "${DOWNLOAD_DEST}" "${DOWNLOAD_URL}"
fi
ok "Download complete."

# ═════════════════════════════════════════════════════════════════════════════
# 4. EXTRACT
# ═════════════════════════════════════════════════════════════════════════════
step "Extracting"

cd "${RGBDS_DIR}"
case "${ASSET}" in
    *.zip)    unzip -q -o "${ASSET}" ;;
    *.tar.xz) tar -xf    "${ASSET}" ;;
    *.tar.gz) tar -xzf   "${ASSET}" ;;
    *)        die "Unknown archive format: ${ASSET}" ;;
esac
rm -f "${ASSET}"
ok "Extracted to '${RGBDS_DIR}/'."

# ═════════════════════════════════════════════════════════════════════════════
# 5. DONE
# ═════════════════════════════════════════════════════════════════════════════
printf '\n'
ok "RGBDS ${RGBDS_VERSION} is ready in '${RGBDS_DIR}/'."

case "${OS}" in
    mac)
        info "To install system-wide:  cd ${RGBDS_DIR} && sudo bash install.sh"
        info "To verify:               ./${RGBDS_DIR}/rgbasm -V"
        ;;
    win*)
        info "Copy the .exe and .dll files to a directory on your PATH (e.g. /usr/local/bin)."
        info "To verify:               ./${RGBDS_DIR}/rgbasm.exe -V"
        ;;
    linux)
        info "Add '${RGBDS_DIR}/' to your PATH, or copy the binaries to /usr/local/bin."
        info "To verify:               ./${RGBDS_DIR}/rgbasm -V"
        ;;
esac
