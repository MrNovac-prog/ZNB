-- // Services // --
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- // Modules // --
local WeaponUtils = require(RS.Modules.Utils.WeaponUtils)
local Knit = require(RS.Packages.knit)

-- // Knit Service // --
local SystemController = Knit.CreateController { Name = "SystemController" }

-- // Array // --
local loadout = {
    CoreGuns = { [1] = "Fists", [2] = "None" },
    Utilitys = { [1] = "Grenade", [2] = "Flash Bang" },
}

-- // Actions // --
function SystemController:EnableSystem()
    print("Gun system activated on client.")
   local VM = WeaponUtils:ViewmodelSetUp()
   WeaponUtils:RenderWeapon(VM, "Connection1", Players.LocalPlayer)
    
end

function SystemController:DisableSystem()
    print("Gun system deactivated on client.")
    --// Handle Unequipping Here
end

function SystemController:KnitStart()
    local GunSystemService = Knit.GetService("GunSystemService")

    GunSystemService.ToggleSystem:Connect(function(enable: boolean)
        if enable then
            self:EnableSystem()
        else
            self:DisableSystem()
        end
    end)
end

function SystemController:KnitInit() end

return SystemController