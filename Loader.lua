local Utils = loadstring(game:HttpGet(("https://raw.githubusercontent.com/yMajestyx/Project/main/CustomFuncs/AllUtils.lua")))();

shared.Config = {
    Main = {
        ["Auto Execute Sky Hub"] = false,
        ["Auto Rejoin If Kick"] = true,
        ["Anti-AFK"] = true,
    },
    Settings = {
        ["Auto Execute Delay"] = 5 -- Default
    },
    Credits = {
        ["Made By"] = "yMajest"
    },
}

getgenv().ScriptLoaded = false;

local function AntiAFK()
    pcall(function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local VirtualUser = game:GetService("VirtualUser")
        local Camera = workspace.CurrentCamera

        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
            VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
    end)
end


local function AutoLoad()
    Utils.Network:Notify("Auto Execute Sky Hub System", "Executed!", 15)
    Utils.Network:QueueOnTeleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/yMajestyx/Project/main/Loader.lua'))();");
end

spawn(function()
    while task.wait() do
        if shared.Config.Main["Auto Rejoin If Kick"] then
            shared.Config.Main["Auto Rejoin If Kick"] = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                    Utils.Network:Notify("Kick Detected", "Rejoining...", 5);
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
        end

        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            Utils.Network:Notify("ErrorMessageChanged", "Event detected. Rejoining...", 5);
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
        task.wait(1)
    end
end)

if shared.Config.Main["Auto Execute Sky Hub"] then
    if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
    while not game:GetService("RunService"):IsRunning() do task.wait() end
    repeat task.wait() until game:GetService("Players")
    task.wait(shared.Config.Settings["Auto Execute Delay"])

    AutoLoad()
end

spawn(function()
    warn("Made by: ".. shared.Config.Credits["Made By"])

    if getgenv().ScriptLoaded then task.wait(5) Utils.Network:Notify("System Made by", "yMajesty 💕", 10) end

    while task.wait(500) do
        if shared.Config.Main["Anti-AFK"] then

            AntiAFK()
        end
    end
end)

Utils.Network:Notify("System Loaded", "Welcome " ..game.Players.LocalPlayer.DisplayName.. '!', 5)
getgenv().ScriptLoaded = true;

-- Script Here --
loadstring(game:HttpGet('https://raw.githubusercontent.com/SKOIXLL/RIVERHUB-SKYHUB/main/WL.lua'))();
