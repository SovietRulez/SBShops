local src = source

QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, shopInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(target)
    local Player2 = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports['oxmysql']:executeSync('SELECT * FROM sbshops WHERE shopName=:shopName', {
        ['shopName'] = shopInfo.name
    })
    if result[1] and Player.PlayerData.money.bank >= shopInfo.price then
        if not result[1].citizenid then
            local targetPed = QBCore.Functions.GetPlayerByCitizenId(targetPlayer.citizenid)
            local targetFn = targetPed.PlayerData.charinfo.firstname
            local targetLn = targetPed.PlayerData.charinfo.lastname
            Player.Functions.RemoveMoney('bank', shopInfo.price)
            TriggerEvent('qb-bossmenu:server:addAccountMoney', Config.Job, shopInfo.price)

            TriggerClientEvent("QBCore:Notify", src, string.format(
                shopInfo.name .. " has been sold to %s %s and money deposited with %s", targetFn, targetLn, Config.Job), "success", 5000)
            TriggerClientEvent("QBCore:Notify", target, "You now own the shop " .. shopInfo.name, "success", 5000)
            exports['oxmysql']:execute('UPDATE sbshops SET citizenid = :citizenid WHERE shopName = :shopName', {
                ['citizenid'] = targetCID,
                ['shopName'] = shopInfo.name
            })
        else
            local player = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
            local firstname = player.PlayerData.charinfo.firstname
            local lastname = player.PlayerData.charinfo.lastname
            TriggerClientEvent("QBCore:Notify", src, string.format("Shop owned by %s %s", firstname, lastname), "error", 5000)
        end
    elseif Player.PlayerData.money.bank < shopInfo.price then
        TriggerClientEvent("QBCore:Notify", src, string.format("Client is to broke to pay"), "error", 5000)
    end
end)

QBCore.Functions.CreateCallback('repoShop', function(source, cb, globalVar, shopInfo)
    local src = source
    local result = exports['oxmysql']:executeSync('SELECT * FROM sbshops WHERE shopName=:shopName', {
        ['shopName'] = globalVar
    })
    if result[1] then
        if result[1].citizenid then
            exports['oxmysql']:execute('UPDATE sbshops SET citizenid = NULL WHERE shopName=:shopName', {
                ['shopName'] = globalVar
            }, function()
                TriggerClientEvent("QBCore:Notify", src, string.format("%s has been reposessed", globalVar), "success", 5000)
            end)
        else
            TriggerClientEvent("QBCore:Notify", src, string.format("%s could not be reposessed, beause it's not owned!", globalVar), "error", 5000)
        end
    end
end)

QBCore.Functions.CreateCallback('isOwner', function(source, cb, shopName)
    local src = source
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    print(shopName, cid)
    local result = exports.oxmysql:scalarSync('SELECT 1 FROM sbshops WHERE shopname = ? AND citizenid = ?', {shopName, cid})
    print(result)

    if result then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('accountAmount', function(source, cb, shopInfo, amt)
    local src = source
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = exports['oxmysql']:executeSync(
        'SELECT * FROM sbshops WHERE shopName=:shopName AND citizenid = :citizenid', {
            ['shopName'] = shopInfo.name,
            ['citizenid'] = cid
        })
    local amt = result[1].accountMoney
    if result[1].accountMoney then
        TriggerClientEvent("QBCore:Notify", src, string.format("Shop money is $%s ", amt), "success", 5000)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('withdraw')
AddEventHandler('withdraw', function(withdrawAmount, shopInfo)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(shopInfo.locations.boss - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = exports['oxmysql']:executeSync(
        'SELECT * FROM sbshops WHERE shopName=:shopName AND citizenid = :citizenid', {
            ['shopName'] = shopInfo.name,
            ['citizenid'] = cid,
            ['accountMoney'] = 0
        })
    if spotLoc < 2 then
        if result[1].accountMoney >= withdrawAmount then
            exports['oxmysql']:execute(
                'UPDATE sbshops SET accountMoney = accountMoney - :withdrawAmount WHERE shopName=:shopName', {
                    ['shopName'] = shopInfo.name,
                    ['withdrawAmount'] = withdrawAmount
                }, function()
                    TriggerClientEvent("QBCore:Notify", src, string.format("%s has withdrawn %s", shopInfo.name, withdrawAmount), "success", 5000)
                    Player.Functions.AddMoney('bank', withdrawAmount)
                end)
        else
            TriggerClientEvent("QBCore:Notify", src, string.format("%s Doesnt have that kind of bread!", shopInfo.name), "error", 5000)
        end
    else
        DropPlayer(src, "Cheaters are not welcome here")
    end
end)
RegisterNetEvent('robberyAmount', function(globalVar)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(globalVar.locations.robLocation - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = exports['oxmysql']:executeSync(
        'SELECT * FROM sbshops WHERE shopName=:shopName AND citizenid = :citizenid', {
            ['shopName'] = globalVar.name,
            ['citizenid'] = cid,
            ['accountMoney'] = 0
        })
    if spotLoc < 2 then
        exports['oxmysql']:execute('UPDATE sbshops SET accountMoney = :acctMny WHERE shopName=:shopName', {
            ['shopName'] = globalVar.name,
            ['acctMny'] = result[1].accountMoney - result[1].accountMoney / Config.Percent
        }, function()
            local val = result[1].accountMoney / Config.Percent

            TriggerClientEvent("QBCore:Notify", src,
                string.format("You have taken %s dollars from %s", math.ceil(val), globalVar.name), "success", 5000)
            Player.Functions.AddMoney('cash', result[1].accountMoney / Config.Percent)
        end)
    end
end)


RegisterServerEvent('deposit')
AddEventHandler('deposit', function(depositAmount, shopInfo)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(shopInfo.locations.boss - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local money = Player.PlayerData.money['cash']
    local result = exports['oxmysql']:executeSync(
        'SELECT * FROM sbshops WHERE shopName=:shopName AND citizenid = :citizenid', {
            ['shopName'] = shopInfo.name,
            ['citizenid'] = cid,
            ['accountMoney'] = 0
        })
    if spotLoc < 2 then
        if result[1].accountMoney and money >= depositAmount then
            exports['oxmysql']:execute('UPDATE sbshops SET accountMoney = accountMoney + :depositAmount WHERE shopName=:shopName', {
                    ['shopName'] = shopInfo.name,
                    ['depositAmount'] = depositAmount
                }, function()
                    TriggerClientEvent("QBCore:Notify", src, string.format("You have deposited %s in %s store",depositAmount, shopInfo.name), "success", 5000)
                    Player.Functions.RemoveMoney('cash', depositAmount)
                end)
        else
            TriggerClientEvent("QBCore:Notify", src, string.format("You dont have that amount of bread holmes!"), "error", 5000)
        end
    else
        DropPlayer(src, "Cheaters are not welcome here")
    end
end)

RegisterServerEvent('test')
AddEventHandler('test', function(itemQuantity, shopName, itemName, itemPrice, slotID, sellPrice)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(shopName.locations.boss - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local money = Player.PlayerData.money['cash']
    local moneyAmount = itemPrice * itemQuantity
    local items = json.decode(exports['oxmysql']:scalarSync('SELECT items FROM sbshops WHERE shopName=:shopName AND citizenid = :citizenid', { ['shopName'] = shopName.name, ['citizenid'] = cid }))
    if not items then items = {} end
    if #items == 0 then
        table.insert(items, {
            name = itemName,
            amount = itemQuantity,
            slot = #items+1,
            price = sellPrice
        })
    else
        local result
        for k, v in pairs(items) do
            if v.name == itemName then
                result = true
                v.amount = v.amount + itemQuantity
                v.price = v.price
            end
        end
        if not result then
            table.insert(items, {
                name = itemName,
                amount = itemQuantity,
                slot = #items+1,
                price = sellPrice
            })
        end
    end

    exports['oxmysql']:execute('UPDATE sbshops SET items = :items WHERE shopName=:shopName', {
        ['shopName'] = shopName.name,
        ['items'] = json.encode(items)
    }, function()
        TriggerClientEvent("QBCore:Notify", src, string.format("You have bought %s %s worth $%s for store %s", itemQuantity, itemName, moneyAmount, shopName.name), "success", 5000)
        Player.Functions.RemoveMoney('cash', moneyAmount)
    end)
end)

QBCore.Functions.CreateCallback('SBShops:GetShopInvData', function(source, cb, shopName)
    local items = exports['oxmysql']:scalarSync('SELECT items FROM sbshops WHERE shopName=@shopName', { ['@shopName'] = shopName })
    cb(json.decode(items))
end)

RegisterServerEvent('qb-shops:server:UpdateShopItems')
AddEventHandler('qb-shops:server:UpdateShopItems', function(shop, data, amount)
  local result = exports['oxmysql']:executeSync(
  'SELECT * FROM sbshops WHERE shopName=:shopName', {
      ['shopName'] = Config.Shops[shop].name
  })
  local items = json.decode(result[1].items)
  local accMon = result[1].accountMoney
  for k,v in pairs(items) do
    if v.name == data.name then
      items[k].amount = items[k].amount - amount
      if (items[k].amount <= 0 or items[k].amount == 0.0) then
        table.remove(items, k)
        for g,f in pairs(items) do
          if f.slot > v.slot then items[g].slot = items[g].slot - 1 end
        end
      end
    end
  end
  exports['oxmysql']:execute('UPDATE sbshops SET items = :items, accountMoney = :acMon WHERE shopName=:shopName', {
      ['shopName'] = Config.Shops[shop].name,
      ['acMon'] = accMon+data.price*amount,
      ['items'] = json.encode(items)
  })
end)

Citizen.CreateThread(function()
  Wait(5000)
  local shops = exports['oxmysql']:executeSync('SELECT * FROM sbshops ', {})
  for i = 1,#shops do
    if shops[i].citizenid == nil or shops[i].citizenid == '' then
      local items = {}
      for k,v in pairs(Config.Shops) do
        if shops[i].shopName == v.name then
          for g,f in pairs(v.allowedItems) do
            table.insert(items, {name = f.name, amount = f.amount, price = f.price, slot = f.slot})
          end
        end
      end
      exports['oxmysql']:execute('UPDATE sbshops SET items = :items WHERE shopName=:shopName', {
          ['shopName'] = shops[i].shopName,
          ['items'] = json.encode(items)
      })
    end
  end
end)

QBCore.Functions.CreateCallback('soviet:server:getCops', function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)


RegisterServerEvent('soviet:server:startCooldown')
AddEventHandler('soviet:server:startCooldown', function(globalVar, shopData)
    print(Config.Shops[globalVar].name.onC)
    if not Config.Shops[globalVar].onC then
        Config.Shops[globalVar].onC = true
        Wait(Config.Shops[globalVar].cooldown * 1000)
        Config.Shops[globalVar].onC = false
    end
end)
