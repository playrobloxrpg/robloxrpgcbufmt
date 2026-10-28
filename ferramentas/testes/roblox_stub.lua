-- Minimal mock of the Roblox API, enough to run the dungeon builder outside Studio
local V3 = {}
V3.__index = function(v, k)
	if k == "X" then return rawget(v, 1) elseif k == "Y" then return rawget(v, 2) elseif k == "Z" then return rawget(v, 3)
	elseif k == "Magnitude" then return math.sqrt(v[1]^2 + v[2]^2 + v[3]^2)
	elseif k == "Lerp" then return function(a, b, t) return a + (b - a) * t end
	elseif k == "Dot" then return function(a, b) return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] end
	elseif k == "Unit" then local m = math.sqrt(v[1]^2 + v[2]^2 + v[3]^2); return Vector3.new(v[1]/m, v[2]/m, v[3]/m) end
end
local function isV3(v) return getmetatable(v) == V3 end
V3.__add = function(a, b) return Vector3.new(a[1]+b[1], a[2]+b[2], a[3]+b[3]) end
V3.__sub = function(a, b) return Vector3.new(a[1]-b[1], a[2]-b[2], a[3]-b[3]) end
V3.__unm = function(a) return Vector3.new(-a[1], -a[2], -a[3]) end
V3.__mul = function(a, b)
	if type(a) == "number" then a, b = b, a end
	if type(b) == "number" then return Vector3.new(a[1]*b, a[2]*b, a[3]*b) end
	return Vector3.new(a[1]*b[1], a[2]*b[2], a[3]*b[3])
end
V3.__div = function(a, b) return Vector3.new(a[1]/b, a[2]/b, a[3]/b) end
Vector3 = { new = function(x, y, z) return setmetatable({x or 0, y or 0, z or 0}, V3) end }
Vector2 = { new = function(x, y) return {x, y} end }

local function cross(a, b) return Vector3.new(a[2]*b[3]-a[3]*b[2], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-a[2]*b[1]) end

local CF = {}
local function mkcf(p, R) return setmetatable({p = p, R = R}, CF) end
local ID = {1,0,0, 0,1,0, 0,0,1}
local function matmul(A, B)
	local C = {}
	for i = 0, 2 do for j = 0, 2 do
		local s = 0
		for k = 0, 2 do s = s + A[i*3+k+1] * B[k*3+j+1] end
		C[i*3+j+1] = s
	end end
	return C
end
local function matvec(A, v) return Vector3.new(A[1]*v[1]+A[2]*v[2]+A[3]*v[3], A[4]*v[1]+A[5]*v[2]+A[6]*v[3], A[7]*v[1]+A[8]*v[2]+A[9]*v[3]) end
local function transpose(A) return {A[1],A[4],A[7], A[2],A[5],A[8], A[3],A[6],A[9]} end
CF.__index = function(c, k)
	if k == "Position" then return c.p
	elseif k == "X" then return c.p[1] elseif k == "Y" then return c.p[2] elseif k == "Z" then return c.p[3]
	elseif k == "LookVector" then return Vector3.new(-c.R[3], -c.R[6], -c.R[9])
	elseif k == "VectorToWorldSpace" then return function(self, v) return matvec(self.R, v) end
	elseif k == "PointToObjectSpace" then return function(self, v) return matvec(transpose(self.R), v - self.p) end
	end
end
CF.__mul = function(a, b)
	if isV3(b) then return matvec(a.R, b) + a.p end
	return mkcf(matvec(a.R, b.p) + a.p, matmul(a.R, b.R))
end
local function rx(t) local c, s = math.cos(t), math.sin(t); return {1,0,0, 0,c,-s, 0,s,c} end
local function ry(t) local c, s = math.cos(t), math.sin(t); return {c,0,s, 0,1,0, -s,0,c} end
local function rz(t) local c, s = math.cos(t), math.sin(t); return {c,-s,0, s,c,0, 0,0,1} end
CFrame = {
	new = function(x, y, z)
		if x == nil then return mkcf(Vector3.new(0,0,0), ID) end
		if isV3(x) then return mkcf(x, ID) end
		return mkcf(Vector3.new(x, y, z), ID)
	end,
	Angles = function(a, b, c) return mkcf(Vector3.new(0,0,0), matmul(matmul(rx(a), ry(b)), rz(c))) end,
	lookAt = function(eye, target, up)
		up = up or Vector3.new(0, 1, 0)
		local look = (target - eye).Unit
		local right = cross(look, up).Unit
		local up2 = cross(right, look)
		local back = -look
		return mkcf(eye, {right[1], up2[1], back[1], right[2], up2[2], back[2], right[3], up2[3], back[3]})
	end,
}

Color3 = {
	fromRGB = function(r, g, b) return {r = r/255, g = g/255, b = b/255, kind = "Color3"} end,
	new = function(r, g, b) return {r = r, g = g, b = b, kind = "Color3"} end,
}
ColorSequence = { new = function(c) return c end }
NumberSequence = { new = function(n) return n end }
NumberRange = { new = function(a, b) return {a, b} end }

local enumMeta = { __index = function(t, k) local s = rawget(t, "_n") .. "." .. k; return s end }
Enum = setmetatable({}, { __index = function(t, k) return setmetatable({_n = k}, enumMeta) end })

local baseParts = { Part = true, SpawnLocation = true, WedgePart = true }
local Inst = {}
local methods = {}
function methods:SetAttribute(k, v) self._attrs[k] = v end
function methods:GetAttribute(k) return self._attrs[k] end
function methods:GetChildren() local t = {}; for i, c in ipairs(self._children) do t[i] = c end; return t end
function methods:GetDescendants()
	local out = {}
	local function walk(n) for _, c in ipairs(n._children) do table.insert(out, c); walk(c) end end
	walk(self)
	return out
end
function methods:FindFirstChild(name) for _, c in ipairs(self._children) do if c._props.Name == name then return c end end return nil end
function methods:FindFirstChildOfClass(cls) for _, c in ipairs(self._children) do if c.ClassName == cls then return c end end return nil end
function methods:IsA(cls)
	if cls == "BasePart" then return baseParts[self.ClassName] == true end
	return self.ClassName == cls
end
function methods:Destroy() self.Parent = nil end
function methods:Set(list) end
Inst.__index = function(o, k)
	if methods[k] then return methods[k] end
	if k == "Parent" then return rawget(o, "_parent") end
	local v = o._props[k]
	if v ~= nil then return v end
	return o:FindFirstChild(k)
end
Inst.__newindex = function(o, k, v)
	if k == "Parent" then
		local old = rawget(o, "_parent")
		if old then
			for i, c in ipairs(old._children) do if c == o then table.remove(old._children, i) break end end
		end
		rawset(o, "_parent", v)
		if v then table.insert(v._children, o) end
	else
		o._props[k] = v
	end
end
local function newInst(cls)
	local o = { ClassName = cls, _props = { Name = cls, Transparency = 0 }, _attrs = {}, _children = {} }
	return setmetatable(o, Inst)
end
Instance = { new = newInst }

workspace = newInst("Workspace")
workspace.Name = "Workspace"
workspace._props.CurrentCamera = newInst("Camera")
workspace._props.CurrentCamera._props.CFrame = CFrame.lookAt(Vector3.new(0, 12, 40), Vector3.new(0, 6, 0))
local services = {}
game = { GetService = function(self, name)
	if not services[name] then
		services[name] = newInst(name)
		if name == "StarterPlayer" then
			local s = newInst("StarterPlayerScripts"); s.Name = "StarterPlayerScripts"; s.Parent = services[name]
		end
	end
	return services[name]
end }

-- Export every BasePart and light under a root
function EXPORT(root)
	local parts, lights, scripts = {}, {}, {}
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") then
			local p = d._props
			local cf = p.CFrame
			table.insert(parts, { name = p.Name, sx = p.Size[1], sy = p.Size[2], sz = p.Size[3],
				x = cf.p[1], y = cf.p[2], z = cf.p[3],
				r1 = cf.R[1], r2 = cf.R[2], r3 = cf.R[3], r4 = cf.R[4], r5 = cf.R[5], r6 = cf.R[6], r7 = cf.R[7], r8 = cf.R[8], r9 = cf.R[9],
				cr = p.Color.r, cg = p.Color.g, cb = p.Color.b, mat = p.Material, tr = p.Transparency or 0,
				zone = (d.Parent and d.Parent._props.Name == "Zonas") and 1 or 0 })
		elseif d.ClassName == "PointLight" then
			local par = d.Parent
			local cf = par._props.CFrame
			table.insert(lights, { x = cf.p[1], y = cf.p[2], z = cf.p[3], cr = d._props.Color.r, cg = d._props.Color.g, cb = d._props.Color.b,
				range = d._props.Range, b = d._props.Brightness or 1 })
		elseif d.ClassName == "Script" or d.ClassName == "LocalScript" then
			table.insert(scripts, d._props.Source)
		end
	end
	return parts, lights, scripts
end
UDim2 = { fromOffset = function(a, b) return {a, b} end, fromScale = function(a, b) return {a, b} end, new = function(...) return {...} end }

-- extras de CFrame usados pelo lobby
do
	local CFm = getmetatable(CFrame.new())
	local oldIndex = CFm.__index
	local function T(A) return {A[1],A[4],A[7], A[2],A[5],A[8], A[3],A[6],A[9]} end
	local function mv(A, v) return Vector3.new(A[1]*v[1]+A[2]*v[2]+A[3]*v[3], A[4]*v[1]+A[5]*v[2]+A[6]*v[3], A[7]*v[1]+A[8]*v[2]+A[9]*v[3]) end
	local function mk(p, R) return setmetatable({p = p, R = R}, CFm) end
	CFm.__index = function(c, k)
		if k == "Inverse" then return function(self) local Rt = T(self.R); return mk(-mv(Rt, self.p), Rt) end
		elseif k == "Rotation" then return mk(Vector3.new(0,0,0), c.R)
		elseif k == "UpVector" then return Vector3.new(c.R[2], c.R[5], c.R[8])
		elseif k == "RightVector" then return Vector3.new(c.R[1], c.R[4], c.R[7])
		end
		return oldIndex(c, k)
	end
	CFm.__add = function(c, v) return mk(c.p + v, c.R) end
end
