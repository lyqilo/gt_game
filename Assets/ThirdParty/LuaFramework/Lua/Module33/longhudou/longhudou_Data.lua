longhudou_Data = {};
local self = longhudou_Data;

self.icon_res = nil;
self.numres = nil;
self.soundres = nil;
self.luabe = nil;
self.lockColIndex = 0;
self.isResCom = 0;

function longhudou_Data.distory(args)
    self.allshowitem = {};
    self.curSelectChoum = 1000;
    self.numrollingcont = {};
    self.choumtable = {1000,2000,3000,4000,5000};
    self.myinfoData = {};

    self.openImg = {1,5,8,1,1,1,4,7,7,7,0,3,6,9,9};--开奖的图片
    self.openWinImg = {};
    self.maxlong = {};
--     stGameReslData
--    {
--	    INT32 bymoney;	//金币
--	    BYTE byIcon;	//图标
--	    BYTE byKey;		//几连
--	    BYTE byCnt;		//X几倍
--    };
    self.allOpenRate = 0;--总倍率
    self.lineWinScore = 0;--连线赢得的总分
    self.byFreeCnt = 0;--免费次数
    self.isFreeGameing = false;--是不是在免费中

    self.isResCom = 0;

    self.isshowmygold = true;
    self.lastshwogold = 0;

    self.isAutoGame = false;--是不是自动游戏

    self.curGameIndex = 0;--当前请求的次数
    if not IsNil(self.saveSound) then
       destroy(self.saveSound);
       self.saveSound = nil;
    end
    self.isruning = false;
    self.bgan = nil;
    self.isPalyFreeAnima = false;
    self.freeAllGold = 0;
    self.lockColIndex = 0;
    self.baseRate = 30;--基础倍数
    self.baseRunMoneyTimer = 30;--跑金币公式的时间

    self.istssound = false;--就是第一个黑将是不是在前三列

    self.istihuan = false;--是不是运动的时候 替换图片 免费第一次的时候 会出现黑色的修改
    self.autoRunNum = 0;
    self.caijin = 0;
    self.winCaijin = 0;
end

--游戏的结算
function longhudou_Data.gameOver(buff)
     self.openImg = {};
     self.openWinImg = {};
     self.maxlong = {};
     local img = 0xFF;
     self.istssound = false;
     local str=""
     for i=1,longhudou_CMD.D_ALL_COUNT do
         img = buff:ReadByte();
         str=str..img
         if i%5==0 then
             str=str.."\n"
         end
         table.insert(self.openImg,i,img);
         if self.istssound==false and img==longhudou_Config.tiger and 0<(i%5) and (i%5)<4 then
            self.istssound = true;
         end
     end

     logYellow("游戏具体值")
     logYellow(str)
     local windata = nil;
     for a=1,10 do
         windata = {};
         windata.byIcon = buff:ReadByte();
         windata.byKey = buff:ReadByte();
         buff:ReadByte();
         buff:ReadByte();
         buff:ReadByte();
         if windata.byKey>0 or longhudou_Config.tiger==windata.byIcon then
            error("___getwin__11__"..windata.byIcon.."____"..windata.byKey);
            table.insert(self.openWinImg,#self.openWinImg+1,windata);
         end
     end
    logYellow("本局具体信息")
    logTable(self.openWinImg)

    self.allOpenRate = 0;--总倍率
    self.lineWinScore = buff:ReadUInt32();  
    local freenum = buff:ReadByte();--免费次数
    self.winCaijin = buff:ReadUInt32(); 
    local _pos=buff:ReadByte()+1

     if _pos>=1 and _pos<=5 then
        if self.openImg[_pos]==8 then
            self.openImg[_pos+5]=self.RanNumber()
            self.openImg[_pos+10]=self.RanNumber()
        end 
     end

     logYellow("连线赢得的总分=="..self.lineWinScore)
     logYellow("免费次数=="..freenum)
     logYellow("本局获得彩金=="..self.winCaijin)
     logYellow("_pos==".._pos)
     logTable(self.openImg)

    self.creatOpen();
    self.isshowmygold = false;
    self.isPalyFreeAnima = false; 
    if freenum>0 and self.byFreeCnt==0 then
       --error("__111__freenum_11__"..freenum);
       self.isPalyFreeAnima = true;
       self.istihuan = true;
    end
    self.isFreeGameing = false;
    if self.byFreeCnt>0 then
       self.isFreeGameing = true;
    end
    if self.byFreeCnt>0 or freenum>0 then
       local islong = false;      
       
       for w=1,5 do
           islong = true;
           for q=1,3 do
               if self.openImg[w+(3-q)*5] ~= longhudou_Config.wild then
                  islong = false;
                  break;
               end
           end 

           if islong == true then
              self.openImg[w+10] = longhudou_Config.maxwild3;
              self.openImg[w+5] = longhudou_Config.maxwild2;
              self.openImg[w] = longhudou_Config.maxwild1;
              longhudou_Event.dispathEvent(longhudou_Event.xiongm_long_move,w); 
           end           
       end 

    end
    self.byFreeCnt = freenum;
    if self.byFreeCnt>0 or self.freeAllGold>0 then
        self.freeAllGold = self.freeAllGold+self.lineWinScore;
    end
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_start); 
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,false); 
    local runnum = 5;
    if self.lockColIndex>0 then
      runnum = self.lockColIndex;
    end
    if runnum>5 then
       return; 
    end
    for d = 1,runnum do
        longhudou_Event.dispathEvent(longhudou_Event.xiangqi_over,{curindex = d,maxtimer=8,jiantimer=0.2});
    end
end

function longhudou_Data.RanNumber()
    local num=math.random(0,7)
    return num
end

function longhudou_Data.isFreeGameWild()
   local re = false;
   if self.isFreeGameing == true then
       local islong = false;
       for w=1,5 do
           islong = false;
           for q=1,3 do
               if self.openImg[w+(3-q)*5] == longhudou_Config.wild then
                  islong = true;
                  break;
               end
           end 
           if islong == true then
           error("______longhudou_Data______isFreeGameWild____________");
              self.openImg[w+10] = longhudou_Config.maxwild3;
              self.openImg[w+5] = longhudou_Config.maxwild2;
              self.openImg[w] = longhudou_Config.maxwild1;
              re = true;
           end
       end 
   end
   return re;
end

-- 黑将的时候 前4列如何有2个将以上 后面要用特殊转动
function longhudou_Data.creatOpen()
  local num = 0;
  self.lockColIndex = 0;
  local firstvalue = longhudou_Config.tiger;
  for a=1,4 do
       for i=1,3 do
           if self.openImg[a+(3-i)*5] ==firstvalue then
              num = num +1;
           end
       end
       if num>=2 then
          self.lockColIndex = a;
          return;
       end       
  end
end

function longhudou_Data.caijinchang(buff)
   self.caijin = buff:ReadUInt32();
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_caijin_chang,nil);
end


local Number=0

function longhudou_Data.Number_Zero()
   Number=0
end

function longhudou_Data.gameSence(buff)


	longhudou_LianLine.IsStartGame=true;
    Number=Number+1
    
    self.choumtable = {};    
    --error("____gameSence_____");
    local n1=buff:ReadUInt32();
    if Number==1 then
        self.curSelectChoum = n1    
    end

    local ChipLimit = buff:ReadUInt32();
    local fchoum = 0;
    for i=1,5 do
       fchoum = buff:ReadUInt32();
        error("____1__curSelectChoum_____"..fchoum);
       table.insert(self.choumtable,i,fchoum);
    end
   
    self.byFreeCnt = buff:ReadByte();--免费次数
    self.caijin = buff:ReadUInt32();--免费次数
    --error("______byFreeCnt_______"..self.byFreeCnt);
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_init,nil);
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_caijin_chang,nil);

    logYellow("当前下注金币=="..self.curSelectChoum)
    logYellow("ChipLimit=="..ChipLimit)
    logYellow("具体下注")
    logTable(self.choumtable)
    logYellow("免费次数=="..self.byFreeCnt)
    logYellow("彩金=="..self.caijin)

    local freerun = function(args)
        local falg=true;
        while falg do
            coroutine.wait(0.5);
            if longhudou_Data.isResCom ==2 then 
                falg=false;
                self.isInitFreeRun();
            end
        end
    end
    coroutine.start(freerun);

end

function longhudou_Data.isInitFreeRun()
   if self.byFreeCnt>0 then
       longhudou_Socket.isongame =true;
       longhudou_Socket.gameOneOver(false);
       if self.byFreeCnt>0 then
          longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_free_btn);
       end
    end
end


--自己的信息改变
function longhudou_Data.myinfoChang()
    self.myinfoData = {};
    self.myinfoData._1dwUser_Id = TableUserInfo._1dwUser_Id;
    self.myinfoData._2szNickName = TableUserInfo._2szNickName;
    self.myinfoData._3bySex = TableUserInfo._3bySex;
    self.myinfoData._4bCustomHeader = TableUserInfo._4bCustomHeader;
    self.myinfoData._5szHeaderExtensionName =TableUserInfo._5szHeaderExtensionName;
    self.myinfoData._6szSign = TableUserInfo._6szSign;
    self.myinfoData._7wGold = TableUserInfo._7wGold;
    self.myinfoData._8wPrize = TableUserInfo._8wPrize;
    self.myinfoData._9wChairID = TableUserInfo._9wChairID;
    self.myinfoData._10wTableID = TableUserInfo._10wTableID;
    self.myinfoData._11byUserStatus = TableUserInfo._11byUserStatus;
    --error("______myinfoChang_______"..self.myinfoData._7wGold);
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_gold_chang,nil);
end

