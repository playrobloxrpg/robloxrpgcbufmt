
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
