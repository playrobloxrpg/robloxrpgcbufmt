
-- ===================== CONTORNO DOS MORADORES =====================
local contorno = Instance.new("Highlight")
contorno.Name = "ContornoPixel"
contorno.FillTransparency = 1
contorno.OutlineColor = Color3.fromRGB(10, 8, 14)
contorno.OutlineTransparency = 0
contorno.DepthMode = Enum.HighlightDepthMode.Occluded
contorno.Adornee = moradores
contorno.Parent = moradores

-- ===================== LIGACAO COM A TOCA =====================
local toca = workspace:FindFirstChild("TocaDaTecelaFaminta")
local inicioToca = toca and toca:FindFirstChild("1_EscadasIngremes") and toca["1_EscadasIngremes"]:FindFirstChild("InicioDaAventura")
if inicioToca then
	-- quem entra no jogo nasce na vila, nao na masmorra
	inicioToca.Enabled = false
	local velho = toca:FindFirstChild("PortalDeVolta")
	if velho then velho:Destroy() end
	local m = Instance.new("Model")
	m.Name = "PortalDeVolta"
	local base = inicioToca.CFrame * CFrame.new(-8, -0.5, 7) * CFrame.Angles(0, math.rad(90), 0)
	blocoL(m, "Base", base, 8, 0.6, 3, 0, 0.3, 0, "pedra2")
	for _, x in ipairs({ -3.2, 3.2 }) do blocoL(m, "Pilar", base, 1.2, 8, 1.2, x, 4.6, 0, "pedraEsc") end
	blocoL(m, "Topo", base, 8, 1, 1.4, 0, 9.1, 0, "pedraEsc")
	local sup = blocoL(m, "Superficie", base, 5.2, 7.4, 0.3, 0, 4.4, 0, "violeta", "neon", nil, 0.35)
	sup.CanCollide = false
	sup:SetAttribute("Portal", "VoltarParaVila")
	luz(sup, "violeta", 18, 1.5)
	local t = blocoL(m, "Tabuleta", base, 4, 1.2, 0.3, 0, 10.3, 0, "madeira2")
	placa(t, Enum.NormalId.Front, "VOLTAR PARA A VILA")
	placa(t, Enum.NormalId.Back, "VOLTAR PARA A VILA")
	m.Parent = toca
end

-- ===================== REMOTOS E MODELOS =====================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local velhosRemotos = ReplicatedStorage:FindFirstChild("LobbyRemotos")
if velhosRemotos then velhosRemotos:Destroy() end
local remotos = Instance.new("Folder")
remotos.Name = "LobbyRemotos"
for _, n in ipairs({ "AbrirLoja", "ComprarItem", "Aviso" }) do
	local r = Instance.new("RemoteEvent")
	r.Name = n
	r.Parent = remotos
end
remotos.Parent = ReplicatedStorage

local velhosModelos = ServerStorage:FindFirstChild("LobbyModelos")
if velhosModelos then velhosModelos:Destroy() end
local modelos = Instance.new("Folder")
modelos.Name = "LobbyModelos"
local uso = Instance.new("Script")
uso.Name = "UsoDoItem"
uso.Enabled = false
uso.Source = [==[
__USO__]==]
uso.Parent = modelos
modelos.Parent = ServerStorage

local sistema = Instance.new("Script")
sistema.Name = "SistemaDoLobby"
sistema.Source = [==[
__SISTEMA__]==]
sistema.Parent = raiz

local scriptsJogador = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
if scriptsJogador then
	local velha = scriptsJogador:FindFirstChild("InterfaceDoLobby")
	if velha then velha:Destroy() end
	local interface = Instance.new("LocalScript")
	interface.Name = "InterfaceDoLobby"
	interface.Source = [==[
__INTERFACE__]==]
	interface.Parent = scriptsJogador
end

-- ===================== ILUMINACAO =====================
if AJUSTAR_ILUMINACAO then
	local Lighting = game:GetService("Lighting")
	Lighting.ClockTime = 19.6
	Lighting.Brightness = 1.4
	Lighting.OutdoorAmbient = Color3.fromRGB(86, 82, 110)
	Lighting.Ambient = Color3.fromRGB(34, 32, 42)
	local atm = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atm.Density = 0.32
	atm.Color = Color3.fromRGB(120, 112, 150)
	atm.Decay = Color3.fromRGB(56, 50, 76)
	atm.Glare = 0
	atm.Haze = 1.2
	atm.Parent = Lighting
end

-- ===================== FINALIZAR =====================
raiz.Parent = workspace
game:GetService("Selection"):Set({ raiz })
workspace.CurrentCamera.CFrame = CFrame.lookAt(W(150, 70, 190), W(110, 0, 100))
local total = 0
for _, d in ipairs(raiz:GetDescendants()) do
	if d:IsA("BasePart") then total = total + 1 end
end
print(("Vila Pedra-Musgo criada! %d pecas, %d arvores. Estatuas das classes no salao: %s. Toca ligada: %s. Design: Yuri Ramos Hernandez")
	:format(total, arvores, (classesMovidas > 0) and "sim" or "nao (rode o script das classes)", inicioToca and "sim" or "nao (rode o script da masmorra)"))
