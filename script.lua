task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 🔥 mapping
local REPLACEMENTS = {
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

-- 🔥 rareté
local RARITY = {
    ["Zibra Zubra Zibralini"] = "OG",
    ["Tigrilini Watermelini"] = "OG",
    ["Carrotini Brainini"] = "OG",
    ["Bananito Bandito"] = "OG",

    ["Torrtuginni Dragonfrutini"] = "OG",
    ["Pot Hotspot"] = "OG",
    ["Esok Sekolah"] = "OG",
    ["Spaghetti Tualetti"] = "OG",
    ["La Secret Combinasion"] = "OG",
    ["Celestial Pegasus"] = "OG"
}

-- 🔥 récupérer modèles index
local function getModel(name)
    for _, v in ipairs(player.PlayerGui:GetDescendants()) do
        if v:IsA("Model") and v.Name == name then
            return v
        end
    end
end

local CACHE = {
    ["Skibidi Toilet"] = getModel("Skibidi Toilet"),
    ["Meowl"] = getModel("Meowl"),
    ["Strawberry Elephant"] = getModel("Strawberry Elephant")
}

local activeFakes = {}

local function clearFake(v)
    if activeFakes[v] then
        activeFakes[v]:Destroy()
        activeFakes[v] = nil
    end
end

local function hideOriginal(v)
    for _, p in ipairs(v:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 1
        elseif p:IsA("BillboardGui") then
            p.Enabled = false
        end
    end
end

local function showOriginal(v)
    for _, p in ipairs(v:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 0
        elseif p:IsA("BillboardGui") then
            p.Enabled = true
        end
    end
end

-- 🔥 changer texte
local function updateUI(v, newName, rarity)
    for _, gui in ipairs(v:GetDescendants()) do
        if gui:IsA("BillboardGui") then
            for _, t in ipairs(gui:GetDescendants()) do
                if t:IsA("TextLabel") then
                    
                    if string.find(string.lower(t.Text), "mythic") 
                    or string.find(string.lower(t.Text), "secret") then
                        t.Text = rarity
                    end

                    if string.find(t.Text, v.Name) then
                        t.Text = newName
                    end
                end
            end
        end
    end
end

local function apply(v)
    if not v:IsA("Model") then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            clearFake(v)

            local fake = source:Clone()
            fake.Parent = workspace
            activeFakes[v] = fake

            if not fake.PrimaryPart then
                fake.PrimaryPart = fake:FindFirstChildWhichIsA("BasePart")
            end

            for _, p in ipairs(fake:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Anchored = true
                    p.CanCollide = false
                end
            end

            updateUI(v, newName, RARITY[original] or "OG")

            RunService.RenderStepped:Connect(function()
                if not v or not v.Parent then
                    clearFake(v)
                    return
                end

                local isHeld = v.Parent:FindFirstChild("Humanoid")

                if isHeld then
                    showOriginal(v)
                    clearFake(v)
                else
                    hideOriginal(v)

                    if v.PrimaryPart and fake.PrimaryPart then
                        fake:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
                    end
                end
            end)
        end
    end
end

-- 🔥 scan monde
for _, v in ipairs(workspace:GetDescendants()) do
    apply(v)
end

workspace.DescendantAdded:Connect(apply)

-- 🔥 INDEX VISUEL
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            if v:IsA("TextLabel") then
                v.Text = newName
            end
        end
    end
end
