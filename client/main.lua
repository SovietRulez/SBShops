local seconds = 1000
local ShopItems = {}
local globalVar, shopData
local amt = 0
local menu = MenuV:CreateMenu(false, 'Shop Management', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv',
    'example_namespace')
local menu2 = MenuV:CreateMenu(false, 'Shop Account Information', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv',
    'example_namespace2')
local menu3 = MenuV:CreateMenu(false, 'Shop Sale', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv',
    'example_namespace3')

-- Account Info Menu
local repoButton = menu3:AddButton({
    icon = '😃',
    label = 'Repossess store',
    value = 0,
    description = 'Repo Current Store Location'
})

local checkFundsButton = menu2:AddButton({
    icon = '😃',
    label = 'placeholder2',
    value = 0,
    description = 'Check Store Money'
})
local withdrawButton = menu2:AddButton({
    icon = '😃',
    label = 'Withdraw Account Money',
    value = 0,
    description = 'Withdraw Money'
})

local depositButton = menu2:AddButton({
    icon = '😃',
    label = 'Deposit Money into Account',
    value = 0,
    description = 'Deposit Money'
})


-- Shop Sale Menu
local sellStoreButton = menu3:AddButton({
    icon = '😃',
    label = 'placeholder',
    value = 0,
    description = 'Sells Current Location To Closest Player'
})

withdrawButton:On('select', function()
    local src = source
    local shopInfo = Config.Shops[globalVar]
    local withdrawAmount = LocalInput('Withdrawal Amount', 255, '')
    if withdrawAmount ~= nil then
TriggerServerEvent('withdraw',tonumber(withdrawAmount), shopInfo)
        print(shopInfo, withdrawAmount)
    end
end)

depositButton:On('select', function()
    local src = source
    local shopInfo = Config.Shops[globalVar]
    local depositAmount = LocalInput('Deposit Amount', 255, '')
    if depositAmount ~= nil then
TriggerServerEvent('deposit',tonumber(depositAmount), shopInfo)
        print(shopInfo, withdrawAmount)
    end
end)

sellStoreButton:On('select', function()
    local target = 1 -- GetPlayerServerId(QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId())))
    local shopInfo = Config.Shops[globalVar]

    print(shopInfo.name, shopInfo.price)

    QBCore.Functions.TriggerCallback('sellShop', function(cb)

    end, target, shopInfo)
end)

checkFundsButton:On('select', function()
    local shopInfo = Config.Shops[globalVar]
    print(shopInfo)
    print(globalVar)
    QBCore.Functions.TriggerCallback('accountAmount', function(cb)

    end, shopInfo)
end)
repoButton:On('select', function()
    local shopInfo = Config.Shops[globalVar]
    QBCore.Functions.TriggerCallback('repoShop', function(cb)

    end, shopInfo.name, globalVar)
end)
------------------^^^^^^^^^^^^^Menu portion 

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
                    DrawText3D(shopData.locations[currentZone], "~g~ Boss Menu")
                    if IsControlJustReleased(1, 38) then
                        QBCore.Functions.TriggerCallback('isOwner', function(cb)
                            if cb then
                                globalVar = shopName
                                shopData = shopData
                                MenuV:OpenMenu(menu2, globalVar, amt)
                                checkFundsButton.Label = string.format('Check Account Balance')
                                print('you da boss')
                            else
                                print('you not the boss bro')
                                QBCore.Functions.Notify(string.format(
                                    "You must contact store owner or %s for assistance", Config.Job), 'error', 5000)
                            end
                        end, shopData.name)
                    end


                elseif currentZone == 'realEstate' and QBCore.Functions.GetPlayerData().job.name == Config.Job then
                    DrawText3D(shopData.locations[currentZone], "~g~" .. 'Realestate Options')
                    if IsControlJustReleased(1, 38) then
                        globalVar = shopName
                        shopData = shopData
                        MenuV:OpenMenu(menu3, globalVar)
                        sellStoreButton.Label = string.format('Sell Store to Player ($%s)', shopData.price)
                    end
                elseif currentZone == 'customer' then
                    DrawText3D(shopData.locations[currentZone], "~g~" .. 'Shop Here')
                    if IsControlJustReleased(1, 38) then
                        ShopItems.label = Config.Shops[shopName]["name"]
                        ShopItems.items = Config.Shops[shopName]["allowedItems"]
                        ShopItems.slots = 10
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_" .. shopName, ShopItems)
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
                        Robbery(shopName, shopData)
                        isBusy = false
                    end
                end
            end
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
function LocalInput(text, number, windows)
    AddTextEntry("FMMC_MPM_NA", text)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", windows or "", "", "", "", number or 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        return result
    end
end

function Robbery(shopName, shopData)
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
        coords = shopData.locations.robLocation
    }
    TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    Citizen.Wait(Config.RobTime * seconds)
    Cooldown(shopName)
end
function UpdateShop()
    QBCore.Functions.TriggerCallback('accountAmount', function(cb)
        menu_button5.Label = 'Shop Amount: $' .. comma_value(cb)
    end)
end
function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

function Cooldown(shopName, shopData)
    Citizen.CreateThread(function()
        isBusy = true
        Config.Shops[shopName].onC = true
        Wait(Config.Shops[shopName].cooldown * seconds)
        Config.Shops[shopName].onC = false
        isBusy = false
    end)
end
