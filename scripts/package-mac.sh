#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESKTOP="$ROOT/upstream/deepseek-harness-desktop/dsh-plugin-desktop"

echo "==> 打包 arm64 .app（跳过原生重编，用预编译产物）"
cd "$DESKTOP"
CSC_IDENTITY_AUTO_DISCOVERY=false node node_modules/electron-builder/cli.js --dir --config.npmRebuild=false

echo "==> 产物: $DESKTOP/dist/mac-arm64/DSH Desktop.app"
