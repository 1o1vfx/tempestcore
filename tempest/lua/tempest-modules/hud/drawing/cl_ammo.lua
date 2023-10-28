
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Shows ammo

local th = Tempest.HUD

-- PANEL
local PANEL = {}
PANEL.Base = "Panel"

function PANEL:Init()
    self:SetSize(th.Scale(200), th.Scale(110))
    self:CalcPos()
    self:ParentToHUD()
    self:SetZPos(-1000)

    self:SetAlpha(Tempest.HUD.Alpha)
end

function PANEL:Format(clip1, total)
    local cl1en = clip1 == -1
    local totalen = total == -1
    if not cl1en and not totalen then
        return clip1 .. "/" .. total
    end
end

function PANEL:Paint(w,h)
    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid(wep) then return end

    local current_clip = wep:Clip1() or 0
    local current_total = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()) or 0
    local text = (th.Config.SpecialAmmo[wep:GetClass()] and th.Config.SpecialAmmo[wep:GetClass()](self, wep)) or self:Format(current_clip, current_total)

    if not text or text == "" then
        self.alpha = Lerp(FrameTime() * 10, self.alpha or 0, 0)
    else
        self.alpha = Lerp(FrameTime() * 10, self.alpha or 1, 1)

        self.text = text
        self.current_clip = current_clip
        self.current_total = current_total
    end

    surface.SetAlphaMultiplier(self.alpha)

    draw.RoundedBoxEx(th.Scale(6), 0, 0, w, h, th:GetColor("background"), false, false, true, true)

    surface.SetDrawColor(th:GetColor("accent"))
    surface.DrawRect(0, 0, w, 2)

    surface.SetMaterial(th:GetMaterial("Right"))
    surface.SetDrawColor(th:GetColor("accent2"))
    surface.DrawTexturedRect(0, 0, w, 2)

    local rawtextw, rawtexth = draw.Text({
        text = self.text,
        pos = {w / 2, h / 2 + 4},
        font = th.Font(60),
        xalign = 1,
        yalign = 1
    })

    local otw = self.textW
    local oth = self.textH
    self.textW = math.max(rawtextw + th.Scale(30), h)
    self.textH = rawtexth

    if otw ~= self.textW or oth ~= self.textH then
        self:SetSize(self.textW, self.textH)
        self:CalcPos()
    end
end

function PANEL:CalcPos()
    local pad = th.Scale(25) / 2
    self:SetPos(ScrW() - self:GetWide() - pad * 2, ScrH() - self:GetTall() - pad)
end

function PANEL:OnScreenSizeChanged()
    self:CalcSize()
end

if IsValid(th.AmmoPanel) then
    th.AmmoPanel:Remove()
    chat.AddText("Refreshing Ammo Panel")
end

local p = vgui.CreateFromTable(PANEL)
th.AmmoPanel = p
