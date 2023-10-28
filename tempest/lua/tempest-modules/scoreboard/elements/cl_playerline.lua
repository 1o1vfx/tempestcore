
local PANEL = {}
AccessorFunc(PANEL, "ply", "Player")

function PANEL:Init()
    self:SetText("")

    self.avatar = vgui.Create("Tempest:Avatar", self)
    self.avatar:SetMouseInputEnabled(false)

    self.mute = vgui.Create("DButton", self)
    self.mute:SetText("")
    function self.mute.DoClick()
        self:GetPlayer():SetMuted(not self:GetPlayer():IsMuted())
        notification.AddLegacy((self:GetPlayer():IsMuted() and "Unmuted " or "Muted ") .. self:GetPlayer():Nick())
    end

    function self.mute.Paint(s,w,h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Tempest.Imgur(self:GetPlayer():IsMuted() and "unmuted" or "muted"))
        surface.DrawTexturedRect(h / 8, h / 8, w - h / 4, h - h / 4)
    end
end

function PANEL:SetPlayer(pl)
    self.ply = pl

    self.avatar:SetPlayer(pl)
end

function PANEL:DoClick()
    local x = self:LocalCursorPos()

    if x <= self:GetTall() + 5 then
        self:GetPlayer():ShowProfile()
        return
    end

    SetClipboardText(self:GetPlayer():SteamID())
    notification.AddLegacy("Copied " .. self:GetPlayer():Nick() .. "'s SteamID")
end

function PANEL:DoRightClick()
    local cmdfunction = function(cmd)
        return function()
            RunConsoleCommand("say", "!" .. cmd .. " " .. self:GetPlayer():SteamID())
        end
    end

    local menu = DermaMenu(false, self)
    menu:AddOption("Copy SteamID", function()
        SetClipboardText(self:GetPlayer():SteamID())
        notification.AddLegacy("Copied " .. self:GetPlayer():Nick() .. "'s SteamID")
    end )
    menu:AddOption("Copy SteamID64", function()
        SetClipboardText(self:GetPlayer():SteamID64())
        notification.AddLegacy("Copied " .. self:GetPlayer():Nick() .. "'s SteamID64")
    end )
    menu:AddOption(self:GetPlayer():IsMuted() and "Unmute" or "Mute", function()
        self:GetPlayer():SetMuted(not self:GetPlayer():IsMuted())
        notification.AddLegacy((self:GetPlayer():IsMuted() and "Unmuted " or "Muted ") .. self:GetPlayer():Nick())
    end )

    menu:AddSpacer()
    menu:AddOption("Goto", cmdfunction("goto"))
    menu:AddOption("Bring", cmdfunction("bring"))
    menu:Open()
end

function PANEL:Paint(w,h)
    if not IsValid(self:GetPlayer()) then
        return self.parent:GeneratePlayers()
    end

    draw.RoundedBoxEx(4, 0, 0, w, h, Tempest.HUD:GetColor("job_item", "F4"), self.first ~= self, self.first ~= self, true, true)

    if self.first == self then
        surface.SetDrawColor(Tempest.HUD:GetColor("shadow", "F4"))
        surface.SetMaterial(Tempest.HUD:GetMaterial("Up"))
        surface.DrawTexturedRect(0, 0, w, 10)
    end

    local pl = self:GetPlayer()
    if Tempest.Scoreboard.Config.SpecialNames[pl:SteamID()] then
        Tempest.Scoreboard.Config.SpecialNames[pl:SteamID()](h + 4, h / 2 + 2, pl)
    else
        draw.Text({
            text = pl:Nick(),
            pos = {h + 4, h / 2 + 2},
            font = Tempest.Font(45),
            yalign = 1
        })
    end

    draw.Text({
        text = self:GetPlayer():Ping() .. "ms",
        pos = {w - 50 - h, h / 2 + 2},
        font = Tempest.Font(35),
        yalign = 1,
        xalign = 1,
        color = Tempest.LerpColor(LocalPlayer():Ping() / 200, Tempest.Scoreboard:GetColor("PingLow", "PlayerLine"), Tempest.Scoreboard:GetColor("PingHigh", "PlayerLine"))
    })

    draw.Text({
        text = self:GetPlayer():Frags() .. "-" .. self:GetPlayer():Deaths(),
        pos = {w - 145 - h, h / 2 + 2},
        font = Tempest.Font(35),
        yalign = 1,
        xalign = 1,
        color = Tempest.HUD:GetColor("text2")
    })

    draw.Text({
        text = Tempest.Scoreboard.Config.Ranks[self:GetPlayer():GetUserGroup()] or self:GetPlayer():GetUserGroup(),
        pos = {w - 220 - h, h / 2 + 2},
        font = Tempest.Font(35),
        yalign = 1,
        xalign = 2,
        color = Tempest.HUD:GetColor("text2")
    })
end

function PANEL:PerformLayout(w, h)
    local sixty = Tempest.Scale(60)
    self.avatar:SetPos(6, 6)
    self.avatar:SetSize(sixty - 12, sixty - 12)

    self.mute:SetPos(w - h, 0)
    self.mute:SetSize(h, h)
end

vgui.Register("Tempest:Scoreboard:PlayerLine", PANEL, "DButton")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    -- Tempest.HUD:Open("scoreboard")
end
