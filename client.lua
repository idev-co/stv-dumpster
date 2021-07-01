ESX = nil

local searched = {3423423424}
local canSearch = true
local dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
local searchTime = 0
local dumpsterTrigger = false
local ped = PlayerPedId()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)




Citizen.CreateThread(function()
    local dumspterModel = {
        218085040,
        666561306,
        -58485588,
        -206690185,
        1511880420,
        682791951,
    }

    exports['bt-target']:AddTargetModel(dumspterModel, {
        options = {
            {
                event = 'dumpsterTrigger',
                icon = 'fas fa-dumpster',
                label = 'Search Dumpster'
            },
        },
        job = {'all'},
        distance = 1.5
    })
end)

RegisterNetEvent('dumpsterTrigger')
AddEventHandler('dumpsterTrigger', function()
    dumpsterTrigger = true
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if canSearch then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dumpsterFound = false

            for i = 1, #dumpsters do
                local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                local dumpPos = GetEntityCoords(dumpster)

                if dumpsterTrigger == true then
                    for i = 1, #searched do
                        if searched[i] == dumpster then
                            dumpsterFound = true
                        end
                        if i == #searched and dumpsterFound then
                            exports['mythic_notify']:DoHudText('error', 'This dumpster has already been searched')
                            dumpsterTrigger = false
                        elseif i == #searched and not dumpsterFound then
                            exports['mythic_notify']:DoHudText('inform', 'You begin to search the dumpster')
                            startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base', 'stv:giveDumpsterReward')
                            TriggerServerEvent('stv:startDumpsterTimer', dumpster)
                            table.insert(searched, dumpster)
                            dumpsterTrigger = false
                        end
                    end
                end
            end
        end
    end
end)



RegisterNetEvent('stv:removeDumpster')
AddEventHandler('stv:removeDumpster', function(object)
    for i = 1, #searched do
        if searched[i] == object then
            table.remove(searched, i)
        end
    end
end)

-- Functions

function startSearching(time, dict, anim, cb)
    local animDict = dict
    local animation = anim
    local ped = PlayerPedId()

    canSearch = false

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    --exports['progressBars']:startUI(time, "Searching Dumpster") 
    exports['mythic_progbar']:Progress({
        name = "unique_action_name",
        duration = 30000,
        label = 'Searching Dumpster',
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
        },
    })
    Citizen.Wait(30000)
    DisableControlAction(0, 245) --309
    DisableControlAction(0, 309)
    local ped = PlayerPedId()

    Wait(time)
    ClearPedTasks(ped)
    canSearch = true
    TriggerServerEvent(cb)
end