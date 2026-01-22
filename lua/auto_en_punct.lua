-- auto_en_punct.lua
-- 当输入英文单词后，使后续的标点符号保持英文格式。

local processor = {}

-- 检测字符串是否全为 ASCII（英文/数字/符号）
local function is_ascii(text)
   for i = 1, #text do
      if string.byte(text, i) > 127 then
         return false
      end
   end
   return true
end

function processor.init(env)
   local context = env.engine.context
   env.one_shot_ascii = false
   
   -- 监听提交事件
   env.commit_notifier = context.commit_notifier:connect(function(ctx)
      local text = ctx:get_commit_text()
      -- 如果提交的是纯英文（不含中文），则标记下一次标点为英文
      if text and text ~= "" and is_ascii(text) then
         env.one_shot_ascii = true
      else
         env.one_shot_ascii = false
      end
   end)
end

function processor.fini(env)
   if env.commit_notifier then
      env.commit_notifier:disconnect()
   end
end

function processor.func(key, env)
   -- 如果不需要处理，或者 Key 已经被释放（release），直接忽略
   if not env.one_shot_ascii or key:release() then
      return 2 -- kNoop
   end

   local k = key.keycode
   
   -- 处理标点符号
   -- ASCII 标点范围判断
   if (k >= 33 and k <= 47) or  -- ! " # $ % & ' ( ) * + , - . /
      (k >= 58 and k <= 64) or  -- : ; < = > ? @
      (k >= 91 and k <= 96) or  -- [ \ ] ^ _ `
      (k >= 123 and k <= 126) then -- { | } ~
      
      -- 如果是标点，强制直接上屏该 ASCII 字符
      env.engine:commit_text(string.char(k))
      
      -- 仅生效一次，处理完重置
      env.one_shot_ascii = false
      
      -- 返回 1 (kAccepted) 拦截该按键，防止后续 Punctuator 再次处理
      return 1
   end

   -- 如果输入的是字母、数字、空格或常见功能键，视为用户开始新的输入或操作，重置状态
   -- 字母 a-z, A-Z, 0-9 (48-57, 65-90, 97-122), Space(32), Enter(0xff0d/13)
   if (k >= 48 and k <= 57) or (k >= 65 and k <= 90) or (k >= 97 and k <= 122) or k == 32 or k == 0xff0d or k == 13 or k == 0xff08 then
      env.one_shot_ascii = false
   end
   
   return 2 -- kNoop
end

return processor
