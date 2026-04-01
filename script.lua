task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 🔥 CONFIG
local REPLACEMENTS = {
    ["Spioniro Golubiro"] = "Skibidi Toilet",
    ["Zibra Zubra Zibralini"] = "Skibidi Toilet",
    ["Tigrilini Watermelini"] = "Meowl",
    ["Carrotini Brainini"] = "Meowl",
    ["Bananito Bandito"] = "Strawberry Elephant",
    ["Torrtuginni Dragonfrutini"] = "Skibidi Toilet",
    ["Pot Hotspot"] = "Skibidi Toilet",
    ["Esok Sekolah"] = "Meowl",
    ["Spaghetti Tualetti"] = "Meowl",
    ["La Secret Combinasion"] = "Strawberry Elephant",
    ["Celestial Pegasus"] = "Strawberry Elephant"
}

-- 🔥 RÉCUP MODELS INDEX (UNE FOIS)
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 MONDE (STABLE)
local active = {}

local function applyWorld(v)
    if not v:IsA("Model") then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            
            if active[v] then return end

            local source = CACHE[newName]
            if not source then return end

            local fake = source:Clone()
            fake.Parent = workspace
            active[v] = fake

            if not fake.PrimaryPart then
                fake.PrimaryPart = fake:FindFirstChildWhichIsA("BasePart")
            end

            for _, p in ipairs(fake:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Anchored = true
                    p.CanCollide = false
                end
            end

            RunService.RenderStepped:Connect(function()
                if not v or not v.Parent then return end
                if v.PrimaryPart and fake.PrimaryPart then
                    fake:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
                end
            end)
        end
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    applyWorld(v)
end

workspace.DescendantAdded:Connect(applyWorld)

-- 🔥 INDEX (FIABLE)
local function fixViewport(vp)
    local world = vp:FindFirstChildOfClass("WorldModel")
    if not world then return end

    local model = world:FindFirstChildOfClass("Model")
    if not model then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(model.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            -- 🔥 RESET PROPRE
            world:ClearAllChildren()

            local clone = source:Clone()
            clone.Parent = world
        end
    end
end

-- scan initial
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("ViewportFrame") then
        task.wait()
        fixViewport(v)
    end
end

-- 🔥 TRIGGER QUAND INDEX CHANGE
player.PlayerGui.DescendantAdded:Connect(function(v)
    if v:IsA("ViewportFrame") then
        task.wait(0.2)
        fixViewport(v)
    end
end)

-- 🔥 TEXTES (FORCÉ SUR LES BRAINROTS)
local function fixTextLabel(label)
    if not label:IsA("TextLabel") then return end

    -- 🔥 RARETÉ
    if label.Text == "Mythic" or label.Text == "Secret" then
        label.Text = "OG"
    end

    -- 🔥 NOM
    for original, newName in pairs(REPLACEMENTS) do
        if label.Text == original then
            label.Text = newName
        end
    end
end

-- scan initial
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    fixTextLabel(v)
end

-- 🔥 FIX EN TEMPS RÉEL
player.PlayerGui.DescendantAdded:Connect(function(v)
    fixTextLabel(v)
end)
