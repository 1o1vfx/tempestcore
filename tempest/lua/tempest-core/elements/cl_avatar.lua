
-- Taken from PIXELUI
-- https://github.com/TomDotBat/pixel-ui/blob/master/lua/pixelui/elements/cl_avatar.lua 
-- <3 Tom

local PANEL = {}

AccessorFunc(PANEL, "MaskSize", "MaskSize", FORCE_NUMBER)

function PANEL:PerformLayout(w, h)
    self.CirclePoly = {}

    local t = 0
    for i = 1, 360 do
        t = math.rad(i * 720) / 720
        self.CirclePoly[i] = {x = w / 2 + math.cos(t) * h / 2, y = h / 2 + math.sin(t) * h / 2}
    end
end

function PANEL:SetPlayer(ply, size)
    self.steamid = ply:SteamID64()
end

function PANEL:SetSteamID(id, size)
    self.steamid = util.SteamIDTo64(id)
end

function PANEL:SetSteamID64(id)
    self.steamid = id
end

local render = render
local surface = surface
local whiteTexture = surface.GetTextureID("vgui/white")
function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    surface.SetTexture(whiteTexture)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawPoly(self.CirclePoly)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    surface.SetMaterial(Tempest.GetProfileImage(self.steamid))
    surface.DrawTexturedRect(0, 0, w, h)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("Tempest:Avatar", PANEL, "Panel")