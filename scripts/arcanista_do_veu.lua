--[[
	Arcanista do Véu
	Design: Yuri Ramos Hernandez

	Mago original em estilo pixel/voxel, ~7.5 studs de altura.
	Referências visuais (repositório izzyfrm/roblox-ai):
	  - style-refs/fantasy (Tiny Dungeon, Kenney, CC0): contorno escuro e paleta curta
	  - vfx/09-magic-circle-cast: círculo mágico roxo com faíscas em "+"

	Como usar: Roblox Studio > aba View > Command Bar > cole tudo > Enter
	O boneco aparece na frente da câmera, de frente para você.
	Aperte Play para ver o círculo girando, o cristal flutuando e as faíscas.
]]

local model = Instance.new("Model")
model.Name = "ArcanistaDoVeu"
model:SetAttribute("Designer", "Yuri Ramos Hernandez")

-- O corpo fica num modelo separado para receber o contorno pixel art
local corpo = Instance.new("Model")
corpo.Name = "Corpo"
corpo.Parent = model

local C = {
	ferro     = Color3.fromRGB(48, 44, 52),
	calca     = Color3.fromRGB(58, 54, 64),
	manto     = Color3.fromRGB(40, 38, 50),
	manto2    = Color3.fromRGB(52, 49, 64),
	carmim    = Color3.fromRGB(128, 28, 40),
	carmimEsc = Color3.fromRGB(90, 20, 30),
	prata     = Color3.fromRGB(170, 170, 180),
	ouro      = Color3.fromRGB(200, 160, 70),
	sombra    = Color3.fromRGB(14, 12, 20),
	olho      = Color3.fromRGB(180, 120, 255),
	luva      = Color3.fromRGB(62, 42, 36),
	haste     = Color3.fromRGB(64, 64, 74),
	cristal   = Color3.fromRGB(160, 90, 255),
	brilho    = Color3.fromRGB(225, 200, 255),
	contorno  = Color3.fromRGB(10, 8, 14),
}

local M = {
	plastico = Enum.Material.SmoothPlastic,
	metal    = Enum.Material.Metal,
	neon     = Enum.Material.Neon,
}

local function bloco(nome, tamanho, cf, cor, material, pai)
	local p = Instance.new("Part")
	p.Name = nome
	p.Size = tamanho
	p.CFrame = cf
	p.Color = C[cor]
	p.Material = M[material or "plastico"]
	p.Anchored = true
	p.CanCollide = false
	p.CastShadow = material ~= "neon"
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = pai
	return p
end

-- { nome, {tamanho X,Y,Z}, {posição X,Y,Z}, cor, material, giroY(graus) }
local pecas = {
	-- pernas e botas
	{"BotaE", {0.8,0.6,1.2}, {-0.5,0.3,-0.1}, "ferro"},
	{"BotaD", {0.8,0.6,1.2}, {0.5,0.3,-0.1}, "ferro"},
	{"PernaE", {0.7,0.9,0.7}, {-0.5,1.05,0}, "calca"},
	{"PernaD", {0.7,0.9,0.7}, {0.5,1.05,0}, "calca"},
	-- manto
	{"BarraManto", {2.65,0.2,2.25}, {0,1.4,0}, "carmim"},
	{"SaiaBaixo", {2.6,0.5,2.2}, {0,1.65,0}, "manto"},
	{"SaiaMeio", {2.4,1.0,2.0}, {0,2.4,0}, "manto2"},
	{"Tronco", {2.2,1.4,1.8}, {0,3.5,0}, "manto"},
	{"Faixa", {2.3,0.3,1.9}, {0,2.95,0}, "carmim"},
	{"Fivela", {0.4,0.4,0.1}, {0,2.95,-0.97}, "prata", "metal"},
	{"PontaFaixa", {0.4,0.9,0.1}, {0.5,2.4,-1.01}, "carmimEsc"},
	{"Grimorio", {0.6,0.75,0.25}, {-0.75,2.35,-1.1}, "carmimEsc"},
	{"FechoGrimorio", {0.1,0.25,0.1}, {-0.47,2.35,-1.2}, "ouro", "metal"},
	{"Ombros", {2.8,0.5,2.1}, {0,4.15,0}, "carmimEsc"},
	{"Gola", {2.0,0.5,1.6}, {0,4.6,0}, "carmim"},
	-- cabeça na sombra
	{"Cabeca", {1.4,1.4,1.5}, {0,5.35,0.05}, "sombra"},
	{"Rosto", {1.3,1.1,0.1}, {0,5.3,-0.75}, "sombra"},
	{"OlhoE", {0.3,0.2,0.1}, {-0.32,5.4,-0.82}, "olho", "neon"},
	{"OlhoD", {0.3,0.2,0.1}, {0.32,5.4,-0.82}, "olho", "neon"},
	-- capuz
	{"CapuzE", {0.3,1.6,2.0}, {-0.85,5.4,0}, "manto2"},
	{"CapuzD", {0.3,1.6,2.0}, {0.85,5.4,0}, "manto2"},
	{"CapuzTras", {2.0,1.6,0.3}, {0,5.4,0.85}, "manto2"},
	{"CapuzTopo", {2.0,0.4,2.0}, {0,6.25,0}, "manto2"},
	{"CapuzAba", {2.0,0.35,0.3}, {0,6.0,-0.85}, "manto2"},
	{"Pico1", {1.2,0.4,1.2}, {0,6.6,0.2}, "manto2"},
	{"Pico2", {0.6,0.4,0.6}, {0,6.95,0.5}, "manto2"},
	{"Pico3", {0.3,0.4,0.3}, {0,7.3,0.75}, "manto2"},
	{"DebrumTopo", {1.4,0.12,0.08}, {0,5.78,-1.02}, "carmim"},
	{"DebrumE", {0.12,1.2,0.08}, {-0.7,5.2,-1.02}, "carmim"},
	{"DebrumD", {0.12,1.2,0.08}, {0.7,5.2,-1.02}, "carmim"},
	-- braço esquerdo (caído)
	{"MangaE", {0.8,1.6,0.8}, {-1.5,3.3,0}, "manto2"},
	{"PunhoE", {0.9,0.3,0.9}, {-1.5,2.45,0}, "carmim"},
	{"MaoE", {0.6,0.5,0.6}, {-1.5,2.1,0}, "luva"},
	-- braço direito (segurando o cajado)
	{"OmbroD", {0.8,1.0,0.8}, {1.5,3.6,0}, "manto2"},
	{"AntebracoD", {0.8,0.8,1.3}, {1.5,3.0,-0.55}, "manto2"},
	{"PunhoD", {0.9,0.9,0.3}, {1.5,3.0,-1.3}, "carmim"},
	{"MaoD", {0.6,0.6,0.6}, {1.5,3.0,-1.7}, "luva"},
	-- cajado de ferro
	{"Haste", {0.3,6.0,0.3}, {1.5,3.0,-1.7}, "haste", "metal"},
	{"Amarra1", {0.4,0.3,0.4}, {1.5,3.6,-1.7}, "carmim"},
	{"Amarra2", {0.4,0.3,0.4}, {1.5,2.4,-1.7}, "carmim"},
	{"Ponteira", {0.4,0.3,0.4}, {1.5,0.15,-1.7}, "haste", "metal"},
	{"Anel", {0.8,0.2,0.8}, {1.5,6.0,-1.7}, "prata", "metal"},
	{"Garra1", {0.2,0.7,0.2}, {1.8,6.35,-1.7}, "prata", "metal"},
	{"Garra2", {0.2,0.7,0.2}, {1.2,6.35,-1.7}, "prata", "metal"},
	{"Garra3", {0.2,0.7,0.2}, {1.5,6.35,-1.4}, "prata", "metal"},
	{"Garra4", {0.2,0.7,0.2}, {1.5,6.35,-2.0}, "prata", "metal"},
	{"Cristal", {0.45,0.7,0.45}, {1.5,6.6,-1.7}, "cristal", "neon", 45},
}

local criadas = {}
for _, d in ipairs(pecas) do
	local cf = CFrame.new(d[3][1], d[3][2], d[3][3]) * CFrame.Angles(0, math.rad(d[6] or 0), 0)
	criadas[d[1]] = bloco(d[1], Vector3.new(d[2][1], d[2][2], d[2][3]), cf, d[4], d[5], corpo)
end

-- ===== CONTORNO PIXEL ART =====
-- Um Highlight sem preenchimento desenha só a borda escura em volta do corpo,
-- como o contorno dos sprites pixel art.
local contorno = Instance.new("Highlight")
contorno.Name = "ContornoPixel"
contorno.FillTransparency = 1
contorno.OutlineColor = C.contorno
contorno.OutlineTransparency = 0
contorno.DepthMode = Enum.HighlightDepthMode.Occluded
contorno.Adornee = corpo
contorno.Parent = corpo

-- ===== FAÍSCAS EM "+" EM VOLTA DO CRISTAL =====
local faiscas = Instance.new("Model")
faiscas.Name = "Faiscas"
faiscas.Parent = model
local posFaiscas = { {1.0,7.1,-1.9}, {2.05,6.9,-1.5}, {1.7,7.5,-2.0}, {1.2,6.4,-2.2} }
for i, p in ipairs(posFaiscas) do
	local f = Instance.new("Model")
	f.Name = "Faisca" .. i
	f.Parent = faiscas
	local cf = CFrame.new(p[1], p[2], p[3])
	local tam = (i % 2 == 0) and 0.3 or 0.42
	bloco("Horizontal", Vector3.new(tam, 0.08, 0.08), cf, "brilho", "neon", f)
	bloco("Vertical", Vector3.new(0.08, tam, 0.08), cf, "brilho", "neon", f)
end

-- ===== CÍRCULO MÁGICO PIXELADO NO CHÃO =====
local circulo = Instance.new("Model")
circulo.Name = "CirculoMagico"
circulo.Parent = model

local function anel(raio, quantidade, espessura, cor, nome)
	local arco = 2 * math.pi * raio / quantidade
	for i = 0, quantidade - 1 do
		local a = i / quantidade * 2 * math.pi
		local cf = CFrame.new(math.cos(a) * raio, 0.05, math.sin(a) * raio) * CFrame.Angles(0, -a, 0)
		bloco(nome .. i, Vector3.new(espessura, 0.1, arco * 0.75), cf, cor, "neon", circulo)
	end
end
anel(3.0, 32, 0.25, "cristal", "AnelFora")
anel(2.4, 20, 0.15, "olho", "AnelDentro")

-- "+" no chão nas quatro diagonais
for k = 0, 3 do
	local a = math.rad(45 + k * 90)
	local cf = CFrame.new(math.cos(a) * 3.5, 0.06, math.sin(a) * 3.5)
	bloco("Cruz" .. k .. "A", Vector3.new(0.6, 0.1, 0.14), cf, "brilho", "neon", circulo)
	bloco("Cruz" .. k .. "B", Vector3.new(0.14, 0.1, 0.6), cf, "brilho", "neon", circulo)
end

-- ===== LUZES =====
local luzCristal = Instance.new("PointLight")
luzCristal.Color = C.cristal
luzCristal.Range = 10
luzCristal.Brightness = 2
luzCristal.Parent = criadas.Cristal

local luzOlhos = Instance.new("PointLight")
luzOlhos.Color = C.olho
luzOlhos.Range = 3
luzOlhos.Brightness = 1
luzOlhos.Parent = criadas.Rosto

-- ===== ANIMAÇÃO (roda quando você aperta Play) =====
local anim = Instance.new("Script")
anim.Name = "Animacao"
anim.Source = [[
-- Animação do Arcanista do Véu (design: Yuri Ramos Hernandez)
local RunService = game:GetService("RunService")
local model = script.Parent
local base = model:GetPivot()

local circulo = {}
for _, p in ipairs(model.CirculoMagico:GetChildren()) do
	circulo[p] = base:ToObjectSpace(p.CFrame)
end

local faiscas = {}
for i, f in ipairs(model.Faiscas:GetChildren()) do
	faiscas[f] = { cf = f:GetPivot(), fase = i * 1.7 }
end

local cristal = model.Corpo.Cristal
local cristalCF = cristal.CFrame

local t = 0
RunService.Heartbeat:Connect(function(dt)
	t += dt
	local giro = base * CFrame.Angles(0, t * 0.5, 0)
	for p, offset in pairs(circulo) do
		p.CFrame = giro * offset
	end
	cristal.CFrame = cristalCF * CFrame.new(0, math.sin(t * 2) * 0.1, 0) * CFrame.Angles(0, t * 1.5, 0)
	for f, info in pairs(faiscas) do
		f:PivotTo(info.cf * CFrame.new(0, math.sin(t * 2.5 + info.fase) * 0.18, 0))
	end
end)
]]
anim.Parent = model

-- ===== POSICIONAR NA FRENTE DA CÂMERA =====
model.WorldPivot = CFrame.new(0, 0, 0)
model.Parent = workspace

local cam = workspace.CurrentCamera
local alvo = cam.CFrame.Position + cam.CFrame.LookVector * 18
local chao = Vector3.new(alvo.X, 0, alvo.Z) -- y = 0 é o topo da Baseplate padrão
local olhar = Vector3.new(cam.CFrame.Position.X, 0, cam.CFrame.Position.Z)
if (olhar - chao).Magnitude < 0.1 then olhar = chao + Vector3.new(0, 0, -1) end
model:PivotTo(CFrame.lookAt(chao, olhar))

game:GetService("Selection"):Set({ model })
print("Arcanista do Véu criado! Design: Yuri Ramos Hernandez")
