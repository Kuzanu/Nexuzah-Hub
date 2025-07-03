local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:SetNotificationLower(true)

WindUI:SetFont("rbxassetid://12187607287")

WindUI:AddTheme({
    Name = "Nexuzah Neon",
    Accent = "#00ffff",        -- Electric cyan neon glow
    Outline = "#0ffeff",       -- Slightly lighter cyan for outlines
    Text = "#e0ffff",          -- Soft cyan text for readability
    Placeholder = "#55bbbb",   -- Muted cyan placeholder text
    Background = "#0a0a12",    -- Very dark navy/black background
    Button = "#022f3c",        -- Dark teal button color
    Icon = "#33ffff",          -- Bright cyan for icons
})

local Window = WindUI:CreateWindow({
    Title = "Nexuzah Hub | Universal",
    Icon = "terminal",
    Author = "by Kuzanu",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(480, 360),
    Transparent = true,
    Theme = "Nexuzah Neon",
    SideBarWidth = 200,
    Background = "", -- rbxassetid only
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Nexuzah Hub",
    Icon = "terminal",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("0a0a12"), 
        Color3.fromHex("33ffff")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = false,
})

local Dialog = Window:Dialog({
    Icon = "terminal",
    Title = "Welcome to Nexuzah Hub",
    Content = "This game is not yet registered in our system, so you're running our universal keyless script instead.",
    Buttons = {
        {
            Title = "Continue",
            Callback = function()
                print("Confirmed!")
            end,
        },
        {
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/YOURINVITEHERE")
            end,
        },
    },
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
    Locked = false,
})
local Main = Window:Tab({
    Title = "Main",
    Icon = "align-justify",
    Locked = false,
})
local Player = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})
local Utilities = Window:Tab({
    Title = "Utilities",
    Icon = "brush-cleaning",
    Locked = false,
})
local Games = Window:Tab({
    Title = "Games Supported",
    Icon = "gamepad-2",
    Locked = false,
})
local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false,
})
local Credits = Window:Tab({
    Title = "Credits",
    Icon = "book-user",
    Locked = false,
})

Window:SelectTab(1) -- Number of Tab

local idkSection = Home:Section({ 
    Title = "Local Player Configurations",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local WalkSpeedValue = 16
local Player = game.Players.LocalPlayer
local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

-- Update Humanoid reference on respawn
Player.CharacterAdded:Connect(function(char)
    Humanoid = char:WaitForChild("Humanoid")
end)

-- Slider setup
local WalkSpeedSlider = Home:Slider({
    Title = "Change WalkSpeed",
    
    Step = 1,
    
    Value = {
        Min = 16,
        Max = 500,
        Default = 16,
    },
    
    Callback = function(value)
        WalkSpeedValue = value
    end
})

-- Loop to maintain WalkSpeed bypassing anti-cheat resets
task.spawn(function()
    while task.wait(0.1) do
        if Humanoid and Humanoid.WalkSpeed ~= WalkSpeedValue then
            Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local InfJumpEnabled = false

local InfJumpsToggle = Home:Toggle({
    Title = "Infinite Jumps",
    Desc = "Toggle infinite jump on/off",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        InfJumpEnabled = state
        print("Infinite Jump Activated: " .. tostring(state))
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local Noclip = false
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local NoclipToggle = Home:Toggle({
    Title = "No Clip",
    Desc = "Toggle noclip on/off",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        Noclip = state
        print("No Clip Activated: " .. tostring(state))
    end
})

RunService.Stepped:Connect(function()
    if Noclip and character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
end)

local idk2Section = Main:Section({ 
    Title = "Flying",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local flyConnection

local function startFly()
    if hrp:FindFirstChild("FlyVelocity") then return end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        local move = Vector3.zero
        local camCF = workspace.CurrentCamera.CFrame

        if UIS.TouchEnabled then
            -- Mobile: fly forward automatically
            move = camCF.LookVector * speed
        else
            -- PC: WASD and space / ctrl
            if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
        end

        if move.Magnitude > 0 then
            hrp.FlyVelocity.Velocity = move.Unit * speed
        else
            hrp.FlyVelocity.Velocity = Vector3.zero
        end
    end)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if hrp:FindFirstChild("FlyVelocity") then
        hrp.FlyVelocity:Destroy()
    end
end

-- Your WindUI toggle
local Flyv1Toggle = Main:Toggle({
    Title = "Fly V1",
    Desc = "quite ass tbh 😭",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        flying = state
        if flying then
            startFly()
        else
            stopFly()
        end
    end
})

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local flying = false
local speed = 60
local vel, gyro, conn
local control = {
    Up = 0,
    Down = 0,
}

-- Actual fly logic
local function startAdminFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    flying = true
    hum.PlatformStand = true

    vel = Instance.new("BodyVelocity")
    vel.Name = "FlyVelocity"
    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    vel.Velocity = Vector3.zero
    vel.P = 1000
    vel.Parent = hrp

    gyro = Instance.new("BodyGyro")
    gyro.Name = "FlyGyro"
    gyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    gyro.P = 5000
    gyro.CFrame = hrp.CFrame
    gyro.Parent = hrp

    conn = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero

        -- Works for both PC WASD and mobile joystick:
        local moveInput = hum.MoveDirection
        if moveInput.Magnitude > 0 then
            local lookVec = cam.CFrame:VectorToWorldSpace(moveInput)
            moveVec += lookVec
        end

        -- PC up/down support
        if control.Up == 1 then moveVec += cam.CFrame.UpVector end
        if control.Down == 1 then moveVec -= cam.CFrame.UpVector end

        if moveVec.Magnitude > 0 then
            vel.Velocity = moveVec.Unit * speed
        else
            vel.Velocity = Vector3.zero
        end

        gyro.CFrame = cam.CFrame
    end)
end

local function stopAdminFly()
    flying = false

    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end

    if conn then conn:Disconnect() end
    if vel then vel:Destroy() end
    if gyro then gyro:Destroy() end

    control.Up = 0
    control.Down = 0
end

-- Keybindings for PC up/down
UIS.InputBegan:Connect(function(input, gpe)
    if gpe or not flying then return end
    if input.KeyCode == Enum.KeyCode.Space then control.Up = 1 end
    if input.KeyCode == Enum.KeyCode.LeftControl then control.Down = 1 end
end)

UIS.InputEnded:Connect(function(input)
    if not flying then return end
    if input.KeyCode == Enum.KeyCode.Space then control.Up = 0 end
    if input.KeyCode == Enum.KeyCode.LeftControl then control.Down = 0 end
end)

-- ✅ Toggle from UI
local FlyAdminToggle = Main:Toggle({
    Title = "Fly V2",
    Desc = "Good, but kinda needs work",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        if state then
            startAdminFly()
        else
            stopAdminFly()
        end
    end
})

-- 🎚️ Speed Slider
local SpeedSlider = Main:Slider({
    Title = "Fly Speed (only for v2)",
    Step = 1,
    Value = {
        Min = 10,
        Max = 75,
        Default = 60,
    },
    Callback = function(v)
        speed = v
    end
})

local idk3Section = Main:Section({ 
    Title = "ESP ++",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
}) 

local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local espStorage = {}

-- 👁️ Color Picker
local Colorpicker = Main:Colorpicker({
    Title = "Player ESP Color",
    Desc = "Sets the ESP box color. Name stays white.",
    Default = espColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        espColor = color
        for _, box in pairs(espStorage) do
            if box.Frame then
                box.Frame.BackgroundColor3 = espColor
            end
        end
    end
})

-- 👁️ Toggle ESP
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local head = player.Character:FindFirstChild("Head")
    if not hrp or not head then return end

    -- Billboard for name
    local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESP_BB"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 100, 0, 40)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head

    local nameLabel = Instance.new("TextLabel", bb)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextScaled = true

    -- Box (Frame overlay)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "PlayerESP_Box"
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = hrp.Size + Vector3.new(1, 1.5, 1)
    box.Color3 = espColor
    box.Transparency = 0.4
    box.Parent = hrp

    espStorage[player] = {BB = bb, Frame = box}
end

local function removeESP(player)
    local esp = espStorage[player]
    if esp then
        if esp.BB then esp.BB:Destroy() end
        if esp.Frame then esp.Frame:Destroy() end
        espStorage[player] = nil
    end
end

local PlayerEspToggle = Main:Toggle({
    Title = "Player ESP ++",
    Desc = "Shows white name + colored box above all players",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        espEnabled = state

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if state then
                    createESP(player)
                else
                    removeESP(player)
                end
            end
        end
    end
})

-- 🔁 Handle new players
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            wait(1)
            createESP(player)
        end
    end)
end)

-- 🔁 Handle character respawns
for _, player in pairs(game.Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if espEnabled then
            wait(1)
            createESP(player)
        end
    end)
end

local idk4Section = Main:Section({ 
    Title = "Teleport",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
}) 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Make sure the player list updates dynamically
local function getPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- avoid teleporting to yourself
            table.insert(names, player.Name)
        end
    end
    return names
end

local selectedPlayer = nil

local selectplayerDropdown = Main:Dropdown({
    Title = "Select Player",
    Values = getPlayerNames(),
    Value = "",
    Callback = function(option)
        selectedPlayer = option
        print("Selected player:", selectedPlayer)
    end
})

-- Optional: Refresh dropdown when players join/leave
Players.PlayerAdded:Connect(function()
    selectplayerDropdown:SetValues(getPlayerNames())
end)

Players.PlayerRemoving:Connect(function()
    selectplayerDropdown:SetValues(getPlayerNames())
end)

local teleporttoplayerButton = Main:Button({
    Title = "Teleport to Player",
    Desc = "Teleports you to the selected player.",
    Locked = false,
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
                print("Teleported to " .. selectedPlayer)
            else
                print("Target player not found or not loaded.")
            end
        else
            print("No player selected!")
        end
    end
})

local startTime = tick()

local function getTimePlayed()
    local total = tick() - startTime
    local minutes = math.floor(total / 60)
    local seconds = math.floor(total % 60)
    return string.format("%02d:%02d", minutes, seconds)
end

local timeParagraph = Player:Paragraph({
    Title = "⏱️ Time in Game",
    Desc = "You have been playing for 00:00.",
    Color = "Blue",
    Image = "", -- you can add a clock icon image ID here
    ImageSize = 30,
    Thumbnail = "", -- optional thumbnail
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "clock",
            Title = "Reset Timer",
            Callback = function()
                startTime = tick()
                print("Timer reset!")
            end,
        }
    }
})

-- Auto-update timer every second
task.spawn(function()
    while true do
        timeParagraph:SetDesc("You have been playing for " .. getTimePlayed() .. ".")
        task.wait(1)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local username = LocalPlayer.Name
local accountAgeDays = LocalPlayer.AccountAge

local userInfoParagraph = Player:Paragraph({
    Title = "👤 Player Info",
    Desc = "Username: " .. username .. "\nAccount Age: " .. accountAgeDays .. " days old",
    Color = "Blue",
    Image = "", -- you can add a profile icon image ID here
    ImageSize = 30,
    Thumbnail = "", -- optional avatar thumbnail
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "user",
            Title = "Copy Username",
            Callback = function()
                setclipboard(username)
                print("Username copied!")
            end,
        }
    }
})

local gamesParagraph = Games:Paragraph({
    Title = "🎮 Games Supported",
    Desc = [[
- Dead Rails
- Muscle Legends
- Blox Fruits
- Grow a Garden
- Build a Tower to Heaven
]],
    Color = "Blue", -- bright and fresh color for games list
    Image = "", -- optional: add an icon image if you want
    ImageSize = 30,
    Thumbnail = "", -- optional thumbnail here
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "gamepad",
            Title = "Join Discord",
            Callback = function()
                print("Redirecting to Discord...")
                -- you can put a Discord link open function here if you want
            end,
        }
    }
})

local creditsParagraph = Credits:Paragraph({
    Title = "👑 Credits to Kuzanu",
    Desc = "UI Designer and Absolute Legend behind the visuals of this hub. Salute to the GOAT. 🐐 Also for making this script possible!",
    Color = "Blue", -- You can change this to any supported color name
    Image = "", -- Optional: replace with a real asset ID if you have one
    ImageSize = 30,
    Thumbnail = "", -- Replace KuzanuUserId with the actual user ID
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "heart", -- Choose from available icons in your UI lib
            Title = "Say Thanks",
            Callback = function()
                print("Shoutout to Kuzanu for the clean UI! ❤️")
            end,
        }
    }
})
