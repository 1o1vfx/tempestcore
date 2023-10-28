
Tempest.HUD = Tempest.HUD or {}

Tempest.HUD.GetColor = Tempest.GetColor
Tempest.HUD.GetMaterial = Tempest.GetMaterial
Tempest.HUD.Imgur = Tempest.Imgur

Tempest.HUD.Scale = Tempest.Scale
Tempest.HUD.Font = Tempest.Font

Tempest.HUD.DropdownModules = Tempest.HUD.DropdownModules or {}

function Tempest.HUD:IsOpen()
    return self.isdropdownopen
end

function Tempest.HUD:Open(module)
    if not self.dropdown then
        self:CreateDropdown()
    end

    self.isdropdownopen = true
    self.dropdown:MoveTo(0, Tempest.HUD.Height, 0.2, 0, 1, function() self.dropdown.ismoving = false end)
    self.dropdown:SetSize(ScrW(), ScrH() - Tempest.HUD.Height)
    self.dropdown:MakePopup()
    self.dropdown:SetZPos(-1)
    self.dropdown:ParentToHUD()
    self.MainPanel:SetDrawOnTop(true)

    self.dropdown.CreatedModules = self.dropdown.CreatedModules or {}

    if self.dropdown.Opened and self.dropdown.Opened.OnOpen then
        self.dropdown.Opened:OnOpen()
    end

    if self.dropdown.CreatedModules[module] then
        if IsValid(self.dropdown.Opened) then
            self.dropdown.Opened:SetVisible(false)
        end

        self.dropdown.CreatedModules[module]:SetVisible(true)
        self.dropdown.Opened = self.dropdown.CreatedModules[module]

        return
    end

    self.dropdown.Opened = vgui.Create(Tempest.HUD.DropdownModules[module], self.dropdown)
    self.dropdown.Opened:SetSize(self.dropdown:GetSize())
    self.dropdown.Opened.module = module

    self.dropdown.CreatedModules[module] = self.dropdown.Opened
end

function Tempest.HUD:Close(dbg_fun)
    if not self.dropdown then
        self:CreateDropdown()
        return
    end
    self.isdropdownopen = false
    self.dropdown:MoveTo(0, -ScrH(), 0.2, 0, 1, function()
        self.dropdown.ismoving = false
        if dbg_fun then dbg_fun() end
        self.MainPanel:SetDrawOnTop(false)
    end )

    self.dropdown:SetMouseInputEnabled(false)
    self.dropdown:SetKeyboardInputEnabled(false)
end

function Tempest.HUD:CreateDropdown()
    if self.dropdown then
        self.dropdown:Remove()
    end
    self.dropdown = vgui.Create("DPanel")
    self.dropdown:SetSize(ScrW(), 0)
    self.dropdown:SetPos(0, -ScrH())

    function self.dropdown:OnKeyCodePressed(f)
        if f == (self.Opened or {}).Tempest_CloseKey then
            Tempest.HUD:Close()
        end
    end

    function self.dropdown:OnMousePressed()
        if Tempest.Devmode then
            Tempest.HUD:Close(function()
                Tempest.HUD.dropdown:Remove()
                Tempest.HUD.dropdown = nil
            end )
        end
    end

    function self.dropdown:PerformLayout(w,h)
        if IsValid(self.Opened) then
            self.Opened:SetSize(w, h)
        end
    end

    function self.dropdown:OnScreenSizeChanged()
        self:SetWide(ScrW())
    end

    function self.dropdown:Paint(w,h)
        surface.SetDrawColor(Tempest.HUD:GetColor("background", "Dropdown"))
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(100,100,100,1)
        surface.SetMaterial(Tempest.Imgur("olpitre"))
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, w, 45)
    end
end

function Tempest.HUD:CreateDropdownModule(id, elmnt)
    self.DropdownModules[id] = elmnt
    print("Created '" .. id .. "'")
end

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD:Close(function()
        Tempest.HUD.dropdown:Remove()
        Tempest.HUD.dropdown = nil
    end )
end

hook.Run("Tempest:ModuleDone", "hud")