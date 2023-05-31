-- Hunting Rifle Shooting

local hasHuntingRifle = false
local isFreeAiming = false
local function processScope(freeAiming)
    if not isFreeAiming and freeAiming then
        isFreeAiming = true
        SendNUIMessage({
            display = true,
        })
    elseif isFreeAiming and not freeAiming then
        isFreeAiming = false
        SendNUIMessage({
            display = false,
        })
    end
end

local blockShotActive = false
local function blockShooting()
    if blockShotActive then return end
    blockShotActive = true
    CreateThread(function()
        while hasHuntingRifle do
            local ply = PlayerId()
            local ped = PlayerPedId()
            local ent = nil
            local aiming, ent = GetEntityPlayerIsFreeAimingAt(ply)
            local freeAiming = IsPlayerFreeAiming(ply)
            processScope(freeAiming)
            local et = GetEntityType(ent)
            if not freeAiming
                or IsPedAPlayer(ent)
                or et == 2
                or (et == 1 and IsPedInAnyVehicle(ent))
            then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(ped, true)
            end
            Wait(0)
        end
        blockShotActive = false
        processScope(false)
    end)
end

CreateThread(function()
    local huntingRifleHash = `weapon_sniperrifle` -- -646649097

    while true do
        if GetSelectedPedWeapon(PlayerPedId()) == huntingRifleHash then
            hasHuntingRifle = true
            blockShooting()
        else
            hasHuntingRifle = false
        end
        Wait(1000)
    end
end)
