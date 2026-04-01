task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

-- 🔥 CACHE MODELS
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 HIDE ORIGINAL
local function hideOriginal(v)
    for _, obj in ipairs(v:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = 1
            obj.CanCollide = false
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
-- 🔥 TEXTE + EFFET OG PROPRE
-- =========================

local function processText(text)
    text = text:gsub("Mythic", "OG")
    text = text:gsub("Secret", "OG")

    for original, newName in pairs(REPLACEMENTS) do
        text = text:gsub(original, newName)
    end

    return text
end

local function addOGEffect(label)
    if not label:IsA("TextLabel") then return end
    if label.Text ~= "OG" then return end
    if label:FindFirstChild("OG_GRADIENT") then return end

    -- couleur
    label.TextColor3 = Color3.fromRGB(255, 215, 0)

    -- contour
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0,0,0)
    stroke.Thickness = 1.5
    stroke.Parent = label

    -- 🔥 gradient propre (PAS de frame)
    local gradient = Instance.new("UIGradient")
    gradient.Name = "OG_GRADIENT"

    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,215,0)),
    })

    gradient.Offset = Vector2.new(-1, 0)
    gradient.Parent = label

    -- animation fluide
    task.spawn(function()
        while gradient.Parent do
            gradient.Offset = Vector2.new(-1, 0)

            local tween = TweenService:Create(
                gradient,
                TweenInfo.new(0.8, Enum.EasingStyle.Linear),
                {Offset = Vector2.new(1, 0)}
            )

            tween:Play()
            tween.Completed:Wait()

            task.wait(1.2)
        end
    end)
end

local function fix(obj)
    -- UI
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        obj.Text = processText(obj.Text)
        addOGEffect(obj)
    end

    -- texte au-dessus des brainrots
    if obj:IsA("BillboardGui") then
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("TextLabel") then
                v.Text = processText(v.Text)
                addOGEffect(v)
            end
        end
    end
end

-- scan initial
for _, v in ipairs(game:GetDescendants()) do
    fix(v)
end

-- nouveaux éléments
game.DescendantAdded:Connect(function(v)
    fix(v)
end)

-- refresh léger
task.spawn(function()
    while true do
        task.wait(1)
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BillboardGui") then
                fix(v)
            end
        end
    end
end)
