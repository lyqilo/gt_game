StringBuilder = {}
local this = StringBuilder;

function StringBuilder:new()
    local o = {}
    setmetatable(o, {__index = self})
    o.strTB = {};
    return o;
end


function StringBuilder:Clear()
    for i,v in ipairs(self.strTB) do
        self.strTB[i] = nil;
    end
    return self;
end


function StringBuilder:Append( str )
    table.insert(self.strTB,tostring(str));
    return self;
end

function StringBuilder:AppendLine( str )
    table.insert(self.strTB,tostring(str));
    table.insert(self.strTB,"\n");
    return self;
end

--得到栈顶元素  栈顶元素,空返回nil
function StringBuilder:AppendFormat( format , ... )
    local str = string.format( format , ... );
    table.insert(self.strTB,str);
    return self;
end

function StringBuilder:RemoveAppend()
    table.remove(self.strTB,#self.strTB);
    return self;
end

--出栈.返回删除的元素,空返回nil    
function StringBuilder:ToString( str )
    if str then
        return table.concat(self.strTB,str);
    else
        return table.concat(self.strTB);
    end
end

function this.__tostring( self )
    return self:ToString();
end

