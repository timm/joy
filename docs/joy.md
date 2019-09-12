---
title: joy.lua
---



# joy.lua
## System defaults 
```lua

local function joy0() return {
  a=   {b= 0},
  sys= {ok= {tries= 0, fails= 0}}
  }
end

function joy(     dontforget)
  dontforget = _G["THE"] and JOY.sys
  JOY = joy0()
  if dontforget then JOY.sys = dontforget end
  return JOY
end

JOY = joy()
```
