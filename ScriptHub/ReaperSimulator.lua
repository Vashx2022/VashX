local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/preztel/AzureLibrary/master/uilib.lua"))()
local AimbotTab = Library:CreateTab("Reaper Simulator", "Reaper Simulator", true)
AimbotTab:CreateToggle("Auto Swing", function(arg)
	if arg then
		print("Auto Swing is now : Enabled")
		_G.AutoSwing = true
		while _G.AutoSwing do
			wait()
			game.ReplicatedStorage.Remotes.ItemUsed:FireServer("Attack")
		end
	else
		print("Auto Swing is now : Disabled")
		_G.AutoSwing = false
		while _G.AutoSwing do
			wait()
			game.ReplicatedStorage.Remotes.ItemUsed:FireServer("Attack")
		end
	end
end)

AimbotTab:CreateToggle("Auto Sell", function(arg)
	if arg then 
		print("Auto Sell is Now : Enabled")
		local sellPath = game:GetService("Workspace").TouchParts.Sell.SellPart
		local plr = game:GetService("Players").LocalPlayer
		_G.autoSell = true
		while _G.autoSell do wait(1)
			sellPath.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
			wait(1)
			sellPath.CFrame = plr.Character.HumanoidRootPart.CFrame
		end
	else
		print("Auto Sell is Now : Disabled")
		local sellPath = game:GetService("Workspace").TouchParts.Sell.SellPart
		local plr = game:GetService("Players").LocalPlayer
		_G.autoSell = false
		while _G.autoSell do wait(1)
			sellPath.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
			wait(1)
			sellPath.CFrame = plr.Character.HumanoidRootPart.CFrame
		end
	end
end)

AimbotTab:CreateToggle("AutoBuy Satchel", function(arg)
	if arg then
		print("Auto Buy Satchel is Now : Enabled")
		_G.SATC = true
		while _G.SATC do
			wait(3)
			
			for i=1, 50 do
				local A_1 = "Satchel"
				game:GetService("ReplicatedStorage").Remotes.Purchase:FireServer(tostring(i), A_1)
			end
			
		end
	else
		print("Auto Buy Satchel is Now : Disabled")
		_G.SATC = false
		while _G.SATC do
			wait(3) 
			
			for i=1, 50 do
				local A_1 = "Satchel"
				game:GetService("ReplicatedStorage").Remotes.Purchase:FireServer(tostring(i), A_1)
			end
		end
	end
end)

AimbotTab:CreateToggle("AutoBuy Scythe", function(arg)
	if arg then
		print("AutoBuy Scythe is Now : Enabled")
		_G.SCYT = true
		while _G.SCYT do
			wait(3) 
			
			for i=1, 50 do
				local A_1 = "Scythe"
				game:GetService("ReplicatedStorage").Remotes.Purchase:FireServer(tostring(i), A_1)
			end
			
		end
	else
		print("AutoBuy Scythe is Now : Disabled")
		_G.SCYT = false
		while _G.SCYT do
			wait(3) 
			
			
			
			for i=1, 50 do
				local A_1 = "Scythe"
				game:GetService("ReplicatedStorage").Remotes.Purchase:FireServer(tostring(i), A_1)
			end
			
		end
	end
end)

AimbotTab:CreateToggle("AutoTp Souls", function(arg)
	if arg then 
		print("AutoTp Souls is Now : Enabled")
		_G.TPSL = true
		while _G.TPSL do
			wait()
			for i,v in pairs(game:GetService("Workspace").AllSouls.SoulModel:GetDescendants()) do
				if v.ClassName == "Part" then
					v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
				end
			end
		end
	else
		print("AutoTp Souls is Now : Disabled")	
		_G.TPSL = true
		while _G.TPSL do
		wait()
		for i,v in pairs(game:GetService("Workspace").AllSouls.SoulModel:GetDescendants()) do
		if v.ClassName == "Part" then
		v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		       end
	       end
        end
    end
end)

AimbotTab:CreateToggle("AutoTp SkullZone", function(arg)
	if arg then
		print("AutoTp SkullZone is Now : Enabled")
		_G.SKUL = true
		while _G.SKUL do
			wait(0.7)
			local Skuls = game.workspace.Hills.SkullZone.Zone
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Skuls.CFrame
		end
	end
	print("AutoTp SkullZone is Now : Disabled")
	_G.SKUL = false
	while _G.SKUL do
		wait(0.7)
		local Skuls = game.workspace.Hills.SkullZone.Zone
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Skuls.CFrame
	end
end)

AimbotTab:CreateToggle("AutoTp SoulZone", function(arg)
	if arg then
		print ("AutoTp SoulZone is Now : Enabled")
		_G.SOUL = true
		while _G.SOUL do
			wait(0.5)
			local Souls = game.workspace.Hills.SoulZone.Zone
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Souls.CFrame
		end
	else
		print ("AutoTp SoulZone is Now : Disabled")
		_G.SOUL = false
		while _G.SOUL do
			wait(0.5)
			local Souls = game.workspace.Hills.SoulZone.Zone
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Souls.CFrame
		end
	end
end)
