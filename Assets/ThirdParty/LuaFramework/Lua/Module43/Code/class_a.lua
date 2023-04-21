--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--继承的实现，classname是子类名称， super是要生成子类时基于的父类 2020.2.19
function class_a(classname, super)
    local supertype = type(super)
    local cls

    if(supertype == "function" and supertype)then
        supertype = nil
        super = nil
    end

    if(superType == "function" or (super and super.__ctype == 1))then
        cls ={}
        if supertype == "table" then
            for k, v in pairs(super)do cls[k] = v end
            cls.__create = super.__create
            cls.super = super
        else
            cls.__create = super
            cls.ctor = function()end
        end

        cls.__cname = classname
        cls.__ctype = 1
        function cls.new(...)
            local instance = cls.__create(...)
            for k, v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    else
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end
    return cls
end

--endregion
