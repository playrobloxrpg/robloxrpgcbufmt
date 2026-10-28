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
