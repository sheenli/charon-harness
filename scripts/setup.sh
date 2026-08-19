#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> 1/3 初始化 submodule"
git submodule update --init --recursive

echo "==> 2/3 安装 fork 依赖"
(cd "$ROOT/upstream/deepseek-harness-desktop" && corepack enable && corepack yarn install --immutable)

echo "==> 3/3 把插件装进 desktop profile"
# 需要全局 dsh CLI；首次先执行一次：pnpm add -g @deepseek-ai/dsh
dsh plugin --profile desktop add "file:$ROOT/plugins/dsh-plugin-subscriptions"

echo "setup 完成"
