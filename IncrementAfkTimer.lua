-- Get the player's humanoid character to track movement
local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")

-- Get the RemoteEvents to fire later
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StartTimer = ReplicatedStorage:WaitForChild("StartTimer")
local EndTimer = ReplicatedStorage:WaitForChild("EndTimer")

-- Get the counter timer that will be shown to the user
local Counter = script.Parent:WaitForChild("ScreenGui"):WaitForChild("TimeFrame"):WaitForChild("Timer"):WaitForChild("TextLabel")

-- Bool values to be used in the script
local IntValue = Counter.Parent:WaitForChild("TimerValue")
local StopValue = false

--If the player moves in any direction, start the timer. Otherwise, end the timer if movement is detected.
humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
	
	if math.round(humanoid.MoveDirection.Magnitude) == 0 then
		StartTimer:FireServer(player)
	else
		EndTimer:FireServer(player)
	end
	
end)

-- When the player stops moving, each second the counter will increment and 
-- if at any time they move, then the timer will stop and reset.
StartTimer.OnClientEvent:Connect(function(player)
	while true do
		local value = IntValue.Value
		task.wait(1)
		if StopValue == true then
			StopValue = false
			IntValue.Value = 0
			Counter.Text = "0 seconds"
			break
		elseif StopValue == false then
			Counter.Text = value .. " seconds"
			IntValue.Value = value + 1
		end
	end
end)

-- when the player stops moving, the StopValue timer is set 
-- to true to stop the timer and reset it.
EndTimer.OnClientEvent:Connect(function(player)
	StopValue = true
	IntValue.Value = 0
	Counter.Text = "0 seconds"
end)
