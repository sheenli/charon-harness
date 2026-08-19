#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORK="${CHARON_FORK:-$ROOT/../charon-harness-desktop}"   # 独立 fork checkout（有 upstream 远程）
SUB="$ROOT/upstream/deepseek-harness-desktop"            # submodule 里的 fork

echo "==> 1/4 拉上游 + 合并 (独立 fork checkout)"
git -C "$FORK" fetch upstream
git -C "$FORK" checkout master
git -C "$FORK" merge upstream/master

echo "==> 2/4 push 到 Gitea 主仓 + GitHub 镜像"
git -C "$FORK" push origin master
git -C "$FORK" push github master

echo "==> 3/4 同步 submodule 里的 fork (从 Gitea 主仓拉最新)"
git -C "$SUB" fetch origin
git -C "$SUB" checkout master
git -C "$SUB" pull --ff-only origin master

echo "==> 4/4 bump 外层仓 submodule 指针"
cd "$ROOT"
git add upstream/deepseek-harness-desktop
if git diff --cached --quiet; then
  echo "submodule 指针没变，无需 bump"
  exit 0
fi
SHA="$(git -C "$SUB" rev-parse --short HEAD)"
git commit -m "chore: bump fork to $SHA"
echo "==> 完成。外层仓的 bump 提交已生成，记得 push 外层仓"
