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

-- 🔥 CACHE MODELS INDEX (FIABLE)
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 MONDE (FIX TOTAL)
local active = {}

local function hideOriginal(v)
    for _, p in ipairs(v:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 1
        elseif p:IsA("BillboardGui") then
            p.Enabled = false
        end
    end
end

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

                -- 🔥 cacher original
                hideOriginal(v)

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

-- 🔥 INDEX FIX (CORRECT)
local function fixViewport(vp)
    local world = vp:FindFirstChildOfClass("WorldModel")
    if not world then return end

    local children = world:GetChildren()
    if #children == 0 then return end

    local model = children[1]

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(model.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            world:ClearAllChildren()
            local clone = source:Clone()
            clone.Parent = world
        end
    end
end

-- scan + refresh continu propre
task.spawn(function()
    while true do
        task.wait(0.5)

        for _, v in ipairs(player.PlayerGui:GetDescendants()) do
            if v:IsA("ViewportFrame") then
                fixViewport(v)
            end
        end
    end
end)

-- 🔥 TEXTES GLOBAL (PARTOUT)
task.spawn(function()
    while true do
        task.wait(0.3)

        for _, v in ipairs(game:GetDescendants()) do
            
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                
                -- rareté
                v.Text = v.Text:gsub("Mythic", "OG")
                v.Text = v.Text:gsub("Secret", "OG")

                -- noms
                for original, newName in pairs(REPLACEMENTS) do
                    v.Text = v.Text:gsub(original, newName)
                end
            end
        end
    end
end)
