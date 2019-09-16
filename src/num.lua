#!/usr/bin/env lua
-- vim: ts=2 sw=2 sts=2  et :

local joy      = require("joy")
local lib      = require("lib")
local isa      = lib.isa
local r,seed   = math.random, math.randomseed
local pi, sqrt = math.pi, math.sqrt
local log, cos = math.log, math.cos

local Num={ako="Num"}

function Num.new(o,pos,txt) 
  o.txt = txt or ""
  o.pos = pos or 0
  o.n  = 0
  o.mu = 0
  o.sd = 0
  o.m2 = 0
  o.hi = -math.huge
  o.lo =  math.huge
  return isa(o,Num)
end

function Num:add(x,    d) 
  if x == joy.sym.skip then return x end
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

return Num
