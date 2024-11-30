local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("StatsDataStore")

local function saveData(player)
    local DataToSave = {
        player.leaderstats.Cash.Value;
        player.Stats.BreakingPower.Value;
    }

    local success, errorMessage = pcall(DataStore.SetAsync, DataStore, player.UserId, DataToSave)

    if success then
        print("Data has been saved!")
    else
        print("Data has not been saved!")
        warn(errorMessage)
    end
end

game.Players.PlayerAdded:Connect(function(Player)

    local leaderstats = Instance.new("Folder", Player)
    leaderstats.Name = "leaderstats"

    local Cash = Instance.new("IntValue", leaderstats)
    Cash.Name = "Cash"
    Cash.Value = 0

    local Stats = Instance.new("Folder", Player)
    Stats.Name = "Stats"

    local BreakingPower = Instance.new("IntValue", Stats)
    BreakingPower.Name = "BreakingPower"
    BreakingPower.Value = 1

    local Data
    local Success, ErrorMessage = pcall(function()
        Data = DataStore:GetAsync(Player.UserId)
    end)
    if Success and Data then
        Cash.Value = Data[1]
        BreakingPower.Value = Data[2]
        print("Data Loaded Successfully")
	else
        print("Error Loading Data:")
        warn(ErrorMessage)
    end
end)

game.Players.PlayerRemoving:Connect(function(Player)
    saveData(Player)
end)

game:BindToClose(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        task.spawn(saveData, player)
    end
end)