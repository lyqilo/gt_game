--数字的滚动


longhudou_NumRolling = {};
local  self = longhudou_NumRolling;

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
self.onceStop = false;


function longhudou_NumRolling:New()
   local go = {};
   setmetatable(go,{__index = self});
   return go;
end
 


-- snum 开始数字
-- enum 结束数字
-- dtimer 时间
-- callobj 要回调的对象
-- callcom 运动完成
-- callupdate 中间更新
function longhudou_NumRolling:setdata(snum,enum,dtimer)
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
   self.onceStop = false;
   self.agenum = (enum-snum)/dtimer;--平均值
   self.snum = snum;--开始值
   self.enum = enum;--结束值
   self.etimer = dtimer;--结束时间   
end

function longhudou_NumRolling:getisrun()
  return self.isrun;
end

function longhudou_NumRolling:setfun(callobj,callcom,callupdate)
   self.callobj = callobj;
   self.callcom = callcom;
   self.callupdate = callupdate;
end

function longhudou_NumRolling:update()
   if self.isrun == false then
      return;
   end
   self.timernum = self.timernum + Time.deltaTime;
   self.curnum  = math.ceil(self.timernum*self.agenum)+self.snum;
   local numbool = false;
   if self.agenum<0 and self.curnum<=self.enum then
      numbool = true;
   end
   if self.agenum>0 and self.curnum>=self.enum then
      numbool = true;
   end
   if self.timernum>=self.etimer or numbool or self.onceStop then
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
