
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Handles configuration options

function Tempest:GetColor(name, m)
    if not self.Config or not self.Config.Colors then
        print("No Config Located - Send this to Melon: ```")
        _p(self)
        _p(debug.getinfo(2))
        print("```")
        return color_white
    end
    local c = self.Config.Colors[m or "General"][name]

    if isfunction(c) then
        c = c()
    end

    return c
end

function Tempest:GetMaterial(name)
    return self.Config.Materials[name]
end
