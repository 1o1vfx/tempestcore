
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Player and Entity Display

local th = Tempest.HUD

-- Shadow Draw Text
local function drawtxt(txt)
    draw.Text({
        text = txt.text,
        pos = {txt.pos[1] + 1, txt.pos[2] + 1},
        xalign = txt.xalign,
        font = txt.font,
        color = th:GetColor("background")
    })
    draw.Text({
        text = txt.text,
        pos = {txt.pos[1] + 2, txt.pos[2] + 2},
        xalign = txt.xalign,
        font = txt.font,
        color = th:GetColor("background")
    })
    return draw.Text(txt)
end

-- Overrides
hook.Add("PostGamemodeLoaded", "Tempest:HUD:Overrides", function()
    local ply = FindMetaTable("Player")

    function ply:drawPlayerInfo()
        local pos = self:EyePos()
        local hh = th.Scale(85)
        pos.z = pos.z + 10
        pos = pos:ToScreen()
        local _, nh = drawtxt({
            text = self:Nick(),
            pos = {pos.x, pos.y - hh},
            xalign = 1,
            font = th.Font(40)
        })
        draw.Text({
            text = self:getDarkRPVar("job"),
            pos = {pos.x, pos.y - hh + nh},
            xalign = 1,
            font = th.Font(35),
            color = (self:getJobTable() or {color = color_white}).color
        })

        if self:getDarkRPVar("wanted") then
            local _, _nhp = drawtxt({
                text = "Wanted",
                pos = {pos.x, pos.y - hh - nh},
                font = th.Font(55),
                xalign = 1,
                color = th:GetColor("wanted", "Player")
            })
            nh = nh + _nhp
        end
    end
    function ply:drawWantedInfo()
    end
end )

if GAMEMODE then
  hook.GetTable()["PostGamemodeLoaded"]["Tempest:HUD:Overrides"]()
end