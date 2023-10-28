
local known = {
    ["fonts"] = "resource/fonts/"
}
concommand.Add("tempest_debug_dump", function(_,_,args)
    if not args[2] then
        args[2] = args[1]
        args[1] = "both"
    end

    if known[args[2]] then
        args[2] = known[args[2]]
    end

    local tojson = {
        ["__osinfo"] = ((system.IsWindows() and "win") or (system.IsLinux() and "linux") or (system.IsOSX() and "osx") or "uns") .. ":" .. jit.arch
    }
    local files, folds = file.Find(args[2] .. "*", "GAME")

    if args[1] == "files" or args[1] == "both" then
        for k,v in pairs(files) do
            tojson["file:" .. v] = {
                file.Size(args[2] .. v, "GAME"),
                file.Time(args[2] .. v, "GAME")
            }
        end
    end

    if args[2] == "folds" or args[1] == "both" then
        for k,v in pairs(folds) do
            local new_f, new_d = file.Find(args[2] .. v .. "/*", "GAME")
            tojson["dir:" .. v] = #table.Merge(new_f, new_d)
        end
    end

    SetClipboardText(util.TableToJSON(tojson))
    print("Copied debug info! send to Melon")
end )

concommand.Add("tempest_dump_viewer", function(_,_,_,argstr)

end )