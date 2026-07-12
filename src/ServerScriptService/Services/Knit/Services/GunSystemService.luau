-- // Services // --
local RS = game:GetService("ReplicatedStorage")

-- // Modules // --
local Knit = require(RS.Packages.knit)

-- // Service // --
local GunSystemService = Knit.CreateService {
    Name = "GunSystemService",
    Client = {
        ToggleSystem = Knit.CreateSignal()
    }
}

function GunSystemService:ToggleSystemForPlayer(player: Player, enable: boolean)
    self.Client.ToggleSystem:Fire(player, enable)
end

function GunSystemService:KnitStart() end
function GunSystemService:KnitInit() end

return GunSystemService