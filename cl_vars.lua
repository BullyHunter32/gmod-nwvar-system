local TYPE_FLOAT = 45

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

local function ReadType(type)
    if type == TYPE_STRING then
        return net.ReadString()
    elseif type == TYPE_NUMBER then
        return net.ReadInt(32)
    elseif type == TYPE_ENTITY then
        return net.ReadEntity()
    elseif type == TYPE_BOOL then
        return net.ReadBool()
    elseif type == TYPE_FLOAT then
        return net.ReadFloat()
    end
    return
end

net.Receive("Vars.Sync", function()
    local isPublic = net.ReadBool()
    local ent = net.ReadEntity()
    local type = net.ReadUInt(8)
    local key = net.ReadString()
    local val = ReadType(type)

    local fnStr = "Get"..(isPublic and "Public" or "Private").."Vars"
    local vars = ent[fnStr](ent)

    print(isPublic, ent, type, key, val, fnStr, vars, Type2String(type))
    if not vars then
        error("Something went wrong synchronizing a variable.")
    end

    vars = vars[Type2String(type)]
    if not vars then
        error("Something went wrong synchronizing a variable.")
    end

    vars[key] = val
end)

local function ReadSet(type)
    return net.ReadString(), ReadType(type)
end

local function ReadTypeTable(ent)
    local type = net.ReadUInt(8)
    local len = net.ReadUInt(12)
    local vars = ent:GetPublicVars(Type2String(type))
    for i = 1, len do
        local k,v = ReadSet(type)
        vars[k] = v
        print("[", k , "] = ", v)
    end
end

net.Receive("Vars.SyncAll", function()
    local len = net.ReadUInt(14)
    for i = 1, len do
        local ent = net.ReadEntity()
        ReadTypeTable(ent)
        ReadTypeTable(ent)
        ReadTypeTable(ent)
        ReadTypeTable(ent)
        ReadTypeTable(ent)
    end
end)