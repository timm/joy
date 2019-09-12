---
title: coro.lua
---



# coro.lua
r=math.random
seed=math.randomseed

yield = coroutine.yield
function iter(f,t) 
  return coroutine.wrap(function() return f(t) end)
end

function tree(t,pre)
  if t then
    pre=pre or 0
    yield(t.value,pre)
    tree(t.left,pre+1) 
    tree(t.right,pre) 
  end
end

function tree0(lo,hi, x)
  lo=lo or 0
  hi=hi or 1
  if (hi-lo)> 0.0001 then
    x=lo+(hi-lo)*r()
    return  {value= x,
             left= tree0(lo,lo+(x-lo)*0.99),
             right=tree0(hi-(hi-x)*0.99,hi)} 
             end 
             end

t=tree0()
print(1)
for v,pre in iter(tree,t) do
  print(string.rep("| ",pre) .. tostring(v))
end
