xiangqi_Win_Gold = {};
local self =xiangqi_Win_Gold;

self.guikey = "cn";
self.per = nil;
self.winGoldroll = nil;
self.addgold = 0;--增加的钱
self.isclose = true;
self.isdispathgameover = false;--是不是这轮游戏结束
self.ftar = nil;--由那个发出的
function xiangqi_Win_Gold.setPer(args)
   self.init();
   self.per = args;
   self.guikey = xiangqi_Event.guid();
   self.per.gameObject:SetActive(false);
   self.addEvent();
   self.moneycont = self.per.transform:Find("numcont");
   self.winGoldroll = xiangqi_NumRolling:New();
   self.winGoldroll:setfun(self,self.winGoldRollCom,self.winGoldRollIng);
   table.insert(xiangqi_Data.numrollingcont,#xiangqi_Data.numrollingcont+1,self.winGoldroll);


end

function xiangqi_Win_Gold.init(args)
    self.guikey = "cn";
    self.per = nil;
    self.winGoldroll = nil;
    self.addgold = 0;--增加的钱
    self.isclose = true;
    self.isdispathgameover = false;--是不是这轮游戏结束
    self.ftar = nil;--由那个发出的
end

function xiangqi_Win_Gold.winGoldRollCom(obj,args)
    self.per.gameObject:SetActive(false);
   if self.isclose == false then
      coroutine.start(function (args)
         self.isclose = true;
         coroutine.wait(1);
         if xiangqi_Socket.isongame==false then
            return;
           end
         xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_gold_roll_com,self.ftar);
         if self.isclose == true then
          
           self.isclose = false;
         end         
    end);
   end

end

function xiangqi_Win_Gold.winGoldRollIng(obj,args)
    xiangqi_PushFun.CreatShowNum(self.moneycont,args,"win_",false,82,2,430,-200);
end

function xiangqi_Win_Gold.addEvent()
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_win_gold,self.showWinGold,self.guikey);
end

function xiangqi_Win_Gold.isDispathGameOver()
    if self.isdispathgameover==true then
         coroutine.start(function()
             --coroutine.wait(1);
             --MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_show_free);
             --MyBelieveSlot_Socket.isReqDataIng  = false;
             --MyBelieveSlot_Socket.gameOneOver(false);
      end);
    end
end
function xiangqi_Win_Gold.showWinGold(args)
    ----error("__000___showWinGold_________");
   if self.per.gameObject.activeSelf==true then
      return;
   end
    --error("_111____showWinGold_________");
   self.per.gameObject:SetActive(true);
    xiangqi_PushFun.CreatShowNum(self.moneycont,args.data.addgold,"win_",false,82,2,430,-200);
   coroutine.start(function()
        coroutine.wait(1);
        if xiangqi_Socket.isongame==false then
           return;
        end
        self.doShowWinGold(args);
   end);
   
end

--{isdispathgameover=false,ftar=MyBelieveSlot_Config.starlin,addgold=0,rate=0,emoney=0,smoney=0,durtimer=0}
function xiangqi_Win_Gold.doShowWinGold(args)
   
--   self.isdispathgameover = args.data.isdispathgameover;--是不是这轮游戏结束
--   self.ftar = args.data.ftar;--由那个发出的
--   if args.data.addgold<=0 then
--      --self.isDispathGameOver();
--       if MyBelieveSlot_Data.isAutoGame ==false then
--          MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_close_choum_mask);
--       end
--      MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_gold_roll_com,self.ftar);
--      return;
--   end
--   local tsanimatype = 1;
--   local durtimer = args.data.durtimer;
--   if args.data.rate>=600 then
--      MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_show_tes_anima,1);
--      durtimer = 3;
--      MyBelieveSlot_Data.winsound =  MyBelieveSlot_Socket.playaudio(MyBelieveSlot_Config.s_supermaxwin);
--   elseif args.data.rate>=180 then
--      MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_show_tes_anima,2);
--      durtimer = 3;
--      MyBelieveSlot_Data.winsound =  MyBelieveSlot_Socket.playaudio(MyBelieveSlot_Config.s_maxwin);
--   else
--     MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_show_tes_anima,0);
--     durtimer = 1.5;
--     MyBelieveSlot_Data.winsound = MyBelieveSlot_Socket.playaudio(MyBelieveSlot_Config.s_win);
--   end

--   self.isclose = false;
--   self.addgold = args.data.addgold;
--   local emoney = args.data.emoney;
--   local smoney = args.data.smoney;
--   MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_gold_chang,{money=MyBelieveSlot_Data.lastshwogold+self.addgold,mtime=durtimer});
--   --error("_____showWinGold_________"..MyBelieveSlot_Data.lastshwogold.."_______________"..self.addgold);
--   self.winGoldroll:setdata(smoney,emoney,durtimer);
end

function xiangqi_Win_Gold.removeEvent()

end

