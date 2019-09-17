#!/usr/bin/env lua
-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro 


local joy      = require("joy")
local lib      = require("lib")
local isa      = lib.isa
local Num      = require("num")
local Sym      = require("sym")

local Rows={ako="Rows"}

function Rows.new(self)
   self.cols={all={},syms={}, xnums={}, xsyms={},nums={},class=nil}
   self.rows{}
   self.name={}
   self.eman={}
   self._use={}
  return isa(self,Rows)
end

function Rows:header(cells,       c,w,what,tmp,indep)
  local function at(a,x) 
    self.cols[a][#self.cols[a] + 1] = x end
  self = self or Rows.new()
  for c0,x in pairs(cells) do
    if not x:match("%?")  then
      c = #t._use+1
      if x:match("!") then self.cols.class = c end
      t._use[c] = c0
      t.name[c] = x
      t.eman[x] = c
      w    = x:match("<") and -1 or 1
      what = x:match("[<>%$]") and Num or Sym
      tmp  = what.new{w=w, txt=x, pos=c}
      indep= not x:match("[<>!]]") 
      at("all", tmp)
      if what==Num then
        at("nums", tmp)
        if indep then at("xnums", tmp) end
      else
        at("syms", tmp)
        if indep then at("xsyms", tmp)  end 
  end end end
end

return Rows
