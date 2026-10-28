--[[
	CLASSES DE PERSONAGEM - A Toca da Tecela Faminta
	Design: Yuri Ramos Hernandez

	Cinco classes no mesmo estilo pixel/voxel do Arcanista do Veu:
	  Cavaleiro   - linha de frente: elmo fechado, gola de pele, espada longa com runas
	  Clerigo     - suporte: maca, escudo com sol, cota de malha na cabeca
	  Arcanista   - magia: o mago do veu com cajado de cristal
	  Ladino      - furtividade: capuz, mascara e duas adagas
	  Patrulheiro - distancia: arco longo, aljava e manto verde

	Como usar: Roblox Studio > aba View > Command Bar > cole tudo > Enter
	Os cinco aparecem lado a lado em pedestais, na frente da camera.
	Cada um e um Model com os atributos Classe, Papel e Designer.

	Para criar so algumas classes, apague os nomes que nao quer da lista abaixo.

	ANIMACOES DE COMBATE (rodam no Play)
	Cada classe tem: Parado, Ataque, Habilidade e Dano.
	  Cavaleiro   - Ataque: corte de cima para baixo | Habilidade: golpe giratorio
	  Clerigo     - Ataque: golpe de maca no chao    | Habilidade: luz sagrada (cura)
	  Arcanista   - Ataque: raio arcano              | Habilidade: circulo do veu (explosao)
	  Ladino      - Ataque: dois cortes rapidos      | Habilidade: passo sombrio (avanco)
	  Patrulheiro - Ataque: disparo de flecha        | Habilidade: chuva de flechas
	No pedestal de cada um: segure E para Ataque e R para Habilidade.
	Com VITRINE = true, eles tambem treinam sozinhos, um golpe de cada vez.
	Em outros scripts: personagem:SetAttribute("Animacao", "Ataque")
]]

local CRIAR = { "Cavaleiro", "Clerigo", "Arcanista", "Ladino", "Patrulheiro" }
local VITRINE = true

local C = {
	-- comuns
	sombra    = Color3.fromRGB(14, 12, 20),
	pele      = Color3.fromRGB(222, 178, 142),
	pele2     = Color3.fromRGB(196, 150, 116),
	couro     = Color3.fromRGB(110, 72, 44),
	couro2    = Color3.fromRGB(86, 56, 36),
	couroEsc  = Color3.fromRGB(52, 38, 32),
	ouro      = Color3.fromRGB(206, 164, 64),
	carmim    = Color3.fromRGB(128, 28, 40),
	carmimEsc = Color3.fromRGB(90, 20, 30),
	prata     = Color3.fromRGB(170, 170, 180),
	aco       = Color3.fromRGB(150, 154, 166),
	aco2      = Color3.fromRGB(112, 116, 130),
	lamina    = Color3.fromRGB(196, 202, 214),
	malha     = Color3.fromRGB(96, 100, 112),
	madeira   = Color3.fromRGB(110, 75, 45),
	branco    = Color3.fromRGB(236, 232, 220),
	-- cavaleiro
	pelo      = Color3.fromRGB(226, 216, 196),
	pelo2     = Color3.fromRGB(196, 184, 162),
	tunica    = Color3.fromRGB(46, 44, 62),
	capaCinza = Color3.fromRGB(66, 64, 74),
	runaAzul  = Color3.fromRGB(120, 190, 255),
	pocao     = Color3.fromRGB(230, 60, 70),
	-- clerigo
	veste     = Color3.fromRGB(232, 226, 210),
	veste2    = Color3.fromRGB(204, 196, 178),
	azul      = Color3.fromRGB(70, 104, 160),
	barba     = Color3.fromRGB(104, 76, 56),
	sol       = Color3.fromRGB(255, 210, 90),
	-- arcanista
	ferro     = Color3.fromRGB(48, 44, 52),
	calca     = Color3.fromRGB(58, 54, 64),
	manto     = Color3.fromRGB(40, 38, 50),
	manto2    = Color3.fromRGB(52, 49, 64),
	olho      = Color3.fromRGB(180, 120, 255),
	luva      = Color3.fromRGB(62, 42, 36),
	haste     = Color3.fromRGB(64, 64, 74),
	cristal   = Color3.fromRGB(160, 90, 255),
	-- ladino
	verdeEsc  = Color3.fromRGB(38, 52, 48),
	verdeEsc2 = Color3.fromRGB(28, 40, 36),
	calcaEsc  = Color3.fromRGB(42, 40, 46),
	-- patrulheiro
	verde     = Color3.fromRGB(72, 98, 58),
	verde2    = Color3.fromRGB(56, 78, 46),
	capaVerde = Color3.fromRGB(50, 68, 44),
	calcaMarrom = Color3.fromRGB(84, 66, 50),
	pena      = Color3.fromRGB(240, 236, 226),
	-- pedestal
	pedra     = Color3.fromRGB(64, 61, 74),
	pedra2    = Color3.fromRGB(48, 46, 58),
}

local M = {
	plastico = Enum.Material.SmoothPlastic,
	metal    = Enum.Material.Metal,
	neon     = Enum.Material.Neon,
}

local function novoPart(pai, nome, tamanho, cf, cor, mat)
	local p = Instance.new("Part")
	p.Name = nome
	p.Anchored = true
	p.CanCollide = false
	p.Size = tamanho
	p.CFrame = cf
	p.Color = C[cor]
	p.Material = M[mat or "plastico"]
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if mat == "neon" then p.CastShadow = false end
	p.Parent = pai
	return p
end

local function rot(r)
	if not r then return CFrame.new() end
	return CFrame.Angles(math.rad(r[1] or 0), math.rad(r[2] or 0), math.rad(r[3] or 0))
end

-- Cada peca pertence a um membro, que gira em volta da sua junta na animacao
local function conjunto(lista)
	local s = {}
	for _, n in ipairs(lista) do s[n] = true end
	return s
end
local MEMBROS = {
	Raiz = conjunto({ "SaiaMalha", "MalhaLinha1", "MalhaLinha2", "TabardoBarra", "SaiaBaixo", "SaiaMeio", "BarraVeste",
		"BarraManto", "Aba", "TunicaBaixo", "CapaBarra", "Rasgo1", "Rasgo2", "FaixaBorda" }),
	Cabeca = conjunto({ "Elmo", "ElmoTopo", "Viseira", "Reforco", "Respiro1", "Respiro2", "Respiro3", "Respiro4",
		"Cabeca", "MalhaE", "MalhaD", "MalhaTras", "MalhaTopo", "MalhaTesta", "OlhoE", "OlhoD", "Nariz", "Bigode",
		"Barba", "Rosto", "CapuzE", "CapuzD", "CapuzTras", "CapuzTopo", "CapuzAba", "CapuzPonta", "Pico1", "Pico2",
		"Pico3", "DebrumTopo", "DebrumE", "DebrumD", "Mascara", "Sobrancelha" }),
	BracoE = conjunto({ "OmbreiraE", "MangaE", "BraceleteE", "ListraE1", "ListraE2", "ManoplaE", "PunhoE", "MaoE",
		"EscudoV", "EscudoH", "EscudoBordaV", "EscudoBordaH", "EscudoSol", "BracoE", "BracadeiraE", "GuardaE", "AdagaE",
		"PontaE", "OmbroE", "AntebracoE", "ArcoCima1", "ArcoCima2", "ArcoBaixo1", "ArcoBaixo2", "Corda" }),
	BracoD = conjunto({ "OmbreiraD", "MangaD", "AntebracoD", "ListraD1", "ListraD2", "ManoplaD", "Pomo", "Empunhadura",
		"Guarda", "Lamina", "PontaLamina", "Runas", "OmbroD", "PunhoD", "MaoD", "CaboMaca", "CabecaMaca", "Flange1",
		"Flange2", "PontaMaca", "Haste", "Amarra1", "Amarra2", "Ponteira", "Anel", "Garra1", "Garra2", "Garra3", "Garra4",
		"Cristal", "BracoD", "BracadeiraD", "GuardaD", "AdagaD", "PontaD" }),
	PernaE = conjunto({ "BotaE", "GrevaE", "JoelheiraE", "PernaE", "DobraE" }),
	PernaD = conjunto({ "BotaD", "GrevaD", "JoelheiraD", "PernaD", "DobraD" }),
}
local function membroDe(nome)
	for membro, nomes in pairs(MEMBROS) do
		if nomes[nome] then return membro end
	end
	return "Tronco"
end

-- { nome, {tamanho}, {posicao}, cor, material, {giroX, giroY, giroZ} }
local function construir(nome, base, pecas, info, extra)
	local m = Instance.new("Model")
	m.Name = nome
	for k, v in pairs(info) do m:SetAttribute(k, v) end
	m:SetAttribute("Designer", "Yuri Ramos Hernandez")
	local criadas = {}
	for _, d in ipairs(pecas) do
		local cf = base * CFrame.new(d[3][1], d[3][2], d[3][3]) * rot(d[6])
		criadas[d[1]] = novoPart(m, d[1], Vector3.new(d[2][1], d[2][2], d[2][3]), cf, d[4], d[5])
	end
	if extra then
		local function seg(n, a, b, esp, cor, mat)
			local pa, pb = base * a, base * b
			local cima = Vector3.new(0, 1, 0)
			if math.abs((pb - pa).Unit.Y) > 0.98 then cima = Vector3.new(0, 0, 1) end
			return novoPart(m, n, Vector3.new(esp, esp, (pb - pa).Magnitude), CFrame.lookAt((pa + pb) / 2, pb, cima), cor, mat)
		end
		extra(seg, criadas)
	end
	for _, p in ipairs(m:GetChildren()) do
		if p:IsA("BasePart") then p:SetAttribute("Membro", membroDe(p.Name)) end
	end
	local contorno = Instance.new("Highlight")
	contorno.Name = "ContornoPixel"
	contorno.FillTransparency = 1
	contorno.OutlineColor = Color3.fromRGB(10, 8, 14)
	contorno.OutlineTransparency = 0
	contorno.DepthMode = Enum.HighlightDepthMode.Occluded
	contorno.Adornee = m
	contorno.Parent = m
	m.WorldPivot = base
	return m, criadas
end

local function luz(parte, cor, alcance, brilho)
	local l = Instance.new("PointLight")
	l.Color = C[cor]
	l.Range = alcance
	l.Brightness = brilho
	l.Parent = parte
end

local V = Vector3.new
local CLASSES = {}

-- ======================= CAVALEIRO =======================
CLASSES.Cavaleiro = function(base)
	local pecas = {
		-- pernas
		{"BotaE", {0.85,0.5,1.25}, {-0.5,0.25,-0.1}, "couro"},
		{"BotaD", {0.85,0.5,1.25}, {0.5,0.25,-0.1}, "couro"},
		{"GrevaE", {0.8,1.0,0.8}, {-0.5,1.0,0}, "aco", "metal"},
		{"GrevaD", {0.8,1.0,0.8}, {0.5,1.0,0}, "aco", "metal"},
		{"JoelheiraE", {0.85,0.3,0.3}, {-0.5,1.35,-0.42}, "aco2", "metal"},
		{"JoelheiraD", {0.85,0.3,0.3}, {0.5,1.35,-0.42}, "aco2", "metal"},
		-- saia de malha e tunica
		{"SaiaMalha", {2.3,0.9,1.8}, {0,1.85,0}, "malha", "metal"},
		{"MalhaLinha1", {2.32,0.08,1.82}, {0,1.65,0}, "aco2", "metal"},
		{"MalhaLinha2", {2.32,0.08,1.82}, {0,2.05,0}, "aco2", "metal"},
		{"Tunica", {2.2,1.7,1.7}, {0,3.2,0}, "tunica"},
		{"Tabardo", {1.0,2.8,0.12}, {0,2.55,-0.91}, "carmim"},
		{"TabardoBarra", {1.0,0.25,0.13}, {0,1.25,-0.91}, "carmimEsc"},
		{"Brasao", {0.5,0.5,0.06}, {0,3.45,-0.99}, "ouro", "metal"},
		{"Colete", {2.3,1.2,1.75}, {0,3.6,0.02}, "couro2"},
		{"Cinto", {2.35,0.35,1.8}, {0,2.45,0}, "couroEsc"},
		{"Fivela", {0.45,0.4,0.1}, {0,2.45,-0.93}, "ouro", "metal"},
		{"Bolsa", {0.6,0.6,0.35}, {0.82,2.05,-0.95}, "couro"},
		{"Pocao", {0.3,0.4,0.3}, {1.12,2.0,-0.7}, "pocao", "neon"},
		{"Bainha", {0.25,1.0,0.15}, {-0.78,1.85,-0.97}, "couro2", nil, {0,0,12}},
		{"CaboAdaga", {0.18,0.4,0.18}, {-0.68,2.5,-0.97}, "couroEsc", nil, {0,0,12}},
		-- capa
		{"Capa", {2.4,3.6,0.2}, {0,2.7,1.0}, "capaCinza"},
		{"CapaBarra", {2.8,0.9,0.2}, {0,1.05,1.05}, "capaCinza"},
		-- gola de pele
		{"Pele", {3.0,0.8,2.2}, {0,4.3,0.05}, "pelo"},
		{"PeleTopo", {2.5,0.5,2.0}, {0,4.75,0.15}, "pelo2"},
		{"Tufo1", {0.6,0.5,0.5}, {-1.4,4.65,-0.6}, "pelo"},
		{"Tufo2", {0.6,0.5,0.5}, {1.4,4.65,-0.6}, "pelo"},
		{"Tufo3", {0.7,0.5,0.6}, {-0.9,4.95,0.8}, "pelo"},
		{"Tufo4", {0.7,0.5,0.6}, {0.9,4.95,0.8}, "pelo"},
		{"Broche", {0.35,0.35,0.1}, {1.05,4.35,-1.12}, "ouro", "metal"},
		-- elmo fechado
		{"Elmo", {1.5,1.6,1.5}, {0,5.55,0}, "aco", "metal"},
		{"ElmoTopo", {1.3,0.3,1.3}, {0,6.5,0}, "aco2", "metal"},
		{"Viseira", {1.25,0.14,0.06}, {0,5.78,-0.77}, "sombra"},
		{"Reforco", {0.22,1.3,0.07}, {0,5.4,-0.78}, "aco2", "metal"},
		{"Respiro1", {0.1,0.1,0.06}, {-0.42,5.25,-0.77}, "sombra"},
		{"Respiro2", {0.1,0.1,0.06}, {-0.42,5.05,-0.77}, "sombra"},
		{"Respiro3", {0.1,0.1,0.06}, {0.42,5.25,-0.77}, "sombra"},
		{"Respiro4", {0.1,0.1,0.06}, {0.42,5.05,-0.77}, "sombra"},
		-- braco esquerdo (punho fechado)
		{"OmbreiraE", {0.95,0.6,1.25}, {-1.5,4.2,0}, "aco", "metal"},
		{"MangaE", {0.75,1.0,0.75}, {-1.5,3.55,0}, "tunica"},
		{"BraceleteE", {0.8,0.85,0.8}, {-1.5,2.75,0}, "couro"},
		{"ListraE1", {0.82,0.14,0.82}, {-1.5,2.95,0}, "carmim"},
		{"ListraE2", {0.82,0.14,0.82}, {-1.5,2.6,0}, "carmim"},
		{"ManoplaE", {0.7,0.6,0.7}, {-1.5,2.05,-0.05}, "aco2", "metal"},
		-- braco direito (segura a espada)
		{"OmbreiraD", {0.95,0.6,1.25}, {1.5,4.2,0}, "aco", "metal"},
		{"MangaD", {0.75,1.0,0.75}, {1.5,3.6,0}, "tunica"},
		{"AntebracoD", {0.8,0.8,1.2}, {1.5,3.0,-0.55}, "couro"},
		{"ListraD1", {0.82,0.82,0.14}, {1.5,3.0,-0.35}, "carmim"},
		{"ListraD2", {0.82,0.82,0.14}, {1.5,3.0,-0.75}, "carmim"},
		{"ManoplaD", {0.7,0.7,0.7}, {1.5,3.0,-1.3}, "aco2", "metal"},
		-- espada longa
		{"Pomo", {0.4,0.4,0.4}, {1.5,2.3,-1.3}, "aco2", "metal"},
		{"Empunhadura", {0.25,0.9,0.25}, {1.5,2.95,-1.3}, "couroEsc"},
		{"Guarda", {1.4,0.25,0.35}, {1.5,3.55,-1.3}, "aco", "metal"},
		{"Lamina", {0.38,4.2,0.12}, {1.5,5.75,-1.3}, "lamina", "metal"},
		{"PontaLamina", {0.2,0.45,0.1}, {1.5,8.05,-1.3}, "lamina", "metal"},
		{"Runas", {0.08,2.4,0.03}, {1.5,5.4,-1.38}, "runaAzul", "neon"},
	}
	return construir("Cavaleiro", base, pecas, { Classe = "Cavaleiro", Papel = "Linha de frente: aguenta o dano e protege o grupo" })
end

-- ======================= CLERIGO =======================
CLASSES.Clerigo = function(base)
	local pecas = {
		{"BotaE", {0.8,0.6,1.2}, {-0.5,0.3,-0.1}, "couro2"},
		{"BotaD", {0.8,0.6,1.2}, {0.5,0.3,-0.1}, "couro2"},
		{"PernaE", {0.7,0.9,0.7}, {-0.5,1.05,0}, "malha", "metal"},
		{"PernaD", {0.7,0.9,0.7}, {0.5,1.05,0}, "malha", "metal"},
		{"BarraVeste", {2.65,0.18,2.25}, {0,1.3,0}, "ouro", "metal"},
		{"SaiaBaixo", {2.6,0.5,2.2}, {0,1.6,0}, "veste"},
		{"SaiaMeio", {2.4,1.1,2.0}, {0,2.35,0}, "veste2"},
		{"Tronco", {2.2,1.4,1.8}, {0,3.5,0}, "veste"},
		{"FaixaFrente", {0.9,2.6,0.1}, {0,2.6,-0.98}, "azul"},
		{"FaixaBorda", {0.95,0.15,0.11}, {0,1.35,-0.98}, "ouro", "metal"},
		{"Cinto", {2.3,0.3,1.9}, {0,2.95,0}, "couro"},
		{"Sol", {0.5,0.5,0.08}, {0,3.65,-0.95}, "sol", "neon"},
		{"Raio1", {0.12,0.28,0.06}, {0,4.05,-0.95}, "sol", "neon"},
		{"Raio2", {0.12,0.28,0.06}, {0,3.25,-0.95}, "sol", "neon"},
		{"Raio3", {0.28,0.12,0.06}, {-0.4,3.65,-0.95}, "sol", "neon"},
		{"Raio4", {0.28,0.12,0.06}, {0.4,3.65,-0.95}, "sol", "neon"},
		{"Manto", {2.8,0.5,2.1}, {0,4.15,0}, "azul"},
		{"Gola", {2.0,0.4,1.6}, {0,4.55,0}, "ouro", "metal"},
		-- cabeca com cota de malha
		{"Cabeca", {1.4,1.4,1.4}, {0,5.35,0}, "pele"},
		{"MalhaE", {0.2,1.4,1.5}, {-0.8,5.35,0.05}, "malha", "metal"},
		{"MalhaD", {0.2,1.4,1.5}, {0.8,5.35,0.05}, "malha", "metal"},
		{"MalhaTras", {1.6,1.4,0.2}, {0,5.35,0.8}, "malha", "metal"},
		{"MalhaTopo", {1.6,0.3,1.6}, {0,6.15,0.05}, "malha", "metal"},
		{"MalhaTesta", {1.4,0.25,0.1}, {0,5.92,-0.72}, "malha", "metal"},
		{"OlhoE", {0.18,0.22,0.06}, {-0.3,5.48,-0.72}, "sombra"},
		{"OlhoD", {0.18,0.22,0.06}, {0.3,5.48,-0.72}, "sombra"},
		{"Nariz", {0.2,0.3,0.15}, {0,5.25,-0.76}, "pele2"},
		{"Bigode", {0.8,0.15,0.1}, {0,5.05,-0.74}, "barba"},
		{"Barba", {1.2,0.55,0.3}, {0,4.78,-0.62}, "barba"},
		-- braco esquerdo com escudo
		{"MangaE", {0.8,1.6,0.8}, {-1.5,3.3,0}, "veste2"},
		{"PunhoE", {0.9,0.3,0.9}, {-1.5,2.45,0}, "ouro", "metal"},
		{"MaoE", {0.6,0.5,0.6}, {-1.5,2.1,0}, "pele"},
		{"EscudoV", {0.25,2.2,1.4}, {-2.05,3.0,0}, "azul"},
		{"EscudoH", {0.25,1.4,2.2}, {-2.05,3.0,0}, "azul"},
		{"EscudoBordaV", {0.22,2.35,1.0}, {-2.0,3.0,0}, "ouro", "metal"},
		{"EscudoBordaH", {0.22,1.0,2.35}, {-2.0,3.0,0}, "ouro", "metal"},
		{"EscudoSol", {0.1,0.6,0.6}, {-2.22,3.0,0}, "sol", "neon"},
		-- braco direito com maca
		{"OmbroD", {0.8,1.0,0.8}, {1.5,3.6,0}, "veste2"},
		{"AntebracoD", {0.8,0.8,1.3}, {1.5,3.0,-0.55}, "veste2"},
		{"PunhoD", {0.9,0.9,0.3}, {1.5,3.0,-1.3}, "ouro", "metal"},
		{"MaoD", {0.6,0.6,0.6}, {1.5,3.0,-1.7}, "pele"},
		{"CaboMaca", {0.25,2.6,0.25}, {1.5,3.6,-1.7}, "madeira"},
		{"CabecaMaca", {0.7,0.7,0.7}, {1.5,5.1,-1.7}, "aco", "metal"},
		{"Flange1", {1.0,0.5,0.22}, {1.5,5.1,-1.7}, "aco2", "metal", {0,45,0}},
		{"Flange2", {1.0,0.5,0.22}, {1.5,5.1,-1.7}, "aco2", "metal", {0,-45,0}},
		{"PontaMaca", {0.3,0.3,0.3}, {1.5,5.6,-1.7}, "sol", "neon"},
	}
	local m, p = construir("Clerigo", base, pecas, { Classe = "Clerigo", Papel = "Suporte: cura o grupo e afasta mortos-vivos" })
	luz(p.Sol, "sol", 8, 0.8)
	return m
end

-- ======================= ARCANISTA =======================
CLASSES.Arcanista = function(base)
	local pecas = {
		{"BotaE", {0.8,0.6,1.2}, {-0.5,0.3,-0.1}, "ferro"},
		{"BotaD", {0.8,0.6,1.2}, {0.5,0.3,-0.1}, "ferro"},
		{"PernaE", {0.7,0.9,0.7}, {-0.5,1.05,0}, "calca"},
		{"PernaD", {0.7,0.9,0.7}, {0.5,1.05,0}, "calca"},
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
		{"Cabeca", {1.4,1.4,1.5}, {0,5.35,0.05}, "sombra"},
		{"Rosto", {1.3,1.1,0.1}, {0,5.3,-0.75}, "sombra"},
		{"OlhoE", {0.3,0.2,0.1}, {-0.32,5.4,-0.82}, "olho", "neon"},
		{"OlhoD", {0.3,0.2,0.1}, {0.32,5.4,-0.82}, "olho", "neon"},
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
		{"MangaE", {0.8,1.6,0.8}, {-1.5,3.3,0}, "manto2"},
		{"PunhoE", {0.9,0.3,0.9}, {-1.5,2.45,0}, "carmim"},
		{"MaoE", {0.6,0.5,0.6}, {-1.5,2.1,0}, "luva"},
		{"OmbroD", {0.8,1.0,0.8}, {1.5,3.6,0}, "manto2"},
		{"AntebracoD", {0.8,0.8,1.3}, {1.5,3.0,-0.55}, "manto2"},
		{"PunhoD", {0.9,0.9,0.3}, {1.5,3.0,-1.3}, "carmim"},
		{"MaoD", {0.6,0.6,0.6}, {1.5,3.0,-1.7}, "luva"},
		{"Haste", {0.3,6.0,0.3}, {1.5,3.0,-1.7}, "haste", "metal"},
		{"Amarra1", {0.4,0.3,0.4}, {1.5,3.6,-1.7}, "carmim"},
		{"Amarra2", {0.4,0.3,0.4}, {1.5,2.4,-1.7}, "carmim"},
		{"Ponteira", {0.4,0.3,0.4}, {1.5,0.15,-1.7}, "haste", "metal"},
		{"Anel", {0.8,0.2,0.8}, {1.5,6.0,-1.7}, "prata", "metal"},
		{"Garra1", {0.2,0.7,0.2}, {1.8,6.35,-1.7}, "prata", "metal"},
		{"Garra2", {0.2,0.7,0.2}, {1.2,6.35,-1.7}, "prata", "metal"},
		{"Garra3", {0.2,0.7,0.2}, {1.5,6.35,-1.4}, "prata", "metal"},
		{"Garra4", {0.2,0.7,0.2}, {1.5,6.35,-2.0}, "prata", "metal"},
		{"Cristal", {0.45,0.7,0.45}, {1.5,6.6,-1.7}, "cristal", "neon", {0,45,0}},
	}
	local m, p = construir("Arcanista", base, pecas, { Classe = "Arcanista", Papel = "Magia: dano em area e controle do campo" })
	luz(p.Cristal, "cristal", 10, 2)
	return m
end

-- ======================= LADINO =======================
CLASSES.Ladino = function(base)
	local pecas = {
		{"BotaE", {0.75,0.7,1.15}, {-0.48,0.35,-0.08}, "couroEsc"},
		{"BotaD", {0.75,0.7,1.15}, {0.48,0.35,-0.08}, "couroEsc"},
		{"PernaE", {0.68,1.0,0.68}, {-0.48,1.2,0}, "calcaEsc"},
		{"PernaD", {0.68,1.0,0.68}, {0.48,1.2,0}, "calcaEsc"},
		{"Aba", {2.1,0.7,1.6}, {0,2.2,0}, "couro2"},
		{"Jaqueta", {2.0,1.6,1.5}, {0,3.3,0}, "couroEsc"},
		{"Correia1", {0.22,2.0,0.08}, {0,3.3,-0.78}, "couro", nil, {0,0,35}},
		{"Correia2", {0.22,2.0,0.08}, {0,3.3,-0.78}, "couro", nil, {0,0,-35}},
		{"Argola", {0.3,0.3,0.1}, {0,3.3,-0.83}, "prata", "metal"},
		{"Cinto", {2.1,0.3,1.6}, {0,2.6,0}, "couro"},
		{"Bolso1", {0.4,0.45,0.3}, {-0.7,2.35,-0.85}, "couro2"},
		{"Bolso2", {0.4,0.45,0.3}, {0.7,2.35,-0.85}, "couro2"},
		{"Bolso3", {0.35,0.4,0.3}, {1.05,2.4,-0.4}, "couro2"},
		{"MantoOmbro", {2.4,0.5,1.9}, {0,4.15,0}, "verdeEsc"},
		{"CapaCurta", {2.2,2.4,0.15}, {0,3.0,0.85}, "verdeEsc"},
		{"Rasgo1", {0.5,0.4,0.15}, {-0.7,1.65,0.85}, "verdeEsc"},
		{"Rasgo2", {0.4,0.3,0.15}, {0.5,1.7,0.85}, "verdeEsc"},
		-- cabeca com capuz e mascara
		{"Cabeca", {1.3,1.3,1.3}, {0,5.0,0}, "pele"},
		{"CapuzE", {0.25,1.5,1.7}, {-0.78,5.05,0}, "verdeEsc2"},
		{"CapuzD", {0.25,1.5,1.7}, {0.78,5.05,0}, "verdeEsc2"},
		{"CapuzTras", {1.8,1.5,0.25}, {0,5.05,0.78}, "verdeEsc2"},
		{"CapuzTopo", {1.8,0.35,1.8}, {0,5.85,0}, "verdeEsc2"},
		{"CapuzAba", {1.8,0.3,0.3}, {0,5.62,-0.72}, "verdeEsc2"},
		{"CapuzPonta", {0.8,0.4,0.8}, {0,6.15,0.35}, "verdeEsc2"},
		{"Mascara", {1.32,0.55,0.08}, {0,4.62,-0.68}, "verdeEsc"},
		{"OlhoE", {0.22,0.14,0.06}, {-0.28,5.1,-0.67}, "sombra"},
		{"OlhoD", {0.22,0.14,0.06}, {0.28,5.1,-0.67}, "sombra"},
		{"Sobrancelha", {0.9,0.08,0.06}, {0,5.27,-0.67}, "couroEsc"},
		-- bracos com adagas em pegada invertida
		{"BracoE", {0.7,1.5,0.7}, {-1.35,3.3,0}, "couroEsc"},
		{"BracoD", {0.7,1.5,0.7}, {1.35,3.3,0}, "couroEsc"},
		{"BracadeiraE", {0.75,0.35,0.75}, {-1.35,2.65,0}, "couro"},
		{"BracadeiraD", {0.75,0.35,0.75}, {1.35,2.65,0}, "couro"},
		{"MaoE", {0.55,0.5,0.55}, {-1.35,2.25,-0.1}, "luva"},
		{"MaoD", {0.55,0.5,0.55}, {1.35,2.25,-0.1}, "luva"},
		{"GuardaE", {0.5,0.12,0.22}, {-1.35,1.95,-0.1}, "prata", "metal"},
		{"GuardaD", {0.5,0.12,0.22}, {1.35,1.95,-0.1}, "prata", "metal"},
		{"AdagaE", {0.12,1.2,0.3}, {-1.35,1.3,-0.1}, "lamina", "metal"},
		{"AdagaD", {0.12,1.2,0.3}, {1.35,1.3,-0.1}, "lamina", "metal"},
		{"PontaE", {0.1,0.3,0.16}, {-1.35,0.6,-0.1}, "lamina", "metal"},
		{"PontaD", {0.1,0.3,0.16}, {1.35,0.6,-0.1}, "lamina", "metal"},
	}
	return construir("Ladino", base, pecas, { Classe = "Ladino", Papel = "Furtividade: abre fechaduras, desarma armadilhas e ataca pelas costas" })
end

-- ======================= PATRULHEIRO =======================
CLASSES.Patrulheiro = function(base)
	local pecas = {
		{"BotaE", {0.8,1.1,1.2}, {-0.5,0.55,-0.1}, "couro"},
		{"BotaD", {0.8,1.1,1.2}, {0.5,0.55,-0.1}, "couro"},
		{"DobraE", {0.85,0.25,1.0}, {-0.5,1.05,0}, "couro2"},
		{"DobraD", {0.85,0.25,1.0}, {0.5,1.05,0}, "couro2"},
		{"PernaE", {0.7,0.7,0.7}, {-0.5,1.45,0}, "calcaMarrom"},
		{"PernaD", {0.7,0.7,0.7}, {0.5,1.45,0}, "calcaMarrom"},
		{"TunicaBaixo", {2.3,0.8,1.8}, {0,2.2,0}, "verde2"},
		{"Tunica", {2.2,1.5,1.7}, {0,3.3,0}, "verde"},
		{"Cinto", {2.35,0.3,1.85}, {0,2.65,0}, "couro"},
		{"Fivela", {0.35,0.35,0.1}, {0,2.65,-0.95}, "prata", "metal"},
		{"Faca", {0.2,0.8,0.12}, {0.8,2.2,-0.96}, "couroEsc"},
		{"CorreiaAljava", {0.22,2.1,0.08}, {0,3.3,-0.88}, "couro2", nil, {0,0,-35}},
		{"Manto", {2.6,0.5,2.0}, {0,4.15,0}, "capaVerde"},
		{"Capa", {2.4,3.2,0.15}, {0,2.9,0.92}, "capaVerde"},
		{"CapaBarra", {2.6,0.6,0.15}, {0,1.15,0.95}, "verde2"},
		-- aljava nas costas
		{"Aljava", {0.8,2.6,0.8}, {0.6,3.7,1.3}, "couro", nil, {0,0,-20}},
		{"AljavaBoca", {0.9,0.25,0.9}, {1.0,4.85,1.3}, "couro2", nil, {0,0,-20}},
		{"Flecha1", {0.1,0.7,0.1}, {0.95,5.3,1.15}, "madeira", nil, {0,0,-20}},
		{"Flecha2", {0.1,0.7,0.1}, {1.2,5.25,1.4}, "madeira", nil, {0,0,-20}},
		{"Flecha3", {0.1,0.7,0.1}, {0.85,5.2,1.45}, "madeira", nil, {0,0,-20}},
		{"Pena1", {0.25,0.35,0.06}, {1.07,5.6,1.15}, "pena", nil, {0,0,-20}},
		{"Pena2", {0.25,0.35,0.06}, {1.32,5.55,1.4}, "carmim", nil, {0,0,-20}},
		{"Pena3", {0.25,0.35,0.06}, {0.97,5.5,1.45}, "pena", nil, {0,0,-20}},
		-- cabeca com capuz
		{"Cabeca", {1.3,1.3,1.3}, {0,5.05,0}, "pele"},
		{"CapuzE", {0.25,1.5,1.7}, {-0.78,5.1,0}, "capaVerde"},
		{"CapuzD", {0.25,1.5,1.7}, {0.78,5.1,0}, "capaVerde"},
		{"CapuzTras", {1.8,1.5,0.25}, {0,5.1,0.78}, "capaVerde"},
		{"CapuzTopo", {1.8,0.35,1.8}, {0,5.9,0}, "capaVerde"},
		{"CapuzAba", {1.8,0.3,0.3}, {0,5.68,-0.72}, "verde2"},
		{"CapuzPonta", {0.7,0.5,0.9}, {0,6.2,0.5}, "capaVerde"},
		{"OlhoE", {0.2,0.2,0.06}, {-0.28,5.12,-0.67}, "sombra"},
		{"OlhoD", {0.2,0.2,0.06}, {0.28,5.12,-0.67}, "sombra"},
		{"Nariz", {0.2,0.25,0.12}, {0,4.92,-0.7}, "pele2"},
		{"Barba", {1.0,0.3,0.1}, {0,4.55,-0.67}, "barba"},
		-- braco esquerdo segura o arco
		{"OmbroE", {0.75,1.0,0.75}, {-1.45,3.6,0}, "verde"},
		{"AntebracoE", {0.8,0.8,1.2}, {-1.45,3.0,-0.55}, "couro"},
		{"MaoE", {0.6,0.6,0.6}, {-1.45,3.0,-1.3}, "luva"},
		-- braco direito solto
		{"BracoD", {0.75,1.5,0.75}, {1.45,3.3,0}, "verde"},
		{"BracadeiraD", {0.8,0.4,0.8}, {1.45,2.65,0}, "couro"},
		{"MaoD", {0.6,0.5,0.6}, {1.45,2.25,0}, "luva"},
	}
	return construir("Patrulheiro", base, pecas, { Classe = "Patrulheiro", Papel = "Distancia: ataques de longe, rastreio e batedor do grupo" },
		function(seg)
			local x = -1.45
			local meio = V(x, 3.0, -1.45)
			local cima1, cima2 = V(x, 4.4, -1.72), V(x, 5.7, -1.35)
			local baixo1, baixo2 = V(x, 1.6, -1.72), V(x, 0.3, -1.35)
			seg("ArcoCima1", meio, cima1, 0.24, "madeira")
			seg("ArcoCima2", cima1, cima2, 0.2, "madeira")
			seg("ArcoBaixo1", meio, baixo1, 0.24, "madeira")
			seg("ArcoBaixo2", baixo1, baixo2, 0.2, "madeira")
			seg("Corda", cima2, baixo2, 0.05, "pena")
		end)
end

-- ======================= MONTAR A FILA =======================
local NOME_FILA = "ClassesDePersonagem"
local velha = workspace:FindFirstChild(NOME_FILA)
if velha then velha:Destroy() end
local fila = Instance.new("Folder")
fila.Name = NOME_FILA
fila:SetAttribute("Designer", "Yuri Ramos Hernandez")

local cam = workspace.CurrentCamera
local alvo = cam.CFrame.Position + cam.CFrame.LookVector * 26
local chao = Vector3.new(alvo.X, 0, alvo.Z) -- y = 0 e o topo da Baseplate padrao
local olhar = Vector3.new(cam.CFrame.Position.X, 0, cam.CFrame.Position.Z)
if (olhar - chao).Magnitude < 0.1 then olhar = chao + Vector3.new(0, 0, -1) end
local baseFila = CFrame.lookAt(chao, olhar)

local NOMES_BONITOS = { Cavaleiro = "CAVALEIRO", Clerigo = "CLERIGO", Arcanista = "ARCANISTA", Ladino = "LADINO", Patrulheiro = "PATRULHEIRO" }
local ESPACO = 7
for i, nome in ipairs(CRIAR) do
	local fazer = CLASSES[nome]
	if fazer then
		local x = ((#CRIAR + 1) / 2 - i) * ESPACO -- o primeiro da lista fica a esquerda de quem olha
		local basePedestal = baseFila * CFrame.new(x, 0, 0)
		-- pedestal de pedra
		local ped = Instance.new("Model")
		ped.Name = "Pedestal" .. nome
		ped.Parent = fila
		local topo = novoPart(ped, "Topo", Vector3.new(3.6, 0.5, 3.6), basePedestal * CFrame.new(0, 0.75, 0), "pedra")
		novoPart(ped, "Base", Vector3.new(4.2, 0.5, 4.2), basePedestal * CFrame.new(0, 0.25, 0), "pedra2")
		novoPart(ped, "Placa", Vector3.new(2.4, 0.35, 0.08), basePedestal * CFrame.new(0, 0.75, -1.82), "ouro", "metal")
		for _, p in ipairs(ped:GetChildren()) do p.CanCollide = true end
		-- botoes para testar os golpes no Play
		for _, acao in ipairs({ { "Ataque", Enum.KeyCode.E }, { "Habilidade", Enum.KeyCode.R } }) do
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = "Prompt" .. acao[1]
			prompt.ActionText = acao[1]
			prompt.ObjectText = NOMES_BONITOS[nome] or nome
			prompt.KeyboardKeyCode = acao[2]
			prompt.HoldDuration = 0
			prompt.MaxActivationDistance = 12
			prompt.RequiresLineOfSight = false
			prompt.UIOffset = Vector2.new(0, acao[1] == "Ataque" and 0 or 60)
			prompt:SetAttribute("Alvo", nome)
			prompt:SetAttribute("Acao", acao[1])
			prompt.Parent = topo
		end
		-- nome flutuando em fonte pixel
		local gui = Instance.new("BillboardGui")
		gui.Name = "NomeDaClasse"
		gui.Size = UDim2.fromOffset(200, 36)
		gui.StudsOffsetWorldSpace = Vector3.new(0, 8.6, 0)
		gui.AlwaysOnTop = false
		gui.Adornee = topo
		local rotulo = Instance.new("TextLabel")
		rotulo.Size = UDim2.fromScale(1, 1)
		rotulo.BackgroundTransparency = 1
		rotulo.Text = NOMES_BONITOS[nome] or nome
		rotulo.TextColor3 = Color3.fromRGB(235, 225, 255)
		rotulo.TextStrokeTransparency = 0
		rotulo.Font = Enum.Font.Arcade
		rotulo.TextScaled = true
		rotulo.Parent = gui
		gui.Parent = topo
		-- personagem em cima do pedestal
		local personagem = fazer(basePedestal * CFrame.new(0, 1, 0))
		personagem.Parent = fila
	end
end

-- ======================= ANIMACOES DE COMBATE =======================
local motor = Instance.new("Script")
motor.Name = "AnimacoesDeCombate"
motor:SetAttribute("Vitrine", VITRINE)
motor.Source = [==[
-- Motor das animacoes de combate (design: Yuri Ramos Hernandez)
-- Gira os membros de cada boneco em volta das juntas, quadro a quadro.
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local pasta = script.Parent
local DADOS = require(script:WaitForChild("DadosDeAnimacao"))
local VITRINE = script:GetAttribute("Vitrine") ~= false

local PIVOS = {
	tronco = Vector3.new(0, 2.4, 0), cabeca = Vector3.new(0, 4.6, 0),
	bracoE = Vector3.new(-1.5, 4.0, 0), bracoD = Vector3.new(1.5, 4.0, 0),
	pernaE = Vector3.new(-0.5, 1.5, 0), pernaD = Vector3.new(0.5, 1.5, 0),
}
local PAI = { tronco = "raiz", cabeca = "tronco", bracoE = "tronco", bracoD = "tronco", pernaE = "raiz", pernaD = "raiz" }
local ORDEM = { "tronco", "cabeca", "bracoE", "bracoD", "pernaE", "pernaD" }
local TODAS = { "raiz", "tronco", "cabeca", "bracoE", "bracoD", "pernaE", "pernaD" }
local MEMBRO = { Raiz = "raiz", Tronco = "tronco", Cabeca = "cabeca", BracoE = "bracoE", BracoD = "bracoD", PernaE = "pernaE", PernaD = "pernaD" }
local MISTURA = 0.12
local SEQUENCIA = { "Ataque", "Habilidade", "Ataque", "Dano" }

-- ============ POSES ============
local function valor(pose, j, i)
	local v = pose[j]
	return (v and v[i]) or 0
end

local function misturar(p1, p2, a)
	local saida = {}
	for _, j in ipairs(TODAS) do
		local n = (j == "raiz") and 6 or 3
		local t = {}
		for i = 1, n do
			local x1 = valor(p1, j, i)
			t[i] = x1 + (valor(p2, j, i) - x1) * a
		end
		saida[j] = t
	end
	return saida
end

local function suave(x) return x * x * (3 - 2 * x) end

local function poseEm(anim, t)
	local k = anim.k
	if t <= k[1][1] then return k[1][2] end
	for i = 1, #k - 1 do
		local a, b = k[i], k[i + 1]
		if t <= b[1] then
			return misturar(a[2], b[2], suave((t - a[1]) / (b[1] - a[1])))
		end
	end
	return k[#k][2]
end

local function giro(v, o)
	o = o or 0
	return CFrame.Angles(math.rad(v[1 + o] or 0), math.rad(v[2 + o] or 0), math.rad(v[3 + o] or 0))
end

local function transformacoes(pose)
	local r = pose.raiz or {}
	local T = { raiz = CFrame.new(r[1] or 0, r[2] or 0, r[3] or 0) * giro(r, 3) }
	for _, j in ipairs(ORDEM) do
		local P = PIVOS[j]
		T[j] = T[PAI[j]] * CFrame.new(P) * giro(pose[j] or {}) * CFrame.new(-P)
	end
	return T
end

-- ============ EFEITOS ============
local efeitos = Instance.new("Folder")
efeitos.Name = "EfeitosDeCombate"
efeitos.Parent = workspace

local function cor3(c) return Color3.fromRGB(c[1], c[2], c[3]) end
local function v3(t) return Vector3.new(t[1], t[2], t[3]) end

local function bloquinho(cf, tam, cor, neon)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.Material = (neon == false) and Enum.Material.SmoothPlastic or Enum.Material.Neon
	p.Color = cor
	p.Size = tam
	p.CFrame = cf
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = efeitos
	return p
end

local function animarSumindo(p, tempo, props, estilo)
	props = props or {}
	props.Transparency = 1
	TweenService:Create(p, TweenInfo.new(tempo, estilo or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	Debris:AddItem(p, tempo + 0.1)
end

local FX = {}

FX.arco = function(base, fx)
	local c, r, n = v3(fx.c), fx.r, 12
	local cor = cor3(fx.cor)
	local pts = {}
	for i = 0, n do
		local a = math.rad(fx.a0 + (fx.a1 - fx.a0) * i / n)
		local off
		if fx.plano == "h" then
			off = Vector3.new(r * math.sin(a), 0, -r * math.cos(a))
		else
			off = Vector3.new(0, r * math.sin(a), -r * math.cos(a))
		end
		pts[i] = base * (c + off)
	end
	local cima = (fx.plano == "h") and base.UpVector or base.RightVector
	for i = 0, n - 1 do
		local a, b = pts[i], pts[i + 1]
		local esp = 0.12 + 0.35 * math.sin(math.pi * (i + 0.5) / n)
		local p = bloquinho(CFrame.lookAt((a + b) / 2, b, cima), Vector3.new(esp, esp, (b - a).Magnitude * 1.05), cor)
		p.Transparency = 0.1
		animarSumindo(p, 0.35)
	end
end

FX.anel = function(base, fx)
	local c, n, cor = v3(fx.c), 24, cor3(fx.cor)
	for i = 0, n - 1 do
		local a = i / n * 2 * math.pi
		local giroA = base.Rotation * CFrame.Angles(0, -a, 0)
		local p0 = base * (c + Vector3.new(math.cos(a) * fx.r0, 0, math.sin(a) * fx.r0))
		local p1 = base * (c + Vector3.new(math.cos(a) * fx.r1, fx.subida, math.sin(a) * fx.r1))
		local p = bloquinho(CFrame.new(p0) * giroA, Vector3.new(0.25, 0.25, 0.9), cor)
		animarSumindo(p, fx.dur, { CFrame = CFrame.new(p1) * giroA })
	end
end

FX.faiscas = function(base, fx)
	local c, cor = base * v3(fx.c), cor3(fx.cor)
	for i = 1, fx.n do
		local a, b = i / fx.n * 2 * math.pi, math.random() * 1.2 - 0.2
		local dir = Vector3.new(math.cos(a), b, math.sin(a)).Unit * (1.5 + math.random() * 2.5)
		local p = bloquinho(CFrame.new(c), Vector3.new(0.3, 0.3, 0.3), cor)
		animarSumindo(p, 0.45, { CFrame = CFrame.new(c + dir) * CFrame.Angles(a, a, 0) })
	end
end

FX.projetil = function(base, fx)
	local o = base * v3(fx.o)
	local d = base:VectorToWorldSpace(v3(fx.d)).Unit
	local fim = o + d * fx.dist
	local cor = cor3(fx.cor)
	local cima = (math.abs(d.Y) > 0.95) and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)
	local p = bloquinho(CFrame.lookAt(o, fim, cima), Vector3.new(fx.tam, fx.tam, fx.comp or fx.tam), cor)
	TweenService:Create(p, TweenInfo.new(fx.dur, Enum.EasingStyle.Linear), { CFrame = CFrame.lookAt(fim, fim + d, cima) }):Play()
	Debris:AddItem(p, fx.dur + 0.05)
	if fx.fim then
		task.delay(fx.dur, function()
			local local_fim = base:PointToObjectSpace(fim)
			FX.faiscas(base, { c = { local_fim.X, local_fim.Y, local_fim.Z }, cor = fx.cor, n = 12 })
			FX.anel(base, { c = { local_fim.X, local_fim.Y, local_fim.Z }, r0 = 0.3, r1 = 2.5, subida = 0, cor = fx.cor, dur = 0.4 })
		end)
	end
end

FX.circulo = function(base, fx)
	local c, cor = v3(fx.c), cor3(fx.cor)
	local pecas = {}
	local n = 32
	for i = 0, n - 1 do
		local a = i / n * 2 * math.pi
		local off = CFrame.new(math.cos(a) * fx.r, 0, math.sin(a) * fx.r) * CFrame.Angles(0, -a, 0)
		table.insert(pecas, { bloquinho(base, Vector3.new(0.3, 0.1, 2 * math.pi * fx.r / n * 0.75), cor), off })
	end
	for i = 0, 7 do
		local a = i / 8 * 2 * math.pi
		local off = CFrame.new(math.cos(a) * fx.r * 0.62, 0, math.sin(a) * fx.r * 0.62) * CFrame.Angles(0, -a + math.pi / 4, 0)
		table.insert(pecas, { bloquinho(base, Vector3.new(0.55, 0.1, 0.55), cor), off })
	end
	local t = 0
	local conexao
	conexao = RunService.Heartbeat:Connect(function(dt)
		t = t + dt
		local centro = base * CFrame.new(c) * CFrame.Angles(0, t * 2, 0)
		local alfa = math.clamp((t - fx.dur + 0.3) / 0.3, 0, 1)
		for _, pc in ipairs(pecas) do
			pc[1].CFrame = centro * pc[2]
			pc[1].Transparency = alfa
		end
		if t >= fx.dur then
			conexao:Disconnect()
			for _, pc in ipairs(pecas) do pc[1]:Destroy() end
		end
	end)
end

FX.coluna = function(base, fx)
	local c = base * v3(fx.c)
	local p = bloquinho(CFrame.new(c + base.UpVector * 0.05) * base.Rotation, Vector3.new(fx.w, 0.1, fx.w), cor3(fx.cor))
	p.Transparency = 0.2
	animarSumindo(p, fx.dur, { Size = Vector3.new(fx.w * 0.5, fx.h, fx.w * 0.5), CFrame = CFrame.new(c + base.UpVector * fx.h / 2) * base.Rotation })
end

FX.fumaca = function(base, fx)
	local c = base * v3(fx.c)
	for i = 1, fx.n do
		local a = i / fx.n * 2 * math.pi
		local dir = Vector3.new(math.cos(a) * 1.6, 1 + math.random() * 1.5, math.sin(a) * 1.6)
		local p = bloquinho(CFrame.new(c), Vector3.new(0.9, 0.9, 0.9), Color3.fromRGB(46, 36, 60), false)
		p.Transparency = 0.2
		animarSumindo(p, 0.6, { CFrame = CFrame.new(c + dir) * CFrame.Angles(a, 0, a), Size = Vector3.new(0.3, 0.3, 0.3) })
	end
end

FX.chuva = function(base, fx)
	local c, cor = v3(fx.c), cor3(fx.cor)
	for i = 1, fx.n do
		task.delay(i * 0.05, function()
			local a, r = math.random() * 2 * math.pi, math.sqrt(math.random()) * fx.raio
			local chao = base * (c + Vector3.new(math.cos(a) * r, 0.6, math.sin(a) * r))
			local alto = chao + Vector3.new(0, 14, 0)
			local p = bloquinho(CFrame.lookAt(alto, chao, Vector3.new(0, 0, 1)), Vector3.new(0.25, 0.25, 2.2), cor)
			TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Linear), { CFrame = CFrame.lookAt(chao, chao - Vector3.new(0, 1, 0), Vector3.new(0, 0, 1)) }):Play()
			task.delay(0.35, function() animarSumindo(p, 0.5) end)
		end)
	end
end

-- ============ PERSONAGENS ============
local personagens = {}

local function animDe(info, nome)
	return (DADOS[info.classe] and DADOS[info.classe][nome]) or DADOS.Comum[nome]
end

local function tocar(info, nome)
	if not animDe(info, nome) then return end
	local normal = {}
	for j, v in pairs(info.ultima) do
		local c = {}
		for i, x in ipairs(v) do
			if j ~= "raiz" or i > 3 then x = ((x + 180) % 360) - 180 end
			c[i] = x
		end
		normal[j] = c
	end
	info.de, info.deT = normal, 0
	info.anim, info.t, info.disparados = nome, 0, {}
end

for i, m in ipairs(pasta:GetChildren()) do
	if m:IsA("Model") and m:GetAttribute("Classe") then
		local base = m.WorldPivot
		local pecas = {}
		for _, p in ipairs(m:GetDescendants()) do
			if p:IsA("BasePart") then
				table.insert(pecas, {
					parte = p,
					membro = MEMBRO[p:GetAttribute("Membro") or "Tronco"] or "tronco",
					offset = base:ToObjectSpace(p.CFrame),
				})
			end
		end
		local info = {
			modelo = m, base = base, pecas = pecas, classe = m:GetAttribute("Classe"),
			anim = "Parado", t = (i * 0.37) % 1.6, ultima = {}, disparados = {}, deT = 1,
			espera = 1.5 + i * 0.8, passo = 1,
		}
		table.insert(personagens, info)
		m:GetAttributeChangedSignal("Animacao"):Connect(function()
			local nome = m:GetAttribute("Animacao")
			if nome and nome ~= "" then
				tocar(info, nome)
				info.espera = 4
				m:SetAttribute("Animacao", "")
			end
		end)
	end
end

-- botoes dos pedestais
for _, prompt in ipairs(pasta:GetDescendants()) do
	if prompt:IsA("ProximityPrompt") and prompt:GetAttribute("Alvo") then
		prompt.Triggered:Connect(function()
			local alvo = pasta:FindFirstChild(prompt:GetAttribute("Alvo"))
			if alvo then alvo:SetAttribute("Animacao", prompt:GetAttribute("Acao")) end
		end)
	end
end

local function atualizar(info, dt)
	local a = animDe(info, info.anim)
	info.t = info.t + dt
	if a.loop then
		if info.t > a.dur then info.t = info.t % a.dur end
		if VITRINE then
			info.espera = info.espera - dt
			if info.espera <= 0 then
				tocar(info, SEQUENCIA[info.passo])
				info.passo = info.passo % #SEQUENCIA + 1
				info.espera = 2.2
				a = animDe(info, info.anim)
			end
		end
	elseif info.t >= a.dur then
		tocar(info, "Parado")
		a = animDe(info, "Parado")
	end
	local pose = poseEm(a, info.t)
	if info.de and info.deT < MISTURA then
		info.deT = info.deT + dt
		pose = misturar(info.de, pose, suave(math.min(1, info.deT / MISTURA)))
	end
	info.ultima = pose
	if a.fx then
		for i, fx in ipairs(a.fx) do
			if not info.disparados[i] and info.t >= fx.t then
				info.disparados[i] = true
				local f = FX[fx.fx]
				if f then task.spawn(f, info.base, fx) end
			end
		end
	end
	local T = transformacoes(pose)
	for _, pc in ipairs(info.pecas) do
		pc.parte.CFrame = info.base * T[pc.membro] * pc.offset
	end
end

RunService.Heartbeat:Connect(function(dt)
	for _, info in ipairs(personagens) do
		atualizar(info, math.min(dt, 0.1))
	end
end)
]==]
local dados = Instance.new("ModuleScript")
dados.Name = "DadosDeAnimacao"
dados.Source = [==[
-- Dados das animacoes de combate (design: Yuri Ramos Hernandez)
-- Cada animacao: dur (segundos), loop, k = lista de quadros-chave {tempo, pose}, fx = efeitos.
-- Pose: raiz = {x, y, z, giroX, giroY, giroZ}; tronco, cabeca, bracoE, bracoD, pernaE, pernaD = {giroX, giroY, giroZ} em graus.
-- giroX positivo leva o braco para frente e para cima; no tronco, inclina para tras.
local AZUL = {170, 210, 255}
local OURO = {255, 214, 110}
local VIOLETA = {180, 110, 255}
local PENA = {240, 236, 226}

return {
	Comum = {
		Parado = { dur = 1.6, loop = true, k = {
			{0,   { tronco = {-4, 0, 0}, bracoE = {4, 0, -4}, bracoD = {4, 0, 4} }},
			{0.8, { raiz = {0, -0.08, 0}, tronco = {-7, 0, 0}, cabeca = {3, 0, 0}, bracoE = {8, 0, -6}, bracoD = {8, 0, 6} }},
			{1.6, { tronco = {-4, 0, 0}, bracoE = {4, 0, -4}, bracoD = {4, 0, 4} }},
		}},
		Dano = { dur = 0.55, k = {
			{0,    {}},
			{0.08, { raiz = {0, 0, 0.5}, tronco = {16, 0, 0}, cabeca = {14, 0, 0}, bracoE = {-12, 0, -14}, bracoD = {-12, 0, 14} }},
			{0.55, {}},
		}, fx = {
			{ t = 0.04, fx = "faiscas", c = {0, 3.6, -1}, cor = {255, 70, 80}, n = 10 },
		}},
	},

	Cavaleiro = {
		Ataque = { dur = 0.95, k = {
			{0,    {}},
			{0.28, { bracoD = {140, 0, 8}, tronco = {8, -18, 0}, raiz = {0, 0, 0.2}, pernaE = {-10, 0, 0}, cabeca = {-6, 0, 0} }},
			{0.42, { bracoD = {-55, 0, 6}, tronco = {-18, 16, 0}, raiz = {0, -0.15, -0.8}, pernaD = {22, 0, 0}, pernaE = {-16, 0, 0} }},
			{0.62, { bracoD = {-50, 0, 6}, tronco = {-14, 12, 0}, raiz = {0, -0.15, -0.8}, pernaD = {20, 0, 0}, pernaE = {-14, 0, 0} }},
			{0.95, {}},
		}, fx = {
			{ t = 0.32, fx = "arco", plano = "v", c = {1.5, 4.0, -0.6}, r = 5.2, a0 = 150, a1 = -40, cor = AZUL },
		}},
		Habilidade = { dur = 1.3, k = {
			{0,    {}},
			{0.25, { bracoD = {70, 0, 30}, tronco = {-10, -50, 0}, raiz = {0, -0.3, 0}, pernaD = {15, 0, 0}, pernaE = {-15, 0, 0} }},
			{0.8,  { bracoD = {70, 0, 30}, tronco = {-10, -50, 0}, raiz = {0, -0.3, 0, 0, 360, 0}, pernaD = {15, 0, 0}, pernaE = {-15, 0, 0} }},
			{1.3,  { raiz = {0, 0, 0, 0, 360, 0} }},
		}, fx = {
			{ t = 0.35, fx = "anel", c = {0, 3.2, 0}, r0 = 2, r1 = 6.5, subida = 0, cor = AZUL, dur = 0.5 },
			{ t = 0.55, fx = "anel", c = {0, 3.0, 0}, r0 = 2, r1 = 7.5, subida = 0, cor = AZUL, dur = 0.5 },
		}},
	},

	Clerigo = {
		Ataque = { dur = 0.9, k = {
			{0,    {}},
			{0.28, { bracoD = {130, 0, 6}, tronco = {10, -10, 0}, raiz = {0, 0.1, 0.2} }},
			{0.42, { bracoD = {-45, 0, 4}, tronco = {-22, 10, 0}, raiz = {0, -0.25, -0.6}, pernaD = {20, 0, 0}, pernaE = {-12, 0, 0}, bracoE = {20, 0, -6} }},
			{0.6,  { bracoD = {-42, 0, 4}, tronco = {-20, 8, 0}, raiz = {0, -0.25, -0.6}, pernaD = {18, 0, 0}, pernaE = {-10, 0, 0}, bracoE = {18, 0, -6} }},
			{0.9,  {}},
		}, fx = {
			{ t = 0.4, fx = "faiscas", c = {1.5, 1.0, -3.2}, cor = OURO, n = 14 },
			{ t = 0.4, fx = "anel", c = {1.5, 0.2, -3.2}, r0 = 0.5, r1 = 3, subida = 0, cor = OURO, dur = 0.45 },
		}},
		Habilidade = { dur = 1.5, k = {
			{0,    {}},
			{0.35, { bracoD = {165, 0, -8}, bracoE = {35, 0, -10}, cabeca = {18, 0, 0}, tronco = {8, 0, 0}, raiz = {0, 0.3, 0} }},
			{1.1,  { bracoD = {165, 0, -8}, bracoE = {35, 0, -10}, cabeca = {18, 0, 0}, tronco = {8, 0, 0}, raiz = {0, 0.35, 0} }},
			{1.5,  {}},
		}, fx = {
			{ t = 0.4, fx = "anel", c = {0, 0.2, 0}, r0 = 1, r1 = 4.5, subida = 6, cor = OURO, dur = 1.0 },
			{ t = 0.5, fx = "faiscas", c = {1.5, 7.5, 0.5}, cor = {255, 236, 170}, n = 16 },
			{ t = 0.7, fx = "anel", c = {0, 0.2, 0}, r0 = 1, r1 = 4.5, subida = 6, cor = OURO, dur = 1.0 },
		}},
	},

	Arcanista = {
		Ataque = { dur = 0.9, k = {
			{0,    {}},
			{0.22, { bracoD = {25, 0, 10}, tronco = {6, -14, 0} }},
			{0.42, { bracoD = {-60, 0, 4}, tronco = {-12, 12, 0}, raiz = {0, 0, -0.3}, bracoE = {30, 0, -10} }},
			{0.6,  { bracoD = {-58, 0, 4}, tronco = {-10, 10, 0}, raiz = {0, 0, -0.3}, bracoE = {26, 0, -10} }},
			{0.9,  {}},
		}, fx = {
			{ t = 0.42, fx = "projetil", o = {1.5, 3.9, -3.6}, d = {0, 0, -1}, dist = 28, dur = 0.55, tam = 0.8, cor = VIOLETA, fim = true },
		}},
		Habilidade = { dur = 1.8, k = {
			{0,    {}},
			{0.3,  { bracoD = {-35, 0, -15}, bracoE = {0, 0, -110}, raiz = {0, 0.6, 0}, cabeca = {10, 0, 0}, tronco = {6, 0, 0} }},
			{1.2,  { bracoD = {-35, 0, -15}, bracoE = {0, 0, -110}, raiz = {0, 0.9, 0}, cabeca = {10, 0, 0}, tronco = {6, 0, 0} }},
			{1.35, { bracoD = {-70, 0, 10}, bracoE = {-10, 0, -20}, tronco = {-15, 0, 0}, raiz = {0, 0.2, -0.2} }},
			{1.8,  {}},
		}, fx = {
			{ t = 0.25, fx = "circulo", c = {0, 0.1, 0}, r = 4.5, cor = VIOLETA, dur = 1.3 },
			{ t = 1.35, fx = "coluna", c = {0, 0, -6}, h = 10, w = 2.4, cor = VIOLETA, dur = 0.6 },
			{ t = 1.35, fx = "anel", c = {0, 0.3, -6}, r0 = 0.5, r1 = 5, subida = 0, cor = VIOLETA, dur = 0.6 },
			{ t = 1.35, fx = "faiscas", c = {0, 1, -6}, cor = {220, 180, 255}, n = 20 },
		}},
	},

	Ladino = {
		Ataque = { dur = 0.75, k = {
			{0,    {}},
			{0.12, { bracoD = {75, 0, -10}, bracoE = {-25, 0, 0}, tronco = {-14, 18, 0}, raiz = {0, -0.2, -0.6} }},
			{0.26, { bracoE = {75, 0, 10}, bracoD = {-25, 0, 0}, tronco = {-14, -18, 0}, raiz = {0, -0.2, -0.9} }},
			{0.42, { bracoE = {60, 0, 10}, bracoD = {-15, 0, 0}, tronco = {-10, -12, 0}, raiz = {0, -0.2, -0.9} }},
			{0.75, {}},
		}, fx = {
			{ t = 0.1,  fx = "arco", plano = "h", c = {0, 2.6, -0.6}, r = 2.6, a0 = -70, a1 = 50, cor = {200, 230, 220} },
			{ t = 0.24, fx = "arco", plano = "h", c = {0, 2.6, -0.9}, r = 2.6, a0 = 70, a1 = -50, cor = {200, 230, 220} },
		}},
		Habilidade = { dur = 1.2, k = {
			{0,    {}},
			{0.22, { raiz = {0, -0.6, 0.3}, tronco = {-28, 0, 0}, bracoE = {-40, 0, -10}, bracoD = {-40, 0, 10}, pernaE = {-30, 0, 0}, pernaD = {30, 0, 0} }},
			{0.42, { raiz = {0, -0.3, -7}, tronco = {-35, 0, 0}, bracoE = {-60, 0, -10}, bracoD = {-60, 0, 10} }},
			{0.55, { raiz = {0, -0.2, -7.5}, tronco = {-10, 0, 0}, bracoE = {95, 0, -20}, bracoD = {95, 0, 20} }},
			{0.8,  { raiz = {0, -0.2, -7.5}, bracoE = {70, 0, -20}, bracoD = {70, 0, 20} }},
			{1.2,  {}},
		}, fx = {
			{ t = 0.25, fx = "fumaca", c = {0, 1.5, 0}, n = 12 },
			{ t = 0.55, fx = "arco", plano = "h", c = {0, 2.6, -8}, r = 2.8, a0 = -80, a1 = 80, cor = {160, 120, 200} },
			{ t = 0.85, fx = "fumaca", c = {0, 1.5, -7.5}, n = 12 },
		}},
	},

	Patrulheiro = {
		Ataque = { dur = 1.1, k = {
			{0,    {}},
			{0.3,  { bracoE = {-5, 0, -4}, bracoD = {80, 0, -25}, tronco = {0, -25, 0}, cabeca = {0, 20, 0} }},
			{0.55, { bracoE = {-5, 0, -4}, bracoD = {70, 0, -5}, tronco = {0, -25, 0}, cabeca = {0, 20, 0} }},
			{0.62, { bracoE = {-5, 0, -4}, bracoD = {40, 0, 10}, tronco = {6, -25, 0}, cabeca = {0, 20, 0} }},
			{1.1,  {}},
		}, fx = {
			{ t = 0.6, fx = "projetil", o = {-1.45, 3.0, -2.0}, d = {0, 0, -1}, dist = 40, dur = 0.5, tam = 0.25, comp = 2.2, cor = PENA },
		}},
		Habilidade = { dur = 1.5, k = {
			{0,    {}},
			{0.35, { bracoE = {-45, 0, -4}, bracoD = {40, 0, -10}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{0.5,  { bracoE = {-45, 0, -4}, bracoD = {60, 0, -5}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{0.9,  { bracoE = {-45, 0, -4}, bracoD = {60, 0, -5}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{1.5,  {}},
		}, fx = {
			{ t = 0.5,  fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {0, 0.8, -0.6}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 0.65, fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {0.15, 0.8, -0.58}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 0.8,  fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {-0.15, 0.8, -0.58}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 1.0,  fx = "chuva", c = {0, 0, -12}, raio = 5, n = 14, cor = PENA },
		}},
	},
}
]==]
dados.Parent = motor
motor.Parent = fila

fila.Parent = workspace
game:GetService("Selection"):Set({ fila })
print("Classes criadas: " .. table.concat(CRIAR, ", ") .. ". Design: Yuri Ramos Hernandez")
