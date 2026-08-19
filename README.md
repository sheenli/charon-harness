# Charon Harness

基于 [DSH Desktop](https://github.com/anywhere-labs/deepseek-harness-desktop) 的私有定制仓库。

## 结构

```
charon-harness/                      本仓库（私有）
├── upstream/
│   └── deepseek-harness-desktop/    submodule = GitHub fork（sheenli/CharonHarness）
│       ├── deepseek-harness/        嵌套 submodule（上游 DSH）
│       ├── dsh-plugin-desktop/      ★ 深度布局改动只在这里
│       ├── dsh-community-market/
│       └── dsh-community-fabric/
├── plugins/                         自己的插件（隔离，不改上游）
│   └── dsh-plugin-subscriptions/
└── scripts/
    ├── setup.sh
    ├── dev.sh
    ├── package-mac.sh
    └── bump-fork.sh
```

## 分工原则

| 东西 | 放哪 | 是否碰上游 |
| --- | --- | --- |
| 深度布局（改框架结构） | fork 的 `dsh-plugin-desktop/src/client/` | 是（唯一允许改的地方） |
| 自己的插件 | `plugins/`，装进 profile | 否 |
| 脚本 | `scripts/` | 否 |

## 首次搭建

```sh
./scripts/setup.sh
```

## 日常开发

```sh
./scripts/dev.sh          # 构建插件 + 启动桌面
./scripts/package-mac.sh  # 打包 arm64 .app（未签名）
```

## 桌面 Git 工具（推荐 Fork）工作流

日常 git 全部在 **Fork**（或其他 GUI）里点按钮，只有下面几个"粘合动作"用脚本：

| 动作 | 方式 |
| --- | --- |
| 拉上游 / 合并 / 开分支 / 提交 / push | Fork 里点按钮 |
| 更新 fork 后同步外层版本 | `./scripts/bump-fork.sh` |
| 构建 + 启动 | `./scripts/dev.sh` |
| 打包 | `./scripts/package-mac.sh` |
| 首次搭建 | `./scripts/setup.sh` |

**Fork 里同步上游的步骤**（把下面换成点按钮即可）：
1. 打开 fork 仓库，`Fetch` 上游
2. 在 `master` 上 `Merge` `upstream/master`（冲突只看布局文件）
3. `Push` 到 `origin`
4. 回外层仓库跑 `./scripts/bump-fork.sh`（一条命令锁定版本）

## 同步上游（命令行等价写法）

```sh
cd upstream/deepseek-harness-desktop
git fetch upstream
git merge upstream/master   # 冲突只可能出现在布局文件
git push origin master
cd ../..
./scripts/bump-fork.sh
```

## 深度布局开发

```sh
cd upstream/deepseek-harness-desktop
git checkout -b feat/my-layout   # 永远在分支上改，不在 master
# 改 dsh-plugin-desktop/src/client/ 下的文件
```

## 关键注意

- `master` 保持干净（= 上游 + 你的合入），不要在上面直接改。
- 打包必须带 `--config.npmRebuild=false`，否则 macOS 26 上 node-pty 源码编译会失败。
