-- // Services // --
local Packages = game:GetService("ReplicatedStorage").Packages
local AdvancedSpring = require(Packages.advancedspring)
local BridgeNet = require(Packages.bridgenet2)

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
    
    local Sway = AdvancedSpring.new(Vector3.zero)
    local Bob = AdvancedSpring.new(Vector3.zero)

    local BobTick = 0

    local LastYVelocity = 0
    local WasFreeFalling = false

    self.RuSConnection = Connection
    self.Player = player

    local char = self.Player.Character or self.Player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    -- // Debug 
    print("Player: ".. self.Player.Name .. " Character: ".. char.Name)
    print("RunService Connection Name: ".. self.RuSConnection .. " Current VM: ".. self.Viewmodel.Name)

    game:GetService("RunService"):BindToRenderStep(self.RuSConnection, Enum.RenderPriority.Camera.Value + 1, function(dt)

        if char:FindFirstChild("HumanoidRootPart") and hum then
            local currentVelocity = char:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity
            local state = hum:GetState()

            if state == Enum.HumanoidStateType.Jumping and not WasFreeFalling then
                local shockVector = Vector3.new(0, -0.4, 3)
                Bob:Set(Bob:Get() + shockVector)
                WasFreeFalling = true
            end

            if state == Enum.HumanoidStateType.Freefall then
                WasFreeFalling = true
                LastYVelocity = currentVelocity.Y 
            end

            if WasFreeFalling and state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
                WasFreeFalling = false
                
                local impactForce = math.abs(LastYVelocity)
                
                if impactForce > 5 then 
                    local sagAmount = math.clamp(impactForce / 80, 0.1, 0.7)
                    local twistAmount = math.clamp(impactForce / 10, 2, 12) 
                    
                    local activePosition = Bob:Get()
                    
                    Bob:Set(Vector3.new(
                        activePosition.X, 
                        activePosition.Y - sagAmount, 
                        activePosition.Z - twistAmount
                    ))
                end
                
                self.LastYVelocity = 0
            end
        end

        -- // Sway Logic
        local mouseDelta = game:GetService("UserInputService"):GetMouseDelta()

        local targetSwayX = mouseDelta.X / 120
        local targetSwayY = mouseDelta.Y / 120

        Sway:Set(Vector3.new(targetSwayX, targetSwayY, 0))
        Sway:Step(dt)

        local currentSway = Sway:Get()

        -- // Bob Logic
        local bobX, bobY, bobZ = 0, 0, 0

        if hum and hum.MoveDirection.Magnitude > 0 and not WasFreeFalling then
            local speedMultiplier = hum.WalkSpeed

            BobTick = BobTick + (dt * speedMultiplier)

            bobX = math.sin(BobTick * 0.5) * 0.14
            bobY = math.cos(BobTick) * 0.09
            bobZ = math.sin(BobTick * 0.5) * 2.5
        else
            BobTick = BobTick + dt

            if WasFreeFalling and char:FindFirstChild("HumanoidRootPart") then
                local fallVelocity = char:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity.Y
                bobX = 0
                bobY = math.clamp(-fallVelocity / 120, -0.15, 0.15) 
                bobZ = math.clamp(fallVelocity / 40, -3, 3)
            else
                bobX = math.sin(BobTick * 1.5) * 0.015
                bobY = math.cos(BobTick * 3.0) * 0.008
                bobZ = math.sin(BobTick * 1.5) * 0.15
            end

        end

        Bob:Set(Vector3.new(bobX, bobY, bobZ))
        Bob:Step(dt)

        local currentBob = Bob:Get()

        -- // Offsets
        local swayCFrame = CFrame.new(-currentSway.X * 0.25, currentSway.Y * 0.25, 0) * CFrame.Angles(math.rad(currentSway.Y * 8), math.rad(currentSway.X * 8), 0)
        local bobCFrame = CFrame.new(currentBob.X, currentBob.Y, 0)

        VM:PivotTo(workspace.CurrentCamera.CFrame * swayCFrame * bobCFrame)

    end)
    
end

return WeaponUtils