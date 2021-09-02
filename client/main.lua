local owned = true

function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local menu = MenuV:CreateMenu(false, 'Shop Management', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace')
local menu2 = MenuV:CreateMenu(false, 'Shop Account Information', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace2')
local menu3 = MenuV:CreateMenu(false, 'Shop Sale', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace3')
local menu_button = menu:AddButton({
    icon = '😃',
    label = 'Check Store Status',
    value = 0,
    description = 'Checks If Store Is Owned'
})
local menu_button3 = menu2:AddButton({
    icon = '😃',
    label = 'Repossess store',
    value = 0,
    description = 'Repo Current Store Location'
})
local menu_button4 = menu2:AddButton({
    icon = '😃',
    label = 'Check Account Funds',
    value = 0,
    description = 'Check Store Money'
})
local menu_button2 = menu3:AddButton({
    icon = '😃',
    label = 'Sell To Nearby Player',
    value = 0,
    description = 'Sells Current Location To Closest Player'
})

menu_button:On('select', function()
    print('2')
    TriggerServerEvent('check')
    print('1')
    QBCore.Functions.TriggerCallback('check', function(storeOwned)
        if storeOwned then
            MenuV:CloseMenu(menu)
            Citizen.Wait(500)
            MenuV:OpenMenu(menu2)
        else
            MenuV:CloseMenu(menu)
            Citizen.Wait(500)
            MenuV:OpenMenu(menu3)
        end
    end)
end)

RegisterNetEvent('SBShops:client:alert')
AddEventHandler('SBShops:client:alert', function(owned)
    if owned then
        QBCore.Functions.Notify("Store is Owned", 'error', 5000)
    else
        QBCore.Functions.Notify("Store is ready for purchase", 'success', 5000)
    end
end)

RegisterNetEvent('SBShops:client:shopItems')
AddEventHandler('SBShops:client:shopItems', function(parent, allowed)
    Config.Shops[parent]["allowedItems"] = allowed
end)

Citizen.CreateThread(function()
    if not Config.QBTarget then
        while true do
            Citizen.Wait(5)
            local InRange = false
            local player = PlayerPedId()
            local PlayerPos = GetEntityCoords(player)
            for parent, child in pairs(Config.Shops) do
                local dist = #(PlayerPos - child.location)
                if dist < 100 then
                    inRange = true
                    DrawText3D(child.location, "~g~" .. child.name)
                end
                if dist <= 2 and IsControlJustReleased(0, 38) then
                    MenuV:OpenMenu(menu)
                end
            end

        end

        if not InRange then
            Citizen.Wait(5000)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('SBShops:openMenuJob')
AddEventHandler('SBShops:openMenuJob', function(source)
    if QBCore.Functions.GetPlayerData().job.name == Config.Job then
        MenuV:OpenMenu(menu)
    else
        QBCore.Functions.Notify("You're not apart of " .. Config.Job, 'error', 5000)
    end
end)

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end
