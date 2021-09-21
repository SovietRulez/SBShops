local seconds = 1000
local ShopItems = {}
local globalVar, shopData, itemsAllowed, itemNames, itemSlot
local amt = 0
robberyTimer = 0
local player = PlayerPedId()
local playerPos = GetEntityCoords(player)
local isBusy = false
local menu = MenuV:CreateMenu(false, 'Shop Management', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv', 'space')
local menu2 = MenuV:CreateMenu(false, 'Shop Account Information', 'centerright', 255, 0, 0, 'size-125', 'test', 'menuv','space2')
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

-- local depositButton = menu2:AddButton({-----------------NOT USED CURRENTLY
--     icon = '😃',
--     label = 'Deposit Money into Account',
--     value = 0,
--     description = 'Deposit Money'
-- })
local orderButton = menu2:AddButton({
    icon = '😃',
    label = 'Order inventory',
    value = menu4,
    description = 'Order Shop Inventory'
})

local sellStoreButton = menu3:AddButton({
    icon = '😃',
    label = 'placeholder',
    value = 0,
    description = 'Sells Current Location To Closest Player'
})
local exit = menu3:AddButton({
    icon = '😃',
    label = 'Close Menu(Realestate ONLY)',
    value = 0,
    description = 'use this to close realestate menu!'
})

exit:On('select', function()
    MenuV:CloseMenu(menu3)
    isBusy = false
end)
withdrawButton:On('select', function()
    local src = source
    local shopInfo = Config.Shops[globalVar]
    local withdrawAmount = LocalInput('Withdrawal Amount', 255, '')
    if withdrawAmount ~= nil then
        TriggerServerEvent('withdraw', tonumber(withdrawAmount), shopInfo)
    end
end)

-- depositButton:On('select', function()
--     local src = source
--     local shopInfo = Config.Shops[globalVar]
--     local depositAmount = LocalInput('Deposit Amount', 255, '')
--     if depositAmount ~= nil then
--         TriggerServerEvent('deposit', tonumber(depositAmount), shopInfo)
--     end
-- end)

sellStoreButton:On('select', function()
    local target = GetPlayerServerId(QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId())))
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isBusy then
            DisableControlAction(0, 38, true)
        end
    end
end)

Citizen.CreateThread(function(label)
    TriggerServerEvent('soviet:server:getZones')
    if not Config.QBTarget then
        
        while true do
            sleep = 500
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            for shopName, shopData in pairs(Config.Shops) do
                for locationName, locationCoords in pairs(shopData.locations) do
                    local distance = #(playerPos - locationCoords)
                    if distance < 1.5 then
                        sleep = 5
                        currentZone = locationName
                        globalVar = shopName
                        shopData = shopData
                        if currentZone == 'boss' then
                            itemsAllowed = shopData.allowedItems
                            itemNames = itemsAllowed.name
                            DrawText3D(shopData.locations[currentZone], "~g~ Boss Menu")
                        elseif currentZone == 'realEstate' and QBCore.Functions.GetPlayerData().job.name == Config.Job then
                            DrawText3D(shopData.locations[currentZone], "~g~" .. 'Realestate Options')
                        elseif currentZone == 'customer' then
                            DrawText3D(shopData.locations[currentZone], string.format('~g~Shop here at %s', Config.Shops[globalVar].name))
                        elseif currentZone == 'robLocation' and not Config.Shops[globalVar].onC then
                                DrawText3D(shopData.locations[currentZone], "~r~ Rob store ~w~" .. shopData.name)
                            else
                                DrawText3D(shopData.locations[currentZone], "~r~ Store on cooldown")
                            end
                        end
                        if IsControlJustReleased(1, 38) and not isBusy then
                            isBusy = true
                            OpenMenu(currentZone)
                        end
                    end
                end
            Wait(sleep)
        end
    end
end)

function OpenMenu(currentZone)
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)
    if currentZone == 'boss' then
        isBusy = false
        QBCore.Functions.TriggerCallback('isOwner', function(cb)
            if cb then
                menu4:ClearItems()
                for i = 1, #itemsAllowed do
                    if itemsAllowed[i].name == itemsAllowed[i].name then
                        local orderingButton = menu4:AddButton({
                            icon = '😃',
                            label = string.format('Order %s $%s',
                                QBCore.Shared.Items[itemsAllowed[i].name].label, math.ceil(Config.PercentToSell/itemsAllowed[i].price)),
                            value = itemsAllowed[i].name,
                            description = string.format('Place order for %s',
                                QBCore.Shared.Items[itemsAllowed[i].name].label)
                        })
                        orderingButton:On('select', function()
                            local src = source
                            local shopInfo = Config.Shops[globalVar]
                            local pft = shopInfo.allowedItems[itemNames]
                            local passThis = itemsAllowed[i].name
                            local priceToPass = itemsAllowed[i].price
                            local asd = itemsAllowed[i].slot
                            local passt = Config.Shops[globalVar].allowedItems[asd].slot
                            local purchaseAmount = LocalInput('Purchase Amount', 255, '')
                            if purchaseAmount ~= nil then
                                MenuV:CloseMenu(menu4)
                                local sellPrice = LocalInput(
                                    string.format('%s price per unit', QBCore.Shared.Items[itemsAllowed[i].name].label), 255, '')
                                if sellPrice ~= nil then
                                    local ownerPrice = math.ceil(Config.PercentToSell/itemsAllowed[i].price)
                                    MenuV:CloseMenu(menu4)
                                    TriggerServerEvent('test', tonumber(purchaseAmount), shopInfo,
                                        passThis, priceToPass, passt, sellPrice, ownerPrice, purchaseAmount)
                                end
                            end
                        end)
                    end
                end
                MenuV:OpenMenu(menu2)
                checkFundsButton.Label = string.format('Check Account Balance')
            else
                QBCore.Functions.Notify(string.format("You must contact store owner or %s for assistance with %s", Config.Job, Config.Shops[globalVar].name), 'error', 5000)
            end
        end, Config.Shops[globalVar].name)
    elseif currentZone == 'realEstate' and isBusy then
        if QBCore.Functions.GetPlayerData().job.name == Config.Job then
                
            MenuV:OpenMenu(menu3, globalVar)
            sellStoreButton.Label = string.format('Sell Store to Player ($%s)', Config.Shops[globalVar].price)
        end
    elseif currentZone == 'customer' then
        isBusy = false
        QBCore.Functions.TriggerCallback('SBShops:GetShopInvData', function(cb)
            ShopItems.label = Config.Shops[globalVar].name
            ShopItems.items = cb
            ShopItems.slots = 20
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_" .. globalVar, ShopItems)
        end, Config.Shops[globalVar].name)
    elseif currentZone == 'robLocation' then
        if not Config.Shops[globalVar].onC then
            QBCore.Functions.TriggerCallback('soviet:server:getCops', function(cops)
                local distance = #(playerPos - Config.Shops[globalVar].locations.robLocation)
                if cops >= Config.CopsRequired then
                    if distance < 2 then
                    robberyTimer = Config.RobTime
                    Robbery(globalVar, shopData)
                    Citizen.Wait(robberyTimer)
                    TriggerServerEvent('robberyAmount', Config.Shops[globalVar])
                end
            end
            if cops < Config.CopsRequired then
            QBCore.Functions.Notify("Not enough cops", 'error', 5000)
            end
            end)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        robberyTimer = robberyTimer - 1
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if robberyTimer > 0 then
            DrawTxt(0.93, 1.44, 1.0, 1.0, 0.6,
                "Shop is being robbed for ~r~" .. math.ceil(robberyTimer) .. "~w~ more seconds", 255, 255, 255, 255)
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
    isBusy = false
end

function Robbery(globalVar, shopData)
    local data = {
        displayCode = '911',
        description = 'Robbery In Progress',
        isImportant = 1,
        recipientList = {'police'},
        length = '25000',
        infoM = 'fa-info-circle',
        info = 'Armed Suspects at attempting Robbery at ' .. Config.Shops[globalVar].name
    }
    local dispatchData = {
        dispatchData = data,
        caller = 'Alarm',
        coords = Config.Shops[globalVar].locations.robLocation
    }
    TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    Citizen.Wait(Config.RobTime * seconds)
    TriggerServerEvent('soviet:server:startCooldown', globalVar, shopData)
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

RegisterNetEvent('qb-shops:client:UpdateShop')
AddEventHandler('qb-shops:client:UpdateShop', function(shop, data, amount)
    TriggerServerEvent('qb-shops:server:UpdateShopItems', shop, data, amount)
end)

RegisterNetEvent('soviet:client:shopCooldown')
AddEventHandler('soviet:client:shopCooldown', function(shop, set)
  Config.Shops[shop].onC = set
end)
RegisterCommand("test", function(source, args, rawCommand)
TriggerEvent('qb-shops:client:UpdateShop')
end, false)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Shops) do
        local blip = AddBlipForCoord(v.locations.customer.x,v.locations.customer.y,v.locations.customer.z)
        SetBlipSprite(blip, 52)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip,19)
        SetBlipAsShortRange(blip,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
end)
