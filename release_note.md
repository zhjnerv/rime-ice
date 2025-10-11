## 📝 更新日志

### 🐛 Bug修复

- [[`dacb88a`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/dacb88a9e371a093794fa2317f9ae2a3af529444)] **-** 通过双击分词符号触发重新分词，并在持续输入分词符号时，能在预设方式之间循环，用于应对类似自然码：必输 必须是 为相同编码导致的必输前置的问题 (wanxiang 15:14)


### 🏡 杂项

- [[`ad5e3de`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/ad5e3def66e9b747c3c801b1cd978e743a400b11)] **-** 变更版本 (wanxiang 10-08 17:24)
- [[`095dcc1`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/095dcc127bdc8c27d670b7d31b701af3766450ad)] **-** 变更版本 (wanxiang 10-08 10:23)
- [[`7d5783d`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/7d5783d6ff03a5dd5e4f8949974715522d24c6a5)] **-** 调整说明 (wanxiang 06:59)


### 📚 词库更新

- [[`89c398f`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/89c398fc46ddf2bb95dc0229e8ed6517cd8851df)] **-** 词库调整 (wanxiang 10-08 23:37)
- [[`99d7113`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/99d7113c9f953c3de14402c82887377125b67212)] **-** 词库调整 (wanxiang 10-08 18:09)
- [[`f0a5b8c`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/f0a5b8cdcb204d8d3fafd11e2588b2b1f77e2034)] **-** 词库调整 (wanxiang 10-08 17:00)


### ✨ 新特性

- [[`6bc2a41`](https://cnb.cool/amzxyz/rime-wanxiang/-/commit/6bc2a41ded7723d7e30506c32581356dc35f6001)] **-** 新增通过双击分词符号触发重新分词，并在持续输入分词符号时，能在预设方式之间循环，用于应对类似自然码：必输 必须是 为相同编码导致的必输前置的问题 (wanxiang 15:13)

## 🚀 下载引导

### 1. 标准版输入方案

✨**适用类型：** 支持全拼、各种双拼

✨**下载地址：** [rime-wanxiang-base.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-base.zip)

### 2. 双拼辅助码增强版输入方案

✨**适用类型：** 支持各种双拼+辅助码的自由组合
   - **自然码辅助版本：** [rime-wanxiang-zrm-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-zrm-fuzhu.zip)
   - **虎码首末辅助版本：** [rime-wanxiang-tiger-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-tiger-fuzhu.zip)
   - **墨奇辅助版本：** [rime-wanxiang-moqi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-moqi-fuzhu.zip)
   - **小鹤辅助版本：** [rime-wanxiang-flypy-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-flypy-fuzhu.zip)
   - **五笔前2辅助版本：** [rime-wanxiang-wubi-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-wubi-fuzhu.zip)
   - **汉心辅助版本：** [rime-wanxiang-hanxin-fuzhu.zip](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/v13.1.0/rime-wanxiang-hanxin-fuzhu.zip)

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
