
-- makes sure the menu will open when called
RegisterNetEvent('MP-Spawn:openMenu')
AddEventHandler('MP-Spawn:openMenu', function()
    SetTimecycleModifier('hud_def_blur')
    SendNUIMessage({action = 'display'})
    SetNuiFocus(true, true)
end)

local spawns = {
    ['airport'] = vector3(-1037.74,-2738.04,20.1693),
    ['bus'] = vector3(451.37,-655.83,28.36),
    ['pink'] = vector3(324.16, -230.15, 54.22),
    ['harmony'] = vector3(1141.46, 2663.82, 38.16),
    ['dream'] = vector3(-96.313, 6324.45, 31.58)
}

RegisterNUICallback('spawn', function(data)
    local Spawn_Name = data.location
    print(Spawn_Name) -- delete later
    local Spawn_Location = spawns[Spawn_Name]
    print(Spawn_Location) -- delete later
    CameraPosition(Spawn_Location.x, Spawn_Location.y, Spawn_Location.z)
    local source = GetPlayerPed(-1)
    SetPlayerInvincible(source, false)
    FreezeEntityPosition(source, false)
end)

function CameraPosition(x,y,z)
    local pos = {x = x, y = y, z = z}
    SetEntityCoords(GetPlayerPed(-1), pos.x , pos.y, pos.z)
    DoScreenFadeIn(500)
    SetTimecycleModifier('default')
    SetNuiFocus(false, false)
    Wait(500)
    local cam_2 = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam_2, pos.x, pos.y, pos.z+200)
    SetCamActiveWithInterp(cam_2, cam, 900, true, true)
    Wait(900)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, pos.x, pos.y, pos.z+2)
    SetCamActiveWithInterp(cam, cam_2, 3700, true, true)
    Wait(3700)
    RenderScriptCams(false, true, 500, true, true) -- test with back 2 false
    FreezeEntityPosition(GetPlayerPed(-1), false)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(1000)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    DisplayHud(true)
    DisplayRadar(true)
end