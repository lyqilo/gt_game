--数字的滚动

BirdsAndBeast_numRolling = {}
local self = BirdsAndBeast_numRolling

self.timernum = 0
self.isrun = false
self.agenum = 0 --平均值
self.snum = 0 --开始值
self.enum = 0 --结束值
self.etimer = 0 --结束时间
self.callobj = nil
self.callcom = nil
self.callupdate = nil
self.curnum = 0

function BirdsAndBeast_numRolling:New()
    local go = {}
    setmetatable(go, self)
    self.__index = BirdsAndBeast_numRolling
    return go
end

-- snum 开始数字
-- enum 结束数字
-- dtimer 时间
-- callobj 要回调的对象
-- callcom 运动完成
-- callupdate 中间更新
function BirdsAndBeast_numRolling:setdata(snum, enum, dtimer, agenum)
    if self.isrun == true then
        return
    end

    self.timernum = 0
    self.isrun = false
    self.agenum = 0 --平均值
    self.snum = 0 --开始值
    self.enum = 0 --结束值
    self.etimer = 0 --结束时间
    self.curnum = 0 --当前值
    local fage = 0
    self.isrun = true
    if enum > snum then
        fage = tostring((enum - snum) / dtimer)
        self.agenum = tonumber(fage) --平均值
        self.isAdd = true;
    else
        fage = tostring((snum - enum) / dtimer)
        self.agenum = tonumber(fage) --平均值
        self.isAdd = false;
    end
    log("平均值：" .. fage)
    self.snum = snum --开始值
    self.enum = enum --结束值
    self.etimer = dtimer --结束时间
end

function BirdsAndBeast_numRolling:getisrun()
    return self.isrun
end

function BirdsAndBeast_numRolling:setfun(callobj, callcom, callupdate)
    self.callobj = callobj
    self.callcom = callcom
    self.callupdate = callupdate
end

function BirdsAndBeast_numRolling:update()
    if self.isrun == false then
        return
    end
    local fnum = 0;
   self.timernum = self.timernum + Time.deltaTime;
   if (self.isAdd == true) then
      --self.curnum = self.snum + self.agenum;
      fnum = math.ceil(self.timernum*self.agenum)+self.snum;
   else
      --self.curnum = self.snum - self.agenum;
      fnum = self.snum - math.ceil(self.timernum*self.agenum)
   end
   if fnum == self.curnum then
      return;
   end
   self.curnum = fnum;
     --刷新
   if self.callupdate ~= nil then
      self.callupdate(self.callobj, self.curnum)
   end
   if (self.isAdd) then
      if self.timernum >= self.etimer or self.curnum >= self.enum then
         self.isrun = false;
         if self.callcom~=nil then
            self.callcom(self.callobj,self.enum);
         end      
      end
   else
      if self.timernum >= self.etimer or self.curnum <= self.enum then
         self.isrun = false;
         if self.callcom~=nil then
            self.callcom(self.callobj,self.enum);
         end      
      end
   end
end
