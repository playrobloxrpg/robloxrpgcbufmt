import sys
from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(open('roblox_stub.lua').read())
lua.execute(open(sys.argv[1]).read())
lua.execute(r'''
-- ===== runtime extras =====
local CFm = getmetatable(CFrame.new())
local oldIndex = CFm.__index
local function transpose(A) return {A[1],A[4],A[7], A[2],A[5],A[8], A[3],A[6],A[9]} end
local function matvec(A, v) return Vector3.new(A[1]*v[1]+A[2]*v[2]+A[3]*v[3], A[4]*v[1]+A[5]*v[2]+A[6]*v[3], A[7]*v[1]+A[8]*v[2]+A[9]*v[3]) end
local function mk(p, R) return setmetatable({p = p, R = R}, CFm) end
local function ortho(R)
  local x = Vector3.new(R[1], R[4], R[7]).Unit
  local y = Vector3.new(R[2], R[5], R[8])
  y = (y - x * (x[1]*y[1] + x[2]*y[2] + x[3]*y[3])).Unit
  local z = Vector3.new(x[2]*y[3]-x[3]*y[2], x[3]*y[1]-x[1]*y[3], x[1]*y[2]-x[2]*y[1])
  return {x[1], y[1], z[1], x[2], y[2], z[2], x[3], y[3], z[3]}
end
CFm.__index = function(c, k)
  if k == "Rotation" then return mk(Vector3.new(0,0,0), c.R)
  elseif k == "UpVector" then return Vector3.new(c.R[2], c.R[5], c.R[8])
  elseif k == "RightVector" then return Vector3.new(c.R[1], c.R[4], c.R[7])
  elseif k == "Lerp" then return function(a, b, t)
      local R = {}
      for i = 1, 9 do R[i] = a.R[i] + (b.R[i] - a.R[i]) * t end
      return mk(a.p + (b.p - a.p) * t, ortho(R))
    end
  elseif k == "ToObjectSpace" then return function(self, o)
      local Rt = transpose(self.R)
      local R = {}
      for i = 0, 2 do for j = 0, 2 do local s = 0; for kk = 0, 2 do s = s + Rt[i*3+kk+1] * o.R[kk*3+j+1] end; R[i*3+j+1] = s end end
      return mk(matvec(Rt, o.p - self.p), R)
    end
  end
  return oldIndex(c, k)
end
CFm.__add = function(c, v) return mk(c.p + v, c.R) end
math.clamp = function(x, a, b) return math.max(a, math.min(b, x)) end
RaycastParams = { new = function() return {} end }

-- scheduler with simulated time
AGORA = 0
local fila = {}
local esperando = {}
local function sinal()
  local s = {cbs = {}}
  function s:Connect(f) table.insert(self.cbs, f); return {Disconnect = function() end} end
  function s:Fire(...) for _, f in ipairs(self.cbs) do f(...) end end
  function s:Wait() local co = coroutine.running(); table.insert(esperando, co); return coroutine.yield() end
  return s
end
HEARTBEAT = sinal()
local function rodar(f, ...)
  local co = coroutine.create(f)
  local ok, err = coroutine.resume(co, ...)
  if not ok then error(err) end
end
task = {
  delay = function(t, f) table.insert(fila, {quando = AGORA + t, f = f}) end,
  spawn = function(f, ...) rodar(f, ...) end,
}
function PASSO(dt)
  AGORA = AGORA + dt
  local w = esperando; esperando = {}
  for _, co in ipairs(w) do local ok, err = coroutine.resume(co, dt); if not ok then error(err) end end
  local pend = fila; fila = {}
  for _, it in ipairs(pend) do
    if it.quando <= AGORA then rodar(it.f) else table.insert(fila, it) end
  end
  for _, f in ipairs(HEARTBEAT.cbs) do f(dt) end
end
PLAYERS = {}
local svc = game.GetService
game.GetService = function(self, n)
  if n == "RunService" then return {Heartbeat = HEARTBEAT} end
  if n == "TweenService" then return {Create = function() return {Play = function() end} end} end
  if n == "Debris" then return {AddItem = function() end} end
  if n == "Players" then return {GetPlayers = function() return PLAYERS end} end
  return svc(self, n)
end
TweenInfo = {new = function() return {} end}
workspace._props.Raycast = function() return nil end

local meta = getmetatable(Instance.new("Part"))
local oldI = meta.__index
meta.__index = function(o, k)
  if k == "GetAttributeChangedSignal" then return function(self, nome)
      rawset(self, "_sinais", rawget(self, "_sinais") or {})
      local ss = rawget(self, "_sinais")
      ss[nome] = ss[nome] or sinal()
      return ss[nome]
    end end
  if k == "SetAttribute" then return function(self, nome, v)
      self._attrs[nome] = v
      local ss = rawget(self, "_sinais")
      if ss and ss[nome] then ss[nome]:Fire() end
    end end
  if k == "MouseClick" or k == "Triggered" then local s = rawget(o, "_s_" .. k) or sinal(); rawset(o, "_s_" .. k, s); return s end
  if k == "WaitForChild" then return function(self, n) return self:FindFirstChild(n) end end
  if k == "Destroy" then return function(self) self.Parent = nil end end
  if k == "Position" and rawget(o, "_props").CFrame then return rawget(o, "_props").CFrame.p end
  if k == "TakeDamage" then return function(self, d) self._props.Health = self._props.Health - d end end
  return oldI(o, k)
end

function NOVO_JOGADOR(pos)
  local ch = Instance.new("Model"); ch.Name = "Heroi"
  local hrp = Instance.new("Part"); hrp.Name = "HumanoidRootPart"; hrp.CFrame = CFrame.new(pos); hrp.Parent = ch
  local hum = Instance.new("Humanoid"); hum.Health = 100; hum.WalkSpeed = 16; hum.Parent = ch
  local j = {Name = "Heroi", Character = ch}
  table.insert(PLAYERS, j)
  return hrp, hum
end
function require(m) return load(m._props.Source)() end
function RODAR_SCRIPT(scr)
  local f = assert(load(scr._props.Source))
  local env = setmetatable({script = scr}, {__index = _G})
  debug.setupvalue(f, 1, env)
  f()
end
''')
g = lua.globals()
raiz = g.workspace.FindFirstChild(g.workspace, "TocaDaTecelaFaminta")
sc = raiz.FindFirstChild(raiz, "AranhasVivas")
g.RODAR_SCRIPT(sc)
pers = raiz.FindFirstChild(raiz, "Personagens")
cria = pers.FindFirstChild(pers, "CriaDeAranha1")
boss = pers.FindFirstChild(pers, "ATecelaFaminta")
def passos(seg):
    for _ in range(int(seg * 60)): g.PASSO(1/60)
def pos(m, nome):
    p = m.FindFirstChild(m, nome); return tuple(round(x, 2) for x in (p._props.CFrame.p[1], p._props.CFrame.p[2], p._props.CFrame.p[3]))
import math
def ok_num(m):
    for _, p in m._children.items():
        if p.ClassName == "Part":
            for x in (p._props.CFrame.p[1], p._props.CFrame.p[2], p._props.CFrame.p[3]):
                if x != x or abs(x) > 1e5: return False
    return True

a0 = pos(cria, "Abdomen")
passos(4)
print("1) 4 s sem jogador | cria passeou: %s -> %s | numeros validos: %s" % (a0, pos(cria, "Abdomen"), ok_num(cria)))

casa = cria._props.WorldPivot.p
hrp, hum = g.NOVO_JOGADOR(g.Vector3.new(casa[1] + 6, casa[2] + 2.5, casa[3]))
passos(6)
print("2) jogador a 6 studs da cria por 6 s | vida do jogador: %d (comecou 100)" % hum._props.Health)

cria.SetAttribute(cria, "Vida", 0)
passos(2)
pe = cria.FindFirstChild(cria, "Torax")._props.CFrame.p[2]
print("3) cria morta | altura do torax caido: %.2f (base %.2f) | numeros validos: %s" % (pe, casa[2], ok_num(cria)))
passos(31)
print("4) 31 s depois | vida da cria renascida: %s" % cria._attrs["Vida"])

# chefe
g.PLAYERS[1].Character.Parent = None
lua.execute('PLAYERS = {}')
cab0 = pos(boss, "Cabeca")
boss.SetAttribute(boss, "Desperta", True)
passos(3)
print("5) Tecela desperta e desce: cabeca %s -> %s" % (cab0, pos(boss, "Cabeca")))
hrp2, hum2 = g.NOVO_JOGADOR(g.Vector3.new(294, 43, 10))
passos(12)
print("6) jogador no meio do Covil por 12 s | vida: %d | preso na teia agora: %s" % (hum2._props.Health, hum2._attrs["PresoNaTeia"]))
hum2._props.Health = 100
hrp2._props.CFrame = g.CFrame.new(294, 43, 25)
passos(6)
print("7) jogador embaixo dela por 6 s | vida: %d" % hum2._props.Health)
boss.SetAttribute(boss, "Vida", 140)
passos(0.5)
lua.execute('function ANIM_DE() end')
print("8) vida 140/300 -> furia disparada")
boss.SetAttribute(boss, "Vida", 0)
passos(4)
print("9) Tecela derrotada: %s | cabeca caiu para %s | numeros validos: %s" % (raiz._attrs["TecelaDerrotada"], pos(boss, "Cabeca"), ok_num(boss)))
