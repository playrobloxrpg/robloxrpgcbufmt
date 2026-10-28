--[[
	VILA PEDRA-MUSGO - lobby de A Toca da Tecela Faminta
	Design: Yuri Ramos Hernandez

	Mesmo estilo em blocos das masmorras: paleta propria, contorno nos moradores e brilhos neon.
	Vilarejo compacto (~220 x 220 studs) com rio e cais, ruas de pedra, praca com o portal,
	casas, a Forja da Ilda e a Taverna do Caneco Torto (com interior completo).

	O QUE FUNCIONA NO PLAY
	  - Moedas: todo jogador comeca com 50 (aparecem na lista de jogadores).
	  - Classes: no Salao dos Herois, dentro da taverna, segure F num pedestal para escolher.
	    Cada classe ganha vida maxima propria e uma arma inicial.
	  - Lojas: fale com o taverneiro (pocoes e tocha) e com a ferreira (armas). Segure E.
	  - Armas: clique para atacar. Ferem as aranhas da masmorra e dao moedas por abate
	    (10 por cria, 150 pela Tecela). A Tocha ilumina e corta as teias violeta;
	    o cajado tambem corta. As pocoes curam ao usar.
	  - Portal na praca: leva para o inicio da Toca. Ha um portal de volta no pe da escada.

	COMO USAR
	  1. Rode antes o script da masmorra (toca_da_tecela_faminta.lua).
	  2. Se quiser as estatuas das classes no salao, rode o classes_de_personagem.lua.
	  3. Rode este script no Command Bar (View > Command Bar > cole tudo > Enter).
	  O lobby fica ao lado da masmorra e vira o lugar onde os jogadores nascem.
	  Rodar de novo apaga a vila anterior e cria outra.
]]

local ORIGEM = CFrame.new(0, 0, 520)
local AJUSTAR_ILUMINACAO = true

local NOME = "VilaPedraMusgo"
local antiga = workspace:FindFirstChild(NOME)
if antiga then antiga:Destroy() end

local raiz = Instance.new("Folder")
raiz.Name = NOME
raiz:SetAttribute("Designer", "Yuri Ramos Hernandez")

local function pasta(nome, pai)
	local f = Instance.new("Folder")
	f.Name = nome
	f.Parent = pai or raiz
	return f
end
local Fterreno = pasta("Terreno")
local Fruas = pasta("Ruas")
local Fcasas = pasta("Casas")
local Ftaverna = pasta("TavernaDoCanecoTorto")
local Fforja = pasta("ForjaDaIlda")
local Fpraca = pasta("Praca")
local Fnatureza = pasta("Natureza")
local Fdetalhes = pasta("Detalhes")

local moradores = Instance.new("Model")
moradores.Name = "Moradores"
moradores.Parent = raiz

-- ===================== PALETA =====================
local C = {
	grama = Color3.fromRGB(78, 112, 58), grama2 = Color3.fromRGB(92, 128, 66), grama3 = Color3.fromRGB(66, 96, 50),
	terra = Color3.fromRGB(110, 86, 62), caminho = Color3.fromRGB(176, 166, 142), caminho2 = Color3.fromRGB(156, 146, 124),
	pedra = Color3.fromRGB(128, 124, 118), pedra2 = Color3.fromRGB(104, 100, 96), pedraEsc = Color3.fromRGB(78, 74, 72),
	agua = Color3.fromRGB(70, 112, 140), aguaFunda = Color3.fromRGB(46, 78, 104),
	madeira = Color3.fromRGB(116, 82, 54), madeira2 = Color3.fromRGB(92, 64, 42), madeiraEsc = Color3.fromRGB(64, 44, 30),
	madeiraClara = Color3.fromRGB(150, 112, 74), tabua = Color3.fromRGB(132, 96, 62), tabua2 = Color3.fromRGB(120, 86, 56),
	reboco = Color3.fromRGB(196, 182, 156), reboco2 = Color3.fromRGB(176, 162, 136),
	telhado = Color3.fromRGB(104, 76, 58), telhado2 = Color3.fromRGB(86, 62, 48), ardosia = Color3.fromRGB(86, 90, 100), ardosia2 = Color3.fromRGB(70, 74, 84),
	vidro = Color3.fromRGB(255, 196, 120), vidroEsc = Color3.fromRGB(60, 70, 90),
	folha = Color3.fromRGB(64, 98, 50), folha2 = Color3.fromRGB(80, 116, 58), folha3 = Color3.fromRGB(52, 82, 44), tronco = Color3.fromRGB(86, 62, 44),
	fogo = Color3.fromRGB(255, 140, 50), fogo2 = Color3.fromRGB(255, 60, 20), brasa = Color3.fromRGB(255, 96, 40),
	ferro = Color3.fromRGB(64, 64, 74), aco = Color3.fromRGB(150, 154, 166), lamina = Color3.fromRGB(196, 202, 214), ouro = Color3.fromRGB(206, 164, 64),
	violeta = Color3.fromRGB(176, 92, 255), violetaClaro = Color3.fromRGB(225, 200, 255), runa = Color3.fromRGB(150, 100, 230),
	carmim = Color3.fromRGB(128, 28, 40), tecido = Color3.fromRGB(150, 40, 46), tecido2 = Color3.fromRGB(60, 90, 130), tecido3 = Color3.fromRGB(196, 170, 90),
	palha = Color3.fromRGB(196, 168, 96), vela = Color3.fromRGB(240, 230, 200), chama = Color3.fromRGB(255, 200, 110),
	pele = Color3.fromRGB(222, 178, 142), pele2 = Color3.fromRGB(176, 128, 96), pele3 = Color3.fromRGB(240, 200, 170),
	cabelo = Color3.fromRGB(70, 46, 32), cabelo2 = Color3.fromRGB(150, 110, 60), cabelo3 = Color3.fromRGB(200, 200, 196), sombra = Color3.fromRGB(14, 12, 20),
	garrafa1 = Color3.fromRGB(70, 140, 80), garrafa2 = Color3.fromRGB(150, 60, 50), garrafa3 = Color3.fromRGB(80, 90, 160),
	caneca = Color3.fromRGB(190, 150, 90), espuma = Color3.fromRGB(240, 236, 220), pao = Color3.fromRGB(200, 150, 80), maca = Color3.fromRGB(200, 50, 50),
	carta = Color3.fromRGB(236, 232, 220), tapete = Color3.fromRGB(120, 36, 40), tapete2 = Color3.fromRGB(176, 130, 60),
}

local M = { plastico = Enum.Material.SmoothPlastic, metal = Enum.Material.Metal, neon = Enum.Material.Neon }
local SMOOTH = Enum.SurfaceType.Smooth

local semente = 528491
local function rnd()
	semente = (semente * 16807) % 2147483647
	return semente / 2147483647
end
local function entre(a, b) return a + (b - a) * rnd() end

-- ===================== AJUDANTES =====================
local function novoPart(pai, nome, tamanho, cf, cor, mat, transp)
	local p = Instance.new("Part")
	p.Name = nome
	p.Anchored = true
	p.Size = tamanho
	p.CFrame = cf
	p.Color = C[cor]
	p.Material = M[mat or "plastico"]
	p.TopSurface = SMOOTH
	p.BottomSurface = SMOOTH
	if transp then p.Transparency = transp end
	if mat == "neon" then p.CastShadow = false end
	p.Parent = pai
	return p
end
local function rotY(g) return CFrame.Angles(0, math.rad(g), 0) end
local function bloco(pai, nome, sx, sy, sz, x, y, z, cor, mat, rot, transp)
	local cf = ORIGEM * CFrame.new(x, y, z)
	if rot then cf = cf * rot end
	return novoPart(pai, nome, Vector3.new(sx, sy, sz), cf, cor, mat, transp)
end
local function W(x, y, z) return ORIGEM * Vector3.new(x, y, z) end
local function blocoL(pai, nome, base, sx, sy, sz, lx, ly, lz, cor, mat, rot, transp)
	local cf = base * CFrame.new(lx, ly, lz)
	if rot then cf = cf * rot end
	return novoPart(pai, nome, Vector3.new(sx, sy, sz), cf, cor, mat, transp)
end
local function ligaL(pai, nome, base, a, b, esp, cor, mat)
	local pa, pb = base * a, base * b
	local d = pb - pa
	local cima = (math.abs(d.Unit.Y) > 0.98) and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)
	return novoPart(pai, nome, Vector3.new(esp, esp, d.Magnitude), CFrame.lookAt((pa + pb) / 2, pb, cima), cor, mat)
end
local function luz(parte, cor, alcance, brilho)
	local l = Instance.new("PointLight")
	l.Color = C[cor]
	l.Range = alcance
	l.Brightness = brilho or 1
	l.Parent = parte
	return l
end
local function fogo(parte, tamanho)
	local f = Instance.new("Fire")
	f.Size = tamanho or 3
	f.Heat = 6
	f.Color = C.fogo
	f.SecondaryColor = C.fogo2
	f.Parent = parte
end
local function semColisao(m)
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end
local function placa(parte, face, texto, tamanhoTexto)
	local sg = Instance.new("SurfaceGui")
	sg.Face = face
	sg.CanvasSize = Vector2.new(400, 100)
	local r = Instance.new("TextLabel")
	r.Size = UDim2.fromScale(1, 1)
	r.BackgroundTransparency = 1
	r.Text = texto
	r.TextColor3 = Color3.fromRGB(240, 224, 190)
	r.TextStrokeTransparency = 0.4
	r.Font = Enum.Font.Arcade
	r.TextScaled = true
	r.Parent = sg
	sg.Parent = parte
end

-- areas onde nao nascem arvores (x1, z1, x2, z2)
local ocupado = {}
local function ocupar(x1, z1, x2, z2) table.insert(ocupado, { x1, z1, x2, z2 }) end
local function livre(x, z, margem)
	for _, r in ipairs(ocupado) do
		if x > r[1] - margem and x < r[3] + margem and z > r[2] - margem and z < r[4] + margem then return false end
	end
	return true
end
