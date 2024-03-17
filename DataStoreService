-- Data Store setup for persistent data across sessions
local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("myDataStore")

-- Reference to inRoundDeath for player status tracking
local inRoundDeath = game.ReplicatedStorage.inRoundDeath

-- Function to handle player joining, sets up leaderstats and death tracking
local function onPlayerJoin(player)
    -- Create a folder for leaderstats in the player object
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    -- Create and initialize a Wins IntValue within leaderstats
    local wins = Instance.new("IntValue")
    wins.Name = "Wins"
    wins.Value = 0
    wins.Parent = leaderstats	

    -- Create and initialize a Points IntValue within leaderstats
    local Points = Instance.new("IntValue")
    Points.Name = "Points"
    Points.Value = 0
    Points.Parent = leaderstats

    -- Clone inRoundDeath object to player for tracking their death status in a round
    inRoundDeath:Clone().Parent = player

    -- Connect to the CharacterAdded event to track player deaths
    player.CharacterAdded:Connect(function(Char)
        Char.Humanoid.Died:Connect(function()
            -- When the player dies, set their inRoundDeath value to true
            player.inRoundDeath.Value = true
        end)
    end)
end

-- Connect the onPlayerJoin function to the PlayerAdded event
game.Players.PlayerAdded:Connect(onPlayerJoin)

-- Placeholder for player removal logic (e.g., saving data)
game.Players.PlayerRemoving:Connect(function()
    -- Add code here to handle player removal, such as saving data
end)
