local IdiotVirus = {}

IdiotVirus.Config = {
	SoundId = "rbxassetid://7266001792",
	MaxWindows = 6,
	MaxAttempts = 10,
	ChaosSpeed = 0.2,
	TitleText = "YOU ARE AN IDIOT 😈",
	FinalText = "Demasiado tarde...",
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function IdiotVirus:Run()
	local player = Players.LocalPlayer
	if not player then
		warn("IdiotVirus: LocalPlayer not available")
		return
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "IdiotVirusGui"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local sound = Instance.new("Sound")
	sound.Name = "IdiotVirusSound"
	sound.SoundId = self.Config.SoundId
	sound.Looped = true
	sound.Volume = 5
	sound.Parent = gui
	sound:Play()

	local closeAttempts = 0
	local windows = {}

	local function createWindow()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0.4, 0, 0.3, 0)
		frame.Position = UDim2.new(math.random() * 0.6, 0, math.random() * 0.7, 0)
		frame.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random())
		frame.BorderSizePixel = 0
		frame.Parent = gui

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 0.7, 0)
		text.BackgroundTransparency = 1
		text.Text = self.Config.TitleText
		text.TextScaled = true
		text.TextColor3 = Color3.new(1, 0, 0)
		text.Parent = frame

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.5, 0, 0.25, 0)
		button.Position = UDim2.new(0.25, 0, 0.72, 0)
		button.Text = "Cerrar"
		button.TextScaled = true
		button.Parent = frame

		local alive = true

		task.spawn(function()
			while alive and frame.Parent do
				frame.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.7, 0)
				frame.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random())
				task.wait(self.Config.ChaosSpeed)
			end
		end)

		button.MouseButton1Click:Connect(function()
			closeAttempts += 1
			alive = false
			frame:Destroy()

			if closeAttempts < self.Config.MaxAttempts then
				task.delay(1, function()
					if gui.Parent then
						createWindow()
					end
				end)
			else
				for _, child in ipairs(gui:GetChildren()) do
					if child:IsA("Frame") then
						child:Destroy()
					end
				end

				local final = Instance.new("TextLabel")
				final.Size = UDim2.new(1, 0, 1, 0)
				final.BackgroundColor3 = Color3.new(0, 0, 0)
				final.TextColor3 = Color3.new(1, 0, 0)
				final.TextScaled = true
				final.Text = self.Config.FinalText
				final.Parent = gui

				task.wait(2)
				error("Connection lost 😈")
			end
		end)

		table.insert(windows, frame)
	end

	for _ = 1, math.min(3, self.Config.MaxWindows) do
		createWindow()
	end
end

return IdiotVirus
