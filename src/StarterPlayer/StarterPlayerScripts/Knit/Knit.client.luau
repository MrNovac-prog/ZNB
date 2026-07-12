local RS = game:GetService("ReplicatedStorage")
local Knit = require(RS.Packages.knit)

local Controllers = RS:WaitForChild("Controllers")

if typeof(Controllers) == "Instance" and Controllers:IsA("Folder") then
    Knit.AddControllers(Controllers)
else
    warn("❌ Controllers is not a folder! It is a: " .. typeof(Controllers), Controllers)
end

Knit.Start():andThen(function()
    print("✨ Knit Client successfully started!")
end):catch(function(err)
    warn("❌ Knit Client failed to start: " .. tostring(err))
end)