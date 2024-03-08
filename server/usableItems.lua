---@diagnostic disable: param-type-mismatch
local Core = exports.vorp_core:GetCore()

exports.vorp_inventory:registerUsableItem("sanguinislupus", function(data) -- // Poção de força dos vampiros
    local _source = data.source
    local Character = Core.getUser(_source).getUsedCharacter 
    local UserGroup = Character.group --Returns user group (not character group)

    if UserGroup ~= 'vampire' then
        exports.vorp_inventory:subItem(_source, "sanguinislupus", 1, nil) -- // Remove Item do Inventario
        Core.NotifyRightTip(_source, "Sua aura de vampiro desperta e você se sente mais poderoso", 4000) -- // Notificação basica
        Character.setGroup("vampire")
    end

 end)

exports.vorp_inventory:registerUsableItem("hellwolf", function(data) -- // Poção de força dos vampiros
    local _source = data.source
    local User = Core.getUser(_source) 
    local UserGroup = User.getGroup --Returns user group (not character group)

    if UserGroup ~= 'vampire' then
        return false
    else
        exports.vorp_inventory:subItem(_source, "hellwolf", 1, nil) -- // Remove Item do Inventario
            
        TriggerClientEvent('byte:transform',_source)
            
            
    end

 end)


 
exports.vorp_inventory:registerUsableItem("transform_bear", function(data) -- // Poção de força dos vampiros
    local _source = data.source
    local User = Core.getUser(_source) 
    local UserGroup = User.getGroup --Returns user group (not character group)
    if UserGroup ~= 'vampire' then

        return false
    else
        exports.vorp_inventory:subItem(_source, "transform_bear", 1, nil) -- // Remove Item do Inventario
            
        TriggerClientEvent('byte:transformbat',_source)
            
            
    end

 end)
