--[[
	A TOCA DA TECELA FAMINTA
	Masmorra para personagens de nivel 5 a 7
	Design: Yuri Ramos Hernandez

	Mesmo estilo do Arcanista do Veu: tudo em blocos, paleta escura,
	contorno pixel art nos personagens e brilhos neon.

	As cinco areas ficam em sequencia, do inicio (x = 0) ate a torre (x ~ 400):
	  1. As Escadas Ingremes   - subida estreita, degraus quebrados, vigia orc ao longe
	  2. O Tunel do Fedor      - escuridao magica, ar putrido, ossos pelo chao
	  3. O Labirinto de Teias  - corredores, becos sem saida, teias e crias de aranha
	  4. O Covil               - casulos com prisioneiros e a Tecela Faminta
	  5. A Saida Vigiada       - torre orc com cela (gancho de resgate)

	Como usar:
	  Roblox Studio > aba View > Command Bar > cole tudo > Enter
	  Depois aperte Play e entre pelo SpawnLocation, no pe da escada.

	O que funciona no Play:
	  - Cada area escurece e muda a cor da tela ao entrar, e mostra o teste da area.
	  - Teias brancas: clique para cortar (crescem de novo em 2 minutos).
	  - Teias violeta: so cortam se o jogador estiver segurando uma ferramenta
	    com "tocha" ou "fogo" no nome, ou com o atributo Magica = true.
	  - Casulos que se mexem tem prisioneiros vivos: segure E para libertar.
	  - A Tecela desperta e desce da teia quando alguem entra no Covil.
	  - Aranhas vivas: as crias passeiam, perseguem e mordem quem chega perto.
	    A Tecela morde quem esta perto, cospe teia (prende o jogador por 3 s)
	    e entra em furia com metade da vida. Clique numa aranha para dar dano.

	Se rodar de novo, a versao anterior e apagada e criada outra vez.
]]

-- Mude aqui para construir em outro lugar do mapa
local ORIGEM = CFrame.new(0, 0, 0)
-- Deixa o ceu de noite com neblina. Coloque false para nao mexer na iluminacao.
local AJUSTAR_ILUMINACAO = true

local NOME = "TocaDaTecelaFaminta"
local antigo = workspace:FindFirstChild(NOME)
if antigo then antigo:Destroy() end

local raiz = Instance.new("Folder")
raiz.Name = NOME
raiz:SetAttribute("Designer", "Yuri Ramos Hernandez")
raiz:SetAttribute("Nivel", "5 a 7")

local function pasta(nome, pai)
	local f = Instance.new("Folder")
	f.Name = nome
	f.Parent = pai or raiz
	return f
end

local Z1 = pasta("1_EscadasIngremes")
local Z2 = pasta("2_TunelDoFedor")
local Z3 = pasta("3_LabirintoDeTeias")
local Z4 = pasta("4_Covil")
local Z5 = pasta("5_SaidaVigiada")
local zonasF = pasta("Zonas")

-- Todos os personagens ficam num modelo so, para um unico contorno pixel art
local personagens = Instance.new("Model")
personagens.Name = "Personagens"
personagens.Parent = raiz

-- ===================== PALETA =====================
local C = {
	rocha      = Color3.fromRGB(52, 50, 60),
	rocha2     = Color3.fromRGB(64, 61, 74),
	rochaEsc   = Color3.fromRGB(36, 34, 42),
	rochaClara = Color3.fromRGB(88, 84, 98),
	terra      = Color3.fromRGB(58, 49, 46),
	osso       = Color3.fromRGB(214, 206, 186),
	ossoEsc    = Color3.fromRGB(168, 158, 138),
	sombra     = Color3.fromRGB(14, 12, 20),
	teia       = Color3.fromRGB(226, 226, 236),
	teiaForte  = Color3.fromRGB(190, 150, 255),
	casulo     = Color3.fromRGB(204, 198, 184),
	casuloEsc  = Color3.fromRGB(160, 154, 140),
	aranha     = Color3.fromRGB(28, 24, 32),
	aranha2    = Color3.fromRGB(46, 40, 52),
	olhoCria   = Color3.fromRGB(255, 60, 80),
	carmim     = Color3.fromRGB(128, 28, 40),
	pele       = Color3.fromRGB(214, 170, 140),
	lodo       = Color3.fromRGB(78, 98, 56),
	runa       = Color3.fromRGB(130, 90, 200),
	orcPele    = Color3.fromRGB(86, 110, 60),
	orcPele2   = Color3.fromRGB(68, 90, 48),
	olhoOrc    = Color3.fromRGB(255, 70, 40),
	couro      = Color3.fromRGB(78, 54, 38),
	couroEsc   = Color3.fromRGB(52, 36, 26),
	ferro      = Color3.fromRGB(64, 64, 74),
	madeira    = Color3.fromRGB(92, 64, 42),
	madeira2   = Color3.fromRGB(70, 48, 32),
	pedraTorre = Color3.fromRGB(76, 72, 78),
	pedraTorre2= Color3.fromRGB(58, 55, 62),
	fogo       = Color3.fromRGB(255, 140, 50),
	fogo2      = Color3.fromRGB(255, 60, 20),
	palha      = Color3.fromRGB(150, 122, 70),
	mantoGuia  = Color3.fromRGB(74, 68, 60),
	peleGuia   = Color3.fromRGB(176, 186, 164),
	olhoGuia   = Color3.fromRGB(214, 255, 200),
	violeta    = Color3.fromRGB(180, 120, 255),
	-- boss
	carapaca     = Color3.fromRGB(34, 30, 40),
	carapaca2    = Color3.fromRGB(52, 46, 60),
	articulacao  = Color3.fromRGB(118, 112, 126),
	cristal      = Color3.fromRGB(176, 92, 255),
	cristal2     = Color3.fromRGB(104, 52, 176),
	cristalClaro = Color3.fromRGB(232, 200, 255),
}

local M = {
	plastico = Enum.Material.SmoothPlastic,
	metal    = Enum.Material.Metal,
	neon     = Enum.Material.Neon,
}

local SMOOTH = Enum.SurfaceType.Smooth

-- Gerador aleatorio com semente fixa: a masmorra sai igual toda vez
local semente = 20261028 % 2147483647
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

-- Bloco em coordenadas da masmorra
local function bloco(pai, nome, sx, sy, sz, x, y, z, cor, mat, rot, transp)
	local cf = ORIGEM * CFrame.new(x, y, z)
	if rot then cf = cf * rot end
	return novoPart(pai, nome, Vector3.new(sx, sy, sz), cf, cor, mat, transp)
end

-- Ponto da masmorra em coordenadas do mundo
local function W(x, y, z) return ORIGEM * Vector3.new(x, y, z) end

-- Bloco ligando dois pontos do mundo (pernas, fios, raios da teia)
local function liga(pai, nome, a, b, esp, cor, mat, transp)
	local d = b - a
	local cima = Vector3.new(0, 1, 0)
	if math.abs(d.Unit.Y) > 0.98 then cima = Vector3.new(0, 0, 1) end
	local meio = (a + b) / 2
	return novoPart(pai, nome, Vector3.new(esp, esp, d.Magnitude), CFrame.lookAt(meio, b, cima), cor, mat, transp)
end

-- Bloco em coordenadas locais de um personagem
local function blocoL(pai, nome, base, sx, sy, sz, lx, ly, lz, cor, mat, rot)
	local cf = base * CFrame.new(lx, ly, lz)
	if rot then cf = cf * rot end
	return novoPart(pai, nome, Vector3.new(sx, sy, sz), cf, cor, mat)
end

local function ligaL(pai, nome, base, a, b, esp, cor, mat)
	return liga(pai, nome, base * a, base * b, esp, cor, mat)
end

local function luz(parte, cor, alcance, brilho)
	local l = Instance.new("PointLight")
	l.Color = C[cor]
	l.Range = alcance
	l.Brightness = brilho or 1
	l.Parent = parte
	return l
end

local function fogo(parte)
	local f = Instance.new("Fire")
	f.Size = 3
	f.Heat = 6
	f.Color = C.fogo
	f.SecondaryColor = C.fogo2
	f.Parent = parte
	luz(parte, "fogo", 18, 1.6)
end

local function chama(pai, x, y, z)
	bloco(pai, "Braseiro", 0.9, 0.5, 0.9, x, y, z, "ferro", "metal")
	local c = bloco(pai, "Chama", 0.55, 0.75, 0.55, x, y + 0.6, z, "fogo", "neon")
	c.CanCollide = false
	fogo(c)
	return c
end

local function zona(nome, sx, sy, sz, x, y, z, info)
	local p = bloco(zonasF, nome, sx, sy, sz, x, y, z, "rocha", nil, nil, 1)
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	for chave, valor in pairs(info) do p:SetAttribute(chave, valor) end
	return p
end

-- Pico de montanha em degraus
local function pico(pai, x, y, z, larg, alt)
	local niveis = 4
	for k = 0, niveis - 1 do
		local f = 1 - k * 0.22
		local cor = (k == niveis - 1) and "rochaClara" or ((k % 2 == 0) and "rocha2" or "rocha")
		bloco(pai, "Pico", larg * f, alt / niveis, larg * f * 0.85, x, y + alt / niveis * (k + 0.5), z, cor)
	end
end

-- ===================== OSSOS =====================
local function osso(pai, x, y, z, g)
	local base = ORIGEM * CFrame.new(x, y, z) * rotY(g)
	blocoL(pai, "Osso", base, 1.6, 0.25, 0.25, 0, 0.13, 0, "osso")
	blocoL(pai, "OssoPonta", base, 0.4, 0.4, 0.4, -0.85, 0.2, 0, "osso")
	blocoL(pai, "OssoPonta", base, 0.4, 0.4, 0.4, 0.85, 0.2, 0, "osso")
end

local function cranio(pai, x, y, z, g)
	local base = ORIGEM * CFrame.new(x, y, z) * rotY(g)
	blocoL(pai, "Cranio", base, 0.9, 0.8, 0.9, 0, 0.4, 0, "osso")
	blocoL(pai, "Mandibula", base, 0.6, 0.25, 0.5, 0, 0.12, -0.3, "ossoEsc")
	blocoL(pai, "Orbita", base, 0.22, 0.22, 0.05, -0.2, 0.5, -0.46, "sombra")
	blocoL(pai, "Orbita", base, 0.22, 0.22, 0.05, 0.2, 0.5, -0.46, "sombra")
end

local function ossada(pai, n, x1, x2, z1, z2, y)
	local f = Instance.new("Model")
	f.Name = "Ossos"
	f.Parent = pai
	for _ = 1, n do
		local x, z, g = entre(x1, x2), entre(z1, z2), rnd() * 180
		if rnd() < 0.15 then cranio(f, x, y, z, g) else osso(f, x, y, z, g) end
	end
	for _, p in ipairs(f:GetChildren()) do p.CanCollide = false end
end

-- ===================== PERSONAGENS =====================
local function aranha(nome, base, s, corOlho)
	local m = Instance.new("Model")
	m.Name = nome
	m.Parent = personagens
	local function b(n, sx, sy, sz, lx, ly, lz, cor, mat, grupo)
		local p = blocoL(m, n, base, sx * s, sy * s, sz * s, lx * s, ly * s, lz * s, cor, mat)
		p:SetAttribute("Grupo", grupo or "Corpo")
		return p
	end
	b("Abdomen", 1.6, 1.3, 1.9, 0, 1.15, 0.95, "aranha", nil, "Abdomen")
	b("AbdomenTopo", 1.2, 0.3, 1.5, 0, 1.9, 0.95, "aranha2", nil, "Abdomen")
	b("Marca", 0.5, 0.1, 0.7, 0, 2.08, 0.95, "carmim", nil, "Abdomen")
	b("Torax", 1.1, 0.8, 1.1, 0, 0.95, -0.5, "aranha2")
	b("Cabeca", 0.8, 0.6, 0.5, 0, 1.05, -1.2, "aranha", nil, "Cabeca")
	local olhos = { {-0.18, 1.2, -1.46}, {0.18, 1.2, -1.46}, {-0.33, 1.05, -1.43}, {0.33, 1.05, -1.43} }
	for i, o in ipairs(olhos) do
		local e = b("Olho" .. i, 0.16, 0.16, 0.08, o[1], o[2], o[3], corOlho, "neon", "Cabeca")
		e:SetAttribute("Olho", true)
	end
	b("PresaE", 0.12, 0.35, 0.12, -0.14, 0.62, -1.4, "ossoEsc", nil, "PresaE")
	b("PresaD", 0.12, 0.35, 0.12, 0.14, 0.62, -1.4, "ossoEsc", nil, "PresaD")
	-- patas: cada uma guarda os pontos das juntas para a animacao
	for _, lado in ipairs({-1, 1}) do
		for k = 0, 3 do
			local idx = ((lado < 0) and 0 or 4) + k + 1
			local pts = {
				Vector3.new(lado * 0.5 * s, 0.95 * s, (-0.8 + k * 0.4) * s),
				Vector3.new(lado * 1.6 * s, 2.0 * s, (-1.6 + k * 0.95) * s),
				Vector3.new(lado * 2.5 * s, 0.05 * s, (-2.3 + k * 1.5) * s),
			}
			for i, p in ipairs(pts) do m:SetAttribute(("P%d_%d"):format(idx, i), p) end
			local coxa = ligaL(m, "Perna", base, pts[1], pts[2], 0.2 * s, "aranha2")
			local pata = ligaL(m, "Pata", base, pts[2], pts[3], 0.16 * s, "aranha")
			for i, seg in ipairs({ coxa, pata }) do
				seg:SetAttribute("Perna", idx)
				seg:SetAttribute("IA", i)
				seg:SetAttribute("IB", i + 1)
			end
		end
	end
	for _, p in ipairs(m:GetChildren()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
	m:SetAttribute("Aranha", true)
	m:SetAttribute("Escala", s)
	m:SetAttribute("Pontos", 3)
	m:SetAttribute("PivoCorpo", Vector3.new(0, 0.95 * s, 0))
	m:SetAttribute("PivoAbdomen", Vector3.new(0, 1.15 * s, 0.05 * s))
	m:SetAttribute("PivoCabeca", Vector3.new(0, 1.0 * s, -0.95 * s))
	m:SetAttribute("PivoPresaE", Vector3.new(-0.14 * s, 0.8 * s, -1.4 * s))
	m:SetAttribute("PivoPresaD", Vector3.new(0.14 * s, 0.8 * s, -1.4 * s))
	m:SetAttribute("Passada", 1.3 * s)
	m:SetAttribute("AlturaPasso", 0.7 * s)
	m:SetAttribute("Frequencia", 2.4)
	m:SetAttribute("Vida", 30)
	m:SetAttribute("VidaMax", 30)
	m.WorldPivot = base
	return m
end

local function orc(nome, base, comEscudo)
	local m = Instance.new("Model")
	m.Name = nome
	m.Parent = personagens
	m:SetAttribute("Inimigo", "Orc vigia")
	local function b(n, sx, sy, sz, lx, ly, lz, cor, mat, rot)
		return blocoL(m, n, base, sx, sy, sz, lx, ly, lz, cor, mat, rot)
	end
	for _, x in ipairs({-0.5, 0.5}) do
		b("Bota", 0.8, 0.6, 1.1, x, 0.3, -0.05, "ferro", "metal")
		b("Perna", 0.75, 1.4, 0.75, x, 1.3, 0, "couro")
	end
	b("Saia", 2.1, 0.8, 1.4, 0, 2.2, 0, "couro")
	b("Cinto", 2.3, 0.3, 1.5, 0, 2.6, 0, "couroEsc")
	b("Armadura", 2.2, 1.8, 1.4, 0, 3.5, 0, "ferro", "metal")
	for _, x in ipairs({-1.45, 1.45}) do
		b("Ombreira", 0.9, 0.5, 1.2, x, 4.35, 0, "ferro", "metal")
		b("Espinho", 0.2, 0.45, 0.2, x * 1.1, 4.8, 0, "osso")
		b("Braco", 0.7, 1.7, 0.7, x, 3.35, 0, "orcPele")
		b("Mao", 0.7, 0.5, 0.7, x, 2.25, -0.2, "orcPele")
	end
	b("Cabeca", 1.5, 1.3, 1.4, 0, 5.0, -0.05, "orcPele")
	b("Mandibula", 1.6, 0.5, 1.3, 0, 4.4, -0.15, "orcPele2")
	b("PresaE", 0.18, 0.4, 0.18, -0.45, 4.8, -0.82, "osso")
	b("PresaD", 0.18, 0.4, 0.18, 0.45, 4.8, -0.82, "osso")
	b("OlhoE", 0.3, 0.15, 0.08, -0.35, 5.2, -0.78, "olhoOrc", "neon")
	b("OlhoD", 0.3, 0.15, 0.08, 0.35, 5.2, -0.78, "olhoOrc", "neon")
	b("Elmo", 1.7, 0.6, 1.6, 0, 5.8, 0, "ferro", "metal")
	b("ElmoPonta", 0.3, 0.6, 0.3, 0, 6.35, 0, "ferro", "metal")
	-- lanca na mao direita
	b("Lanca", 0.25, 7.4, 0.25, 1.45, 3.8, -0.35, "madeira")
	b("LancaPonta", 0.45, 1.0, 0.45, 1.45, 8.0, -0.35, "ferro", "metal", rotY(45))
	if comEscudo then
		b("Escudo", 0.25, 1.8, 1.5, -1.95, 3.0, 0, "madeira2")
		b("EscudoCentro", 0.15, 0.6, 0.6, -2.1, 3.0, 0, "ferro", "metal")
	end
	for _, p in ipairs(m:GetChildren()) do p.CanCollide = false end
	return m
end

local function guia(base)
	local m = Instance.new("Model")
	m.Name = "GuiaTraicoeiro"
	m.Parent = personagens
	m:SetAttribute("Nome", "O guia traicoeiro")
	m:SetAttribute("Nota", "Guia o grupo pela escada e some aqui, na entrada do tunel")
	local function b(n, sx, sy, sz, lx, ly, lz, cor, mat, rot)
		return blocoL(m, n, base, sx, sy, sz, lx, ly, lz, cor, mat, rot)
	end
	b("Manto", 1.8, 1.6, 1.6, 0, 0.8, 0, "mantoGuia")
	b("Rasgo", 0.4, 0.5, 0.12, -0.5, 0.15, -0.82, "couroEsc")
	b("Rasgo", 0.3, 0.4, 0.12, 0.4, 0.2, -0.82, "couroEsc")
	b("Tronco", 1.6, 1.4, 1.4, 0, 2.1, -0.2, "mantoGuia", nil, CFrame.Angles(math.rad(-20), 0, 0))
	b("Corcunda", 1.4, 0.9, 1.2, 0, 2.85, 0.25, "mantoGuia")
	b("Capuz", 1.4, 1.2, 1.3, 0, 3.0, -0.85, "mantoGuia")
	b("Rosto", 1.0, 0.8, 0.1, 0, 2.9, -1.52, "sombra")
	b("OlhoE", 0.22, 0.12, 0.06, -0.25, 3.0, -1.6, "olhoGuia", "neon")
	b("OlhoD", 0.22, 0.12, 0.06, 0.25, 3.0, -1.6, "olhoGuia", "neon")
	for _, x in ipairs({-0.7, 0.7}) do
		ligaL(m, "Braco", base, Vector3.new(x, 2.6, -0.6), Vector3.new(x * 0.85, 1.6, -1.4), 0.32, "mantoGuia")
		b("Mao", 0.35, 0.5, 0.25, x * 0.85, 1.4, -1.45, "peleGuia")
	end
	for _, p in ipairs(m:GetChildren()) do p.CanCollide = false end
	return m
end

local function casulo(pai, nome, x, y, z, vivo, topoY)
	local m = Instance.new("Model")
	m.Name = nome
	m.Parent = pai
	m:SetAttribute("Vivo", vivo == true)
	local base = ORIGEM * CFrame.new(x, y, z) * rotY(rnd() * 90)
	local camadas = {
		{1.2, 0.8, 1.2, 0.4}, {1.9, 1.2, 1.9, 1.4}, {2.1, 1.6, 2.1, 2.8}, {1.8, 1.0, 1.8, 4.1}, {1.1, 0.8, 1.1, 5.0},
	}
	local principal
	for i, c in ipairs(camadas) do
		local p = blocoL(m, "Casca" .. i, base, c[1], c[2], c[3], 0, c[4], 0, "casulo")
		p:SetAttribute("Casca", true)
		if i == 3 then principal = p end
	end
	for _, yy in ipairs({2.15, 3.45}) do
		local f = blocoL(m, "Faixa", base, 2.2, 0.2, 2.2, 0, yy, 0, "casuloEsc")
		f:SetAttribute("Casca", true)
	end
	if topoY then
		local fio = bloco(m, "Fio", 0.12, topoY - (y + 5.4), 0.12, x, (topoY + y + 5.4) / 2, z, "teia", nil, nil, 0.3)
		fio.CanCollide = false
	end
	if vivo then
		-- prisioneiro dentro do casulo (aparece quando a casca some)
		blocoL(m, "PrisioneiroCorpo", base, 1.0, 2.4, 0.8, 0, 1.9, 0, "couro")
		blocoL(m, "PrisioneiroCabeca", base, 0.8, 0.8, 0.8, 0, 3.6, 0, "pele")
		principal:SetAttribute("Fala", "Por favor... me tirem daqui!")
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Libertar"
		prompt.ObjectText = "Prisioneiro no casulo"
		prompt.HoldDuration = 2
		prompt.MaxActivationDistance = 10
		prompt.RequiresLineOfSight = false
		prompt.Parent = principal
	end
	return m
end

-- ===================== 1. AS ESCADAS INGREMES =====================
bloco(Z1, "Plato", 26, 1, 22, -13, -0.5, 0, "terra")
local spawn = Instance.new("SpawnLocation")
spawn.Name = "InicioDaAventura"
spawn.Size = Vector3.new(6, 1, 6)
spawn.CFrame = ORIGEM * CFrame.new(-14, 0.5, 0)
spawn.Anchored = true
spawn.Color = C.carmim
spawn.Material = M.plastico
spawn.TopSurface = SMOOTH
spawn.BottomSurface = SMOOTH
spawn.Neutral = true
spawn.Parent = Z1

-- 40 degraus: cada um sobe 1 stud e avanca 2. Alguns estao quebrados na beirada.
for i = 0, 39 do
	local cor = (i % 2 == 0) and "rocha" or "rocha2"
	local largura, centroZ = 8, 0
	if i > 3 and rnd() < 0.2 then largura, centroZ = 5.5, 1.25 end
	local d = bloco(Z1, "Degrau" .. (i + 1), 2, i + 2, largura, 2 * i + 1, i / 2, centroZ, cor)
	if largura < 8 then
		d.Name = "DegrauQuebrado" .. (i + 1)
		d:SetAttribute("Perigo", "Beirada quebrada: teste de Destreza CD 12 ou cai")
	end
	if rnd() < 0.25 then
		bloco(Z1, "Pedrisco", 0.6, 0.4, 0.6, 2 * i + entre(0.5, 1.5), i + 1.2, entre(-3.4, 3.4), "rochaClara")
	end
end

-- Paredao a direita da escada; a esquerda e so o vazio
for i = 0, 9 do
	local h = 4 * (i + 1) + 14
	bloco(Z1, "Paredao" .. i, 8, h + 1, 10, 8 * i + 4, (h + 1) / 2 - 1, 9, (i % 2 == 0) and "rocha" or "rochaEsc")
end
bloco(Z1, "Encosta", 88, 80, 30, 44, 39, 29, "rochaEsc")
pico(Z1, 18, 79, 30, 22, 24)
pico(Z1, 50, 79, 26, 26, 34)
pico(Z1, 76, 79, 32, 18, 20)

-- Patamar no alto, na boca do tunel
bloco(Z1, "Patamar", 12, 41, 14, 86, 19.5, 0, "rocha")

-- Crista distante com o posto de vigia orc
bloco(Z1, "CristaDistante", 140, 46, 18, 60, 22, -85, "rochaEsc")
pico(Z1, 20, 45, -86, 20, 18)
pico(Z1, 100, 45, -86, 24, 26)
bloco(Z1, "PostoVigia", 8, 0.6, 8, 64, 45.3, -80, "madeira")
for _, p in ipairs({ {60.5, -83.5}, {67.5, -83.5}, {60.5, -76.5}, {67.5, -76.5} }) do
	bloco(Z1, "Poste", 0.6, 6, 0.6, p[1], 48.6, p[2], "madeira2")
end
bloco(Z1, "Telhado", 9, 0.6, 9, 64, 51.9, -80, "madeira2")
chama(Z1, 61.5, 45.85, -77.5)
orc("OrcDaCrista", CFrame.lookAt(W(65, 45.6, -79), W(40, 45.6, 0)), false)

guia(CFrame.lookAt(W(88, 40, -3), W(70, 40, 0)))

zona("Zona1_EscadasIngremes", 102, 60, 16, 39, 28, 0, {
	Nome = "As Escadas Ingremes",
	Descricao = "Subida longa e estreita pela encosta. Vigias orcs na crista ao longe.",
	Teste = "Constituicao CD 12 por exaustao a cada 10 degraus",
	Escuridao = 0.15,
	Tinta = Color3.fromRGB(205, 205, 235),
})

-- ===================== 2. O TUNEL DO FEDOR =====================
-- interior: x 92..172, z -5..5, y 40..52
bloco(Z2, "Chao", 80, 2, 14, 132, 39, 0, "terra")
bloco(Z2, "ParedeN", 80, 12, 2, 132, 46, 6, "rochaEsc")
bloco(Z2, "ParedeS", 80, 12, 2, 132, 46, -6, "rochaEsc")
bloco(Z2, "Teto", 80, 2, 14, 132, 53, 0, "rochaEsc")
bloco(Z2, "MontanhaN", 80, 84, 33, 132, 41, 23.5, "rocha")
bloco(Z2, "MontanhaS", 80, 84, 33, 132, 41, -23.5, "rocha")
bloco(Z2, "MontanhaCima", 80, 30, 14, 132, 69, 0, "rocha")
bloco(Z2, "MontanhaBaixo", 80, 39, 14, 132, 18.5, 0, "rocha")
pico(Z2, 112, 83, 10, 30, 30)
pico(Z2, 150, 83, -12, 34, 40)

-- arco antigo na entrada, com runas apagadas
bloco(Z2, "ArcoE", 1.5, 12, 1.5, 92.4, 46, -4.6, "rochaClara")
bloco(Z2, "ArcoD", 1.5, 12, 1.5, 92.4, 46, 4.6, "rochaClara")
bloco(Z2, "ArcoTopo", 1.5, 1.5, 10.7, 92.4, 51.4, 0, "rochaClara")
for _, z in ipairs({-2.5, 0, 2.5}) do
	bloco(Z2, "Runa", 0.1, 0.6, 0.6, 91.6, 51.4, z, "runa", "neon", nil, 0.35)
end

-- paredes irregulares, estalactites, lodo e ossos
for i = 1, 36 do
	local lado = (i % 2 == 0) and 1 or -1
	bloco(Z2, "Rocha", entre(1.5, 4.5), entre(1, 4), 1.4, entre(94, 170), entre(40.5, 50.5), lado * 4.4,
		(rnd() < 0.5) and "rocha" or "rocha2")
end
for _ = 1, 22 do
	local x, z, w, len = entre(94, 170), entre(-4, 4), entre(0.5, 1.2), entre(0.8, 3)
	bloco(Z2, "Estalactite", w, len, w, x, 52 - len / 2, z, "rochaEsc")
	bloco(Z2, "EstalactitePonta", w * 0.5, 0.6, w * 0.5, x, 52 - len - 0.3, z, "rocha2")
end
for _ = 1, 9 do
	local l = bloco(Z2, "Lodo", entre(2, 6), 0.1, entre(1.5, 4.5), entre(95, 169), 40.05, entre(-3.5, 3.5), "lodo", nil, nil, 0.15)
	l.CanCollide = false
end
ossada(Z2, 55, 94, 170, -4.3, 4.3, 40)

-- miasma esverdeado
for _, x in ipairs({110, 135, 160}) do
	local fonte = bloco(Z2, "Miasma", 1, 1, 1, x, 41, 0, "lodo", nil, nil, 1)
	fonte.CanCollide = false
	local pe = Instance.new("ParticleEmitter")
	pe.Color = ColorSequence.new(C.lodo)
	pe.Transparency = NumberSequence.new(0.75)
	pe.Size = NumberSequence.new(5)
	pe.Lifetime = NumberRange.new(6, 9)
	pe.Rate = 3
	pe.Speed = NumberRange.new(0.3, 0.8)
	pe.SpreadAngle = Vector2.new(180, 180)
	pe.Parent = fonte
end

zona("Zona2_TunelDoFedor", 80, 12, 10, 132, 46, 0, {
	Nome = "O Tunel do Fedor",
	Descricao = "Escuridao magica que engole ate a visao no escuro. Ar putrido e ossos de varias racas.",
	Teste = "Constituicao CD 13 contra envenenamento leve",
	Escuridao = 0.85,
	Tinta = Color3.fromRGB(175, 205, 145),
})

-- ===================== 3. O LABIRINTO DE TEIAS =====================
local X0, ZM0, N, CEL = 172, -42, 7, 12
bloco(Z3, "Chao", 86, 2, 86, 214, 39, 0, "terra")
bloco(Z3, "Teto", 86, 2, 86, 214, 53, 0, "rochaEsc")
bloco(Z3, "MontanhaN", 86, 84, 27, 214, 41, 56.5, "rocha")
bloco(Z3, "MontanhaS", 86, 84, 27, 214, 41, -56.5, "rocha")
bloco(Z3, "MontanhaCima", 86, 30, 86, 214, 69, 0, "rocha")
bloco(Z3, "MontanhaBaixo", 86, 39, 86, 214, 18.5, 0, "rocha")
pico(Z3, 200, 83, 20, 40, 44)
pico(Z3, 234, 83, -18, 30, 30)

-- labirinto perfeito (backtracking) a partir da entrada
local abertoE, abertoS, visitado = {}, {}, {}
for c = 0, N - 1 do
	abertoE[c], abertoS[c], visitado[c] = {}, {}, {}
end
local function abrir(c1, r1, c2, r2)
	if c2 == c1 + 1 then abertoE[c1][r1] = true
	elseif c2 == c1 - 1 then abertoE[c2][r2] = true
	elseif r2 == r1 + 1 then abertoS[c1][r1] = true
	else abertoS[c2][r2] = true end
end
local pilha = { {0, 3} }
visitado[0][3] = true
while #pilha > 0 do
	local atual = pilha[#pilha]
	local c, r = atual[1], atual[2]
	local viz = {}
	for _, d in ipairs({ {1, 0}, {-1, 0}, {0, 1}, {0, -1} }) do
		local nc, nr = c + d[1], r + d[2]
		if nc >= 0 and nc < N and nr >= 0 and nr < N and not visitado[nc][nr] then
			table.insert(viz, {nc, nr})
		end
	end
	if #viz == 0 then
		table.remove(pilha)
	else
		local escolhido = viz[math.floor(rnd() * #viz) + 1]
		abrir(c, r, escolhido[1], escolhido[2])
		visitado[escolhido[1]][escolhido[2]] = true
		table.insert(pilha, escolhido)
	end
end
-- duas passagens extras para criar voltas
for _ = 1, 2 do
	local c, r = math.floor(rnd() * (N - 1)), math.floor(rnd() * N)
	abertoE[c][r] = true
end

local function aberturas(c, r)
	local n = 0
	if (c < N - 1 and abertoE[c][r]) or (c == N - 1 and r == 3) then n = n + 1 end
	if (c > 0 and abertoE[c - 1][r]) or (c == 0 and r == 3) then n = n + 1 end
	if r < N - 1 and abertoS[c][r] then n = n + 1 end
	if r > 0 and abertoS[c][r - 1] then n = n + 1 end
	return n
end

local paredes = Instance.new("Model")
paredes.Name = "Paredes"
paredes.Parent = Z3
for c = -1, N - 1 do
	for r = 0, N - 1 do
		local existe
		if c == -1 or c == N - 1 then existe = (r ~= 3) else existe = not abertoE[c][r] end
		if existe then
			bloco(paredes, "Parede", 2, 12, 14, X0 + (c + 1) * CEL, 46, ZM0 + r * CEL + 6,
				((c + r) % 2 == 0) and "rocha" or "rocha2")
		end
	end
end
for r = -1, N - 1 do
	for c = 0, N - 1 do
		local existe = (r == -1 or r == N - 1) or not abertoS[c][r]
		if existe then
			bloco(paredes, "Parede", 14, 12, 2, X0 + c * CEL + 6, 46, ZM0 + (r + 1) * CEL,
				((c + r) % 2 == 0) and "rocha2" or "rocha")
		end
	end
end

-- teias nas passagens
local contTeia = 0
local function teia(x, z, aoLongoDeZ)
	contTeia = contTeia + 1
	local resistente = rnd() < 0.4
	local m = Instance.new("Model")
	m.Name = "Teia" .. contTeia
	m.Parent = Z3
	m:SetAttribute("Teia", true)
	m:SetAttribute("Resistente", resistente)
	local cor = resistente and "teiaForte" or "teia"
	local mat = resistente and "neon" or "plastico"
	local sx, sz = 0.3, 10
	if not aoLongoDeZ then sx, sz = 10, 0.3 end
	local rede = bloco(m, "Rede", sx, 11.6, sz, x, 46, z, cor, mat, nil, resistente and 0.6 or 0.65)
	local clique = Instance.new("ClickDetector")
	clique.MaxActivationDistance = 14
	clique.Parent = rede
	-- fios desenhando a teia
	local function P(u, v)
		if aoLongoDeZ then return W(x, 46 + v, z + u) end
		return W(x + u, 46 + v, z)
	end
	local fios = { {P(-5, -5.8), P(5, 5.8)}, {P(-5, 5.8), P(5, -5.8)}, {P(0, -5.8), P(0, 5.8)}, {P(-5, 0), P(5, 0)},
		{P(-2.5, 0), P(0, 2.9)}, {P(0, 2.9), P(2.5, 0)}, {P(2.5, 0), P(0, -2.9)}, {P(0, -2.9), P(-2.5, 0)} }
	for _, f in ipairs(fios) do
		local fio = liga(m, "Fio", f[1], f[2], 0.12, cor, mat, resistente and 0.1 or 0.15)
		fio.CanCollide = false
	end
end

local becos = {}
for c = 0, N - 1 do
	for r = 0, N - 1 do
		if c < N - 1 and abertoE[c][r] and rnd() < 0.28 then
			teia(X0 + (c + 1) * CEL, ZM0 + r * CEL + 6, true)
		end
		if r < N - 1 and abertoS[c][r] and rnd() < 0.28 then
			teia(X0 + c * CEL + 6, ZM0 + (r + 1) * CEL, false)
		end
		local cx, cz = X0 + c * CEL + 6, ZM0 + r * CEL + 6
		if aberturas(c, r) == 1 and not (r == 3 and (c == 0 or c == N - 1)) then
			table.insert(becos, {cx, cz})
		end
		if rnd() < 0.35 then
			for _ = 1, 3 do
				local len = entre(2, 7)
				local fio = bloco(Z3, "FioPendurado", 0.08, len, 0.08, cx + entre(-4, 4), 52 - len / 2, cz + entre(-4, 4), "teia", nil, nil, 0.3)
				fio.CanCollide = false
			end
		end
	end
end

-- crias de aranha nos becos sem saida
local contCria = 0
for _, b in ipairs(becos) do
	if rnd() < 0.75 then
		for _ = 1, 2 do
			contCria = contCria + 1
			local base = ORIGEM * CFrame.new(b[1] + entre(-2.5, 2.5), 40, b[2] + entre(-2.5, 2.5)) * rotY(rnd() * 360)
			local cria = aranha("CriaDeAranha" .. contCria, base, 0.9, "olhoCria")
			cria:SetAttribute("Inimigo", "Cria de aranha")
		end
		ossada(Z3, 3, b[1] - 3, b[1] + 3, b[2] - 3, b[2] + 3, 40)
	end
end

zona("Zona3_LabirintoDeTeias", 84, 12, 84, 214, 46, 0, {
	Nome = "O Labirinto de Teias",
	Descricao = "Corredores que se ramificam e acabam em becos sem saida. Crias atacam em grupo.",
	Teste = "Teias brancas: clique para cortar. Teias violeta: so com fogo ou lamina magica.",
	Escuridao = 0.7,
	Tinta = Color3.fromRGB(195, 185, 235),
})

-- ===================== 4. O COVIL =====================
-- passagem do labirinto ate a camara (x 257..263)
bloco(Z4, "PassagemChao", 6, 2, 14, 260, 39, 0, "terra")
bloco(Z4, "PassagemParedeN", 6, 12, 2, 260, 46, 6, "rochaEsc")
bloco(Z4, "PassagemParedeS", 6, 12, 2, 260, 46, -6, "rochaEsc")
bloco(Z4, "PassagemTeto", 6, 2, 14, 260, 53, 0, "rochaEsc")
bloco(Z4, "MontanhaPassagemN", 6, 84, 63, 260, 41, 38.5, "rocha")
bloco(Z4, "MontanhaPassagemS", 6, 84, 63, 260, 41, -38.5, "rocha")
bloco(Z4, "MontanhaPassagemCima", 6, 30, 14, 260, 69, 0, "rocha")
bloco(Z4, "MontanhaPassagemBaixo", 6, 39, 14, 260, 18.5, 0, "rocha")

-- camara: interior x 265..323, z -30..30, y 40..72
bloco(Z4, "Chao", 62, 2, 64, 294, 39, 0, "terra")
bloco(Z4, "Teto", 62, 2, 64, 294, 73, 0, "rochaEsc")
bloco(Z4, "ParedeN", 62, 32, 2, 294, 56, 31, "rochaEsc")
bloco(Z4, "ParedeS", 62, 32, 2, 294, 56, -31, "rochaEsc")
for _, x in ipairs({264, 324}) do
	bloco(Z4, "ParedeLado", 2, 32, 27, x, 56, 18.5, "rochaEsc")
	bloco(Z4, "ParedeLado", 2, 32, 27, x, 56, -18.5, "rochaEsc")
	bloco(Z4, "ParedeLadoTopo", 2, 20, 10, x, 62, 0, "rochaEsc")
end
bloco(Z4, "MontanhaN", 62, 84, 38, 294, 41, 51, "rocha")
bloco(Z4, "MontanhaS", 62, 84, 38, 294, 41, -51, "rocha")
bloco(Z4, "MontanhaCima", 62, 26, 64, 294, 87, 0, "rocha")
bloco(Z4, "MontanhaBaixo", 62, 39, 64, 294, 18.5, 0, "rocha")
pico(Z4, 286, 100, 6, 46, 40)
pico(Z4, 312, 100, -16, 28, 26)

-- estalagmites
for _ = 1, 7 do
	local x, z = entre(270, 318), entre(-24, 22)
	local h = entre(3, 6)
	bloco(Z4, "Estalagmite", 2.4, h, 2.4, x, 40 + h / 2, z, "rocha2")
	bloco(Z4, "Estalagmite", 1.4, h * 0.6, 1.4, x, 40 + h + h * 0.3, z, "rocha")
	bloco(Z4, "Estalagmite", 0.6, 1, 0.6, x, 40 + h * 1.6 + 0.5, z, "rochaClara")
end

-- a grande teia na parede do fundo
local teiaGrande = Instance.new("Model")
teiaGrande.Name = "TeiaGrande"
teiaGrande.Parent = Z4
local centro = W(294, 56, 29.7)
local raios, aneis = 12, { 3.5, 7, 10.5, 14 }
local pontos = {}
for i = 0, raios - 1 do
	local a = i / raios * 2 * math.pi
	local dir = ORIGEM:VectorToWorldSpace(Vector3.new(math.cos(a), math.sin(a), 0))
	local raio = liga(teiaGrande, "Raio", centro, centro + dir * 14, 0.25, "teia", "neon", 0.35)
	raio.CanCollide = false
	if i % 4 == 0 then luz(raio, "violeta", 22, 0.7) end
	pontos[i] = dir
end
for _, rr in ipairs(aneis) do
	for i = 0, raios - 1 do
		local a = centro + pontos[i] * rr
		local b = centro + pontos[(i + 1) % raios] * rr
		local fio = liga(teiaGrande, "Anel", a, b, 0.15, "teia", "neon", 0.4)
		fio.CanCollide = false
	end
end

-- ===== A TECELA FAMINTA (boss) =====
-- Construida em coordenadas locais: frente para -Z, patas tocando y = 0.
-- acordada = false deixa os olhos apagados (a masmorra acende quando ela desperta).
local function construirTecela(pai, base, acordada)
	local m = Instance.new("Model")
	m.Name = "ATecelaFaminta"
	m:SetAttribute("Nome", "A Tecela Faminta")
	m:SetAttribute("Chefe", true)
	m:SetAttribute("Designer", "Yuri Ramos Hernandez")
	m.Parent = pai

	local function b(n, sx, sy, sz, lx, ly, lz, cor, mat, rot)
		return blocoL(m, n, base, sx, sy, sz, lx, ly, lz, cor, mat, rot)
	end
	local function seg(n, a, c, esp, cor, mat)
		return ligaL(m, n, base, a, c, esp, cor, mat)
	end
	local V = Vector3.new

	-- abdomen arredondado em blocos
	b("Abdomen", 6, 4, 7, 0, 4.2, 4.6, "carapaca")
	b("AbdomenLargo", 7, 3, 6, 0, 4.2, 4.6, "carapaca")
	b("AbdomenTopo", 5, 1.2, 6, 0, 6.5, 4.6, "carapaca2")
	b("AbdomenBase", 5, 1, 5.5, 0, 2.2, 4.6, "carapaca")
	b("AbdomenTras", 4, 3, 1.2, 0, 4.2, 8.6, "carapaca2")
	for i, z in ipairs({ 2.2, 4.0, 5.8, 7.4 }) do
		b("Placa" .. i, 7.3, 0.5, 0.7, 0, 4.6, z, "carapaca2")
	end
	b("Fiandeira", 1.2, 0.8, 0.8, 0, 3.2, 9.4, "osso")

	-- cristais crescendo nas costas
	local sem = 777
	local function r()
		sem = (sem * 16807) % 2147483647
		return sem / 2147483647
	end
	local cristais = {
		{0, 4.6, 3.2}, {-1.4, 3.4, 2.4}, {1.5, 3.7, 2.6}, {-0.8, 6.2, 2.8}, {0.9, 6.0, 2.7}, {-2.3, 4.8, 1.9},
		{2.4, 5.2, 1.8}, {0, 2.6, 2.2}, {-1.6, 7.3, 1.8}, {1.7, 7.4, 1.7}, {0, 7.8, 2.0}, {-2.6, 2.8, 1.5},
		{2.6, 3.2, 1.4}, {-0.4, 5.4, 3.6}, {0.6, 3.0, 3.0}, {1.2, 8.3, 1.3},
	}
	local brilho
	for i, c in ipairs(cristais) do
		local dx, dz, h = c[1], c[2] - 4.6, c[3] + r() * 0.8
		local w = 0.7 + r() * 0.6
		local inclina = CFrame.Angles(dz * 0.12, r() * 1.5, -dx * 0.14)
		local raizCF = base * CFrame.new(dx, 6.6, c[2]) * inclina
		local corpo = novoPart(m, "Cristal" .. i, V(w, h, w), raizCF * CFrame.new(0, h / 2, 0),
			(i % 3 == 0) and "cristal2" or "cristal",
			(i % 3 == 0) and "plastico" or "neon", (i % 3 == 0) and 0 or 0.08)
		corpo.CanCollide = false
		local ponta = novoPart(m, "PontaCristal" .. i, V(w * 0.55, h * 0.32, w * 0.55), raizCF * CFrame.new(0, h + h * 0.12, 0),
			"cristalClaro", "neon")
		ponta.CanCollide = false
		if i == 1 then brilho = corpo end
	end
	local luzCristal = Instance.new("PointLight")
	luzCristal.Name = "LuzDosCristais"
	luzCristal.Color = C.cristal
	luzCristal.Range = 26
	luzCristal.Brightness = acordada and 1.6 or 0
	luzCristal.Parent = brilho

	-- cefalotorax e cabeca
	b("Torax", 4, 2.4, 4, 0, 3.6, -0.6, "carapaca2")
	b("ToraxTopo", 3.4, 0.6, 3.4, 0, 5.0, -0.6, "carapaca")
	b("RunaA", 0.25, 0.12, 2.6, 0, 5.36, -0.6, "carmim", "neon", CFrame.Angles(0, math.rad(45), 0))
	b("RunaB", 0.25, 0.12, 2.6, 0, 5.36, -0.6, "carmim", "neon", CFrame.Angles(0, math.rad(-45), 0))
	for i, p in ipairs({ {-1.5, 0.8}, {1.5, 0.8}, {-1.5, -2.0}, {1.5, -2.0} }) do
		b("Espinho" .. i, 0.35, 0.7, 0.35, p[1], 5.2, p[2], "osso")
	end
	local cabeca = b("Cabeca", 3, 1.8, 2, 0, 3.6, -3.4, "carapaca")
	b("Testa", 2.4, 0.5, 1.6, 0, 4.7, -3.3, "carapaca2")

	local corOlho = acordada and "violeta" or "sombra"
	local olhos = {
		{0.6, -0.55, 4.1, -4.42}, {0.6, 0.55, 4.1, -4.42},
		{0.4, -1.15, 3.85, -4.38}, {0.4, 1.15, 3.85, -4.38},
		{0.3, -0.35, 4.62, -4.3}, {0.3, 0.35, 4.62, -4.3},
		{0.3, -1.45, 4.35, -3.9}, {0.3, 1.45, 4.35, -3.9},
	}
	for i, o in ipairs(olhos) do
		local olho = b("Olho" .. i, o[1], o[1], 0.2, o[2], o[3], o[4], corOlho, "neon")
		olho:SetAttribute("Olho", true)
	end
	local luzOlhos = Instance.new("PointLight")
	luzOlhos.Name = "LuzDosOlhos"
	luzOlhos.Color = C.violeta
	luzOlhos.Range = 28
	luzOlhos.Brightness = acordada and 2 or 0
	luzOlhos.Parent = cabeca

	-- queliceras e presas
	for _, s in ipairs({ -1, 1 }) do
		b("Quelicera", 0.9, 1.4, 1, s * 0.6, 2.55, -4.25, "carapaca2")
		b("Presa", 0.38, 1.0, 0.38, s * 0.62, 1.55, -4.55, "osso", nil, CFrame.Angles(math.rad(-15), 0, math.rad(s * 10)))
		b("PresaPonta", 0.26, 0.7, 0.26, s * 0.45, 0.85, -4.35, "osso", nil, CFrame.Angles(math.rad(20), 0, math.rad(s * 35)))
		-- pedipalpos
		local p1, p2, p3 = V(s * 1.2, 3.0, -4.0), V(s * 1.9, 1.6, -5.2), V(s * 1.5, 0.5, -5.7)
		seg("Pedipalpo", p1, p2, 0.45, "carapaca2")
		seg("Pedipalpo", p2, p3, 0.35, "carapaca")
		b("PedipalpoJunta", 0.55, 0.55, 0.55, p2.X, p2.Y, p2.Z, "articulacao")
	end

	-- oito patas longas, com juntas de osso e pontas de cristal
	for _, s in ipairs({ -1, 1 }) do
		for k = 0, 3 do
			local quadril = V(s * 2.0, 3.6, -1.8 + k * 0.8)
			local joelho = V(s * (5.5 + k * 0.3), 9.5 - k * 0.4, -5.5 + k * 3.2)
			local tornozelo = V(s * (9 + k * 0.4), 6.5 - k * 0.3, -8 + k * 5)
			local ponta = V(s * (11 + k * 0.5), 0.1, -9.5 + k * 6.2)
			local meio = tornozelo:Lerp(ponta, 0.55)
			local idx = ((s < 0) and 0 or 4) + k + 1
			for i, ponto in ipairs({ quadril, joelho, tornozelo, meio, ponta }) do
				m:SetAttribute(("P%d_%d"):format(idx, i), ponto)
			end
			local segs = {
				seg("Coxa", quadril, joelho, 0.9, "carapaca2"),
				seg("Tibia", joelho, tornozelo, 0.75, "carapaca"),
				seg("Metatarso", tornozelo, meio, 0.55, "carapaca2"),
				seg("Garra", meio, ponta, 0.42, "cristal", "neon"),
			}
			for i, sg in ipairs(segs) do
				sg:SetAttribute("Perna", idx)
				sg:SetAttribute("IA", i)
				sg:SetAttribute("IB", i + 1)
			end
			local juntas = {
				{ b("Joelho", 1.15, 1.15, 1.15, joelho.X, joelho.Y, joelho.Z, "articulacao"), 2, V(0, 0, 0) },
				{ b("JoelhoEspinho", 0.35, 0.8, 0.35, joelho.X, joelho.Y + 0.9, joelho.Z, "osso"), 2, V(0, 0.9, 0) },
				{ b("Tornozelo", 0.9, 0.9, 0.9, tornozelo.X, tornozelo.Y, tornozelo.Z, "articulacao"), 3, V(0, 0, 0) },
				{ b("JuntaMeio", 0.6, 0.6, 0.6, meio.X, meio.Y, meio.Z, "osso"), 4, V(0, 0, 0) },
			}
			for _, j in ipairs(juntas) do
				j[1]:SetAttribute("Perna", idx)
				j[1]:SetAttribute("IP", j[2])
				j[1]:SetAttribute("Desloc", j[3])
			end
		end
	end

	-- grupos que se mexem juntos na animacao
	local ABDOMEN = { Abdomen = true, AbdomenLargo = true, AbdomenTopo = true, AbdomenBase = true, AbdomenTras = true, Fiandeira = true }
	local CABECA = { Cabeca = true, Testa = true, Pedipalpo = true, PedipalpoJunta = true }
	local PRESAS = { Quelicera = true, Presa = true, PresaPonta = true }
	for _, p in ipairs(m:GetChildren()) do
		if p:IsA("BasePart") and not p:GetAttribute("Perna") then
			local n = p.Name
			local grupo = "Corpo"
			if ABDOMEN[n] or n:match("^Placa") or n:match("Cristal") then grupo = "Abdomen"
			elseif CABECA[n] or n:match("^Olho") then grupo = "Cabeca"
			elseif PRESAS[n] then grupo = (base:PointToObjectSpace(p.CFrame.Position).X < 0) and "PresaE" or "PresaD" end
			p:SetAttribute("Grupo", grupo)
		end
	end
	m:SetAttribute("Aranha", true)
	m:SetAttribute("Escala", 4)
	m:SetAttribute("Pontos", 5)
	m:SetAttribute("PivoCorpo", V(0, 3.6, 0.5))
	m:SetAttribute("PivoAbdomen", V(0, 4.2, 1.1))
	m:SetAttribute("PivoCabeca", V(0, 3.6, -2.4))
	m:SetAttribute("PivoPresaE", V(-0.6, 2.4, -4.3))
	m:SetAttribute("PivoPresaD", V(0.6, 2.4, -4.3))
	m:SetAttribute("Passada", 4.5)
	m:SetAttribute("AlturaPasso", 2.2)
	m:SetAttribute("Frequencia", 1.1)
	m:SetAttribute("Vida", 300)
	m:SetAttribute("VidaMax", 300)
	m.WorldPivot = base
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
	return m
end

-- agarrada na teia do fundo, de cabeca para baixo, esperando (olhos apagados ate despertar)
local baseTecela = ORIGEM * CFrame.new(294, 61, 29.6) * CFrame.Angles(math.rad(-90), 0, 0)
local tecelaModelo = construirTecela(personagens, baseTecela, false)
-- quando morre, ela cai no chao do Covil, de frente para a entrada
tecelaModelo:SetAttribute("ChaoCF", ORIGEM * CFrame.new(294, 40, 20) * CFrame.Angles(0, math.rad(90), 0))

-- casulos pendurados (antigos) e no chao (alguns vivos)
local casulos = Instance.new("Folder")
casulos.Name = "Casulos"
casulos.Parent = Z4
for i = 1, 8 do
	local y = 72 - 5.4 - entre(3, 11)
	casulo(casulos, "CasuloPendurado" .. i, entre(270, 318), y, entre(-26, 22), false, 72)
end
local noChao = { {269, -26, true}, {279, -27, false}, {311, -25, true}, {318, -17, false}, {270, 21, true}, {300, -26, false} }
for i, c in ipairs(noChao) do
	casulo(casulos, (c[3] and "CasuloVivo" or "Casulo") .. i, c[1], 40, c[2], c[3])
end
ossada(Z4, 40, 267, 321, -28, 26, 40)

zona("Zona4_Covil", 58, 32, 60, 294, 56, 0, {
	Nome = "O Covil",
	Descricao = "Camara ampla cheia de casulos. Alguns prisioneiros ainda imploram por resgate.",
	Teste = "A Tecela Faminta desperta quando alguem entra",
	Escuridao = 0.55,
	Tinta = Color3.fromRGB(210, 190, 240),
})

-- ===================== 5. A SAIDA VIGIADA =====================
-- passagem de saida: x 325..352
bloco(Z5, "SaidaChao", 27, 2, 14, 338.5, 39, 0, "terra")
bloco(Z5, "SaidaParedeN", 27, 12, 2, 338.5, 46, 6, "rochaEsc")
bloco(Z5, "SaidaParedeS", 27, 12, 2, 338.5, 46, -6, "rochaEsc")
bloco(Z5, "SaidaTeto", 27, 2, 14, 338.5, 53, 0, "rochaEsc")
bloco(Z5, "MontanhaN", 27, 84, 63, 338.5, 41, 38.5, "rocha")
bloco(Z5, "MontanhaS", 27, 84, 63, 338.5, 41, -38.5, "rocha")
bloco(Z5, "MontanhaCima", 27, 30, 14, 338.5, 69, 0, "rocha")
bloco(Z5, "MontanhaBaixo", 27, 39, 14, 338.5, 18.5, 0, "rocha")
pico(Z5, 336, 83, 18, 24, 26)
bloco(Z5, "ArcoE", 1.5, 12, 1.5, 351.6, 46, -4.6, "rochaClara")
bloco(Z5, "ArcoD", 1.5, 12, 1.5, 351.6, 46, 4.6, "rochaClara")
bloco(Z5, "ArcoTopo", 1.5, 1.5, 10.7, 351.6, 51.4, 0, "rochaClara")

-- plato do outro lado da montanha
bloco(Z5, "Plato", 60, 41, 70, 382, 19.5, 0, "rocha")
local trilha = bloco(Z5, "Trilha", 60, 0.1, 6, 382, 40.05, 0, "terra")
trilha.CanCollide = false

-- paliçada com portao aberto
local palicada = Instance.new("Model")
palicada.Name = "Palicada"
palicada.Parent = Z5
local zz = -34
while zz <= 8.6 do
	if math.abs(zz) > 5.2 then
		bloco(palicada, "Estaca", 1.2, 7, 1.2, 372, 43.5, zz, (math.floor(zz) % 2 == 0) and "madeira" or "madeira2")
		bloco(palicada, "Ponta", 0.6, 0.8, 0.6, 372, 47.4, zz, "madeira2")
	end
	zz = zz + 1.4
end
for _, z in ipairs({-4.5, 4.5}) do
	bloco(palicada, "PostePortao", 1.8, 9, 1.8, 372, 44.5, z, "madeira2")
	chama(palicada, 372, 49.25, z)
end
bloco(palicada, "Travessa", 1.2, 1, 10.8, 372, 48.3, 0, "madeira")

-- torre orc: externa x 383..397, z 11..25, y 40..76
local torre = Instance.new("Model")
torre.Name = "TorreOrc"
torre.Parent = Z5
bloco(torre, "ParedeO", 2, 36, 14, 384, 58, 18, "pedraTorre")
bloco(torre, "ParedeL", 2, 36, 14, 396, 58, 18, "pedraTorre")
bloco(torre, "ParedeN", 10, 36, 2, 390, 58, 24, "pedraTorre")
bloco(torre, "ParedeS_E", 3, 36, 2, 386.5, 58, 12, "pedraTorre")
bloco(torre, "ParedeS_D", 3, 36, 2, 393.5, 58, 12, "pedraTorre")
bloco(torre, "ParedeS_Topo", 4, 29, 2, 390, 61.5, 12, "pedraTorre")
for _, y in ipairs({52, 64, 74}) do
	bloco(torre, "Faixa", 14.4, 0.8, 0.4, 390, y, 10.8, "pedraTorre2")
	bloco(torre, "Faixa", 14.4, 0.8, 0.4, 390, y, 25.2, "pedraTorre2")
	bloco(torre, "Faixa", 0.4, 0.8, 14.4, 382.8, y, 18, "pedraTorre2")
	bloco(torre, "Faixa", 0.4, 0.8, 14.4, 397.2, y, 18, "pedraTorre2")
end
bloco(torre, "PisoMeio", 10, 1, 10, 390, 57.5, 18, "madeira2")
bloco(torre, "PisoTopo", 14, 1, 14, 390, 76.5, 18, "pedraTorre2")
for _, x in ipairs({384, 388, 392, 396}) do
	bloco(torre, "Ameia", 2, 2, 2, x, 78, 12, "pedraTorre")
	bloco(torre, "Ameia", 2, 2, 2, x, 78, 24, "pedraTorre")
end
for _, z in ipairs({16, 20}) do
	bloco(torre, "Ameia", 2, 2, 2, 384, 78, z, "pedraTorre")
	bloco(torre, "Ameia", 2, 2, 2, 396, 78, z, "pedraTorre")
end
for _, y in ipairs({63, 70}) do
	bloco(torre, "Seteira", 0.6, 2, 0.1, 390, y, 10.94, "fogo", "neon", nil, 0.3)
	bloco(torre, "Seteira", 0.1, 2, 0.6, 397.06, y, 18, "fogo", "neon", nil, 0.3)
	bloco(torre, "Seteira", 0.1, 2, 0.6, 382.94, y, 18, "fogo", "neon", nil, 0.3)
end
bloco(torre, "Estandarte", 3, 7, 0.15, 390, 67.5, 10.85, "carmim")
bloco(torre, "EstandarteMarca", 1.3, 1.3, 0.05, 390, 68.5, 10.75, "sombra")
bloco(torre, "EstandartePonta", 3, 0.6, 0.15, 390, 63.7, 10.85, "carmim")
chama(torre, 389, 44.25, 14.5)

-- cela no terreo (gancho de resgate)
local cela = Instance.new("Model")
cela.Name = "Cela"
cela.Parent = torre
local bx = 385.4
while bx <= 394.6 do
	bloco(cela, "Grade", 0.2, 6, 0.2, bx, 43, 19, "ferro", "metal")
	bx = bx + 0.8
end
bloco(cela, "GradeTravessa", 10, 0.25, 0.25, 390, 41, 19, "ferro", "metal")
bloco(cela, "GradeTravessa", 10, 0.25, 0.25, 390, 45.6, 19, "ferro", "metal")
bloco(cela, "Palha", 4, 0.3, 2.5, 388, 40.15, 21.5, "palha")
bloco(cela, "Corrente", 0.3, 2, 0.3, 392, 44, 22.8, "ferro", "metal")
bloco(cela, "Algema", 0.8, 0.3, 0.4, 392, 42.9, 22.6, "ferro", "metal")

orc("OrcPortaoE", CFrame.lookAt(W(369.5, 40, -7), W(352, 40, -2)), true)
orc("OrcPortaoD", CFrame.lookAt(W(369.5, 40, 7), W(352, 40, 2)), true)
orc("OrcDaTorre", CFrame.lookAt(W(391, 77, 14), W(352, 77, 0)), false)
orc("OrcCarcereiro", CFrame.lookAt(W(388, 40, 15), W(390, 40, 22)), false)

zona("Zona5_SaidaVigiada", 87, 40, 70, 368.5, 60, 0, {
	Nome = "A Saida Vigiada",
	Descricao = "Do outro lado da montanha, uma torre orc controla a passagem.",
	Teste = "Furtividade (Destreza) contra a Percepcao passiva dos orcs",
	Escuridao = 0.2,
	Tinta = Color3.fromRGB(235, 205, 190),
})
zona("Zona5_CelaDaTorre", 10, 6, 4, 390, 43, 21.5, {
	Nome = "Cela da Torre",
	Descricao = "Quem for capturado ou paralisado e trazido para ca.",
	Teste = "Gancho: resgate na proxima sessao",
	Escuridao = 0.25,
	Tinta = Color3.fromRGB(255, 205, 165),
})

-- ===================== CONTORNO PIXEL ART =====================
local contorno = Instance.new("Highlight")
contorno.Name = "ContornoPixel"
contorno.FillTransparency = 1
contorno.OutlineColor = Color3.fromRGB(10, 8, 14)
contorno.OutlineTransparency = 0
contorno.DepthMode = Enum.HighlightDepthMode.Occluded
contorno.Adornee = personagens
contorno.Parent = personagens

-- ===================== MECANICAS (rodam no Play) =====================
local mecanicas = Instance.new("Script")
mecanicas.Name = "Mecanicas"
mecanicas.Source = [==[
-- A Toca da Tecela Faminta: mecanicas do servidor
-- Design: Yuri Ramos Hernandez
local raiz = script.Parent
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local function mostrarTexto(parte, texto, cor)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(320, 44)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.Adornee = parte
	local rotulo = Instance.new("TextLabel")
	rotulo.Size = UDim2.fromScale(1, 1)
	rotulo.BackgroundTransparency = 1
	rotulo.Text = texto
	rotulo.TextColor3 = cor or Color3.fromRGB(235, 225, 255)
	rotulo.TextStrokeTransparency = 0
	rotulo.Font = Enum.Font.Arcade
	rotulo.TextScaled = true
	rotulo.Parent = gui
	gui.Parent = parte
	Debris:AddItem(gui, 3)
end

local function temFogoOuMagia(jogador)
	local personagem = jogador.Character
	if not personagem then return false end
	for _, item in ipairs(personagem:GetChildren()) do
		if item:IsA("Tool") then
			local nome = string.lower(item.Name)
			if item:GetAttribute("Magica") or item:GetAttribute("Fogo")
				or string.find(nome, "tocha") or string.find(nome, "fogo") then
				return true
			end
		end
	end
	return false
end

local function dentro(zona, pos)
	local rel = zona.CFrame:PointToObjectSpace(pos)
	local s = zona.Size / 2
	return math.abs(rel.X) <= s.X and math.abs(rel.Y) <= s.Y and math.abs(rel.Z) <= s.Z
end

-- TEIAS: clique para cortar; as violeta precisam de fogo ou magia
for _, teia in ipairs(raiz:GetDescendants()) do
	if teia:IsA("Model") and teia:GetAttribute("Teia") then
		local rede = teia:FindFirstChild("Rede")
		local clique = rede and rede:FindFirstChildOfClass("ClickDetector")
		if clique then
			local cortada = false
			clique.MouseClick:Connect(function(jogador)
				if cortada then return end
				if teia:GetAttribute("Resistente") and not temFogoOuMagia(jogador) then
					mostrarTexto(rede, "Resistente demais! So fogo ou lamina magica", Color3.fromRGB(200, 160, 255))
					return
				end
				cortada = true
				local antes = {}
				for _, p in ipairs(teia:GetDescendants()) do
					if p:IsA("BasePart") then
						antes[p] = p.Transparency
						p.Transparency = 1
						p.CanCollide = false
					end
				end
				mostrarTexto(rede, "Teia cortada!")
				task.delay(120, function()
					for p, transp in pairs(antes) do
						p.Transparency = transp
						p.CanCollide = (p == rede)
					end
					cortada = false
				end)
			end)
		end
	end
end

-- CASULOS VIVOS: se mexem e podem ser abertos
local casulosVivos = {}
for _, c in ipairs(raiz:GetDescendants()) do
	if c:IsA("Model") and c:GetAttribute("Vivo") then
		local principal = c:FindFirstChild("Casca3")
		local prompt = principal and principal:FindFirstChildOfClass("ProximityPrompt")
		local info = { modelo = c, base = c:GetPivot(), fase = #casulosVivos * 1.3, livre = false }
		table.insert(casulosVivos, info)
		if prompt then
			prompt.Triggered:Connect(function()
				prompt.Enabled = false
				info.livre = true
				c:PivotTo(info.base)
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") and p:GetAttribute("Casca") then
						p.Transparency = 1
						p.CanCollide = false
					end
				end
				c:SetAttribute("Libertado", true)
				mostrarTexto(principal, "Obrigado... voces me salvaram!", Color3.fromRGB(255, 230, 180))
			end)
		end
	end
end

-- A TECELA FAMINTA: desperta quando alguem entra no Covil
local tecela = raiz.Personagens:FindFirstChild("ATecelaFaminta")
local zonaCovil = raiz.Zonas:FindFirstChild("Zona4_Covil")
local despertou = false

local function despertar()
	despertou = true
	for _, p in ipairs(tecela:GetDescendants()) do
		if p:IsA("BasePart") and p:GetAttribute("Olho") then
			p.Color = Color3.fromRGB(190, 110, 255)
		elseif p:IsA("PointLight") then
			p.Brightness = 2.5
		end
	end
	-- o script AranhasVivas faz ela descer da teia e comecar a lutar
	tecela:SetAttribute("Desperta", true)
	local cabeca = tecela:FindFirstChild("Cabeca")
	if cabeca then
		mostrarTexto(cabeca, "A Tecela Faminta desperta!", Color3.fromRGB(255, 90, 110))
	end
end

local t, acumulado = 0, 0
RunService.Heartbeat:Connect(function(dt)
	t = t + dt
	for _, info in ipairs(casulosVivos) do
		if not info.livre then
			info.modelo:PivotTo(info.base * CFrame.Angles(0, 0, math.sin(t * 3 + info.fase) * 0.04))
		end
	end
	acumulado = acumulado + dt
	if not despertou and tecela and zonaCovil and acumulado > 0.3 then
		acumulado = 0
		for _, jogador in ipairs(Players:GetPlayers()) do
			local hrp = jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart")
			if hrp and dentro(zonaCovil, hrp.Position) then
				despertar()
				break
			end
		end
	end
end)
]==]
mecanicas.Parent = raiz

-- ===================== ARANHAS VIVAS (rodam no Play) =====================
local aranhasVivas = Instance.new("Script")
aranhasVivas.Name = "AranhasVivas"
aranhasVivas.Source = [==[
-- Aranhas vivas: animacao das patas, comportamento e dano (design: Yuri Ramos Hernandez)
-- Crias: passeiam no beco, perseguem e mordem quem chega perto.
-- Tecela Faminta: desce da teia quando desperta, morde quem esta perto,
-- cospe teia em quem esta longe e entra em furia com metade da vida.
-- Para dar dano em uma aranha de outro script:
--   aranha:SetAttribute("Vida", aranha:GetAttribute("Vida") - 10)
-- Para testar sem armas: clique na aranha (10 de dano na cria, 15 na Tecela).
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local raiz = script.Parent
local DADOS = require(script:WaitForChild("DadosDasAranhas"))
local personagensF = raiz:WaitForChild("Personagens")

local MISTURA = 0.15
local CAMPOS = { "cy", "cz", "rx", "ry", "rz", "ab", "cab", "pr", "fr", "curl" }
local DANO_MORDIDA_CRIA, DANO_MORDIDA_CHEFE, DANO_TEIA = 8, 20, 6
local DANO_CLIQUE_CRIA, DANO_CLIQUE_CHEFE = 10, 15
local RENASCER = 30

-- ============ POSES ============
local function suave(x) return x * x * (3 - 2 * x) end

local function misturar(a, b, t)
	local o = {}
	for _, c in ipairs(CAMPOS) do
		local x = a[c] or 0
		o[c] = x + ((b[c] or 0) - x) * t
	end
	return o
end

local function poseEm(anim, t)
	local k = anim.k
	if t <= k[1][1] then return misturar(k[1][2], k[1][2], 0) end
	for i = 1, #k - 1 do
		local a, b = k[i], k[i + 1]
		if t <= b[1] then
			return misturar(a[2], b[2], suave((t - a[1]) / (b[1] - a[1])))
		end
	end
	return misturar(k[#k][2], k[#k][2], 0)
end

local function girarEm(P, rx, ry, rz)
	return CFrame.new(P) * CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)) * CFrame.new(-P)
end

-- ============ EFEITOS ============
local efeitos = workspace:FindFirstChild("EfeitosDeCombate")
if not efeitos then
	efeitos = Instance.new("Folder")
	efeitos.Name = "EfeitosDeCombate"
	efeitos.Parent = workspace
end

local function cor3(c) return Color3.fromRGB(c[1], c[2], c[3]) end

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

local function animarSumindo(p, tempo, props)
	props = props or {}
	props.Transparency = 1
	TweenService:Create(p, TweenInfo.new(tempo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	Debris:AddItem(p, tempo + 0.1)
end

local function faiscasEm(pos, cor, n)
	for i = 1, n do
		local a, b = i / n * 2 * math.pi, math.random() * 1.2 - 0.2
		local dir = Vector3.new(math.cos(a), b, math.sin(a)).Unit * (1.5 + math.random() * 2.5)
		local p = bloquinho(CFrame.new(pos), Vector3.new(0.3, 0.3, 0.3), cor)
		animarSumindo(p, 0.45, { CFrame = CFrame.new(pos + dir) * CFrame.Angles(a, a, 0) })
	end
end

local FX = {}
FX.faiscas = function(info, fx)
	local c = fx.c
	faiscasEm(info.base * (Vector3.new(c[1], c[2], c[3]) * info.s), cor3(fx.cor), fx.n)
end
FX.anel = function(info, fx)
	local s, base = info.s, info.base
	local c = Vector3.new(fx.c[1], fx.c[2], fx.c[3]) * s
	local n, cor = 24, cor3(fx.cor)
	for i = 0, n - 1 do
		local a = i / n * 2 * math.pi
		local giroA = base.Rotation * CFrame.Angles(0, -a, 0)
		local p0 = base * (c + Vector3.new(math.cos(a) * fx.r0 * s, 0, math.sin(a) * fx.r0 * s))
		local p1 = base * (c + Vector3.new(math.cos(a) * fx.r1 * s, fx.subida * s, math.sin(a) * fx.r1 * s))
		local p = bloquinho(CFrame.new(p0) * giroA, Vector3.new(0.25, 0.25, 0.9) * math.max(1, s * 0.5), cor)
		animarSumindo(p, fx.dur, { CFrame = CFrame.new(p1) * giroA })
	end
end

-- rede de teia que prende no chao
local function redeEm(pos)
	local cor = Color3.fromRGB(230, 230, 240)
	local n = 10
	for i = 0, n - 1 do
		local a = i / n * 2 * math.pi
		for _, r in ipairs({ 1.4, 2.8 }) do
			local p0 = pos + Vector3.new(math.cos(a) * r, 0.1, math.sin(a) * r)
			local p1 = pos + Vector3.new(math.cos(a + 2 * math.pi / n) * r, 0.1, math.sin(a + 2 * math.pi / n) * r)
			local fio = bloquinho(CFrame.lookAt((p0 + p1) / 2, p1), Vector3.new(0.12, 0.12, (p1 - p0).Magnitude), cor, false)
			fio.Transparency = 0.15
			task.delay(1.6, function() animarSumindo(fio, 0.6) end)
		end
		local ponta = pos + Vector3.new(math.cos(a) * 3.2, 0.1, math.sin(a) * 3.2)
		local raio = bloquinho(CFrame.lookAt((pos + ponta) / 2 + Vector3.new(0, 0.1, 0), ponta + Vector3.new(0, 0.1, 0)),
			Vector3.new(0.12, 0.12, 3.2), cor, false)
		raio.Transparency = 0.15
		task.delay(1.6, function() animarSumindo(raio, 0.6) end)
	end
end

-- ============ NUMEROS DE DANO E BARRA DE VIDA ============
local function numeroDeDano(parte, texto, cor)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(120, 40)
	gui.StudsOffsetWorldSpace = Vector3.new(math.random() * 2 - 1, 2, 0)
	gui.AlwaysOnTop = true
	gui.Adornee = parte
	local rotulo = Instance.new("TextLabel")
	rotulo.Size = UDim2.fromScale(1, 1)
	rotulo.BackgroundTransparency = 1
	rotulo.Text = texto
	rotulo.TextColor3 = cor
	rotulo.TextStrokeTransparency = 0
	rotulo.Font = Enum.Font.Arcade
	rotulo.TextScaled = true
	rotulo.Parent = gui
	gui.Parent = parte
	TweenService:Create(gui, TweenInfo.new(0.9), { StudsOffsetWorldSpace = gui.StudsOffsetWorldSpace + Vector3.new(0, 3, 0) }):Play()
	TweenService:Create(rotulo, TweenInfo.new(0.9), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	Debris:AddItem(gui, 1)
end

local function criarBarra(info)
	local cabeca = info.modelo:FindFirstChild("Cabeca")
	local gui = Instance.new("BillboardGui")
	gui.Name = "BarraDeVida"
	gui.Size = UDim2.fromOffset(300, 46)
	gui.StudsOffsetWorldSpace = Vector3.new(0, 9, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 140
	gui.Enabled = false
	gui.Adornee = cabeca
	local nome = Instance.new("TextLabel")
	nome.Size = UDim2.new(1, 0, 0, 20)
	nome.BackgroundTransparency = 1
	nome.Text = "A TECELA FAMINTA"
	nome.TextColor3 = Color3.fromRGB(235, 225, 255)
	nome.TextStrokeTransparency = 0
	nome.Font = Enum.Font.Arcade
	nome.TextScaled = true
	nome.Parent = gui
	local fundo = Instance.new("Frame")
	fundo.Position = UDim2.new(0, 0, 0, 24)
	fundo.Size = UDim2.new(1, 0, 0, 16)
	fundo.BackgroundColor3 = Color3.fromRGB(20, 16, 28)
	fundo.BorderSizePixel = 0
	fundo.Parent = gui
	local barra = Instance.new("Frame")
	barra.Name = "Barra"
	barra.Position = UDim2.fromOffset(2, 2)
	barra.Size = UDim2.new(1, -4, 1, -4)
	barra.BackgroundColor3 = Color3.fromRGB(176, 92, 255)
	barra.BorderSizePixel = 0
	barra.Parent = fundo
	gui.Parent = cabeca
	info.barra, info.barraGui = barra, gui
end

local function atualizarBarra(info)
	if not info.barra then return end
	local f = math.clamp(info.vida / info.vidaMax, 0, 1)
	info.barra.Size = UDim2.new(f, -4, 1, -4)
	info.barra.BackgroundColor3 = (f < 0.5) and Color3.fromRGB(230, 60, 90) or Color3.fromRGB(176, 92, 255)
end

-- ============ LEITURA DAS ARANHAS ============
local aranhas = {}

local function ler(m)
	local base = m.WorldPivot
	local info = {
		modelo = m, base = base, casa = base, s = m:GetAttribute("Escala"),
		chefe = m:GetAttribute("Chefe") == true,
		pernas = {}, corpo = {}, anim = "Parado", t = math.random() * 2, ultima = misturar({}, {}, 0),
		deT = 1, disp = {}, ciclo = math.random(), passoPeso = 0, velFator = 1, recarga = 0,
		vida = m:GetAttribute("Vida"), vidaMax = m:GetAttribute("VidaMax"),
		pivo = {
			Corpo = m:GetAttribute("PivoCorpo"), Abdomen = m:GetAttribute("PivoAbdomen"), Cabeca = m:GetAttribute("PivoCabeca"),
			PresaE = m:GetAttribute("PivoPresaE"), PresaD = m:GetAttribute("PivoPresaD"),
		},
		passada = m:GetAttribute("Passada"), alturaPasso = m:GetAttribute("AlturaPasso"), frequencia = m:GetAttribute("Frequencia"),
	}
	local n = m:GetAttribute("Pontos")
	for idx = 1, 8 do
		local pts = {}
		for i = 1, n do pts[i] = m:GetAttribute(("P%d_%d"):format(idx, i)) end
		info.pernas[idx] = { pts = pts, segs = {}, juntas = {} }
	end
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then
			local perna = p:GetAttribute("Perna")
			if perna then
				local L = info.pernas[perna]
				if p:GetAttribute("IA") then
					table.insert(L.segs, { parte = p, a = p:GetAttribute("IA"), b = p:GetAttribute("IB") })
				else
					table.insert(L.juntas, { parte = p, i = p:GetAttribute("IP"), d = p:GetAttribute("Desloc") or Vector3.new(),
						rot = base:ToObjectSpace(p.CFrame).Rotation })
				end
			else
				table.insert(info.corpo, { parte = p, grupo = p:GetAttribute("Grupo") or "Corpo", offset = base:ToObjectSpace(p.CFrame),
					transp = p.Transparency })
			end
		end
	end
	return info
end

-- ============ APLICAR A POSE ============
local function aplicar(info, pose)
	local s, base = info.s, info.base
	local corpoT = CFrame.new(0, pose.cy * s, pose.cz * s) * girarEm(info.pivo.Corpo, pose.rx, pose.ry, pose.rz)
	local T = { Corpo = corpoT }
	T.Abdomen = corpoT * girarEm(info.pivo.Abdomen, pose.ab, 0, 0)
	T.Cabeca = corpoT * girarEm(info.pivo.Cabeca, pose.cab, 0, 0)
	T.PresaE = T.Cabeca * girarEm(info.pivo.PresaE, 0, 0, -pose.pr)
	T.PresaD = T.Cabeca * girarEm(info.pivo.PresaD, 0, 0, pose.pr)
	for _, c in ipairs(info.corpo) do
		c.parte.CFrame = base * (T[c.grupo] or corpoT) * c.offset
	end
	local S, H, w = info.passada, info.alturaPasso, info.passoPeso
	for idx, L in ipairs(info.pernas) do
		local k = (idx - 1) % 4
		local lado = (idx <= 4) and -1 or 1
		local u = (info.ciclo + ((k + ((lado < 0) and 0 or 1)) % 2) * 0.5) % 1
		local dz, lift
		if u < 0.5 then
			dz, lift = -S / 2 + S * (u / 0.5), 0
		else
			local v = (u - 0.5) / 0.5
			dz, lift = S / 2 - S * v, H * math.sin(math.pi * v)
		end
		dz, lift = dz * w, lift * w
		local fr = pose.fr * ((k == 0) and 1 or ((k == 1) and 0.45 or 0))
		local pts = L.pts
		local n = #pts
		local R1, Rn = pts[1], pts[n]
		local ponta = Rn + Vector3.new(0, lift + fr * H * 1.4, dz - fr * S * 0.5)
		if pose.curl > 0 then
			ponta = ponta:Lerp(corpoT * (R1 + (Rn - R1) * 0.25) + Vector3.new(0, 0.5 * s, 0), pose.curl)
		end
		local delta = ponta - Rn
		local novos = { [1] = corpoT * R1, [n] = ponta }
		for i = 2, n - 1 do
			local f = (i - 1) / (n - 1)
			local Pi = (corpoT * pts[i]):Lerp(pts[i] + delta, f) + Vector3.new(0, (lift + fr * H * 0.8) * 0.5 * math.sin(math.pi * f), 0)
			if pose.curl > 0 then
				Pi = Pi:Lerp(corpoT * (R1 + (pts[i] - R1) * 0.45) + Vector3.new(0, 0.9 * s, 0), pose.curl * 0.8)
			end
			novos[i] = Pi
		end
		for _, sg in ipairs(L.segs) do
			local a, b = novos[sg.a], novos[sg.b]
			local d = b - a
			local cima = (math.abs(d.Unit.Y) > 0.98) and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)
			sg.parte.Size = Vector3.new(sg.parte.Size.X, sg.parte.Size.Y, d.Magnitude)
			sg.parte.CFrame = base * CFrame.lookAt((a + b) / 2, b, cima)
		end
		for _, j in ipairs(L.juntas) do
			j.parte.CFrame = base * CFrame.new(novos[j.i] + j.d) * j.rot
		end
	end
end

-- ============ ESTADOS ============
local function animDe(info, nome)
	return (info.chefe and DADOS.Chefe[nome]) or DADOS.Comum[nome]
end

local function tocar(info, nome)
	if info.morta and nome ~= "Morte" then return end
	if not animDe(info, nome) then return end
	info.de, info.deT = info.ultima, 0
	info.anim, info.t, info.disp, info.golpeFeito = nome, 0, {}, false
end

local function atualizarAnim(info, dt)
	local a = animDe(info, info.anim)
	info.t = info.t + dt
	if a.loop then
		info.t = info.t % a.dur
	elseif info.t >= a.dur then
		if a.segura then
			info.t = a.dur
		else
			tocar(info, "Parado")
			a = animDe(info, "Parado")
		end
	end
	local peso = a.passo and 1 or 0
	info.passoPeso = info.passoPeso + (peso - info.passoPeso) * math.min(1, dt * 6)
	if info.passoPeso > 0.01 then
		info.ciclo = (info.ciclo + dt * info.frequencia * info.velFator) % 1
	end
	local pose = poseEm(a, info.t)
	if info.de and info.deT < MISTURA then
		info.deT = info.deT + dt
		pose = misturar(info.de, pose, suave(math.min(1, info.deT / MISTURA)))
	end
	info.ultima = pose
	if a.fx then
		for i, fx in ipairs(a.fx) do
			if not info.disp[i] and info.t >= fx.t then
				info.disp[i] = true
				local f = FX[fx.fx]
				if f then task.spawn(f, info, fx) end
			end
		end
	end
	if a.golpe and not info.golpeFeito and info.t >= a.golpe then
		info.golpeFeito = true
		if info.aoGolpe then task.spawn(info.aoGolpe, info, info.anim) end
	end
	aplicar(info, pose)
end

-- ============ ALVOS ============
local raio = RaycastParams.new()
raio.FilterType = Enum.RaycastFilterType.Exclude
raio.RespectCanCollide = true

local function jogadorMaisPerto(pos, alcance)
	local melhor, dist = nil, alcance
	for _, jogador in ipairs(Players:GetPlayers()) do
		local personagem = jogador.Character
		local hrp = personagem and personagem:FindFirstChild("HumanoidRootPart")
		local hum = personagem and personagem:FindFirstChildOfClass("Humanoid")
		if hrp and hum and hum.Health > 0 then
			local d = (hrp.Position - pos).Magnitude
			if d < dist then melhor, dist = { jogador = jogador, hrp = hrp, hum = hum }, d end
		end
	end
	return melhor, dist
end

local function livre(de, para, ignorar)
	raio.FilterDescendantsInstances = { personagensF, ignorar }
	return workspace:Raycast(de, para - de, raio) == nil
end

local function ferir(hum, dano)
	if hum and hum.Health > 0 then hum:TakeDamage(dano) end
end

local function prender(hum)
	if not hum or hum:GetAttribute("PresoNaTeia") then return end
	hum:SetAttribute("PresoNaTeia", true)
	local antes = hum.WalkSpeed
	hum.WalkSpeed = math.min(antes, 4)
	task.delay(3, function()
		if hum.Parent then
			hum.WalkSpeed = antes
			hum:SetAttribute("PresoNaTeia", nil)
		end
	end)
end

-- ============ VIDA E MORTE ============
local function parteDeClique(info)
	return info.modelo:FindFirstChild("Abdomen") or info.modelo:FindFirstChild("Cabeca")
end

local function renascer(info)
	info.morta = false
	info.base = info.casa
	for _, c in ipairs(info.corpo) do c.parte.Transparency = c.transp end
	for _, L in ipairs(info.pernas) do
		for _, sg in ipairs(L.segs) do sg.parte.Transparency = 0 end
		for _, j in ipairs(L.juntas) do j.parte.Transparency = 0 end
	end
	info.vida = info.vidaMax
	info.modelo:SetAttribute("Vida", info.vidaMax)
	info.anim, info.t, info.ultima, info.de = "Parado", 0, misturar({}, {}, 0), nil
end

local function morrer(info)
	info.morta = true
	tocar(info, "Morte")
	if info.chefe then
		task.delay(1.4, function()
			local de, para = info.base, info.modelo:GetAttribute("ChaoCF") or info.base
			local t = 0
			while t < 1 do
				t = math.min(1, t + RunService.Heartbeat:Wait() / 0.9)
				info.base = de:Lerp(para, t * t)
			end
			faiscasEm(para.Position + Vector3.new(0, 2, 0), Color3.fromRGB(190, 110, 255), 24)
			for _, l in ipairs(info.modelo:GetDescendants()) do
				if l:IsA("PointLight") then l.Brightness = 0.3 end
			end
			if info.barraGui then info.barraGui.Enabled = false end
			numeroDeDano(info.modelo:FindFirstChild("Cabeca"), "DERROTADA!", Color3.fromRGB(255, 220, 120))
			raiz:SetAttribute("TecelaDerrotada", true)
		end)
	else
		task.delay(4, function()
			for _, p in ipairs(info.modelo:GetDescendants()) do
				if p:IsA("BasePart") then
					TweenService:Create(p, TweenInfo.new(1), { Transparency = 1 }):Play()
				end
			end
		end)
		task.delay(RENASCER, function() renascer(info) end)
	end
end

local function conectarVida(info)
	local m = info.modelo
	m:GetAttributeChangedSignal("Vida"):Connect(function()
		local nova = m:GetAttribute("Vida")
		local perdeu = info.vida - nova
		info.vida = nova
		if info.morta then return end
		atualizarBarra(info)
		if perdeu > 0 then
			numeroDeDano(parteDeClique(info), "-" .. math.floor(perdeu + 0.5), Color3.fromRGB(255, 90, 100))
		end
		if nova <= 0 then
			morrer(info)
		elseif perdeu > 0 and info.anim ~= "Furia" and info.anim ~= "Ataque" then
			tocar(info, "Dano")
		end
	end)
	local clique = Instance.new("ClickDetector")
	clique.MaxActivationDistance = info.chefe and 60 or 32
	clique.Parent = parteDeClique(info)
	clique.MouseClick:Connect(function()
		if info.morta or (info.chefe and not info.desperta) then return end
		m:SetAttribute("Vida", info.vida - (info.chefe and DANO_CLIQUE_CHEFE or DANO_CLIQUE_CRIA))
	end)
end

-- ============ COMPORTAMENTO DAS CRIAS ============
local function virarPara(info, alvoPos, dt, rapido)
	local pos = info.base.Position
	local plano = Vector3.new(alvoPos.X, pos.Y, alvoPos.Z)
	if (plano - pos).Magnitude < 0.05 then return end
	info.base = info.base:Lerp(CFrame.lookAt(pos, plano), math.min(1, dt * (rapido and 8 or 4)))
end

local function golpeCria(info)
	local alvo = info.alvo
	local pos = info.base.Position
	if alvo and alvo.hrp.Parent and Vector3.new(alvo.hrp.Position.X - pos.X, 0, alvo.hrp.Position.Z - pos.Z).Magnitude < 4.2 then
		ferir(alvo.hum, DANO_MORDIDA_CRIA)
	end
end

local function iaCria(info, dt)
	if info.morta then return end
	info.recarga = math.max(0, info.recarga - dt)
	if info.anim == "Ataque" or info.anim == "Dano" then return end
	local pos = info.base.Position
	local olhos = pos + Vector3.new(0, 1.4, 0)
	local alvo, dist = jogadorMaisPerto(pos, 16)
	if alvo and (math.abs(alvo.hrp.Position.Y - pos.Y) > 8 or not livre(olhos, alvo.hrp.Position, alvo.hrp.Parent)
		or (alvo.hrp.Position - info.casa.Position).Magnitude > 22) then
		alvo = nil
	end
	info.alvo = alvo
	local destino
	if alvo then
		local noChao = Vector3.new(alvo.hrp.Position.X - pos.X, 0, alvo.hrp.Position.Z - pos.Z).Magnitude
		if noChao <= 3.4 then
			virarPara(info, alvo.hrp.Position, dt, true)
			if info.recarga <= 0 then
				tocar(info, "Ataque")
				info.recarga = 1.4
			elseif info.anim == "Andar" then
				tocar(info, "Parado")
			end
			return
		end
		destino = alvo.hrp.Position
	else
		info.esperaVagar = (info.esperaVagar or math.random() * 3) - dt
		if info.esperaVagar <= 0 then
			local a, r = math.random() * 2 * math.pi, math.random() * 4
			info.vagar = info.casa.Position + Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)
			info.esperaVagar = 3 + math.random() * 3
		end
		destino = info.vagar
	end
	local andando = false
	if destino then
		local plano = Vector3.new(destino.X, pos.Y, destino.Z)
		if (plano - pos).Magnitude > (alvo and 2.6 or 0.4) then
			virarPara(info, plano, dt, alvo ~= nil)
			local vel = alvo and 7 or 2.6
			local frente = info.base.LookVector
			raio.FilterDescendantsInstances = { personagensF }
			if not workspace:Raycast(olhos, frente * (1.6 * info.s + 0.6), raio) then
				info.base = info.base + frente * vel * dt
				andando = true
			end
			info.velFator = vel / 3
		elseif not alvo then
			info.vagar = nil
		end
	end
	if andando and info.anim ~= "Andar" then
		tocar(info, "Andar")
	elseif not andando and info.anim == "Andar" then
		tocar(info, "Parado")
	end
end

-- ============ COMPORTAMENTO DA TECELA ============
local function golpeChefe(info, nome)
	local alvo = info.alvo
	if nome == "Ataque" then
		local ponto = info.base * Vector3.new(0, 1.5, -7)
		for _, jogador in ipairs(Players:GetPlayers()) do
			local hrp = jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart")
			if hrp and (hrp.Position - ponto).Magnitude < 9 then
				ferir(jogador.Character:FindFirstChildOfClass("Humanoid"), DANO_MORDIDA_CHEFE)
			end
		end
	elseif nome == "Teia" and alvo and alvo.hrp.Parent then
		local cabeca = info.modelo:FindFirstChild("Cabeca")
		local de = cabeca.Position
		local para = alvo.hrp.Position - Vector3.new(0, 2.5, 0)
		local bola = bloquinho(CFrame.lookAt(de, para), Vector3.new(1.2, 1.2, 1.2), Color3.fromRGB(230, 230, 240), false)
		local tempo = math.clamp((para - de).Magnitude / 45, 0.25, 0.8)
		TweenService:Create(bola, TweenInfo.new(tempo, Enum.EasingStyle.Linear), { CFrame = CFrame.new(para) }):Play()
		Debris:AddItem(bola, tempo + 0.05)
		task.delay(tempo, function()
			redeEm(para)
			local hrp = alvo.hrp
			if hrp.Parent and (Vector3.new(hrp.Position.X, para.Y, hrp.Position.Z) - para).Magnitude < 4.5 then
				ferir(alvo.hum, DANO_TEIA)
				prender(alvo.hum)
			end
		end)
	end
end

local function iaChefe(info, dt)
	if info.morta or not info.desperta then return end
	if info.descendo then
		local d = math.min(info.descendo, dt * 2.2)
		info.base = info.base * CFrame.new(0, 0, -d)
		info.descendo = info.descendo - d
		if info.descendo <= 0 then
			info.descendo = nil
			tocar(info, "Parado")
		end
		return
	end
	info.recarga = info.recarga - dt
	if info.anim ~= "Parado" or info.recarga > 0 then return end
	local cabeca = info.modelo:FindFirstChild("Cabeca")
	local alvo, dist = jogadorMaisPerto(cabeca.Position, 70)
	if not alvo then return end
	info.alvo = alvo
	local ritmo = info.furiaUsada and 0.65 or 1
	if not info.furiaUsada and info.vida <= info.vidaMax * 0.5 then
		info.furiaUsada = true
		tocar(info, "Furia")
		for _, l in ipairs(info.modelo:GetDescendants()) do
			if l:IsA("PointLight") then l.Brightness = 4 end
		end
		info.recarga = 2.4
	elseif dist <= 11 then
		tocar(info, "Ataque")
		info.recarga = 2.2 * ritmo
	else
		tocar(info, "Teia")
		info.recarga = 3.2 * ritmo
	end
end

-- ============ INICIO ============
for _, m in ipairs(personagensF:GetChildren()) do
	if m:IsA("Model") and m:GetAttribute("Aranha") then
		local info = ler(m)
		info.aoGolpe = info.chefe and golpeChefe or golpeCria
		conectarVida(info)
		if info.chefe then
			criarBarra(info)
			m:GetAttributeChangedSignal("Desperta"):Connect(function()
				if m:GetAttribute("Desperta") and not info.desperta then
					info.desperta = true
					info.descendo = 5
					info.velFator = 0.8
					info.barraGui.Enabled = true
					tocar(info, "Andar")
				end
			end)
		end
		table.insert(aranhas, info)
	end
end

RunService.Heartbeat:Connect(function(dt)
	dt = math.min(dt, 0.1)
	for _, info in ipairs(aranhas) do
		if info.chefe then iaChefe(info, dt) else iaCria(info, dt) end
		atualizarAnim(info, dt)
	end
end)
]==]
local dadosAranhas = Instance.new("ModuleScript")
dadosAranhas.Name = "DadosDasAranhas"
dadosAranhas.Source = [==[
-- Animacoes das aranhas (design: Yuri Ramos Hernandez)
-- Valores em "escala" da aranha (cy, cz e posicoes de efeito) e em graus (giros).
--   cy, cz: sobe/desce e frente(-)/tras(+) do corpo
--   rx, ry, rz: giro do corpo (rx positivo ergue a frente)
--   ab: balanco do abdomen | cab: cabeca | pr: abertura das presas
--   fr: ergue as patas da frente | curl: dobra as patas (morte)
-- passo = true liga o ciclo de caminhada das patas.
-- golpe = momento em que o ataque acerta (a IA aplica o dano aqui).
local VERMELHO = {255, 70, 80}
local VIOLETA = {180, 110, 255}

return {
	Comum = {
		Parado = { dur = 2.4, loop = true, k = {
			{0,   { pr = 2 }},
			{1.2, { cy = -0.05, ab = 4, pr = 7, cab = 2 }},
			{2.4, { pr = 2 }},
		}},
		Andar = { dur = 1, loop = true, passo = true, k = {
			{0,    { cy = 0.05, ab = -3, rz = -1.5 }},
			{0.5,  { cy = 0.12, ab = 3, rz = 1.5 }},
			{1,    { cy = 0.05, ab = -3, rz = -1.5 }},
		}},
		Ataque = { dur = 0.85, golpe = 0.42, k = {
			{0,    {}},
			{0.28, { cz = 0.7, rx = 14, fr = 1, pr = 28, cab = 8, ab = -6 }},
			{0.42, { cz = -1.3, rx = -10, fr = 0.4, pr = 0, cab = -6, ab = 8 }},
			{0.55, { cz = -1.1, rx = -8, fr = 0.2, pr = 4 }},
			{0.85, {}},
		}, fx = {
			{ t = 0.42, fx = "faiscas", c = {0, 0.9, -2.2}, cor = VERMELHO, n = 8 },
		}},
		Dano = { dur = 0.5, k = {
			{0,    {}},
			{0.07, { cz = 0.5, rx = 12, rz = 7, ab = 12, pr = 22, cab = 10 }},
			{0.5,  {}},
		}, fx = {
			{ t = 0.02, fx = "faiscas", c = {0, 1.3, 0.4}, cor = {255, 60, 70}, n = 10 },
		}},
		Morte = { dur = 1.4, segura = true, k = {
			{0,    {}},
			{0.15, { cz = 0.4, rx = 18, pr = 30, ab = 15, fr = 0.6 }},
			{0.6,  { cy = -0.65, rx = -6, rz = 22, curl = 1, pr = 8, ab = -10 }},
			{1.4,  { cy = -0.7, rx = -6, rz = 24, curl = 1, pr = 4, ab = -12 }},
		}},
	},
	Chefe = {
		Teia = { dur = 1.1, golpe = 0.5, k = {
			{0,    {}},
			{0.35, { rx = 16, cz = 0.4, pr = 32, cab = 12, fr = 0.5 }},
			{0.5,  { rx = -6, cz = -0.4, pr = 10, cab = -4 }},
			{1.1,  {}},
		}},
		Furia = { dur = 1.8, k = {
			{0,    {}},
			{0.4,  { rx = 32, cy = 0.45, fr = 1.6, pr = 34, cab = 14, ab = -14 }},
			{0.7,  { rx = 30, cy = 0.5, fr = 1.5, pr = 8, cab = 12, ab = -14 }},
			{0.9,  { rx = 32, cy = 0.45, fr = 1.6, pr = 34, cab = 14, ab = -14 }},
			{1.1,  { rx = 30, cy = 0.5, fr = 1.5, pr = 8, cab = 12, ab = -14 }},
			{1.8,  {}},
		}, fx = {
			{ t = 0.4,  fx = "anel", c = {0, 0.1, 0}, r0 = 0.5, r1 = 3, subida = 0, cor = VIOLETA, dur = 0.7 },
			{ t = 0.45, fx = "faiscas", c = {0, 2.4, 0.9}, cor = {220, 170, 255}, n = 18 },
			{ t = 0.9,  fx = "anel", c = {0, 0.1, 0}, r0 = 0.5, r1 = 3.5, subida = 0, cor = VIOLETA, dur = 0.7 },
		}},
	},
}
]==]
dadosAranhas.Parent = aranhasVivas
aranhasVivas.Parent = raiz

-- ===================== EFEITOS DE TELA (cada jogador) =====================
local StarterPlayer = game:GetService("StarterPlayer")
local scriptsJogador = StarterPlayer:FindFirstChild("StarterPlayerScripts")
if scriptsJogador then
	local velho = scriptsJogador:FindFirstChild("EfeitosTocaTecela")
	if velho then velho:Destroy() end
	local efeitos = Instance.new("LocalScript")
	efeitos.Name = "EfeitosTocaTecela"
	efeitos.Source = [==[
-- A Toca da Tecela Faminta: escuridao e cor de cada area
-- Design: Yuri Ramos Hernandez
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local jogador = Players.LocalPlayer
local raiz = workspace:WaitForChild("TocaDaTecelaFaminta")
local zonas = raiz:WaitForChild("Zonas")

local efeito = Instance.new("ColorCorrectionEffect")
efeito.Name = "EfeitoTocaTecela"
efeito.Parent = Lighting

local brilho, saturacao = 0, 0
local tinta = Color3.new(1, 1, 1)
local zonaAtual = nil

local function dentro(zona, pos)
	local rel = zona.CFrame:PointToObjectSpace(pos)
	local s = zona.Size / 2
	return math.abs(rel.X) <= s.X and math.abs(rel.Y) <= s.Y and math.abs(rel.Z) <= s.Z
end

local function zonaDe(pos)
	local melhor, valor = nil, -1
	for _, z in ipairs(zonas:GetChildren()) do
		if z:IsA("BasePart") and dentro(z, pos) then
			local e = z:GetAttribute("Escuridao") or 0
			if e > valor then
				melhor, valor = z, e
			end
		end
	end
	return melhor
end

RunService.RenderStepped:Connect(function(dt)
	local personagem = jogador.Character
	local hrp = personagem and personagem:FindFirstChild("HumanoidRootPart")
	local alvoBrilho, alvoSat, alvoTinta = 0, 0, Color3.new(1, 1, 1)
	if hrp then
		local z = zonaDe(hrp.Position)
		if z ~= zonaAtual then
			zonaAtual = z
			if z then
				pcall(function()
					StarterGui:SetCore("SendNotification", {
						Title = z:GetAttribute("Nome") or z.Name,
						Text = z:GetAttribute("Teste") or z:GetAttribute("Descricao") or "",
						Duration = 6,
					})
				end)
			end
		end
		if z then
			local e = z:GetAttribute("Escuridao") or 0
			alvoBrilho = -0.55 * e
			alvoSat = -0.7 * e
			alvoTinta = z:GetAttribute("Tinta") or alvoTinta
		end
	end
	local k = math.min(1, dt * 2)
	brilho = brilho + (alvoBrilho - brilho) * k
	saturacao = saturacao + (alvoSat - saturacao) * k
	tinta = tinta:Lerp(alvoTinta, k)
	efeito.Brightness = brilho
	efeito.Saturation = saturacao
	efeito.TintColor = tinta
end)
]==]
	efeitos.Parent = scriptsJogador
end

-- ===================== ILUMINACAO =====================
if AJUSTAR_ILUMINACAO then
	local Lighting = game:GetService("Lighting")
	Lighting.ClockTime = 20.5
	Lighting.Brightness = 1.2
	Lighting.OutdoorAmbient = Color3.fromRGB(70, 68, 95)
	Lighting.Ambient = Color3.fromRGB(26, 25, 34)
	local atm = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atm.Density = 0.38
	atm.Color = Color3.fromRGB(110, 105, 140)
	atm.Decay = Color3.fromRGB(50, 45, 70)
	atm.Glare = 0
	atm.Haze = 1.5
	atm.Parent = Lighting
end

-- ===================== FINALIZAR =====================
raiz.Parent = workspace
game:GetService("Selection"):Set({ raiz })
local cam = workspace.CurrentCamera
cam.CFrame = CFrame.lookAt((ORIGEM * CFrame.new(-45, 32, -50)).Position, (ORIGEM * CFrame.new(45, 22, 0)).Position)

local total = 0
for _, d in ipairs(raiz:GetDescendants()) do
	if d:IsA("BasePart") then total = total + 1 end
end
print(("A Toca da Tecela Faminta criada! %d pecas, %d teias, %d crias. Design: Yuri Ramos Hernandez"):format(total, contTeia, contCria))
