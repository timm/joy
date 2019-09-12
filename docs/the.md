---
title: the.lua
---



# the.lua
local function the0() return {
  a=   {b= 0},
  sys= {ok= {tries= 0, fails= 0}}
  }
end

function the(  y,n)
  if   _G["THE"] 
  then y,n = THE.sys.ok.tries, THE.sys.ok.fails 
  else y,n = 0,0 
  end
  THE = the0()
  THE.sys.ok.tries, THE.sys.ok.fails = y,n
  return THE
end

THE = the()
