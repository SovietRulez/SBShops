local src = source

QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, shopInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(target)
    local Player2 = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = shopInfo.name
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
            exports['ghmattimysql']:execute('UPDATE sbshops SET citizenid = @citizenid WHERE shopName = @shopName', {
                ['@citizenid'] = targetCID,
                ['@shopName'] = shopInfo.name
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
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = globalVar
    })
    if result[1] then
        if result[1].citizenid then
            exports.ghmattimysql:execute('UPDATE sbshops SET citizenid = NULL WHERE shopName=@shopName', {
                ['@shopName'] = globalVar
            }, function()
                TriggerClientEvent("QBCore:Notify", src, string.format("%s has been reposessed", globalVar), "success", 5000)
            end)
        else
            TriggerClientEvent("QBCore:Notify", src, string.format("%s could not be reposessed, beause it's not owned!", globalVar), "error", 5000)
        end
    end
end)

QBCore.Functions.CreateCallback('isOwner', function(source, cb, shopname)
    local src = source
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = exports.ghmattimysql:executeSync(
        'SELECT * FROM sbshops WHERE shopName=@shopName AND citizenid = @citizenid', {
            ['@shopName'] = shopname,
            ['@citizenid'] = cid
        })
    if result[1] then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('accountAmount', function(source, cb, shopInfo, amt)
    local src = source
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = exports.ghmattimysql:executeSync(
        'SELECT * FROM sbshops WHERE shopName=@shopName AND citizenid = @citizenid', {
            ['@shopName'] = shopInfo.name,
            ['@citizenid'] = cid
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
    local result = exports.ghmattimysql:executeSync(
        'SELECT * FROM sbshops WHERE shopName=@shopName AND citizenid = @citizenid', {
            ['@shopName'] = shopInfo.name,
            ['@citizenid'] = cid,
            ['@accountMoney'] = 0
        })
    if spotLoc < 2 then
        if result[1].accountMoney >= withdrawAmount then
            exports.ghmattimysql:execute(
                'UPDATE sbshops SET accountMoney = accountMoney - @withdrawAmount WHERE shopName=@shopName', {
                    ['@shopName'] = shopInfo.name,
                    ['@withdrawAmount'] = withdrawAmount
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

RegisterServerEvent('deposit')
AddEventHandler('deposit', function(depositAmount, shopInfo)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(shopInfo.locations.boss - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local money = Player.PlayerData.money['cash']
    local result = exports.ghmattimysql:executeSync(
        'SELECT * FROM sbshops WHERE shopName=@shopName AND citizenid = @citizenid', {
            ['@shopName'] = shopInfo.name,
            ['@citizenid'] = cid,
            ['@accountMoney'] = 0
        })
    if spotLoc < 2 then
        if result[1].accountMoney and money >= depositAmount then
            exports.ghmattimysql:execute('UPDATE sbshops SET accountMoney = accountMoney + @depositAmount WHERE shopName=@shopName', {
                    ['@shopName'] = shopInfo.name,
                    ['@depositAmount'] = depositAmount
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
AddEventHandler('test', function(purchaseAmount, shopInfo, passThis, priceToPass, passt)
    local src = source
    local plyLoc = GetEntityCoords(GetPlayerPed(src))
    local spotLoc = #(shopInfo.locations.boss - plyLoc)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local money = Player.PlayerData.money['cash']
    local moneyAmount = priceToPass * purchaseAmount
    local items = {}
    print(passt)
    table.insert(items, {
        name = passThis,
        amount = purchaseAmount,
        slot = passt,
    })
    local result = exports.ghmattimysql:executeSync(
        'SELECT * FROM sbshops WHERE shopName=@shopName AND citizenid = @citizenid', {
            ['@shopName'] = shopInfo.name,
            ['@citizenid'] = cid
            
        })
    if spotLoc < 2 then
        if result[1] and money >= moneyAmount then
            exports.ghmattimysql:execute('UPDATE sbshops SET items = @items WHERE shopName=@shopName', {
                    ['@shopName'] = shopInfo.name,
                    ['@items'] = json.encode(items)
                }, function()
                    TriggerClientEvent("QBCore:Notify", src, string.format("You have bought %s  %s worth $%s for store %s",purchaseAmount, passThis, moneyAmount, shopInfo.name), "success", 5000)
                    Player.Functions.RemoveMoney('cash', moneyAmount)
                end)
        else
            TriggerClientEvent("QBCore:Notify", src, string.format("You dont have that amount of bread holmes!"), "error", 5000)
        end
    else
        DropPlayer(src, "Cheaters are not welcome here")
    end
end)

