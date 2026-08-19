#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SUB="$ROOT/upstream/deepseek-harness-desktop"

# 1. 让 submodule 拿到 fork 的最新 master（GUI 里已完成 pull 的话这步是无害的 no-op）
echo "==> 同步 fork master"
git -C "$SUB" fetch origin
git -C "$SUB" checkout master
git -C "$SUB" pull --ff-only origin master

# 2. 把 submodule 新指针记录到外层仓库
cd "$ROOT"
git add upstream/deepseek-harness-desktop
if git diff --cached --quiet; then
  echo "==> submodule 指针没变，无需 bump"
  exit 0
fi

SHA="$(git -C "$SUB" rev-parse --short HEAD)"
git commit -m "chore: bump fork to $SHA"
echo "==> 已提交 bump，接下来在 Fork 里 push 外层仓库即可"
