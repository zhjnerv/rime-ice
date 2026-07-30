# The Matrix / 数字雨 —— Weasel 主题设计文档

> 版本：v3 重设计（2026-07-30）
> 上游设计令牌：[MATRIX-DESIGN.md](D:/谷歌硬盘/PC同步/GitHub/主题设计/MATRIX-DESIGN.md) §2 深色模式
> 实现参数参考：[weasel-style-reference.md](weasel-style-reference.md)

---

## 0. 设计目标与约束

**目标**：在 Weasel 候选窗上还原「数字雨（Digital Rain）」的视觉气质 —— 纯黑深渊中，绿色字符流自上而下坠落，头部最亮、尾部渐隐，选中态如「雨点被光标捕获」般爆发出高亮。

**硬约束（来自 Weasel 引擎）**：

| 能力 | 状态 | 说明 |
|------|------|------|
| CSS 动画 / keyframes | ❌ 不支持 | 无定时器、无逐帧重绘 |
| 鼠标悬停改变颜色 | ✅ 支持 | `hover_type: hilite` / `semi_hilite` |
| 选中态突变 | ✅ 支持 | `hilited_*` 系列颜色瞬时切换 |
| Win11 风格选中标记 | ✅ 支持 | `mark_text: ""` + `hilited_mark_color` |
| 半透明 / 模糊 | ✅ 支持 | `translucency` / `blur` |
| 圆角、阴影 | ✅ 支持 | `corner_radius` / `shadow_*` |

**结论**：不做"假动画"（如静态渐变图贴背景，Weasel 不支持背景图），而是用**色彩层级 + 交互态切换 + 阴影辉光**构建"雨落感"。动画体现在：
1. **雨点头部高亮**：选中候选 = 最亮字符 + 绿底反白，模拟雨点头部被照亮
2. **雨尾渐隐**：普通候选用中亮度绿，注释/标签用暗绿，形成纵向亮度梯度
3. **悬停捕获**：鼠标划过候选项时触发 `hilite`，如同雨滴被探照灯捕获
4. **边缘辉光**：窗口阴影用绿色发光而非黑色投影，模拟 CRT 荧光溢出

---

## 1. 色彩系统（严格引用 MATRIX-DESIGN 令牌）

### 1.1 背景层级

| Weasel 参数 | 令牌 | 色值 | 理由 |
|-------------|------|------|------|
| `back_color` | `--mx-bg-base` | `#000000` | 电影正统纯黑，OLED 友好，让绿色字符自己发光 |
| `border_color` | `--mx-accent` | `#00FF41` | 文化绿边框，1px 细线，像终端窗口的边框 |
| `shadow_color` | `--mx-accent` 35% | `#5900FF41` | 绿色发光阴影，偏移 0/0 + 大半径 = 四周辉光 |

> 废弃 v2 的 `#020B02` 底色 —— 那是 CRT 变体专用（MATRIX-DESIGN §5），不符合"正统数字雨"定位。

### 1.2 字符亮度梯度（雨落层次）

数字雨的核心是"同一绿色，不同亮度"。按 MATRIX-DESIGN §2.2 的 HSL 亮度档分配：

| 角色 | Weasel 参数 | 令牌 | 色值 | 视觉角色 |
|------|-------------|------|------|----------|
| 雨点尾部 | `comment_text_color` | `--mx-rain-dim` | `#0F610A` | 最暗，几乎隐入黑背景 |
| 次级雨滴 | `label_color` | `--mx-rain-mid` | `#2E9E1F` | 序号标签，可辨识但不抢戏 |
| 雨体主色 | `candidate_text_color` | `--mx-rain-body` | `#6FF769` | 普通候选文字，柔和可读 |
| 雨体主色 | `text_color` | `--mx-rain-body` | `#6FF769` | 编码区文字 |
| 接近头部 | `hilited_text_color` | `--mx-rain-bright` | `#94F98F` | 已输入编码的高亮部分 |
| 头部高亮 | `hilited_candidate_text_color` | `--mx-accent-text` | `#E0FFE0` | 选中候选文字（压绿底上） |
| 反光点 | `hilited_label_color` | `--mx-glint` | `#FFFFFF` | 选中候选的序号，最亮 |

### 1.3 高亮捕获态（"雨点被光标捕获"）

| Weasel 参数 | 色值 | 设计意图 |
|-------------|------|----------|
| `hilited_candidate_back_color` | `#00FF41` | 文化绿实底，像探照灯打在雨点上 |
| `hilited_candidate_text_color` | `#000000` | 黑字压绿底，最高对比度，"反白"效果 |
| `hilited_label_color` | `#000000` | 序号同步反白 |
| `hilited_comment_text_color` | `#003300` | 注释在绿底上用深绿，保持可读 |
| `hilited_back_color` | `#0A1F0A` | 编码区已输入部分的背景，微弱浮起 |
| `hilited_mark_color` | `#00FF41` | Win11 风格选中标记（竖线），同边框色 |

### 1.4 翻页箭头（保留雨滴意象）

| Weasel 参数 | 色值 | 说明 |
|-------------|------|------|
| `prevpage_color` | `#2E9E1F` | 中绿，可点击但不刺眼 |
| `nextpage_color` | `#2E9E1F` | 同上 |

---

## 2. 布局与动效参数

### 2.1 窗口形态

```yaml
corner_radius: 0          # 直角窗口 —— 终端的硬朗感，Matrix 拒绝圆角
hilited_corner_radius: 0  # 高亮块也直角，保持网格感
border_width: 1           # 1px 细边框，终端窗口线
```

**理由**：Matrix 的虚拟世界是代码构成的网格，直角呼应"矩阵/终端"的冷硬几何。

### 2.2 辉光阴影（唯一合法的"光效"）

```yaml
shadow_offset_x: 0
shadow_offset_y: 0
shadow_radius: 12
shadow_color: 0x5900FF41   # #00FF41 @ 35% alpha
```

**理由**：黑色阴影在纯黑背景上不可见。改用**零偏移 + 大半径 + 绿色半透明** = 候选窗四周泛起荧光，像 CRT 显示器的电子束溢出。这是静态参数能模拟的"辉光呼吸"基底。

### 2.3 悬停交互动效（真正的"动画"）

```yaml
hover_type: hilite
```

**效果**：鼠标划过候选项 → 瞬时切换为 `hilited_candidate_*` 配色（绿底黑字）。
**设计意图**：如同雨滴下落过程中被一道光束捕获，"高亮"即"被系统注意到"。这是 Weasel 唯一能驱动的"逐帧感"——用户的鼠标移动本身就是动画的时钟源。

### 2.4 选中标记

```yaml
mark_text: ""               # 空字符串
hilited_mark_color: 0x00FF41
```

**效果**：选中候选左侧显示 Win11 风格竖线标记，颜色同边框，像光标锁定雨点。

### 2.5 间距节奏

```yaml
spacing: 10              # 编码区与候选区间距，呼吸感
candidate_spacing: 2     # 候选项紧凑排列，模拟雨流连续性
hilite_padding: 4        # 高亮块内边距
margin_x: 10
margin_y: 8
```

**理由**：候选项紧凑排列，让高亮块在移动时呈现"跳格"的干脆感，而非松散漂浮。

### 2.6 字体策略

```yaml
font_face: "Roboto Condensed, Sarasa Gothic SC, Microsoft YaHei UI"
```

- **西文/数字**：Roboto Condensed（MATRIX-DESIGN §4 正统）
- **中文**：Sarasa Gothic SC（更黑/更窄，符合终端气质）
- **回退**：Microsoft YaHei UI

**回退说明**：Weasel 的 `font_face` fallback 链用逗号分隔，系统若无 Roboto Condensed 则自动落到中文窄体。不强制安装字体，保证可用性。

---

## 3. 完整配置（可直接替换）

```yaml
the_matrix:
  name: "The Matrix / 数字雨 v3"
  author: "zhjwork"

  # --- 背景层级 ---
  back_color: 0x000000                    # 纯黑深渊
  border_color: 0x00FF41                  # 文化绿边框
  shadow_color: 0x5900FF41                # 绿光辉辉

  # --- 编码区 ---
  text_color: 0x6FF769                    # 雨体主色
  hilited_text_color: 0x94F98F            # 已输入部分更亮
  hilited_back_color: 0x0A1F0A            # 已输入背景微浮

  # --- 普通候选（雨尾渐隐）---
  candidate_text_color: 0x6FF769          # 雨体
  comment_text_color: 0x0F610A            # 最暗尾部
  label_color: 0x2E9E1F                   # 序号中绿

  # --- 高亮候选（雨点头部被捕获）---
  hilited_candidate_back_color: 0x00FF41  # 探照灯绿底
  hilited_candidate_text_color: 0x000000  # 反白黑字
  hilited_label_color: 0x000000           # 序号反白
  hilited_comment_text_color: 0x003300    # 注释深绿
  hilited_mark_color: 0x00FF41            # Win11 选中标记

  # --- 翻页箭头 ---
  prevpage_color: 0x2E9E1F
  nextpage_color: 0x2E9E1F

  # --- 布局动效 ---
  corner_radius: 0                        # 直角终端
  hilited_corner_radius: 0
  border_width: 1
  hover_type: hilite                      # 悬停捕获
  mark_text: ""                           # Win11 竖线标记

  # --- 字体 ---
  font_face: "Roboto Condensed, Sarasa Gothic SC, Microsoft YaHei UI"
  font_point: 15
  label_font_point: 14
  comment_font_point: 13
```

### 配套 `style` 全局调整（建议）

```yaml
style:
  horizontal: false           # 竖排候选 —— 数字雨自上而下，竖排才是雨的方向
  inline_preedit: false       # 编码区独立显示，形成"命令行 + 雨流"两层结构
  translucency: false         # 关闭半透明，保持纯黑的电影感
  blur: false                 # 关闭模糊，让字符锐利如代码
  layout:
    shadow_offset_x: 0
    shadow_offset_y: 0
    shadow_radius: 12         # 辉光半径
    spacing: 10
    candidate_spacing: 2
    hilite_padding: 4
    margin_x: 10
    margin_y: 8
```

---

## 4. 视觉示意（ASCII）

```
┌─────────────────────────────────────┐  ← 1px #00FF41 边框
│  ni hao ▌                           │  ← 编码区 #6FF769，光标
│  ─────────                          │     已输入部分 #94F98F on #0A1F0A
│  1. 你好  (ni hao)                  │  ← 普通候选 #6FF769，注释 #0F610A
│ ▌2. 拟好  (ni hao)                  │  ← 选中：左侧 #00FF41 竖线标记
│     ████████████████████████        │     高亮块 #00FF41 底 + #000000 字
│  3. 泥沼  (ni zhao)                 │
│  4. 逆行  (ni xing)                 │
└─────────────────────────────────────┘
  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ← #00FF41 35% 绿色辉光阴影
```

---

## 5. 与 MATRIX-DESIGN 的合规性自查

| 规范条款 | 本设计 | 状态 |
|----------|--------|------|
| §2.1 底色纯黑 `#000000` | `back_color: 0x000000` | ✅ |
| §2.1 禁止 `#020B02` 作默认底色 | 已从 v2 移除 | ✅ |
| §2.2 正文用 `#6FF769` 而非 `#00FF41` | `candidate_text_color: 0x6FF769` | ✅ |
| §2.3 `#00FF41` 只作 accent/边框/高亮底 | 边框、高亮底、标记 | ✅ |
| §2.4 辉光用绿色阴影 | `shadow_color: 0x5900FF41` | ✅ |
| §4 字体 Roboto Condensed → 中文窄体 | 已配置 fallback 链 | ✅ |
| §7 反模式：浅色模式禁扫描线 | 本主题为深色专属 | N/A |

---

## 6. 已知限制与后续迭代

1. **无真动画**：Weasel 引擎不支持逐帧动效，雨落感依赖色彩梯度与交互态切换。若需真动画，需迁移到 [RimeSeeMe](https://fxliang.github.io/RimeSeeMe/) 生成静态预览，或使用支持 Lua 脚本化 UI 的第三方前端（如 fcitx5-rime + 自定义 skin）。
2. **字体依赖**：Roboto Condensed / Sarasa Gothic SC 非 Windows 自带，未安装时回退到 Microsoft YaHei UI，风格损失但可用。
3. **阴影性能**：`shadow_radius: 12` 在高分屏（>200% DPI）上可能略耗 GPU，若卡顿可降至 8。

---

*设计依据：MATRIX-DESIGN.md §2 深色模式 + Weasel 0.17.4 参数参考*
