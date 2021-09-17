local seconds = 1000
local ShopItems = {}
local globalVar, shopData, itemsAllowed, itemNames, itemSlot
local amt = 0
deathTime = 0
local isBusy = false
local menu = MenuV:CreateMenu(false, 'Shop Management', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'space')
local menu2 = MenuV:CreateMenu(false, 'Shop Account Information', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv',
    'space2')
local menu3 = MenuV:CreateMenu(false, 'Shop Sale', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'space3')
local menu4 = MenuV:CreateMenu(false, 'Shop Ordering', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'space4')

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
local orderButton = menu2:AddButton({
    icon = '😃',
    label = 'Order inventory',
    value = menu4,
    description = 'Order Shop Inventory'
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
        TriggerServerEvent('withdraw', tonumber(withdrawAmount), shopInfo)
    end
end)

depositButton:On('select', function()
    local src = source
    local shopInfo = Config.Shops[globalVar]
    local depositAmount = LocalInput('Deposit Amount', 255, '')
    if depositAmount ~= nil then
        TriggerServerEvent('deposit', tonumber(depositAmount), shopInfo)
    end
end)

sellStoreButton:On('select', function()
    local target = 2 -- GetPlayerServerId(QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId())))
    local shopInfo = Config.Shops[globalVar]

    QBCore.Functions.TriggerCallback('sellShop', function(cb)

    end, target, shopInfo)
end)

checkFundsButton:On('select', function()
    local shopInfo = Config.Shops[globalVar]
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
        Citizen.Wait(1000)
        if isBusy then
            DisableControlAction(0, 38, true)
        end
    end
end)

local isInMarker, currentZone, sleep = false, nil, false
Citizen.CreateThread(function(label)
    if not Config.QBTarget then
        while true do
            Citizen.Wait(5)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            for shopName, shopData in pairs(Config.Shops) do
                for locationName, locationCoords in pairs(shopData.locations) do
                    local distance = #(playerPos - locationCoords)
                    if not isInMarker and currentZone == nil then
                        if distance <= 1.5 then
                            currentZone = locationName
                            isInMarker = true
                            sleep = false
                        end
                    elseif isInMarker and currentZone == locationName then
                        if distance > 1.5 then
                            currentZone = nil
                            isInMarker = false
                            sleep = true
                        end

                    end
                end
                if currentZone == 'boss' then
                    DrawText3D(shopData.locations[currentZone], "~g~ Boss Menu")
                    if IsControlJustReleased(1, 38) then
                        QBCore.Functions.TriggerCallback('isOwner', function(cb)
                            if cb then
                                menu4:ClearItems()
                                -- menu2:ClearItems()
                                globalVar = shopName
                                shopData = shopData
                                itemsAllowed = shopData.allowedItems
                                itemNames = itemsAllowed.name
                                for i = 1, #itemsAllowed do
                                    if itemsAllowed[i].name == itemsAllowed[i].name then
                                        local orderingButton = menu4:AddButton({
                                            icon = '😃',
                                            label = string.format('Order %s $%s',
                                                QBCore.Shared.Items[itemsAllowed[i].name].label, itemsAllowed[i].price),
                                            value = itemsAllowed[i].name,
                                            description = string.format('Place order for %s',
                                                QBCore.Shared.Items[itemsAllowed[i].name].label)
                                        })
                                        orderingButton:On('select', function()
                                            local src = source
                                            local shopInfo = Config.Shops[globalVar]
                                            -- local glob = globalVar.allowedItems
                                            local pft = shopInfo.allowedItems[itemNames]
                                            local passThis = itemsAllowed[i].name
                                            local priceToPass = itemsAllowed[i].price
                                            local asd = itemsAllowed[i].slot
                                            local passt = Config.Shops[globalVar].allowedItems[asd].slot
                                            local purchaseAmount = LocalInput('Purchase Amount', 255, '')
                                            if purchaseAmount ~= nil then
                                                MenuV:CloseMenu(menu4)
                                                local sellPrice = LocalInput(
                                                    string.format('%s price per unit', passThis), 255, '')
                                                if sellPrice ~= nil then
                                                    MenuV:CloseMenu(menu4)
                                                    print(json.encode(Config.Shops[globalVar].allowedItems[asd].slot))
                                                    TriggerServerEvent('test', tonumber(purchaseAmount), shopInfo,
                                                        passThis, priceToPass, passt, sellPrice)
                                                end
                                            end
                                        end)
                                    end
                                end
                                MenuV:OpenMenu(menu2)
                                checkFundsButton.Label = string.format('Check Account Balance')
                            else
                                QBCore.Functions.Notify(string.format(
                                    "You must contact store owner or %s for assistance", Config.Job), 'error', 5000)
                            end
                        end, shopData.name)
                    end
                elseif currentZone == 'realEstate' then
                    if QBCore.Functions.GetPlayerData().job.name == Config.Job then
                        DrawText3D(shopData.locations[currentZone], "~g~" .. 'Realestate Options')

                        if IsControlJustReleased(1, 38) then

                            globalVar = shopName
                            shopData = shopData
                            MenuV:OpenMenu(menu3, globalVar)
                            sellStoreButton.Label = string.format('Sell Store to Player ($%s)', shopData.price)
                        end
                    end
                elseif currentZone == 'customer' then
                    DrawText3D(shopData.locations[currentZone], "~g~" .. 'Shop Here')
                    if IsControlJustReleased(1, 38) then
                        QBCore.Functions.TriggerCallback('SBShops:GetShopInvData', function(cb)
                            ShopItems.label = Config.Shops[shopName].name
                            ShopItems.items = cb
                            ShopItems.slots = 10
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_" .. shopName,
                                ShopItems, shopData)
                        end, Config.Shops[shopName].name)
                    end
                elseif currentZone == 'robLocation' then
                    if not shopData.onC and not robbed then
                        DrawText3D(shopData.locations[currentZone], "~r~ Rob store ~w~" .. shopData.name)
                    else
                        DrawText3D(shopData.locations[currentZone], "~r~ Store on cooldown")
                    end
                    if IsControlJustReleased(1, 38) and not shopData.onC then
                        QBCore.Functions.TriggerCallback('soviet:server:getCops', function(cops)
                            if cops >= Config.CopsRequired then
                                Config.Shops[shopName].robbed = true

                                deathTime = Config.RobTime
                                Robbery(shopName, shopData)
                                Citizen.Wait(deathTime)
                                TriggerServerEvent('robberyAmount', shopData)
                                isBusy = false
                            end
                            if cops < Config.CopsRequired then
                                QBCore.Functions.Notify("Not enough cops", 'error', 5000)
                            end
                        end)
                    end
                end
            end
        end
        if sleep then
            Citzen.Wait(2000)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        deathTime = deathTime - 1
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if deathTime > 0 then
            DrawTxt(0.93, 1.44, 1.0, 1.0, 0.6,
                "Shop is being robbed for ~r~" .. math.ceil(deathTime) .. "~w~ more seconds", 255, 255, 255, 255)
        end
    end
end)

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
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
    isBusy = false
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
        -- isBusy = true
        Config.Shops[shopName].onC = true
        Wait(Config.Shops[shopName].cooldown * seconds)
        Config.Shops[shopName].onC = false
        -- isBusy = false
    end)
end

RegisterNetEvent('qb-shops:client:UpdateShop')
AddEventHandler('qb-shops:client:UpdateShop', function(shop, data, amount)
    TriggerServerEvent('qb-shops:server:UpdateShopItems', shop, data, amount)
end)
