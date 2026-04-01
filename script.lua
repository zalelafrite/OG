task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 🔥 REMPLACEMENTS
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

-- 🔥 GET MODELS INDEX
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

-- 🔥 PARTIE 1 : MONDE
local activeFakes = {}

local function clearFake(v)
    if activeFakes[v] then
        activeFakes[v]:Destroy()
        activeFakes[v] = nil
    end
end

local function hide(v)
    for _, p in ipairs(v:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 1
        end
    end
end

local function show(v)
    for _, p in ipairs(v:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 0
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

            RunService.RenderStepped:Connect(function()
                if not v or not v.Parent then
                    clearFake(v)
                    return
                end

                local held = v.Parent:FindFirstChild("Humanoid")

                if held then
                    show(v)
                    clearFake(v)
                else
                    hide(v)

                    if v.PrimaryPart and fake.PrimaryPart then
                        fake:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
                    end
                end
            end)
        end
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    apply(v)
end

workspace.DescendantAdded:Connect(apply)

-- 🔥 PARTIE 2 : INDEX VISUEL (LE PLUS IMPORTANT)

for _, frame in ipairs(player.PlayerGui:GetDescendants()) do
    
    if frame:IsA("ViewportFrame") then
        
        for original, newName in pairs(REPLACEMENTS) do
            
            if string.find(frame:GetFullName(), original) then
                
                local source = CACHE[newName]
                if source then
                    
                    local world = frame:FindFirstChildOfClass("WorldModel")
                    if world then
                        
                        world:ClearAllChildren()
                        
                        local clone = source:Clone()
                        clone.Parent = world
                        
                    end
                end
            end
        end
    end
end

-- 🔥 PARTIE 3 : TEXTES GLOBAL

for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    
    if v:IsA("TextLabel") then
        
        -- rareté
        v.Text = string.gsub(v.Text, "Mythic", "OG")
        v.Text = string.gsub(v.Text, "Secret", "OG")

        -- noms
        for original, newName in pairs(REPLACEMENTS) do
            v.Text = string.gsub(v.Text, original, newName)
        end
    end
end
