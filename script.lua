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

-- 🔥 CACHE MODELS INDEX
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

local function clear(v)
    if active[v] then
        active[v]:Destroy()
        active[v] = nil
    end
end

local function apply(v)
    if not v:IsA("Model") then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            clear(v)

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
                if not v or not v.Parent then
                    clear(v)
                    return
                end

                local held = v.Parent:FindFirstChild("Humanoid")

                if held then
                    clear(v)
                else
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

-- 🔥 INDEX FIX (FIABLE)
task.spawn(function()
    while true do
        task.wait(0.5)

        for _, vp in ipairs(player.PlayerGui:GetDescendants()) do
            
            if vp:IsA("ViewportFrame") then
                
                local world = vp:FindFirstChildOfClass("WorldModel")
                if not world then continue end

                local model = world:FindFirstChildOfClass("Model")
                if not model then continue end

                for original, newName in pairs(REPLACEMENTS) do
                    
                    if string.find(model.Name, original) then
                        
                        local source = CACHE[newName]
                        if source then
                            
                            if model.Name ~= newName then
                                world:ClearAllChildren()
                                
                                local clone = source:Clone()
                                clone.Parent = world
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 🔥 TEXTES GLOBAL (PARTOUT)
task.spawn(function()
    while true do
        task.wait(0.3)

        for _, v in ipairs(player.PlayerGui:GetDescendants()) do
            
            if v:IsA("TextLabel") then
                
                -- rareté
                if string.find(v.Text, "Mythic") then
                    v.Text = "OG"
                end
                
                if string.find(v.Text, "Secret") then
                    v.Text = "OG"
                end

                -- noms
                for original, newName in pairs(REPLACEMENTS) do
                    if string.find(v.Text, original) then
                        v.Text = newName
                    end
                end
            end
        end
    end
end)
