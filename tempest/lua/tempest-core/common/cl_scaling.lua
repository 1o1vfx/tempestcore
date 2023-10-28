
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Scaling and font functions

function Tempest.Scale(v)
    return v * (ScrH() / 1080)
end

local fonts = {}
function Tempest.Font(size)
    if fonts[size] then
        return fonts[size]
    end

    surface.CreateFont("Tempest:" .. size, {
        font = "Poppins",
        size = Tempest.Scale(size)
    })

    fonts[size] = "Tempest:" .. size

    return fonts[size]
end

hook.Add("OnScreenSizeChanged", "Tempest:Fonts", function()
    fonts = {}
end )