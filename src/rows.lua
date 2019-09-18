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
  for c0,x in pairs(cells) do
    if not x:match("%?")  then
      c = #t._use+1
      t._use[c] = c0
      t.name[c] = x
      t.eman[x] = c
      self:header1(x,c, 
                  {w      = x:match("<") and -1 or 1,
                   nump   = x:match("[<>%$]"),
                   indep  = not x:match("[<>!]]"),
                   klassp = x:match("!")}) end end 
end

function Rows:header1(x,c,is,      klass,tmp,at)
  klass = is.nump and Num or Sym
  tmp   = what.new{w= is.w, txt=x, pos=c}
  at    = function(a) self.cols[a][#self.cols[a] + 1] = tmp end
  at("all")
  at(is.nump and "nums" or "syms")
  if is.indep then
    at(is.nump and "xnums" or "xsyms") end
  if is.klassp then at("klass") end
end


i ../etc/.vimrc
