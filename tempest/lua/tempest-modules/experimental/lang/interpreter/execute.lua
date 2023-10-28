
function Tempest.Lang.Execute(parsed)

end

function Tempest.Lang.ExecuteString(str)
    Tempest.Lang.Execute(Tempest.Lang.ParseFromString(str))
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
Tempest.Lang.ExecuteString(test)
print()