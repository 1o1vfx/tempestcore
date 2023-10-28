
local PANEL = {}
AccessorFunc(PANEL, "currenttab", "CurrentTab")

function PANEL:Init()
    self.tabs = {}
end

function PANEL:AddTab(id, type)
    local p = vgui.Create(type or "Panel", self)
    p:SetSize(self:GetSize())
    p:SetPos(0, 0)
    p:SetVisible(false)
    p.id = id

    self.tabs[id] = p

    if not self:GetCurrentTab() then
        self:SetTab(id)
    end

    return p
end

function PANEL:SetTab(id)
    local cur = self:GetCurrentTab() or {}
    local get = self.tabs[id]

    if not get then return end
    if cur.id == id then return end
    if ispanel(cur) then
        cur:SetVisible(false)
    end

    get:SetVisible(true)
    self:SetCurrentTab(get)

    self:OnSelected(get)
end

function PANEL:OnSelected(tab)

end

function PANEL:PerformLayout(w, h)
    for k,v in pairs(self.tabs) do
        v:SetSize(w, h)
    end
end

vgui.Register("Tempest:Tabs", PANEL, "Panel")