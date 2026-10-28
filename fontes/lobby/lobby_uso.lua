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
