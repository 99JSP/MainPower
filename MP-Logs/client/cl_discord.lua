Citizen.CreateThread(function()
    while true do
        SetDiscordAppId(MP.Discord.idBot)
        SetDiscordRichPresenceAsset(MP.Discord.AssetImage)
        SetDiscordRichPresenceAssetText(MP.Discord.AssetText)
        SetDiscordRichPresenceAssetSmall(MP.Discord.SmallAssetImg)
        SetDiscordRichPresenceAssetSmallText(MP.Discord.SmallAssetText)
        if MP.Discord.ButtonActive then 
            SetDiscordRichPresenceAction(0, MP.Discord.ActionButtonName1, MP.Discord.AssetDescriptionName1)
        end
        Wait(MP.Discord.Wait)
    end
end)


-- exports['MP-Logs']:sendTODiscord(log,name,message,color)

exports('sendToDiscord', function(log, name, message,color)
    TriggerServerEvent('MP-Logs:Server:Send', log, name, message,color)
end)