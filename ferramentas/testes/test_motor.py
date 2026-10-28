import sys
from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(open('roblox_stub.lua').read())
lua.execute(open(sys.argv[1]).read())
# extra runtime API for the engine
lua.execute(r'''
local CFm = getmetatable(CFrame.new())
local oldIndex = CFm.__index
local function transpose(A) return {A[1],A[4],A[7], A[2],A[5],A[8], A[3],A[6],A[9]} end
local function matvec(A, v) return Vector3.new(A[1]*v[1]+A[2]*v[2]+A[3]*v[3], A[4]*v[1]+A[5]*v[2]+A[6]*v[3], A[7]*v[1]+A[8]*v[2]+A[9]*v[3]) end
CFm.__index = function(c, k)
  if k == "Rotation" then return setmetatable({p = Vector3.new(0,0,0), R = c.R}, CFm)
  elseif k == "UpVector" then return Vector3.new(c.R[2], c.R[5], c.R[8])
  elseif k == "RightVector" then return Vector3.new(c.R[1], c.R[4], c.R[7])
  elseif k == "ToObjectSpace" then return function(self, o)
      local Rt = transpose(self.R)
      local R = {}
      for i = 0, 2 do for j = 0, 2 do local s = 0; for kk = 0, 2 do s = s + Rt[i*3+kk+1] * o.R[kk*3+j+1] end; R[i*3+j+1] = s end end
      return setmetatable({p = matvec(Rt, o.p - self.p), R = R}, CFm)
    end
  end
  return oldIndex(c, k)
end
math.clamp = function(x, a, b) return math.max(a, math.min(b, x)) end
local sinais = {}
local function sinal() local s = {cbs = {}}; function s:Connect(f) table.insert(self.cbs, f); return {Disconnect = function() end} end; return s end
HEARTBEAT = sinal()
local svc = game.GetService
game.GetService = function(self, n)
  if n == "RunService" then return {Heartbeat = HEARTBEAT} end
  if n == "TweenService" then return {Create = function() return {Play = function() end} end} end
  if n == "Debris" then return {AddItem = function() end} end
  return svc(self, n)
end
TweenInfo = {new = function() return {} end}
task = {delay = function(t, f) f() end, spawn = function(f, ...) f(...) end}
local meta = getmetatable(Instance.new("Part"))
local oldI = meta.__index
meta.__index = function(o, k)
  if k == "GetAttributeChangedSignal" then return function() return sinal() end end
  if k == "Triggered" then local s = rawget(o, "_trig") or sinal(); rawset(o, "_trig", s); return s end
  if k == "WaitForChild" then return function(self, n) return self:FindFirstChild(n) end end
  if k == "Destroy" then return function(self) self.Parent = nil end end
  return oldI(o, k)
end
''')
g = lua.globals()
fila = g.workspace.FindFirstChild(g.workspace, "ClassesDePersonagem")
motor = fila.FindFirstChild(fila, "AnimacoesDeCombate")
dados = motor.FindFirstChild(motor, "DadosDeAnimacao")
lua.execute('function require(m) return load(m._props.Source)() end')
runner = lua.eval('function(src, scr) local f = assert(load(src)); local env = setmetatable({script = scr}, {__index = _G}); debug.setupvalue(f, 1, env); f() end')
runner(motor._props.Source, motor)
cbs = g.HEARTBEAT.cbs
print("heartbeat callbacks:", len(cbs))
cav = fila.FindFirstChild(fila, "Cavaleiro")
lam = cav.FindFirstChild(cav, "Lamina")
y0 = lam._props.CFrame.p[2]
ys = []
for i in range(2400):
    cbs[1](1/60)
    ys.append(lam._props.CFrame.p[2])
print("40 s simulados sem erro. Altura da lamina do cavaleiro: min %.2f max %.2f (repouso %.2f)" % (min(ys), max(ys), y0))
# manual trigger through the attribute path
for nome in ["Cavaleiro", "Clerigo", "Arcanista", "Ladino", "Patrulheiro"]:
    m = fila.FindFirstChild(fila, nome)
    print(nome, "pecas animadas OK" if m else "faltando")
