
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Hides Default HUD Elements that arent needed

hook.Add("HUDShouldDraw", "Tempest:HUD:Hide", function(n)
    if n == "DarkRP_HUD" or n == "CHudAmmo" or n == "CHudSecondaryAmmo" then
        return false
    end
end )