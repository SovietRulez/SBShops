local seconds = 1000

local menu = MenuV:CreateMenu(false, 'Shop Management', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace')
local menu2 = MenuV:CreateMenu(false, 'Shop Account Information', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace2')
local menu3 = MenuV:CreateMenu(false, 'Shop Sale', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'example_namespace3')

-- Management Menu
local statusButton = menu:AddButton({
    icon = '😃',
    label = 'Check Store Status',
    value = 0,
    description = 'Checks If Store Is Owned'
})

-- Account Info Menu
local repoButton = menu2:AddButton({
    icon = '😃',
    label = 'Repossess store',
    value = 0,
    description = 'Repo Current Store Location'
})
local checkFundsButton = menu2:AddButton({
    icon = '😃',
    label = 'Check Account Funds',
    value = 0,
    description = 'Check Store Money'
})

-- Shop Sale Menu
local sellStoreButton = menu3:AddButton({
    icon = '😃',
    label = 'Sell To Nearby Player',
    value = 0,
    description = 'Sells Current Location To Closest Player'
})

statusButton:On('select', function()
    TriggerServerEvent('check')
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
AddEventHandler('SBShops:client:shopItems', function(shop, allowed)
    Config.Shops[shop]["allowedItems"] = allowed
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isBusy then
            DisableControlAction(0, 38, true)
        end
    end
end)

local isInMarker, currentZone = false, nil
Citizen.CreateThread(function()
    if not Config.QBTarget then
        while true do
            Citizen.Wait(4)
            local isBusy = false
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            for shopName, shopData in pairs(Config.Shops) do
                local products = Config.Shops[shopName].allowedItems
                for locationName, locationCoords in pairs(shopData.locations) do
                    local distance = #(playerPos - locationCoords)
                    if not isInMarker and currentZone == nil then
                        if distance <= 1.5 then
                            currentZone = locationName
                            isInMarker = true
                        end
                    elseif isInMarker and currentZone == locationName then
                        if distance > 1.5 then
                            currentZone = nil
                            isInMarker = false
                        end
                    end
                end
                if currentZone == 'boss' then
                    DrawText3D(shopData.locations[currentZone], "~g~" .. shopData.name)
                    if IsControlJustReleased(1, 38) then
                        print('Hi Dad')
                    end
                elseif currentZone == 'realEstate' then
                    DrawText3D(shopData.locations[currentZone], "~g~" .. 'Realestate Options')
                    if IsControlJustReleased(1, 38) then
                        MenuV:OpenMenu(menu)
                        -- TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
                    end
                elseif currentZone == 'robLocation' then
                    if not shopData.onC then
                        DrawText3D(shopData.locations[currentZone], "~r~ Rob store ~w~" .. shopData.name)
                    else
                        DrawText3D(shopData.locations[currentZone], "~r~ Store on cooldown")
                    end
                    if IsControlJustReleased(1, 38) then
                        Config.Shops[shopName].robbed = true
                        print(shopName)
                        print(shopData)
                        print(shopData.allowedItems)
                        isBusy = true
                        local ShopItems = {}
                        ShopItems.label = Config.Shops[shopName]["name"]
                        ShopItems.items = Config.Shops[shopName]["allowedItems"]
                        ShopItems.slots = 30
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shopName, ShopItems)
                        -- MenuV:OpenMenu(menu)
                        local data = {
                            displayCode = '911',
                            description = 'Robbery In Progress',
                            isImportant = 1,
                            recipientList = {'police'},
                            length = '25000',
                            infoM = 'fa-info-circle',
                            info = 'Armed Suspects at attempting Robbery at ' .. shopName
                        }
                        local dispatchData = {
                            dispatchData = data,
                            caller = 'Alarm',
                            coords = shopData.robLocation
                        }
                        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
                        Robbery(shopName, shopData)
                        isBusy = false
                    end
                end
            end
        end
        Citizen.Wait(5)
    end
end)

function SetupItems(shop)
    local products = Config.Shops[shop].allowedItems
    local playerJob = QBCore.Functions.GetPlayerData().job.name
    local items = {}

    for i = 1, #products do
        --if not products[i].requiredJob then
            table.insert(items, products[i])
        --else
            --for i2 = 1, #products[i].requiredJob do
                --if playerJob == products[i].requiredJob[i2] then
                --    table.insert(items, products[i])
                --end
           -- end
        end
   -- end

    return items
end

RegisterNetEvent('SBShops:openMenuJob')
AddEventHandler('SBShops:openMenuJob', function(source)
    if QBCore.Functions.GetPlayerData().job.name == Config.Job then
        MenuV:OpenMenu(menu)
    else
        QBCore.Functions.Notify("You're not apart of " .. Config.Job, 'error', 5000)
    end
end)

function GetClosestPlayer() -- Soviet use this instead QBCore.Functions.GetClosestPlayer(coords)
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

function Robbery(shopName, shopData)
    -- print(Config.Shops[shopName].cooldown)
    Citizen.Wait(Config.RobTime * seconds)
    Cooldown(shopName)
end

function Cooldown(shopName, shopData)
    Citizen.CreateThread(function()
        -- print(shopName)
        isBusy = true
        Config.Shops[shopName].onC = true
        Wait(Config.Shops[shopName].cooldown * seconds)
        Config.Shops[shopName].onC = false
        isBusy = false
    end)
end