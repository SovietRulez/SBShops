# SBShops
Player owned shop system

Go into qb-shops and edit line 1 server side event to

```lua
RegisterServerEvent('qb-shops:server:UpdateShopItems')
AddEventHandler('qb-shops:server:UpdateShopItems', function(shop, itemData, amount)
  if Config.Locations[shop] then
    if Config.Locations[shop]["products"] then
      if Config.Locations[shop]["products"][itemData.slot] then
        if Config.Locations[shop]["products"][itemData.slot].amount then
          Config.Locations[shop]["products"][itemData.slot].amount =  Config.Locations[shop]["products"][itemData.slot].amount - amount
          if Config.Locations[shop]["products"][itemData.slot].amount <= 0 then 
              Config.Locations[shop]["products"][itemData.slot].amount = 0
          end
          TriggerClientEvent('qb-shops:client:SetShopItems', -1, shop, Config.Locations[shop]["products"])
        end
      end
    end
  end
end)```
