
local PANEL = {}
local th = Tempest.HUD

function PANEL:Init()
    th = th or Tempest.HUD

    self.nav = vgui.Create("Panel", self)
    self.content = vgui.Create("Tempest:Tabs", self)

    function self.nav:Paint(w,h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Tempest.HUD:GetColor("header", "F4"), true, true)
    end

    function self.nav:PaintOver(w,h)
        local ft = FrameTime() * 10
        self.barx = Lerp(ft, self.barx or 0, self.active:GetPos())
        self.barw = Lerp(ft, self.barw or 0, self.active:GetWide())

        self.barcolor = Tempest.LerpColor((self.barx + self.barw / 2) / w, Tempest.HUD:GetColor("accent"), Tempest.HUD:GetColor("accent2"))

        surface.SetDrawColor(self.barcolor)
        surface.DrawRect(self.barx, h - 2, self.barw, 2)
    end

    function self.nav:PerformLayout(w,h)
        local cnt = self:GetChildren()
        local curw = 0
        surface.SetFont(Tempest.Font(50))
        for k,v in ipairs(cnt) do
            v:SetSize(select(1, surface.GetTextSize(v.name)) + 60, h)
            v:SetPos(curw, 0)

            curw = curw + v:GetWide()

            v.isLast = k == #cnt
        end
    end

    self:AddThing("Entities").Generate = self.GenerateEntities
    self:AddThing("Weapons")
    self:AddThing("Shipments")
    self:AddThing("Ammo")

    for k,v in pairs(self.content:GetChildren()) do
        v:Generate()
    end
end

function PANEL:AddThing(name)
    local btn = vgui.Create("DButton", self.nav)
    btn:SetText("")

    btn.name = name

    function btn:Paint(w,h)
        draw.Text({
            text = self.name,
            pos = {w / 2, h / 2 + 2},
            xalign = 1,
            yalign = 1,
            font = Tempest.Font(50),
            color = self.active and Tempest.OffsetColor(self:GetParent().barcolor or color_white, 1.4) or Tempest.HUD:GetColor("text1")
        })
    end

    function btn:DoClick()
        self:GetParent().active.active = false
        self:GetParent().active = self
        self.active = true

        self:GetParent():GetParent().content:SetTab(name)
    end

    self.nav.active = self.nav.active or btn
    self.nav.active.active = true

    return self.content:AddTab(name, "Tempest:F4:Items:Blank")
end

function PANEL:PerformLayout(w,h)
    local scl = th.Scale(30)
    self.nav:Dock(TOP)
    self.nav:SetTall(th.Scale(60))
    self.nav:DockMargin(scl, scl, scl, 0)
    self.content:Dock(FILL)
    self.content:DockMargin(scl, scl / 2, scl, scl)
end

-- Pages Below
local function canBuyEntity(item)
    local ply = LocalPlayer()

    if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyCustomEntity", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

function PANEL:GenerateEntities()
    for k,v in pairs(DarkRP.getCategories().entities) do
        if #v.members == 0 then continue end
        self:AddHeader(v.name, v.color, #v.members .. " Items")
        for kk,vv in pairs(v.members) do
            self:AddItem(vv.model, v.color, vv.name)
        end
    end
end


vgui.Register("Tempest:F4:Items", PANEL, "Panel")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("f4")
end
