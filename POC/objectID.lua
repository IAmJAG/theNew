local metaRoot = {id = 'x'}
metaRoot.__index = metaRoot

local metaLevel1 = {id = 'a'}
metaLevel1.__index = metaRoot

local metaLevel2 = {id = 'b'}
metaLevel2.__index = metaLevel1

local metaBase = {id = 'z'}
metaBase.__index = metaLevel2

local proxy = {id = 0}

setmetatable(metaLevel1, metaRoot)
setmetatable(metaLevel2, metaLevel1)
setmetatable(metaBase, metaLevel2)
setmetatable(proxy, metaBase)

local obj = proxy

while obj do
    print(obj.id)
    obj = getmetatable(obj)
end