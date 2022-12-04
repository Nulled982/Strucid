-- Updated 4/12/2022

local Players = game:GetService("Players");
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = localPlayer.Character
local hrp = char.HumanoidRootPart
local MiddleScreenVector = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
local rs = game:GetService("RunService")
local DroppedItems, CurrentBuilds, MapFolder = game:GetService("Workspace").GroundWeapons, game:GetService("Workspace").BuildStuff, game:GetService("Workspace").Map
local Settings = {
    ESP = {
        Enabled = true,
        TeamCheck = false,
        DrawLines = false,
        ItemEsp = true
    }
}

function ItemEspDisplay(item)
    local Text = Drawing.new("Text")
    Text.Center = true
    Text.Size = 15
    Text.Outline = true
    Text.Font = 2
    Text.Color = Color3.new(1,1,1)

    local render
    render = rs.RenderStepped:Connect(function()
        if item and DroppedItems:FindFirstChild(item.Name) and item:FindFirstChild("Center") then
            local itemvector, onScreen = camera:WorldToViewportPoint(item.Center.Position)

            if onScreen then
                Text.Position = Vector2.new(itemvector.X,itemvector.Y)
                Text.Visible = true
                Text.Text = item.Name
            else
                Text.Visible = false
            end
        else
            Text.Visible = false
            Text:Remove()
            render:Disconnect()
        end
    end)
end
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
