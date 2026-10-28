-- Interface da Vila Pedra-Musgo: tela das lojas e avisos (design: Yuri Ramos Hernandez)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local jogador = Players.LocalPlayer
local remotos = ReplicatedStorage:WaitForChild("LobbyRemotos")
local AbrirLoja, ComprarItem, Aviso = remotos.AbrirLoja, remotos.ComprarItem, remotos.Aviso

local FUNDO = Color3.fromRGB(24, 20, 32)
local PAINEL = Color3.fromRGB(36, 31, 48)
local BORDA = Color3.fromRGB(70, 58, 92)
local TEXTO = Color3.fromRGB(235, 228, 245)
local SUAVE = Color3.fromRGB(170, 160, 190)
local DESTAQUE = Color3.fromRGB(176, 92, 255)
local OURO = Color3.fromRGB(230, 190, 90)

local tela = Instance.new("ScreenGui")
tela.Name = "InterfaceDoLobby"
tela.ResetOnSpawn = false
tela.IgnoreGuiInset = false
tela.Parent = jogador:WaitForChild("PlayerGui")

local function borda(obj, cor, esp)
	local s = Instance.new("UIStroke")
	s.Color = cor or BORDA
	s.Thickness = esp or 2
	s.Parent = obj
end
local function texto(pai, props)
	local r = Instance.new("TextLabel")
	r.BackgroundTransparency = 1
	r.TextColor3 = TEXTO
	r.Font = Enum.Font.Gotham
	r.TextSize = 16
	r.TextXAlignment = Enum.TextXAlignment.Left
	for k, v in pairs(props) do r[k] = v end
	r.Parent = pai
	return r
end

-- ===== aviso no alto da tela =====
local aviso = Instance.new("TextLabel")
aviso.AnchorPoint = Vector2.new(0.5, 0)
aviso.Position = UDim2.new(0.5, 0, 0, 16)
aviso.Size = UDim2.fromOffset(440, 40)
aviso.BackgroundColor3 = FUNDO
aviso.BackgroundTransparency = 0.1
aviso.TextColor3 = TEXTO
aviso.Font = Enum.Font.GothamMedium
aviso.TextSize = 16
aviso.TextWrapped = true
aviso.Visible = false
aviso.Parent = tela
borda(aviso, DESTAQUE)
local contagem = 0
Aviso.OnClientEvent:Connect(function(msg)
	contagem = contagem + 1
	local minha = contagem
	aviso.Text = msg
	aviso.Visible = true
	task.delay(3.5, function()
		if contagem == minha then aviso.Visible = false end
	end)
end)

-- ===== janela da loja =====
local janela = Instance.new("Frame")
janela.AnchorPoint = Vector2.new(0.5, 0.5)
janela.Position = UDim2.fromScale(0.5, 0.5)
janela.Size = UDim2.new(0, 520, 0, 430)
janela.BackgroundColor3 = FUNDO
janela.Visible = false
janela.Parent = tela
borda(janela, BORDA, 3)
local limite = Instance.new("UISizeConstraint")
limite.MaxSize = Vector2.new(520, 430)
limite.Parent = janela
local escala = Instance.new("UIScale")
escala.Parent = janela
local function ajustar()
	local cam = workspace.CurrentCamera
	local v = cam and cam.ViewportSize or Vector2.new(800, 600)
	escala.Scale = math.min(1, (v.X - 24) / 520, (v.Y - 80) / 430)
end
ajustar()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ajustar) end

local tituloLoja = texto(janela, { Position = UDim2.fromOffset(20, 14), Size = UDim2.new(1, -120, 0, 30), Font = Enum.Font.Arcade, TextSize = 24 })
local moedasTxt = texto(janela, { Position = UDim2.new(1, -170, 0, 16), Size = UDim2.fromOffset(110, 26), TextColor3 = OURO, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right })
local fechar = Instance.new("TextButton")
fechar.Position = UDim2.new(1, -48, 0, 12)
fechar.Size = UDim2.fromOffset(34, 34)
fechar.BackgroundColor3 = PAINEL
fechar.Text = "X"
fechar.TextColor3 = TEXTO
fechar.Font = Enum.Font.GothamBold
fechar.TextSize = 18
fechar.Parent = janela
borda(fechar)
fechar.MouseButton1Click:Connect(function() janela.Visible = false end)

local lista = Instance.new("ScrollingFrame")
lista.Position = UDim2.fromOffset(16, 58)
lista.Size = UDim2.new(1, -32, 1, -74)
lista.BackgroundTransparency = 1
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 6
lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.CanvasSize = UDim2.new()
lista.Parent = janela
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = lista

local function atualizarMoedas()
	local ls = jogador:FindFirstChild("leaderstats")
	local m = ls and ls:FindFirstChild("Moedas")
	moedasTxt.Text = m and (m.Value .. " moedas") or ""
end

local lojaAtual
AbrirLoja.OnClientEvent:Connect(function(loja)
	lojaAtual = loja.id
	tituloLoja.Text = string.upper(loja.titulo)
	atualizarMoedas()
	for _, c in ipairs(lista:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	for i, item in ipairs(loja.itens) do
		local linha = Instance.new("Frame")
		linha.LayoutOrder = i
		linha.Size = UDim2.new(1, -8, 0, 64)
		linha.BackgroundColor3 = PAINEL
		linha.Parent = lista
		borda(linha)
		local icone = Instance.new("Frame")
		icone.Position = UDim2.fromOffset(12, 14)
		icone.Size = UDim2.fromOffset(36, 36)
		icone.BackgroundColor3 = Color3.fromRGB(item.cor[1], item.cor[2], item.cor[3])
		icone.Parent = linha
		borda(icone, Color3.fromRGB(10, 8, 14))
		texto(linha, { Text = item.nome, Position = UDim2.fromOffset(60, 10), Size = UDim2.new(1, -200, 0, 22), Font = Enum.Font.GothamBold })
		texto(linha, { Text = item.desc, Position = UDim2.fromOffset(60, 32), Size = UDim2.new(1, -200, 0, 22), TextSize = 13, TextColor3 = SUAVE, TextTruncate = Enum.TextTruncate.AtEnd })
		local botao = Instance.new("TextButton")
		botao.AnchorPoint = Vector2.new(1, 0.5)
		botao.Position = UDim2.new(1, -12, 0.5, 0)
		botao.Size = UDim2.fromOffset(120, 38)
		botao.BackgroundColor3 = DESTAQUE
		botao.Text = "Comprar - " .. item.preco
		botao.TextColor3 = Color3.fromRGB(255, 255, 255)
		botao.Font = Enum.Font.GothamBold
		botao.TextSize = 15
		botao.Parent = linha
		botao.MouseButton1Click:Connect(function()
			ComprarItem:FireServer(lojaAtual, item.id)
			task.delay(0.3, atualizarMoedas)
		end)
	end
	janela.Visible = true
end)
