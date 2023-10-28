
local PANEL = {}
AccessorFunc(PANEL, "job", "Job")

function PANEL:Init()
    self:SetText("")

    self.model = vgui.Create("DModelPanel", self)
    self.model:SetMouseInputEnabled(false)
    self.model.PaintOver = function(s,w,h)
        if not istable(self.job.model) and #self.job.model >= 2 then return end
        draw.Text({
            text = "Scroll to change model",
            pos = {
                w / 2, h
            },
            xalign = 1,
            yalign = 4,
            font = Tempest.Font(20),
            color = Tempest.HUD:GetColor("accent2")
        })
    end

    self.model.OnMouseWheeled = function(s, delt)
        if not istable(self.job.model) and #self.job.model >= 2 then return end
        if delt == 1 then
            self.current_job = (self.current_job % #self.job.model) + 1
        else
            if self.current_job == 1 then
                self.current_job = #self.job.model
            else
                self.current_job = math.Clamp((self.current_job - 1) % #self.job.model, 1, #self.job.model)
            end
        end
        s:SetModel(self.job.model[self.current_job])
        DarkRP.setPreferredJobModel(self.job.team, s:GetModel())
    end
end

function PANEL:PerformLayout(w,h)
    self.model:SetSize(w, w)
    self.model:SetPos(0, 30)
end

function PANEL:SetJob(job)
    self.job = job

    self.model:SetModel(Tempest.F4.HandleJobModel(job))
    self.current_job = 1
end

function PANEL:OnMouseWheeled(d)
    self.model:OnMouseWheeled(d)
end

function PANEL:Paint(w,h)
    if not self.job then return end
    draw.Text({
        text = self.job.name,
        pos = {w / 2, 20},
        xalign = 1,
        font = Tempest.Font(40)
    })
    draw.Text({
        text = "Description",
        pos = {w / 2, w + 70},
        xalign = 1,
        font = Tempest.Font(40)
    })
    draw.DrawText(DarkRP.textWrap(self.job.description, Tempest.Font(20), w - 20), Tempest.Font(20), w / 2, w + 110, color_white, 1)

    surface.SetDrawColor(Tempest.HUD:GetColor("bland"))
    surface.DrawRect(w / 8, w + 45, w - w / 4, 2)
    surface.SetDrawColor(self.job.color.r, self.job.color.g, self.job.color.b, 50)
    surface.SetMaterial(Tempest.HUD:GetMaterial("Right"))
    surface.DrawTexturedRect(w / 8, w + 45, w - w / 4, 2)
end

function PANEL:DoClick()
    RunConsoleCommand("say", "/" .. self.job.command)
    Tempest.HUD:Close()
end

vgui.Register("Tempest:F4:SidePanel", PANEL, "DButton")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("f4")
end
