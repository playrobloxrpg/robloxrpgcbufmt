-- Dados das animacoes de combate (design: Yuri Ramos Hernandez)
-- Cada animacao: dur (segundos), loop, k = lista de quadros-chave {tempo, pose}, fx = efeitos.
-- Pose: raiz = {x, y, z, giroX, giroY, giroZ}; tronco, cabeca, bracoE, bracoD, pernaE, pernaD = {giroX, giroY, giroZ} em graus.
-- giroX positivo leva o braco para frente e para cima; no tronco, inclina para tras.
local AZUL = {170, 210, 255}
local OURO = {255, 214, 110}
local VIOLETA = {180, 110, 255}
local PENA = {240, 236, 226}

return {
	Comum = {
		Parado = { dur = 1.6, loop = true, k = {
			{0,   { tronco = {-4, 0, 0}, bracoE = {4, 0, -4}, bracoD = {4, 0, 4} }},
			{0.8, { raiz = {0, -0.08, 0}, tronco = {-7, 0, 0}, cabeca = {3, 0, 0}, bracoE = {8, 0, -6}, bracoD = {8, 0, 6} }},
			{1.6, { tronco = {-4, 0, 0}, bracoE = {4, 0, -4}, bracoD = {4, 0, 4} }},
		}},
		Dano = { dur = 0.55, k = {
			{0,    {}},
			{0.08, { raiz = {0, 0, 0.5}, tronco = {16, 0, 0}, cabeca = {14, 0, 0}, bracoE = {-12, 0, -14}, bracoD = {-12, 0, 14} }},
			{0.55, {}},
		}, fx = {
			{ t = 0.04, fx = "faiscas", c = {0, 3.6, -1}, cor = {255, 70, 80}, n = 10 },
		}},
	},

	Cavaleiro = {
		Ataque = { dur = 0.95, k = {
			{0,    {}},
			{0.28, { bracoD = {140, 0, 8}, tronco = {8, -18, 0}, raiz = {0, 0, 0.2}, pernaE = {-10, 0, 0}, cabeca = {-6, 0, 0} }},
			{0.42, { bracoD = {-55, 0, 6}, tronco = {-18, 16, 0}, raiz = {0, -0.15, -0.8}, pernaD = {22, 0, 0}, pernaE = {-16, 0, 0} }},
			{0.62, { bracoD = {-50, 0, 6}, tronco = {-14, 12, 0}, raiz = {0, -0.15, -0.8}, pernaD = {20, 0, 0}, pernaE = {-14, 0, 0} }},
			{0.95, {}},
		}, fx = {
			{ t = 0.32, fx = "arco", plano = "v", c = {1.5, 4.0, -0.6}, r = 5.2, a0 = 150, a1 = -40, cor = AZUL },
		}},
		Habilidade = { dur = 1.3, k = {
			{0,    {}},
			{0.25, { bracoD = {70, 0, 30}, tronco = {-10, -50, 0}, raiz = {0, -0.3, 0}, pernaD = {15, 0, 0}, pernaE = {-15, 0, 0} }},
			{0.8,  { bracoD = {70, 0, 30}, tronco = {-10, -50, 0}, raiz = {0, -0.3, 0, 0, 360, 0}, pernaD = {15, 0, 0}, pernaE = {-15, 0, 0} }},
			{1.3,  { raiz = {0, 0, 0, 0, 360, 0} }},
		}, fx = {
			{ t = 0.35, fx = "anel", c = {0, 3.2, 0}, r0 = 2, r1 = 6.5, subida = 0, cor = AZUL, dur = 0.5 },
			{ t = 0.55, fx = "anel", c = {0, 3.0, 0}, r0 = 2, r1 = 7.5, subida = 0, cor = AZUL, dur = 0.5 },
		}},
	},

	Clerigo = {
		Ataque = { dur = 0.9, k = {
			{0,    {}},
			{0.28, { bracoD = {130, 0, 6}, tronco = {10, -10, 0}, raiz = {0, 0.1, 0.2} }},
			{0.42, { bracoD = {-45, 0, 4}, tronco = {-22, 10, 0}, raiz = {0, -0.25, -0.6}, pernaD = {20, 0, 0}, pernaE = {-12, 0, 0}, bracoE = {20, 0, -6} }},
			{0.6,  { bracoD = {-42, 0, 4}, tronco = {-20, 8, 0}, raiz = {0, -0.25, -0.6}, pernaD = {18, 0, 0}, pernaE = {-10, 0, 0}, bracoE = {18, 0, -6} }},
			{0.9,  {}},
		}, fx = {
			{ t = 0.4, fx = "faiscas", c = {1.5, 1.0, -3.2}, cor = OURO, n = 14 },
			{ t = 0.4, fx = "anel", c = {1.5, 0.2, -3.2}, r0 = 0.5, r1 = 3, subida = 0, cor = OURO, dur = 0.45 },
		}},
		Habilidade = { dur = 1.5, k = {
			{0,    {}},
			{0.35, { bracoD = {165, 0, -8}, bracoE = {35, 0, -10}, cabeca = {18, 0, 0}, tronco = {8, 0, 0}, raiz = {0, 0.3, 0} }},
			{1.1,  { bracoD = {165, 0, -8}, bracoE = {35, 0, -10}, cabeca = {18, 0, 0}, tronco = {8, 0, 0}, raiz = {0, 0.35, 0} }},
			{1.5,  {}},
		}, fx = {
			{ t = 0.4, fx = "anel", c = {0, 0.2, 0}, r0 = 1, r1 = 4.5, subida = 6, cor = OURO, dur = 1.0 },
			{ t = 0.5, fx = "faiscas", c = {1.5, 7.5, 0.5}, cor = {255, 236, 170}, n = 16 },
			{ t = 0.7, fx = "anel", c = {0, 0.2, 0}, r0 = 1, r1 = 4.5, subida = 6, cor = OURO, dur = 1.0 },
		}},
	},

	Arcanista = {
		Ataque = { dur = 0.9, k = {
			{0,    {}},
			{0.22, { bracoD = {25, 0, 10}, tronco = {6, -14, 0} }},
			{0.42, { bracoD = {-60, 0, 4}, tronco = {-12, 12, 0}, raiz = {0, 0, -0.3}, bracoE = {30, 0, -10} }},
			{0.6,  { bracoD = {-58, 0, 4}, tronco = {-10, 10, 0}, raiz = {0, 0, -0.3}, bracoE = {26, 0, -10} }},
			{0.9,  {}},
		}, fx = {
			{ t = 0.42, fx = "projetil", o = {1.5, 3.9, -3.6}, d = {0, 0, -1}, dist = 28, dur = 0.55, tam = 0.8, cor = VIOLETA, fim = true },
		}},
		Habilidade = { dur = 1.8, k = {
			{0,    {}},
			{0.3,  { bracoD = {-35, 0, -15}, bracoE = {0, 0, -110}, raiz = {0, 0.6, 0}, cabeca = {10, 0, 0}, tronco = {6, 0, 0} }},
			{1.2,  { bracoD = {-35, 0, -15}, bracoE = {0, 0, -110}, raiz = {0, 0.9, 0}, cabeca = {10, 0, 0}, tronco = {6, 0, 0} }},
			{1.35, { bracoD = {-70, 0, 10}, bracoE = {-10, 0, -20}, tronco = {-15, 0, 0}, raiz = {0, 0.2, -0.2} }},
			{1.8,  {}},
		}, fx = {
			{ t = 0.25, fx = "circulo", c = {0, 0.1, 0}, r = 4.5, cor = VIOLETA, dur = 1.3 },
			{ t = 1.35, fx = "coluna", c = {0, 0, -6}, h = 10, w = 2.4, cor = VIOLETA, dur = 0.6 },
			{ t = 1.35, fx = "anel", c = {0, 0.3, -6}, r0 = 0.5, r1 = 5, subida = 0, cor = VIOLETA, dur = 0.6 },
			{ t = 1.35, fx = "faiscas", c = {0, 1, -6}, cor = {220, 180, 255}, n = 20 },
		}},
	},

	Ladino = {
		Ataque = { dur = 0.75, k = {
			{0,    {}},
			{0.12, { bracoD = {75, 0, -10}, bracoE = {-25, 0, 0}, tronco = {-14, 18, 0}, raiz = {0, -0.2, -0.6} }},
			{0.26, { bracoE = {75, 0, 10}, bracoD = {-25, 0, 0}, tronco = {-14, -18, 0}, raiz = {0, -0.2, -0.9} }},
			{0.42, { bracoE = {60, 0, 10}, bracoD = {-15, 0, 0}, tronco = {-10, -12, 0}, raiz = {0, -0.2, -0.9} }},
			{0.75, {}},
		}, fx = {
			{ t = 0.1,  fx = "arco", plano = "h", c = {0, 2.6, -0.6}, r = 2.6, a0 = -70, a1 = 50, cor = {200, 230, 220} },
			{ t = 0.24, fx = "arco", plano = "h", c = {0, 2.6, -0.9}, r = 2.6, a0 = 70, a1 = -50, cor = {200, 230, 220} },
		}},
		Habilidade = { dur = 1.2, k = {
			{0,    {}},
			{0.22, { raiz = {0, -0.6, 0.3}, tronco = {-28, 0, 0}, bracoE = {-40, 0, -10}, bracoD = {-40, 0, 10}, pernaE = {-30, 0, 0}, pernaD = {30, 0, 0} }},
			{0.42, { raiz = {0, -0.3, -7}, tronco = {-35, 0, 0}, bracoE = {-60, 0, -10}, bracoD = {-60, 0, 10} }},
			{0.55, { raiz = {0, -0.2, -7.5}, tronco = {-10, 0, 0}, bracoE = {95, 0, -20}, bracoD = {95, 0, 20} }},
			{0.8,  { raiz = {0, -0.2, -7.5}, bracoE = {70, 0, -20}, bracoD = {70, 0, 20} }},
			{1.2,  {}},
		}, fx = {
			{ t = 0.25, fx = "fumaca", c = {0, 1.5, 0}, n = 12 },
			{ t = 0.55, fx = "arco", plano = "h", c = {0, 2.6, -8}, r = 2.8, a0 = -80, a1 = 80, cor = {160, 120, 200} },
			{ t = 0.85, fx = "fumaca", c = {0, 1.5, -7.5}, n = 12 },
		}},
	},

	Patrulheiro = {
		Ataque = { dur = 1.1, k = {
			{0,    {}},
			{0.3,  { bracoE = {-5, 0, -4}, bracoD = {80, 0, -25}, tronco = {0, -25, 0}, cabeca = {0, 20, 0} }},
			{0.55, { bracoE = {-5, 0, -4}, bracoD = {70, 0, -5}, tronco = {0, -25, 0}, cabeca = {0, 20, 0} }},
			{0.62, { bracoE = {-5, 0, -4}, bracoD = {40, 0, 10}, tronco = {6, -25, 0}, cabeca = {0, 20, 0} }},
			{1.1,  {}},
		}, fx = {
			{ t = 0.6, fx = "projetil", o = {-1.45, 3.0, -2.0}, d = {0, 0, -1}, dist = 40, dur = 0.5, tam = 0.25, comp = 2.2, cor = PENA },
		}},
		Habilidade = { dur = 1.5, k = {
			{0,    {}},
			{0.35, { bracoE = {-45, 0, -4}, bracoD = {40, 0, -10}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{0.5,  { bracoE = {-45, 0, -4}, bracoD = {60, 0, -5}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{0.9,  { bracoE = {-45, 0, -4}, bracoD = {60, 0, -5}, tronco = {18, -20, 0}, cabeca = {22, 10, 0} }},
			{1.5,  {}},
		}, fx = {
			{ t = 0.5,  fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {0, 0.8, -0.6}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 0.65, fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {0.15, 0.8, -0.58}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 0.8,  fx = "projetil", o = {-1.45, 5.0, -2.5}, d = {-0.15, 0.8, -0.58}, dist = 20, dur = 0.4, tam = 0.25, comp = 2.2, cor = PENA },
			{ t = 1.0,  fx = "chuva", c = {0, 0, -12}, raio = 5, n = 14, cor = PENA },
		}},
	},
}
