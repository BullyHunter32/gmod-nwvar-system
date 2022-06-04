
local function BuildVarTable()
    local tbl = {
        String = {},
        Bool = {},
        Int = {},
        Entity = {},
        Float = {}
    }
    return tbl
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:GetPublicVars(s)
    if not self.m_tPublicVars then
        self.m_tPublicVars = BuildVarTable()
    end
    local dat = self.m_tPublicVars 
    dat = s and dat[s] or dat

    return dat
end

function ENTITY:GetPublicString(key, default)
    if default == nil then default = "" end
    local v = self:GetPublicVars("String")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPublicBool(key, default)
    if default == nil then default = false end
    local v = self:GetPublicVars("Bool")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPublicInt(key, default)
    if default == nil then default = 0 end
    local v = self:GetPublicVars("Int")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPublicEntity(key, default)
    if default == nil then default = NULL end
    local v = self:GetPublicVars("Entity")[key]
    if v == nil then return default end
    return v
end

------------------------------------------------
-- PRIVATE
------------------------------------------------

function ENTITY:GetPrivateVars(s)
    if not self.m_tPrivateVars then
        self.m_tPrivateVars = BuildVarTable()
    end
    local dat = self.m_tPrivateVars 
    dat = s and dat[s] or dat

    return dat
end

function ENTITY:GetPrivateString(key, default)
    if default == nil then default = "" end
    local v = self:GetPrivateVars("String")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPrivateBool(key, default)
    if default == nil then default = false end
    local v = self:GetPrivateVars("Bool")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPrivateInt(key, default)
    if default == nil then default = 0 end
    local v = self:GetPrivateVars("Int")[key]
    if v == nil then return default end
    return v
end

function ENTITY:GetPrivateEntity(key, default)
    if default == nil then default = NULL end
    local v = self:GetPrivateVars("Entity")[key]
    if v == nil then return default end
    return v
end
