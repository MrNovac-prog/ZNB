-- // Services // --
local spring = game:GetService("ReplicatedStorage").package.spring

-- // Helper Functions // --
local function Weld(VM, GunModel)
    assert(GunModel, "No Weapon Model Passed to Weld.")
    assert(VM, "No Viewmodel Found, Please Send Valid Viewmodel")

    if VM:FindFirstChild("RightArm"):FindFirstChildOfClass("Motor6D") then
        warn("Already Exsists, Creating new Weld")
        VM:FindFirstChild("RightArm"):FindFirstChildOfClass("Motor6D"):Destroy()
    end

    local New6D = Instance.new("Motor6D")
    New6D.Part0 = VM:FindFirstChild("RightArm")
    New6D.Part1 = GunModel.PrimaryPart
    New6D.Parent = VM:FindFirstChild("RightArm")

end

-- // Module Logic // --

local WeaponUtils = {}

-- // Initilisation Functions // --
function WeaponUtils:ViewmodelSetUp()
    local VmTemp = game:GetService("ReplicatedStorage").Storage:WaitForChild("VM")
    local Vm = VmTemp:Clone()

    Vm.Parent = workspace.CurrentCamera

    self.Viewmodel = Vm

    return Vm
end

function WeaponUtils:LoadWeapon(SelectedWeapon: string, VM: Model, WeaponType)
    assert(VM, "No Viewmodel Found, Please Send a Valid Viewmodel")

    if game:GetService("ReplicatedStorage").Storage.WeaponModels:FindFirstChild(WeaponType):FindFirstChild(SelectedWeapon) then
        print("Selected Weapon Found: ".. SelectedWeapon)

        local SelectedModel = game:GetService("ReplicatedStorage").Storage.WeaponModels:FindFirstChild(WeaponType):FindFirstChild(SelectedWeapon):Clone()
        
        if not SelectedModel then
            warn("Selected Weapon Could not be found")
            return
        end

        --// Switching Weapon Logic
        if VM:FindFirstChildOfClass("Model") then
            print("Switching Weapon")
        end

        --// Start Up Weapon Logic
        if not VM:FindFirstChildOfClass("Model") then
            print("Loading Up Weapon")

            SelectedModel.Parent = VM
            Weld(VM, SelectedModel)

            self.ActiveWeapon = SelectedModel
        end

    end    

end

-- // Core Functions // --

function WeaponUtils:RenderWeapon(VM: Model, Connection: string, player: Player)
    assert(VM, "No Viewmodel Passed for function.")
    
    self.RuSConnection = Connection
    self.Player = player

    local char = self.Player.Character or self.Player.CharacterAdded:Wait()
    
    -- // Debug 
    print("Player: ".. self.Player.Name .. " Character: ".. char.Name)
    print("RunService Connection Name: ".. self.RuSConnection .. " Current VM: ".. self.Viewmodel.Name)

    game:GetService("RunService"):BindToRenderStep(self.RuSConnection, Enum.RenderPriority.Camera.Value + 1, function(dt)
        local mouseDelta = game:GetService("UserInputService"):GetMouseDelta()


        VM:PivotTo(workspace.CurrentCamera.CFrame)

    end)
    
end

return WeaponUtils