
Tempest.Colors = {
    General = {
        background  =       Color(20, 20, 20),
        accent      =       Color(95, 30, 199),
        accent2     =       Color(159, 30, 199),
        text        =       Color(255, 255, 255),
        text2       =       Color(170, 170, 170),
        bland       =       Color(55,55,55)
    }
}

Tempest.Config = Tempest.Config or {}
Tempest.Config.Materials = {
    Left = Material("vgui/gradient-l"),
    Right = Material("vgui/gradient-r"),
    Up = Material("vgui/gradient-u"),
    Down = Material("vgui/gradient-d"),
}

concommand.Add("femboys_r_hot", function()
    hook.Add("Think", "Femboys r hot", function()
        Tempest.Colors.General["accent"] = HSVToColor((CurTime() * 10) % 360, 0.9, 0.9)
        Tempest.Colors.General["accent2"] = HSVToColor(((CurTime() * 10) + 20) % 360, 0.9, 0.9)
        Tempest.HUD.Config.Colors.General = Tempest.Colors.General
    end)
end)