
Tempest.Lang = Tempest.Lang or {}

-- Debug Functions
-- local function align(str, amt)
--     return (" "):rep(math.max(amt - #(tostring(str)), 0))
-- end

-- Tokenization Functions
function Tempest.Lang.TokenizeLine(line)
    local tokens = {}

    for k,v in ipairs(Tempest.Lang.SplitLine(line)) do
        if isstring(v) then
            table.insert(tokens, {v, type(v)})
        elseif istable(v) then
            table.insert(tokens, {v, type(v)})
        end
    end

    return Tempest.Lang.SplitLine(line)
end

function Tempest.Lang.Tokenize(str)
    local lines = string.Split(str, "\n")

    local line_list = {}

    for k,v in ipairs(lines) do
        local pre = Tempest.Lang.PreprocessLine(v)

        if not pre then
            -- MsgC(Color(255,0,0), k .. ":" .. align(k .. ":", 6) .. "$", align("|", 4) .. "|" ..  v, "\n")
            continue
        end

        -- print(k .. align(k, 4) .. "  " .. Tempest.Lang.GetIndents(v), "  |" .. v .. align(v, 40) .. "| " .. util.TableToJSON(Tempest.Lang.TokenizeLine(pre)))

        local tokenlist = Tempest.Lang.SplitLine(pre)

        if tokenlist.error then
            print("[TempestLang] [Tokenizer] " .. tokenlist.errormsg)
            return {}
        end

        table.insert(line_list, {
            line = k,
            tokens = tokenlist,
            indent = Tempest.Lang.GetIndents(v),
            original = v
        })
    end

    return line_list
end

-- Line Handling Functions
function Tempest.Lang.GetIndents(line)
    local cnt = 0
    for mat in string.gmatch(line, "    ") do
        cnt = cnt + 1
    end
    return cnt
end

function Tempest.Lang.PreprocessLine(line)
    local trimmed = string.Trim(line)
    if trimmed == "" then return false end

    if trimmed[1] == "#" then return false end

    return line:Trim()
end

function Tempest.Lang.IsAZ(str)
    local gs = string.gsub(str, "[a-zA-Z1-9]", "")
    return gs == "", gs
end

function Tempest.Lang.SplitLine(line)
    local split = {}
    local open = false
    local openstr = false

    for i = 1, #line do
        local char = line[i]
        local az = Tempest.Lang.IsAZ(char)

        if openstr then
            if char == openstr[2] then
                table.insert(split, {"string", openstr[1], openstr[2]})
                openstr = false
            else
                openstr[1] = openstr[1] .. char
            end
        elseif char == "\"" or char == "\'" then
            openstr = {
                "",
                char
            }
        elseif open then
            if az then
                open = open .. char
            else
                table.insert(split, {(tonumber(open) and "number") or "ident", open})
                table.insert(split, {char == " " and "space" or "symbol", char})
                open = false
            end
        else
            if az then
                open = char
            else
                table.insert(split, {char == " " and "space" or "symbol", char})
            end
        end
    end

    if open then
        table.insert(split, {"unknown", open})
    end

    if openstr then
        return {error = true, errormsg = "Improperly closed string, are you missing a closing " .. openstr[2] .. "?"}
    end

    return split
end

-- Tests
if not GAMEMODE then return end
local test = [[
# Test Comment

print(123)

def Test():
    print(256)

print("This is a string", 'asd')
print(False)
]]

print(("\n\n\n"):rep(10), "")
for k,v in pairs(Tempest.Lang.Tokenize(test:TrimRight())) do
    _p(v)
end
print()