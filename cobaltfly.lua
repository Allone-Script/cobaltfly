-- CobaltFly.lua

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CobaltFlyGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Создание основного фрейма
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 150) -- Increased height for better layout
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Adjusted position
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Создание заголовка
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "CobaltFly"
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Создание ползунка для скорости
local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(1, 0, 0, 30)
speedSlider.Position = UDim2.new(0, 0, 0.2, 0) -- Adjusted position
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.Text = "Speed: 1"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextSize = 18
speedSlider.Font = Enum.Font.SourceSans
speedSlider.Parent = mainFrame

local speedValue = 1

speedSlider.MouseButton1Click:Connect(function()
    speedValue = speedValue + 1
    if speedValue > 50 then
        speedValue = 1
    end
    speedSlider.Text = "Speed: " .. tostring(speedValue)
end)

-- Создание кнопки включения/выключения
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.5, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0, 0, 0.5, 0) -- Adjusted position
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Enable"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Parent = mainFrame

local isFlyEnabled = false

toggleButton.MouseButton1Click:Connect(function()
    isFlyEnabled = not isFlyEnabled
    if isFlyEnabled then
        toggleButton.Text = "Disable"
    else
        toggleButton.Text = "Enable"
    end
end)

-- Создание галочки для обхода
local bypassCheckBox = Instance.new("TextButton")
bypassCheckBox.Size = UDim2.new(0.5, 0, 0.2, 0)
bypassCheckBox.Position = UDim2.new(0.5, 0, 0.5, 0) -- Adjusted position
bypassCheckBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bypassCheckBox.Text = "Bypass"
bypassCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassCheckBox.TextSize = 18
bypassCheckBox.Font = Enum.Font.SourceSans
bypassCheckBox.Parent = mainFrame

local isBypassEnabled = false

bypassCheckBox.MouseButton1Click:Connect(function()
    isBypassEnabled = not isBypassEnabled
    if isBypassEnabled then
        bypassCheckBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        bypassCheckBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Перетаскивание окна
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Скрытие/отображение GUI по нажатию Right Control
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        if screenGui.Enabled then
            screenGui.Enabled = false
        else
            screenGui.Enabled = true
        end
    end
end)

-- Обновление позиции игрока
game:GetService("RunService").RenderStepped:Connect(function()
    if isFlyEnabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local moveVector = Vector3.new(0, 0, 0)

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + (workspace.CurrentCamera.CoordinateFrame.LookVector * speedValue)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - (workspace.CurrentCamera.CoordinateFrame.LookVector * speedValue)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - (workspace.CurrentCamera.CoordinateFrame.RightVector * speedValue)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + (workspace.CurrentCamera.CoordinateFrame.RightVector * speedValue)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + (Vector3.new(0, speedValue, 0))
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - (Vector3.new(0, speedValue, 0))
            end

            humanoidRootPart.Velocity = moveVector
        end
    end

    if isBypassEnabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        end
    end
end)
