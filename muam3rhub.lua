-- Muam3r Hub v6 - Anti-Cheat Resistant (Improved Version for Delta Executor) repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

print("[Muam3r Hub] Starting script...")

local g = game local s = g:GetService("Players") local r = g:GetService("RunService") local u = g:GetService("UserInputService") local p = s.LocalPlayer

local function asc(str) return string.gsub(str, "\(%d%d%d)", function(n) return string.char(tonumber(n)) end) end

-- Encoded strings local label_main = asc("\077\117\097\109\051\114\032\072\117\098\032\118\054") local notify_title = asc("\077\117\097\109\051\114\032\072\117\098") local toggle_insta = asc("\073\110\115\116\097\032\083\116\101\097\108") local toggle_air = asc("\065\105\114\032\074\117\109\112") local toggle_speed = asc("\083\112\101\101\100\032\072\097\099\107") local toggle_flight = asc("\070\108\105\103\104\116") local label_off = asc("\079\070\070") local label_on = asc("\079\078")

-- Stealth GUI local gui = Instance.new("ScreenGui") gui.Name = label_main gui.ResetOnSpawn = false gui.Parent = p:WaitForChild("PlayerGui")

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 180, 0, 220) frame.Position = UDim2.new(0.5, -90, 0.5, -110) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.Active = true frame.Draggable = true frame.Parent = gui

local title = Instance.new("TextLabel") title.Text = label_main title.TextColor3 = Color3.fromRGB(255, 60, 60) title.Size = UDim2.new(1, 0, 0.1, 0) title.BackgroundTransparency = 1 title.Font = Enum.Font.GothamBold title.TextSize = 14 title.Parent = frame

local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 5) layout.Parent = frame

local function stealthNotify(txt) pcall(function() g:GetService("StarterGui"):SetCore("SendNotification", { Title = notify_title, Text = txt, Duration = 3 }) end) end

local function stealthToggle(label, cb) local container = Instance.new("Frame") container.Size = UDim2.new(1, -10, 0, 30) container.BackgroundTransparency = 1 container.Parent = frame

local l = Instance.new("TextLabel")
l.Text = label
l.Size = UDim2.new(0.7, 0, 1, 0)
l.TextColor3 = Color3.new(1, 1, 1)
l.BackgroundTransparency = 1
l.Font = Enum.Font.Gotham
l.TextSize = 12
l.TextXAlignment = Enum.TextXAlignment.Left
l.Parent = container

local b = Instance.new("TextButton")
b.Size = UDim2.new(0.25, 0, 0.7, 0)
b.Position = UDim2.new(0.72, 0, 0.15, 0)
b.Text = label_off
b.TextSize = 11
b.Font = Enum.Font.Gotham
b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
b.TextColor3 = Color3.new(1, 1, 1)
b.Parent = container

local st = false
b.MouseButton1Click:Connect(function()
    st = not st
    b.Text = st and label_on or label_off
    b.BackgroundColor3 = st and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 60)
    cb(st)
end)

end

-- Obfuscated Insta Steal stealthToggle(toggle_insta, function(state) if state then task.spawn(function() while state do task.wait(0.35 + math.random() * 0.05) pcall(function() local c = p.Character if not c then return end local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end local pos = hrp.CFrame for _,v in ipairs(workspace:GetDescendants()) do if v.Name == "AnimalPodium" and v:FindFirstChildWhichIsA("ProximityPrompt") then hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0) task.wait(0.1) pcall(fireproximityprompt, v:FindFirstChildWhichIsA("ProximityPrompt")) task.wait(0.1) hrp.CFrame = pos break end end end) end end) end end)

-- Obfuscated Air Jump stealthToggle(toggle_air, function(state) if state then p.CharacterAdded:Connect(function(c) local h = c:WaitForChild("Humanoid") h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) u.JumpRequest:Connect(function() if state then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end) end end)

-- Obfuscated Speed Hack stealthToggle(toggle_speed, function(state) if state then task.spawn(function() while state do task.wait(0.2 + math.random() * 0.05) pcall(function() local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 32 end end) end end) else pcall(function() local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 end end) end end)

-- Obfuscated Flight stealthToggle(toggle_flight, function(state) if state then task.spawn(function() local bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(0, 9e9, 0) while state do task.wait(0.05) pcall(function() local c = p.Character local hrp = c and c:FindFirstChild("HumanoidRootPart") if hrp then if not hrp:FindFirstChild("BodyVelocity") then bv.Parent = hrp end local speed = 50 local y = u:IsKeyDown(Enum.KeyCode.Space) and speed or u:IsKeyDown(Enum.KeyCode.LeftControl) and -speed or 0 bv.Velocity = Vector3.new(0, y, 0) end end) end pcall(function() local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart") local v = hrp and hrp:FindFirstChild("BodyVelocity") if v then v:Destroy() end end) end) end end)

stealthNotify(label_main .. " loaded!")

