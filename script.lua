task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

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

-- 🔥 MODELS INDEX
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

-- 🔥 MONDE
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

-- 🔥 INDEX (EVENT BASED)
local function fixViewport(vp)
    local world = vp:FindFirstChildOfClass("WorldModel")
    if not world then return end

    local model = world:FindFirstChildOfClass("Model")
    if not model then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(model.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            world:ClearAllChildren()
            source:Clone().Parent = world
        end
    end
end

for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("ViewportFrame") then
        fixViewport(v)
    end
end

player.PlayerGui.DescendantAdded:Connect(function(v)
    if v:IsA("ViewportFrame") then
        task.wait(0.1)
        fixViewport(v)
    end
end)

-- 🔥 TEXTES (UNE FOIS + EVENT)
local function fixText(obj)
    if not obj:IsA("TextLabel") then return end

    obj.Text = obj.Text:gsub("Mythic", "OG")
    obj.Text = obj.Text:gsub("Secret", "OG")

    for original, newName in pairs(REPLACEMENTS) do
        obj.Text = obj.Text:gsub(original, newName)
    end
end

for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    fixText(v)
end

player.PlayerGui.DescendantAdded:Connect(function(v)
    fixText(v)
end)
