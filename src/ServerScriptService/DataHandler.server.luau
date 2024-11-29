local DataStoreService = game:GetService("DataStoreService")
local LeaderstatsDataStore = DataStoreService:GetDataStore("LeaderstatsDataStore")

game.Players.PlayerAdded:Connect(function(Player)

    local leaderstats = Instance.new("Folder", Player)
    leaderstats.Name = "leaderstats"

    local Cash = Instance.new("IntValue", leaderstats)
    Cash.Name = "Cash"
    Cash.Value = 0

    local Data
    local Success, ErrorMessage = pcall(function()
        Data = LeaderstatsDataStore:GetAsync(Player.UserId)
    end)
    if Success then
        Cash.Value = Data
        print("Data Loaded Successfully")
    else
        print("Error Loading Data:")
        warn(ErrorMessage)
    end
end)

game.Players.PlayerRemoving:Connect(function(Player)
    local Data = Player.leaderstats.Cash.Value
    local Success, ErrorMessage = pcall(function()
        LeaderstatsDataStore:SetAsync(Player.UserId, Data)
    end)
    if Success then
        print("Data Saved Successfully")
    else
        print("Error Saving Data:")
        warn(ErrorMessage)
    end
end)