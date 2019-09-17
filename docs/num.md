---
title: num.lua
---



# num.lua
local joy      = require("joy")
local lib      = require("lib")
local isa      = lib.isa
local r,seed   = math.random, math.randomseed
local pi, sqrt = math.pi, math.sqrt
local exp, log, cos = math.exp, math.log, math.cos

local Num={ako="Num"}

function Num.nums(t,f,  n)
  f = f or function(x) return x end
  n = Num.new{}
  for _,x in pairs(t) do n:add( f(x) ) end
  return n
end

function Num.new(self,pos,txt) 
  self.txt = txt or ""
  self.pos = pos or 0
  self.w   = 1
  self.n   = 0
  self.mu  = 0
  self.sd  = 0
  self.m2  = 0
  self.hi  = -math.huge
  self.lo  =  math.huge
  return isa(self,Num)
end

function Num:add(x,    d) 
  if x == joy.char.skip then return x end
  x = tonumber(x)
  self.n = self.n + 1
  if x < self.lo then self.lo = x end 
  if x > self.hi then self.hi = x end 
  d       = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x - self.mu)
  i.sd = self:sd0()
  return x
end

function Num:del(x    d)
  if x == joy.sym.skip then return x end
  x = tonumber(x)
  if self.n < 2 then self.sd=0; return x end
  self.n  = self.n - 1
  d       = x - self.mu
  self.mu = self.mu - d/self.n
  self.m2 = self.m2 - d*(x - self.mu)
  self.sd = self:sd0()
  return x
end

function Num:sd0() 
  if self.m2 < 0 then return 0 end
  if self.n  < 2 then return 0 end
  return (self.m2/(self.n - 1))^0.5
end

function Num:any() return self.mu + self.sd * Num:z() end
function Num:z()   return sqrt(-2*log(r()))*cos(2*pi*r()) end

function Num:norm(x)
  return (x - self.lo) / (self.hi - self.lo + 10^-32)
end

function Num:variety() return self.sd end

function Num:xpect(other,   n)
  n = self.n + other.n
  return self.sd*self.n/n + other.sd*other.n/n
end

function Num:pdf(x)
  return exp(-1*(x - self.mu)^2/(2*self.sd^2)) *
         1 / (self.sd * ((2*pi)^0.5))
end

return Num
