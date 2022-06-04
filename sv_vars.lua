local TYPE_FLOAT = 45

local ENTS = {}

local function IterTable(tbl)
    local new = {
        [0] = 0
    }
    for k, v in pairs(tbl) do
        new[0] = new[0] + 1
        new[new[0]] = {k, v}
    end
    return new
end

local function WriteType(type, val)
    if type == TYPE_NUMBER then
        net.WriteInt(val, 32)
    elseif type == TYPE_BOOL then
        net.WriteBool(val)
    elseif type == TYPE_STRING then
        net.WriteString(val)
    elseif type == TYPE_ENTITY then
        net.WriteEntity(val)
    elseif type == TYPE_FLOAT then
        net.WriteFloat(val)
    end
end

local function WriteSet(type, set)
    local k, v = set[1], set[2]
    net.WriteString(k)
    WriteType(type, v)
end

local function Type2String(type)
    if type == TYPE_STRING then
        return "String"
    elseif type == TYPE_NUMBER then
        return "Int"
    elseif type == TYPE_ENTITY then
        return "Entity"
    elseif type == TYPE_BOOL then
        return "Bool"
    elseif type == TYPE_FLOAT then
        return "Float"
    end
    return ""
end

local function WriteTypeTable(ent, type)
    local data = IterTable(ent:GetPublicVars(Type2String(type)))
    net.WriteUInt(type, 8)
    net.WriteUInt(data[0], 12)
    for i = 1, data[0] do
        WriteSet(type, data[i])
    end
end

local function WriteAllVars(ent)
    net.WriteEntity(ent)
    WriteTypeTable(ent, TYPE_STRING)
    WriteTypeTable(ent, TYPE_NUMBER)
    WriteTypeTable(ent, TYPE_ENTITY)
    WriteTypeTable(ent, TYPE_BOOL)
    WriteTypeTable(ent, TYPE_FLOAT)
end

util.AddNetworkString("Vars.SyncAll")
local function SyncAllPublic(ply)
    local world = Entity(0)

    local _ENTS = {}
    local count = 0

    for k,v in pairs(ENTS) do
        if not IsValid(k) and k ~= world then
            ENTS[k] = nil
        else
            count = count + 1
            _ENTS[count] = k
        end
    end

    local len = #_ENTS
    net.Start("Vars.SyncAll")
    net.WriteUInt(len, 14)
    for i = 1, len do
        WriteAllVars(_ENTS[i])
    end
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "Vars.SyncAll", function(ply)
    timer.Simple(1, function()
        SyncAllPublic(ply)
    end)
end)

util.AddNetworkString("Vars.Sync")
local function SyncVar(ent, type, key, value, recipient)
    if recipient == nil then
        recipient = true
    end

    net.Start("Vars.Sync")
    net.WriteBool(recipient == true)
    net.WriteEntity(ent)
    net.WriteUInt(type, 8)
    net.WriteString(key)
    WriteType(type, value)
    if recipient == true then
        net.Broadcast()
    else
        net.Send(recipient)
    end
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:SetPublicString(key, value)
    local dat = self:GetPublicVars("String")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_STRING, key, value)
end

function ENTITY:SetPublicBool(key, value)
    local dat = self:GetPublicVars("Bool")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_BOOL, key, value)
end

function ENTITY:SetPublicInt(key, value)
    local dat = self:GetPublicVars("Int")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_NUMBER, key, value)
end

function ENTITY:SetPublicEntity(key, value)
    local dat = self:GetPublicVars("Entity")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_ENTITY, key, value)
end

function ENTITY:SetPublicFloat(key, value)
    local dat = self:GetPublicVars("Float")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_FLOAT, key, value, self)
end

------------------------------------------------
-- PRIVATE
------------------------------------------------

function ENTITY:SetPrivateString(key, value)
    local dat = self:GetPrivateVars("String")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_STRING, key, value, self)
end

function ENTITY:SetPrivateBool(key, value)
    local dat = self:GetPrivateVars("Bool")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_BOOL, key, value, self)
end

function ENTITY:SetPrivateInt(key, value)
    local dat = self:GetPrivateVars("Int")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_NUMBER, key, value, self)
end

function ENTITY:SetPrivateEntity(key, value)
    local dat = self:GetPrivateVars("Entity")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_ENTITY, key, value, self)
end

function ENTITY:SetPrivateFloat(key, value)
    local dat = self:GetPrivateVars("Float")
    dat[key] = value
    if not ENTS[self] then
        ENTS[self] = true
    end
    SyncVar(self, TYPE_FLOAT, key, value, self)
end
