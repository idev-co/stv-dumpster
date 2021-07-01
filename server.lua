ESX = nil

--[[
    Chance = Lower is most likely
    ID = Item Name
    Name = Name of Item
    Quantity = amount you get from finding the item
    Limit = max you can get per item
]]

local dumpsterItems = { 
    [1] = {chance = 2, id = 'casiowatch', name = 'Casio Watch', quantity = math.random(1,3), limit = 10},
    [2] = {chance = 4, id = 'rubber', name = 'Rubber', quantity = math.random(1,4), limit = 15},
    [3] = {chance = 2, id = 'oldshoe', name = 'Old Shoe', quantity = 1, limit = 10},
    [4] = {chance = 2, id = 'cookie', name = 'Cookie', quantity = 2, limit = 10},
    [5] = {chance = 3, id = 'plastic', name = 'Plastic', quantity = math.random(1,8), limit = 0},
    [6] = {chance = 4, id = 'WEAPON_BAT', name = 'Baseball Bat', quantity = 1, limit = 2},
    [7] = {chance = 8, id = 'electronics', name = 'Electronics', quantity = math.random(1,2), limit = 0},
    [8] = {chance = 5, id = 'lowgradefemaleseed', name = 'Female Seed', quantity = 1, limit = 0},
    [9] = {chance = 5, id = 'lowgrademaleseed', name = 'Male Seed', quantity = 1, limit = 0},
    [10] = {chance = 2, id = 'battery', name = 'Battery', quantity = math.random(1,3), limit = 10},
    [11] = {chance = 4, id = 'phone', name = 'Phone', quantity = 1, limit = 0},
    [12] = {chance = 3, id = 'copper', name = 'Copper', quantity = math.random(1,3), limit = 0},
    [13] = {chance = 2, id = 'fishingrod', name = 'Fishing Rod', quantity = 1, limit = 10},
    [14] = {chance = 7, id = 'cartire', name = 'Car Tire', quantity = 1, limit = 4},
    [15] = {chance = 8, id = 'weddingring', name = 'Wedding Ring', quantity = 1, limit = 10},
    [16] = {chance = 7, id = 'advancedlockpick', name = 'Advanced Lockpick', quantity = 1, limit = 15},
    [17] = {chance = 2, id = 'burger', name = 'Burger', quantity = 1, limit = 10}
   }

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('stv:startDumpsterTimer')
AddEventHandler('stv:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('stv:giveDumpsterReward')
AddEventHandler('stv:giveDumpsterReward', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}


 for i=1, math.random(1, 2) do
  item = dumpsterItems[math.random(1, #dumpsterItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addMoney(item.quantity)
    --TriggerClientEvent('chatMessage', source, 'You found $'..item.quantity)
    --TriggerClientEvent('notification', source, 'You found $'..item.quantity)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You found $'..item.quantity, })
   elseif item.isWeapon and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addWeapon(item.id, 50)
    --TriggerClientEvent('chatMessage', source, 'You found a '..item.name)
    --TriggerClientEvent('notification', source, 'Item Added!', 2)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Item Added!', })
   elseif not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addInventoryItem(item.id, item.quantity)
    --TriggerClientEvent('chatMessage', source, 'You have found '..item.quantity..'x '..item.name)
    --TriggerClientEvent('notification', source, 'Item Added!', 2)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Item Added!', })
   end
  end
 end
end)

function startTimer(id, object)
    local timer = 10 * 60000

    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            TriggerClientEvent('stv:removeDumpster', id, object)
        end
    end
end



