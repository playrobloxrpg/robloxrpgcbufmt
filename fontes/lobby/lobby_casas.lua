
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
