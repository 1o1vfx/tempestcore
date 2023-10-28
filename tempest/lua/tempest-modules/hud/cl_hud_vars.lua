
local vars = {}
function Tempest.HUD.AddOption(name, default, on)
    name = "tempest_hud_" .. name
    vars[name] = CreateClientConVar(name, default, true, nil)

    cvars.AddChangeCallback(name, function(_,_,n)
        on(n)
    end )

    return vars[name]
end

Tempest.HUD.Alpha = tonumber(Tempest.HUD.AddOption("alpha", 250, function(n)
    Tempest.HUD.Alpha = tonumber(n or "255") or 255

    Tempest.HUD.MainPanel:SetAlpha(Tempest.HUD.Alpha)
    Tempest.HUD.AmmoPanel:SetAlpha(Tempest.HUD.Alpha)
end):GetInt() or 255) or 255

Tempest.HUD.Height = tonumber(Tempest.HUD.AddOption("height", 55, function(n)
    Tempest.HUD.Height = tonumber(n or "55") or 55

    Tempest.HUD.MainPanel:SetTall(Tempest.HUD.Height)

    print("HUD is now " .. math.floor((Tempest.HUD.Height / 1080) * 100) .. "% of your screen height")
end):GetInt() or 255) or 255

Tempest.HUD.NotifAlpha = tonumber(Tempest.HUD.AddOption("notification_alpha", 255, function(n)
    Tempest.HUD.NotifAlpha = tonumber(n or "255") or 255
end ) or 255) or 255
