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

-- ===================== MORADORES (NPCs) =====================
-- base: pes no chao, frente para -Z. sentado = sentado numa cadeira de assento a 1.6 do chao
local function morador(nome, base, v, sentado)
	local m = Instance.new("Model")
	m.Name = nome
	m.Parent = moradores
	local function b(n, sx, sy, sz, x, y, z, cor, mat, rot) return blocoL(m, n, base, sx, sy, sz, x, y, z, cor, mat, rot) end
	local dy = 0
	if sentado then
		dy = 0.7
		for _, x in ipairs({ -0.45, 0.45 }) do
			b("Coxa", 0.7, 0.7, 1.4, x, 1.95, -0.6, v.calca)
			b("Canela", 0.7, 1.3, 0.7, x, 0.95, -1.2, v.calca)
			b("Bota", 0.8, 0.5, 1.0, x, 0.25, -1.35, v.bota or "madeiraEsc")
		end
	else
		for _, x in ipairs({ -0.45, 0.45 }) do
			b("Bota", 0.8, 0.5, 1.1, x, 0.25, -0.08, v.bota or "madeiraEsc")
			b("Perna", 0.7, 1.4, 0.7, x, 1.2, 0, v.calca)
		end
	end
	b("Tronco", 2.0, 1.9, 1.3, 0, 2.85 + dy, 0, v.roupa)
	b("Cinto", 2.05, 0.3, 1.35, 0, 2.05 + dy, 0, v.cinto or "madeiraEsc")
	if v.avental then b("Avental", 1.4, 2.1, 0.1, 0, 2.3 + dy, -0.7, v.avental) end
	if v.colete then b("Colete", 2.1, 1.3, 1.4, 0, 3.1 + dy, 0, v.colete) end
	for _, x in ipairs({ -1.3, 1.3 }) do
		b("Braco", 0.6, 1.6, 0.6, x, 2.9 + dy, 0, v.manga or v.roupa)
		b("Mao", 0.55, 0.45, 0.55, x, 1.9 + dy, -0.05, v.pele)
	end
	b("Cabeca", 1.3, 1.3, 1.3, 0, 4.45 + dy, 0, v.pele)
	b("OlhoE", 0.2, 0.22, 0.06, -0.28, 4.55 + dy, -0.66, "sombra")
	b("OlhoD", 0.2, 0.22, 0.06, 0.28, 4.55 + dy, -0.66, "sombra")
	b("Nariz", 0.2, 0.3, 0.14, 0, 4.35 + dy, -0.7, "pele2")
	if v.cabelo then
		b("Cabelo", 1.4, 0.4, 1.4, 0, 5.2 + dy, 0.02, v.cabelo)
		b("CabeloTras", 1.4, 1.0, 0.25, 0, 4.7 + dy, 0.6, v.cabelo)
	end
	if v.barba then
		b("Barba", 1.1, 0.6, 0.3, 0, 3.95 + dy, -0.58, v.barba)
		b("Bigode", 0.8, 0.15, 0.1, 0, 4.18 + dy, -0.68, v.barba)
	end
	if v.chapeu then
		b("Chapeu", 1.9, 0.2, 1.9, 0, 5.25 + dy, 0, v.chapeu)
		b("ChapeuTopo", 1.3, 0.6, 1.3, 0, 5.6 + dy, 0, v.chapeu)
	end
	if v.capuz then
		b("Lenco", 1.45, 0.35, 1.45, 0, 5.2 + dy, 0, v.capuz)
		b("LencoTras", 1.45, 0.9, 0.25, 0, 4.75 + dy, 0.62, v.capuz)
	end
	if v.elmo then
		b("Elmo", 1.5, 0.7, 1.5, 0, 5.3 + dy, 0, "aco", "metal")
		b("Nasal", 0.2, 0.6, 0.08, 0, 4.8 + dy, -0.76, "aco", "metal")
	end
	semColisao(m)
	m.WorldPivot = base
	return m
end

-- ===================== TERRENO E RIO =====================
-- grama: tudo, menos o rio ao sul (z > 186) e a baia a leste (x > 190, z > 120)
bloco(Fterreno, "Grama", 190, 4, 186, 95, -2, 93, "grama")
bloco(Fterreno, "GramaLeste", 30, 4, 120, 205, -2, 60, "grama")
bloco(Fterreno, "LeitoRio", 260, 3, 60, 110, -5, 212, "terra")
bloco(Fterreno, "LeitoBaia", 30, 3, 70, 205, -5, 155, "terra")
local agua = bloco(Fterreno, "Rio", 260, 2.6, 40, 110, -1.8, 207, "agua", nil, nil, 0.15)
agua.CanCollide = false
local agua2 = bloco(Fterreno, "Baia", 34, 2.6, 66, 207, -1.8, 155, "agua", nil, nil, 0.15)
agua2.CanCollide = false
bloco(Fterreno, "FundoRio", 260, 0.4, 40, 110, -3.2, 207, "aguaFunda")
-- manchas de grama em tons diferentes (pixel)
for _ = 1, 60 do
	local x, z = entre(4, 186), entre(4, 182)
	local w, d = entre(4, 12), entre(4, 12)
	local p = bloco(Fterreno, "Mancha", w, 0.1, d, x, 0.05, z, (rnd() < 0.5) and "grama2" or "grama3")
	p.CanCollide = false
end
-- margens de pedra
for i = 0, 28 do
	local x = i * 8 + 4
	local h = entre(0.8, 2.2)
	bloco(Fterreno, "Margem", entre(6, 9), h, entre(3, 5), x, h / 2 - 0.6, 187 + entre(-0.5, 1.5), (i % 2 == 0) and "pedra" or "pedra2")
end
for i = 0, 8 do
	local z = 122 + i * 8
	local h = entre(0.8, 2.2)
	bloco(Fterreno, "Margem", entre(3, 5), h, entre(6, 9), 189 + entre(-0.5, 1.5), h / 2 - 0.6, z, (i % 2 == 0) and "pedra" or "pedra2")
end
ocupar(186, 118, 230, 230)
ocupar(-10, 184, 230, 230)

-- ===================== RUAS E PRACA =====================
local function rua(x1, z1, x2, z2)
	local p = bloco(Fruas, "Rua", x2 - x1, 0.2, z2 - z1, (x1 + x2) / 2, 0.1, (z1 + z2) / 2, "caminho")
	p.CanCollide = false
	-- pedras soltas no caminho
	local n = math.floor((x2 - x1) * (z2 - z1) / 60)
	for _ = 1, n do
		local q = bloco(Fruas, "Pedrinha", entre(1, 2.5), 0.12, entre(1, 2.5), entre(x1 + 1, x2 - 1), 0.22, entre(z1 + 1, z2 - 1), "caminho2")
		q.CanCollide = false
	end
	ocupar(x1, z1, x2, z2)
end
rua(10, 104, 186, 116)   -- leste-oeste
rua(104, 88, 116, 186)   -- norte-sul, da taverna ate o cais
rua(40, 116, 50, 160)    -- ramal sudoeste
rua(150, 40, 158, 104)   -- ramal nordeste

-- praca central em xadrez de pedra
for i = 0, 9 do
	for j = 0, 9 do
		local p = bloco(Fpraca, "Piso", 4, 0.3, 4, 92 + i * 4, 0.15, 92 + j * 4, ((i + j) % 2 == 0) and "pedra" or "pedra2")
		p.CanCollide = false
	end
end
ocupar(88, 88, 132, 132)

-- ===================== PORTAL PARA A TOCA =====================
local portalM = Instance.new("Model")
portalM.Name = "PortalDaToca"
portalM.Parent = Fpraca
bloco(portalM, "Degrau1", 16, 0.8, 8, 110, 0.4, 110, "pedra2")
bloco(portalM, "Degrau2", 13, 0.8, 6, 110, 1.2, 110, "pedra")
for _, x in ipairs({ -6, 6 }) do
	bloco(portalM, "Pilar", 2, 14, 2, 110 + x, 8.6, 110, "pedraEsc")
	bloco(portalM, "PilarBase", 2.6, 1, 2.6, 110 + x, 2.1, 110, "pedra2")
	for k = 0, 3 do
		bloco(portalM, "Runa", 0.1, 0.8, 0.8, 110 + x + ((x < 0) and 1.05 or -1.05), 4.5 + k * 2.8, 110, "runa", "neon", nil, 0.2)
	end
end
bloco(portalM, "Arco1", 14, 1.4, 2, 110, 16.3, 110, "pedraEsc")
bloco(portalM, "Arco2", 9, 1, 2, 110, 17.5, 110, "pedra2")
bloco(portalM, "Arco3", 4, 1, 2, 110, 18.5, 110, "pedraEsc")
local olhoArco = bloco(portalM, "OlhoDoArco", 1.2, 1.2, 2.1, 110, 16.3, 110, "violeta", "neon", rotY(0) * CFrame.Angles(0, 0, math.rad(45)))
local superficie = bloco(portalM, "Superficie", 10, 13, 0.4, 110, 9, 110, "violeta", "neon", nil, 0.35)
superficie.CanCollide = false
superficie:SetAttribute("Portal", "IrParaToca")
luz(superficie, "violeta", 30, 2)
local brilhoPortal = Instance.new("ParticleEmitter")
brilhoPortal.Color = ColorSequence.new(C.violetaClaro)
brilhoPortal.LightEmission = 1
brilhoPortal.Size = NumberSequence.new(0.4)
brilhoPortal.Lifetime = NumberRange.new(1, 2)
brilhoPortal.Rate = 25
brilhoPortal.Speed = NumberRange.new(1, 3)
brilhoPortal.SpreadAngle = Vector2.new(30, 30)
brilhoPortal.Parent = superficie
local tabuleta = bloco(portalM, "Tabuleta", 6, 2.4, 0.6, 110, 2.8, 117, "pedra2")
bloco(portalM, "TabuletaPe", 1, 1.6, 0.6, 110, 0.8, 117, "pedraEsc")
placa(tabuleta, Enum.NormalId.Back, "A TOCA DA TECELA FAMINTA - NIVEL 5 A 7")
placa(tabuleta, Enum.NormalId.Front, "A TOCA DA TECELA FAMINTA - NIVEL 5 A 7")
olhoArco.CanCollide = false

local spawnLobby = Instance.new("SpawnLocation")
spawnLobby.Name = "InicioNoLobby"
spawnLobby.Size = Vector3.new(8, 0.6, 8)
spawnLobby.CFrame = ORIGEM * CFrame.new(110, 0.3, 142) * rotY(180)
spawnLobby.Anchored = true
spawnLobby.Color = C.carmim
spawnLobby.Material = M.plastico
spawnLobby.TopSurface = SMOOTH
spawnLobby.BottomSurface = SMOOTH
spawnLobby.Neutral = true
spawnLobby.Duration = 0
spawnLobby.Parent = Fpraca

-- barracas de feira nos cantos da praca
local function barraca(x, z, corToldo, giro)
	local m = Instance.new("Model")
	m.Name = "Barraca"
	m.Parent = Fpraca
	local base = ORIGEM * CFrame.new(x, 0, z) * rotY(giro)
	for _, p in ipairs({ { -2.6, -1.6 }, { 2.6, -1.6 }, { -2.6, 1.6 }, { 2.6, 1.6 } }) do
		blocoL(m, "Poste", base, 0.4, 6, 0.4, p[1], 3, p[2], "madeira2")
	end
	blocoL(m, "Balcao", base, 5.6, 2.2, 1.6, 0, 1.1, -1.2, "madeira")
	blocoL(m, "Tampo", base, 5.9, 0.25, 1.8, 0, 2.3, -1.2, "madeiraClara")
	for i = 0, 3 do
		blocoL(m, "Toldo", base, 6.2, 0.3, 1.0, 0, 6.2 - i * 0.3, -1.9 + i * 1.0, (i % 2 == 0) and corToldo or "vela")
	end
	for i = 0, 4 do
		local itens = { "maca", "pao", "garrafa1", "maca", "pao" }
		blocoL(m, "Mercadoria", base, 0.6, 0.5, 0.6, -2 + i, 2.7, -1.2, itens[i + 1])
	end
	blocoL(m, "Caixote", base, 1.2, 1.2, 1.2, 2.2, 0.6, 1.2, "madeira2")
	ocupar(x - 4, z - 3, x + 4, z + 3)
end
barraca(95, 125, "tecido", 0)
barraca(125, 125, "tecido2", 0)

-- ===================== TAVERNA DO CANECO TORTO =====================
-- interior: x 86..134, z 22..86, piso em y = 0.6. Porta ao sul, virada para a praca.
local T = Ftaverna
local P0 = 0.6
local Fext = pasta("Exterior", T)
local Fint = pasta("Interior", T)
local Fmov = pasta("Moveis", T)
ocupar(80, 16, 140, 92)

-- piso de tabuas
for i = 0, 23 do
	bloco(Fint, "Tabua", 2, 0.6, 64, 87 + i * 2, 0.3, 54, (i % 2 == 0) and "tabua" or "tabua2")
end
bloco(Fext, "Fundacao", 54, 0.5, 70, 110, 0.25, 54, "pedra2")

-- paredes de madeira com pilares
local H = 16
bloco(Fext, "ParedeOeste", 2, H, 68, 85, P0 + H / 2, 54, "madeira")
bloco(Fext, "ParedeLeste", 2, H, 68, 135, P0 + H / 2, 54, "madeira")
bloco(Fext, "ParedeNorte", 52, H, 2, 110, P0 + H / 2, 21, "madeira")
bloco(Fext, "ParedeSulE", 23, H, 2, 95.5, P0 + H / 2, 87, "madeira")
bloco(Fext, "ParedeSulD", 23, H, 2, 124.5, P0 + H / 2, 87, "madeira")
bloco(Fext, "ParedeSulPorta", 6, H - 9, 2, 110, P0 + 9 + (H - 9) / 2, 87, "madeira")
for _, x in ipairs({ 84.5, 98, 110 - 3.6, 110 + 3.6, 122, 135.5 }) do
	bloco(Fext, "Pilar", 1.4, H, 2.6, x, P0 + H / 2, 87, "madeiraEsc")
	bloco(Fext, "Pilar", 1.4, H, 2.6, x, P0 + H / 2, 21, "madeiraEsc")
end
for _, z in ipairs({ 21, 38, 54, 70, 87 }) do
	bloco(Fext, "Pilar", 2.6, H, 1.4, 85, P0 + H / 2, z, "madeiraEsc")
	bloco(Fext, "Pilar", 2.6, H, 1.4, 135, P0 + H / 2, z, "madeiraEsc")
end
-- rodape de pedra por dentro das paredes
bloco(Fint, "Rodape", 0.4, 1, 64, 86.2, P0 + 0.5, 54, "pedra2")
bloco(Fint, "Rodape", 0.4, 1, 64, 133.8, P0 + 0.5, 54, "pedra2")
bloco(Fint, "Rodape", 48, 1, 0.4, 110, P0 + 0.5, 22.2, "pedra2")
-- janelas que atravessam a parede (brilham dos dois lados)
local function janelaT(x, z, normalX)
	if normalX then
		bloco(Fext, "Janela", 2.4, 3, 2.4, x, 7.6, z, "vidro", "neon", nil, 0.2)
		bloco(Fext, "Moldura", 2.6, 3.4, 0.3, x, 7.6, z, "madeiraEsc")
		bloco(Fext, "Moldura", 2.6, 0.3, 2.8, x, 7.6, z, "madeiraEsc")
	else
		bloco(Fext, "Janela", 2.4, 3, 2.4, x, 7.6, z, "vidro", "neon", nil, 0.2)
		bloco(Fext, "Moldura", 0.3, 3.4, 2.6, x, 7.6, z, "madeiraEsc")
		bloco(Fext, "Moldura", 2.8, 0.3, 2.6, x, 7.6, z, "madeiraEsc")
	end
end
for _, z in ipairs({ 30, 46, 62, 78 }) do
	janelaT(85, z, true)
	janelaT(135, z, true)
end
janelaT(94, 87, false)
janelaT(126, 87, false)
janelaT(98, 21, false)

-- teto, vigas e telhado em degraus
local teto = bloco(Fext, "TetoTaverna", 52, 0.6, 68, 110, P0 + H + 0.3, 54, "madeiraEsc")
for i = 0, 7 do
	bloco(Fint, "VigaTeto", 48, 0.8, 0.8, 110, P0 + H - 0.4, 26 + i * 8, "madeiraEsc")
end
for i = 0, 11 do
	local largura = 56 - i * 4.6
	bloco(Fext, "Telhado", largura, 1.4, 72, 110, P0 + H + 1.3 + i * 1.4, 54, (i % 2 == 0) and "telhado" or "telhado2")
end
bloco(Fext, "TelhadoCumeeira", 1.2, 0.8, 72.6, 110, P0 + H + 1.3 + 12 * 1.4, 54, "telhado2")
bloco(Fext, "Chamine", 6, 22, 4, 124, P0 + 8 + 11, 23, "pedra2")
bloco(Fext, "ChamineTopo", 6.8, 0.8, 4.8, 124, P0 + 30.4, 23, "pedraEsc")

-- entrada e tabuleta
bloco(Fext, "Degrau", 9, 0.6, 2.4, 110, 0.3, 89.2, "pedra")
bloco(Fext, "BracoTabuleta", 0.4, 0.4, 3.2, 104, 12.2, 89.4, "madeiraEsc")
local tab = bloco(Fext, "Tabuleta", 8, 2.2, 0.4, 104, 10.6, 90.6, "madeira2")
placa(tab, Enum.NormalId.Back, "TAVERNA DO CANECO TORTO")
placa(tab, Enum.NormalId.Front, "TAVERNA DO CANECO TORTO")
for _, x in ipairs({ 105.2, 114.8 }) do
	local l = bloco(Fext, "LanternaPorta", 0.7, 0.9, 0.7, x, 8, 88.6, "chama", "neon")
	luz(l, "chama", 16, 1)
end

-- ===== MOVEIS =====
local function vela(pai, x, y, z, comLuz)
	bloco(pai, "Vela", 0.3, 0.6, 0.3, x, y + 0.3, z, "vela")
	local c = bloco(pai, "Chama", 0.2, 0.3, 0.2, x, y + 0.75, z, "chama", "neon")
	c.CanCollide = false
	if comLuz then luz(c, "chama", 10, 0.7) end
end
local function caneca(pai, x, y, z)
	bloco(pai, "Caneca", 0.45, 0.55, 0.45, x, y + 0.28, z, "caneca")
	bloco(pai, "Espuma", 0.47, 0.12, 0.47, x, y + 0.6, z, "espuma")
end
local function cadeira(pai, x, z, alvoX, alvoZ, cor)
	local m = Instance.new("Model")
	m.Name = "Cadeira"
	m.Parent = pai
	local base = CFrame.lookAt(W(x, P0, z), W(alvoX, P0, alvoZ))
	blocoL(m, "Assento", base, 1.6, 0.3, 1.6, 0, 1.6, 0, cor or "madeira")
	for _, p in ipairs({ { -0.65, -0.65 }, { 0.65, -0.65 }, { -0.65, 0.65 }, { 0.65, 0.65 } }) do
		blocoL(m, "Perna", base, 0.25, 1.5, 0.25, p[1], 0.75, p[2], "madeira2")
	end
	blocoL(m, "Encosto", base, 1.6, 1.8, 0.25, 0, 2.6, 0.7, cor or "madeira")
	blocoL(m, "EncostoTopo", base, 1.7, 0.25, 0.35, 0, 3.5, 0.7, "madeiraEsc")
	return base
end
local function mesaRedonda(cx, cz, r, n)
	local m = Instance.new("Model")
	m.Name = "MesaRedonda"
	m.Parent = Fmov
	bloco(m, "Tampo", 2 * r, 0.4, 1.2 * r, cx, P0 + 2.6, cz, "madeiraClara")
	bloco(m, "Tampo", 1.2 * r, 0.4, 2 * r, cx, P0 + 2.6, cz, "madeiraClara")
	bloco(m, "Tampo", 1.7 * r, 0.42, 1.7 * r, cx, P0 + 2.6, cz, "madeira")
	bloco(m, "Pe", 1, 2.4, 1, cx, P0 + 1.2, cz, "madeira2")
	bloco(m, "Base", 2.4, 0.3, 2.4, cx, P0 + 0.15, cz, "madeira2")
	for i = 0, n - 1 do
		local a = i / n * 2 * math.pi
		cadeira(m, cx + math.cos(a) * (r + 1.2), cz + math.sin(a) * (r + 1.2), cx, cz)
	end
	vela(m, cx, P0 + 2.8, cz, true)
end
local function mesaQuadrada(cx, cz, lados)
	local m = Instance.new("Model")
	m.Name = "Mesa"
	m.Parent = Fmov
	bloco(m, "Tampo", 4, 0.4, 3.4, cx, P0 + 2.6, cz, "madeiraClara")
	for _, p in ipairs({ { -1.6, -1.3 }, { 1.6, -1.3 }, { -1.6, 1.3 }, { 1.6, 1.3 } }) do
		bloco(m, "Perna", 0.35, 2.4, 0.35, cx + p[1], P0 + 1.2, cz + p[2], "madeira2")
	end
	local pos = { N = { cx, cz - 2.8 }, S = { cx, cz + 2.8 }, L = { cx + 3.0, cz }, O = { cx - 3.0, cz } }
	for _, l in ipairs(lados) do
		cadeira(m, pos[l][1], pos[l][2], cx, cz)
	end
	caneca(m, cx - 0.8, P0 + 2.8, cz - 0.4)
	caneca(m, cx + 0.9, P0 + 2.8, cz + 0.5)
	bloco(m, "Prato", 1, 0.1, 1, cx + 0.2, P0 + 2.85, cz - 0.6, "carta")
	bloco(m, "Pao", 0.6, 0.35, 0.4, cx + 0.2, P0 + 3.05, cz - 0.6, "pao")
	bloco(m, "Cartas", 0.6, 0.06, 0.8, cx - 0.6, P0 + 2.83, cz + 0.7, "carta", nil, rotY(20))
	return m
end
local function barril(x, z, deitado, y)
	local m = Instance.new("Model")
	m.Name = "Barril"
	m.Parent = Fmov
	y = y or P0
	if deitado then
		bloco(m, "Barril", 2.2, 1.8, 1.8, x, y + 0.9, z, "madeira")
		bloco(m, "Aro", 0.25, 1.95, 1.95, x - 0.7, y + 0.9, z, "ferro", "metal")
		bloco(m, "Aro", 0.25, 1.95, 1.95, x + 0.7, y + 0.9, z, "ferro", "metal")
		bloco(m, "Tampa", 0.1, 1.2, 1.2, x - 1.15, y + 0.9, z, "madeira2")
	else
		bloco(m, "Barril", 1.8, 2.2, 1.8, x, y + 1.1, z, "madeira")
		bloco(m, "Aro", 1.95, 0.25, 1.95, x, y + 0.4, z, "ferro", "metal")
		bloco(m, "Aro", 1.95, 0.25, 1.95, x, y + 1.8, z, "ferro", "metal")
		bloco(m, "Tampa", 1.4, 0.1, 1.4, x, y + 2.25, z, "madeira2")
	end
end
local function caixote(x, z, s, y)
	bloco(Fmov, "Caixote", s, s, s, x, (y or P0) + s / 2, z, "madeira2")
	bloco(Fmov, "CaixoteRipa", s + 0.05, 0.2, s + 0.05, x, (y or P0) + s / 2, z, "madeiraEsc")
end

-- lareira de pedra (parede norte, a direita)
do
	local m = Instance.new("Model")
	m.Name = "Lareira"
	m.Parent = Fmov
	bloco(m, "Pedra", 10, 8, 4, 124, P0 + 4, 24, "pedra")
	bloco(m, "PedraTopo", 11, 0.6, 4.6, 124, P0 + 8.3, 24.2, "pedra2")
	bloco(m, "Boca", 5.4, 3.8, 0.3, 124, P0 + 1.9, 26.05, "sombra")
	bloco(m, "Soleira", 11, 0.4, 2.4, 124, P0 + 0.2, 27.2, "pedra2")
	bloco(m, "Lenha", 3.6, 0.5, 0.6, 124, P0 + 0.65, 26.6, "madeiraEsc")
	bloco(m, "Lenha", 0.6, 0.5, 2.8, 124.8, P0 + 1.05, 26.4, "madeiraEsc", nil, rotY(30))
	local brasa = bloco(m, "Brasas", 3.2, 0.5, 1, 124, P0 + 1.2, 26.5, "brasa", "neon")
	brasa.CanCollide = false
	fogo(brasa, 3)
	luz(brasa, "fogo", 30, 2.2)
	bloco(m, "Prateleira", 11, 0.5, 1.4, 124, P0 + 6.2, 26.4, "madeiraEsc")
	caneca(m, 120.5, P0 + 6.45, 26.4)
	vela(m, 127.5, P0 + 6.45, 26.4, false)
	bloco(m, "Lenheira", 2.6, 2.2, 2.6, 131.5, P0 + 1.1, 24, "madeira2")
	for i = 0, 2 do
		bloco(m, "Tora", 2.4, 0.6, 0.6, 131.5, P0 + 2.5 + i * 0.6, 23.2 + i * 0.4, "madeira")
	end
end

-- balcao em L com banquinhos e prateleira de garrafas
do
	local m = Instance.new("Model")
	m.Name = "Balcao"
	m.Parent = Fmov
	bloco(m, "BalcaoLongo", 3, 4.2, 16, 115, P0 + 2.1, 37, "madeira")
	bloco(m, "TampoLongo", 3.6, 0.4, 16.6, 115, P0 + 4.4, 37, "madeiraClara")
	bloco(m, "BalcaoPe", 12.5, 4.2, 3, 121.25, P0 + 2.1, 46.5, "madeira")
	bloco(m, "TampoPe", 13.1, 0.4, 3.6, 121.25, P0 + 4.4, 46.5, "madeiraClara")
	for i = 0, 4 do
		bloco(m, "Painel", 0.2, 3.4, 2.6, 113.4, P0 + 2.0, 31 + i * 3, "madeira2")
	end
	local garrafas = { "garrafa1", "garrafa2", "garrafa3" }
	for i = 0, 5 do
		bloco(m, "Garrafa", 0.4, 0.9, 0.4, 115.3, P0 + 5.05, 31 + i * 1.3, garrafas[(i % 3) + 1])
	end
	caneca(m, 115, P0 + 4.6, 40)
	caneca(m, 115, P0 + 4.6, 42.5)
	caneca(m, 118, P0 + 4.6, 46.5)
	bloco(m, "Barrilete", 1.2, 1.2, 1.6, 124, P0 + 5.2, 46.5, "madeira2")
	bloco(m, "Torneira", 0.2, 0.3, 0.5, 124, P0 + 4.9, 45.4, "ouro", "metal")
	for _, z in ipairs({ 31, 34, 37, 40, 43 }) do
		bloco(m, "BancoAssento", 1.4, 0.3, 1.4, 111.5, P0 + 3.0, z, "madeira")
		bloco(m, "BancoPe", 0.4, 2.85, 0.4, 111.5, P0 + 1.45, z, "madeira2")
	end
	for _, x in ipairs({ 117, 121, 125 }) do
		bloco(m, "BancoAssento", 1.4, 0.3, 1.4, x, P0 + 3.0, 50.2, "madeira")
		bloco(m, "BancoPe", 0.4, 2.85, 0.4, x, P0 + 1.45, 50.2, "madeira2")
	end
	-- prateleira de garrafas na parede leste
	for k = 0, 2 do
		bloco(m, "Prateleira", 1.4, 0.3, 12, 133.2, P0 + 4.2 + k * 2.4, 37, "madeiraEsc")
		for i = 0, 7 do
			local cor = garrafas[((i + k) % 3) + 1]
			bloco(m, "Garrafa", 0.45, 1.0, 0.45, 133.2, P0 + 4.85 + k * 2.4, 31.8 + i * 1.5, cor)
		end
	end
end

-- mesa redonda grande (noroeste) e mesinha perto da lareira
mesaRedonda(98, 34, 4.2, 6)
mesaRedonda(127, 34, 2.8, 3)

-- meias-paredes que dividem o salao
bloco(Fmov, "MeiaParede", 16, 3, 1.2, 94, P0 + 1.5, 50, "madeira2")
bloco(Fmov, "MeiaParedeTopo", 16.4, 0.4, 1.6, 94, P0 + 3.2, 50, "madeiraEsc")
bloco(Fmov, "Coluna", 1.4, H, 1.4, 102.7, P0 + H / 2, 50, "madeiraEsc")
bloco(Fmov, "MeiaParede", 10, 3, 1.2, 129, P0 + 1.5, 50, "madeira2")
bloco(Fmov, "MeiaParedeTopo", 10.4, 0.4, 1.6, 129, P0 + 3.2, 50, "madeiraEsc")
bloco(Fmov, "Coluna", 1.4, H, 1.4, 123.3, P0 + H / 2, 50, "madeiraEsc")

-- mesa comprida com banquinhos
do
	local m = Instance.new("Model")
	m.Name = "MesaComprida"
	m.Parent = Fmov
	bloco(m, "Tampo", 14, 0.4, 3.4, 96, P0 + 2.6, 55, "madeiraClara")
	for _, x in ipairs({ 90, 102 }) do
		bloco(m, "Cavalete", 0.5, 2.4, 3, x, P0 + 1.2, 55, "madeira2")
	end
	for _, x in ipairs({ 90.5, 93.5, 96.5, 99.5, 102.5 }) do
		bloco(m, "Banquinho", 1.3, 0.3, 1.3, x, P0 + 1.6, 52.4, "madeira")
		bloco(m, "BanquinhoPe", 0.35, 1.45, 0.35, x, P0 + 0.72, 52.4, "madeira2")
	end
	caneca(m, 92, P0 + 2.8, 55.4)
	caneca(m, 99, P0 + 2.8, 54.7)
	bloco(m, "Travessa", 1.6, 0.15, 1.2, 96, P0 + 2.88, 55, "carta")
	bloco(m, "Assado", 1.0, 0.5, 0.7, 96, P0 + 3.2, 55, "pao")
	vela(m, 101, P0 + 2.8, 55.2, true)
end

-- mesas da parte de baixo
mesaQuadrada(104, 63, { "N", "S", "L", "O" })
mesaQuadrada(117, 63, { "N", "L", "O" })
mesaQuadrada(106, 76, { "N", "L", "O" })
mesaQuadrada(121, 76, { "N", "S", "L" })
mesaQuadrada(130, 60, { "O" })
mesaQuadrada(130, 68.5, { "O" })

-- barris e caixotes pelas paredes
barril(87.5, 24.5) barril(87.5, 27) barril(88.2, 25.7, false, P0 + 2.2)
barril(133, 50.5) barril(133, 53) barril(132.6, 80, true) barril(132.6, 82.3, true)
barril(87.5, 45, true) barril(130, 84)
caixote(128, 84.5, 1.6) caixote(126.3, 84.8, 1.2) caixote(128, 84.5, 1.1, P0 + 1.6)
for _, p in ipairs({ { 88.5, 39 }, { 89.6, 40.2 } }) do
	bloco(Fmov, "Saco", 1.3, 1.1, 1.0, p[1], P0 + 0.55, p[2], "palha")
end

-- tapete da entrada e lustre
bloco(Fint, "Tapete", 8, 0.1, 9, 110, P0 + 0.05, 80, "tapete").CanCollide = false
bloco(Fint, "TapeteBorda", 8.6, 0.08, 9.6, 110, P0 + 0.03, 80, "tapete2").CanCollide = false
do
	local m = Instance.new("Model")
	m.Name = "Lustre"
	m.Parent = Fint
	local cx, cy, cz = 112, P0 + 12.5, 66
	bloco(m, "Corrente", 0.2, H - 12.5, 0.2, cx, cy + (H - 12.5) / 2, cz, "ferro", "metal")
	for i = 0, 7 do
		local a = i / 8 * 2 * math.pi
		bloco(m, "Aro", 1.6, 0.3, 0.4, cx + math.cos(a) * 2.2, cy, cz + math.sin(a) * 2.2, "madeiraEsc", nil, rotY(-math.deg(a) + 90))
		if i % 2 == 0 then vela(m, cx + math.cos(a) * 2.2, cy + 0.15, cz + math.sin(a) * 2.2, false) end
	end
	local centro = bloco(m, "LuzDoLustre", 0.4, 0.4, 0.4, cx, cy - 0.5, cz, "chama", "neon")
	luz(centro, "chama", 40, 1.4)
	semColisao(m)
end
-- lanternas de parede
for _, p in ipairs({ { 86.6, 40 }, { 133.4, 60 }, { 133.4, 76 }, { 86.6, 52 } }) do
	bloco(Fint, "Suporte", 0.8, 0.3, 0.3, p[1], 9, p[2], "ferro", "metal")
	local l = bloco(Fint, "Lanterna", 0.7, 0.9, 0.7, (p[1] < 110) and p[1] + 0.5 or p[1] - 0.5, 8.4, p[2], "chama", "neon")
	luz(l, "chama", 20, 1)
end

-- salao dos herois: palco na parede oeste com os 5 pedestais das classes
local PALCO = Instance.new("Model")
PALCO.Name = "SalaoDosHerois"
PALCO.Parent = T
bloco(PALCO, "Palco", 8, 0.8, 27, 90, P0 + 0.4, 71.5, "madeiraEsc")
bloco(PALCO, "PalcoBorda", 0.4, 1.0, 27, 94.1, P0 + 0.5, 71.5, "ouro", "metal")
bloco(PALCO, "PalcoDegrau", 1.2, 0.4, 6, 94.8, P0 + 0.2, 71.5, "madeira")
local quadro = bloco(PALCO, "Quadro", 0.4, 2.4, 16, 86.4, 11.5, 71, "madeira2")
placa(quadro, Enum.NormalId.Right, "SALAO DOS HEROIS")
local CLASSES_ORDEM = { "Cavaleiro", "Clerigo", "Arcanista", "Ladino", "Patrulheiro" }
local NOMES_CLASSE = { Cavaleiro = "CAVALEIRO", Clerigo = "CLERIGO", Arcanista = "ARCANISTA", Ladino = "LADINO", Patrulheiro = "PATRULHEIRO" }
local function baseDoPedestal(i)
	return ORIGEM * CFrame.new(90, P0 + 0.8, 61 + (i - 1) * 5) * rotY(-90)
end

local function promptEscolha(parte, nome)
	local p = Instance.new("ProximityPrompt")
	p.Name = "PromptEscolher"
	p.ActionText = "Escolher classe"
	p.ObjectText = NOMES_CLASSE[nome]
	p.KeyboardKeyCode = Enum.KeyCode.F
	p.HoldDuration = 0.6
	p.MaxActivationDistance = 10
	p.RequiresLineOfSight = false
	p.UIOffset = Vector2.new(0, -60)
	p:SetAttribute("EscolherClasse", nome)
	p.Parent = parte
end

local filaClasses = workspace:FindFirstChild("ClassesDePersonagem")
local classesMovidas = 0
if filaClasses then
	-- traz as estatuas animadas para o palco
	for i, nome in ipairs(CLASSES_ORDEM) do
		local modelo = filaClasses:FindFirstChild(nome)
		local ped = filaClasses:FindFirstChild("Pedestal" .. nome)
		if modelo and ped then
			local antigaBase = modelo.WorldPivot * CFrame.new(0, -1, 0)
			local delta = baseDoPedestal(i) * antigaBase:Inverse()
			for _, grupo in ipairs({ modelo, ped }) do
				for _, p in ipairs(grupo:GetDescendants()) do
					if p:IsA("BasePart") then p.CFrame = delta * p.CFrame end
				end
			end
			modelo.WorldPivot = delta * modelo.WorldPivot
			local topo = ped:FindFirstChild("Topo")
			if topo then promptEscolha(topo, nome) end
			classesMovidas = classesMovidas + 1
		end
	end
end
if classesMovidas == 0 then
	-- sem o script das classes: pedestais simples com o nome
	for i, nome in ipairs(CLASSES_ORDEM) do
		local base = baseDoPedestal(i)
		local topo = blocoL(PALCO, "Topo", base, 3.6, 0.5, 3.6, 0, 0.75, 0, "pedra")
		blocoL(PALCO, "Base", base, 4.2, 0.5, 4.2, 0, 0.25, 0, "pedra2")
		blocoL(PALCO, "Placa", base, 2.4, 0.35, 0.08, 0, 0.75, -1.82, "ouro", "metal")
		local gui = Instance.new("BillboardGui")
		gui.Size = UDim2.fromOffset(200, 36)
		gui.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
		gui.Adornee = topo
		local r = Instance.new("TextLabel")
		r.Size = UDim2.fromScale(1, 1)
		r.BackgroundTransparency = 1
		r.Text = NOMES_CLASSE[nome]
		r.TextColor3 = Color3.fromRGB(235, 225, 255)
		r.TextStrokeTransparency = 0
		r.Font = Enum.Font.Arcade
		r.TextScaled = true
		r.Parent = gui
		gui.Parent = topo
		promptEscolha(topo, nome)
	end
end

-- taverneiro atras do balcao e clientes
local taverneiro = morador("Bartolo", ORIGEM * CFrame.new(121, P0, 37.5) * rotY(90), {
	pele = "pele", roupa = "reboco", manga = "reboco2", calca = "madeiraEsc", avental = "tecido3",
	barba = "cabelo2", cabelo = "cabelo2",
})
taverneiro:SetAttribute("Loja", "taverna")
taverneiro:SetAttribute("Fala", "Uma pocao antes da Toca? A casa recomenda.")
morador("ClienteDoBalcao", ORIGEM * CFrame.new(111.5, P0 + 1.4, 37) * rotY(-90), {
	pele = "pele3", roupa = "tecido2", calca = "madeira2", chapeu = "madeiraEsc",
}, true)
morador("ClienteJogador", CFrame.lookAt(W(114, P0, 63), W(117, P0, 63)), {
	pele = "pele2", roupa = "tecido", calca = "madeiraEsc", capuz = "tecido3", barba = "cabelo",
}, true)
morador("ClienteVelho", CFrame.lookAt(W(121, P0, 73.2), W(121, P0, 76)), {
	pele = "pele", roupa = "madeira2", calca = "madeiraEsc", cabelo = "cabelo3", barba = "cabelo3",
}, true)

-- ===================== CASAS (so fachada) =====================
-- casa em coordenadas locais: porta virada para -Z
local function telhado(m, base, w, d, h, cor1, cor2)
	local passos = math.floor(w / 2 / 1.2)
	for i = 0, passos do
		local largura = w + 2 - i * 2.4
		if largura <= 0.8 then break end
		blocoL(m, "Telhado", base, largura, 1.2, d + 2, 0, h + 0.6 + i * 1.2, 0, (i % 2 == 0) and cor1 or cor2)
	end
	blocoL(m, "TelhadoCumeeira", base, 0.8, 0.6, d + 2.4, 0, h + 0.6 + (passos + 0.5) * 1.2, 0, cor2)
end

local function janela(m, base, x, y, z, normalX)
	if normalX then
		blocoL(m, "Janela", base, 0.2, 1.8, 1.6, x, y, z, "vidro", "neon", nil, 0.15)
		blocoL(m, "Moldura", base, 0.3, 2.2, 0.25, x, y, z, "madeiraEsc")
		blocoL(m, "Moldura", base, 0.3, 0.25, 2.0, x, y, z, "madeiraEsc")
	else
		blocoL(m, "Janela", base, 1.6, 1.8, 0.2, x, y, z, "vidro", "neon", nil, 0.15)
		blocoL(m, "Moldura", base, 0.25, 2.2, 0.3, x, y, z, "madeiraEsc")
		blocoL(m, "Moldura", base, 2.0, 0.25, 0.3, x, y, z, "madeiraEsc")
	end
end

local function casa(nome, x, z, w, d, h, giro, estilo)
	local m = Instance.new("Model")
	m.Name = nome
	m.Parent = Fcasas
	local base = ORIGEM * CFrame.new(x, 0, z) * rotY(giro)
	local parede = estilo.parede or "reboco"
	blocoL(m, "Base", base, w + 0.6, 0.8, d + 0.6, 0, 0.4, 0, "pedra2")
	blocoL(m, "Paredes", base, w, h, d, 0, h / 2 + 0.8, 0, parede)
	-- vigas de madeira nos cantos e no meio
	for _, cx in ipairs({ -w / 2, w / 2 }) do
		for _, cz in ipairs({ -d / 2, d / 2 }) do
			blocoL(m, "Viga", base, 0.7, h, 0.7, cx, h / 2 + 0.8, cz, "madeiraEsc")
		end
	end
	blocoL(m, "VigaFaixa", base, w + 0.3, 0.5, d + 0.3, 0, h * 0.55 + 0.8, 0, "madeiraEsc")
	blocoL(m, "VigaTopo", base, w + 0.3, 0.5, d + 0.3, 0, h + 0.6, 0, "madeiraEsc")
	-- porta
	blocoL(m, "Porta", base, 2.6, 4.4, 0.3, 0, 3.0, -d / 2 - 0.1, "madeira2")
	blocoL(m, "Macaneta", base, 0.2, 0.2, 0.2, 0.9, 3.0, -d / 2 - 0.3, "ouro", "metal")
	blocoL(m, "PortaTopo", base, 3.2, 0.4, 0.4, 0, 5.3, -d / 2 - 0.1, "madeiraEsc")
	-- janelas
	for _, jx in ipairs({ -w / 2 + 2.6, w / 2 - 2.6 }) do
		janela(m, base, jx, h * 0.55 + 0.8 - 1.8, -d / 2 - 0.1, false)
		janela(m, base, jx, h * 0.55 + 0.8 + 2.0, -d / 2 - 0.1, false)
		janela(m, base, jx, h * 0.55 + 0.8 + 2.0, d / 2 + 0.1, false)
	end
	for _, jz in ipairs({ -d / 4, d / 4 }) do
		janela(m, base, -w / 2 - 0.1, h * 0.55 + 0.8 + 2.0, jz, true)
		janela(m, base, w / 2 + 0.1, h * 0.55 + 0.8 + 2.0, jz, true)
	end
	telhado(m, base, w, d, h + 0.8, estilo.telhado or "telhado", estilo.telhado2 or "telhado2")
	if estilo.chamine then
		blocoL(m, "Chamine", base, 2, h * 0.7 + 3, 2, w / 2 - 2.5, h + 0.8 + (h * 0.7 + 3) / 2 - 1, d / 4, "pedra2")
		blocoL(m, "ChamineTopo", base, 2.4, 0.5, 2.4, w / 2 - 2.5, h + 0.8 + h * 0.7 + 2.2, d / 4, "pedraEsc")
	end
	-- degrau e lanterna da porta
	blocoL(m, "Degrau", base, 3.4, 0.4, 1.2, 0, 0.2, -d / 2 - 0.8, "pedra")
	local lant = blocoL(m, "Lanterna", base, 0.5, 0.7, 0.5, 2.0, 5.0, -d / 2 - 0.5, "chama", "neon")
	luz(lant, "chama", 14, 0.9)
	local cos, sin = math.abs(math.cos(math.rad(giro))), math.abs(math.sin(math.rad(giro)))
	local ex, ez = (w * cos + d * sin) / 2, (w * sin + d * cos) / 2
	ocupar(x - ex - 1, z - ez - 1, x + ex + 1, z + ez + 1)
	return m, base
end

casa("CasaDoMoleiro", 30, 30, 18, 14, 9, 0, { chamine = true })
casa("CasaDaCurandeira", 62, 40, 14, 12, 8, 0, { parede = "reboco2", telhado = "ardosia", telhado2 = "ardosia2" })
casa("SalaoDosMercadores", 162, 30, 22, 16, 10, 0, { chamine = true })
casa("CasaDoPescador", 165, 66, 16, 14, 9, 90, { parede = "reboco2" })
casa("CasaDoEscriba", 150, 82, 12, 12, 8, 0, { telhado = "ardosia", telhado2 = "ardosia2" })
casa("Celeiro", 30, 150, 18, 16, 9, 90, { parede = "madeira", telhado = "telhado2", telhado2 = "telhado" })
casa("CasaDaPadeira", 66, 150, 18, 14, 9, 0, { chamine = true, telhado = "ardosia", telhado2 = "ardosia2" })
casa("CasaDoBarqueiro", 150, 145, 16, 12, 8, 180, { parede = "reboco2", chamine = true })
casa("CasaDoLenhador", 30, 85, 12, 12, 8, 90, { parede = "madeira" })

-- ===================== FORJA DA ILDA =====================
-- predio x 50..80, z 70..96, com a forja aberta na frente (z 96..103)
local forjaBase = ORIGEM * CFrame.new(65, 0, 83) * rotY(180)
do
	local m = Instance.new("Model")
	m.Name = "Predio"
	m.Parent = Fforja
	local w, d, h = 30, 26, 10
	blocoL(m, "Base", forjaBase, w + 0.6, 0.8, d + 0.6, 0, 0.4, 0, "pedra2")
	blocoL(m, "Paredes", forjaBase, w, h, d, 0, h / 2 + 0.8, 0, "pedra")
	for _, cx in ipairs({ -w / 2, w / 2 }) do
		for _, cz in ipairs({ -d / 2, d / 2 }) do
			blocoL(m, "Pilar", forjaBase, 1.2, h, 1.2, cx, h / 2 + 0.8, cz, "pedraEsc")
		end
	end
	blocoL(m, "Faixa", forjaBase, w + 0.4, 0.6, d + 0.4, 0, h + 0.5, 0, "pedraEsc")
	telhado(m, forjaBase, w, d, h + 0.8, "ardosia", "ardosia2")
	blocoL(m, "Chamine", forjaBase, 3, 18, 3, -9, 10, 9, "pedraEsc")
	local brasaChamine = blocoL(m, "BrasaChamine", forjaBase, 2, 0.4, 2, -9, 19.1, 9, "brasa", "neon")
	local fumaca = Instance.new("Smoke")
	fumaca.Color = Color3.fromRGB(70, 66, 70)
	fumaca.Size = 4
	fumaca.RiseVelocity = 3
	fumaca.Opacity = 0.15
	fumaca.Parent = brasaChamine
	blocoL(m, "Porta", forjaBase, 3, 4.6, 0.3, 8, 3.1, -d / 2 - 0.1, "madeiraEsc")
	janela(m, forjaBase, -8, 6.5, -d / 2 - 0.1, false)
	ocupar(48, 68, 82, 104)
end
-- alpendre da forja (lado da rua, z 96..103)
do
	local m = Instance.new("Model")
	m.Name = "Alpendre"
	m.Parent = Fforja
	bloco(m, "Piso", 30, 0.6, 7, 65, 0.3, 99.5, "pedra2")
	for _, x in ipairs({ 51, 65, 79 }) do
		bloco(m, "Poste", 0.8, 8, 0.8, x, 4.6, 102.6, "madeiraEsc")
	end
	for i = 0, 2 do
		bloco(m, "Cobertura", 31, 0.5, 2.6, 65, 8.8 + i * 0.4, 101.8 - i * 2.4, (i % 2 == 0) and "ardosia" or "ardosia2")
	end
	-- forja de pedra com brasas
	bloco(m, "Forja", 6, 3.2, 4, 56, 2.2, 98.5, "pedraEsc")
	bloco(m, "ForjaBorda", 6.4, 0.5, 4.4, 56, 3.9, 98.5, "pedra2")
	local brasas = bloco(m, "Brasas", 4.6, 0.3, 2.6, 56, 4.2, 98.5, "brasa", "neon")
	fogo(brasas, 4)
	luz(brasas, "fogo", 24, 2)
	bloco(m, "Fole", 2.2, 1.2, 1.6, 52.2, 3.0, 98.5, "madeira2")
	bloco(m, "FoleCouro", 1.6, 1.4, 1.2, 50.8, 3.0, 98.5, "tecido")
	-- bigorna
	bloco(m, "BigornaBase", 1.4, 1.6, 1.2, 63, 1.4, 99.5, "madeiraEsc")
	bloco(m, "BigornaCorpo", 1.0, 0.8, 0.9, 63, 2.6, 99.5, "ferro", "metal")
	bloco(m, "BigornaTopo", 2.6, 0.5, 1.0, 63.3, 3.2, 99.5, "ferro", "metal")
	bloco(m, "BigornaPonta", 0.8, 0.35, 0.6, 61.6, 3.25, 99.5, "ferro", "metal")
	bloco(m, "Martelo", 0.25, 0.25, 1.2, 63.8, 3.6, 99.3, "madeira")
	bloco(m, "MarteloCabeca", 0.5, 0.5, 0.5, 63.8, 3.6, 98.7, "aco", "metal")
	-- balde de tempera
	bloco(m, "Balde", 1.6, 1.4, 1.6, 66, 1.3, 98.2, "madeira2")
	bloco(m, "AguaBalde", 1.3, 0.1, 1.3, 66, 1.95, 98.2, "agua")
	-- prateleira de armas
	bloco(m, "Expositor", 7, 0.5, 1.2, 74, 5.2, 96.9, "madeira")
	bloco(m, "Expositor2", 7, 0.5, 1.2, 74, 2.6, 96.9, "madeira")
	for i = 0, 3 do
		local x = 71.2 + i * 1.9
		bloco(m, "Lamina", 0.3, 3.0, 0.12, x, 4.0, 96.6, "lamina", "metal")
		bloco(m, "Guarda", 0.9, 0.2, 0.25, x, 2.5, 96.6, "aco", "metal")
		bloco(m, "Cabo", 0.25, 0.9, 0.25, x, 1.9, 96.6, "madeiraEsc")
	end
	bloco(m, "Escudo", 0.3, 2.2, 2.2, 79, 5.8, 98, "tecido2")
	bloco(m, "EscudoBorda", 0.32, 2.5, 0.4, 79, 5.8, 98, "ferro", "metal")
	bloco(m, "EscudoBorda", 0.32, 0.4, 2.5, 79, 5.8, 98, "ferro", "metal")
	-- balcao de venda
	bloco(m, "Balcao", 6, 2.4, 1.6, 69, 1.8, 101.8, "madeira")
	bloco(m, "BalcaoTampo", 6.3, 0.3, 1.9, 69, 3.1, 101.8, "madeiraClara")
	local tabuletaForja = bloco(m, "Tabuleta", 6, 1.6, 0.3, 65, 7.2, 103.2, "madeira2")
	placa(tabuletaForja, Enum.NormalId.Back, "FORJA DA ILDA")
	placa(tabuletaForja, Enum.NormalId.Front, "FORJA DA ILDA")
end
local ferreira = morador("Ilda", ORIGEM * CFrame.new(69, 0.6, 99.8) * rotY(180), {
	pele = "pele2", roupa = "tecido2", manga = "pele2", calca = "madeiraEsc", avental = "madeiraEsc",
	cabelo = "cabelo", capuz = "tecido",
})
ferreira:SetAttribute("Loja", "ferraria")
ferreira:SetAttribute("Fala", "Aco bom nao e barato, aventureiro.")

-- ===================== NATUREZA =====================
local function arvore(x, z, porte)
	local m = Instance.new("Model")
	m.Name = "Arvore"
	m.Parent = Fnatureza
	local h = 4 + porte * 2
	bloco(m, "Tronco", 1.2 + porte * 0.3, h, 1.2 + porte * 0.3, x, h / 2, z, "tronco")
	local tons = { "folha", "folha2", "folha3" }
	local s = 5 + porte * 1.6
	bloco(m, "Copa", s, s * 0.7, s, x, h + s * 0.25, z, tons[(math.floor(x + z) % 3) + 1])
	bloco(m, "Copa", s * 0.75, s * 0.55, s * 0.75, x + entre(-0.6, 0.6), h + s * 0.75, z + entre(-0.6, 0.6), tons[(math.floor(x) % 3) + 1])
	bloco(m, "Copa", s * 0.45, s * 0.4, s * 0.45, x, h + s * 1.1, z, "folha2")
	for _ = 1, 3 do
		bloco(m, "Folhagem", s * 0.35, s * 0.3, s * 0.35, x + entre(-s * 0.5, s * 0.5), h + entre(0, s * 0.5), z + entre(-s * 0.5, s * 0.5), tons[math.floor(rnd() * 3) + 1])
	end
end
local arvores = 0
for gx = 0, 23 do
	for gz = 0, 20 do
		local x, z = 4 + gx * 9 + entre(-3, 3), 4 + gz * 9 + entre(-3, 3)
		local borda = (x < 16 or x > 176 or z < 16 or z > 172)
		local chance = borda and 0.75 or 0.12
		if rnd() < chance and livre(x, z, 4) and x > 2 and x < 186 and z > 2 then
			arvore(x, z, math.floor(rnd() * 3))
			ocupar(x - 3, z - 3, x + 3, z + 3)
			arvores = arvores + 1
		end
	end
end
-- arbustos e flores
for _ = 1, 50 do
	local x, z = entre(6, 184), entre(6, 182)
	if livre(x, z, 1.5) then
		local s = entre(1.2, 2.4)
		local p = bloco(Fnatureza, "Arbusto", s, s * 0.7, s, x, s * 0.35, z, (rnd() < 0.5) and "folha" or "folha3")
		p.CanCollide = false
		if rnd() < 0.5 then
			local f = bloco(Fnatureza, "Flor", 0.4, 0.4, 0.4, x + 0.3, s * 0.7 + 0.1, z, (rnd() < 0.5) and "maca" or "tecido3")
			f.CanCollide = false
		end
	end
end

-- ===================== DETALHES =====================
local function poste(x, z)
	bloco(Fdetalhes, "Poste", 0.6, 7, 0.6, x, 3.5, z, "madeiraEsc")
	bloco(Fdetalhes, "PosteBraco", 1.8, 0.4, 0.4, x + 0.7, 7.0, z, "madeiraEsc")
	bloco(Fdetalhes, "LanternaCaixa", 0.9, 1.1, 0.9, x + 1.4, 6.2, z, "ferro", "metal")
	local c = bloco(Fdetalhes, "LanternaLuz", 0.6, 0.7, 0.6, x + 1.4, 6.2, z, "chama", "neon")
	luz(c, "chama", 22, 1.1)
end
for _, p in ipairs({ {30, 102}, {64, 118}, {86, 102}, {134, 102}, {160, 118}, {102, 150}, {118, 172}, {88, 88}, {132, 88}, {88, 132}, {132, 132} }) do
	poste(p[1], p[2])
end

-- poco
do
	local m = Instance.new("Model")
	m.Name = "Poco"
	m.Parent = Fdetalhes
	local x, z = 34, 124
	bloco(m, "Borda", 5, 2.4, 5, x, 1.2, z, "pedra")
	bloco(m, "Agua", 3.6, 0.2, 3.6, x, 2.25, z, "aguaFunda")
	bloco(m, "PosteE", 0.5, 4, 0.5, x - 2.2, 4.4, z, "madeiraEsc")
	bloco(m, "PosteD", 0.5, 4, 0.5, x + 2.2, 4.4, z, "madeiraEsc")
	bloco(m, "Eixo", 4.8, 0.4, 0.4, x, 5.6, z, "madeira")
	bloco(m, "TelhadoPoco", 6, 0.5, 4, x, 6.8, z, "telhado")
	bloco(m, "Balde", 0.9, 0.9, 0.9, x, 4.0, z, "madeira2")
	ocupar(x - 3, z - 3, x + 3, z + 3)
end

-- cais com barco
do
	local m = Instance.new("Model")
	m.Name = "Cais"
	m.Parent = Fdetalhes
	for i = 0, 9 do
		bloco(m, "Tabua", 12, 0.4, 1.9, 110, 0.4, 187 + i * 2, (i % 2 == 0) and "tabua" or "tabua2")
	end
	for _, x in ipairs({ 104.5, 115.5 }) do
		for _, z in ipairs({ 190, 198, 205 }) do
			bloco(m, "Estaca", 0.8, 5, 0.8, x, -1, z, "madeiraEsc")
		end
	end
	local barco = ORIGEM * CFrame.new(122, -0.6, 200)
	blocoL(m, "Casco", barco, 3.6, 1.4, 9, 0, 0, 0, "madeira2")
	blocoL(m, "CascoProa", barco, 2.4, 1.4, 1.6, 0, 0, -5.2, "madeira2")
	blocoL(m, "Borda", barco, 3.9, 0.3, 9.2, 0, 0.75, 0, "madeiraEsc")
	blocoL(m, "Banco", barco, 3.4, 0.25, 0.8, 0, 0.5, 1.5, "madeira")
	blocoL(m, "Remo", barco, 0.2, 0.2, 5, 1.6, 0.9, 0.5, "madeira", nil, CFrame.Angles(0, math.rad(15), 0))
	for _, x in ipairs({ 107, 113 }) do
		bloco(m, "Barril", 1.4, 1.8, 1.4, x, 1.5, 200, "madeira")
	end
end

-- carroca, caixotes e feno
do
	local m = Instance.new("Model")
	m.Name = "Carroca"
	m.Parent = Fdetalhes
	local base = ORIGEM * CFrame.new(140, 0, 122) * rotY(20)
	blocoL(m, "Caixa", base, 4, 1.6, 6, 0, 2.2, 0, "madeira")
	blocoL(m, "Feno", base, 3.6, 1.2, 5.4, 0, 3.4, 0, "palha")
	for _, p in ipairs({ { -2.2, -1.8 }, { 2.2, -1.8 }, { -2.2, 1.8 }, { 2.2, 1.8 } }) do
		blocoL(m, "Roda", base, 0.4, 2, 2, p[1], 1.0, p[2], "madeiraEsc")
	end
	blocoL(m, "Cabo", base, 0.3, 0.3, 4, 0, 1.4, -5, "madeira2")
	ocupar(134, 115, 146, 129)
end
for _, p in ipairs({ {84, 96, 0}, {85.5, 97.5, 1}, {136, 96, 0}, {48, 106, 0}, {82, 104, 1} }) do
	local s = (p[3] == 1) and 1.2 or 1.6
	bloco(Fdetalhes, "Caixote", s, s, s, p[1], s / 2, p[2], "madeira2")
end

-- cercas dos quintais
local function cerca(x1, z1, x2, z2)
	local d = W(x2, 0, z2) - W(x1, 0, z1)
	local n = math.floor(d.Magnitude / 2)
	for i = 0, n do
		local t = i / n
		bloco(Fdetalhes, "Estaca", 0.4, 2, 0.4, x1 + (x2 - x1) * t, 1, z1 + (z2 - z1) * t, "madeira2")
	end
	local a, b = W(x1, 1.4, z1), W(x2, 1.4, z2)
	novoPart(Fdetalhes, "Travessa", Vector3.new(0.25, 0.25, (b - a).Magnitude), CFrame.lookAt((a + b) / 2, b), "madeira")
	local a2, b2 = W(x1, 0.7, z1), W(x2, 0.7, z2)
	novoPart(Fdetalhes, "Travessa", Vector3.new(0.25, 0.25, (b2 - a2).Magnitude), CFrame.lookAt((a2 + b2) / 2, b2), "madeira")
end
cerca(18, 160, 42, 160)
cerca(18, 160, 18, 140)
cerca(54, 160, 78, 160)
cerca(140, 154, 162, 154)
cerca(20, 42, 42, 42)

-- guarda da vila perto do portal
morador("GuardaDaVila", ORIGEM * CFrame.new(121, 0, 104) * rotY(180), {
	pele = "pele", roupa = "tecido", calca = "madeiraEsc", colete = "ferro", elmo = true, barba = "cabelo",
}):SetAttribute("Fala", "O portal leva para a Toca. Va preparado.")

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
-- Uso de armas, pocoes e tocha (design: Yuri Ramos Hernandez)
-- Le os atributos da ferramenta: Tipo, Dano, Alcance, Recarga, Cura, CuraGolpe, Cor.
local tool = script.Parent
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ultimo = 0

local function brilho(cf, tam, cor, tempo, destino)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.Material = Enum.Material.Neon
	p.Color = cor
	p.Size = tam
	p.CFrame = cf
	p.Parent = workspace
	local props = { Transparency = 1 }
	if destino then props.CFrame = destino end
	TweenService:Create(p, TweenInfo.new(tempo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	Debris:AddItem(p, tempo + 0.1)
	return p
end

local function aranhasVivas()
	local lista = {}
	local toca = workspace:FindFirstChild("TocaDaTecelaFaminta")
	local pers = toca and toca:FindFirstChild("Personagens")
	if pers then
		for _, m in ipairs(pers:GetChildren()) do
			if m:IsA("Model") and m:GetAttribute("Aranha") and (m:GetAttribute("Vida") or 0) > 0 then
				table.insert(lista, m)
			end
		end
	end
	return lista
end

local function ferir(aranha, dano, jogador)
	-- a Tecela so pode ser ferida depois de despertar
	if aranha:GetAttribute("Chefe") and not aranha:GetAttribute("Desperta") then return end
	aranha:SetAttribute("UltimoAtacante", jogador.UserId)
	aranha:SetAttribute("Vida", (aranha:GetAttribute("Vida") or 0) - dano)
end

tool.Activated:Connect(function()
	local personagem = tool.Parent
	local jogador = Players:GetPlayerFromCharacter(personagem)
	local hum = personagem and personagem:FindFirstChildOfClass("Humanoid")
	local hrp = personagem and personagem:FindFirstChild("HumanoidRootPart")
	if not (jogador and hum and hrp) or hum.Health <= 0 then return end
	if os.clock() - ultimo < (tool:GetAttribute("Recarga") or 0.6) then return end
	ultimo = os.clock()

	local tipo = tool:GetAttribute("Tipo")
	local cor = tool:GetAttribute("Cor") or Color3.new(1, 1, 1)

	if tipo == "pocao" then
		hum.Health = math.min(hum.MaxHealth, hum.Health + (tool:GetAttribute("Cura") or 40))
		for i = 1, 10 do
			local a = i / 10 * 2 * math.pi
			local de = hrp.CFrame * CFrame.new(math.cos(a) * 1.6, -2, math.sin(a) * 1.6)
			brilho(de, Vector3.new(0.3, 0.3, 0.3), cor, 0.8, de + Vector3.new(0, 4, 0))
		end
		tool:Destroy()
		return
	elseif tipo == "tocha" then
		return
	end

	local dano = tool:GetAttribute("Dano") or 5
	local alcance = tool:GetAttribute("Alcance") or 6
	local frente = hrp.CFrame.LookVector
	local planoFrente = Vector3.new(frente.X, 0, frente.Z).Unit

	if tipo == "corpo" then
		-- arco de corte na frente do jogador
		for i = 0, 6 do
			local a = math.rad(-60 + i * 20)
			brilho(hrp.CFrame * CFrame.Angles(0, a, 0) * CFrame.new(0, 0.3, -3.2), Vector3.new(0.25, 0.25, 1.3), cor, 0.25)
		end
		for _, m in ipairs(aranhasVivas()) do
			local cf, tam = m:GetBoundingBox()
			local d = cf.Position - hrp.Position
			local plano = Vector3.new(d.X, 0, d.Z)
			local raio = math.max(tam.X, tam.Z) * 0.35
			local naFrente = plano.Magnitude < 1 or plano.Unit:Dot(planoFrente) > 0.3
			if plano.Magnitude - raio <= alcance and naFrente and math.abs(d.Y) < 14 then
				ferir(m, dano, jogador)
				brilho(CFrame.new(cf.Position), Vector3.new(0.8, 0.8, 0.8), Color3.fromRGB(255, 80, 90), 0.3)
			end
		end
		local cg = tool:GetAttribute("CuraGolpe")
		if cg then hum.Health = math.min(hum.MaxHealth, hum.Health + cg) end
	elseif tipo == "distancia" then
		-- mira automatica: a aranha mais proxima dentro de um cone a frente
		local origem = hrp.Position + Vector3.new(0, 1.2, 0)
		local alvo, melhor = nil, math.huge
		for _, m in ipairs(aranhasVivas()) do
			local cf = m:GetBoundingBox()
			local d = cf.Position - origem
			local plano = Vector3.new(d.X, 0, d.Z)
			if d.Magnitude <= alcance and plano.Magnitude > 0.1 and plano.Unit:Dot(planoFrente) > 0.85 and d.Magnitude < melhor then
				alvo, melhor = m, d.Magnitude
			end
		end
		local fim = alvo and alvo:GetBoundingBox().Position or (origem + frente * alcance)
		local tempo = math.clamp((fim - origem).Magnitude / 90, 0.08, 0.6)
		local comprido = tool:GetAttribute("Magica") and 0.7 or 2.2
		local tiro = brilho(CFrame.lookAt(origem, fim), Vector3.new(0.35, 0.35, comprido), cor, tempo, CFrame.lookAt(fim, fim + (fim - origem).Unit))
		tiro.Transparency = 0
		task.delay(tempo, function()
			if alvo then
				ferir(alvo, dano, jogador)
				for i = 1, 6 do
					local a = i / 6 * 2 * math.pi
					brilho(CFrame.new(fim), Vector3.new(0.3, 0.3, 0.3), cor, 0.35, CFrame.new(fim + Vector3.new(math.cos(a) * 2, math.random() * 2, math.sin(a) * 2)))
				end
			end
		end)
	end
end)
]==]
uso.Parent = modelos
modelos.Parent = ServerStorage

local sistema = Instance.new("Script")
sistema.Name = "SistemaDoLobby"
sistema.Source = [==[
-- Vila Pedra-Musgo: moedas, classes, lojas, portais e recompensas (design: Yuri Ramos Hernandez)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local raiz = script.Parent
local remotos = ReplicatedStorage:WaitForChild("LobbyRemotos")
local AbrirLoja, ComprarItem, Aviso = remotos.AbrirLoja, remotos.ComprarItem, remotos.Aviso
local modelos = ServerStorage:WaitForChild("LobbyModelos")

local MOEDAS_INICIAIS = 50
local RECOMPENSA_CRIA, RECOMPENSA_CHEFE = 10, 150

-- ================= ITENS =================
local ITENS = {
	pocao        = { nome = "Pocao de Vida", desc = "Recupera 40 de vida.", preco = 15, tipo = "pocao", cura = 40, cor = {220, 50, 70} },
	pocaoGrande  = { nome = "Pocao Grande", desc = "Recupera 100 de vida.", preco = 35, tipo = "pocao", cura = 100, cor = {240, 90, 120} },
	tocha        = { nome = "Tocha", desc = "Ilumina o tunel escuro e queima as teias violeta.", preco = 10, tipo = "tocha", cor = {255, 150, 50} },
	espadaLonga  = { nome = "Espada Longa", desc = "Corpo a corpo: 18 de dano.", preco = 60, tipo = "corpo", dano = 18, alcance = 8, recarga = 0.7, cor = {196, 202, 214} },
	macaSagrada  = { nome = "Maca Sagrada", desc = "Corpo a corpo: 14 de dano e cura 5 a cada golpe.", preco = 65, tipo = "corpo", dano = 14, alcance = 7, recarga = 0.75, curaGolpe = 5, cor = {255, 210, 90} },
	adagasGemeas = { nome = "Adagas Gemeas", desc = "Corpo a corpo rapido: 9 de dano.", preco = 55, tipo = "corpo", dano = 9, alcance = 6, recarga = 0.35, cor = {200, 230, 220} },
	arcoLongo    = { nome = "Arco Longo", desc = "Distancia: 14 de dano ate 70 studs.", preco = 70, tipo = "distancia", dano = 14, alcance = 70, recarga = 0.9, cor = {240, 236, 226} },
	cajadoArcano = { nome = "Cajado Arcano", desc = "Magia a distancia: 16 de dano. Corta teias violeta.", preco = 80, tipo = "distancia", dano = 16, alcance = 50, recarga = 1.0, magica = true, cor = {180, 110, 255} },
	-- armas iniciais das classes
	espadaCurta    = { nome = "Espada Curta", desc = "Arma inicial do Cavaleiro.", preco = 0, tipo = "corpo", dano = 10, alcance = 7, recarga = 0.7, cor = {196, 202, 214}, visual = "espadaLonga" },
	macaFerro      = { nome = "Maca de Ferro", desc = "Arma inicial do Clerigo.", preco = 0, tipo = "corpo", dano = 9, alcance = 6.5, recarga = 0.75, curaGolpe = 3, cor = {170, 170, 180}, visual = "macaSagrada" },
	cajadoAprendiz = { nome = "Cajado de Aprendiz", desc = "Arma inicial do Arcanista.", preco = 0, tipo = "distancia", dano = 9, alcance = 40, recarga = 1.0, magica = true, cor = {160, 90, 255}, visual = "cajadoArcano" },
	adagasCouro    = { nome = "Adagas de Couro", desc = "Arma inicial do Ladino.", preco = 0, tipo = "corpo", dano = 6, alcance = 5.5, recarga = 0.35, cor = {200, 230, 220}, visual = "adagasGemeas" },
	arcoCurto      = { nome = "Arco Curto", desc = "Arma inicial do Patrulheiro.", preco = 0, tipo = "distancia", dano = 8, alcance = 50, recarga = 0.9, cor = {240, 236, 226}, visual = "arcoLongo" },
}
local LOJAS = {
	taverna  = { titulo = "Taverna do Caneco Torto", itens = { "pocao", "pocaoGrande", "tocha" } },
	ferraria = { titulo = "Forja da Ilda", itens = { "espadaLonga", "macaSagrada", "adagasGemeas", "arcoLongo", "cajadoArcano", "tocha" } },
}
local CLASSES = {
	Cavaleiro   = { vida = 140, inicial = { "espadaCurta" } },
	Clerigo     = { vida = 120, inicial = { "macaFerro", "pocao" } },
	Arcanista   = { vida = 90, inicial = { "cajadoAprendiz" } },
	Ladino      = { vida = 100, inicial = { "adagasCouro" } },
	Patrulheiro = { vida = 100, inicial = { "arcoCurto" } },
}

-- ================= FERRAMENTAS =================
local function c3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

local function peca(tool, nome, tam, offset, cor, neon)
	local p = Instance.new("Part")
	p.Name = nome
	p.Size = tam
	p.Color = cor
	p.Material = neon and Enum.Material.Neon or Enum.Material.SmoothPlastic
	p.CanCollide = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	local handle = tool:FindFirstChild("Handle")
	if handle then
		p.CFrame = handle.CFrame * offset
		local w = Instance.new("WeldConstraint")
		w.Part0, w.Part1 = handle, p
		w.Parent = p
	else
		p.CFrame = offset
	end
	p.Parent = tool
	return p
end

local MADEIRA, ESCURO, ACO = Color3.fromRGB(110, 75, 45), Color3.fromRGB(52, 38, 32), Color3.fromRGB(150, 154, 166)
local VISUAIS = {
	espadaLonga = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.3, 1.2, 0.3), CFrame.new(), ESCURO)
		peca(tool, "Pomo", Vector3.new(0.4, 0.4, 0.4), CFrame.new(0, -0.7, 0), ACO)
		peca(tool, "Guarda", Vector3.new(1.3, 0.25, 0.35), CFrame.new(0, 0.7, 0), ACO)
		peca(tool, "Lamina", Vector3.new(0.35, 3.4, 0.12), CFrame.new(0, 2.5, 0), cor)
		return h
	end,
	macaSagrada = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.3, 2.2, 0.3), CFrame.new(), MADEIRA)
		peca(tool, "Cabeca", Vector3.new(0.8, 0.8, 0.8), CFrame.new(0, 1.4, 0), ACO)
		peca(tool, "Flange", Vector3.new(1.1, 0.5, 0.22), CFrame.new(0, 1.4, 0) * CFrame.Angles(0, math.rad(45), 0), ACO)
		peca(tool, "Flange", Vector3.new(1.1, 0.5, 0.22), CFrame.new(0, 1.4, 0) * CFrame.Angles(0, math.rad(-45), 0), ACO)
		peca(tool, "Ponta", Vector3.new(0.3, 0.3, 0.3), CFrame.new(0, 1.95, 0), cor, true)
		return h
	end,
	adagasGemeas = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.25, 0.8, 0.25), CFrame.new(), ESCURO)
		peca(tool, "Guarda", Vector3.new(0.6, 0.15, 0.25), CFrame.new(0, 0.45, 0), ACO)
		peca(tool, "Lamina", Vector3.new(0.14, 1.3, 0.3), CFrame.new(0, 1.15, 0), cor)
		return h
	end,
	arcoLongo = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.3, 0.8, 0.3), CFrame.new(), ESCURO)
		peca(tool, "BracoCima", Vector3.new(0.22, 1.8, 0.22), CFrame.new(0, 1.3, -0.15) * CFrame.Angles(math.rad(-12), 0, 0), MADEIRA)
		peca(tool, "BracoBaixo", Vector3.new(0.22, 1.8, 0.22), CFrame.new(0, -1.3, -0.15) * CFrame.Angles(math.rad(12), 0, 0), MADEIRA)
		peca(tool, "Corda", Vector3.new(0.05, 4.2, 0.05), CFrame.new(0, 0, 0.25), cor)
		return h
	end,
	cajadoArcano = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.3, 1.2, 0.3), CFrame.new(), ESCURO)
		peca(tool, "Haste", Vector3.new(0.28, 4.4, 0.28), CFrame.new(0, 0.8, 0), Color3.fromRGB(64, 64, 74))
		peca(tool, "Anel", Vector3.new(0.7, 0.2, 0.7), CFrame.new(0, 3.0, 0), Color3.fromRGB(170, 170, 180))
		local cristal = peca(tool, "Cristal", Vector3.new(0.45, 0.7, 0.45), CFrame.new(0, 3.45, 0) * CFrame.Angles(0, math.rad(45), 0), cor, true)
		local l = Instance.new("PointLight")
		l.Color, l.Range, l.Brightness = cor, 8, 1.2
		l.Parent = cristal
		return h
	end,
	pocao = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.6, 0.8, 0.6), CFrame.new(), cor, true)
		peca(tool, "Gargalo", Vector3.new(0.3, 0.35, 0.3), CFrame.new(0, 0.55, 0), Color3.fromRGB(200, 220, 230))
		peca(tool, "Rolha", Vector3.new(0.34, 0.2, 0.34), CFrame.new(0, 0.8, 0), MADEIRA)
		return h
	end,
	tocha = function(tool, cor)
		local h = peca(tool, "Handle", Vector3.new(0.3, 1.6, 0.3), CFrame.new(), MADEIRA)
		peca(tool, "Pano", Vector3.new(0.45, 0.4, 0.45), CFrame.new(0, 0.85, 0), ESCURO)
		local chama = peca(tool, "Chama", Vector3.new(0.4, 0.6, 0.4), CFrame.new(0, 1.3, 0), cor, true)
		local f = Instance.new("Fire")
		f.Size, f.Heat = 2, 5
		f.Parent = chama
		local l = Instance.new("PointLight")
		l.Color, l.Range, l.Brightness = cor, 22, 1.6
		l.Parent = chama
		return h
	end,
}
VISUAIS.pocaoGrande = VISUAIS.pocao

local function criarFerramenta(id, inicial)
	local item = ITENS[id]
	local tool = Instance.new("Tool")
	tool.Name = item.nome
	tool.ToolTip = item.desc
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	local cor = c3(item.cor)
	local visual = VISUAIS[item.visual or id] or VISUAIS.espadaLonga
	local handle = visual(tool, cor)
	-- reposiciona as pecas presas no handle
	for _, p in ipairs(tool:GetChildren()) do
		if p:IsA("BasePart") and p ~= handle then p.Anchored = false end
	end
	handle.Anchored = false
	tool:SetAttribute("ItemId", id)
	tool:SetAttribute("Tipo", item.tipo)
	tool:SetAttribute("Cor", cor)
	tool:SetAttribute("Dano", item.dano)
	tool:SetAttribute("Alcance", item.alcance)
	tool:SetAttribute("Recarga", item.recarga)
	tool:SetAttribute("Cura", item.cura)
	tool:SetAttribute("CuraGolpe", item.curaGolpe)
	tool:SetAttribute("Magica", item.magica)
	tool:SetAttribute("Fogo", item.tipo == "tocha" or nil)
	tool:SetAttribute("Inicial", inicial or nil)
	local uso = modelos.UsoDoItem:Clone()
	uso.Parent = tool
	uso.Enabled = true
	return tool
end

local function dar(jogador, id, inicial)
	local tool = criarFerramenta(id, inicial)
	tool.Parent = jogador:FindFirstChildOfClass("Backpack")
	-- armas e tocha voltam depois de morrer; pocoes nao
	if ITENS[id].tipo ~= "pocao" then
		local gear = jogador:FindFirstChild("StarterGear")
		if gear then criarFerramenta(id, inicial).Parent = gear end
	end
end

local function avisar(jogador, texto) Aviso:FireClient(jogador, texto) end

-- ================= MOEDAS =================
local function moedasDe(jogador)
	local ls = jogador:FindFirstChild("leaderstats")
	return ls and ls:FindFirstChild("Moedas")
end

local function titulo(jogador)
	local personagem = jogador.Character
	local cabeca = personagem and personagem:FindFirstChild("Head")
	local classe = jogador:GetAttribute("Classe")
	if not cabeca or not classe then return end
	local velho = cabeca:FindFirstChild("TituloDaClasse")
	if velho then velho:Destroy() end
	local gui = Instance.new("BillboardGui")
	gui.Name = "TituloDaClasse"
	gui.Size = UDim2.fromOffset(160, 26)
	gui.StudsOffset = Vector3.new(0, 2.4, 0)
	gui.MaxDistance = 60
	local r = Instance.new("TextLabel")
	r.Size = UDim2.fromScale(1, 1)
	r.BackgroundTransparency = 1
	r.Text = string.upper(classe)
	r.TextColor3 = Color3.fromRGB(225, 200, 255)
	r.TextStrokeTransparency = 0
	r.Font = Enum.Font.Arcade
	r.TextScaled = true
	r.Parent = gui
	gui.Parent = cabeca
end

local function aplicarClasse(jogador)
	local info = CLASSES[jogador:GetAttribute("Classe") or ""]
	local hum = jogador.Character and jogador.Character:FindFirstChildOfClass("Humanoid")
	if info and hum then
		hum.MaxHealth = info.vida
		hum.Health = info.vida
	end
	titulo(jogador)
end

Players.PlayerAdded:Connect(function(jogador)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local moedas = Instance.new("IntValue")
	moedas.Name = "Moedas"
	moedas.Value = MOEDAS_INICIAIS
	moedas.Parent = ls
	ls.Parent = jogador
	jogador.CharacterAdded:Connect(function()
		task.wait(0.2)
		aplicarClasse(jogador)
	end)
end)

-- ================= ESCOLHER CLASSE =================
local function escolherClasse(jogador, nome)
	local info = CLASSES[nome]
	if not info then return end
	if jogador:GetAttribute("Classe") == nome then
		avisar(jogador, "Voce ja e " .. nome .. ".")
		return
	end
	-- tira as armas iniciais da classe anterior
	for _, lugar in ipairs({ jogador:FindFirstChildOfClass("Backpack"), jogador:FindFirstChild("StarterGear"), jogador.Character }) do
		if lugar then
			for _, t in ipairs(lugar:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("Inicial") then t:Destroy() end
			end
		end
	end
	jogador:SetAttribute("Classe", nome)
	for _, id in ipairs(info.inicial) do dar(jogador, id, true) end
	aplicarClasse(jogador)
	avisar(jogador, "Agora voce e " .. string.upper(nome) .. "! Vida maxima: " .. info.vida .. ".")
end

local function ligarPrompts(pasta)
	if not pasta then return end
	for _, p in ipairs(pasta:GetDescendants()) do
		if p:IsA("ProximityPrompt") and p:GetAttribute("EscolherClasse") then
			p.Triggered:Connect(function(jogador) escolherClasse(jogador, p:GetAttribute("EscolherClasse")) end)
		end
	end
end
ligarPrompts(raiz)
ligarPrompts(workspace:FindFirstChild("ClassesDePersonagem"))

-- ================= LOJAS =================
local function listaDaLoja(id)
	local loja = LOJAS[id]
	local lista = {}
	for _, itemId in ipairs(loja.itens) do
		local it = ITENS[itemId]
		table.insert(lista, { id = itemId, nome = it.nome, desc = it.desc, preco = it.preco, cor = it.cor })
	end
	return { id = id, titulo = loja.titulo, itens = lista }
end

for _, npc in ipairs(raiz.Moradores:GetChildren()) do
	local lojaId = npc:GetAttribute("Loja")
	local fala = npc:GetAttribute("Fala")
	local cabeca = npc:FindFirstChild("Cabeca")
	if cabeca and (lojaId or fala) then
		local p = Instance.new("ProximityPrompt")
		p.ActionText = lojaId and "Comprar" or "Conversar"
		p.ObjectText = npc.Name
		p.HoldDuration = 0
		p.MaxActivationDistance = 12
		p.RequiresLineOfSight = false
		p.Parent = cabeca
		p.Triggered:Connect(function(jogador)
			if fala then avisar(jogador, npc.Name .. ": " .. fala) end
			if lojaId then AbrirLoja:FireClient(jogador, listaDaLoja(lojaId)) end
		end)
	end
end

ComprarItem.OnServerEvent:Connect(function(jogador, lojaId, itemId)
	local loja = LOJAS[lojaId]
	if type(itemId) ~= "string" or not loja or not table.find(loja.itens, itemId) then return end
	local item = ITENS[itemId]
	local moedas = moedasDe(jogador)
	if not moedas then return end
	if moedas.Value < item.preco then
		avisar(jogador, "Moedas insuficientes para " .. item.nome .. ". Faltam " .. (item.preco - moedas.Value) .. ".")
		return
	end
	moedas.Value = moedas.Value - item.preco
	dar(jogador, itemId, false)
	avisar(jogador, "Voce comprou " .. item.nome .. "!")
end)

-- ================= PORTAIS =================
local function inicioDaToca()
	local toca = workspace:FindFirstChild("TocaDaTecelaFaminta")
	local z1 = toca and toca:FindFirstChild("1_EscadasIngremes")
	return z1 and z1:FindFirstChild("InicioDaAventura")
end

local espera = {}
local function teleportar(hrp, destino)
	local jogador = Players:GetPlayerFromCharacter(hrp.Parent)
	if not jogador or (espera[jogador] and os.clock() - espera[jogador] < 2) then return end
	espera[jogador] = os.clock()
	hrp.CFrame = destino
end

local function ligarPortal(superficie, ondeIr)
	superficie.CanTouch = true
	superficie.Touched:Connect(function(parte)
		if parte.Name ~= "HumanoidRootPart" then return end
		local destino = ondeIr()
		if destino then
			teleportar(parte, destino)
		else
			local jogador = Players:GetPlayerFromCharacter(parte.Parent)
			if jogador then avisar(jogador, "A Toca ainda nao foi construida neste lugar.") end
		end
	end)
end

local spawnLobby = raiz.Praca.InicioNoLobby
for _, p in ipairs(raiz:GetDescendants()) do
	if p:IsA("BasePart") and p:GetAttribute("Portal") == "IrParaToca" then
		ligarPortal(p, function()
			local s = inicioDaToca()
			return s and (s.CFrame * CFrame.new(4, 3.5, 0))
		end)
	end
end
local toca = workspace:FindFirstChild("TocaDaTecelaFaminta")
if toca then
	for _, p in ipairs(toca:GetDescendants()) do
		if p:IsA("BasePart") and p:GetAttribute("Portal") == "VoltarParaVila" then
			ligarPortal(p, function() return spawnLobby.CFrame * CFrame.new(0, 3.5, -4) end)
		end
	end
end

-- ================= RECOMPENSAS =================
local function pagarAbates()
	local tocaAgora = workspace:FindFirstChild("TocaDaTecelaFaminta")
	local pers = tocaAgora and tocaAgora:FindFirstChild("Personagens")
	if not pers then return end
	for _, aranha in ipairs(pers:GetChildren()) do
		if aranha:IsA("Model") and aranha:GetAttribute("Aranha") then
			local pago = false
			aranha:GetAttributeChangedSignal("Vida"):Connect(function()
				local vida = aranha:GetAttribute("Vida") or 0
				if vida > 0 then
					pago = false
				elseif not pago then
					pago = true
					local jogador = Players:GetPlayerByUserId(aranha:GetAttribute("UltimoAtacante") or 0)
					local moedas = jogador and moedasDe(jogador)
					if moedas then
						local valor = aranha:GetAttribute("Chefe") and RECOMPENSA_CHEFE or RECOMPENSA_CRIA
						moedas.Value = moedas.Value + valor
						avisar(jogador, "+" .. valor .. " moedas!")
					end
				end
			end)
		end
	end
end
pagarAbates()
]==]
sistema.Parent = raiz

local scriptsJogador = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
if scriptsJogador then
	local velha = scriptsJogador:FindFirstChild("InterfaceDoLobby")
	if velha then velha:Destroy() end
	local interface = Instance.new("LocalScript")
	interface.Name = "InterfaceDoLobby"
	interface.Source = [==[
-- Interface da Vila Pedra-Musgo: tela das lojas e avisos (design: Yuri Ramos Hernandez)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local jogador = Players.LocalPlayer
local remotos = ReplicatedStorage:WaitForChild("LobbyRemotos")
local AbrirLoja, ComprarItem, Aviso = remotos.AbrirLoja, remotos.ComprarItem, remotos.Aviso

local FUNDO = Color3.fromRGB(24, 20, 32)
local PAINEL = Color3.fromRGB(36, 31, 48)
local BORDA = Color3.fromRGB(70, 58, 92)
local TEXTO = Color3.fromRGB(235, 228, 245)
local SUAVE = Color3.fromRGB(170, 160, 190)
local DESTAQUE = Color3.fromRGB(176, 92, 255)
local OURO = Color3.fromRGB(230, 190, 90)

local tela = Instance.new("ScreenGui")
tela.Name = "InterfaceDoLobby"
tela.ResetOnSpawn = false
tela.IgnoreGuiInset = false
tela.Parent = jogador:WaitForChild("PlayerGui")

local function borda(obj, cor, esp)
	local s = Instance.new("UIStroke")
	s.Color = cor or BORDA
	s.Thickness = esp or 2
	s.Parent = obj
end
local function texto(pai, props)
	local r = Instance.new("TextLabel")
	r.BackgroundTransparency = 1
	r.TextColor3 = TEXTO
	r.Font = Enum.Font.Gotham
	r.TextSize = 16
	r.TextXAlignment = Enum.TextXAlignment.Left
	for k, v in pairs(props) do r[k] = v end
	r.Parent = pai
	return r
end

-- ===== aviso no alto da tela =====
local aviso = Instance.new("TextLabel")
aviso.AnchorPoint = Vector2.new(0.5, 0)
aviso.Position = UDim2.new(0.5, 0, 0, 16)
aviso.Size = UDim2.fromOffset(440, 40)
aviso.BackgroundColor3 = FUNDO
aviso.BackgroundTransparency = 0.1
aviso.TextColor3 = TEXTO
aviso.Font = Enum.Font.GothamMedium
aviso.TextSize = 16
aviso.TextWrapped = true
aviso.Visible = false
aviso.Parent = tela
borda(aviso, DESTAQUE)
local contagem = 0
Aviso.OnClientEvent:Connect(function(msg)
	contagem = contagem + 1
	local minha = contagem
	aviso.Text = msg
	aviso.Visible = true
	task.delay(3.5, function()
		if contagem == minha then aviso.Visible = false end
	end)
end)

-- ===== janela da loja =====
local janela = Instance.new("Frame")
janela.AnchorPoint = Vector2.new(0.5, 0.5)
janela.Position = UDim2.fromScale(0.5, 0.5)
janela.Size = UDim2.new(0, 520, 0, 430)
janela.BackgroundColor3 = FUNDO
janela.Visible = false
janela.Parent = tela
borda(janela, BORDA, 3)
local limite = Instance.new("UISizeConstraint")
limite.MaxSize = Vector2.new(520, 430)
limite.Parent = janela
local escala = Instance.new("UIScale")
escala.Parent = janela
local function ajustar()
	local cam = workspace.CurrentCamera
	local v = cam and cam.ViewportSize or Vector2.new(800, 600)
	escala.Scale = math.min(1, (v.X - 24) / 520, (v.Y - 80) / 430)
end
ajustar()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ajustar) end

local tituloLoja = texto(janela, { Position = UDim2.fromOffset(20, 14), Size = UDim2.new(1, -120, 0, 30), Font = Enum.Font.Arcade, TextSize = 24 })
local moedasTxt = texto(janela, { Position = UDim2.new(1, -170, 0, 16), Size = UDim2.fromOffset(110, 26), TextColor3 = OURO, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right })
local fechar = Instance.new("TextButton")
fechar.Position = UDim2.new(1, -48, 0, 12)
fechar.Size = UDim2.fromOffset(34, 34)
fechar.BackgroundColor3 = PAINEL
fechar.Text = "X"
fechar.TextColor3 = TEXTO
fechar.Font = Enum.Font.GothamBold
fechar.TextSize = 18
fechar.Parent = janela
borda(fechar)
fechar.MouseButton1Click:Connect(function() janela.Visible = false end)

local lista = Instance.new("ScrollingFrame")
lista.Position = UDim2.fromOffset(16, 58)
lista.Size = UDim2.new(1, -32, 1, -74)
lista.BackgroundTransparency = 1
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 6
lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.CanvasSize = UDim2.new()
lista.Parent = janela
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = lista

local function atualizarMoedas()
	local ls = jogador:FindFirstChild("leaderstats")
	local m = ls and ls:FindFirstChild("Moedas")
	moedasTxt.Text = m and (m.Value .. " moedas") or ""
end

local lojaAtual
AbrirLoja.OnClientEvent:Connect(function(loja)
	lojaAtual = loja.id
	tituloLoja.Text = string.upper(loja.titulo)
	atualizarMoedas()
	for _, c in ipairs(lista:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	for i, item in ipairs(loja.itens) do
		local linha = Instance.new("Frame")
		linha.LayoutOrder = i
		linha.Size = UDim2.new(1, -8, 0, 64)
		linha.BackgroundColor3 = PAINEL
		linha.Parent = lista
		borda(linha)
		local icone = Instance.new("Frame")
		icone.Position = UDim2.fromOffset(12, 14)
		icone.Size = UDim2.fromOffset(36, 36)
		icone.BackgroundColor3 = Color3.fromRGB(item.cor[1], item.cor[2], item.cor[3])
		icone.Parent = linha
		borda(icone, Color3.fromRGB(10, 8, 14))
		texto(linha, { Text = item.nome, Position = UDim2.fromOffset(60, 10), Size = UDim2.new(1, -200, 0, 22), Font = Enum.Font.GothamBold })
		texto(linha, { Text = item.desc, Position = UDim2.fromOffset(60, 32), Size = UDim2.new(1, -200, 0, 22), TextSize = 13, TextColor3 = SUAVE, TextTruncate = Enum.TextTruncate.AtEnd })
		local botao = Instance.new("TextButton")
		botao.AnchorPoint = Vector2.new(1, 0.5)
		botao.Position = UDim2.new(1, -12, 0.5, 0)
		botao.Size = UDim2.fromOffset(120, 38)
		botao.BackgroundColor3 = DESTAQUE
		botao.Text = "Comprar - " .. item.preco
		botao.TextColor3 = Color3.fromRGB(255, 255, 255)
		botao.Font = Enum.Font.GothamBold
		botao.TextSize = 15
		botao.Parent = linha
		botao.MouseButton1Click:Connect(function()
			ComprarItem:FireServer(lojaAtual, item.id)
			task.delay(0.3, atualizarMoedas)
		end)
	end
	janela.Visible = true
end)
]==]
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
