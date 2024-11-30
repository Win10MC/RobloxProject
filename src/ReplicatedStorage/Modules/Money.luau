local Money = {}

Money.addMoney = function(player, amount)
    if player and player.leaderstats and player.leaderstats.Cash then
        player.leaderstats.Cash.Value = math.clamp(player.leaderstats.Cash.Value + amount, 0, math.huge)
    end
end

Money.removeMoney = function(player, amount)
    if player and player.leaderstats and player.leaderstats.Cash then
        Money.addMoney(player, -amount)
    end
end

Money.getMoney = function(player)
    if player and player.leaderstats and player.leaderstats.Cash then
        return player.leaderstats.Cash.Value
    end
    return 0
end

Money.hasMoney = function(player, amount)
    return Money.getMoney(player) >= amount
end

return Money