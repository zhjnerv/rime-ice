## 📝 更新日志

### 🐛 Bug修复

- [[`a3624d8`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/a3624d804886f0aa30bab3920b93343006eac73e)] **-** 修复手动排序windows路径处理bug (amzxyz 11:16)


### 🏡 杂项

- [[`4815f86`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/4815f86e5343b23406ebaebf8907df3e42b781e2)] **-** 变更版本 (wanxiang 10-12 13:25)


### 📚 词库更新

- [[`78b800b`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/78b800bec4364552a96c6e3d4dad59f89a2dbb1c)] **-** 词库调整 (amzxyz 16:33)
- [[`4b7bc85`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/4b7bc859637779615fcbe9ee53faf23e6a888061)] **-** 词库调整 (amzxyz 10-12 17:58)
- [[`e36f09c`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/e36f09c82fb05e36c067184c6e588df933383e2c)] **-** 辅助码3变2词组权重调整 (amzxyz 10-12 23:38)

## 🚀 下载引导

### 1. 标准版输入方案

✨**适用类型：** 支持全拼、各种双拼

✨**下载地址：** [rime-wanxiang-base.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-base.zip)

### 2. 双拼辅助码增强版输入方案

✨**适用类型：** 支持各种双拼+辅助码的自由组合
   - **自然码辅助版本：** [rime-wanxiang-zrm-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-zrm-fuzhu.zip)
   - **虎码首末辅助版本：** [rime-wanxiang-tiger-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-tiger-fuzhu.zip)
   - **墨奇辅助版本：** [rime-wanxiang-moqi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-moqi-fuzhu.zip)
   - **小鹤辅助版本：** [rime-wanxiang-flypy-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-flypy-fuzhu.zip)
   - **五笔前2辅助版本：** [rime-wanxiang-wubi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-wubi-fuzhu.zip)
   - **汉心辅助版本：** [rime-wanxiang-hanxin-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.4/rime-wanxiang-hanxin-fuzhu.zip)

### 3. 语法模型

✨**适用类型：** 所有版本皆可用

✨**下载地址：** [wanxiang-lts-zh-hans.gram](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/model/wanxiang-lts-zh-hans.gram)

## 📘 使用说明(QQ群：11033572 参与讨论)

1. **不使用辅助码的用户：**

   请直接下载标准版，按仓库中的 [README.md](https://cnb.cool/amzxyz/rime-wanxiang/-/blob/wanxiang/README.md) 配置使用。

2. **使用增强版的用户：**
   - PRO 每一个 zip 是**完整独立配置包**，其差异仅在于词库是否带有特定辅助码。
   - zrm 仅表示“词库中包含zrm辅助码”，并**不代表这是自然码双拼方案，万象支持任意双拼与任意辅助码组合使用**。
   - 想要**携带全部辅助码**？直接下载仓库版本即可。
   - 若已有目标辅助码类型，只需下载对应 zip，解压后根据 README 中提示修改表头（例如双拼方案）即可使用。

3. **语法模型需单独下载**，并放入输入法用户目录根目录（与方案文件放一起），**无需配置**。

4. 💾 飞机盘下载地址（最快更新）：[点击访问](https://share.feijipan.com/s/xiGvXdKz)

5. 🛠 推荐使用更新脚本优雅管理版本：[rime-wanxiang-weasel-update-tools](https://github.com/rimeinn/rime-wanxiang-update-tools)

6. Arch Linux 用户推荐 [启用 Arch Linux CN 仓库](https://www.archlinuxcn.org/archlinux-cn-repo-and-mirror/) 或通过 [AUR](https://aur.archlinux.org/pkgbase/rime-wanxiang)，按需安装。
   - 基础版包名：`rime-wanxiang-[拼写方案名]`，如：自然码方案：`rime-wanxiang-zrm`
   - 双拼辅助码增强版包名：`rime-wanxiang-pro-[拼写方案名]`，如：自然码方案：`rime-wanxiang-pro-zrm`
7. Deepin Linux v25 用户亦可以通过仓库进行安装。例如：'sudo apt install rime-wanxiang-zrm'
