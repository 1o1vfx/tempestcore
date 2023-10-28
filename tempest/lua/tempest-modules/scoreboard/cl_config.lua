
Tempest.Scoreboard = Tempest.Scoreboard or {}
Tempest.Scoreboard.GetColor = Tempest.GetColor

Tempest.Scoreboard.Config = Tempest.Scoreboard.Config or {}
Tempest.Scoreboard.Config.Colors = {
    General = table.Merge({
        header      =       Color(35, 35, 35),
        job_item    =       Color(39, 39, 39),
    }, Tempest.Colors.General),

    PlayerLine = {
        PingHigh = Color(190, 52, 36),
        PingLow = Color(12, 116, 67)
    }
}

Tempest.Scoreboard.Config.Ranks = {
    ["superadmin"] = "superadmin"
}

Tempest.Scoreboard.Config.SpecialNames = {
    ["STEAM_0:1:24711728"] = function(x, y, pl)
        local curw = 0
        local n = pl:Nick()
        local ctime = CurTime()
        for i = 1,#n do
            local s = (ctime + (i * 2))
            local yy = y + math.sin(s * 6) * 2
            local col = HSVToColor(s * #n, 0.9, 0.9)
            local tw, th = draw.Text({
                text = n[i],
                pos = {x + curw, yy},
                font = Tempest.Font(45),
                yalign = 1,
                color = col
            })

            surface.SetDrawColor(col)
            surface.DrawRect(x + curw, yy + th / 4, tw, 2)

            curw = curw + tw
        end
    end
}