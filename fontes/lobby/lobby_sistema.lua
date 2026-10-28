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
