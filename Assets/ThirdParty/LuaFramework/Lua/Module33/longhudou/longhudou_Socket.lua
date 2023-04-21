


longhudou_Socket = {}

local self = longhudou_Socket;

local wTableID; --桌子号

self.myChairID = -1;

self.isReqDataIng = false;--是不是在请求游戏的数据中
self.isongame =false;
self.isreqStart=true
self.isOver=true;

--加入游戏消息事件
function longhudou_Socket.addGameMessge()
    
    EventCallBackTable._01_GameInfo = longhudou_Socket.OnHandleGameInfo; --游戏消息
    EventCallBackTable._02_ScenInfo = longhudou_Socket.OnHandleScenInfo; --场景消息
    EventCallBackTable._03_LogonSuccess = longhudou_Socket.OnGameLogonWin; --登陆成功
    EventCallBackTable._04_LogonOver = longhudou_Socket.OnGameLogonOver; --登陆完成
    EventCallBackTable._05_LogonFailed = longhudou_Socket.OnGameLogonLost; --登陆失败
    EventCallBackTable._06_Biao_Action = longhudou_Socket.onBiaoAction; --表情
    EventCallBackTable._07_UserEnter = longhudou_Socket.onPlayerEnter; --用户进入
    EventCallBackTable._08_UserLeave = longhudou_Socket.OnPlayerLeave; --用户离开
    EventCallBackTable._09_UserStatus = longhudou_Socket.OnPlyaerStatus; --用户状态
    EventCallBackTable._10_UserScore = longhudou_Socket.OnUserScore; --用户分数
    EventCallBackTable._11_GameQuit = longhudou_Socket.onGameQuit; --退出游戏
    EventCallBackTable._12_OnSit = longhudou_Socket.onInSeatOver; --用户入座
    EventCallBackTable._13_ChangeTable = longhudou_Socket.onChageTable;  --换桌
    EventCallBackTable._14_RoomBreakLine = longhudou_Socket.onRoomBreakLine; --断线消息
    EventCallBackTable._15_OnBackGame = longhudou_Socket.onBackGame; --断线消息
    EventCallBackTable._16_OnHelp = longhudou_Socket.onHelp; --帮助

  
    --EventCallBackTable._01_GameInfo(1, 1, 1, 1);

    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);
    
end
function longhudou_Socket.onBackGame(args)
    logYellow("回到游戏=="..tostring(self.isreqStart))
    if self.isreqStart then
        longhudou_InitProt.Reconnect()
    end
end

function longhudou_Socket.onHelp(args)
    longhudou_Rule.show();
end
--发送登陆数据结构
self.CMD_GR_LogonByUserID = 
{
    [1] = DataSize.UInt32,  --广场版本 暂时不用
    [2] = DataSize.UInt32,  --进程版本 暂时不用
    [3] = DataSize.UInt32,  --用户 I D
    [4] = DataSize.String33, --登录密码 MD5小写加密
    [5] = DataSize.String100, --机器序列 暂时不用
    [6] = DataSize.byte, --补位
    [7] = DataSize.byte, --补位
}

--用户登陆
function longhudou_Socket.playerLogon()
    
    --coroutine.wait(1);

    error("登陆游戏。。00。。");

    local data = 
    {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword ,	 --登录密码 MD5小写加密
        [5] = Opcodes,	 --机器序列 暂时不用
        [6] = 0,
        [7] = 0, 
    }

    local buffer = SetC2SInfo(self.CMD_GR_LogonByUserID, data);

    --Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_USERID, buffer, gameSocketNumber.GameSocket);   
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket);

end

--玩家入座
function longhudou_Socket.playerInSeat()

    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);

end

--用户准备
-- 客户端游戏场景准备好了，准备接收场景消息
self.CMD_GF_Info = 
{
    [1] = DataSize.byte,   --旁观标志 必须等于0
}
function  longhudou_Socket.playerPrepare()
    
    error("==========发送用户准备==========");
    local Data = { [1] = 0, } --旁观标志 必须等于0
    local buffer = SetC2SInfo(self.CMD_GF_Info, Data);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);

end


--登陆成功
function longhudou_Socket.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)

    error("=============OnGameLogonWin============= " .. TableUserInfo._10wTableID);

    wTableID = TableUserInfo._9wChairID; 

end


--登陆完成
function longhudou_Socket.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)

    error("=============OnGameLogonOver============= 桌子ID");

    if(65535 == wTableID) then --不在桌子上
        self.playerInSeat();
    else --若在桌子上 则直接发送玩家准备
        self.playerPrepare();
    end

end

--登陆失败
function longhudou_Socket.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============");
end


--入座完成
function longhudou_Socket.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    
    if(wSize > 0) then
        error("=============入座失败=============");
    else
        error("=============入座成功=============");
        self.playerPrepare();
    end    
    
end

--用户进入
function longhudou_Socket.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    
    error("=============用户进入============= chairID " ..TableUserInfo._1dwUser_Id );
    --error("用户进入。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    error("________onPlayerEnter_____________"..SCPlayerInfo._01dwUser_Id);
    if(TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
       return;
    end
    
   longhudou_Data.myinfoChang();
end

--用户离开
function longhudou_Socket.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    self.isreflushScore = true;
    --UserListSp.reflush();
end


--用户状态
function longhudou_Socket.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    
    --error("=============用户状态============= chairID " ..TableUserInfo._9wChairID );

end


--用户分数
function longhudou_Socket.OnUserScore(wMaiID, wSubID, buffer, wSize)
    
   -- error("=============用户分数============= chairID " ..TableUserInfo._9wChairID );
    if(TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
       return;
    end
    --error("______OnUserScore_______");
    longhudou_Data.myinfoChang();

end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function longhudou_Socket.onChageTable(wMaiID, wSubID, buffer, wSize)
    error("================换桌============");
end

--退出游戏
function longhudou_Socket.onGameQuit(wMaiID, wSubID, buffer, wSize)

    --[[if(point21PlayerTab[myChairID + 1].allChipNumInt > 0) then --在游戏中 弹出提示
        Point21ScenCtrlPanel.titleImage.gameObject:SetActive(true);
    else --不在游戏中 直接退出
        Point21ScenCtrlPanel.gameQuit();
    end]]
    error("________直接退出_________");
    longhudou_Data.Number_Zero()
    self.initdataandres(1);    
    GameSetsBtnInfo.LuaGameQuit();    
end

function longhudou_Socket.initdataandres(args)
    self.isongame =false;    
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_exit,nil);
    if args==1 then
       longhudou_Event.dispathEvent(longhudou_Event.xiangqi_unload_game_res,nil);
    else
        longhudou_Data.icon_res = nil;
        longhudou_Data.numres = nil;
        longhudou_Data.soundres = nil;
        longhudou_Data.isResCom = 0;
    end
    longhudou_Event.destroying();
    self.distory();
    longhudou_Data.distory();    
    MessgeEventRegister.Game_Messge_Un();
end

function longhudou_Socket.distory(args)
   self.myChairID = -1;

   self.isReqDataIng = false;--是不是在请求游戏的数据中
end

--表情
function longhudou_Socket.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    
    error("================表情================ " );

   --[[ local sChairId = buffer:ReadUInt16();
    local sIndex = buffer:ReadByte();

    point21PlayerTab[sChairId + 1]:playExpression(sIndex);]]

end

--断线消息
function longhudou_Socket.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    error("======11==========断线===============");
   -- Point21ScenCtrlPanel.gameQuit();
end



--游戏消息
function longhudou_Socket.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    
--    error("游戏。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);

--    if self.isongame ==false  then
--       return;
--    end
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );
    error("=============游戏消息============= sid : " .. sid.."________长度__________"..wSize);

    if sid == longhudou_CMD.SUB_SC_GAME_START then
        logYellow("服务器返回开始游戏")
       longhudou_Data.gameOver(buffer);
    elseif sid == longhudou_CMD.SUB_SC_GAME_CAI_JIN then
        logYellow("刷新彩金")
       longhudou_Data.caijinchang(buffer)
    end
end




--场景消息
function longhudou_Socket.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    error("====11=========场景消息============="..wSize);
    self.isReqSamllClick = false;    
    longhudou_Data.gameSence(buffer);
    self.isongame =true;
    GameSetsBtnInfo.SetPlaySuonaPos(0,349,0);
end

--播放声
--isbgsound true 播放的是音乐 不然就是音效, isplay 是背景音乐的时候 它是播放还是停止
function longhudou_Socket.playaudio(audioname,isbgsound,isplay,issave)
    local musicchip = longhudou_Data.soundres.transform:Find(audioname):GetComponent('AudioSource').clip;
    if isbgsound == true then
       longhudou_Data.bgan = audioname;
       if issave==true then
          MusicManager:PlayBacksoundX(musicchip,isplay);
       else
         MusicManager:PlayBacksoundX(musicchip,isplay);
       end
       
    elseif issave==true then
       longhudou_Data.saveSound = MusicManager:PlayX(musicchip).gameObject;
    else
      return MusicManager:PlayX(musicchip).gameObject;
    end    
end

function longhudou_Socket.stopallaudio()
    if longhudou_Data.bgan~= nil and  longhudou_Data.bgan~= "bg" then
       MusicManager:PlayBacksound("end",false);
       longhudou_Socket.playaudio("bg",true,true,true);
       longhudou_Data.bgan= nil;
    end
    
end

self.reqnum = 0;
function longhudou_Socket.reqStart()
    if self.isReqDataIng == true then
      return;
    end
    if self.isongame ==false  then
       return;
    end  
    if longhudou_Data.autoRunNum>0 and longhudou_Data.isAutoGame==true and longhudou_Data.byFreeCnt==0 then
       longhudou_Data.autoRunNum = math.max(longhudou_Data.autoRunNum-1,0);
    end
    longhudou_Data.curGameIndex = longhudou_Data.curGameIndex+1;
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_colse_line_anima);
    self.SendUserReady();
    self.isReqDataIng = true;
    longhudou_Data.isshowmygold = true;    


    if longhudou_Data.byFreeCnt>0 or longhudou_Data.freeAllGold>0 then
    else
        longhudou_Data.myinfoData._7wGold=longhudou_Data.myinfoData._7wGold-longhudou_Data.curSelectChoum*30       
        longhudou_Event.dispathEvent(longhudou_Event.xiongm_gold_chang,true); 
    end
    self.isOver=false
    local bf = ByteBuffer.New();
    bf:WriteUInt32(longhudou_Data.curSelectChoum);
    Network.Send(MH.MDM_GF_GAME, longhudou_CMD.SUB_CS_GAME_START, bf, gameSocketNumber.GameSocket);  
    self.isreqStart=false
    logYellow("发送开始游戏")
   --self.reqnum = self.reqnum+1;
    --error("原先次数——————"..self.reqnum);
end

function longhudou_Socket.ShowMessageBox(strTitle, iBtnCount,yesfun)
    iBtnCount = iBtnCount or 1;
    local tab = GeneralTipsSystem_ShowInfo;
    tab._01_Title = "";
    tab._02_Content = strTitle;
    tab._03_ButtonNum = iBtnCount;
    tab._04_YesCallFunction = yesfun;
    tab._05_NoCallFunction = nil;
    MessageBox.CreatGeneralTipsPanel(tab);
end

--发送用户准备（游戏中）
function longhudou_Socket.SendUserReady()
    
    error("=====游戏中=====发送用户准备==========");
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket);

end
function longhudou_Socket.gameOneOver2(isauto)
    self.isOver=true
   if longhudou_Data.byFreeCnt>0 or longhudou_Data.isAutoGame==true then
      coroutine.start(function(args)
          coroutine.wait(1);
          self.gameOneOver(isauto);
      end);
    else
        self.gameOneOver(isauto);
   end
end

--一次游戏完成 isauto 是不是在update里面检测发出的
function longhudou_Socket.gameOneOver(isauto)
    longhudou_LianLine.IsStartGame=false;
    if isauto==false then
      self.isReqDataIng = false;
   end
   if self.isReqDataIng==false then
       --error("__111_gameOneOver________");
   end
   if longhudou_Data.isruning == true then
      return;
   end   

   if longhudou_Data.byFreeCnt==0 and longhudou_Data.freeAllGold>0 then
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_free_all_gold);
      return;
   end

   if longhudou_Data.byFreeCnt>0 then
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_bg,1);
   else
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_bg,2);
   end

    longhudou_Event.dispathEvent(longhudou_Event.xiongm_mianf_btn_mode);
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_title_mode);

   if longhudou_Data.byFreeCnt>0 then
   else
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);  
    end

   if longhudou_Data.byFreeCnt==0 then
        longhudou_Data.isFreeing = false;--是不是免费模式中 
    end 

    self.isreqStart=true

    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
    else
        return
    end
    if GameManager.IsStopGame then
        return 
    end

    longhudou_LianLine.IsStartGame=false;
   if isauto==false and longhudou_Data.byFreeCnt>=1 then
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_free_num_chang);
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_click);
      self.reqStart();      
      return;
   end
   
   if isauto==true and self.isReqDataIng==false then
      if toInt64(longhudou_Data.curSelectChoum*longhudou_Data.baseRate)>toInt64(longhudou_Data.myinfoData._7wGold) then
          self.ShowMessageBox("金币不够",1,nil);
          longhudou_Data.isAutoGame = false;
          longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_start_btn);
          longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);
          return;
       end
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_click);
      self.reqStart();
      return;
   end
   if longhudou_Data.isAutoGame==true and self.isReqDataIng==false then
       if toInt64(longhudou_Data.curSelectChoum*longhudou_Data.baseRate)>toInt64(longhudou_Data.myinfoData._7wGold) then
          self.ShowMessageBox("金币不够",1,nil);
          longhudou_Data.isAutoGame = false;
          longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_start_btn);
          longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);
          return;
       end
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_no_start_btn);
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_click);
      self.reqStart();
      return;
   end   
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_start_btn,nil);
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);
end