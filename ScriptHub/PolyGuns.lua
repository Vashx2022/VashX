local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(...)
	local Self,Args=...
	if getnamecallmethod()=="FireServer" and Self and string.find(Self.Name,"GoodBoy") then
		return
	end
	return OldNameCall(...)
end)

local walter = require(game:GetService("ReplicatedStorage").Modules.RemoteModule)
local function kill(player)
	if player.Character and player.Character.Head and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health>0 and not player.Character:FindFirstChild("Shield") then
		walter.Fire("Hit",player.Character.Head)
	end
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/XYNHY/MadCityHaxx/main/UILib"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/XYNHY/MadCityHaxx/main/ESPLIB"))()
local window = SolarisLib:New({
	Name = "Poly Guns",
	FolderToSave = "POLYGUNS"
})


local Visuals = window:Tab("Visuals")

local section1 = Visuals:Section("ESP")

local Aimbot = window:Tab("Aimbot")

local section2 = Aimbot:Section("AimBot Settings")

local GunMods = window:Tab("GunMods")

local section3 = GunMods:Section("Modify Guns")

local PlayerCheats = window:Tab("Players")

local section4 = PlayerCheats:Section("Player Cheats")

local EnableESP = section1:Toggle("Enable", false,"Toggle", function(state1)
	ESP:Toggle(state1)
end)

local Boxes = section1:Toggle("Boxes", false,"Toggle", function(state2)
	ESP.Boxes = state2
end)

local Tracers = section1:Toggle("Tracers", false, "Toggle", function(state3)
	ESP.Tracers = state3
end)

local Name = section1:Toggle("Name", false, "Toggle", function(state4)
	ESP.Names = state4
end)

local TeamColor = section1:Toggle("TeamColor", false, "Toggle", function(state5)
	ESP.TeamColor = state5
end)

local Players = section1:Toggle("Players", false, "Toggle", function(state6)
	ESP.Players = state6
end)


local SilentAim = section2:Toggle("SilentAim", false, "Toggle", function(state8)
	if state8 then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XYNHY/PolyGuns/main/Scripts/SilentAim"))()
		keypress(0x54)
	end
end)

local EnableGunMods = section3:Toggle("Enable GunMods", false, "Toggle", function(state9)
	if state9 then
		game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
		local wep = game:GetService("Players").LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
		local gunModule = require(wep.Config)
		repeat 
		task.wait() 
		
		
		wep.Ammo.Value = math.huge
		gunModule.MagazineSize = math.huge

		
		until state9 == false
		game.Players.LocalPlayer.Character.Humanoid:EquipTool(wep)
		for i, v in pairs(getgc(true)) do
			if type(v) == "table" and rawget(v, "MagazineSize" and rawget(v, "Damage") and rawget(v, "Ammo")) then
				v.MagazineSize = math.huge
				v.Damage = 100
				v.FireRate = 300
				v.Recoil = 0
				v.Spread = 0
				v.Range = math.huge
				v.BulletsPerShot = 3
				v.ReloadTime = 1
				v.Aim = 200
				v.Sprint = 100
				v.None = 200
				v.Reload = 0.001
				v.Zoom = 30
			end
		end
	end
end)


local AutoShoot = section4:Toggle("Auto Shoot", false, "Toggle", function(state10)
	local RS = game:GetService("RunService")
	if state10 then
		RS:BindToRenderStep("AutoShoot", Enum.RenderPriority.Camera.Value, function()
			for i,v in pairs(game.Players:GetPlayers()) do
				if i~=1 then
					kill(v)
				end
			end
		end)
	else
		RS:UnbindFromRenderStep("AutoShoot")
	end
	
end)

local HumanModCons = {}

function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end

local walkspeed = section4:Slider("WalkSpeed", 16,100,16,18,"Slider", function(value1)
	if isNumber(value1) then
		local Char = game.Players.LocalPlayer.Character or workspace:FindFirstChild(game.Players.LocalPlayer.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local function WalkSpeedChange()
			if Char and Human then
				Human.WalkSpeed = value1
			end
		end
		WalkSpeedChange()
		HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or game.Players.PlayerAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			WalkSpeedChange()
			HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		end)
	end
end)

local JumPower = section4:Slider("Jump Power", 50, 200, 0, 2,5, function(value2)
	if isNumber(value2) then
		local Char = game.Players.LocalPlayer.Character or workspace:FindFirstChild(game.Players.LocalPlayer.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local function JumpPowerChange()
			if Char and Human then
				if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').UseJumpPower then
					game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').JumpPower = value2
				else
					game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').JumpHeight  = value2
				end
			end
		end
		JumpPowerChange()
		HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or game.Players.PlayerAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			JumpPowerChange()
			HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		end)
	end
end)

local IsInfHealth = false
local GodMode = section4:Toggle("GodMode", false, "Toggle", function(state11)
	if state11 then
		
	end
end)

local Fly = section4:Toggle("Fly", false, "Toggle", function(state12)
	if state12 then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XYNHY/PolyGuns/main/Scripts/Fly"))()
	end
end)

local FlySpeed = section4:Slider("Fly Speed", 1,40,0,2,5, function(value3)
	_G.Speed = value3
end)
