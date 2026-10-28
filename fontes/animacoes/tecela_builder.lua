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
			seg("Coxa", quadril, joelho, 0.9, "carapaca2")
			seg("Tibia", joelho, tornozelo, 0.75, "carapaca")
			seg("Metatarso", tornozelo, meio, 0.55, "carapaca2")
			seg("Garra", meio, ponta, 0.42, "cristal", "neon")
			b("Joelho", 1.15, 1.15, 1.15, joelho.X, joelho.Y, joelho.Z, "articulacao")
			b("JoelhoEspinho", 0.35, 0.8, 0.35, joelho.X, joelho.Y + 0.9, joelho.Z, "osso")
			b("Tornozelo", 0.9, 0.9, 0.9, tornozelo.X, tornozelo.Y, tornozelo.Z, "articulacao")
			b("JuntaMeio", 0.6, 0.6, 0.6, meio.X, meio.Y, meio.Z, "osso")
		end
	end

	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
	return m
end
