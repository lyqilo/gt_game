--数字的滚动


numRolling = {};
local  self = numRolling;

self.timernum = 0;
self.isrun = false;  
self.agenum = 0;--平均值
self.snum = 0;--开始值
self.enum = 0;--结束值
self.etimer = 0;--结束时间
self.callobj = nil;
self.callcom = nil;
self.callupdate = nil;
self.curnum = 0;


function numRolling:New()
   local go = {};
   setmetatable(go,self);
   self.__index = numRolling;
   return go;
end
 


-- snum 开始数字
-- enum 结束数字
-- dtimer 时间
-- callobj 要回调的对象
-- callcom 运动完成
-- callupdate 中间更新
function numRolling:setdata(snum,enum,dtimer)
   if self.isrun == true then
      return;
   end

   self.timernum = 0;
   self.isrun = false;  
   self.agenum = 0;--平均值
   self.snum = 0;--开始值
   self.enum = 0;--结束值
   self.etimer = 0;--结束时间
   self.curnum = 0;--当前值

   self.isrun = true;
   self.agenum = (enum-snum)/dtimer;--平均值
   self.snum = snum;--开始值
   self.enum = enum;--结束值
   self.etimer = dtimer;--结束时间   
end

function numRolling:getisrun()
  return self.isrun;
end

function numRolling:setfun(callobj,callcom,callupdate)
   self.callobj = callobj;
   self.callcom = callcom;
   self.callupdate = callupdate;
end

function numRolling:update()
   if self.isrun == false then
      return;
   end
   self.timernum = self.timernum + Time.deltaTime;
   self.curnum  = math.ceil(self.timernum*self.agenum)+self.snum;
   if self.timernum>=self.etimer or self.curnum>=self.enum then
      if self.callupdate~=nil then
         self.callupdate(self.callobj,self.enum);
      end
      self.isrun = false;
      if self.callcom~=nil then
         self.callcom(self.callobj,self.enum);
      end      
   else
     if self.callupdate~=nil then
        self.callupdate(self.callobj,self.curnum);
     end
   end
   
end
