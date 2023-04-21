Stack = {}

function Stack:new()
    local copy = {}
    setmetatable(copy, {__index = self})
    copy.count = 0;
    copy.map = {};
    copy.list = {};
    return copy
end

--得到栈内元素数量
function Stack:size()
    return self.count;
end

--栈是否为空
function Stack:empty()
    return (self.count == 0)
end

function Stack:contain(value)
    if self.map[value] then
        return true;
    else
        return false
    end
end

--出栈.返回删除的元素,空返回nil    
function Stack:pop()
    local tmp = self:top()
    if tmp ~= nil then
        self.map[self.list[self.count]] = nil;
        table.remove(self.list,self.count);
        self.count = self.count - 1;
    end
    return tmp
end

--入栈.
function Stack:push(value)
    table.insert(self.list, value)
    self.map[value] = true;
    self.count = self.count + 1;
    return self.count;
end

--得到栈顶元素  栈顶元素,空返回nil
function Stack:top()
    if self.count == 0 then
        return nil
    end
    return self.list[self.count]
end

function Stack:clear()
    for k,v in pairs(self.map) do
        self.map[k] = nil;
    end
    for k,v in pairs(self.list) do
        self.list[k] = nil;
    end
    self.count = 0;
end

return Stack


    --[[
    local function f(test)
        print("---------------------size-", test:size())
        print("---------------------isempty", test:empty())
    end
    local test = Stack:new()
    f(test)
    local t1 = {}
    print(test:push(t1))

    print(test:pop(t1))

    print(test:size())
    --]]