local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local ESP_ENABLED = true

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Главная панель
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(360, 220)
Main.Position = UDim2.new(0.5, -180, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

-- Обводка
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(65, 65, 80)
Stroke.Thickness = 1
Stroke.Parent = Main

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -30, 0, 45)
Title.Position = UDim2.fromOffset(15, 8)
Title.BackgroundTransparency = 1
Title.Text = "ESP MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Подзаголовок
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -30, 0, 25)
Subtitle.Position = UDim2.fromOffset(15, 45)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Player visual settings"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 155)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(1, -30, 0, 60)
ESPButton.Position = UDim2.fromOffset(15, 82)
ESPButton.BackgroundColor3 = Color3.fromRGB(45, 180, 95)
ESPButton.BorderSizePixel = 0
ESPButton.Text = ""
ESPButton.AutoButtonColor = false
ESPButton.Parent = Main

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
ButtonCorner.Parent = ESPButton

-- Текст кнопки
local ButtonText = Instance.new("TextLabel")
ButtonText.Size = UDim2.new(1, -30, 1, 0)
ButtonText.Position = UDim2.fromOffset(15, 0)
ButtonText.BackgroundTransparency = 1
ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonText.TextSize = 17
ButtonText.Font = Enum.Font.GothamBold
ButtonText.TextXAlignment = Enum.TextXAlignment.Left
ButtonText.Parent = ESPButton

-- Статус
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 30)
Status.Position = UDim2.fromOffset(15, 155)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(140, 140, 155)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--==================================================
-- DRAG WINDOW
--==================================================

local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end

		end)
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)

	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end
end)

--==================================================
-- ESP
--==================================================

local function CreateESP(player)

	if player == LocalPlayer then
		return
	end

	local function SetupCharacter(character)

		local oldESP = character:FindFirstChild("ESP_Highlight")

		if oldESP then
			oldESP:Destroy()
		end

		local Highlight = Instance.new("Highlight")

		Highlight.Name = "ESP_Highlight"
		Highlight.Adornee = character

		Highlight.FillColor = Color3.fromRGB(255, 45, 45)
		Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

		Highlight.FillTransparency = 0.45
		Highlight.OutlineTransparency = 0

		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.Enabled = ESP_ENABLED

		Highlight.Parent = character
	end

	if player.Character then
		SetupCharacter(player.Character)
	end

	player.CharacterAdded:Connect(SetupCharacter)
end

-- Уже находящиеся игроки
for _, player in ipairs(Players:GetPlayers()) do
	CreateESP(player)
end

-- Новые игроки
Players.PlayerAdded:Connect(CreateESP)

--==================================================
-- UPDATE MENU
--==================================================

local function UpdateMenu()

	if ESP_ENABLED then

		ESPButton.BackgroundColor3 = Color3.fromRGB(45, 180, 95)

		ButtonText.Text = "●   ESP                         ON"

		Status.Text = "ESP is currently enabled"

	else

		ESPButton.BackgroundColor3 = Color3.fromRGB(180, 55, 60)

		ButtonText.Text = "●   ESP                         OFF"

		Status.Text = "ESP is currently disabled"

	end

end

--==================================================
-- BUTTON
--==================================================

ESPButton.MouseButton1Click:Connect(function()

	ESP_ENABLED = not ESP_ENABLED

	for _, player in ipairs(Players:GetPlayers()) do

		if player ~= LocalPlayer and player.Character then

			local Highlight = player.Character:FindFirstChild("ESP_Highlight")

			if Highlight then
				Highlight.Enabled = ESP_ENABLED
			end

		end

	end

	UpdateMenu()

end)

--==================================================
-- START
--==================================================

UpdateMenu()
