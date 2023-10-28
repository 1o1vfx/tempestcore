
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Draws Main Bit, yaknow the big one

local th = Tempest.HUD

-- PANEL
local PANEL = {}
PANEL.Base = "Panel"

function PANEL:Init()
    self:CalcSize()
    self.Modules = {}

    self:ParentToHUD()
    self:SetZPos(10)

    self:SetAlpha(Tempest.HUD.Alpha)
    self:SetTall(Tempest.HUD.Height)
end

function PANEL:Think()
    local lp = LocalPlayer()
    if not IsValid(lp) then return end

    local wep = lp:GetActiveWeapon()
    if not IsValid(wep) then return end

    if wep:GetClass() == "gmod_camera" then
        self.alpha = (Lerp(FrameTime() * 10, self.alpha or 0, 0))
    else
        self.alpha = (Lerp(FrameTime() * 10, self.alpha or 255, Tempest.HUD.Alpha))
    end

    self:SetAlpha(self.alpha)
end

function PANEL:Paint(w,h)
    -- Hacky fix for keeping HUD below all EXCEPT dropdown
    if gui.IsGameUIVisible() then
        self:SetDrawOnTop(false)
    elseif th.isdropdownopen then
        self:SetDrawOnTop(true)
    end

    surface.SetDrawColor(th:GetColor("background"))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(th:GetColor("accent"))
    surface.DrawRect(0, h - 2, w, 2)

    surface.SetMaterial(th:GetMaterial("Right"))
    surface.SetDrawColor(th:GetColor("accent2"))
    surface.DrawTexturedRect(0, h - 2, w, 2)

    -- Uncomment below for a shadow
    -- local oc = DisableClipping(true)

    -- surface.SetDrawColor(th:GetColor("shadow", "Dropdown"))
    -- surface.SetMaterial(th:GetMaterial("Up"))
    -- surface.DrawTexturedRect(0, h, w, 2)

    -- DisableClipping(oc)
end

function PANEL:CalcSize()
    self:SetWide(ScrW())
    self:SetTall(th.Scale(Tempest.HUD.Height))

    local pad = th.Scale(8)
    self:DockPadding(pad,pad,pad,pad)
end

function PANEL:OnScreenSizeChanged()
    self:CalcSize()
end

function PANEL:AddModule()
    local p = vgui.Create("Panel", self)
    p:Dock(LEFT)

    function p:CalcSize(w, h) end

    function p:Create() end

    function p:CreateThink()
        if self.Create then
            self:Create()
            self.Create = false
        end
    end

    function p:Think()
        self:CreateThink()
    end

    local sep = vgui.Create("Panel", self)
    sep:Dock(LEFT)

    function sep:Paint(w, h)
        surface.SetDrawColor(th:GetColor("bland"))
        surface.DrawRect(0,0,w,h)
    end

    p.divider = sep
    table.insert(self.Modules, p)
    return p
end

function PANEL:PerformLayout(ww, hh)
    local dp = self:GetDockPadding() * 2
    for k,v in ipairs(self.Modules) do
        v.divider:SetWide(1)
        v.divider:DockMargin(dp, 0, dp, 0)
        v:CalcSize(ww, hh - dp)
    end
    self.Modules[#self.Modules].divider:SetVisible(false)
end

-- Creation
if Tempest.DevMode and IsValid(th.MainPanel) then
    th.MainPanel:Remove()
    chat.AddText("Refreshing Main Panel")
end

local p = vgui.CreateFromTable(PANEL)
th.MainPanel = p

-- Modules
-- -- Player
do
    local ply = p:AddModule()

    function ply:Create()
        self.image = vgui.Create("Tempest:Avatar", self)
        self.image:SetPlayer(LocalPlayer())

        self.textW = 0
    end

    function ply:CalcSize(w, h)
        if not self.image then return end
        self.image:SetSize(h, h)
        self.image:SetMaskSize(h / 2)

        self:SetWide(h + self.textW + 7)
    end

    function ply:Paint(w, h)
        local oc = DisableClipping(true)
        local otw = self.textW
        self.textW = math.max(
        select(1, draw.Text({
            text = LocalPlayer():Nick(),
            pos = {h + 7, h / 4 + 1},
            yalign = TEXT_ALIGN_CENTER,
            -- 36
            font = Tempest.HUD.Font(h * .9)
        })),

        select(1, draw.Text({
            text = LocalPlayer():getDarkRPVar("job") .. " - " .. DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")),
            pos = {h + 7, h - h / 4 + 3},
            yalign = TEXT_ALIGN_CENTER,
            -- 26
            font = Tempest.HUD.Font(h * .7),
            color = th:GetColor("text2")
        })))

        DisableClipping(oc)

        if self.textW ~= otw then
            self:CalcSize(w, h)
        end
    end
end

-- -- Logo
do
    local mod = p:AddModule()

    function mod:Paint(w, h)
        surface.SetMaterial(th.Imgur("olpitre"))
        surface.SetDrawColor(th:GetColor("text"))
        surface.DrawTexturedRect(0, 0, h, h)
    end

    function mod:CalcSize(_, h)
        self:Dock(RIGHT)
        self.divider:SetVisible(false)

        if self:GetWide() ~= h then -- Prevents unnecessary layouts
            self:SetSize(h, h)
        end
    end
end

-- -- Lerping Modules
-- -- Ive made these autogenerate for my own convenience

local modules = {
    ["Health"] = {
        order           = 1,
        drawbland       = true,

        iconcolor       = "health",
        icon            = "hhwmxrf",
        percentage      = function()
            return LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
        end,
        text            = function(self)
            return math.max(math.Round(self.value), 0) .. "%"
        end,
        lerpvalue       = function(self)
            self.value = Lerp(FrameTime() * 22, self.value or 0, LocalPlayer():Health())
        end
    },
    ["Armor"] = {
        order           = 2,
        drawbland       = true,

        iconcolor       = "armor",
        icon            = "9xk0tzi",
        icondiv         = 1.3,
        percentage      = function()
            return LocalPlayer():Armor() / 100
        end,
        text            = function(self)
            return math.max(math.Round(self.value), 0) .. "%"
        end,
        lerpvalue       = function(self)
            self.value = Lerp(FrameTime() * 22, self.value or 0, LocalPlayer():Armor())
        end

    },
    ["Money"] = {
        order           = 3,
        drawbland       = false,

        iconcolor       = "money",
        icon            = "21bm3ij",
        icondiv         = 1.3,
        text            = function(self)
            return self.value_text
        end,
        lerpvalue       = function(self)
            local ov = self.value
            self.value = Lerp(FrameTime() * 22, self.value or 0, LocalPlayer():getDarkRPVar("money"))

            if self.value ~= ov then
                self.value_text = DarkRP.formatMoney(math.Round(self.value))
            end
        end
    }
}

for k,v in SortedPairsByMemberValue(modules, "order") do
    local mod = p:AddModule()
    mod.module = v

    function mod:Paint(w,h)
        local iconsize = h / (self.module.icondiv or 1.5)
        surface.SetMaterial(th.Imgur(self.module.icon))
        if self.module.drawbland then
            surface.SetDrawColor(th:GetColor("bland"))
            surface.DrawTexturedRect(1, h / 2 - iconsize / 2 + 1, iconsize - 2, iconsize - 2)

            render.SetScissorRect(0, self:GetY() + (h / 2 - iconsize / 2) + iconsize - ((self.module.percentage()) * iconsize), ScrW(), self:GetY() + ScrW(), true)
            surface.SetDrawColor(th:GetColor(self.module.iconcolor, "Main"))
            surface.DrawTexturedRect(0, h / 2 - iconsize / 2, iconsize, iconsize)
            render.SetScissorRect(0, 0, 0, 0, false)

        else
            surface.SetDrawColor(th:GetColor(self.module.iconcolor, "Main"))
            surface.DrawTexturedRect(0, h / 2 - iconsize / 2, iconsize, iconsize)
        end

        local nw = draw.Text({
            text = self.module.text(self),
            pos = {iconsize + 5, h / 2 + 2},
            font = Tempest.HUD.Font(h * 1.1),
            yalign = 1,
            xalign = 0
        })

        if nw ~= self.textW then
            self.textW = nw
            self:CalcSize(w, h)
        end
    end

    function mod:CalcSize(w, h)
        if not self.textW then return end
        self:SetWide(h / (self.module.icondiv or 1.5) + self.textW + 5)
    end

    function mod:Think()
        self:CreateThink()

        self.module.lerpvalue(self)
    end
end
