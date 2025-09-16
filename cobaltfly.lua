-- CobaltFly.lua

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CobaltFlyGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Создание основного фрейма
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 210)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -105)
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
speedSlider.Position = UDim2.new(0, 0, 0.14, 0)
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

-- Создание кнопки включения/выключения полета
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.5, 0, 0.15, 0)
toggleButton.Position = UDim2.new(0, 0, 0.33, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Enable Fly"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Parent = mainFrame

local isFlyEnabled = false

-- Создание кнопки NoClip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.5, 0, 0.15, 0)
noclipButton.Position = UDim2.new(0.5, 0, 0.33, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.Text = "NoClip: Off"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 18
noclipButton.Font = Enum.Font.SourceSans
noclipButton.Parent = mainFrame

local isNoclipEnabled = false
local noclipConnection = nil
local originalWalkSpeed = 16
local originalGravity = 196.2

-- Создание кнопки TestClip
local testclipButton = Instance.new("TextButton")
testclipButton.Size = UDim2.new(0.5, 0, 0.15, 0)
testclipButton.Position = UDim2.new(0, 0, 0.52, 0)
testclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
testclipButton.Text = "TestClip: Off"
testclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testclipButton.TextSize = 18
testclipButton.Font = Enum.Font.SourceSans
testclipButton.Parent = mainFrame

local isTestclipEnabled = false
local testclipConnection = nil

-- Функция телепортации вперед
local function teleportForward(distance)
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Получаем направление взгляда камеры
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            
            -- Телепортируем вперед
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (lookVector * distance)
        end
    end
end

-- Функция TestClip (простая телепортация вперед)
local function toggleTestclip()
    isTestclipEnabled = not isTestclipEnabled
    
    if isTestclipEnabled then
        testclipButton.Text = "TestClip: On"
        testclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        
        -- Создаем соединение для обработки телепортации
        if testclipConnection then
            testclipConnection:Disconnect()
        end
        
        testclipConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and isTestclipEnabled then
                -- Телепортация при нажатии клавиши E
                if input.KeyCode == Enum.KeyCode.E then
                    teleportForward(5) -- Телепортация на 5 stud'ов вперед
                end
            end
        end)
        
    else
        testclipButton.Text = "TestClip: Off"
        testclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Отключаем соединение
        if testclipConnection then
            testclipConnection:Disconnect()
            testclipConnection = nil
        end
    end
end

testclipButton.MouseButton1Click:Connect(toggleTestclip)

-- Функция NoClip
local function toggleNoclip()
    isNoclipEnabled = not isNoclipEnabled
    
    local character = game.Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if isNoclipEnabled then
        noclipButton.Text = "NoClip: On"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Сохраняем оригинальные значения
        if humanoid then
            originalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = 3
        end
        
        if workspace then
            originalGravity = workspace.Gravity
            workspace.Gravity = 50
        end
        
        -- Отключаем коллизии
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        
        -- Создаем соединение для постоянного отключения коллизий
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if isNoclipEnabled and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
    else
        noclipButton.Text = "NoClip: Off"
        noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Восстанавливаем значения
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed
        end
        
        if workspace then
            workspace.Gravity = originalGravity
        end
        
        -- Восстанавливаем коллизии
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        -- Отключаем соединение
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

noclipButton.MouseButton1Click:Connect(toggleNoclip)

toggleButton.MouseButton1Click:Connect(function()
    isFlyEnabled = not isFlyEnabled
    if isFlyEnabled then
        toggleButton.Text = "Disable Fly"
    else
        toggleButton.Text = "Enable Fly"
    end
end)

-- Создание галочки для обхода
local bypassCheckBox = Instance.new("TextButton")
bypassCheckBox.Size = UDim2.new(0.5, 0, 0.15, 0)
bypassCheckBox.Position = UDim2.new(0.5, 0, 0.52, 0)
bypassCheckBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bypassCheckBox.Text = "Bypass fly"
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

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
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
        mainFrame.Visible = not mainFrame.Visible
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
            humanoidRootPart.AssemblyLinearVelocity = moveVector
        end
    end

    if isBypassEnabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.Velocity = Vector3.new(0, 50, 0)
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 50, 0)
        end
    end
end)

-- Автоматическое отключение при смерти
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        if isNoclipEnabled then
            isNoclipEnabled = false
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            noclipButton.Text = "NoClip: Off"
            noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        
        if isTestclipEnabled then
            isTestclipEnabled = false
            if testclipConnection then
                testclipConnection:Disconnect()
                testclipConnection = nil
            end
            testclipButton.Text = "TestClip: Off"
            testclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
end)
