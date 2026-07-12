-- // Services // --
local RS = game:GetService("ReplicatedStorage")

-- // Modules // --

local Cmdr = require(RS:WaitForChild("CmdrClient"))

if Cmdr then
    Cmdr:SetActivationKeys({Enum.KeyCode.Comma})
elseif not Cmdr then
    warn("Could Not Find Cmdr Client")
end
