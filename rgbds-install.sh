#!/bin/bash
set -e

RGBDS_VERSION="1.0.1"
RGBDS_DIR="rgbds"

WIN64_URL="https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VERSION}/rgbds-win64.zip"
WIN32_URL="https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VERSION}/rgbds-win32.zip"
LINUX_URL="https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VERSION}/rgbds-linux-x86_64.tar.xz"
MAC_URL="https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VERSION}/rgbds-macos.zip"

echo "Detecting operating system..."

case "$(uname -s)" in
    Linux*)
        OS="linux"
        ;;
    Darwin*)
        OS="mac"
        ;;
    MINGW64_NT*|MSYS_NT*|CYGWIN_NT*)
        OS="win64"
        ;;
    MINGW32_NT*)
        OS="win32"
        ;;
    *)
        echo "Unsupported OS: $(uname -s)"
        exit 1
        ;;
esac

echo "Detected OS: $OS"

echo "Checking dependencies..."
if [ "$OS" = "linux" ]; then
    PKG_MANAGER=""
    if command -v apt >/dev/null 2>&1; then
        PKG_MANAGER="sudo apt install -y"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MANAGER="sudo dnf install -y"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MANAGER="sudo pacman -Sy --noconfirm"
    elif command -v pkg >/dev/null 2>&1; then
        PKG_MANAGER="pkg install -y"
    fi

    if [ -n "$PKG_MANAGER" ]; then
        $PKG_MANAGER libpng flex bison unzip || true
    else
        echo "Warning: could not detect package manager; please install libpng, flex, bison, and unzip manually."
    fi
else
    if ! command -v unzip >/dev/null 2>&1; then
        echo "Installing unzip..."
        if command -v brew >/dev/null 2>&1; then
            brew install unzip
        else
            echo "Please install unzip manually."
            exit 1
        fi
    fi
fi

if [ -d "$RGBDS_DIR" ]; then
    echo "Removing existing '$RGBDS_DIR' directory..."
    rm -rf "$RGBDS_DIR"
fi

mkdir -p "$RGBDS_DIR"
cd "$RGBDS_DIR"

echo "Downloading RGBDS ${RGBDS_VERSION} for $OS..."

case "$OS" in
    win64)
        URL="$WIN64_URL"
        ;;
    win32)
        URL="$WIN32_URL"
        ;;
    linux)
        URL="$LINUX_URL"
        ;;
    mac)
        URL="$MAC_URL"
        ;;
esac

FILENAME=$(basename "$URL")
curl -L -o "$FILENAME" "$URL"

echo "Extracting..."
if [[ "$FILENAME" == *.zip ]]; then
    unzip -o "$FILENAME"
elif [[ "$FILENAME" == *.tar.xz ]]; then
    tar -xf "$FILENAME"
fi

echo "Cleaning up..."
rm -f "$FILENAME"

echo "RGBDS ${RGBDS_VERSION} successfully installed in '$RGBDS_DIR'."
