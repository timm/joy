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
  JOY.sys = dontforget or JOY.sys
  return JOY
end

JOY = joy()
```
