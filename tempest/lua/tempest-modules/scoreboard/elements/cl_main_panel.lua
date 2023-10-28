
local PANEL = {}

function PANEL:Init()
    self.current_players = {}
    self.open_player = false

    self.canvas = vgui.Create("DScrollPanel", self)
    self.canvas:GetVBar():SetHideButtons(true)
    self.canvas:GetVBar().Paint = function(s,w,h)
        draw.RoundedBox(6, w / 4, 0, w / 2, h, Tempest.HUD:GetColor("header", "F4"))
    end
    self.canvas:GetVBar().btnGrip.Paint = function(s,w,h)
        draw.RoundedBox(4, w / 4 + 2, 2, w / 2 - 4, h - 4, Tempest.LerpColor(self.canvas:GetVBar():GetScroll() / self.canvas:GetCanvas():GetTall(), Tempest.HUD:GetColor("accent"), Tempest.HUD:GetColor("accent2")))
    end

    self:GeneratePlayers()
end

function PANEL:GeneratePlayers()
    -- if self:CheckPlayers(player.GetAll()) then return end
    self.current_players = player.GetAll()

    for k,v in pairs(self.canvas:GetCanvas():GetChildren()) do
        v:Remove()
    end

    local scl60 = Tempest.Scale(60)
    local first = nil
    for k,v in SortedPairs(self:ProcessPlayers()) do
        local head = vgui.Create("Panel", self.canvas)
        head:Dock(TOP)
        head:SetTall(scl60)
        head:DockMargin(0, 8, 0, 0)
        head.job = RPExtraTeams[k]
        first = first or head

        function head:Paint(w, h)
            local oldh = h
            h = first == self and h / 1.5 or h
            draw.RoundedBoxEx(4, 0, 0, w, h, Tempest.HUD:GetColor("job_item", "F4"), true, true)

            surface.SetDrawColor(Tempest.HUD:GetColor("accent"))
            surface.DrawRect(0, h - 2, w, 2)
            surface.SetMaterial(Tempest.HUD:GetMaterial("Right"))
            surface.SetDrawColor(self.job.color)
            surface.DrawTexturedRect(0, h - 2, w, 2)

            draw.Text({
                text = self.job.name,
                pos = {20, h / 2},
                font = Tempest.Font(40),
                yalign = 1
            })
            draw.Text({
                text = #v .. " Members",
                pos = {w - 20, h / 2},
                font = Tempest.Font(30),
                yalign = 1,
                xalign = TEXT_ALIGN_RIGHT
            })


            if self ~= first then return end
            local ny = oldh / 1.5
            local nh = oldh - ny
            draw.RoundedBoxEx(4, 0, ny, w, nh, Tempest.HUD:GetColor("header", "F4"), false, false, true, true)
            surface.SetDrawColor(Tempest.HUD:GetColor("bland"))
            surface.DrawRect(0, ny, w, 1)

            draw.Text({
                text = "MUTE",
                pos = {w - h / 2 - 5, ny + nh / 2 + 1},
                color = Tempest.HUD:GetColor("text2"),
                xalign = 1,
                yalign = 1,
                font = Tempest.Font(30)
            })

            h = h + 2
            draw.Text({
                text = "PING",
                pos = {w - 50 - h, ny + nh / 2 + 1},
                color = Tempest.HUD:GetColor("text2"),
                xalign = 1,
                yalign = 1,
                font = Tempest.Font(30)
            })

            draw.Text({
                text = "K-D",
                pos = {w - 145 - h, ny + nh / 2 + 1},
                color = Tempest.HUD:GetColor("text2"),
                xalign = 1,
                yalign = 1,
                font = Tempest.Font(30)
            })

            draw.Text({
                text = "RANK",
                pos = {w - 220 - h, ny + nh / 2 + 1},
                color = Tempest.HUD:GetColor("text2"),
                xalign = 2,
                yalign = 1,
                font = Tempest.Font(30)
            })
        end

        local firstpl
        for kk,vv in pairs(v) do
            local pl = vgui.Create("Tempest:Scoreboard:PlayerLine", self.canvas)
            firstpl = firstpl or pl
            pl:Dock(TOP)
            pl:DockMargin(2, 2, 2, 2)
            pl:SetPlayer(vv)
            pl:SetTall(scl60)
            pl.first = firstpl
            pl.parent = self
        end

        firstpl:DockMargin(2, 0, 2, 2)
    end

    first:DockMargin(0, 0, 0, 0)
    first:SetTall(scl60 * 1.5)
end

function PANEL:PerformLayout(w, h)
    self.canvas:SetSize(w - 40, h - 48)
    self.canvas:SetPos(20, 24)
end

function PANEL:OnOpen()
    self:GeneratePlayers()
end

function PANEL:ProcessPlayers()
    local plys = {}

    for k,v in pairs(player.GetAll()) do
        local t = v:getJobTable().team
        if not plys[t] then
            plys[t] = {}
        end

        table.insert(plys[t], v)
    end

    return plys
end

function PANEL:CheckPlayers(tbl)
    local cur = self.current_players

    if #cur ~= #tbl then print("Failed") return false end
    for k,v in pairs(tbl) do
        if not IsValid(cur[k]) then print("Failed") return false end
        if cur[k]:SteamID64() ~= v:SteamID64() then print("Failed") return false end
        if cur[k]:getDarkRPVar("job") ~= v:getDarkRPVar("job") then print("Failed") return false end
    end

    print("paseed")
    return true
end

vgui.Register("Tempest:Scoreboard", PANEL, "Panel")

if Tempest.DevMode and IsValid(Tempest.HUD.dropdown) then
    Tempest.HUD.dropdown.CreatedModules = nil
    Tempest.HUD.dropdown:Remove()
    Tempest.HUD.dropdown = nil
    Tempest.HUD:Open("scoreboard")
end
