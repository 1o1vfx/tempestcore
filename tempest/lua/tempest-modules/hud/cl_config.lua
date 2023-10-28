
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Configuration File

-- General Stuff
Tempest.HUD = Tempest.HUD or {}
Tempest.HUD.Config = Tempest.HUD.Config or {}

-- Colors
Tempest.HUD.Config.Colors = {
    General = Tempest.Colors.General,
    Main = {
        health      =       Color(190, 52, 36),
        armor       =       Color(0, 102, 192),
        money       =       Color(12, 116, 67),
        select      =       Color(16, 16, 16)
    },
    Player = {
        wanted      =       function()
            local sin = math.sin(CurTime() * 5) * 100
            return Color(190 + sin, 52 + sin, 36 + sin, 200)
        end
    },
    Dropdown = {
        background  =       Color(22, 22, 22, 254),
        shadow      =       Color(22, 22, 22)
    },
    Notifications = {
        background = ColorAlpha(Tempest.Colors.General.background, 253),
        types = {
            [NOTIFY_GENERIC]    = Color(255, 255, 255),
            [NOTIFY_ERROR]      = Color(190, 52, 36),
            [NOTIFY_UNDO]       = Color(12, 116, 67),
            [NOTIFY_HINT]       = Color(219, 206, 25),
            [NOTIFY_CLEANUP]    = Color(0, 102, 192),
        },

        yes = Color(12, 116, 67),
        no = Color(190, 52, 36),

        vote_color = function()
            local ctime = CurTime() * 255
            return HSVToColor(ctime % 360, 0.9, 0.9)
        end,

        icon_background = ColorAlpha(Tempest.DarkenColor(Tempest.Colors.General.background, .80), 253),
        select_bg       = ColorAlpha(Tempest.DarkenColor(Tempest.Colors.General.background, .90), 253)
    },
    DoorDisplay = {
        shadow          = Tempest.Colors.General.background,
        normal          = color_white,
        invalid         = Color(250, 91, 74)
    },
    -- Im too lazy to move stuff out of here, ill do it eventually
    F4 = {
        header      =       Color(35, 35, 35),
        job_item    =       Color(39, 39, 39),
        shadow      =       Color(32, 32, 32)
    }
}

-- Notifications
Tempest.HUD.Config.NotificationTypeIcons = {
    [NOTIFY_GENERIC]    = "jt7clkq",
    [NOTIFY_ERROR]      = "jt7clkq",
    [NOTIFY_UNDO]       = "jt7clkq",
    [NOTIFY_HINT]       = "jt7clkq",
    [NOTIFY_CLEANUP]    = "jt7clkq",
    [5]                 = "jt7clkq",
}

-- Materials
Tempest.HUD.Config.Materials = Tempest.Config.Materials

-- Special Ammo Text
Tempest.HUD.Config.SpecialAmmo = {}
Tempest.HUD.Config.SpecialAmmo["gmod_tool"] = function(self, wep)
    return LocalPlayer():GetCount("props") .. " props"
end
Tempest.HUD.Config.SpecialAmmo["weapon_physgun"] = Tempest.HUD.Config.SpecialAmmo["gmod_tool"]
Tempest.HUD.Config.SpecialAmmo["weapon_rpg"] = function(self, wep)
    return LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())
end
Tempest.HUD.Config.SpecialAmmo["weapon_frag"] = Tempest.HUD.Config.SpecialAmmo["weapon_rpg"]

Tempest.HUD.Config.SpecialAmmo["weapon_physcannon"] = function() return "" end
Tempest.HUD.Config.SpecialAmmo["weapon_bugbait"] = function() return "" end
