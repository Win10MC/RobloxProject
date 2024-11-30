local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Zones = Workspace:WaitForChild("Zones"):GetChildren()

function zoneExists(input)
    for _, zone in pairs(Zones) do
        if zone.Name == input then
            return true
        end
    end
    return false
end

local function getZoneByName(name)
    for _, zone in pairs(Zones) do
        if zone.Name == name then
            return zone
        end
    end
    return nil
end

local function isPositionColliding(position, existingCoins, radius)
    for _, coin in pairs(existingCoins) do
        if (coin.Position - position).Magnitude < radius then
            return true
        end
    end
    return false
end

local function generateLocation(Zone)
    if zoneExists(Zone) then
        local zone = getZoneByName(Zone)
        if zone then
            local spawnZone = zone:FindFirstChild("SpawnZone")
            if spawnZone then
                local size = spawnZone.Size
                local position = spawnZone.Position
                local maxAttempts = 10
                local existingCoins = zone:FindFirstChild("Breakables"):GetChildren()

                local margin = 2

                for _ = 1, maxAttempts do
                    local x = math.random(position.X - size.X / 2 + margin, position.X + size.X / 2 - margin)
                    local y = position.Y - 0.1
                    local z = math.random(position.Z - size.Z / 2 + margin, position.Z + size.Z / 2 - margin)
                    local newPosition = Vector3.new(x, y, z)

                    if not isPositionColliding(newPosition, existingCoins, 5) then
                        return newPosition
                    end
                end

                warn("Failed to find a valid non-colliding position after", maxAttempts, "attempts")
            end
        end
    end
    return nil
end

local function updateBreakable(Coin)
    Coin.UI.Border.ProgressText.Text = tostring(Coin.CurrentHealth.Value)
    Coin.UI.Border.Progress.Size = UDim2.new(Coin.CurrentHealth.Value / Coin.TotalHealth.Value, 0, 1, 0)
end

local function SpawnBreakable(Zone)
    if zoneExists(Zone) then
        local zone = getZoneByName(Zone)
        local breakablesFolder = zone:FindFirstChild("Breakables")
        local coinTemplate = ReplicatedStorage.Zones:FindFirstChild(Zone):FindFirstChild("Coin")

        if breakablesFolder and coinTemplate then
            local newCoin = coinTemplate:Clone()
            local position = generateLocation(Zone)
            if position then
                newCoin.Position = position
                newCoin.Parent = breakablesFolder
                newCoin.CurrentHealth.Value = newCoin.TotalHealth.Value
                CollectionService:AddTag(newCoin, "Breakable")
                updateBreakable(newCoin)
            else
                warn("Could not spawn a coin in zone:", Zone)
            end
        else
            warn("Breakables folder or coin template missing for zone:", Zone)
        end
    else
        warn("Zone does not exist:", Zone)
    end
end

local function EnsureZone(Zone, Amount)
    if zoneExists(Zone) then
		if #getZoneByName(Zone).Breakables:GetChildren() >= Amount then return end
        for _ = #getZoneByName(Zone).Breakables:GetChildren(), Amount - 1 do
            SpawnBreakable(Zone)
        end

    end
end

coroutine.wrap(function()
    while wait() do
        for _, zone in pairs(Zones) do
            for _, coin in pairs(zone.Breakables:GetChildren()) do
                updateBreakable(coin)
            end
        end
    end
end)()

coroutine.wrap(function()
    while wait(5) do
        for _, zone in pairs(Zones) do
            EnsureZone(zone.Name, 100)
        end
    end
end)()