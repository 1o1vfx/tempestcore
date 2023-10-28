
local speaking = {}
local drawn = 0
function Tempest.HUD.DrawVoice(pl)
    if not IsValid(pl) then
        speaking[pl] = nil
    end
    if speaking[pl] <= 0.1 then
        speaking[pl] = nil
        return
    end
    if not pl:IsSpeaking() then
        speaking[pl] = Lerp(FrameTime() * 10, speaking[pl], 0)
    end

    surface.SetAlphaMultiplier(speaking[pl])

    surface.SetFont(Tempest.Font(30))
    local job = pl:getJobTable().name
    local w = math.max(150, select(1, surface.GetTextSize(pl:Nick())), select(1, surface.GetTextSize(job))) + 10
    local h = Tempest.Scale(45)
    local x = ScrW() - w - 5 - h
    local y = (ScrH() * .7) - ((h + 5) * drawn)

    draw.RoundedBoxEx(4, x, y, h, h, Tempest.HUD:GetColor("select", "Main"), true, false, true)
    draw.RoundedBoxEx(4, x + h, y, w, h, Tempest.HUD:GetColor("background"), false, true, false, true)

    local vv = pl:VoiceVolume()
    render.SetScissorRect(x, math.max(y + h - ((vv * 1.5) * h), y), x + w, y + h, true)
    draw.RoundedBoxEx(4, x, y, h, h, Tempest.LerpColor(vv, Tempest.HUD:GetColor("accent"), pl:getJobTable().color), true, false, true)
    render.SetScissorRect(0,0,0,0,false)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(Tempest.GetProfileImage(pl:SteamID64()))
    surface.DrawTexturedRect(x + 4, y + 4, h - 8, h - 8)

    draw.Text({
        text = pl:Nick(),
        pos = {x + h + 5, y + (h / 4) + 4},
        font = Tempest.Font(30),
        yalign = 1
    })

    draw.Text({
        text = job,
        pos = {x + h + 5, y + (h - (h / 4)) - 2},
        font = Tempest.Font(25),
        yalign = 1,
        color = Tempest.HUD:GetColor("text2")
    })
    drawn = drawn + 1
end

hook.Add("HUDShouldDraw", "Tempest:HUD:RemoveChatRecievers", function(n)
    if n == "DarkRP_ChatReceivers" then return false end
end )

hook.Add("PlayerStartVoice", "Tempest:HUD:StartVoice", function(pl)
    speaking[pl] = 1
end)

hook.Add("PlayerEndVoice", "Tempest:HUD:StartVoice", function(pl)
    speaking[pl] = nil
end)

hook.Add("HUDPaint", "Tempest:HUD:DrawVoice", function()
    local lp = LocalPlayer()

    if not IsValid(lp) then return end

    -- if lp:IsSpeaking() and not speaking[lp] then
    --     speaking[lp] = 1
    -- end

    for k,v in pairs(speaking) do
        Tempest.HUD.DrawVoice(k)
    end
    drawn = 0
end )

hook.Add("InitPostEntity", "Tempest:HUD:RemoveOldVoicePanel", function()
    timer.Simple(1, function()
        timer.Remove("VoiceClean")
        if not IsValid(g_VoicePanelList) then return end
        g_VoicePanelList:Remove()
    end)
end)