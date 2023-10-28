
Tempest.F4 = Tempest.F4 or {}

function Tempest.F4.HandleJobModel(job)
    local m = job.model

    if istable(m) then
        return DarkRP.getPreferredJobModel(job.team) or m[1]
    end

    return m
end

function Tempest.F4.Generate()
    Tempest.HUD:CreateDropdownModule("f4", "Tempest:F4")
end

hook.Add("Tempest:ModuleDone", "Tempest:F4", function(f)
    if f ~= "hud" then return end
    Tempest.F4.Generate()
end )

if Tempest.HUD then
    Tempest.F4.Generate()
end

hook.Add("PostGamemodeLoaded", "Tempest:F4:Init", function()
    function DarkRP.openF4Menu()
        if Tempest.HUD:IsOpen() then
            Tempest.HUD:Close()
            return
        end
        Tempest.HUD:Open("f4")
    end
end )

if GAMEMODE then
    Tempest.F4.Generate()
end