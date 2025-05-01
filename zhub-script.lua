-- CROSS-PLATFORM EXECUTOR SCRIPT, FEATURES CAN BE UPDATED --
if _G.ScriptHubLoaded then return end
_G.ScriptHubLoaded = true

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- LOADING SCREEN
local loading = Instance.new("TextLabel")
loading.Size = UDim2.new(1, 0, 1, 0)
loading.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loading.Text = "Loading ZHub..."
loading.TextSize = 24
loading.Font = Enum.Font.GothamBold
loading.TextColor3 = Color3.fromRGB(255, 255, 255)
loading.Parent = CoreGui
wait(2)
loading:Destroy()

-- MAIN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZScriptHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Top bar
local topBar = Instance.new("TextLabel", main)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundTransparency = 1
topBar.Text = "ZHub"
topBar.Font = Enum.Font.GothamBold
topBar.TextSize = 16
topBar.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Side tabs
local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(0, 120, 1, -35)
tabHolder.Position = UDim2.new(0, 0, 0, 35)
tabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0, 6)

-- Function library
local function createTab(name, callback)
	local btn = Instance.new("TextButton", tabHolder)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
	btn.MouseButton1Click:Connect(callback)
end

-- ESP SCRIPT FUNCTION
local function runESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if not player.Character:FindFirstChild("Highlight") then
				local highlight = Instance.new("Highlight")
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 230, 255)
				highlight.Adornee = player.Character
				highlight.Parent = player.Character
			end
		end
	end

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(char)
			wait(1)
			local highlight = Instance.new("Highlight")
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.Adornee = char
			highlight.Parent = char
		end)
	end)
end

-- FLY SCRIPT FUNCTION
local function runFly()
	local FlySpeed = 50
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local flying = false
	local bv, bg, body
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	local function startFly()
		if flying then return end
		flying = true
		hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		bv = Instance.new("BodyVelocity")
		bv.Velocity = Vector3.new()
		bv.MaxForce = Vector3.new(1,1,1) * 1e9
		bv.Parent = hrp

		bg = Instance.new("BodyGyro")
		bg.CFrame = hrp.CFrame
		bg.MaxTorque = Vector3.new(1,1,1) * 1e9
		bg.P = 10^5
		bg.Parent = hrp

		RunService.RenderStepped:Connect(function()
			if not flying then return end
			local cam = workspace.CurrentCamera
			local dir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
			bv.Velocity = dir.Unit * FlySpeed
			bg.CFrame = cam.CFrame
		end)
	end

	local function stopFly()
		flying = false
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.E then
			if flying then stopFly() else startFly() end
		end
	end)
end

-- Create Tabs
createTab("ESP", function()
	runESP()
end)

createTab("Fly", function()
	runFly()
end)

-- Done
print("✅ Script Hub loaded.")
