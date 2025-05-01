if _G.ScriptHubLoaded then return end
_G.ScriptHubLoaded = true

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- LOADING SCREEN WITH PROGRESS BAR
local loading = Instance.new("TextLabel")
loading.Size = UDim2.new(1, 0, 1, 0)
loading.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loading.Text = "Loading ZHub..."
loading.TextSize = 24
loading.Font = Enum.Font.GothamBold
loading.TextColor3 = Color3.fromRGB(255, 255, 255)
loading.Parent = CoreGui

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0, 5)
progressBar.Position = UDim2.new(0.5, -225, 0.5, 180)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
progressBar.Parent = loading

-- Animate the progress bar
for i = 1, 100 do
    wait(0.05)
    progressBar.Size = UDim2.new(i / 100, 0, 0, 5)
end
wait(2)
loading:Destroy()

-- MAIN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZScriptHub"
gui.ResetOnSpawn = false

-- MAIN FRAME: With a shadow effect and rounded corners
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
main.ZIndex = 10

-- SHADOW EFFECT: To give it a floating look
local shadow = Instance.new("ImageLabel", main)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Image = "rbxassetid://13196426434"
shadow.ImageTransparency = 0.6
shadow.BackgroundTransparency = 1
shadow.ZIndex = 1

-- Top Bar: New font style and additional hover effects
local topBar = Instance.new("TextLabel", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
topBar.Text = "ZHub - Script Hub"
topBar.Font = Enum.Font.GothamBold
topBar.TextSize = 20
topBar.TextColor3 = Color3.fromRGB(255, 255, 255)
topBar.TextStrokeTransparency = 0.8
topBar.TextXAlignment = Enum.TextXAlignment.Left
topBar.TextYAlignment = Enum.TextYAlignment.Center
topBar.TextButton.MouseEnter:Connect(function() 
    topBar.TextColor3 = Color3.fromRGB(255, 0, 0)
end)
topBar.TextButton.MouseLeave:Connect(function()
    topBar.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Side Tabs: A modern tab bar with rounded buttons
local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(0, 120, 1, -45)
tabHolder.Position = UDim2.new(0, 0, 0, 45)
tabHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabHolder.BorderSizePixel = 0
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0, 8)

-- Hover effect for buttons in tabs
local function createTab(name, callback)
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.TextButton.MouseEnter:Connect(function() 
        btn.BackgroundColor3 = Color3.fromRGB(75, 75, 75) 
    end)
    btn.TextButton.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    btn.MouseButton1Click:Connect(callback)
end

-- Create tabs with a modern design

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
    local flying = false
    local bv, bg, body
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local function startFly()
        if flying then return end
        flying = true
        hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new()
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e9
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.CFrame = hrp.CFrame
        bg.MaxTorque = Vector3.new(1, 1, 1) * 1e9
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

-- TELEPORT SCRIPT FUNCTION (Realistic Logic)
local function runTP()
    -- Function to teleport to a specific location (example: Vector3(0, 10, 0))
    local function teleportToLocation(location)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
        end
    end

    -- Function to teleport to a specific player
    local function teleportToPlayer(playerName)
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame
            end
        end
    end

    -- Button for teleporting to a predefined location (Example location)
    createTab("TP to Location", function()
        teleportToLocation(Vector3.new(0, 10, 0))  -- Customize this location
    end)

    -- Button for teleporting to a specific player (User can input player's name)
    createTab("TP to Player", function()
        local playerName = "TargetPlayerName"  -- Replace this with the target player's name
        teleportToPlayer(playerName)
    end)
end

-- Create the Tabs with modern UI
createTab("ESP", function()
    runESP()
end)

createTab("Fly", function()
    runFly()
end)

createTab("Teleport", function()
    runTP()
end)

createTab("How to Install", function()
    local guide = Instance.new("TextLabel")
    guide.Size = UDim2.new(0, 400, 0, 200)
    guide.Position = UDim2.new(0.5, -200, 0.5, -100)
    guide.Text = "1. Open your executor\n2. Copy-paste the script\n3. Enjoy ZHub!"
    guide.TextSize = 16
    guide.BackgroundTransparency = 1
    guide.TextColor3 = Color3.fromRGB(255, 255, 255)
    guide.Parent = gui
end)

-- Done
print("✅ Script Hub loaded.")
