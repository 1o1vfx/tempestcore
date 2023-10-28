
-- ----------- --
-- Tempest Hud --
-- ----------- --
-- 
-- Written by Melon (https://peepee.us/)
-- 
-- Purpose: Handles downloading images from the info-superhighway

local url = Tempest.DevMode and "https://urgay.xyz/static/tempest/" or "https://tempest-networks.com/img/tempest/"

file.CreateDir("tempest")
file.CreateDir("tempest/profiles")

local errmat = Material("vgui/gradient-l")

local imgs = {}
local currently_downloading = {}
function Tempest.Imgur(id)
    local realid = id
    id = string.lower(id)
    if imgs[id] then
        return imgs[id]
    end

    if file.Exists("tempest/" .. id .. ".png", "DATA") then
        imgs[id] = Material("../data/tempest/" .. id .. ".png", "mips smooth")
        return imgs[id]
    end

    print("Attempting to find Image (" .. id .. ")`")

    if not currently_downloading[id] then
        http.Fetch(url .. realid .. ".png", function(bod, size)
            if size < 200 then
                return print("Bad Imgur ID (" .. id .. ") (size " .. size .. ")")
            end
            print("Successfully Downloaded ")
            file.Write("tempest/" .. id ..  ".png", bod)

            imgs[id] = Material("../data/tempest/" .. id .. ".png", "mips smooth")
        end,
        function(err)
            print("Invalid Imgur ID (" .. id .. ") (" .. err .. ")")
        end )
        currently_downloading[id] = true
    end

    imgs[id] = errmat
    return errmat
end

local pfps = {}
function Tempest.GetProfileImage(stid) -- STEAMID64 BRO\
    if not stid then
        return errmat
    end
    if pfps[stid] then
        return pfps[stid]
    end
    if file.Exists("tempest/profiles/" .. stid .. ".png", "DATA") then
        pfps[stid] = Material("../data/tempest/profiles/" .. stid .. ".png", "smooth")
        return pfps[stid]
    elseif file.Exists("tempest/profiles/" .. stid .. ".jpg", "DATA") then
        pfps[stid] = Material("../data/tempest/profiles/" .. stid .. ".jpg", "smooth")
        return pfps[stid]
    end

    http.Fetch("https://steamcommunity.com/profiles/" .. stid .. "/?xml=1", function(bod, size, _, code)
        if bod:match("The specified profile could not be found.") then
            return print("Bad Profile ID (" .. stid .. ") (size " .. size .. ")")
        end

        local pfp_url, ext = bod:match("<avatarFull>.-(https?://%S+%f[%.]%.)(%w+).-</avatarFull>")
        ext = ext == "jpeg" and "jpg" or ext

        http.Fetch(pfp_url .. ext, function(bod2)
            file.Write("tempest/profiles/" .. stid .. "." .. ext, bod2)
            pfps[stid] = Material("../data/tempest/profiles/" .. stid .. "." .. ext, "mips smooth")
        end, function()
            print("Invalid Profile ID (" .. stid .. ") (" .. err .. ")")
        end )
    end,
    function(err2)
        print("Invalid Profile ID (" .. id .. ") (" .. err2 .. ")")
    end )

    pfps[stid] = errmat
    return errmat
end

concommand.Add("tempest_clear_images", function()
    file.Delete("tempest")
    file.CreateDir("tempest")
    file.CreateDir("tempest/profiles")
end )

concommand.Add("tempest_image_dump", function()
    local files = file.Find("tempest/*", "DATA")
    local copy = ""

    for k,v in pairs(files) do
        copy = copy .. k .. "=" .. v .. ";"
    end

    SetClipboardText(copy)
    print("Copied")
end )