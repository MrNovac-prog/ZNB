local RS = game:GetService("ReplicatedStorage")
local Knit = require(RS.Packages.knit)

return function(context, Player: Players, Enable: boolean)

    local GunSystemService = Knit.GetService("GunSystemService")

    if Enable then
        context:Reply("Enabling gun system for " .. Player.Name)
        GunSystemService:ToggleSystemForPlayer(Player, true)
    else
        context:Reply("Disabling gun system for " .. Player.Name)
        GunSystemService:ToggleSystemForPlayer(Player, false)
    end
    
    return "Command executed successfully" 
end