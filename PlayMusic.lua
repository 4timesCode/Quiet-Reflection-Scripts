-- Get the music list that is stored in StarterGui pack of the player
local musicfile = script.Parent:WaitForChild("MusicList")

-- Generates a random number depending on how many sound files there are in the folder
local maxsize = #musicfile:GetChildren()
local RandomNum = math.random(1, maxsize)

-- Picks a song from the folder
local song = musicfile[RandomNum]

-- declaring and initalizing variables to show the system status to the user later
local GUI = script.Parent:WaitForChild("ScreenGui")
local currentsong = GUI:WaitForChild("Frame"):WaitForChild("CurrentSong"):WaitForChild("TextBox")
local TimeFrame = GUI:WaitForChild("Frame"):WaitForChild("TimeFrame"):WaitForChild("SongFrame")


local TweenService = game:GetService("TweenService")

-- Values stored in game to be able to skip the song or mute the song
local skipsong = game.Workspace:WaitForChild("SkipValue")
local mutesong = game.Workspace:WaitForChild("MuteValue")
local skip = false

-- Calling ReplicatedStorage to fire a remote event when player wants to skip song 
local RepStore = game:GetService("ReplicatedStorage")
local NewSong = RepStore:WaitForChild("NewSong")

-- Values that are used for when the player skips a song and wants a new song
local playnewsong = false
local playerselection = ""
local playersongname = ""
local CurrentSongValue = game.Workspace:WaitForChild("CurrentSong")


--[[
	While loop that plays the current song and then moves the bar to indicate how 
	long the music has been playing.
]]
while true do
	
	--If the player wants to play song of their choice, the if 
	--branch will do so and if not, then the song will be chosen randomly.
	if playnewsong == true then
		song = musicfile:WaitForChild(playerselection)
		currentsong.Text = playersongname
		song:Play()
		CurrentSongValue.Value = playerselection
		playnewsong = false
	elseif playnewsong == false then
		RandomNum = math.random(1, maxsize)
		song = musicfile[RandomNum]
		currentsong.Text = song:WaitForChild("Value").Value
		CurrentSongValue.Value = RandomNum
		song:Play()
	end
	
	-- For loop that moves the bar on the music player to indicate how long the music has been playing.
	for count = 0, 313, 1 do
		
		--for loop increments by the number of seconds in a song divided by the size of the bar (which is 313)
		task.wait(song.TimeLength/313)
		
		-- creates a tween to slowly increase the size of the bar as the song plays
		local Tween = TweenService:Create(TimeFrame, TweenInfo.new(0.1), {Size = UDim2.new(count/		313, 0, 1, 0)})
		Tween:Play()
		
		-- if the value of skipsong changes at all, then that means the song has now changed.
		-- Bar is reset, song is stopped, and the current loop is skipped to the next song over.
		skipsong.Changed:Connect(function(player)
			song:Stop()
			TimeFrame.Size = UDim2.new(0, 0, 0, 12)
			skip = true
		end)
			
		-- if the mutesong value in game is changed, then the song will either be muted or unmuted 
		-- depending on the state it changed into. 
		mutesong.Changed:Connect(function(player)
			if mutesong.Value == true then
				song.Volume = 0
				GUI:WaitForChild("MuteFrame"):WaitForChild("TextButton").Text = "Unmute"
			end
			if mutesong.Value == false then
				song.Volume = .5
				GUI:WaitForChild("MuteFrame"):WaitForChild("TextButton").Text = "Mute"
			end
		end)
		
		-- Fires Remote event to client change to a user chosen song.
		NewSong.OnClientEvent:Connect(function(SongNum, SongName)
			playerselection = SongNum
			playersongname = SongName
			song:Stop()
			TimeFrame.Size = UDim2.new(0, 0, 0, 12)
			playnewsong = true
		end)
		
		if skip == true or playnewsong == true then
			break
		end
		
	end
	
	-- continues the function onto the next iteration and 
	--sets skip to false so the user can skip or play a new song again later.
	if skip == true or playnewsong == true then
		skip = false
		continue
	end
end
