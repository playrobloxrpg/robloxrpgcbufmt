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
	if alvo and alvo.hrp.Parent and (alvo.hrp.Position - info.base.Position).Magnitude < 4.5 then
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
		if dist <= 3.4 then
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
		if (plano - pos).Magnitude > (alvo and 2.8 or 0.4) then
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
