local Players = game:GetService("Players");
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = localPlayer.Character
local hrp = char.HumanoidRootPart
local MiddleScreenVector = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
local rs = game:GetService("RunService")
local DroppedItems, CurrentBuilds, MapFolder = game:GetService("Workspace").GroundWeapons, game:GetService("Workspace").BuildStuff, game:GetService("Workspace").Map
-- SETTINGS & TOGGLES

local Viewports = {
    Center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2),
    Bottom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1),
    Up = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 10)
}

-- ESP

_G.ESPEnabled = true
_G.TeamCheck = false
_G.ESPColor = Color3.fromRGB(255,255,255)
-- MainEsp

_G.ShowTracers = false
_G.TracerPos = Viewports.Up
_G.TracerThickness = 1

--ItemESP
_G.ItemESP = false
_G.ItemESPColor = Color3.fromRGB(0, 140, 255)


function ItemEspDisplay(item)
    local Text = Drawing.new("Text")
    Text.Center = true
    Text.Visible = false
    Text.Size = 15
    Text.Outline = true
    Text.Font = 2
    Text.Color = Color3.new(1,1,1)

    local render
    render = rs.RenderStepped:Connect(function()
        if item and DroppedItems:FindFirstChild(item.Name) and item:FindFirstChild("Center") then
            local itemvector, onScreen = camera:WorldToViewportPoint(item.Center.Position)
            if _G.ESPEnabled and _G.ItemESP then
                if onScreen then
                    Text.Position = Vector2.new(itemvector.X,itemvector.Y)
                    Text.Color = _G.ItemESPColor
                    Text.Visible = true
                    Text.Text = item.Name
                else
                    Text.Visible = false
                end
            else
                Text.Visible = false
            end
        else
            Text.Visible = false
        end
    end)
end

function AddLine(plr)
    local Line = Drawing.new("Line")
    Line.Visible = false
    local rend
    rend = rs.RenderStepped:Connect(function()
        if plr and plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChild("Humanoid").Health > 0 then
            local playervec, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if _G.ESPEnabled and _G.ShowTracers then
                if OnScreen then
                    if _G.TeamCheck and plr.TeamColor == localPlayer.TeamColor then
                        Line.Visible = false
                    else
                        Line.Visible = true
                        Line.Thickness = _G.TracerThickness
                        Line.Color = _G.ESPColor
                        Line.From = _G.TracerPos
                        Line.To = Vector2.new(playervec.X, playervec.Y)
                    end
                else
                    Line.Visible = false
                end
            else
                Line.Visible = false
            end
        else
            Line.Visible = false
        end
    end)
end

for _,v in pairs(Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        AddLine(v)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        AddLine(player)
    end
end)

for i,v in pairs(DroppedItems:GetChildren()) do
    if v:IsA("Model") then
        ItemEspDisplay(v)
    end
end
DroppedItems.ChildAdded:Connect(function(item)
    if item:IsA("Model") then
        ItemEspDisplay(item)
    end
end)
