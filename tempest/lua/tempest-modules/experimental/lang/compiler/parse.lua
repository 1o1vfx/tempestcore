
Tempest.Lang = Tempest.Lang or {}
Tempest.Lang.Keywords = {
    False = "bool",
    True = "bool",
    None = "none",

    def = "function"
}
Tempest.Lang.Symbols = {
    ["+"] = "add",
    ["-"] = "sub",
    ["/"] = "div",
    ["*"] = "mul",
    ["@"] = "attr"
}

-- Tokenizer works fine but the parser doesnt :)
-- This needs a rewrite
function Tempest.Lang.Parse(tokens)
    local ast = {}

    if tokens.error then
        return false
    end

    for k,v in ipairs(tokens) do
        local line = {}
        line.token = v
        line.type = "error"
        line.indent = v.indent

        local start = v.tokens[1]

        if start[1] == "ident" then
            if start[2] == "def" then
                line.type = "def"
                line.name = v.tokens[3]
            end

            local iscall, bef = Tempest.Lang.PeekUntil(v.tokens, 2, "(", {["space"] = true})
            if iscall then
                line.type = "call"
                line.args = {}

                for i = (3 + bef), #v.tokens - 1 do
                    local t = v.tokens[i][1]
                    if t == "number" or t == "bool" or t == "string" or t == "ident" then
                        table.insert(line.args, t)
                    end
                    -- line.args = line.args .. v.tokens[i][1] .. " "
                end
            end
        elseif start[1] == "symbol" then
            if start[2] == "@" then
                line.type = "attr"
            end
        end

        table.insert(ast, line)
    end

    return ast
end

function Tempest.Lang.PeekUntil(tokens, start, type, ign)
    for i = start,#tokens do
        if ign[tokens[i][1]] then
            continue
        elseif (tokens[i][2] == type) or (tokens[i][1] == type) then
            return tokens[i], i - start
        else
            return false
        end
    end
end

function Tempest.Lang.ParseFromString(str)
    return Tempest.Lang.Parse(Tempest.Lang.Tokenize(str))
end

if not GAMEMODE then return end
local test = [[
# Test Comment

print(123)

def Test():
    print(256)

print("This is a string", 'asd')
Test()
]]

Tempest.ReloadTimes = (Tempest.ReloadTimes or 0) + 1
print(("\n\n\n"):rep(5), Tempest.ReloadTimes, ("\n\n\n"):rep(5))
for k,v in pairs(Tempest.Lang.ParseFromString(test)) do
    print(k, v.type, v.indent, v.token.original)
end
print()