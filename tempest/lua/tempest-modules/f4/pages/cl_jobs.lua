
local PANEL = {}
local th = Tempest.HUD

function PANEL:Init()
    local scl = th.Scale(30)
    th = th or Tempest.HUD

    self.main = vgui.Create("DScrollPanel", self)
    self.job = vgui.Create("Panel", self)
    self.job.inner = vgui.Create("Tempest:F4:SidePanel", self.job)
    function self.job:PerformLayout(w, h)
        self.inner:SetSize(w, h)
        self.inner:SetY(0)
    end
    function self.job:Paint(w,h)
        surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
        surface.DrawRect(0, 0, 1, h)
        surface.SetDrawColor(Tempest.HUD:GetColor("accent2"))
        surface.SetMaterial(th:GetMaterial("Up"))
        surface.DrawTexturedRect(0, 0, 1, h)
    end

    function self.main:PerformLayout(w,h)
        if self:GetVBar():IsVisible() then
            self:GetVBar():SetWide(scl)
            self:DockMargin(scl, scl, 0, scl)
        else
            self:DockMargin(scl, scl, scl, scl)
        end
    end
    self.main:GetVBar():SetHideButtons(true)
    self.main:GetVBar().Paint = function(s,w,h)
        draw.RoundedBox(6, w / 4, 0, w / 2, h, th:GetColor("header", "F4"))
    end
    self.main:GetVBar().btnGrip.Paint = function(s,w,h)
        draw.RoundedBox(4, w / 4 + 2, 2, w / 2 - 4, h - 4, Tempest.LerpColor(self.main:GetVBar():GetScroll() / self.main:GetCanvas():GetTall(), Tempest.HUD:GetColor("accent"), Tempest.HUD:GetColor("accent2")))
    end

    self.main.cats = {}
    self.main:DockMargin(scl, scl, 0, scl)
    for k,v in ipairs(DarkRP.getCategories()["jobs"]) do
        if #v.members == 0 then continue end
        local p = vgui.Create("Panel", self.main)
        p:Dock(TOP)
        p:SetTall(scl * 2)
        p:DockMargin(0, 0, 0, 6)
        p.PaintOver = function(s,w,h)
            draw.RoundedBoxEx(4, 0, 0, w, h, Tempest.HUD:GetColor("header", "F4"), true, true)

            surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
            surface.DrawRect(0, h - 2, w, 2)
            surface.SetMaterial(th:GetMaterial("Right"))
            surface.SetDrawColor(v.color)
            surface.DrawTexturedRect(0, h - 2, w, 2)


            draw.Text({
                text = v.name,
                pos = {20, h / 2 + 2},
                font = Tempest.Font(40),
                yalign = 1
            })
            draw.Text({
                text = #v.members .. " Jobs",
                pos = {w - 20, h / 2 + 2},
                yalign = 1,
                font = Tempest.Font(30),
                xalign = TEXT_ALIGN_RIGHT
            })
        end
        self.main.cats[k] = p

        local max = 2
        local existing = nil
        for kk,j in ipairs(v.members) do
            if not existing or existing.amt == max then
                existing = vgui.Create("Panel", self.main)
                existing:Dock(TOP)
                existing:SetTall(th.Scale(75))
                existing.amt = 0

                function existing:PerformLayout(w, h)
                    for i, ch in ipairs(self:GetChildren()) do
                        local wid = w / max
                        ch:SetSize(wid, h)
                        ch:SetPos(wid * (i - 1), 0)
                    end
                end
            end

            local job = vgui.Create("DButton", existing)
            job:SetText("")
            job.DoClick = function()
                self:ShowJob(j)
            end
            job.Paint = function(s,w,h)
                if s:IsHovered() then
                    s.yy = Lerp(FrameTime() * 10, s.yy or h, 6)
                else
                    s.yy = Lerp(FrameTime() * 10, s.yy or h, h - 6)
                end

                draw.RoundedBox(4, 6, h - 12, w - 12, 6, j.color)
                draw.RoundedBoxEx(4, 6, 6, w - 12, h - 14, th:GetColor("job_item", "F4"), true, true)

                draw.RoundedBoxEx(4, 6, s.yy - 2, w - 12, h - s.yy - 6, Tempest.DarkenColor(j.color, .6), true, true)

                surface.SetDrawColor(10, 10, 10, 70)
                surface.SetMaterial(th:GetMaterial("Down"))
                surface.DrawTexturedRect(6, h - 14, w - 12, 5)

                draw.Text({
                    text = j.name,
                    pos = {h + h / 4, h / 2 + 2},
                    yalign = 1,
                    font = Tempest.Font(40)
                })
            end

            job.model = vgui.Create("DModelPanel", job)
            job.model:SetModel(Tempest.F4.HandleJobModel(j))
            local hpos = job.model.Entity:GetBonePosition(job.model.Entity:LookupBone("ValveBiped.Bip01_Head1"))

            job.model.LayoutEntity = function() end
            job.model:SetLookAt(hpos)
            job.model:SetCamPos(hpos-Vector(-17, 0, 0))

            function job:PerformLayout(w,h)
                self.model:SetPos(h / 4, 0)
                self.model:SetSize(h - 12, h - 8)
            end

            existing.amt = existing.amt + 1
        end
        local spacer = vgui.Create("Panel", self.main)
        spacer:SetTall(10)
        spacer:Dock(TOP)
    end
end

function PANEL:ShowJob(jobtbl, btn)
    if self.job.inner.moving then
        return
    end
    if self.job.inner.active then
        self.job.inner.moving = true
        self.job.inner:MoveTo(self.job:GetWide(), 0, 0.2, 0, 1, function()
            self.job.inner.moving = false
            self.job.inner.active = false
            self:ShowJob(jobtbl, btn)
        end )
        return
    end

    self.job.inner.moving = true
    self.job.inner:MoveTo(0, 0, 0.2, 0, 1, function()
        self.job.inner.moving = false
        self.job.inner.active = true
    end )

    self.job.inner:SetJob(jobtbl)
    self.job.inner.button = btn
end

function PANEL:PerformLayout(w, h)
    self.job:Dock(RIGHT)
    self.job:SetWide(th.Scale(300))

    self.main:Dock(FILL)
    self.job.inner:SetPos(self.job:GetWide(), 0)
end

vgui.Register("Tempest:F4:Jobs", PANEL, "Panel")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("f4")
end
