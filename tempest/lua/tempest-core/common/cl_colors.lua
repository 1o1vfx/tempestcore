
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Handles color modifications, like Lerping and other stuff

function Tempest.LerpColor(amt, from, to)
    return Color(
        Lerp(amt, from.r, to.r),
        Lerp(amt, from.g, to.g),
        Lerp(amt, from.b, to.b)
    )
end

function Tempest.DarkenColor(col, amt)
    return Color(
        col.r * amt,
        col.g * amt,
        col.b * amt
    )
end

Tempest.OffsetColor = Tempest.DarkenColor