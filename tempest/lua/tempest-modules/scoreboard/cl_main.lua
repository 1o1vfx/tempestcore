
Tempest.Scoreboard = Tempest.Scoreboard or {}
function Tempest.Scoreboard.Generate()
    Tempest.HUD:CreateDropdownModule("scoreboard", "Tempest:Scoreboard")
end

hook.Add("Tempest:ModuleDone", "Tempest:Scoreboard", function(f)
    if f ~= "hud" then return end
    Tempest.Scoreboard.Generate()
end )

if Tempest.HUD then
    Tempest.Scoreboard.Generate()
end

hook.Add("PostGamemodeLoaded", "Tempest:ScoreboardInit", function()
    hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    hook.Remove("ScoreboardShow", "FAdmin_scoreboard")

    hook.Add("ScoreboardShow", "Tempest:ScoreboardShow", function()
        Tempest.HUD:Open("scoreboard")
    end )

    hook.Add("ScoreboardHide", "Tempest:ScoreboardHide", function()
        Tempest.HUD:Close()
    end )

    function GAMEMODE:ScoreboardShow()
    end

    function GAMEMODE:ScoreboardHide()
    end
end )

if Tempest.DevMode and GAMEMODE then
    hook.GetTable()["PostGamemodeLoaded"]["Tempest:ScoreboardInit"]()
end
