#!/usr/bin/env bash
set -euo pipefail

# Ensure Vagrant stores boxes/state in a location with enough space.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export VAGRANT_HOME="${VAGRANT_HOME:-"$PROJECT_ROOT/.vagrant.d"}"

mkdir -p "$VAGRANT_HOME"
echo "Using VAGRANT_HOME=$VAGRANT_HOME"

cd "$PROJECT_ROOT"
exec vagrant "$@"
