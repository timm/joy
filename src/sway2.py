import random
r=random.random
shuffle=random.shuffle
log=lambda z: math.log(z,2)
sqrt=math.sqrt

def nil()     : return Sym(lambda: None)
def sym(*lst) : return Sym(lambda: any(lst))
def num(lo,mode,hi) : 
  c = (mode - lo) / (hi - lo)
  def f():
    u,v=r(),r()
    x= (1-c)*min(u,v) + c*max(u,v)
    return lo + x*(hi - lo) 
  return Num(f)

class Thing: 
  def __call__(i):
    return i.seen( i.generator() )
class Sym(Thing): 
  def __init__(i,fun): i.generator = fun
  def seen(i,x):       return x
  def dist(i,x,y):     return 0 if x==y then 1
class Num(Thing):
  def __init__(i,fun):
     i.generator = fun
     i.lo, i.hi = 10**32, -10**32
  def seen(i,x): 
    if x < i.lo: i.lo =x
    if x > i.hi: i.hi =x
    return x
  def norm(i,x):   return (x - i.lo) / (i.hi - i.lo)
  def dist(i,x,y): return i.norm(x) - i.norm(y)

class Model():
  def init(i):
    i.xs,i.ys= i.about()
  def __call__(i): 
    i.x = [f() for f in i.xs]
    i.y = [f() for f in i.ys]
  def distance(i,j):
    return sum( [ f.dist(a,b)**2 for a,b,f  in
                  zip(i.x, j.x, i.xs) ] 
              ) / length(i.x)

class Model1(Model):
  def about(i):
    return [num(2,8,10), num(3,4,8), sym(True, False)],[nil(), nil()]

def pole(model,some,peeks):
  hi,east,west = 0,None,None
  for _ in peeks:
    east0, west0 = any(some), any(some)
    d= model.distance(east, west)
    if d > hi:
      hi = d
      east,west = east0,west0
  return east,west

def sway2(model=Model1(),np=10000,m=256, peeks=30):
  poles = int(log(sqrt(np)) + 1)
  pop   = shuffle([model() for _ in range(np)])
  some  = pop[:m]
  dims  = [pole(model,some,peeks) for _ in range(poles)]
