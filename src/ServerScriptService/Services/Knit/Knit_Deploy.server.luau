-- // Server Deployer (Located in ServerScriptService) // --
local RS = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Controllers = script.Parent:WaitForChild("Controllers")
local Services = script.Parent:WaitForChild("Services")

Controllers.Parent = RS
Services.Parent = ServerStorage

local Knit = require(RS.Packages.knit)

Knit.AddServices(Services)

Knit.Start():andThen(function()
    print("⚡ Knit Server successfully started via Deployer!")
end):catch(function(err)
    warn("❌ Knit Server failed to start: " .. tostring(err))
end)

script:Destroy()