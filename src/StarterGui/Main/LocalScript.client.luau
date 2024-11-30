script.Parent.Text = game.Players.LocalPlayer:WaitForChild('leaderstats').Cash.Value
game.Players.LocalPlayer:WaitForChild('leaderstats').Cash:GetPropertyChangedSignal("Value"):Connect(function()
    script.Parent.Text = game.Players.LocalPlayer:WaitForChild('leaderstats').Cash.Value
end)