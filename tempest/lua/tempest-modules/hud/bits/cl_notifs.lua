
-- General Vars
local th = Tempest.HUD
th.Notifications = th.Notifications or {}
local notifs = Tempest.HUD.Notifications

-- Refresh Support
for k,v in pairs(th.Notifications) do
    v:Remove()
    th.Notifications[k] = nil
end

-- Locals
local _w, _h = Tempest.Scale(200), Tempest.Scale(45)
local _pad_margin = Tempest.Scale(10)
local _pad_top = Tempest.Scale(110) + _pad_margin

-- Main Notification Panel
local PANEL = {}

function PANEL:Init()
    self:SetAlpha(Tempest.HUD.NotifAlpha)
end

function PANEL:OnScreenSizeChanged(w, h)
    _w, _h = Tempest.Scale(200), Tempest.Scale(45)
    _pad_margin = Tempest.Scale(10)
    _pad_top = Tempest.Scale(110) + _pad_margin
end

function PANEL:Think()
    if (CurTime() >= (self.time or CurTime() + 5)) and not self.moving then
        self:MoveTo(ScrW(), self:GetY(), 0.2, 0, 1, function()
            self:Remove()
            table.remove(notifs, self.index)
            for i = self.index, #notifs do
                notifs[i].index = notifs[i].index - 1
            end
        end )
        self.moving = true
    end

    self.y = Lerp(FrameTime() * 10, self.y, _pad_top + (((self.index or 1) - 2) * (_h + _pad_margin) + _pad_margin))

    if not self.moving then
        self.x = ScrW() - self:GetWide() - 5
    end
end

function PANEL:Paint(w, h)
    if not th.Config.NotificationTypeIcons[self.type] then
        print("invalid notification type ")
        return
    end
    draw.RoundedBoxEx(4, 0, 0, 6, h, th:GetColor("types", "Notifications")[self.type] or color_black, true, false, true)
    draw.RoundedBoxEx(4, 4 + h, 0, w - 4 - h, h, th:GetColor("background", "Notifications"), false, true, false, true)

    surface.SetDrawColor(th:GetColor("icon_background", "Notifications"))
    surface.DrawRect(4, 0, h, h)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(Tempest.Imgur(th.Config.NotificationTypeIcons[self.type]))
    surface.DrawTexturedRect(12, 8, h - 16, h - 16)

    local otw = self.textW or w

    local ntw = math.Clamp(draw.Text({
        text = self.text,
        pos = {h + 16, h / 2 + 2},
        xalign = 0,
        yalign = 1,
        font = Tempest.Font(30)
    }) + h + 28, 200, ScrW() * .7)

    if otw ~= ntw then
        self.textW = Lerp(FrameTime() * 10, otw, ntw)
        self:SetWide(self.textW)
    end
end

function PANEL:Kill()
    self.time = CurTime()
end

vgui.Register("Tempest:Notification", PANEL, "DPanel")

-- Notification Selection
PANEL = {}

function PANEL:Init()
    self.text = "abcdef"

    self.yes = vgui.Create("DButton", self)
    self.yes:SetText("")
    self.yes.icon = "yvg7vi6"
    self.yes.color = "yes"

    self.no = vgui.Create("DButton", self)
    self.no:SetText("")
    self.no.icon = "z1uau0b"
    self.no.color = "no"

    self.yes.DoClick = function()
        self.on_selected(self, true)
    end

    self.no.DoClick = function()
        self.on_selected(self, false)
    end

    self.yes.Paint = function(s,w,h)
        surface.SetDrawColor(th:GetColor(s.color, "Notifications"))
        surface.SetMaterial(Tempest.Imgur(s.icon))
        surface.DrawTexturedRect(2, 2, w - 4, h - 4)
    end
    self.no.Paint = self.yes.Paint

    self:SetAlpha(Tempest.HUD.NotifAlpha)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(4, 0, 0, 6, h, th:GetColor("types", "Notifications")[self.type] or th:GetColor("vote_color", "Notifications"), true, false, true)

    surface.SetDrawColor(th:GetColor("icon_background", "Notifications"))
    surface.DrawRect(4, 0, h, h)

    surface.SetDrawColor(th:GetColor("select_bg", "Notifications"))
    surface.DrawRect(h + 4, 0, h / 2 + 8, h)

    local p = h + h / 2 + 11
    draw.RoundedBoxEx(4, p, 0, w - p , h, th:GetColor("background", "Notifications"), false, true, false, true)

    draw.Text({
        text = math.max(math.ceil(self.time - CurTime()), 0),
        pos = {4 + h / 2, h / 2 + 2},
        xalign = 1,
        yalign = 1,
        font = Tempest.Font(30)
    })

    local otw = self.textW or w

    local ntw = draw.Text({
        text = self.text,
        pos = {h + 48, h / 2 + 2},
        xalign = 0,
        yalign = 1,
        font = Tempest.Font(30)
    }) + h + 58

    if otw ~= ntw then
        self.textW = Lerp(FrameTime() * 10, otw, ntw)
        self:SetWide(self.textW)
    end
end

function PANEL:PerformLayout(w, h)
    self.yes:SetPos(h + 8, 0)
    self.yes:SetSize(h / 2, h / 2)
    self.no:SetPos(h + 8, h / 2)
    self.no:SetSize(self.yes:GetSize())
end

vgui.Register("Tempest:Notification:Select", PANEL, "Tempest:Notification")

-- Notification Handlers
function notification.AddLegacy(text, type, time)
    if GAS then
        GAS:PlaySound("popup")
    end

    surface.SetFont(Tempest.Font(30))

    local p = vgui.Create("Tempest:Notification")
    p:SetSize(_w, _h)
    p:SetPos(ScrW(), _pad_top + ((#notifs - 1) * (_h + _pad_margin) + _pad_margin))
    p:MoveTo(ScrW() - p:GetWide() - _pad_margin, p:GetY(), 0.2)

    p.time = CurTime() + (time or 5)
    p.type = 0
    p.text = text or ""
    p.index = #notifs + 1

    notifs[p.index] = p

    return p.index
end

function notification.AddSelection(text, time, selected)
    if GAS then
        GAS:PlaySound("alert")
    end

    local p = vgui.Create("Tempest:Notification:Select")
    p:SetSize(_w, _h)
    p:SetPos(ScrW(), _pad_top + ((#notifs - 1) * (_h + _pad_margin) + _pad_margin))
    p:MoveTo(ScrW() - p:GetWide() - _pad_margin, p:GetY(), 0.2)

    p.time = CurTime() + (time or 5)
    p.type = 5
    p.text = text
    p.index = #notifs + 1
    p.on_selected = selected

    notifs[p.index] = p

    return p
end

function notification.Kill(index)
    if IsValid(notifs[index]) then
        notifs[index]:Kill()
    end
end

function notification.AddProgress(id, str, frac)
    notification.AddLegacy(str, NOTIFY_HINT)
end

concommand.Add("tempest_test_selection", function()
    if LocalPlayer():SteamID() ~= "STEAM_0:1:24711728" then return print("Naughty boy") end

    notification.AddSelection("Test Selection Text Blah Blah", 30, function(s)
        s.text = "Thank you for selecting this text!"
    end )
end )