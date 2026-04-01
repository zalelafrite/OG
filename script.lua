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

-- 🔥 CACHE MODELS
local CACHE = {}
for _, v in ipairs(player.PlayerGui:GetDescendants()) do
    if v:IsA("Model") then
        CACHE[v.Name] = v
    end
end

-- 🔥 MONDE (SIMPLE ET STABLE)
local function apply(v)
    if not v:IsA("Model") then return end

    for original, newName in pairs(REPLACEMENTS) do
        if string.find(v.Name, original) then
            
            local source = CACHE[newName]
            if not source then return end

            local fake = source:Clone()
            fake.Parent = workspace

            if not fake.PrimaryPart then
                fake.PrimaryPart = fake:FindFirstChildWhichIsA("BasePart")
            end

            for _, p in ipairs(fake:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Anchored = true
                    p.CanCollide = false
                end
            end

            -- 🔥 follow SANS spam
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not v or not v.Parent then
                    if conn then conn:Disconnect() end
                    if fake then fake:Destroy() end
                    return
                end

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

-- 🔥 TEXTES GLOBAL (UNE FOIS)
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        
        v.Text = v.Text:gsub("Mythic", "OG")
        v.Text = v.Text:gsub("Secret", "OG")

        for original, newName in pairs(REPLACEMENTS) do
            v.Text = v.Text:gsub(original, newName)
        end
    end
end
