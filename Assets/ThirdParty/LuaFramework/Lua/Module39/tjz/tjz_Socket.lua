


tjz_Socket = {}

local self = tjz_Socket;

local wTableID; --桌子号

self.myChairID = -1;

self.isReqDataIng = false;--是不是在请求游戏的数据中
self.isongame =false;
self.isreqStart=true;


--加入游戏消息事件
function tjz_Socket.addGameMessge()
    
    EventCallBackTable._01_GameInfo = tjz_Socket.OnHandleGameInfo; --游戏消息
    EventCallBackTable._02_ScenInfo = tjz_Socket.OnHandleScenInfo; --场景消息
    EventCallBackTable._03_LogonSuccess = tjz_Socket.OnGameLogonWin; --登陆成功
    EventCallBackTable._04_LogonOver = tjz_Socket.OnGameLogonOver; --登陆完成
    EventCallBackTable._05_LogonFailed = tjz_Socket.OnGameLogonLost; --登陆失败
    EventCallBackTable._06_Biao_Action = tjz_Socket.onBiaoAction; --表情
    EventCallBackTable._07_UserEnter = tjz_Socket.onPlayerEnter; --用户进入
    EventCallBackTable._08_UserLeave = tjz_Socket.OnPlayerLeave; --用户离开
    EventCallBackTable._09_UserStatus = tjz_Socket.OnPlyaerStatus; --用户状态
    EventCallBackTable._10_UserScore = tjz_Socket.OnUserScore; --用户分数
    EventCallBackTable._11_GameQuit = tjz_Socket.onGameQuit; --退出游戏
    EventCallBackTable._12_OnSit = tjz_Socket.onInSeatOver; --用户入座
    EventCallBackTable._13_ChangeTable = tjz_Socket.onChageTable;  --换桌
    EventCallBackTable._14_RoomBreakLine = tjz_Socket.onRoomBreakLine; --断线消息
    EventCallBackTable._15_OnBackGame = tjz_Socket.onBackGame; --断线消息
    EventCallBackTable._16_OnHelp = tjz_Socket.onHelp; --帮助

  
    --EventCallBackTable._01_GameInfo(1, 1, 1, 1);

    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);
    
end
function tjz_Socket.onBackGame(args)
    logYellow("回到游戏=="..tostring(self.isreqStart))
    if self.isreqStart then
        tjz_InitProt.Reconnect()
    end
end

function tjz_Socket.onHelp(args)
    tjz_Rule.show();
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
function tjz_Socket.playerLogon()
    
    --coroutine.wait(1);

    error("登陆游戏。。。。");

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
function tjz_Socket.playerInSeat()

    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);

end

--用户准备
-- 客户端游戏场景准备好了，准备接收场景消息
self.CMD_GF_Info = 
{
    [1] = DataSize.byte,   --旁观标志 必须等于0
}

function  tjz_Socket.playerPrepare()
    
    error("==========发送用户准备==========");
    local Data = { [1] = 0, } --旁观标志 必须等于0
    local buffer = SetC2SInfo(self.CMD_GF_Info, Data);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);

end


--登陆成功
function tjz_Socket.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)

    error("=============OnGameLogonWin============= " .. TableUserInfo._10wTableID);

    wTableID = TableUserInfo._9wChairID; 

end


--登陆完成
function tjz_Socket.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)

    error("=============OnGameLogonOver============= 桌子ID=="..wTableID);

    if(65535 == wTableID) then --不在桌子上
        self.playerInSeat();
    else --若在桌子上 则直接发送玩家准备
        self.playerPrepare();
    end

end

--登陆失败
function tjz_Socket.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============");
end


--入座完成
function tjz_Socket.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    
    if(wSize > 0) then
        HallScenPanel.NetException("Failed to enter room", gameSocketNumber.GameSocket);
        error("=============入座失败=============");
    else
        error("=============入座成功=============");
        self.playerPrepare();
    end    
    
end

--用户进入
function tjz_Socket.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    error("=============用户进入============= chairID " ..TableUserInfo._1dwUser_Id );
    --error("用户进入。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    error("________onPlayerEnter_____________"..SCPlayerInfo._01dwUser_Id);
    if(TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
       return;
    end

   tjz_Data.myinfoChang();
end

--用户离开
function tjz_Socket.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    self.isreflushScore = true;
    --UserListSp.reflush();
end


--用户状态
function tjz_Socket.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    
    --error("=============用户状态============= chairID " ..TableUserInfo._9wChairID );

end


--用户分数
function tjz_Socket.OnUserScore(wMaiID, wSubID, buffer, wSize)
    
   -- error("=============用户分数============= chairID " ..TableUserInfo._9wChairID );
    if(TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
       return;
    end
    --error("______OnUserScore_______");
    tjz_Data.myinfoChang();

end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function tjz_Socket.onChageTable(wMaiID, wSubID, buffer, wSize)
    error("================换桌============");
end

--退出游戏
function tjz_Socket.onGameQuit(wMaiID, wSubID, buffer, wSize)

    --[[if(point21PlayerTab[myChairID + 1].allChipNumInt > 0) then --在游戏中 弹出提示
        Point21ScenCtrlPanel.titleImage.gameObject:SetActive(true);
    else --不在游戏中 直接退出
        Point21ScenCtrlPanel.gameQuit();
    end]]
    error("________直接退出_________");
    tjz_Data.Number_Zero()
    self.initdataandres(1);
    GameSetsBtnInfo.LuaGameQuit();    
end

function tjz_Socket.initdataandres(args)
    self.isongame =false;
    tjz_Event.dispathEvent(tjz_Event.xiongm_exit,nil);
    if args==1 then
       tjz_Event.dispathEvent(tjz_Event.xiongm_unload_game_res,nil);
    end
    tjz_Event.destroying();
    self.distory();
    tjz_Data.distory();    
    MessgeEventRegister.Game_Messge_Un();
end

function tjz_Socket.distory(args)
   self.myChairID = -1;

   self.isReqDataIng = false;--是不是在请求游戏的数据中
end

--表情
function tjz_Socket.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    
    error("================表情================ " );

   --[[ local sChairId = buffer:ReadUInt16();
    local sIndex = buffer:ReadByte();

    point21PlayerTab[sChairId + 1]:playExpression(sIndex);]]

end

--断线消息
function tjz_Socket.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    error("================断线===============");
   -- Point21ScenCtrlPanel.gameQuit();
end



--游戏消息
function tjz_Socket.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    
    ----error("游戏。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);

--    if self.isongame ==false  then
--       return;
--    end
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );
    error("=============游戏消息============= sid : " .. sid.."________长度__________"..wSize);
    
    if sid == tjz_CMD.SUB_SC_GAME_OVER then--是否游戏结束
       tjz_Data.gameOver(buffer);
    end

end

--场景消息
function tjz_Socket.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    error("====11=========场景消息============="..wSize);
    self.isReqSamllClick = false;
    tjz_Data.gameSence(buffer);
    self.isongame =true;

end

--播放声
--isbgsound true 播放的是音乐 不然就是音效, isplay 是背景音乐的时候 它是播放还是停止
function tjz_Socket.playaudio(audioname,isbgsound,isplay,issave)
    local musicchip = tjz_Data.soundres.transform:Find(audioname):GetComponent('AudioSource').clip;
    if isbgsound == true then
       MusicManager:PlayBacksoundX(musicchip,isplay);
    elseif issave==true then
       tjz_Data.saveSound = MusicManager:PlayX(musicchip).gameObject;
    else
      return MusicManager:PlayX(musicchip).gameObject;
    end    
end



self.reqnum = 0;
--==================================开始游戏================================================--
function tjz_Socket.reqStart()

    if self.isReqDataIng == true then
      return;
    end

    if self.isongame ==false or tjz_Data.isResCom~=2 then
       return;
    end 

    --return;
    --error("reqStart————");
    tjz_Event.dispathEvent(tjz_Event.xiongm_start); 
    tjz_Data.isshowmygold = true;
    if tjz_Data.autoRunNum>0 and tjz_Data.isAutoGame==true and tjz_Data.byFreeCnt==0 and not tjz_Data.bReturn then
       tjz_Data.autoRunNum = math.max(tjz_Data.autoRunNum-1,0);
    end

    if tjz_Data.byFreeCnt>0 or tjz_Data.bReturn then
       tjz_Data.isshowmygold = false;
    end

    tjz_Data.curGameIndex = tjz_Data.curGameIndex+1;
    tjz_Event.dispathEvent(tjz_Event.xiongm_colse_line_anima);
    self.SendUserReady();
    self.isReqDataIng = true;
    --tjz_Data.isshowmygold = true;  
 

    logYellow("curSelectChoum=="..tjz_Data.curSelectChoum)
    local bf = ByteBuffer.New();
    bf:WriteUInt32(tjz_Data.curSelectChoum);--下注金额
    Network.Send(MH.MDM_GF_GAME, tjz_CMD.SUB_CS_GAME_START, bf, gameSocketNumber.GameSocket);  
    self.isreqStart=false

    --self.reqnum = self.reqnum+1;
    --error("原先次数——————"..self.reqnum);
end

function tjz_Socket.ShowMessageBox(strTitle, iBtnCount,yesfun)
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
function tjz_Socket.SendUserReady()
    
    --error("=====游戏中=====发送用户准备==========");
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket);

end

function tjz_Socket.gameOneOver2(isauto)
        if tjz_Data.byFreeCnt>0 or tjz_Data.isAutoGame==true then
            coroutine.start(function(args)
                tjz_Data.isshowmygold = true;
                tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
                coroutine.wait(1);
                if tjz_Socket.isongame==false then
                    return;
                end
              self.gameOneOver(isauto);
          end);
        else
            self.gameOneOver(isauto);
       end
end


--一次游戏完成 isauto 是不是在update里面检测发出的
function tjz_Socket.gameOneOver(isauto)
   error("__00__tjz_Data.bFireMode_____"..tjz_Data.byFreeCnt);
   if isauto==false then
      self.isReqDataIng = false;
   end
   if self.isReqDataIng==false then
       --error("__111_gameOneOver________");
   end

   if tjz_Data.isruning == true then
      return;
   end

    tjz_Data.isshowmygold = true;
    tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
   
   if tjz_Data.byFreeCnt==0 then
        tjz_Data.isFreeing = false;--是不是免费模式中 
    end 

    if tjz_Data.byFreeCnt==0 and tjz_Data.bReturn and tjz_Data.byUpProcess>0 then

    else
        tjz_Event.dispathEvent(tjz_Event.xiongm_mianf_btn_mode);   
    end 

    tjz_Event.dispathEvent(tjz_Event.xiongm_title_mode);
    

    self.isreqStart=true
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

    else
        return
    end
    if GameManager.IsStopGame then
        return 
    end

    if tjz_Data.bReturn==true then
        tjz_Event.dispathEvent(tjz_Event.xiongm_move_gudi);
        --error("________xiongm_move_gudi_______");
         tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_click);
        self.reqStart();      
        return;
    else
        tjz_Event.dispathEvent(tjz_Event.xiongm_close_gudi); 
    end

    if tjz_Data.byFreeCnt>0 then
       tjz_Socket.playaudio("freebg",true,true);
    else
       tjz_Socket.playaudio("noramlbg",true,true);
   end 

   if isauto==false and tjz_Data.byFreeCnt>=1 then
      tjz_Event.dispathEvent(tjz_Event.xiongm_show_free_num_chang);
      tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_click);
      self.reqStart();      
      return;
   end 
   
   if tjz_Data.byFreeCnt>0 or tjz_Data.isAutoGame==true then
   else
       tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_no_inter,true);  
    end
   
    if isauto==true and self.isReqDataIng==false then
        if toInt64(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)>toInt64(tjz_Data.myinfoData._7wGold) then
          self.ShowMessageBox("金币不够",1,nil);
          tjz_Data.isAutoGame = false;
          tjz_Event.dispathEvent(tjz_Event.xiongm_show_start_btn);
          tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_no_inter,true);
          return;
       end
       tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_click);
      self.reqStart();
      return;
   end
   if tjz_Data.isAutoGame==true and self.isReqDataIng==false then
       if toInt64(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)>toInt64(tjz_Data.myinfoData._7wGold) then
          self.ShowMessageBox("金币不够",1,nil);
          tjz_Data.isAutoGame = false;
          tjz_Event.dispathEvent(tjz_Event.xiongm_show_start_btn);
          tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_no_inter,true);
          return;
       end
        tjz_Data.isshowmygold = true
        tjz_Data.myinfoData._7wGold=tjz_Data.myinfoData._7wGold-(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)
        error("更新金币2222为："..tjz_Data.myinfoData._7wGold)
        tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_no_start_btn);
       tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_click);
      self.reqStart();
      return;
   end   
   tjz_Event.dispathEvent(tjz_Event.xiongm_show_start_btn,nil);
end