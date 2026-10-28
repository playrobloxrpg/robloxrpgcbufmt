import sys
from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(open('roblox_stub.lua').read())
for f in sys.argv[1:]:
    lua.execute(open(f).read())
lua.execute(open('runtime_extras.lua').read())
lua.execute(r'''
table.find = function(t, v) for i, x in ipairs(t) do if x == v then return i end end end
task.wait = function(t) end
string.upper = string.upper
local sig = function()
  local s = {cbs = {}}
  function s:Connect(f) table.insert(self.cbs, f); return {Disconnect = function() end} end
  function s:Fire(...) for _, f in ipairs(self.cbs) do f(...) end end
  return s
end
-- jogadores
PLAYERS = {}
local PlayerAdded = sig()
CLIENTE = {}  -- mensagens enviadas ao cliente
local svc2 = game.GetService
game.GetService = function(self, n)
  if n == "Players" then
    return {
      PlayerAdded = PlayerAdded,
      GetPlayers = function() return PLAYERS end,
      GetPlayerFromCharacter = function(_, ch) for _, p in ipairs(PLAYERS) do if p.Character == ch then return p end end end,
      GetPlayerByUserId = function(_, id) for _, p in ipairs(PLAYERS) do if p.UserId == id then return p end end end,
    }
  end
  return svc2(self, n)
end
local meta = getmetatable(Instance.new("Part"))
local idx = meta.__index
meta.__index = function(o, k)
  if k == "Triggered" or k == "Touched" or k == "Activated" or k == "OnServerEvent" or k == "CharacterAdded" or k == "OnClientEvent" then
    local s = rawget(o, "_s_" .. k) or sig(); rawset(o, "_s_" .. k, s); return s
  end
  if k == "FireClient" then return function(self, jogador, ...) table.insert(CLIENTE, {self._props.Name, ...}) end end
  if k == "FindFirstAncestorWhichIsA" then return function() return nil end end
  if k == "Clone" then return function(self)
      local c = Instance.new(self.ClassName)
      for a, b in pairs(self._props) do c._props[a] = b end
      for a, b in pairs(self._attrs) do c._attrs[a] = b end
      return c
    end end
  if k == "GetBoundingBox" then return function(self)
      local mn, mx = {1e9, 1e9, 1e9}, {-1e9, -1e9, -1e9}
      for _, p in ipairs(self:GetDescendants()) do
        if p._props.CFrame and p._props.Size then
          local c = p._props.CFrame.p
          for i = 1, 3 do mn[i] = math.min(mn[i], c[i]); mx[i] = math.max(mx[i], c[i]) end
        end
      end
      return CFrame.new((mn[1]+mx[1])/2, (mn[2]+mx[2])/2, (mn[3]+mx[3])/2), Vector3.new(mx[1]-mn[1], mx[2]-mn[2], mx[3]-mn[3])
    end end
  return idx(o, k)
end
function NOVO_JOGADOR()
  local j = Instance.new("Player"); j.Name = "Heroi"; j.UserId = 777
  local bp = Instance.new("Backpack"); bp.Parent = j
  local sg = Instance.new("StarterGear"); sg.Name = "StarterGear"; sg.Parent = j
  local ch = Instance.new("Model"); ch.Name = "Heroi"
  local hrp = Instance.new("Part"); hrp.Name = "HumanoidRootPart"; hrp.CFrame = CFrame.new(110, 3, 662); hrp.Parent = ch
  local head = Instance.new("Part"); head.Name = "Head"; head.CFrame = CFrame.new(110, 5, 662); head.Parent = ch
  local hum = Instance.new("Humanoid"); hum.Health = 100; hum.MaxHealth = 100; hum.Parent = ch
  rawset(j, "Character", ch); j._props.Character = ch
  table.insert(PLAYERS, j)
  PlayerAdded:Fire(j)
  j.CharacterAdded:Fire(ch)
  return j, hrp, hum
end
''')
g = lua.globals()
vila = g.workspace.FindFirstChild(g.workspace, "VilaPedraMusgo")
g.RODAR_SCRIPT(vila.FindFirstChild(vila, "SistemaDoLobby"))
j, hrp, hum = g.NOVO_JOGADOR()
moedas = j.FindFirstChild(j, "leaderstats").FindFirstChild(j.FindFirstChild(j, "leaderstats"), "Moedas")
print("1) jogador entrou com", moedas._props.Value, "moedas")

# escolher classe Cavaleiro pelo pedestal
fila = g.workspace.FindFirstChild(g.workspace, "ClassesDePersonagem")
alvo = None
for d in fila.GetDescendants(fila).values():
    if d.ClassName == "ProximityPrompt" and d._attrs["EscolherClasse"] == "Cavaleiro": alvo = d
alvo.Triggered.Fire(alvo.Triggered, j)
bp = j.FindFirstChildOfClass(j, "Backpack")
itens = [t._props.Name for t in bp.GetChildren(bp).values()]
print("2) classe:", j._attrs["Classe"], "| vida maxima:", hum._props.MaxHealth, "| mochila:", itens)

# loja da ferraria: comprar espada longa (60) com 50 moedas -> falta; depois com 100
rem = g.game.GetService(g.game, "ReplicatedStorage").FindFirstChild(g.game.GetService(g.game, "ReplicatedStorage"), "LobbyRemotos")
comprar = rem.FindFirstChild(rem, "ComprarItem")
comprar.OnServerEvent.Fire(comprar.OnServerEvent, j, "ferraria", "espadaLonga")
print("3) tentou comprar Espada Longa:", g.CLIENTE[len(g.CLIENTE)][2] if g.CLIENTE else None)
comprar.OnServerEvent.Fire(comprar.OnServerEvent, j, "taverna", "tocha")
comprar.OnServerEvent.Fire(comprar.OnServerEvent, j, "taverna", "pocao")
print("4) comprou tocha e pocao | moedas:", moedas._props.Value, "| mochila:", [t._props.Name for t in bp.GetChildren(bp).values()])
comprar.OnServerEvent.Fire(comprar.OnServerEvent, j, "taverna", "espadaLonga")
print("5) item que nao e da loja ignorado | moedas:", moedas._props.Value)

# abrir loja pelo NPC
mor = vila.FindFirstChild(vila, "Moradores")
ilda = mor.FindFirstChild(mor, "Ilda"); cab = ilda.FindFirstChild(ilda, "Cabeca")
pr = cab.FindFirstChildOfClass(cab, "ProximityPrompt"); n0 = len(g.CLIENTE)
pr.Triggered.Fire(pr.Triggered, j)
abriu = [m for m in list(g.CLIENTE.values())[n0:] if m[1] == "AbrirLoja"]
print("6) falar com a Ilda abriu a loja:", bool(abriu), "| itens:", len(abriu[0][2]["itens"]) if abriu else 0)

# portal: tocar na superficie
portal = vila.FindFirstChild(vila, "Praca").FindFirstChild(vila.FindFirstChild(vila, "Praca"), "PortalDaToca")
sup = portal.FindFirstChild(portal, "Superficie")
sup.Touched.Fire(sup.Touched, hrp)
p = hrp._props.CFrame.p
print("7) atravessou o portal -> posicao %.1f, %.1f, %.1f (inicio da Toca fica perto de -14, 0, 0)" % (p[1], p[2], p[3]))

# usar a espada numa cria
toca = g.workspace.FindFirstChild(g.workspace, "TocaDaTecelaFaminta")
pers = toca.FindFirstChild(toca, "Personagens"); cria = pers.FindFirstChild(pers, "CriaDeAranha1")
cf, tam = cria.GetBoundingBox(cria)
hrp._props.CFrame = g.CFrame.lookAt(g.Vector3.new(cf.p[1] + 3, 42.5, cf.p[3]), g.Vector3.new(cf.p[1], 42.5, cf.p[3]))
espada = [t for t in bp.GetChildren(bp).values() if t._props.Name == "Espada Curta"][0]
espada.Parent = j._props.Character
uso = espada.FindFirstChild(espada, "UsoDoItem")
g.RODAR_SCRIPT(uso)
m0 = moedas._props.Value
for i in range(4):
    lua.execute("AGORA = AGORA + 1")
    lua.execute("os.clock = function() return AGORA end")
    espada.Activated.Fire(espada.Activated)
print("8) 4 golpes de espada | vida da cria: %s | moedas: %d -> %d" % (cria._attrs["Vida"], m0, moedas._props.Value))
EOF_MARK = None
