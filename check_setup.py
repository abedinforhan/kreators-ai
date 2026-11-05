# ============================================================
# CHECK_SETUP.PY - Confirms Kreators AI installed correctly
# ============================================================
# Run automatically at the end of setup. It checks:
#   1. Python is version 3.12
#   2. Every package has the exact pinned version, and loads without errors
#   3. PyTorch can do a tiny calculation
#   4. The Qwen3 base model was downloaded
# If anything is wrong it says exactly what, in plain words.
# Usage: python check_setup.py requirements-windows.txt
# ============================================================

import os
import platform
import re
import sys
from importlib import metadata

BASE_MODEL = os.environ.get("KREATORS_BASE_MODEL", "Qwen/Qwen3-0.6B")
problems = []


def norm(name):
    return re.sub(r"[-_.]+", "-", name).lower()


req_file = sys.argv[1] if len(sys.argv) > 1 else None

print("=" * 50)
print("          KREATORS AI - INSTALL CHECK")
print("=" * 50)
print(f"Computer : {platform.system()} {platform.release()} ({platform.machine()})")
print(f"Python   : {platform.python_version()}")
print()

# 1. Python version
if sys.version_info[:2] != (3, 12):
    problems.append(f"Python {platform.python_version()} found, but Python 3.12 is required.")

# 2. Package versions
if req_file and os.path.exists(req_file):
    for line in open(req_file, encoding="utf-8"):
        line = line.split("#")[0].strip()
        if "==" not in line:
            continue
        name, wanted = [x.strip() for x in line.split("==", 1)]
        try:
            have = metadata.version(norm(name))
        except metadata.PackageNotFoundError:
            problems.append(f"{name} is not installed (needs {wanted}).")
            print(f"  [MISSING] {name:18} needs {wanted}")
            continue
        have_base = have.split("+")[0]
        if have_base != wanted:
            problems.append(f"{name} is {have}, expected {wanted}.")
            print(f"  [WRONG]   {name:18} has {have}, needs {wanted}")
        else:
            print(f"  [ok]      {name:18} {have}")
else:
    problems.append("No requirements file given to check against.")

# 2b. Every main package actually loads (catches "installed but crashes" problems)
import importlib

for mod in ("numpy", "torch", "tokenizers", "safetensors", "huggingface_hub",
            "transformers", "accelerate", "peft", "datasets"):
    try:
        importlib.import_module(mod)
    except Exception as e:  # noqa: BLE001
        problems.append(f"{mod} is installed but fails to load: {str(e).splitlines()[0]}")
        print(f"  [BROKEN]  {mod:18} {str(e).splitlines()[0]}")
print("  [ok]      all packages load")

# 3. PyTorch works
try:
    import torch

    x = torch.ones(2, 2) @ torch.ones(2, 2)
    assert float(x.sum()) == 8.0
    print(f"  [ok]      PyTorch calculation works")
except Exception as e:  # noqa: BLE001
    problems.append(f"PyTorch does not work: {e}")

# 4. Base model downloaded
try:
    if os.path.isdir(BASE_MODEL):
        print(f"  [ok]      Base model folder found: {BASE_MODEL}")
    else:
        from huggingface_hub import try_to_load_from_cache

        found = try_to_load_from_cache(BASE_MODEL, "config.json")
        if isinstance(found, str):
            print(f"  [ok]      Base model downloaded: {BASE_MODEL}")
        else:
            problems.append(f"Base model {BASE_MODEL} is not downloaded yet.")
except Exception as e:  # noqa: BLE001
    problems.append(f"Could not check the base model: {e}")

print()
if problems:
    print("RESULT: PROBLEMS FOUND")
    for p in problems:
        print(f"  - {p}")
    print()
    print("Please send a screenshot of this screen to your teacher.")
    sys.exit(1)

print("RESULT: ALL GOOD - Kreators AI is ready to use.")
sys.exit(0)
