getgenv().newcclosure = function(p1)
	return p1
end
getgenv().GetObjects = newcclosure(function(String)
	assert(type(String) == "string", "String expected for first argument")
	assert(String:match("rbxassetid://%w+"), "First argument must be a Roblox Asset ID")
	return {game:GetService("InsertService"):LoadLocalAsset(String)}
end)
getgenv().gethui = newcclosure(function()
	return game.CoreGui
end)
getgenv().getnilinstances = newcclosure(function()
	local Table = {}
	for i,v in pairs(getreg()) do
		if type(v) == "table" then
			for I,V in pairs(v) do
				if typeof(V) == "Instance" and V.Parent == nil then
					table.insert(Table, V)
				end
			end
		end
	end
	return Table
end)
getgenv().getsenv = newcclosure(function(scr)
	for i, v in next, getreg() do
		if type(v) == "function" and getfenv(v).script == scr then
			return getfenv(v)
		end
	end
	error("Script environment could not be found.")
end)
getgenv().getmenv = getsenv
getgenv().getcallingscript = newcclosure(function()
	local A, B = dfghfjgk(getfenv, function()
		local fenv = getfenv(0);
		return rawget(fenv, "script")
	end, 3)
	local C = rawget(B, "script")
	if not C or typeof(C) ~= "Instance" then
		local D = string_match(debug_traceback(), "%w+:[%d%s]+$")
		return string_split(D, ":")[1]
	end
	return C
end)
getgenv().getinstances = newcclosure(function()
	local Table = {}
	for i,v in pairs(getreg()) do
		if type(v) == "table" then
			for I,V in pairs(v) do
				if typeof(V) == "Instance" then
					table.insert(Table, V)
				end
			end
		end
	end
	return Table
end)
getgenv().dofile = newcclosure(function(a1)
	assert(a1, "Bad argument to 'dofile' (#1) | Expected string. Recived, nil")
	loadfile(a1)()
end)
getgenv().getscripts = newcclosure(function()
	local scripts = {}
	for i, v in next, getinstances() do
		if v:IsA("ModuleScript") or v:IsA("LocalScript") then
			scripts[#scripts + 1] = v
		end
	end
	return scripts
end)

getgenv().getscriptenvs = newcclosure(function()
	local envs = {}
	for i, v in next, getscripts() do
		local succ, res = pcall(getsenv, v)
		if succ then
			envs[res.script] = res
		end
	end
	return envs
end)
getgenv().getmodules = newcclosure(function()
	local modules = {}
	local function Check(mScript)
		local Name = mScript:GetFullName()
		if Name:sub(1, 7) == "CoreGui" or Name:sub(1, 12) == "CorePackages" then
			return false
		end
		return true
	end
	for i, v in next, getscripts() do
		if v:IsA("ModuleScript") and Check(v) then
			modules[#modules + 1] = v
		end
	end
	return modules
end)
getgenv().is_protosmasher_caller = checkcaller
getgenv().get_nil_instances = getnilinstances
getgenv().get_loaded_modules = getmodules
getgenv().getloadedmodules = getmodules
getgenv().is_l_closure = islclosure;
getgenv().is_c_closure = iscclosure;
-- encoding
getgenv().base64_encode = newcclosure(function(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end)

-- decoding
getgenv().base64_decode = newcclosure(function(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end)

getgenv().secure_create = function(data)
	setclipboard(base64_encode(data))
end

getgenv().secure_run = function(data)
	loadstring(base64_decode(data))()
end

local specialinfo = {
	["Terrain"] = {
		["SmoothGrid"] = true,
		["MaterialColors"] = true
	},
	["MeshPart"] = {
		["PhysicsData"] = true,
		["InitialSize"] = true
	},
	["UnionOperation"] = {
		["AssetId"] = true,
		["ChildData"] = true,
		["FormFactor"] = true,
		["InitialSize"] = true,
		["MeshData"] = true,
		["PhysicsData"] = true
	}
}

getgenv().getspecialinfo = newcclosure(function(obj)
	assert(obj and typeof(obj) == "Instance", "getspecialinfo - Instance expected.")
	local data = {}
	for i, v in next, specialinfo[obj.ClassName] do
		data[i] = gethiddenproperty(obj, i)
	end
	return data
end)
getgenv().clonefunction = newcclosure(function(p1)
	assert(type(p1) == "function", "invalid argument #1 to '?' (function expected)", 2)
	local A = p1
	local B = xpcall(setfenv, function(p2, p3)
		return p2, p3
	end, p1, getfenv(p1))
	if B then
		return function(...)
			return A(...)
		end
	end
	return coroutine.wrap(function(...)
		while true do
			A = coroutine.yield(A(...))
		end
	end)
end)

getgenv().base64 = {
	encode = base64_encode,
	decode = base64_decode
}

getgenv().dumpstring = newcclosure(function(p1)
	assert(type(p1) == "string", "invalid argument #1 to '?' (string expected)", 2)
	return tostring("\\" .. table.concat({string_byte(p1, 1, #p1)}, "\\"))
end)


local gmt = getrawmetatable(game)
local old = gmt.__namecall
setreadonly(gmt, false)
gmt.__namecall = function(self, ...)
	if self == game and getnamecallmethod() =='HttpGet' or getnamecallmethod() == 'HttpGetAsync' then
		return HttpGet(...)
	end
	if self == game and getnamecallmethod() == 'GetObjects' then
		return GetObjects(...)
	end
	if self == game and getnamecallmethod() == "HttpPost" or getnamecallmethod() == "HttpPostAsync" then
		return HttpPost(...)
	end
	return old(self, ...)
end

getgenv().secure_call = newcclosure(function(Closure, Spoof, ...)
	assert(typeof(Spoof) == "Instance", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got "..type(Spoof)..")")
	assert(Spoof.ClassName == "LocalScript" or Spoof.ClassName == "ModuleScript", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got "..type(Spoof)..")")

	local OldScript = getfenv().script
	local OldThreadID = getthreadidentity()

	getfenv().script = Spoof
	setthreadidentity(2)
	local Success, Err = pcall(Closure, ...) -- so we can restore the spoofed values
	setthreadidentity(OldThreadID)
	getfenv().script = OldScript
	if not Success and Err then error(Err) end
end)


getgenv().getallthreads = newcclosure(function()
	local threads = {}
	for i, v in next, getreg() do
		if type(v) == "thread" then
			threads[#threads + 1] = v
		end
	end
	return threads
end)

getgenv().isluau = newcclosure(function()
	return __VERSION == "Luau"
end)

getgenv().identifyexecutor = function()
	return "Synapse x"
end




local DisableCon = disableconnection
local EnableCon = enableconnection
local GetConFunc = getconnectionfunc
local MT = {
	__index = function(a, b)
		if b == "Fire" then
			return function(self, ...) fireonesignal(self.__OBJECT, ...) end
		end

		if b == "Disable" then
			return function(self, ...) DisableCon(self.__OBJECT) end
		end

		if b == "Enable" then
			return function(self, ...) EnableCon(self.__OBJECT) end
		end

		if b == "Function" then
			return function(self, ...) return GetConFunc(self.__OBJECT) end
		end

		return nil
	end
}
function attachMT(tbl)
	setmetatable(tbl, MT)
	return tbl
end
getgenv().firesignal = function(a, ...)
	temp=a:Connect(function()end)
	temp:Disconnect()
	return firesignalhelper(temp, ...)
end
getgenv().getconnections = function(a)
	temp = a:Connect(function() end)
	signals = getothersignals(temp)
	for i,v in pairs(signals) do
		signals[i] = attachMT(v)
	end
	temp:Disconnect()
	return signals
end

getgenv().appendfile = newcclosure(function(a1, a2)
	assert(a1, "Bad argument to 'appendfile' (#1) | Expected string. Recived, nil")
	assert(a2, "Bad argument to 'appendfile' (#2) | Expected string. Recived, nil")
	local data = readfile(a1) 
	writefile(a1, a2)
	return data;
end)

getgenv().loadfile = newcclosure(function(a1)
	assert(a1, "Bad argument to 'loadfile' (#1) | Expected string. Recived, nil")
	local data = readfile(a1) 
	return loadstring(data)
end)

local M = {_TYPE='module', _NAME='bitop.funcs', _VERSION='1.0-0'}

local floor = math.floor

local MOD = 2^32
local MODM = MOD-1

local function memoize(f)

	local mt = {}
	local t = setmetatable({}, mt)

	function mt:__index(k)
		local v = f(k)
		t[k] = v
		return v
	end

	return t
end

local function make_bitop_uncached(t, m)
	local function bitop(a, b)
		local res,p = 0,1
		while a ~= 0 and b ~= 0 do
			local am, bm = a%m, b%m
			res = res + t[am][bm]*p
			a = (a - am) / m
			b = (b - bm) / m
			p = p*m
		end
		res = res + (a+b) * p
		return res
	end
	return bitop
end

local function make_bitop(t)
	local op1 = make_bitop_uncached(t, 2^1)
	local op2 = memoize(function(a)
		return memoize(function(b)
			return op1(a, b)
		end)
	end)
	return make_bitop_uncached(op2, 2^(t.n or 1))
end

function M.tobit(x)
	return x % 2^32
end

M.bxor = make_bitop {[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0}, n=4}
local bxor = M.bxor

function M.bnot(a)   return MODM - a end
local bnot = M.bnot

function M.band(a,b) return ((a+b) - bxor(a,b))/2 end
local band = M.band

function M.bor(a,b)  return MODM - band(MODM - a, MODM - b) end
local bor = M.bor

local lshift, rshift 

function M.rshift(a,disp) 
	if disp < 0 then return lshift(a,-disp) end
	return floor(a % 2^32 / 2^disp)
end
rshift = M.rshift

function M.lshift(a,disp) 
	if disp < 0 then return rshift(a,-disp) end
	return (a * 2^disp) % 2^32
end
lshift = M.lshift

function M.tohex(x, n) 
	n = n or 8
	local up
	if n <= 0 then
		if n == 0 then return '' end
		up = true
		n = - n
	end
	x = band(x, 16^n-1)
	return ('%0'..n..(up and 'X' or 'x')):format(x)
end
local tohex = M.tohex

function M.extract(n, field, width) 
	width = width or 1
	return band(rshift(n, field), 2^width-1)
end
local extract = M.extract

function M.replace(n, v, field, width)
	width = width or 1
	local mask1 = 2^width-1
	v = band(v, mask1) 
	local mask = bnot(lshift(mask1, field))
	return band(n, mask) + lshift(v, field)
end
local replace = M.replace

function M.bswap(x) 
	local a = band(x, 0xff); x = rshift(x, 8)
	local b = band(x, 0xff); x = rshift(x, 8)
	local c = band(x, 0xff); x = rshift(x, 8)
	local d = band(x, 0xff)
	return lshift(lshift(lshift(a, 8) + b, 8) + c, 8) + d
end
local bswap = M.bswap

function M.rrotate(x, disp)  -- Lua5.2 inspired
	disp = disp % 32
	local low = band(x, 2^disp-1)
	return rshift(x, disp) + lshift(low, 32-disp)
end
local rrotate = M.rrotate

function M.lrotate(x, disp) 
	return rrotate(x, -disp)
end
local lrotate = M.lrotate

M.rol = M.lrotate  
M.ror = M.rrotate 


function M.arshift(x, disp) 
	local z = rshift(x, disp)
	if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
	return z
end
local arshift = M.arshift

function M.btest(x, y) 
	return band(x, y) ~= 0
end


M.bit32 = {} 


local function bit32_bnot(x)
	return (-1 - x) % MOD
end
M.bit32.bnot = bit32_bnot

local function bit32_bxor(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = bxor(a, b)
		if c then
			z = bit32_bxor(z, c, ...)
		end
		return z
	elseif a then
		return a % MOD
	else
		return 0
	end
end
M.bit32.bxor = bit32_bxor

local function bit32_band(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = ((a+b) - bxor(a,b)) / 2
		if c then
			z = bit32_band(z, c, ...)
		end
		return z
	elseif a then
		return a % MOD
	else
		return MODM
	end
end
M.bit32.band = bit32_band

local function bit32_bor(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = MODM - band(MODM - a, MODM - b)
		if c then
			z = bit32_bor(z, c, ...)
		end
		return z
	elseif a then
		return a % MOD
	else
		return 0
	end
end
M.bit32.bor = bit32_bor

function M.bit32.btest(...)
	return bit32_band(...) ~= 0
end

function M.bit32.lrotate(x, disp)
	return lrotate(x % MOD, disp)
end

function M.bit32.rrotate(x, disp)
	return rrotate(x % MOD, disp)
end

function M.bit32.lshift(x,disp)
	if disp > 31 or disp < -31 then return 0 end
	return lshift(x % MOD, disp)
end

function M.bit32.rshift(x,disp)
	if disp > 31 or disp < -31 then return 0 end
	return rshift(x % MOD, disp)
end

function M.bit32.arshift(x,disp)
	x = x % MOD
	if disp >= 0 then
		if disp > 31 then
			return (x >= 0x80000000) and MODM or 0
		else
			local z = rshift(x, disp)
			if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
			return z
		end
	else
		return lshift(x, -disp)
	end
end

function M.bit32.extract(x, field, ...)
	local width = ... or 1
	if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
	x = x % MOD
	return extract(x, field, ...)
end

function M.bit32.replace(x, v, field, ...)
	local width = ... or 1
	if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
	x = x % MOD
	v = v % MOD
	return replace(x, v, field, ...)
end

M.bit = {} 

function M.bit.tobit(x)
	x = x % MOD
	if x >= 0x80000000 then x = x - MOD end
	return x
end
local bit_tobit = M.bit.tobit

function M.bit.tohex(x, ...)
	return tohex(x % MOD, ...)
end

function M.bit.bnot(x)
	return bit_tobit(bnot(x % MOD))
end

local function bit_bor(a, b, c, ...)
	if c then
		return bit_bor(bit_bor(a, b), c, ...)
	elseif b then
		return bit_tobit(bor(a % MOD, b % MOD))
	else
		return bit_tobit(a)
	end
end
M.bit.bor = bit_bor

local function bit_band(a, b, c, ...)
	if c then
		return bit_band(bit_band(a, b), c, ...)
	elseif b then
		return bit_tobit(band(a % MOD, b % MOD))
	else
		return bit_tobit(a)
	end
end
M.bit.band = bit_band

local function bit_bxor(a, b, c, ...)
	if c then
		return bit_bxor(bit_bxor(a, b), c, ...)
	elseif b then
		return bit_tobit(bxor(a % MOD, b % MOD))
	else
		return bit_tobit(a)
	end
end
M.bit.bxor = bit_bxor

function M.bit.lshift(x, n)
	return bit_tobit(lshift(x % MOD, n % 32))
end

function M.bit.rshift(x, n)
	return bit_tobit(rshift(x % MOD, n % 32))
end

function M.bit.arshift(x, n)
	return bit_tobit(arshift(x % MOD, n % 32))
end

function M.bit.rol(x, n)
	return bit_tobit(lrotate(x % MOD, n % 32))
end

function M.bit.ror(x, n)
	return bit_tobit(rrotate(x % MOD, n % 32))
end

function M.bit.bswap(x)
	return bit_tobit(bswap(x % MOD))
end

getgenv().bit = M

getgenv().syn = {
	protect_gui = gethui,
	request = http_request,
	securecall = secure_call,
	secure_call = secure_call,

}

setreadonly(getgenv().syn, true)


local gmt = getrawmetatable(game)
local oldi = gmt.__index
setreadonly(gmt, false)
gmt.__index = function(self, Index)
	if self == game and Index == 'HttpGet' or Index == 'HttpGetAsync' then
		return HttpGet
	end
	if self == game and Index == "HttpPost" or Index == "HttpPostAsync" then
		return HttpPost
        end
	if self == game and Index ==  "GetObjects" then
		return GetObjects
	end
	if self == game and Index == "Players" then
		return game:GetService("Players")
	end
	if self == game and Index == "RunService" then
		return game:GetService("RunService")
	end

	return oldi(self, Index)
end
setreadonly(gmt, true)
