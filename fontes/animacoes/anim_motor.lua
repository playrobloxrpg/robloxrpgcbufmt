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
