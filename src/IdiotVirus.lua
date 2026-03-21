local Players = game:GetService("Players")

local Config = require(script.Parent:WaitForChild("Config"))

local IdiotVirus = {}

local function inverseColor(isBlack)
	if isBlack then
		return Color3.new(0, 0, 0), Color3.new(1, 1, 1)
	else
		return Color3.new(1, 1, 1), Color3.new(0, 0, 0)
	end
end

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
	sound.SoundId = Config.SoundId
	sound.Looped = true
	sound.Volume = 5
	sound.Parent = gui
	sound:Play()

	local attempts = 0

	local function createMainWindow()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.BorderSizePixel = 0
		frame.Parent = gui

		local face = Instance.new("TextLabel")
		face.Size = UDim2.new(1, 0, 0.7, 0)
		face.Position = UDim2.new(0, 0, 0.12, 0)
		face.BackgroundTransparency = 1
		face.Text = "☻"
		face.TextScaled = true
		face.Font = Enum.Font.SourceSansBold
		face.Parent = frame

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.2, 0, 0.08, 0)
		button.Position = UDim2.new(0.4, 0, 0.86, 0)
		button.Text = "Cerrar"
		button.TextScaled = true
		button.Font = Enum.Font.SourceSansBold
		button.Parent = frame

		local running = true

		task.spawn(function()
			local black = true
			while running and frame.Parent do
				local bg, fg = inverseColor(black)
				frame.BackgroundColor3 = bg
				face.TextColor3 = fg
				button.BackgroundColor3 = fg
				button.TextColor3 = bg
				black = not black
				task.wait(Config.ChaosSpeed or 0.12)
			end
		end)

		button.MouseButton1Click:Connect(function()
			attempts += 1
			running = false
			frame:Destroy()

			if attempts < Config.MaxAttempts then
				task.delay(0.8, function()
					if gui.Parent then
						createMainWindow()
					end
				end)
			else
				local final = Instance.new("TextLabel")
				final.Size = UDim2.new(1, 0, 1, 0)
				final.BackgroundColor3 = Color3.new(0, 0, 0)
				final.TextColor3 = Color3.new(1, 1, 1)
				final.TextScaled = true
				final.Font = Enum.Font.SourceSansBold
				final.Text = Config.FinalText or "Demasiado tarde..."
				final.Parent = gui

				task.wait(2)
				error("Connection lost 😈")
			end
		end)
	end

	createMainWindow()
end

return IdiotVirus
