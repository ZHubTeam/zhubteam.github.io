-- Prevent multiple executions
if _G.ScriptHubLoaded then return end
_G.ScriptHubLoaded = true

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "ZHub - Script Hub",
    LoadingTitle = "ZHub",
    LoadingSubtitle = "Initializing...",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "ZHubConfigs",
        FileName = "ZHubSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "", -- Add your Discord invite code here
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "ZHub Key System",
        Subtitle = "Authentication Required",
        Note = "Join our Discord to obtain the key.",
        FileName = "ZHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"YourKeyHere"} -- Replace with your actual key(s)
    }
})

-- Create tabs
local MainTab = Window:CreateTab("Main") -- Replace with your desired icon ID
local TeleportTab = Window:CreateTab("Teleport")
local InfoTab = Window:CreateTab("Info")

-- ESP Functionality
local function runESP()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function highlightCharacter(character)
        if not character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Adornee = character
            highlight.Parent = character
        end
    end

    -- Highlight existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            highlightCharacter(player.Character)
        end
    end

    -- Highlight new players
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            highlightCharacter(character)
        end)
    end)
end

-- Fly Functionality
local function runFly()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local flying = false
    local FlySpeed = 50
    local bv, bg

    local function startFly()
        if flying then return end
        flying = true

        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new()
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e9
        bv.Parent = HumanoidRootPart

        bg = Instance.new("BodyGyro")
        bg.CFrame = HumanoidRootPart.CFrame
        bg.MaxTorque = Vector3.new(1, 1, 1) * 1e9
        bg.P = 10^5
        bg.Parent = HumanoidRootPart

        RunService.RenderStepped:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * FlySpeed
            else
                bv.Velocity = Vector3.zero
            end
            bg.CFrame = cam.CFrame
        end)
    end

    local function stopFly()
        flying = false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end

    -- Toggle fly mode with "E" key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            if flying then
                stopFly()
            else
                startFly()
            end
        end
    end)
end

-- Teleport Functionality
local function teleportToLocation(location)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
    end
end

local function teleportToPlayer(playerName)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- MainTab Buttons
MainTab:CreateButton({
    Name = "Enable ESP",
    Callback = function()
        runESP()
    end,
})

MainTab:CreateButton({
    Name = "Enable Fly (Toggle with 'E')",
    Callback = function()
        runFly()
    end,
})

-- TeleportTab Inputs
TeleportTab:CreateInput({
    Name = "Teleport to Coordinates",
    PlaceholderText = "Enter X, Y, Z",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local x, y, z = Text:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        if x and y and z then
            local position = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
            teleportToLocation(position)
        else
            Rayfield:Notify({
                Title = "Invalid Input",
                Content = "Please enter coordinates in the format: X, Y, Z",
                Duration = 5,
            })
        end
    end,
})

TeleportTab:CreateInput({
    Name = "Teleport to Player",
    PlaceholderText = "Enter Player Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        teleportToPlayer(Text)
    end,
})

-- InfoTab Paragraph
InfoTab:CreateParagraph({
    Title = "How to Install",
    Content = "1. Open your executor\n2. Copy-paste the script\n3. Enjoy ZHub!",
})
