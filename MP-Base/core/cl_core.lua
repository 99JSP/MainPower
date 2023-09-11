function MP.Base.Start(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent('MP-Base:Start')
                TriggerServerEvent('MP-Base:ServerStart')
                break
            end
        end
    end)
end
MP.Base.Start(self)

exports('GetObject', function()
    return MP
end)
-- local MP = exports['MP-Base']:GetObject()

-- ADMIN

exports('updateGroup', function(group)
	MP.PlayerData.UserGroups = group
end)
-- RegisterNetEvent("MP-Admin:updateGroup")
-- AddEventHandler("MP-Admin:updateGroup", function(group)
-- end)
