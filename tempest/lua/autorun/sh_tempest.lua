
-- ----------- --
-- Tempest  UI --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Loads files in tempest/
-- 
-- If you see these headers you know its a file from before i made the F4
-- Very epic!

-- Main Init
Tempest = Tempest or {}
Tempest.DisabledModules = {
    f4 = true,
    scoreboard = true,
    experimental = true
}
Tempest.DevMode = true
Tempest.Version = 1.1

-- Devmode Checks
if Tempest.DevMode then
    Tempest.F4 = {}

    Tempest.HUD = {}
    function Tempest.HUD:CreateDropdownModule(id, elmnt)
        self.DropdownModules = self.DropdownModules or {}
        self.DropdownModules[id] = elmnt
    end
end

-- Load Function
local function loadDirectory(dir, first)
    local fil, fol = file.Find(dir .. "/*", "LUA")

    for k,v in ipairs(fil) do
        local dirs = dir .. "/" .. v

        print("Loading: " .. dirs)
        if v:StartWith("cl_") then
            if SERVER then AddCSLuaFile(dirs)
            else include(dirs) end
        elseif v:StartWith("sv_") then
            if SERVER then include(dirs) end
        else
            AddCSLuaFile(dirs)
            include(dirs)
        end
    end

    for k,v in pairs(fol) do
        if Tempest.DisabledModules[v] then
            print("Skip   : \"" .. v .. "\"")
            continue
        end
        loadDirectory(dir .. "/" .. v)
    end
end

-- Console Message
local tempest_msg = {
    [[_/\/\/\/\/\/\_/\/\/\/\/\/\_/\/\______/\/\_/\/\/\/\/\___/\/\/\/\/\/\___/\/\/\/\/\_/\/\/\/\/\/\_]],
    [[_____/\/\_____/\___________/\/\/\__/\/\/\_/\/\____/\/\_/\___________/\/\_____________/\/\_____]],
    [[_____/\/\_____/\/\/\/\/\___/\/\/\/\/\/\/\_/\/\/\/\/\___/\/\/\/\/\_____/\/\/\/\_______/\/\_____]],
    [[_____/\/\_____/\/\_________/\/\__/\__/\/\_/\/\_________/\/\_________________/\/\_____/\/\_____]],
    [[_____/\/\_____/\/\/\/\/\/\_/\/\______/\/\_/\/\_________/\/\/\/\/\/\_/\/\/\/\/\_______/\/\_____]],
    [[______________________________________________________________________________________________]],
}

function Tempest.PrintMessage()
    local basecol = Color(170, 170, 170)
    local up = Color(95, 30, 199)
    local down = Color(159, 30, 199)

    local from = up
    local to = down
    local sv_col = Color(130,96,255)

    local function base_col(i)
        return Color(
            Lerp(i / #tempest_msg[1], from.r, to.r),
            Lerp(i / #tempest_msg[1], from.g, to.g),
            Lerp(i / #tempest_msg[1], from.b, to.b)
        )
    end

    for k,v in ipairs(tempest_msg) do
        for i = 1,#v do
            local c = v[i]
            local n = v[math.min(i + 1, #v)]
            local p = v[math.max(i - 1, 0)]
            MsgC(c == "_" and basecol or (c == "/" and p == "_" and up) or (c == "\\" and n == "_" and down) or (SERVER and sv_col or base_col(i)), c)
        end
        MsgN()
    end
end

-- Credits
concommand.Add("tempest_credits", function()
    Tempest.PrintMessage()
    MsgC(        Color(165, 101, 4), "\n",
    "      Main Development by Melon\n",
    "      Whudda a very cool man\n",
    "      Junes super cute, sig heil bro\n",
    "      Mirx is meh but he helps\n",
    "      Rain is pretty sick, and dayum he cute (ask for pics)\n",
    "      And ze, the love of my life, the shining light in this dark world.... send feet pics pls")
end )

-- Actual Initialization
print(("\n"):rep(2))
Tempest.PrintMessage()
print(("\n"):rep(2))
loadDirectory("tempest-core")
loadDirectory("tempest-modules")