#!/bin/bash
set -e
# 预处理更新日志文本（按规则替换关键词）
NEW_CHANGELOG=$(echo "${LATEST_CHANGE_LOG}" | sed \
  -e 's/Features/✨ 新特性/g' \
  -e 's/Bug Fixes/🐛 Bug修复/g' \
  -e 's/Performance Improvements/🔥 性能优化/g' \
  -e 's/Code Refactoring/🏡 杂项/g' \
  -e 's/chore/🏡 杂项/g' \
  -e 's/dict/📚 词库更新/g' \
  -e 's/docs/📖 文档变更/g' \
  -e 's/Documentation/📖 文档变更/g' \
  -e 's/ci/🤖 持续集成/g'
)

# 声明辅助码 zip 包类型显示名
declare -A display_names=(
  [zrm]="自然码"
  [moqi]="墨奇"
  [flypy]="小鹤"
  [hanxin]="汉心"
  [wubi]="五笔前2"
  [tiger]="虎码首末"
)

# 仓库和下载地址定义
DOWNLOAD_URL="https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/${CNB_BRANCH}"

{
  echo "## 📝 更新日志"
  echo ""
  echo "${NEW_CHANGELOG}"
  echo ""
  echo "## 🚀 下载引导"
  echo ""
  echo "### 1. 标准版输入方案"
  echo ""
  echo "✨**适用类型：** 支持全拼、各种双拼"
  echo ""
  echo "✨**下载地址：** [rime-wanxiang-base.zip](${DOWNLOAD_URL}/rime-wanxiang-base.zip)"
  echo ""
  echo "### 2. 双拼辅助码增强版输入方案"
  echo ""
  echo "✨**适用类型：** 支持各种双拼+辅助码的自由组合"

  for type in "${!display_names[@]}"; do
    name="${display_names[$type]}"
    echo "   - **${name}辅助版本：** [rime-wanxiang-${type}-fuzhu.zip](${DOWNLOAD_URL}/rime-wanxiang-${type}-fuzhu.zip)"
  done

  echo ""
  echo "### 3. 语法模型"
  echo ""
  echo "✨**适用类型：** 所有版本皆可用"
  echo ""
  echo "✨**下载地址：** [wanxiang-lts-zh-hans.gram](https://cnb.cool/amzxyz/rime-wanxiang/-/releases/download/model/wanxiang-lts-zh-hans.gram)"
  echo ""
  echo "## 📘 使用说明(QQ群：11033572 参与讨论)"
  echo ""
  echo "1. **不使用辅助码的用户：**"
  echo ""
  echo "   请直接下载标准版，按仓库中的 [README.md](https://cnb.cool/amzxyz/rime-wanxiang/-/blob/wanxiang/README.md) 配置使用。"
  echo ""
  echo "2. **使用增强版的用户：**"
  echo "   - PRO 每一个 zip 是**完整独立配置包**，其差异仅在于词库是否带有特定辅助码。"
  echo '   - zrm 仅表示“词库中包含zrm辅助码”，并**不代表这是自然码双拼方案，万象支持任意双拼与任意辅助码组合使用**。'
  echo "   - 想要**携带全部辅助码**？直接下载仓库版本即可。"
  echo "   - 若已有目标辅助码类型，只需下载对应 zip，解压后根据 README 中提示修改表头（例如双拼方案）即可使用。"
  echo ""
  echo "3. **语法模型需单独下载**，并放入输入法用户目录根目录（与方案文件放一起），**无需配置**。"
  echo ""
  echo "4. 💾 飞机盘下载地址（最快更新）：[点击访问](https://share.feijipan.com/s/xiGvXdKz)"
  echo ""
  echo "5. 🛠 推荐使用更新脚本优雅管理版本：[rime-wanxiang-weasel-update-tools](https://github.com/rimeinn/rime-wanxiang-update-tools)"
  echo ""
  echo "6. Arch Linux 用户推荐 [启用 Arch Linux CN 仓库](https://www.archlinuxcn.org/archlinux-cn-repo-and-mirror/) 或通过 [AUR](https://aur.archlinux.org/pkgbase/rime-wanxiang)，按需安装。"
  echo "   - 基础版包名：\`rime-wanxiang-[拼写方案名]\`，如：自然码方案：\`rime-wanxiang-zrm\`"
  echo "   - 双拼辅助码增强版包名：\`rime-wanxiang-pro-[拼写方案名]\`，如：自然码方案：\`rime-wanxiang-pro-zrm\`"
  echo "7. Deepin Linux v25 用户亦可以通过仓库进行安装。例如：'sudo apt install rime-wanxiang-zrm'"
} > release_note.md
