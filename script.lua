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

-- 🔥 CACHE MODELS (UNE FOIS)
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 MONDE (SANS BUG)
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

-- 🔥 INDEX (ULTRA CIBLÉ)
local function fixIndex()
    local gui = player.PlayerGui:FindFirstChild("Index")
    if not gui then return end

    for _, vp in ipairs(gui:GetDescendants()) do
        if vp:IsA("ViewportFrame") then
            
            local world = vp:FindFirstChildOfClass("WorldModel")
            if not world then continue end

            local model = world:FindFirstChildOfClass("Model")
            if not model then continue end

            for original, newName in pairs(REPLACEMENTS) do
                if string.find(model.Name, original) then
                    
                    local source = CACHE[newName]
                    if not source then continue end

                    world:ClearAllChildren()
                    source:Clone().Parent = world
                end
            end
        end
    end
end

-- 🔥 ON FIX QUAND TU OUVRES L’INDEX
player.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "Index" then
        task.wait(0.5)
        fixIndex()
    end
end)

-- 🔥 TEXTES (UNE FOIS PROPRE)
local function fixTexts()
    for _, v in ipairs(player.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            
            v.Text = v.Text:gsub("Mythic", "OG")
            v.Text = v.Text:gsub("Secret", "OG")

            for original, newName in pairs(REPLACEMENTS) do
                v.Text = v.Text:gsub(original, newName)
            end
        end
    end
end

task.wait(1)
fixTexts()
