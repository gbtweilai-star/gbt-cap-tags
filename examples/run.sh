#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_cap_tags info
PYTHONPATH=src python -m gbt_cap_tags check --payload '{}'
PYTHONPATH=src python -m gbt_cap_tags run   --payload '{}'
