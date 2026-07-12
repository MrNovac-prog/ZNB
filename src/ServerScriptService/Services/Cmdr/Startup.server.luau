-- // Services // --
local RS = game:GetService("ReplicatedStorage")

-- // Modules // --
local Cmdr = require(RS.Modules.Utils.Lib.Cmdr)

-- // Variables // --
local Commands = script.Parent.Commands
local Hooks = script.Parent.Hooks
local Types = script.Parent.Types

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(Commands)
Cmdr:RegisterTypesIn(Types)
Cmdr:RegisterHooksIn(Hooks)