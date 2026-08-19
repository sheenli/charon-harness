#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESKTOP="$ROOT/upstream/deepseek-harness-desktop"

echo "==> 构建插件"
(cd "$ROOT/plugins/dsh-plugin-subscriptions" && corepack pnpm install && corepack pnpm build)

echo "==> 启动桌面 (dev)"
(cd "$DESKTOP" && corepack yarn dev)
