
local votes = {}
local function OnVote(msg)
    local q = msg:ReadString()
    local voteid = msg:ReadShort()
    local timeleft = msg:ReadFloat()

    if timeleft == 0 then
        timeleft = 100
    end

    votes[voteid] = notification.AddSelection(q:gsub("[\t\n]", " "), timeleft, function(s, passed)
        RunConsoleCommand("vote", voteid, passed and "yea" or "nay")
        s.yes.DoClick = function() end
        s.no.DoClick = function() end

        s.time = CurTime() + 3
        s.text = "Thank you for voting!"
    end )
end

local function KillVote(msg)
    local voteid = msg:ReadShort()

    if votes[voteid] then
        votes[voteid]:Kill()
        votes[voteid] = nil
    end
end

hook.Add("PostGamemodeLoaded", "Tempest:LoadVoteUI", function()
    usermessage.Hook("DoVote", OnVote)
    usermessage.Hook("KillVoteVGUI", KillVote)
end )

if GAMEMODE then
    usermessage.Hook("DoVote", OnVote)
    usermessage.Hook("KillVoteVGUI", KillVote)
end