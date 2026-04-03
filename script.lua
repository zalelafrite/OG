task.wait(2)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

-- =========================
-- 🔥 CONFIG
-- =========================

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
    ["Celestial Pegasus"] = "Strawberry Elephant",

    ["Tigroligre Frutonni"] = "Skibidi Toilet",
    ["Orcalero Orcala"] = "Skibidi Toilet",
    ["Mastodontico Telepiedone"] = "Meowl",
    ["Bulbito Bandito Traktorito"] = "Meowl",
    ["Pop Pop Sahur"] = "Strawberry Elephant"
}

local ANIMALS = RS:WaitForChild("Models"):WaitForChild("Animals")

local function getModel(name)
    return ANIMALS:FindFirstChild(name)
end

-- =========================
-- 🔥 HIDE ORIGINAL (SAFE)
-- =========================

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

-- =========================
-- 🔥 REMPLACEMENT STABLE
-- =========================

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
-- 💰 TEXTE + NOM (FIX GLOBAL)
-- =========================

local function process(text)
    if not text then return text end

    text = text:gsub("Mythic", "OG")
    text = text:gsub("Secret", "OG")
    text = text:gsub("Brainrot God", "OG")

    text = text:gsub("%$2%.5M", "$1T")
    text = text:gsub("%$500M", "$1T")

    for original, newName in pairs(REPLACEMENTS) do
        text = text:gsub(original, newName)
    end

    return text
end

local function applyText(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        local new = process(v.Text)
        if v.Text ~= new then
            v.Text = new
        end
    end
end

-- 🔥 scan initial
for _, v in ipairs(game:GetDescendants()) do
    applyText(v)
end

-- 🔥 nouveaux éléments
game.DescendantAdded:Connect(function(v)
    task.wait()
    applyText(v)
end)

-- 🔥 refresh léger (fix déplacement)
task.spawn(function()
    while true do
        task.wait(2)
        for _, v in ipairs(player.PlayerGui:GetDescendants()) do
            applyText(v)
        end
    end
end)

-- =========================
-- ✨ OG EFFECT JAUNE FIX
-- =========================

local function addEffect(label)
    if label.Text ~= "OG" then return end
    if label:FindFirstChild("FX") then return end

    local g = Instance.new("UIGradient")
    g.Name = "FX"

    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,215,0))
    })

    g.Rotation = 90
    g.Parent = label

    task.spawn(function()
        while g.Parent do
            g.Offset = Vector2.new(0,-1)

            TweenService:Create(
                g,
                TweenInfo.new(2, Enum.EasingStyle.Linear),
                {Offset = Vector2.new(0,1)}
            ):Play()

            task.wait(2)
        end
    end)
end

-- appliquer effet
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("TextLabel") then
        addEffect(v)
    end
end
