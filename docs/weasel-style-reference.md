# Rime Weasel (小狼毫) 皮肤参数完整参考

> 基于 Weasel 0.17.4，来源：`weasel.yaml` 内置默认、`weasel_style.yaml` 注释参考、源码 `RimeWithWeasel/RimeWithWeasel.cpp`。
> 在线配色设计工具：[RimeSeeMe](https://fxliang.github.io/RimeSeeMe/)

---

## 一、`style` 全局样式

### 1.1 字体

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `font_face` | string | `Microsoft YaHei` | 全局字体，支持 fallback 链：`"字体1:起始码位:结束码位:字重:字形,字体2..."`。emoji 字体可通过指定码位范围避免影响其他字符 |
| `label_font_face` | string | 同 font_face | 候选标签（序号）字体 |
| `comment_font_face` | string | 同 font_face | 候选注释（编码提示/词频等）字体 |
| `font_point` | int | 14 | 全局字号 |
| `label_font_point` | int | 同 font_point | 标签字号，不设定则不 fallback 到 font_point |
| `comment_font_point` | int | 同 font_point | 注释字号，不设定则不 fallback 到 font_point |

### 1.2 预编辑区

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `inline_preedit` | bool | `true` | true=行内显示预编辑区，false=候选窗内显示 |
| `preedit_type` | enum | `composition` | 预编辑区内容：`composition`（编码）、`preview`（高亮候选）、`preview_all`（全部候选） |

### 1.3 候选框布局方向

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `horizontal` | bool | `false` | 候选项横排（true）或竖排（false） |
| `vertical_text` | bool | `false` | 竖排文本模式 |
| `text_orientation` | enum | `horizontal` | 文本排列方向：`horizontal` / `vertical` |
| `vertical_text_left_to_right` | bool | `false` | 竖排模式下文字从左到右排列 |
| `vertical_text_with_wrap` | bool | `false` | 竖排模式下自动换行 |
| `vertical_auto_reverse` | bool | `false` | 竖排模式下候选窗口在光标上方时倒序排列 |
| `fullscreen` | bool | `false` | 候选窗口全屏显示 |

### 1.4 标签与标记

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `label_format` | string | `"%s."` | 标签格式。`%s` 替换为序号。如 `"%s."`→`1.`，`"%s、"`→`1、` |
| `mark_text` | string | `""` | 选中候选项的标记字符。空字符串且 `hilited_mark_color` 非透明时显示 Win11 风格标记 |

### 1.5 行为控制

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `color_scheme` | string | `aqua` | 当前配色方案名，对应 `preset_color_schemes` 下的键名 |
| `color_scheme_dark` | string | — | 暗色主题配色（Windows 暗色模式时自动切换） |
| `ascii_tip_follow_cursor` | bool | `false` | ASCII 模式切换提示跟随鼠标而非输入光标 |
| `enhanced_position` | bool | `false` | 定位失败时在窗口左上角显示候选框 |
| `display_tray_icon` | bool | `false` | 系统托盘显示独立于语言栏的额外图标 |
| `antialias_mode` | enum | `default` | 次像素反锯齿：`default` / `force_dword` / `cleartype` / `grayscale` / `aliased` |
| `candidate_abbreviate_length` | int | `30` | 候选项略写长度，超过用省略号；`0` 禁用 |
| `hover_type` | enum | `semi_hilite` | 鼠标悬停行为：`none`（无动作）、`hilite`（选中候选项）、`semi_hilite`（高亮候选项） |
| `paging_on_scroll` | bool | `false` | 滚轮操作：`true`=翻页，`false`=切换候选项 |
| `click_to_capture` | bool | `false` | 点击候选项创建截图 |

### 1.6 视觉效果（0.15+）

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `blur` | bool | `false` | 候选窗口背景模糊效果 |
| `translucency` | bool | `false` | 候选窗口半透明效果 |
| `color_space` | enum | `srgb` | 颜色空间：`srgb`（标准 sRGB）、`linear`（线性空间，颜色更准确） |

---

## 二、`style/layout` 布局细节

### 2.1 布局类型

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `type` | enum | `horizontal` | 布局类型完整指定：`horizontal` / `vertical` / `vertical_text` / `vertical+fullscreen` / `horizontal+fullscreen` |

### 2.2 窗口尺寸

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `max_height` | int | `0` | 候选框最大高度（px），`0` 不限制，超过时自动折叠 |
| `max_width` | int | `0` | 候选框最大宽度（px），`0` 不限制 |
| `min_height` | int | `0` | 候选框最小高度 |
| `min_width` | int | `160` | 候选框最小宽度 |

### 2.3 边框与边距

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `border_width` / `border` | int | `3` | 窗口边框宽度，两者等价 |
| `margin_x` | int | `12` | 主体与候选窗左右边距。**负值时不显示候选框** |
| `margin_y` | int | `12` | 主体与候选窗上下边距 |
| `corner_radius` | int | `4` | **候选窗口**圆角半径 |
| `round_corner` / `hilited_corner_radius` | int | `4` | **高亮背景色块**圆角半径，两者等价 |

### 2.4 间距

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `spacing` | int | `10` | `inline_preedit: false` 时编码区与候选区间距 |
| `candidate_spacing` | int | `5` | 候选项间距 |
| `hilite_spacing` | int | `4` | 候选项与标签、注释的间距 |
| `hilite_padding` | int | `2` | 高亮区域与内部文字间距。**值 >= margin 时高亮色覆盖整个候选区域** |
| `hilite_padding_x` | int | 同 hilite_padding | 高亮区域内左右间距 |
| `hilite_padding_y` | int | 同 hilite_padding | 高亮区域内上下间距 |

### 2.5 对齐

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `align_type` | enum | `center` | 标签、候选文字、注释文字之间的垂直对齐：`top` / `center` / `bottom` |

### 2.6 阴影

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `shadow_offset_x` | int | `4` | 阴影 X 轴偏移，可为负数 |
| `shadow_offset_y` | int | `4` | 阴影 Y 轴偏移 |
| `shadow_radius` | int | `0` | 阴影模糊半径。**`0`=不显示阴影**，同时需要配色中 `shadow_color` 非透明 |

---

## 三、`preset_color_schemes` 配色参数

每个配色方案的键名用于 `style/color_scheme` 引用。

### 3.1 基本信息

| 参数 | 类型 | 说明 |
|------|------|------|
| `name` | string | 在「输入法设定」中显示的配色名称 |
| `author` | string | 作者信息 |

### 3.2 颜色格式

```yaml
color_format: argb   # 可选：argb / rgba / abgr。默认视为 0xAARRGGBB
```

所有颜色值为 `0xAARRGGBB`（AA=Alpha 透明度，RR=红，GG=绿，BB=蓝）。

### 3.3 窗口背景与边框

| 参数 | 说明 |
|------|------|
| `back_color` | 候选窗口背景色 |
| `border_color` | 候选窗口边框颜色 |
| `shadow_color` | 阴影颜色。全透明（`0x00000000`）=无阴影 |

### 3.4 编码区（`inline_preedit: false` 时可见）

| 参数 | 说明 |
|------|------|
| `text_color` | 编码区文字颜色（含预编辑区文字） |
| `hilited_text_color` | 编码区高亮文字颜色（候选序号、已输入部分） |
| `hilited_back_color` | 编码区高亮背景颜色 |
| `hilited_shadow_color` | 编码区高亮背景块阴影颜色 |

### 3.5 翻页箭头（`inline_preedit: false` 时可见）

| 参数 | 说明 |
|------|------|
| `nextpage_color` | 下一页箭头颜色。不设置则不显示箭头 |
| `prevpage_color` | 上一页箭头颜色。不设置则不显示箭头 |

### 3.6 普通候选项

| 参数 | 说明 |
|------|------|
| `candidate_text_color` | 非高亮候选文字颜色 |
| `candidate_back_color` | 非高亮候选背景颜色 |
| `candidate_border_color` | 非高亮候选边框颜色 |
| `candidate_shadow_color` | 非高亮候选背景块阴影颜色 |
| `comment_text_color` | 非高亮候选项注释文字颜色 |
| `label_color` | 非高亮候选项标签（序号）颜色 |

### 3.7 高亮候选项（当前选中）

| 参数 | 说明 |
|------|------|
| `hilited_candidate_text_color` | 高亮候选文字颜色 |
| `hilited_candidate_back_color` | 高亮候选背景颜色 |
| `hilited_candidate_border_color` | 高亮候选边框颜色 |
| `hilited_candidate_shadow_color` | 高亮候选背景块阴影颜色 |
| `hilited_comment_text_color` | 高亮候选注释文字颜色 |
| `hilited_label_color` | 高亮候选标签（序号）颜色 |
| `hilited_candidate_label_color` | 独立的高亮候选标签颜色（与 `hilited_label_color` 区分） |

### 3.8 标记

| 参数 | 说明 |
|------|------|
| `hilited_mark_color` | 高亮标记颜色。搭配 `style/mark_text` 使用；`mark_text: ""` 且此值非透明时显示 Win11 风格标记 |

---

## 四、配色内可覆盖的布局/样式参数（0.15+）

以下参数可在每个配色方案内部独立设置，覆盖全局 `style` 中的值：

| 参数 | 类型 | 说明 |
|------|------|------|
| `font_face` | string | 字体 |
| `font_point` | int | 字号 |
| `label_font_face` | string | 标签字体 |
| `label_font_point` | int | 标签字号 |
| `comment_font_face` | string | 注释字体 |
| `comment_font_point` | int | 注释字号 |
| `corner_radius` | int | 窗口圆角 |
| `hilited_corner_radius` | int | 高亮色块圆角 |
| `inline_preedit` | bool | 预编辑模式 |
| `translucency` | bool | 半透明 |
| `blur` | bool | 背景模糊 |
| `color_space` | enum | 颜色空间 |
| `alpha` | int(0-1) | 窗口透明度 |
| `candidate_list_layout` | enum | `linear`（线性排列） |
| `candidate_format` | string | 候选格式模板，如 `"%c %_@ "` |
| `line_spacing` | int | 行间距 |
| `spacing` | int | 覆盖全局 spacing |
| `text_orientation` | enum | `horizontal` / `vertical` |
| `mutual_exclusive` | bool | 互斥模式 |
| `base_offset` | int | 基础偏移量 |
| `border_height` / `border_width` | int | 配色内独立边框 |
| `surrounding_extra_expansion` | int | 周围额外扩展 |
| `shadow_size` | int | 阴影尺寸 |

---

## 五、`app_options` 应用级覆盖

```yaml
"app_options/appname.exe":
  ascii_mode: true       # 该应用强制英文模式
  inline_preedit: true   # Firefox 等必须设为 true，否则会预插入空格
  vim_mode: true         # Esc / Ctrl+C / Ctrl+[ 切换到 ASCII
```

---

## 六、已弃用参数

| 旧参数 | 替代 |
|--------|------|
| `mouse_hover_ms` | `hover_type` |

---

## 七、实操备忘

- 修改配置后需在托盘右键菜单选择「重新部署」（或 `Ctrl+Shift+```）才能生效
- 预览配色：在用户目录创建 `preview` 文件夹，放入 `color_scheme_<name>.png` 截图
- 排查：先查 `weasel_style.yaml` 完整参数，再通过 `weasel.custom.yaml` 的 `__include` 引入
