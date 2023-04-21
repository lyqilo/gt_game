Queue = {}

function Queue:new()
    local copy = {}
    setmetatable(copy, {__index = self})
    copy.count = 0;
    copy.map = {};
    copy.list = {};
    return copy
end

--得到栈内元素数量
function Queue:size()
    return self.count;
end

--栈是否为空
function Queue:empty()
    return (self.count == 0)
end

function Queue:contain(value)
    if self.map[value] then
        return true;
    else
        return false
    end
end

--得到栈顶元素  栈顶元素,空返回nil
function Queue:peek()
    if self.count == 0 then
        return nil
    end
    return self.list[1];
end

--出栈.返回删除的元素,空返回nil    
function Queue:dequeue()
    local tmp = self:peek()
    if tmp ~= nil then
        self.map[self.list[1]] = nil;
        table.remove(self.list,1);
        self.count = self.count - 1;
    end
    return tmp
end

--入栈.
function Queue:enqueue(value)
    table.insert(self.list, value)
    self.map[value] = true;
    self.count = self.count + 1;
    return self.count;
end

function Queue:clear()
    for k,v in pairs(self.map) do
        self.map[k] = nil;
    end
    for k,v in pairs(self.list) do
        self.list[k] = nil;
    end
    self.count = 0;
end