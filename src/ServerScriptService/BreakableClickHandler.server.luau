local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local MoneyModule = require(game:GetService("ReplicatedStorage").Modules.Money)

local function RewardCoins(player, breakable)
    local attributes = breakable:GetAttributes()
    for playerName, amount in pairs(attributes) do
        local player = Players:FindFirstChild(playerName)
        if player then
            if MoneyModule.addMoney then
                MoneyModule.addMoney(player, amount)
            else
                warn("MoneyModule.addMoney is not a function")
            end
        end
    end
end

local function DamageCoin(player, breakable)
	
    if breakable:GetAttribute(player.Name) then
        if breakable.CurrentHealth.Value >= player.Stats.BreakingPower.Value then
            breakable:SetAttribute(player.Name, breakable:GetAttribute(player.Name) + player.Stats.BreakingPower.Value)
        else
            breakable:SetAttribute(player.Name, breakable:GetAttribute(player.Name) + breakable.CurrentHealth.Value)
        end
    else
        breakable:SetAttribute(player.Name, player.Stats.BreakingPower.Value)
    end
    breakable:WaitForChild("CurrentHealth").Value -= player.Stats.BreakingPower.Value
end

local function clickFunction(player, breakable)
    DamageCoin(player, breakable)
    if breakable:WaitForChild("CurrentHealth").Value <= 0 then
        RewardCoins(player, breakable)
        breakable:Destroy()
    end
end

CollectionService:GetInstanceAddedSignal("Breakable"):Connect(function(Breakable)
	Breakable.ClickDetector.MouseClick:Connect(function(player)
		clickFunction(player, Breakable)
	end)
end)