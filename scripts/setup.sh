#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESKTOP="$ROOT/upstream/deepseek-harness-desktop"
DSH="$DESKTOP/dsh-plugin-desktop/node_modules/.bin/dsh"

echo "==> 1/4 初始化 submodule"
git submodule update --init --recursive

echo "==> 2/4 安装 fork 依赖"
(cd "$DESKTOP" && corepack enable && corepack yarn install --immutable)

echo "==> 3/4 下载 Electron 二进制（yarn 因 enableScripts=false 跳过了）"
(cd "$DESKTOP/dsh-plugin-desktop/node_modules/electron" \
  && ELECTRON_MIRROR="${ELECTRON_MIRROR:-https://npmmirror.com/mirrors/electron/}" node install.js)

echo "==> 4/4 把插件装进 desktop profile"
"$DSH" plugin --profile desktop add "file:$ROOT/plugins/dsh-plugin-subscriptions"

echo "setup 完成"
