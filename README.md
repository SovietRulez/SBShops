# SBShops
Player owned shop system
**FORKING IS NOT AUTHORIZED

You can create as many shops as you would like. You must have the name within config the same name as shopName in database.
This script is not authorized to be forked, re released as a modification, or sold.
You can PR this repo and I will actively check and test the PRs.


Thank you Kakarot for helping optimize.

If you like my work and want to support it you can buy me a kofi! https://ko-fi.com/sovietrulez
*Planned updates* 
I plan on bringing in weaponshops, and "blackmarket" locations(shops that wont show up on map. This is a planned update and I have yet to start it. Thank you

Put the config for qb-shops in replace of its current, Or comment out the vectors for the shops
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
end)
