---@diagnostic disable: missing-parameter

local Core = exports.vorp_core:GetCore()
local isTransformed = false
local dayornight -- true for day / false for night.

function PerformRequest(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)
        Wait(100)
    end
end

function SetMonModel(hashName)
    local model = GetHashKey(hashName)
    local player = PlayerId()

    if not IsModelValid(model) then return end
    PerformRequest(model)

    if HasModelLoaded(model) then
        Citizen.InvokeNative(0xED40380076A31506, player, model, false)
        Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
        SetModelAsNoLongerNeeded(model)
    end
end

RegisterNetEvent('byte:playFX')
AddEventHandler('byte:playFX', function()
    Citizen.InvokeNative(0x4102732DF6B4005F, 'MP_BagReturnFriendly') -- AnimPlayFX
end)

RegisterNetEvent('byte:transform')
AddEventHandler('byte:transform', function()
    local Player = PlayerId()
    local new_ptfx_dictionary = "anm_blood"
    local new_ptfx_name = "ent_anim_mouth_hit_blood"
    local is_particle_effect_active = false
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name
    local current_ptfx_handle_id = false
    local ptfx_offcet_x = 0.0
    local ptfx_offcet_y = 0.0
    local ptfx_offcet_z = 0.0
    local ptfx_rot_x = -90.0
    local ptfx_rot_y = 0.0
    local ptfx_rot_z = 0.0
    local ptfx_scale = 5.0
    local ptfx_axis_x = 0
    local ptfx_axis_y = 0
    local ptfx_axis_z = 0

    if not dayornight then
        isTransformed = true
        TriggerEvent('byte:playFX')
        Core.NotifyLeftRank(Config.Notifications.Title, Config.Notifications.onTransform, "toast_awards_set_b",
            "awards_set_b_016", 4000, "COLOR_RED")


        if IsPedMale(PlayerPedId()) then
            SetMonModel('cs_vampire')
        else
            SetMonModel('cs_mp_jessica')
        end

        SetEntityHealth(PlayerPedId(), 600, 0)

        Citizen.CreateThread(function()
            while isTransformed do
                Wait(0)
                SetSuperJumpThisFrame(Player) -- Super Jump
                if IsPedDeadOrDying(PlayerPedId()) then
                    SetEntityHealth(PlayerPedId(), 600, 0)

                    if IsPedMale(PlayerPedId()) then
                        ExecuteCommand('rc')
                        break
                    else
                        ExecuteCommand('rc')
                        break
                    end
                end
            end
        end)

        Citizen.CreateThread(function() -- blood sp
            while true do
                Citizen.Wait(0)
                if not is_particle_effect_active then
                    current_ptfx_dictionary = new_ptfx_dictionary
                    current_ptfx_name = new_ptfx_name
                    if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then                         -- HasNamedPtfxAssetLoaded
                        Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))                                 -- RequestNamedPtfxAsset
                        local counter = 0
                        while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do -- while not HasNamedPtfxAssetLoaded
                            Citizen.Wait(0)
                        end
                    end
                    if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
                        Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary)                 -- UseParticleFxAsset


                        current_ptfx_handle_id = Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name,
                            PlayerPedId(), ptfx_offcet_x, ptfx_offcet_y, ptfx_offcet_z, ptfx_rot_x, ptfx_rot_y,
                            ptfx_rot_z, ptfx_scale, ptfx_axis_x, ptfx_axis_y, ptfx_axis_z) -- StartNetworkedParticleFxNonLoopedOnEntity
                        is_particle_effect_active = true
                    else
                        print("cant load ptfx dictionary!")
                    end
                else
                    if current_ptfx_handle_id then
                        if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then    -- DoesParticleFxLoopedExist
                            Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false) -- RemoveParticleFx
                        end
                    end
                    current_ptfx_handle_id = false
                    is_particle_effect_active = false

                    Wait(2000)
                    break
                end
            end
        end)
    else
        Core.NotifyLeftRank(Config.Notifications.Title, Config.Notifications.onFailForm, "toast_challenges_herbalist",
            "challenge_herbalist_8", 4000, "COLOR_SOCIAL_CLUB")
    end -- day ornight end
end)


RegisterNetEvent('byte:transformbat')
AddEventHandler('byte:transformbat', function()
    local Player = PlayerId()
    SetMonModel('A_C_Wolf')
    TriggerEvent('byte:playFX')

    Citizen.InvokeNative(0x9FF1E042FA597187, PlayerPedId(), 15, 1)
    Core.NotifyLeftRank(Config.Notifications.Title, "Hora do morcego", "toast_awards_set_b", "awards_set_b_016", 4000,
        "COLOR_RED")
    SetEntityHealth(PlayerPedId(), 600, 0)
end)




Citizen.CreateThread(function() -- Activates Passive effects on vampires // Super Strength, Night Vision,
    local Notified = false
    local NotifiedOff = true
    while true do
        Citizen.Wait(1000)
        local Group = LocalPlayer.state.Character.Group
        local PlayerCoordinates = GetEntityCoords(PlayerPedId())
        local Player = PlayerId()
        local Hours = GetClockHours()

        if Group == 'vampire' then
            if Hours >= 20 or Hours < 6 then                                                      -- enables vision at night
                Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), true)                        -- Eagle Eye: True
                Citizen.InvokeNative(0x7146CF430965927C, 'PERSONA_CONT_EAGLEEYE_ON_SPRINT', true) -- Eagle Eye Run
                Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 2000.0)                      -- SetPlayerMeleeWeaponDamageModifier
                dayornight = false
                if not Notified then                                                              -- Verifies bloodlust on notification
                    Core.NotifyLeftRank(Config.Notifications.Title, Config.Notifications.onEnable, "toast_awards_set_b",
                        "awards_set_b_016", 4000, "COLOR_RED")
                    Notified = true
                    NotifiedOff = false
                end
            elseif Hours >= 6 then
                Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), false) -- Eagle Eye: False
                Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 1.0)   -- SetPlayerMeleeWeaponDamageModifier
                Notified = false
                dayornight = true

                if isTransformed then    -- Check if player is transformed or not
                    isTransformed = false
                    ExecuteCommand('rc') -- Resets vampire form if it's
                end

                if not NotifiedOff then
                    Core.NotifyLeftRank(Config.Notifications.Title, Config.Notifications.onDisable, "toast_awards_set_b",
                        "awards_set_b_016", 4000, "COLOR_PURE_WHITE")
                    NotifiedOff = true
                end
            end
        end
    end
end)



Citizen.CreateThread(function() -- Burn player if is day
    local new_ptfx_dictionary = "des_moon1"
    local new_ptfx_name = "ent_ray_moon1_roof_fire"

    local is_particle_effect_active = false
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    local current_ptfx_handle_id = false

    local bone_index = 597 -- ["PH_Head"]  = {bone_index = 247, bone_id = 57278},

    local ptfx_offcet_x = 0.0
    local ptfx_offcet_y = 0.0
    local ptfx_offcet_z = 0.0
    local ptfx_rot_y = 0.0
    local ptfx_rot_z = 0.0
    local ptfx_scale = 1.0
    local ptfx_axis_x = 0
    local ptfx_axis_y = 0
    local ptfx_axis_z = 0


    while true do
        Citizen.Wait(1000)
        local Group = LocalPlayer.state.Character.Group
        if Group == 'vampire' then
            if not Citizen.InvokeNative(0xFB4891BD7578CDC1, PlayerPedId(), 0x9925C067) then
                if dayornight then
                    if not is_particle_effect_active then
                        current_ptfx_dictionary = new_ptfx_dictionary
                        current_ptfx_name = new_ptfx_name
                        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
                            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))     -- RequestNamedPtfxAsset
                            local counter = 0

                            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do -- while not HasNamedPtfxAssetLoaded
                                Citizen.Wait(0)
                            end
                        end
                        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
                            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary)             -- UseParticleFxAsset

                            current_ptfx_handle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_ptfx_name,
                                PlayerPedId(), ptfx_offcet_x, ptfx_offcet_y, ptfx_offcet_z, ptfx_rot_x, ptfx_rot_y,
                                ptfx_rot_z, bone_index, ptfx_scale, ptfx_axis_x, ptfx_axis_y, ptfx_axis_z) -- StartNetworkedParticleFxLoopedOnEntityBone

                            Citizen.InvokeNative(0x88786E76234F7054, current_ptfx_handle_id, 0.0)      -- alpha

                            is_particle_effect_active = true
                        else
                            print("cant load ptfx dictionary!")
                        end
                    end
                end
            else
                if is_particle_effect_active then
                    if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then -- DoesParticleFxLoopedExist
                        Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false) -- RemoveParticleFx
                    end
                end
                current_ptfx_handle_id = false
                is_particle_effect_active = false
            end
        end
    end
end)
