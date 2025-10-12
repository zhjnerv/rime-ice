## 📝 更新日志

### 🐛 Bug修复

- [[`4f24b95`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/4f24b9509da19e55ad72af159819175c4c2bd2c4)] **-** 调整转写 (amzxyz 10-11 22:56)


### 🏡 杂项

- [[`6d40bcb`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/6d40bcbe31c1f9c36d8d439e65c9748dc06c870f)] **-** 变更版本 (wanxiang 10-09 16:20)


### 📚 词库更新

- [[`02bf2e8`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/02bf2e81d24d6d4e3fd46defa6e4443a08559412)] **-** 词库调整 (amzxyz 01:16)
- [[`cb54b19`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/cb54b192990e7333916c0bbccdab3fe18debbc19)] **-** 词库调整 (amzxyz 00:54)
- [[`32c3741`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/32c374172ee00fc4ddc237bd98eff6d006d53808)] **-** 词库调整 (amzxyz 10-10 23:37)
- [[`9353968`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/935396810e278164f32821338f189d8f40d1d860)] **-** 词库调整 (amzxyz 10-10 22:57)
- [[`25d8660`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/25d8660a5d4e290bc811e9dc84626f2e7e2cd4fb)] **-** 词库调整 (wanxiang 10-09 22:17)

## 🚀 下载引导

### 1. 标准版输入方案

✨**适用类型：** 支持全拼、各种双拼

✨**下载地址：** [rime-wanxiang-base.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-base.zip)

### 2. 双拼辅助码增强版输入方案

✨**适用类型：** 支持各种双拼+辅助码的自由组合
   - **自然码辅助版本：** [rime-wanxiang-zrm-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-zrm-fuzhu.zip)
   - **虎码首末辅助版本：** [rime-wanxiang-tiger-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-tiger-fuzhu.zip)
   - **墨奇辅助版本：** [rime-wanxiang-moqi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-moqi-fuzhu.zip)
   - **小鹤辅助版本：** [rime-wanxiang-flypy-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-flypy-fuzhu.zip)
   - **五笔前2辅助版本：** [rime-wanxiang-wubi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-wubi-fuzhu.zip)
   - **汉心辅助版本：** [rime-wanxiang-hanxin-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.1/rime-wanxiang-hanxin-fuzhu.zip)

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
