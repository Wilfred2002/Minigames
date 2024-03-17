--game and intermission length initialized in seconds
local intermissionLength = 15
local gameLength = 60 


--initializing local variables
local lobbySpawn = game.Workspace.lobbySpawn
local gameSpawn = game.Workspace.gameSpawn
local Status = game.ReplicatedStorage.Status
local inRound = game.ReplicatedStorage.inRound
local inRoundDeath = game.ReplicatedStorage.inRoundDeath
local gameSelect = game.ReplicatedStorage.gameSelect


-- Function to randomly select and set up a game mode
local function gameSelector()
	local pastGame = game.ReplicatedStorage.pastGame
	-- Randomly select a game mode
	gameSelect.Value = math.random(1,3)

	if gameSelect.Value == 1 then
		-- Sword battle game mode
		for i, player in pairs(game.Players:GetChildren()) do
			local sword = game.ReplicatedStorage.ClassicSword:Clone()
			sword.Parent = player.Backpack
			game.Workspace.gameBoundary.CanCollide = true
			local swordsMap = game.ReplicatedStorage.swordsMap:Clone()
			swordsMap.Parent = game.Workspace.mapFolder
			pastGame.Value = 1 -- Record the game mode
		end
	elseif gameSelect.Value == 3 then
		-- Flood escape game mode
		for i, player in pairs(game.Players:GetChildren()) do
			game.Workspace.gameBoundary.CanCollide = false
			local floodMap = game.ReplicatedStorage.floodMap:Clone()
			local water = game.ReplicatedStorage.water:Clone()
			floodMap.Parent = game.Workspace.mapFolder
			water.Parent = game.Workspace.mapFolder
			pastGame.Value = 3 -- Record the game mode
			-- Gradually raise the water level
			for i = 1, 30, 1 do
				wait(0.5)
				game.Workspace.mapFolder.water.Position = game.Workspace.mapFolder.water.Position + Vector3.new(0,1,0)
			end
		end
	elseif gameSelect.Value == 2 then
		-- Laser tag game mode
		for i, player in pairs(game.Players:GetChildren()) do
			local HyperlaserGun = game.ReplicatedStorage.HyperlaserGun:Clone()
			HyperlaserGun.Parent = player.Backpack
			game.Workspace.gameBoundary.CanCollide = true
			local laserMap = game.ReplicatedStorage.laserMap:Clone()
			laserMap.Parent = game.Workspace.mapFolder
			pastGame.Value = 2 -- Record the game mode
		end
	end
end

	
-- Teleport players to game or lobby and manage round transitions
inRound.Changed:Connect(function()
	if inRound.Value then
		-- Start of the round: teleport players to the game, reset status, and clear backpacks
		for _, player in pairs(game.Players:GetChildren()) do
			player.Character.HumanoidRootPart.CFrame = gameSpawn.CFrame
			player.inRoundDeath.Value = false
			player.Backpack:ClearAllChildren()
		end
		-- Begin the game
		gameSelector()
	else
		-- End of the round: teleport players to the lobby and reward survivors
		for _, player in pairs(game.Players:GetChildren()) do
			player.Character.HumanoidRootPart.CFrame = lobbySpawn.CFrame
			player.inRoundDeath.Value = false
			if not player.inRoundDeath.Value then
				player.leaderstats.Wins.Value += 1
				player.leaderstats.Points.Value += 150
			end
		end
		-- Clean up the map and prepare for the next round
		game.Workspace.mapFolder:ClearAllChildren()
		game.Workspace.mapFolder.Water.Position = Vector3.new(-88.1,-35.4,28.9)
	end
end)


local function roundTimer()
	while wait() do
		for i = intermissionLength, 1, -1 do
			inRound.Value = false
			wait(1)
			Status.Value= "Intermission: ".. i .. " seconds left."
		end
		for i = gameLength, 1, -1 do
			inRound.Value = true
			wait(1)
			Status.Value = "Game: " .. i .. " seconds left."
		end
	end
end

spawn(roundTimer)
