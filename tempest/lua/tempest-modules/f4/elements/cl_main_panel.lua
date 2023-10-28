
local th = Tempest.HUD
local PANEL = {}
PANEL.Tempest_CloseKey = KEY_F4

function PANEL:Init()
    th = th or Tempest.HUD
    self.buttons = vgui.Create("Panel", self)
    self.tabs = vgui.Create("Tempest:Tabs", self)

    self:AddThing("dkerdsv", "Dashboard")
    self:AddThing("k8auizl", "Jobs", "Tempest:F4:Jobs")
    self:AddThing("4mn5h4b", "Items", "Tempest:F4:Items")
    self.tabs:SetTab("Items")

    self.buttons.divider = vgui.Create("DPanel", self.buttons)
    self.buttons.divider:Dock(TOP)
    self.buttons.divider.Paint = function(s,w,h)
        local oc = DisableClipping(true)
        surface.SetDrawColor(Tempest.HUD:GetColor("bland"))
        surface.DrawRect(0,-1,w,h)

        if self.lastbtn.activeWide >= 1 then
            surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
            surface.DrawRect(w / 2 - self.lastbtn.activeWide / 2, -1, self.lastbtn.activeWide, 1)
        end

        DisableClipping(oc)
    end

    for k,v in pairs(Tempest.F4.Config.Links) do
        self:AddLinkThing(k, v[2], v[1])
    end

    function self.buttons:PerformLayout(w, h)
        local size = Tempest.Scale(85)
        self:DockPadding(0, w, 0, 0)
        for k,v in pairs(self:GetChildren()) do
            v:SetTall(size)
        end

        self.divider:DockMargin(w / 8, 0, w / 8, 0)
        self.divider:SetTall(1)
    end

    function self.buttons:Paint(w, h)
        local ww = w / 1.5
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Tempest.Imgur("olpitre"))
        surface.DrawTexturedRect(ww / 4, ww / 4, ww, ww)

        surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
        surface.DrawRect(w - 1, 0, 1, h)
        surface.SetDrawColor(Tempest.HUD:GetColor("accent2"))
        surface.SetMaterial(th:GetMaterial("Down"))
        surface.DrawTexturedRect(w - 1, 0, 1, h)

        surface.SetDrawColor(Tempest.HUD:GetColor("bland"))
        surface.DrawRect(w / 8,w,w - w / 4,1)
    end
end

function PANEL:PerformLayout(w,h)
    self.tabs:Dock(FILL)

    self.buttons:Dock(LEFT)
    self.buttons:SetWide(th.Scale(300))
end

function PANEL:AddThing(icon, name, type)
    local tab = self.tabs:AddTab(name, type)

    local btn = vgui.Create("DButton", self.buttons)
    btn:Dock(TOP)
    btn:SetText("")
    btn.DoClick = function()
        self.tabs:SetTab(name)
    end
    btn.Paint = function(s, w, h)
        s.off = s:IsHovered() and Lerp(FrameTime() * 12, s.off or 0, 10) or Lerp(FrameTime() * 10, s.off or 0, 0)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Tempest.Imgur(icon))
        surface.DrawTexturedRect(h / 4, h / 4, h / 2, h / 2)

        draw.Text({
            text = name,
            font = Tempest.Font(40),
            pos = {w - w / 8 - s.off, h / 2 + 2},
            yalign = 1,
            xalign = 2
        })

        if self.tabs:GetCurrentTab() == tab then
            s.activeWide = Lerp(FrameTime() * 10, s.activeWide or 0, w - w / 4)
        else
            s.activeWide = Lerp(FrameTime() * 10, s.activeWide or 0, 0)
        end

        surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
        surface.DrawRect(w / 2 - s.activeWide / 2, h - 1, s.activeWide, 1)
    end
    self.lastbtn = btn
end

function PANEL:AddLinkThing(name, icon, link)
    local btn = vgui.Create("DButton", self.buttons)
    btn:Dock(TOP)
    btn:SetText("")
    btn.DoClick = function()
        if isstring(link) then
            gui.OpenURL(link)
        else
            link()
        end
    end
    btn.Paint = function(s, w, h)
        s.off = s:IsHovered() and Lerp(FrameTime() * 12, s.off or 0, 10) or Lerp(FrameTime() * 10, s.off or 0, 0)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Tempest.Imgur(icon))
        surface.DrawTexturedRect(h / 4, h / 4, h / 2, h / 2)

        draw.Text({
            text = name,
            font = Tempest.Font(40),
            pos = {w - w / 8 - s.off, h / 2 + 2},
            yalign = 1,
            xalign = 2
        })
    end
end

vgui.Register("Tempest:F4", PANEL, "Panel")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("f4")
end
