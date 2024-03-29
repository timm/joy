---
title: lib.lua
---



# lib.lua
##  Standard library functions
```lua
local joy=require "joy"
local lib={}

function all(klass,t,f,   n)
  f = f or function(x) return x end
  n = klass()
  for _,x in pairs(t) do n:add( f(x) ) end
  return n
end

f
```
## inc 

Add one to counter `i` in `a`. If counter missing, initialize it with `a[i]=1`

```lua
function lib.inc(a,i,    new) 
  new  = (a[i] or 0) + 1 
  a[i] = new
  return new
end

function lib.ordered(t)
  local i,tmp = 0,{}
  for key,_ in pairs(t) do tmp[#tmp+1] = key end
  table.sort(tmp)
  return function () 
    if i < #tmp then 
      i = i+1
      return tmp[i], t[tmp[i]] end end 
end

function lib.rogues(    ignore,match)
  ignore = {
    jit=true, utf8=true,math=true, package=true, table=true, 
    coroutine=true, bit=true, os=true, io=true, 
    bit32=true, string=true, arg=true, debug=true, 
    _VERSION=true, _G=true }
  for k,v in pairs( _G ) do
    if type(v) ~= "function" and not ignore[k] then
       if k:match("^[^A-Z]") then
         print("-- warning, rogue local ["..k.."]") 
  end end end 
end 

lib.floor=math.floor
function lib.ok(t,     n,score,s,my)
  my=joy.sys.ok
  local function s(t1)
     return lib.floor(0.5 + 100*(1-(
             (my.tries - my.fails) / my.tries))) end
  for x,f in pairs(t) do
    my.tries = my.tries + 1
    print("-- Test #" .. my.tries .. 
          " (oops=".. s() .."%). Checking ".. x .." ... ")
    local passed,err = pcall(f)
    if not passed then
      my.fails = my.fails + 1
      print("-- E> Failure " .. my.fails .. " of " 
            .. my.tries ..": ".. err) end end
  rogues()
end

do
  local ids=0
  local function identity(o)
    ids = ids + 1
    o._id = ids
    return o
  end
  function lib.isa(o,c)
    return identity( setmetatable(o ,{__index=c}))
  end
end

function lib.copy(t,f, out)
  out={}
  f =  f and f or function(z) return z end
  if t then for i,v in pairs(t) do out[i] = f(v) end  end
  return out
end

function lib.deepCopy(t)  
  return type(t) == 'table' and copy(t,lib.deepCopy) or t
end

function lib.cols(t,     numfmt, sfmt,noline,w,txt,sep)
  w={}
  for i,_ in pairs(t[1]) do w[i] = 0 end
  for i,line in pairs(t) do
    for j,cell in pairs(line) do
      if type(cell)=="number" and numfmt then
        cell    = string.format(numfmt,cell)
        t[i][j] = cell end
      w[j] = max( w[j], #tostring(cell) ) end end
  for n,line in pairs(t) do
    txt,sep="",""
    for j,cell in pairs(line) do
      sfmt = "%" .. (w[j]+1) .. "s"
      txt = txt .. sep .. string.format(sfmt,cell)
      sep = ","
    end
    print(txt)
    if (n==1 and not noline) then
      sep="#"
      for _,w1 in pairs(w) do
        io.write(sep .. string.rep("-",w1)  )
        sep=", " end
      print("") end end
end


```

## System stuff

Refine `tostring`
(so it can print tables).

```lua

_tostring=tostring
function tostring(a,   prefix,t) 
  local function go(x,str,sep,seen)  
    if type(x) ~= "table" then return _tostring(x) end
    if seen[x] then return "..." end
    seen[x] = true
    for k,v in lib.ordered(x) do
      if not (type(k) == "string" and 
             string.sub(k, 1, 1) == "_") then
        str = str .. sep .. k .. ": " .. go(v,"{","",seen)
        sep = ", " end end
    return str .. '}'
  end 
  prefix="{"
  if type(a)=="table" then
    t = getmetatable(a) 
    if t and t.__index and t.__index.ako then
      prefix = t.__index.ako .. "{" end  end
  return go(a,prefix,"",{}) 
end  

return lib
```
