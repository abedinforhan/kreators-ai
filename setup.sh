#!/usr/bin/env bash
# Kreators AI setup for Mac (Apple Silicon + Intel) and Linux.
# Run with:  bash setup.sh
cd "$(dirname "$0")" || exit 1

fail () { echo; echo "SETUP FAILED: $1"; [ -n "$2" ] && echo "$2"; exit 1; }

echo "=================================================="
echo "           KREATORS AI - SETUP (Mac / Linux)"
echo "=================================================="
echo "Installing everything needed. This takes 10-15 minutes."
echo

OS="$(uname -s)"

# ---------- macOS version check ----------
if [ "$OS" = "Darwin" ]; then
    MAC_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
    if [ "$MAC_MAJOR" -lt 12 ] 2>/dev/null; then
        fail "This Mac runs macOS $(sw_vers -productVersion). Kreators AI needs macOS 12 (Monterey) or newer." \
             "Update macOS in System Settings > Software Update, or use a newer computer."
    fi
fi

# ---------- 1. Find Python 3.12 ----------
find_python () {
    for c in python3.12 \
             /Library/Frameworks/Python.framework/Versions/3.12/bin/python3.12 \
             /opt/homebrew/bin/python3.12 /usr/local/bin/python3.12 python3; do
        if command -v "$c" >/dev/null 2>&1; then
            v="$("$c" -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null)"
            if [ "$v" = "3.12" ]; then PY="$(command -v "$c")"; return 0; fi
        fi
    done
    return 1
}

PY=""
if find_python; then
    echo "[1/5] Python 3.12 found: $PY"
else
    echo "[1/5] Python 3.12 not found. Installing it (your computer password may be asked)..."
    if [ "$OS" = "Darwin" ]; then
        PKG_URL="https://www.python.org/ftp/python/3.12.10/python-3.12.10-macos11.pkg"
        TMP_PKG="$(mktemp -d)/python312.pkg"
        curl -fL --retry 3 -o "$TMP_PKG" "$PKG_URL" || fail "Could not download Python." \
            "Install Python 3.12 by hand from https://www.python.org/downloads/ then run: bash setup.sh"
        sudo installer -pkg "$TMP_PKG" -target / || fail "Python installer did not finish." \
            "Install Python 3.12 by hand from https://www.python.org/downloads/ then run: bash setup.sh"
        "/Applications/Python 3.12/Install Certificates.command" >/dev/null 2>&1 || true
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y python3.12 python3.12-venv
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y python3.12
    else
        fail "No supported way to install Python here." "Install Python 3.12 from https://www.python.org/downloads/ then run: bash setup.sh"
    fi
    find_python || fail "Python 3.12 still not found after install." \
        "Close this window, open a new Terminal, and run: bash setup.sh"
fi

# ---------- 2. Pick the right pinned package list for THIS computer ----------
ARCH="$("$PY" -c 'import platform; print(platform.machine())')"
if [ "$OS" = "Darwin" ] && [ "$ARCH" = "x86_64" ]; then
    REQ="requirements-mac-intel.txt"
    echo "      Intel Mac detected -> using $REQ"
elif [ "$OS" = "Darwin" ]; then
    REQ="requirements-mac-arm.txt"
    echo "      Apple Silicon Mac detected -> using $REQ"
else
    REQ="requirements-windows.txt"
    echo "      Linux detected -> using $REQ"
fi

echo "[2/5] Creating workspace..."
rm -rf .venv
"$PY" -m venv .venv || fail "Could not create the workspace." ""
[ -x .venv/bin/python ] || fail "Workspace was not created." ""

# ---------- 3. Install the exact pinned versions ----------
echo "[3/5] Installing AI tools (the slow part, please wait)..."
PIP=".venv/bin/python -m pip"
FLAGS="--disable-pip-version-check --no-input --default-timeout 100 --retries 5"
$PIP install $FLAGS --upgrade pip || fail "pip upgrade failed. Check your internet." ""
if [ "$OS" = "Linux" ]; then
    # On Linux the normal PyTorch pulls ~3 GB of GPU files nobody needs. Use the CPU build.
    $PIP install $FLAGS --index-url https://download.pytorch.org/whl/cpu "torch==2.14.0" \
        || fail "PyTorch install failed." ""
fi
$PIP install $FLAGS --only-binary=:all: -r "$REQ" || fail "Package install failed. See the message above." \
    "If you see 'No matching distribution', send a screenshot to your teacher."

# ---------- 4. Download the base model ----------
echo "[4/5] Downloading the Qwen3-0.6B base model (about 1.5 GB)..."
.venv/bin/python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; AutoTokenizer.from_pretrained('Qwen/Qwen3-0.6B'); AutoModelForCausalLM.from_pretrained('Qwen/Qwen3-0.6B'); print('Qwen3 downloaded.')" \
    || fail "Model download failed." "Check your internet and run: bash setup.sh"

# ---------- 5. Verify everything ----------
echo "[5/5] Checking the install..."
.venv/bin/python check_setup.py "$REQ" || exit 1
touch .venv/kreators_setup_v2.ok

echo
echo "=================================================="
echo "  SETUP COMPLETE!  Run: bash start.sh"
echo "=================================================="
