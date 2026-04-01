task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

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

-- 🔥 MODELS
local ANIMALS = RS:WaitForChild("Models"):WaitForChild("Animals")

local function getModel(name)
    return ANIMALS:FindFirstChild(name)
end

-- 🔥 HIDE ORIGINAL
local function hideOriginal(v)
    for _, obj in ipairs(v:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = 1
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("BillboardGui") then
            obj.Enabled = false
        end
    end
end

-- 🔥 MONDE
local active = {}

local function apply(v)
    if not v:IsA("Model") then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            
            if active[v] then return end

            local source = getModel(newName)
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
                if not v or not v.Parent then
                    if fake then fake:Destroy() end
                    return
                end

                hideOriginal(v)

                if v.PrimaryPart and fake.PrimaryPart then
                    fake:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
                end
            end)

            break
        end
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    apply(v)
end

workspace.DescendantAdded:Connect(apply)

-- =========================
-- 🔥 TEXTE + ARGENT + OG
-- =========================

local function processText(text)

    -- 💰 ARGENT FORCÉ
    text = text:gsub("%$29%.7K/s", "$5.5b/s")
    text = text:gsub("%$42K/s", "$6.9b/s")

    -- rareté
    text = text:gsub("Mythic", "OG")
    text = text:gsub("Secret", "OG")

    -- noms
    for original, newName in pairs(REPLACEMENTS) do
        text = text:gsub(original, newName)
    end

    return text
end

-- 🔥 EFFET OG
local function addOGEffect(label)
    if not label:IsA("TextLabel") then return end
    if label.Text ~= "OG" then return end
    if label:FindFirstChild("OG_GRADIENT") then return end

    label.TextColor3 = Color3.fromRGB(255,215,0)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0,0,0)
    stroke.Thickness = 1.5
    stroke.Parent = label

    local gradient = Instance.new("UIGradient")
    gradient.Name = "OG_GRADIENT"

    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,215,0)),
    })

    gradient.Offset = Vector2.new(0, -1)
    gradient.Parent = label

    task.spawn(function()
        while gradient.Parent do
            gradient.Offset = Vector2.new(0, -1)

            local tween = TweenService:Create(
                gradient,
                TweenInfo.new(3, Enum.EasingStyle.Linear),
                {Offset = Vector2.new(0, 1)}
            )

            tween:Play()
            tween.Completed:Wait()

            task.wait(2)
        end
    end)
end

-- 🔥 TEXTE NORMAL
local function fix(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        obj.Text = processText(obj.Text)
        addOGEffect(obj)
    end

    if obj:IsA("BillboardGui") then
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("TextLabel") then
                v.Text = processText(v.Text)
                addOGEffect(v)
            end
        end
    end
end

for _, v in ipairs(game:GetDescendants()) do
    fix(v)
end

game.DescendantAdded:Connect(function(v)
    fix(v)
end)

-- 🔥 ARGENT FORCE (IMPORTANT)
RunService.RenderStepped:Connect(function()

    for _, v in ipairs(workspace:GetDescendants()) do
        
        if v:IsA("BillboardGui") then
            for _, t in ipairs(v:GetDescendants()) do
                
                if t:IsA("TextLabel") then
                    local txt = t.Text
                    
                    if string.find(txt, "%$/s") then
                        t.Text = processText(txt)
                    end
                end
            end
        end

    end

end)

-- =========================
-- 🔥 INDEX + SHOP
-- =========================

game.DescendantAdded:Connect(function(v)
    if v:IsA("ViewportFrame") then
        task.wait(0.2)

        local world = v:FindFirstChildOfClass("WorldModel")
        if not world then return end

        local model = world:FindFirstChildOfClass("Model")
        if not model then return end

        for original, newName in pairs(REPLACEMENTS) do
            if string.find(model.Name, original) then
                
                local source = getModel(newName)
                if not source then return end

                world:ClearAllChildren()
                source:Clone().Parent = world
                break
            end
        end
    end
end)
