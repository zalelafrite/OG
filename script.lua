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

-- 🔥 CACHE MODELS (depuis index)
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 cacher complètement le vrai brainrot
local function hideOriginal(v)
    for _, obj in ipairs(v:GetDescendants()) do
        
        if obj:IsA("BasePart") then
            obj.Transparency = 1
            obj.CanCollide = false
        end
        
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
        
        if obj:IsA("BillboardGui") then
            obj.Enabled = false
        end
    end
end

-- 🔥 MONDE (propre, sans duplication)
local active = {}

local function apply(v)
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

            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not v or not v.Parent then
                    if conn then conn:Disconnect() end
                    if fake then fake:Destroy() end
                    return
                end

                -- cacher vrai
                hideOriginal(v)

                -- suivre
                if v.PrimaryPart and fake.PrimaryPart then
                    fake:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
                end
            end)

            break
        end
    end
end

-- scan initial
for _, v in ipairs(workspace:GetDescendants()) do
    apply(v)
end

workspace.DescendantAdded:Connect(apply)

-- 🔥 TEXTE GLOBAL (SANS LAG)

local function fixText(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    
    local text = obj.Text

    text = text:gsub("Mythic", "OG")
    text = text:gsub("Secret", "OG")

    for original, newName in pairs(REPLACEMENTS) do
        text = text:gsub(original, newName)
    end

    obj.Text = text
end

-- scan initial texte
for _, v in ipairs(game:GetDescendants()) do
    fixText(v)
end

-- nouveaux textes
game.DescendantAdded:Connect(function(v)
    fixText(v)
end)
