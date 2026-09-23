local Players = game:GetService("Players")

local function addESP(player)
	if player == Players.LocalPlayer then
		return
	end

	local function setupCharacter(character)
		local oldESP = character:FindFirstChild("PlayerESP")
		if oldESP then
			oldESP:Destroy()
		end

		local highlight = Instance.new("Highlight")
		highlight.Name = "PlayerESP"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = character
	end

	if player.Character then
		setupCharacter(player.Character)
	end

	player.CharacterAdded:Connect(setupCharacter)
end

for _, player in ipairs(Players:GetPlayers()) do
	addESP(player)
end

Players.PlayerAdded:Connect(addESP)
