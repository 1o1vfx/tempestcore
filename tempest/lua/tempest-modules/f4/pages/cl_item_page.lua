
local PANEL = {}

function PANEL:Init()
    self.open = false
end

function PANEL:PerformLayout(w,h)
end

function PANEL:AddHeader(title, color, subtext)
    local head = vgui.Create("DPanel", self)
    head:Dock(TOP)
    head:SetTall(Tempest.Scale(60))

    function head:Paint(w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Tempest.HUD:GetColor("header", "F4"), true, true)
        surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
        surface.DrawRect(0, h - 2, w, 2)
        surface.SetDrawColor(color)
        surface.SetMaterial(Tempest.HUD:GetMaterial("Right"))
        surface.DrawTexturedRect(0, h - 2, w, 2)

        draw.Text({
            text = title,
            pos = {20, h / 2 + 2},
            font = Tempest.Font(40),
            yalign = 1
        })
        draw.Text({
            text = subtext,
            pos = {w - 20, h / 2 + 2},
            yalign = 1,
            font = Tempest.Font(30),
            xalign = TEXT_ALIGN_RIGHT
        })
    end

    if IsValid(self.open) then
        self.open = false
    end
end

function PANEL:AddItem(model, color, title)
    print()
end

function PANEL:Generate()
end

vgui.Register("Tempest:F4:Items:Blank", PANEL, "DScrollPanel")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("f4")
end