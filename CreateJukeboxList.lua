-- Getting the ReplicatedStorage service to copy frames into the GUI of the jukebox
local RepStore = game:GetService("ReplicatedStorage")

-- Getting the music list to create a frame for each song
local Musiclist = RepStore:WaitForChild("MusicList")
local MusicArray = Musiclist:GetChildren()

-- Finds the Frame to apply the new frames to
local ScrollingFrame = game.Workspace:WaitForChild("Jukebox"):WaitForChild("Jukebox"):WaitForChild("SurfaceGui"):WaitForChild("Frame")
:WaitForChild("ScrollingFrame")

-- For loop generates a frame for each song in the music list and correctly 
-- positions it on the frame it is parented to
for spot, data in ipairs(Musiclist:GetChildren()) do
	
	--Clones the part from ReplicatedStorage
	local NewLeaderboardFrame = game.ReplicatedStorage:WaitForChild("Frame"):Clone()
	
	-- Changes the text to be the song name and positions it correctly
	NewLeaderboardFrame.TitleFrame.TextLabel.Text = MusicArray[spot].Value.Value
	NewLeaderboardFrame.Position = UDim2.new(0, 0, NewLeaderboardFrame.Position.Y.Scale + (.022* #ScrollingFrame:GetChildren()), 0)
	NewLeaderboardFrame.Parent = ScrollingFrame
	NewLeaderboardFrame.Value.Value = MusicArray[spot].Name
end
