--[[ COMFIGURATION ]]--

local aimbot = {
    settings = {
        enabled = true,
        teamcheck = true
    }
}

--[[ VARIABLES ]]--

local players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService")

local localplayer = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera

local holding = false

--[[ FUNCTIONS ]]--

local function GetClosestPlayerFromCursor()
    local closestdistance = math.huge
    local closestplayer = nil
    local mousepos = userinputservice.GetMouseLocation(userinputservice)

    for _, player in pairs(players.GetPlayers(players)) do
        if player ~= localplayer and player.Character then
            local humanoid = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                    local screenpos = camera:WorldToViewportPoint(head.Position)
                    local distance = (Vector2.new(screenpos.X, screenpos.Y) - mousepos).Magnitude
                    if aimbot.settings.teamcheck then
                        if player.Team ~= localplayer.Team then
                            if distance < closestdistance then
                                closestdistance = distance
                                closestplayer = player
                            end
                        end
                    else
                        if distance < closestdistance then
                            closestdistance = distance
                            closestplayer = player
                        end
                    end
                end
            end
        end
    end
    return closestplayer
end

userinputservice.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holding = true
    end
end)

userinputservice.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holding = false
    end
end)

runservice.RenderStepped:Connect(function()
    if (holding and aimbot.settings.enabled) then
        TweenService:Create(camera, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(camera.CFrame.Position, GetClosestPlayerFromCursor().Character.Head.Position)}):Play()
    end
end)
