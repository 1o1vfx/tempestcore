
-- Straight from darkrp with cool modifications
local function draw_door_info(door)
    if door:IsVehicle() then return false end

    local blocked = door:getKeysNonOwnable()
    local doorTeams = door:getKeysDoorTeams()
    local doorGroup = door:getKeysDoorGroup()
    local playerOwned = door:isKeysOwned() or (door:getKeysCoOwners() or {})[1] ~= nil
    local owned = playerOwned or doorGroup or doorTeams

    local doorInfo = {}

    local title = door:getKeysTitle()
    if title then table.insert(doorInfo, title) end

    if owned then
        table.insert(doorInfo, DarkRP.getPhrase("keys_owned_by"))
    end

    if playerOwned then
        if door:isKeysOwned() then table.insert(doorInfo, door:getDoorOwner():Nick()) end
        for k in pairs(door:getKeysCoOwners() or {}) do
            local ent = Player(k)
            if not IsValid(ent) or not ent:IsPlayer() then continue end
            table.insert(doorInfo, ent:Nick())
        end

        local allowedCoOwn = door:getKeysAllowedToOwn()
        if allowedCoOwn and not fn.Null(allowedCoOwn) then
            table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

            for k in pairs(allowedCoOwn) do
                local ent = Player(k)
                if not IsValid(ent) or not ent:IsPlayer() then continue end
                table.insert(doorInfo, ent:Nick())
            end
        end
    elseif doorGroup then
        table.insert(doorInfo, doorGroup)
    elseif doorTeams then
        for k, v in pairs(doorTeams) do
            if not v or not RPExtraTeams[k] then continue end

            table.insert(doorInfo, RPExtraTeams[k].name)
        end
    elseif blocked and changeDoorAccess then
        table.insert(doorInfo, DarkRP.getPhrase("keys_allow_ownership"))
    elseif not blocked then
        table.insert(doorInfo, DarkRP.getPhrase("keys_unowned"))
        if changeDoorAccess then
            table.insert(doorInfo, DarkRP.getPhrase("keys_disallow_ownership"))
        end
    end

    if door:IsVehicle() then
        local driver = door:GetDriver()
        if driver:IsPlayer() then
            table.insert(doorInfo, DarkRP.getPhrase("driver", driver:Nick()))
        end
    end

    local pos = door:LocalToWorld(door:OBBCenter()):ToScreen()
    local x = pos.x
    local y = pos.y
    local text = table.concat(doorInfo, "\n")
    draw.DrawNonParsedText(text, Tempest.Font(35, 9000), x + 1, y + 1, Tempest.HUD:GetColor("shadow", "DoorDisplay"), 1)
    draw.DrawNonParsedText(text, Tempest.Font(35, 9000), x + 2, y + 2, Tempest.HUD:GetColor("shadow", "DoorDisplay"), 1)
    draw.DrawNonParsedText(text, Tempest.Font(35, 9000), x, y, (blocked or owned) and Tempest.HUD:GetColor("normal", "DoorDisplay") or Tempest.HUD:GetColor("invalid", "DoorDisplay"), 1)

    return true
end

hook.Add("HUDDrawDoorData", "Tempest:DoorDisplay", draw_door_info)