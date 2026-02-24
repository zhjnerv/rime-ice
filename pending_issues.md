# 待解决问题记录

## 问题：英文候选词上屏后自动使用半角标点

**状态**: 已解决 (2026-02-24)
**优先级**: P2

### 问题描述
在中文输入模式下，选择英文候选词上屏后，期望下一个��点符号自动变成半角英文标点，但实际上仍然是中文全角标点。

### 期望行为
1. 在中文模式下输入编码
2. 选择英文候选词（如 `hello`）上屏
3. 紧接着输入标点符号（如逗号、句号）
4. **期望**：得到半角英文标点（`,` `.`）
5. **实际**：得到全角中文标点（`，` `。`）

### 对比功能
**数字后自动半角功能是正常的**：
- 在中文模式下输入数字（如 `123`）
- 紧接着输入标点符号
- 能够自动得到半角标点
- 这个功能由 `punctuator/digit_separators: ":,."` 实现

### 已尝试的解决方案

#### 方案 1：使用 auto_en_punct.lua（失败）
**操作**：
- 在 `wanxiang_pro.custom.yaml` 中添加配置：
  ```yaml
  engine/processors/@before 9: lua_processor@auto_en_punct
  ```
- 该配置已正确添加到编译后的文件中（build/wanxiang_pro.schema.yaml 第 102 行）
- 位置正确：在 `punctuator` 之前处理

**失败原因分析**：
1. `auto_en_punct.lua` 监听 `commit_notifier` 事件
2. 检测逻辑：判断上屏文本是否为纯 ASCII（`is_ascii()` 函数）
3. 可能的问题：
   - table_translator 生成的英文候选词在上屏时可能不触发标准的 `commit_notifier`
   - 或者上屏文本格式不符合 `is_ascii()` 的判断条件
   - 与 `super_english.lua` 的监听器存在冲突

**最终操作**：
- 已从 `wanxiang_pro.custom.yaml` 中移除此配置
- 相关 Lua 脚本：`lua/auto_en_punct.lua`

### 技术分析

#### 英文候选词的处理流程
1. **Translators（翻译器）**：
   - `table_translator@wanxiang_english` - 英文词汇表翻译器
   - `table_translator@wanxiang_mixedcode` - 混合编码翻译器
   - 负责生成英文候选词

2. **Filters（过滤器）**：
   - `lua_filter@*super_english` - 英文候选词过滤器
   - 位置：`lua/super_english.lua`
   - 功能：英文自动加空格、格式化、判断英文候选词

3. **super_english.lua 的监听器**（第 264-290 行）：
   ```lua
   env.commit_notifier = env.engine.context.commit_notifier:connect(function(ctx)
       local commit_text = ctx:get_commit_text()
       local text_no_space = gsub(commit_text, "%s", "")
       local is_eng = is_ascii_phrase_fast(text_no_space)
       -- 设置 prev_commit_is_eng 标记
       env.prev_commit_is_eng = is_eng
       if is_eng then
           env.last_commit_time = get_now()
       else
           env.last_commit_time = 0
       end
   end)
   ```

#### 关键发现
- `super_english.lua` 已经监听了 `commit_notifier` 事件
- 它使用 `is_ascii_phrase_fast()` 函数判断是否为英文
- 它设置了 `prev_commit_is_eng` 标记用于英文加空格功能
- **两个监听器监听同一个事件，可能存在冲突或优先级问题**

### 可能的解决方案（待验证）

#### 方案 A：修改 super_english.lua
在 `super_english.lua` 的 `commit_notifier` 中添加标点处理逻辑：
- 检测到英文上屏后，设置一个标记（类似 `env.one_shot_ascii_punct = true`）
- 在 filter 阶段或通过其他方式处理下一个标点按键

**优点**：
- 不需要额外的 processor
- 逻辑集中在一个文件中
- 利用现有的英文检测逻辑

**缺点**：
- 需要修改原始 lua 文件
- filter 无法直接处理按键事件（需要配合 processor）

#### 方案 B：修改 auto_en_punct.lua
增强 `auto_en_punct.lua` 的检测逻辑：
- 监听 `select_notifier`（候选词选择事件）
- 使用更宽松的英文判断（如 `has_english_letters()` 函数）
- 添加日志调试以确认触发时机

**优点**：
- 逻辑独立，不影响其他功能
- 可选配置，用户可自由启用/禁用

**缺点**：
- 需要修改原始 lua 文件
- 可能与 `super_english.lua` 的监听器冲突

#### 方案 C：利用 super_english 的标记
检查 `super_english.lua` 是否已经设置了某种可复用的标记，在 `punctuator` 之前拦截按键。

#### 方案 D：使用 weasel.yaml 的 ascii_punct
在某些应用中配置 `ascii_punct: true`，但这是全局设置，不是基于上下文的智能切换。

### 相关文件
- `lua/auto_en_punct.lua` - 自动英文标点处理器（已禁用）
- `lua/super_english.lua` - 英文候选词过滤器（核心模块）
- `wanxiang_pro.schema.yaml` - 主方案配置
- `wanxiang_pro.custom.yaml` - 用户自定义配置
- `wanxiang_english.schema.yaml` - 英文独立方案
- `README.md` - 项目文档（第 611 行：数字后自动半角说明）

### 相关配置
```yaml
# 数字后自动半角（已生效）
punctuator:
  digit_separators: ":,."
```

```yaml
# 英文自动加空格（当前配置：关闭）
wanxiang_english/english_spacing: off
wanxiang_english/spacing_timeout: 0
```

### 最终解决方案（防更新覆盖）

为了彻底解决识别不准以及未来系统更新被覆盖的问题，采用了基于 Rime Context Property 和高优先级注入的方案：

1. **废弃修改原生脚本**：不再修改官方的 `super_english.lua` 和 `super_processor.lua`，而是保持其原样以应对未来的仓库更新。
2. **新增独立脚本 `lua/custom_en_punct.lua`**：
   - 将 `super_english.lua` 里的纯英文快速判断逻辑（`is_ascii_phrase_fast`）提取到该独立脚本中。
   - 监听 `commit_notifier` 实时判断刚刚上屏的词汇是否为纯英文。
   - 在其 `func` 处理函数中优先拦截随后的键盘敲击：如果是标点则强制半角上屏并重置状态；如果敲击字母/数字则视为新输入，重置状态。
3. **注入最高优先级补丁 `wanxiang_pro.custom.yaml`**：
   ```yaml
   patch:
     "engine/processors/@before 0": lua_processor@*custom_en_punct
   ```
   - 利用 `@before 0` 语法，将该自定义处理器强行置于整个 `engine/processors` 列表的最顶端（第 0 顺位）。
   - 这不仅确保了拦截逻辑在 `punctuator` 和 `speller` 之前生效，更保证了我们的补丁**独立存续，不会被官方更新文件覆盖**。

### 参考资料
- 万象方案 README.md
- Rime 官方文档
- Rime Lua 扩展用法及 `@before` 插入语法
- table_translator 的工作机制
- commit_notifier 的触发时机

---

## 其他待解决问题

（此处可记录其他问题）
