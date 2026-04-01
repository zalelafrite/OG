task.wait(2)

local player = game.Players.LocalPlayer
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

-- 🔥 TEXTE
local function processText(text)

    -- 💰 ARGENT (CE QUE TU VEUX)
    text = text:gsub("%$29%.7K/s", "$5.5b/s")
    text = text:gsub("%$42K/s", "$6.9b/s")

    -- rareté
    text = text:gsub("Mythic", "OG")
    text = text:gsub("Secret", "OG")

    -- noms
    for a,b in pairs(REPLACEMENTS) do
        text = text:gsub(a,b)
    end

    return text
end

-- 🔥 FIX CIBLÉ (PAS DE FREEZE)
local function fixLabel(label)
    if not label:IsA("TextLabel") then return end

    local function update()
        local new = processText(label.Text)
        if label.Text ~= new then
            label.Text = new
        end
    end

    update()

    label:GetPropertyChangedSignal("Text"):Connect(update)
end

-- 🔥 SCAN INTELLIGENT (UNE FOIS)
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("TextLabel") then
        fixLabel(v)
    end
end

-- 🔥 NOUVEAUX ELEMENTS
game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") then
        task.wait()
        fixLabel(v)
    end
end)

-- =========================
-- 🔥 EFFET OG PROPRE
-- =========================

local function addOGEffect(label)
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

-- applique OG
game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") then
        task.wait()
        addOGEffect(v)
    end
end)
