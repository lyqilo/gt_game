xiangqi_Data = {};
local self = xiangqi_Data;

self.icon_res = nil;
self.numres = nil;
self.soundres = nil;
self.luabe = nil;
self.lockColIndex = 0;
self.isResCom = 0;

function xiangqi_Data.distory(args)
    self.allshowitem = {};
    self.curSelectChoum = 1000;
    self.numrollingcont = {};
    self.choumtable = {1000,2000,3000,4000,5000};
    self.myinfoData = {};

    self.openImg = {1,5,8,1,1,1,4,7,7,7,0,3,6,9,9};--开奖的图片
    self.openWinImg = {};
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

    self.isResCom = 0;

    self.isshowmygold = true;
    self.lastshwogold = 0;

    self.isAutoGame = false;--是不是自动游戏

    self.curGameIndex = 0;--当前请求的次数

    self.saveSound = nil;
    self.isruning = false;

    self.isPalyFreeAnima = false;
    self.freeAllGold = 0;
    self.lockColIndex = 0;
    self.baseRate = 30;--基础倍数
    self.baseRunMoneyTimer = 30;--跑金币公式的时间

    self.istssound = false;--就是第一个黑将是不是在前三列

    self.istihuan = false;--是不是运动的时候 替换图片 免费第一次的时候 会出现黑色的修改
    self.autoRunNum = 0;
end

--游戏的结算
function xiangqi_Data.gameOver(buff)
	logError("***************************游戏结果******************************************")
     self.openImg = {};
     self.openWinImg = {};
     local img = 0xFF;
     self.istssound = false;
     for i=1,xiangqi_CMD.D_ALL_COUNT do
         img = buff:ReadInt32();
         table.insert(self.openImg,i,img);
         if self.istssound==false and img==xiangqi_Config.general and 0<(i%5) and (i%5)<4 then
            self.istssound = true;
         end
     end
     local wincont = buff:ReadByte();
     error("_img_wincont_111_"..wincont);
     local windata = nil;
     for a=1,4 do
         windata = {};
         windata.bymoney = buff:ReadInt32();
         windata.byIcon = buff:ReadByte();
         windata.byKey = buff:ReadByte();
         windata.byCnt = buff:ReadByte();
         if a<=wincont then
            error("___getwin__11__"..windata.byIcon.."____"..windata.byKey);
            table.insert(self.openWinImg,a,windata);
         end
     end
 
    self.allOpenRate = buff:ReadInt32();--总倍率
    self.lineWinScore =tonumber(buff:ReadInt64Str()) 
	logError("赢的总分="..self.lineWinScore)
    local freenum = buff:ReadByte();--免费次数
	
	logError("免费次数="..freenum)
    self.creatOpen();
    self.isshowmygold = false;
    self.isPalyFreeAnima = false; 
    if freenum>0 and self.byFreeCnt==0 then
       --error("__111__freenum_11__"..freenum);
       self.isPalyFreeAnima = true;
       self.istihuan = true;
    end
    self.byFreeCnt = freenum;
    if self.byFreeCnt>0 or self.freeAllGold>0 then
        self.freeAllGold = self.freeAllGold+self.lineWinScore;
    end
     --error("__22__freenum__11_"..freenum);
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start); 
    --xiangqi_Event.dispathEvent(xiangqi_Event.xiangqi_over); 
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start_btn_no_inter,false); 
    local runnum = 5;
    if self.lockColIndex>0 then
      runnum = self.lockColIndex;
    end
    if runnum>5 then
       return; 
    end
    for d = 1,runnum do
        xiangqi_Event.dispathEvent(xiangqi_Event.xiangqi_over,{curindex = d,maxtimer=8,jiantimer=0.2});
    end
    
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start_btn_no_inter,false); 
end

-- 黑将的时候 前4列如何有2个将以上 后面要用特殊转动
function xiangqi_Data.creatOpen()
  local num = 0;
  self.lockColIndex = 0;
  local firstvalue = xiangqi_Config.general;
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

function xiangqi_Data.gameSence(buff)
    self.choumtable = {};    
    --error("____gameSence_____");
    local fchoum = 0;
    for i=1,5 do
       fchoum = buff:ReadInt32();
       table.insert(self.choumtable,i,fchoum);
    end
    self.curSelectChoum = buff:ReadInt32();
    
    self.byFreeCnt = buff:ReadByte();--免费次数
    --error("______byFreeCnt_______"..self.byFreeCnt);
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_init,nil);
--    local freerun = function(args)
--          if xiangqi_Data.isResCom==2 then
--             self.isInitFreeRun();
--          else
--            coroutine.wait(0.5);
--            coroutine.start(freerun);
--          end
--     end
--     coroutine.start(freerun);
    logYellow("选择下注=="..self.curSelectChoum)
    logYellow("免费次数=="..self.byFreeCnt)

local freerun = function(args)
        local falg=true;
        while falg do
            coroutine.wait(0.5);
            if xiangqi_Data.isResCom ==2 then 
                falg=false;
                self.isInitFreeRun();
            end
        end
    end
    coroutine.start(freerun);

end

function xiangqi_Data.isInitFreeRun()
   if self.byFreeCnt>0 then
       xiangqi_Socket.isongame =true;
       xiangqi_Socket.gameOneOver(false);
       if self.byFreeCnt>0 then
          xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_free_btn);
       end
    end
end


--自己的信息改变
function xiangqi_Data.myinfoChang()
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
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_gold_chang,nil);
end

