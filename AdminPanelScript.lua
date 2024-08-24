-- Admin Panel Script
-- Place this script in ServerScriptService in Roblox Studio

-- List of admin usernames (case-sensitive)
local Admins = {"AdminUsername1", "AdminUsername2"}

-- Check if a player is an admin
local function isAdmin(player)
    for _, admin in pairs(Admins) do
        if player.Name == admin then
            return true
        end
    end
    return false
end

-- Handle player chat commands
local function onPlayerChatted(player, message)
    if not isAdmin(player) then
        return
    end

    local command, targetName = message:match("^(%S+)%s?(.*)$")

    if command == "!kick" and targetName ~= "" then
        local targetPlayer = game.Players:FindFirstChild(targetName)
        if targetPlayer then
            targetPlayer:Kick("You have been kicked by an admin.")
            print("Player " .. targetName .. " has been kicked by " .. player.Name)
        else
            player:SendNotification({Title = "Kick Failed", Text = "Player " .. targetName .. " not found."})
        end
    elseif command == "!shutdown" then
        if isAdmin(player) then
            game:Shutdown()
            print("Game is shutting down initiated by " .. player.Name)
        end
    else
        player:SendNotification({Title = "Command Error", Text = "Invalid command or insufficient permissions."})
    end
end

-- Connect chat events for all players
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)
