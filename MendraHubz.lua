-- MENDRA HUBZ - interface reconstruida
-- Uso: Roblox Studio > StarterPlayer > StarterPlayerScripts > LocalScript
-- IMPORTANTE:
-- 1) Troque IMAGE_ASSET_ID pelo ID da imagem depois de enviá-la ao Roblox.
-- 2) Troque BACKGROUND_AUDIO_ID por um áudio que você tenha permissão para usar.
-- 3) Preencha CATALOG com IDs de áudio que estejam disponíveis para sua experiência.
-- 4) Este projeto é uma interface legítima: não contém auto-shoot, auto-knife,
--    ESP/visão através de paredes ou automação de combate no MM2.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local IMAGE_ASSET_ID = "rbxassetid://0" -- substitua pelo ID da sua imagem
local BACKGROUND_AUDIO_ID = "rbxassetid://0" -- use um áudio autorizado

-- Não há uma lista pública garantida com TODOS os áudios do Roblox.
-- Adicione aqui somente IDs que você verificou e pode usar.
local CATALOG = {
    -- {name = "Nome da música", id = "1234567890"},
}

local old = playerGui:FindFirstChild("MendraHubz")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "MendraHubz"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local blue = Color3.fromRGB(22, 91, 165)
local dark = Color3.fromRGB(8, 22, 42)
local panel = Color3.fromRGB(13, 39, 69)
local pale = Color3.fromRGB(222, 240, 255)

local main = make("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(570, 390),
    Position = UDim2.new(0.5, -285, 0.5, -195),
    BackgroundColor3 = dark,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
make("UIStroke", {Color = Color3.fromRGB(69, 157, 230), Thickness = 1.5}, main)

-- Barra superior e arraste manual
local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = blue,
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, top)
make("Frame", {
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = blue,
    BorderSizePixel = 0,
}, top)

local logo = make("ImageLabel", {
    Size = UDim2.fromOffset(44, 44),
    Position = UDim2.fromOffset(8, 7),
    BackgroundColor3 = panel,
    Image = IMAGE_ASSET_ID,
    ScaleType = Enum.ScaleType.Crop,
    BorderSizePixel = 0,
}, top)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, logo)

make("TextLabel", {
    Position = UDim2.fromOffset(62, 7),
    Size = UDim2.new(1, -120, 0, 25),
    BackgroundTransparency = 1,
    Text = "MENDRA HUBZ",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)
make("TextLabel", {
    Position = UDim2.fromOffset(63, 31),
    Size = UDim2.new(1, -130, 0, 17),
    BackgroundTransparency = 1,
    Text = "Community Hub",
    TextColor3 = pale,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local close = make("TextButton", {
    Size = UDim2.fromOffset(34, 32),
    Position = UDim2.new(1, -42, 0, 12),
    BackgroundColor3 = Color3.fromRGB(170, 55, 65),
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    BorderSizePixel = 0,
}, top)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Chuvinha decorativa
local rainLayer = make("Frame", {
    Name = "Rain",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 1,
}, main)
for i = 1, 24 do
    local drop = make("Frame", {
        Size = UDim2.fromOffset(2, math.random(7, 14)),
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        BackgroundColor3 = Color3.fromRGB(130, 190, 235),
        BackgroundTransparency = 0.42,
        BorderSizePixel = 0,
        ZIndex = 1,
    }, rainLayer)
    task.spawn(function()
        while drop.Parent do
            drop.Position = UDim2.new(math.random(), 0, -0.08, 0)
            local duration = math.random(18, 32) / 10
            local tw = TweenService:Create(drop, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(drop.Position.X.Scale, 0, 1.08, 0)
            })
            tw:Play()
            tw.Completed:Wait()
        end
    end)
end

-- Conteúdo fica acima da chuva
local nav = make("Frame", {
    Position = UDim2.fromOffset(10, 70),
    Size = UDim2.fromOffset(135, 308),
    BackgroundColor3 = panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ZIndex = 3,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, nav)

local content = make("Frame", {
    Position = UDim2.fromOffset(155, 70),
    Size = UDim2.new(1, -165, 1, -82),
    BackgroundColor3 = panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ZIndex = 3,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, content)

local pages = {}
local function newPage(name)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 4,
    }, content)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, page)
    make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    pages[name] = page
    return page
end

local function label(parent, text, height)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, height or 34),
        BackgroundColor3 = Color3.fromRGB(20, 58, 94),
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = pale,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextWrapped = true,
        ZIndex = 5,
    }, parent)
end

local function button(parent, text, callback)
    local b = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(28, 105, 175),
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        ZIndex = 5,
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local home = newPage("Main")
label(home, "MENDRA HUBZ  •  MENU PRINCIPAL", 38)
label(home, "Interface reconstruída com chuva animada e janela arrastável.", 42)
label(home, "Recursos de mira automática, lançamento automático de faca e ESP não estão incluídos.", 58)
label(home, "Bomb Jump / Gold / Green: não há implementação aqui para explorar ou automatizar partidas públicas.", 64)
label(home, "Use este hub apenas para recursos permitidos pelo jogo ou no seu próprio projeto.", 48)

local devs = newPage("Owners")
label(devs, "OWNERS / DEVS", 38)
label(devs, "mendra_fogo  —  OWNER SCRIPT")
label(devs, "mendra_fogoo  —  ADMIN")
label(devs, "wowoxi4  —  ADMIN AJUDANTE")
label(devs, "wowoxi_33  —  ADMIN AJUDANTE")

local boombox = newPage("Boombox")
label(boombox, "BOOMBOX GLOBAL  •  CATÁLOGO LOCAL", 38)
label(boombox, "Pesquise no catálogo que você preencher com áudios verificados. Nem todo áudio é permitido em todos os jogos.", 54)

local search = make("TextBox", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(7, 24, 43),
    BorderSizePixel = 0,
    PlaceholderText = "Digite o nome da música...",
    Text = "",
    TextColor3 = Color3.new(1, 1, 1),
    PlaceholderColor3 = Color3.fromRGB(160, 185, 205),
    Font = Enum.Font.Gotham,
    TextSize = 13,
    ClearTextOnFocus = false,
    ZIndex = 5,
}, boombox)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, search)

local idBox = make("TextBox", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(7, 24, 43),
    BorderSizePixel = 0,
    PlaceholderText = "ID encontrado aparecerá aqui para copiar manualmente",
    Text = "",
    TextColor3 = Color3.new(1, 1, 1),
    PlaceholderColor3 = Color3.fromRGB(160, 185, 205),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    ZIndex = 5,
}, boombox)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, idBox)

local results = make("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 5,
}, boombox)
make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, results)

local function refresh()
    for _, child in ipairs(results:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    local term = string.lower(search.Text)
    local found = 0
    for _, item in ipairs(CATALOG) do
        if string.find(string.lower(item.name), term, 1, true) then
            found += 1
            local b = button(results, item.name .. "  |  ID: " .. item.id, function()
                idBox.Text = tostring(item.id)
                idBox:CaptureFocus()
                idBox.CursorPosition = #idBox.Text + 1
            end)
        end
    end
    if found == 0 then
        label(results, "ERROR: NÃO EXISTE ESSE ÁUDIO NO CATÁLOGO", 42)
    end
end
search:GetPropertyChangedSignal("Text"):Connect(refresh)
refresh()

local tabButtons = {}
local function showPage(name)
    for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
    for pageName, b in pairs(tabButtons) do
        b.BackgroundColor3 = pageName == name and Color3.fromRGB(40, 135, 210) or Color3.fromRGB(18, 65, 108)
    end
end

for _, info in ipairs({
    {"Main", "INÍCIO"},
    {"Owners", "OWNERS / DEVS"},
    {"Boombox", "BOOMBOX GLOBAL"},
}) do
    local pageName, title = info[1], info[2]
    tabButtons[pageName] = button(nav, title, function() showPage(pageName) end)
end
showPage("Main")

-- Música de fundo: só toca se você configurar um ID autorizado.
if BACKGROUND_AUDIO_ID ~= "rbxassetid://0" then
    local sound = Instance.new("Sound")
    sound.Name = "MendraHubzBackground"
    sound.SoundId = BACKGROUND_AUDIO_ID
    sound.Volume = 0.18
    sound.Looped = true
    sound.Parent = SoundService
    sound:Play()
    gui.Destroying:Connect(function() sound:Destroy() end)
end
