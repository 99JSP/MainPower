local DISCORD_WEBHOOK = ""
local DISCORD_ADMINWEBHOOK = ""
local STEAM_KEY = ""
local DISCORD_IMAGE = ""


AddEventHandler('chatMessage', function(source, name, message)
    if string.match(message, "@everyone") then 
        message = message:gsub("@everyone", "`@everyone`")
    end
    if string.match(message, "@here") then 
        message = message:gsub("@here", "`@here`")
    end

    if STEAM_KEY == '' or STEAM_KEY == nil then
		PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, tts = false}), { ['Content-Type'] = 'application/json' })
	else
		PerformHttpRequest('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. STEAM_KEY .. '&steamids=' .. tonumber(GetIDFromSource('steam', source), 16), function(err, text, headers)
			local image = string.match(text, '"avatarfull":"(.-)","')
			PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, avatar_url = image, tts = false}), { ['Content-Type'] = 'application/json' })
		end)
	end 
end)


function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

RegisterServerEvent('MP-Logs:Server:Send')
AddEventHandler('MP-Logs:Server:Send', function(log, name, message)
    exports['MP-Logs']:sendTODiscord(log,name,message,color)
end)

--  Exports ['MP-Logs']:sendTODiscord(log,name,message,color)

exports ("sendToDiscord", function(log, name, message,color)
    if log == "DISCORD_WEBHOOK" or "1" then 
        log = DISCORD_WEBHOOK
    end
    if log == nil then 
        log = DISCORD_ADMINWEBHOOK
    end
    local connect = {
        {
            ["color"] = color, 
            ["title"] = "**" .. name "**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(log, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end)