#!/usr/bin/env lua
-- vim: ts=2 sw=2 sts=2  et :

-- ## System defaults 
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
