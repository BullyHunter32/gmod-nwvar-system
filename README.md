# Documentation
NWVar system for non-predicted data. \
Private data is only sent to the client it belongs to, public data is shared with everyone.

## Public Variables

ENTITY:SetPublicInt(key, value) \
ENTITY:SetPublicString(key, value) \
ENTITY:SetPublicBool(key, value) \
ENTITY:SetPublicEntity(key, value) 
  
ENTITY:GetPublicInt(key, default = 0) \
ENTITY:GetPublicString(key, default = "") \
ENTITY:GetPublicBool(key, default = false) \
ENTITY:GetPublicEntity(key, default = NULL)

## Private Variables
  
PLAYER:SetPrivateInt(key, value) \
PLAYER:SetPrivateString(key, value) \
PLAYER:SetPrivateBool(key, value) \
PLAYER:SetPrivateEntity(key, value) 
  
PLAYER:GetPrivateInt(key, default = 0) \
PLAYER:GetPrivateString(key, default = "") \
PLAYER:GetPrivateBool(key, default = false) \
PLAYER:GetPrivateEntity(key, default = NULL)
