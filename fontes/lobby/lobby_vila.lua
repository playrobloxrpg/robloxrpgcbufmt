
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
