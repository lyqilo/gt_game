NiuNiuPlayer = { };
--local self = NiuNiuPlayer;

local ChoosePokerNum = 0;

local palyerchairid = 0;
local NiuNiuChooseChipTable = { 1, 10, 100, 1000, 10000, 100000, 1000000 };

local dTime = 0;
function NiuNiuPlayer:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end
-- 绑定lua代码
function NiuNiuPlayer.CreatPlayer(chairid)

end

function NiuNiuPlayer:Start(obj)--玩家数据初始化
    self.transform = obj.transform;--各个玩家的对象
    self.playerobj = obj;
    local luaBehaviour = self.transform:GetComponent("LuaBehaviour");
    self.luaBehaviour = luaBehaviour;
    self.chipvalue = 0;--下注金额
    self.chairid = -100;--座位号
    self:FindCompent();--玩家基本信息初始化
    self.palyerinfo = { };

    -- 是否操作
    self.bOperate = 0;

    --是否在游戏中
    self.IsPlayingGame=0;

    --是否显示
    self.ISDIS=false;

    -- 是否抢庄
    self.bRobBanker = 0;

    -- 下注值（最小）
    self.i64ChipValue =toInt64(0);

    -- 牛牛点数（0到10）
    self.byNiuNiuPoint = 0;

    -- 扑克数据
    self.playerPoker = { 0, 0, 0, 0, 0 };

    -- 赢金币
    self.i64WinScore = 0;

    -- 是否正在播放表情
    self.IsExpress = false;  

    -- 是否播放庄动画
    self.IsMoveBanker = false;

    -- 赢次数
    --self.winCount = 0;

    -- 牛牛次数
    --self.niuniuCount = 0;

    -- 默认(座位)没有玩家

    -- 抢庄总时间，经过时间
    -- 准备时间

    -- 配牌时间

    -- 是否是中途进入

    -- 开始配牌时间

    -- 设置总输赢
  --  self.AllWinLoseScore = 0;
end

-- 用户进入（初始化状态） 刚刚进入
function NiuNiuPlayer:InitInfo(chairid)
    self.chipvalue = 0;
    self.chairid = chairid;--自己座位id
    self.playerobj:SetActive(true);
    self.info:SetActive(true);
    self.SetChip:SetActive(false);
    self:SetChangeBg(false);
    self.IsStartBanker:SetActive(false);

    local posnum = self.chairid - NiuNiuMH.MySelf_ChairID;
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    NiuNiuPanel.LeavePlayerImg.transform:GetChild(posnum).gameObject:SetActive(false);

    self.info.name = "Info" .. self.chairid;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    self.winCount = 0;
    self.niuniuCount = 0;
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(self.palyerinfo._7wGold);--自己现有的金币
    NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold,nil);

    --self:SetGold(0);
    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;--自己的昵称
    local width = self.info.transform:Find("Name"):GetComponent('Text').preferredWidth;
    local height = self.info.transform:Find("Name"):GetComponent('Text').preferredHeight;
    self.info.transform:Find("Name"):GetComponent("RectTransform").sizeDelta = Vector2.New(width, height);
    local imgurl = "";
    self.info.transform:Find("Head/Head"):GetComponent("RectTransform").sizeDelta=Vector2.New(90,90);

    --设置系统默认头像
    self:SetHead();

    --自己设置头像
    if (self.palyerinfo._4bCustomHeader > 0) then
        imgurl = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" ..
        self.palyerinfo._1dwUser_Id .. "." .. self.palyerinfo._5szHeaderExtensionName;
        local  headstr = self.palyerinfo._1dwUser_Id .. "." .. self.palyerinfo._5szHeaderExtensionName;
        UpdateFile.downHead(imgurl,headstr,nil,self.info.transform:Find("Head/Head").gameObject);
    else
    end

    self.Timer:SetActive(false);

    -- 其他玩家进入在抢庄时进入（可以加入游戏）
    if chairid ~= NiuNiuMH.MySelf_ChairID then        
        if NiuNiuMH.Playing_State == NiuNiuMH.SUB_SC_ROB_BANKER and self.bOperate == 0 then
            self.IsPlayingGame=1;
            self:IsShowTimer(true, NiuNiuMH.D_TIMER_ROB_BANKER, NiuNiuMH.Playing_Time*1000);
        --elseif NiuNiuMH.Playing_State>3 and  NiuNiuMH.Playing_State< 8 then
        elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_GAME_RESULT then
            self.IsPlayingGame=1;
        else
            self.IsPlayingGame=0;
        end
        else

        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.GetHeadIcon();
    end
end
--设置金币显示
function NiuNiuPlayer:SetGold(num)
    local n=NiuNiuMH.PlayerScore-num;
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(n);--自己现有的金币
    NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, n,nil);
end
--设置金币显示
function NiuNiuPlayer:SetBankGold(id)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(self.palyerinfo._7wGold);--自己现有的金币
    NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold, nil);
end
--设置头像
function NiuNiuPlayer:SetHead()
    if self.palyerinfo._3bySex==enum_Sex.E_SEX_MAN then 
        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.nanSprtie;
    elseif self.palyerinfo._3bySex==enum_Sex.E_SEX_WOMAN then 
        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.nvSprtie
    else
        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.nanSprtie;
    end
    local index = math.random(1,10);
    self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.headIcons.transform:GetChild(index-1):GetComponent("Image").sprite;
end


-- 用户场景
function NiuNiuPlayer:SetInitValue(data, passTime)

    --error("用户场景")
    if data[1]<0 then 
        self.playerobj:SetActive(false);
        self.info:SetActive(false);
    else
        self.playerobj:SetActive(true);
        self.info:SetActive(true);
    end

    --隐藏自己的牌
    self.ThinkingPoker:SetActive(false);

    --加载牌的背面图片
    for i = 1, self.ThinkingPoker.transform.childCount do
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').color = Color.New(1, 1, 1, 1);
    end
    self.Result:SetActive(false);
    self.playerobj.transform.localScale=Vector3.New(1,1,1);
    
    -- 自己座位号
    self.chairid = data[1];
    -- 是否在游戏
    --self.IsPlayingGame = data[2];
    if data[2]==1 then
        self.IsPlayingGame = 0;
    else
        self.IsPlayingGame = 1;
    end

    -- 是否操作
    self.bOperate = data[3];

    -- 是否抢庄
    self.bRobBanker = data[4];

    -- 下注值（最小）
    self.i64ChipValue = data[5];

    -- 牛牛点数（0到13）
    self.byNiuNiuPoint = data[6];

    -- 扑克数据
    self.playerPoker = data[7];

    -- 赢金币
    self.i64WinScore = data[8];

    -- 赢次数
    -- self.winCount = data[9];
    -- 牛牛次数
    -- self.niuniuCount = data[10];
    -- 总输赢
    -- self.AllWinLoseScore = data[11];

    self.IsStartBanker:SetActive(false);

    --判断自己是否是庄家，是就表示在游戏
    if self.chairid == NiuNiuMH.Banker_ChairID then 
        self.IsPlayingGame = 1 
    end


    --空状态
    if NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_NULL then
        self.IsPlayingGame = 1;
        error("空状态=============");
        self.IsPlayingGame = 1;
        self:IsShowTimer(false, 0, 0)
        if self.chairid == NiuNiuMH.MySelf_ChairID and self.IsPlayingGame == 1 then
         -- error("自己空状态=============");
            NiuNiu_IsGameStartIn = false;
            NiuNiuMH.Game_State = 0;
            NiuNiuPanel.SetShowBtn()
        end
    -- 抢庄
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_ROB_BANKER then
        NiuNiuMH.Playing_State=0;
        self.IsPlayingGame=1;
        error("抢庄============="..self.bOperate);
        if self.bOperate == 1 then
            -- 已经操作过枪庄
            self:IsShowTimer(false, 0, 0)
            if self.bRobBanker == 1 then
                self:SetBankerText(true)
            else
                self:SetBankerText(false)
            end          
        elseif self.bOperate == 0 then
            -- 没有操作过抢庄（显示进度条）根据当前操作的玩家显示
            self:IsShowTimer(false, 0, 0)
            self.IsStartBanker:SetActive(false);
            if data[1] == NiuNiuMH.MySelf_ChairID and self.IsPlayingGame == 1 then
                --error("自己进入的时候为抢庄，显示倒计时");
                NiuNiuMH.Game_State = 1;
                NiuNiuPanel.SetShowBtn()
                local  needtime = math.floor(passTime/ 1000);
                NiuNiuPanel.TimerMusic(needtime);
            end
           self:IsShowTimer(true, NiuNiuMH.D_TIMER_ROB_BANKER, passTime);
        end
    -- 下注
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_CHIP then
        error("下注============="..self.bOperate);
        if  self.bOperate == 0 then
            self.IsPlayingGame = 1;
            self:IsShowTimer(false, 0, 0)
            --error(" -- 已经下过注了（需要创建筹码移动到中心位置）");
            self:PlayingChipAnimator(self.i64ChipValue);
        elseif self.bOperate == 1 then
            if self.chairid ~= NiuNiuMH.Banker_ChairID then 
                self:IsShowTimer(true, NiuNiuMH.D_TIMER_CHIP, passTime); 
            end
            if self.chairid == NiuNiuMH.MySelf_ChairID and self.IsPlayingGame == 1 then
                NiuNiuMH.Game_State = 2;
                NiuNiuPanel.SetShowBtn()
            end
        end
        --error("确定庄家动画")
        if self.chairid == NiuNiuMH.Banker_ChairID or NiuNiuMH.Game_State>1 then
            local bankernum =(NiuNiuMH.Banker_ChairID - NiuNiuMH.MySelf_ChairID);
            if bankernum < 0 then bankernum = bankernum + NiuNiuMH.GAME_PLAYER end
            NiuNiuPanel.BankerAnimator(bankernum);-- body
        end;

    --发牌
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_SEND_POKER then
            --error("确定庄家动画")
        if self.chairid == NiuNiuMH.Banker_ChairID or NiuNiuMH.Game_State>1 then
            local bankernum =(NiuNiuMH.Banker_ChairID - NiuNiuMH.MySelf_ChairID);
            if bankernum < 0 then bankernum = bankernum + NiuNiuMH.GAME_PLAYER end
            NiuNiuPanel.BankerAnimator(bankernum);-- body
        end;
        error("发牌============="..self.i64ChipValue);
        if self.i64ChipValue>0 then self.IsPlayingGame = 1 end

        if self.IsPlayingGame == 0 then return end

        self.ThinkingPoker:SetActive(true);
        self:PlayingChipAnimator(self.i64ChipValue);
        
        if self.playerPoker[1]>0 then self.ThinkingPoker:SetActive(true) end;--判断扑克数据是否为空

        if self.chairid == NiuNiuMH.MySelf_ChairID then
            for i = 1, self.ThinkingPoker.transform.childCount do
                --local tb=NiuNiuPanel.Ten2tTwo(self.playerPoker[i])
                --local pokernum=tb[1]*13+tb[2]
                local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
            end
        else
            for i = 1, self.ThinkingPoker.transform.childCount do
                local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                --local tb=NiuNiuPanel.Ten2tTwo(self.playerPoker[i])
                --local pokernum=tb[1]*13+tb[2]
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
            end
        end
    -- 开牌
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_OPEN_POKER then
        error("开牌")
        --error("确定庄家动画")
            if self.chairid == NiuNiuMH.Banker_ChairID or NiuNiuMH.Game_State>1 then
                local bankernum =(NiuNiuMH.Banker_ChairID - NiuNiuMH.MySelf_ChairID);
                if bankernum < 0 then bankernum = bankernum + NiuNiuMH.GAME_PLAYER end
                NiuNiuPanel.BankerAnimator(bankernum);-- body
            end;
        --如果下注金额大于0或者是庄家      
        if self.i64ChipValue> 0 or self.chairid==NiuNiuMH.Banker_ChairID then 
            self.IsPlayingGame = 1; 
            self.ThinkingPoker:SetActive(true);
        end

        if self.chairid<0 then 
            self.IsPlayingGame = 0; 
            self.ThinkingPoker:SetActive(false); 
        end

        if self.IsPlayingGame == 0 then return end
        --error("开牌=="..self.IsPlayingGame)
        if self.bOperate == 1 then
            self:IsShowTimer(false, 0, 0);
            self.ThinkingPoker:SetActive(true);
            --self:OutPoker(self.byNiuNiuPoint, self.playerPoker);
            self.Poker_Over:SetActive(true);
        elseif self.bOperate == 0 then
            self:IsShowTimer(true, NiuNiuMH.D_TIMER_OPEN_POKER, passTime);        
            if self.playerPoker[1]>0 then self.ThinkingPoker:SetActive(true) end;

            if self.chairid == NiuNiuMH.MySelf_ChairID then
                NiuNiuMH.Game_State = 3;
                NiuNiuPanel.SetShowBtn()
                for i = 1, self.ThinkingPoker.transform.childCount do
                    --local tb=NiuNiuPanel.Ten2tTwo(self.playerPoker[i])
                    --local pokernum=tb[1]*13+tb[2]
                    local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                    self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
                end
            end
        end
    --游戏结算
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_GAME_RESULT then
        --error("确定庄家动画")
        if self.chairid == NiuNiuMH.Banker_ChairID or NiuNiuMH.Game_State>1 then
            local bankernum =(NiuNiuMH.Banker_ChairID - NiuNiuMH.MySelf_ChairID);
            if bankernum < 0 then bankernum = bankernum + NiuNiuMH.GAME_PLAYER end
            NiuNiuPanel.BankerAnimator(bankernum);-- body
        end;
        self.IsPlayingGame = 1;
        NiuNiuMH.Playing_Time=0;
        self.ThinkingPoker:SetActive(false);
        return;
    --游戏结束
    elseif NiuNiuMH.Game_State == NiuNiuMH.D_GAME_STATE_GAME_END then
        error("-- 游戏结束");
        self:GameOver();
     end
end


--玩家基本信息配置（初始化..默认不显示）
function NiuNiuPlayer:FindCompent()
    -- 玩家基础信息
    self.info = self.transform:Find("Info").gameObject;
    -- self.info.name = "Info" .. self.chairid;
    self.info:SetActive(false);

    --配牌完成
    self.Poker_Over = self.transform:Find("Over").gameObject;
    self.Poker_Over:SetActive(false);
    
    --是否为庄家
    self.BankerImg=self.transform:Find("Banker").gameObject;
    self.BankerImg:SetActive(false);
    self.BankerAnimator=self.BankerImg:GetComponent("Animator")

    --error("隐藏玩家基础信息");
    -- 玩家思考牌型状态（没牛状态）
    self.ThinkingPoker = self.transform:Find("ThinkingPoker").gameObject;
        if self.chairid ~= NiuNiuMH.MySelf_ChairID then
            for i=1,self.ThinkingPoker.transform.childCount do 
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite--翻牌
            end
        end
    self.ThinkingPoker:SetActive(false);

    -- 牛牛结果及加减金币
    self.Result = self.transform:Find("Result").gameObject;
    self.Result:SetActive(false);

    -- 倒计时
    self.Timer = self.transform:Find("Timer").gameObject;
    self.TimeImg=self.Timer.transform:GetChild(0):GetComponent("Image");
    for i=1,self.Timer.transform.childCount-1 do
        self.Timer.transform:GetChild(0).gameObject:SetActive(false); 
    end
    self.Timer:SetActive(false);

    -- 开始枪庄字样
    self.IsStartBanker = self.transform:Find("IsBanker").gameObject;
    self.IsStartBanker:SetActive(false);  
    self.IsStartBanker.transform:GetChild(0).gameObject:SetActive(true);
    self.IsStartBanker.transform:GetChild(1).gameObject:SetActive(false);
    --self.endpos=self.ThinkingPoker.transform.position;
    self.startpos = self.Result.transform:Find("TextBg").localPosition + Vector3.New(0, 0, 0);
    self.speedtime = 2;
    self.Height = 80;
    self.Wight = 100;

    -- 牌型位置
    self.startpokerpos = self.ThinkingPoker.transform.localPosition;

    -- 庄家/玩家头像图切换对象
    self.ChangeImg = self.info.transform:Find("Image").gameObject;

    --设置显示下注
    self.SetChip=self.transform.transform:Find("SetChip").gameObject;
    self.SetChip:SetActive(false);
    self.StartAni = false;


    -- 玩家离开显示默认头像
    -- 筹码创建父物体
    self.ChipArea = self.transform:Find("ChipArea").gameObject;
    self.ChipArea:SetActive(false);
    -- 表情父物体
    self.BiaoQingFather = self.transform:Find("BiaoQing").gameObject;

end

--显示是否抢庄
function NiuNiuPlayer:SetBankerText(IsShow)
    if self.chairid < 0 then return end;
    self.IsPlayingGame = 1;
    if IsShow then
        self.IsStartBanker.transform:GetChild(0).gameObject:SetActive(true);
        self.IsStartBanker.transform:GetChild(1).gameObject:SetActive(false);
        self.IsStartBanker:SetActive(true);
    else
        self.IsStartBanker.transform:GetChild(0).gameObject:SetActive(false);
        self.IsStartBanker.transform:GetChild(1).gameObject:SetActive(true);
        self.IsStartBanker:SetActive(true);
    end
end


-- 发牌
function NiuNiuPlayer:SendPoker()
    --判断是否可以发牌
    if self.chairid < 0 then return end;
    if self.IsPlayingGame == 0 then return end;
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    self.ThinkingPoker.transform.localPosition = self.startpokerpos
    self:IsShowTimer(false, 0, 0);

    local posnum =(NiuNiuMH.Banker_ChairID - NiuNiuMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end

    if NiuNiuPanel.AllPlayerFather.transform:GetChild(posnum) then
        local  niuniubanker = NiuNiuPanel.AllPlayerFather.transform:GetChild(posnum).gameObject;
     
        for i = 1, self.ThinkingPoker.transform.childCount do
            self.ThinkingPoker.transform:GetChild(i - 1).position = Vector3.New(niuniubanker.transform.position.x, niuniubanker.transform.position.y, 2000);
        end
    end



    local startpos = -110;
    local pokerdis = 35;
    self.ThinkingPoker:SetActive(true);

    if self.chairid == NiuNiuMH.MySelf_ChairID then
        pokerdis = pokerdis + 60;
    end

    for i = 1, self.ThinkingPoker.transform.childCount do

        if GameNextScenName ~= gameScenName.Game03 then return end;

        local tweener = self.ThinkingPoker.transform:GetChild(i - 1):DOLocalMove(Vector3.New(startpos + pokerdis *(i - 1), 0, 0), 0.8, false);

        if GameNextScenName ~= gameScenName.Game03 then return end;

        tweener:SetEase(DG.Tweening.Ease.InCubic);

        if GameNextScenName ~= gameScenName.Game03 then return end;

        local chip = NiuNiuPanel.Musicprefeb.transform:Find("Snd_SendCard"):GetComponent('AudioSource').clip
        MusicManager:PlayX(chip);
        coroutine.wait(0.2);
    end

end

self.movenum=0;
self.jishu=0;
self.IsTimeUpdate=false;

-- 配牌/叫庄/下注 倒计时(包含显示与否)
function NiuNiuPlayer:IsShowTimer(byshowtimer, alltime, oldtime)
    --byshowtimer false  true  是否需要开始计时
    --alltime   当前状态的总时间；
    --oldtime   已经经过的时间
    if self.chairid < 0 then  return end;
    if self.IsPlayingGame == 0 then  return end;
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    --local count=self.Timer.transform.childCount
    if byshowtimer then
        self.Timer.transform:GetComponent("Image").fillAmount = 1;
        
        for i=1,4 do 
            self.Timer.transform:GetChild(i-1):GetComponent("Image").fillAmount = 0;
        end

        self.jishu = 1 /((alltime / 1000));

        local dis = self.jishu *(oldtime / 1000);
        local needtime =(alltime - oldtime) / 1000;
        self.movenum = dis;
        self.timerimg=0

        if self.movenum<0.25  then
            self.TimeImg=self.Timer.transform:GetChild(0):GetComponent("Image");  
            self.Timer.transform:GetChild(0).gameObject:SetActive(true);
            self.Timer.transform:GetChild(1).gameObject:SetActive(false);
            self.Timer.transform:GetChild(2).gameObject:SetActive(false);
            self.Timer.transform:GetChild(3).gameObject:SetActive(false);
            self.timerimg=1
        elseif self.movenum<0.5  then  
            self.TimeImg=self.Timer.transform:GetChild(1):GetComponent("Image");  
            self.Timer.transform:GetChild(0).gameObject:SetActive(false);
            self.Timer.transform:GetChild(1).gameObject:SetActive(true);
            self.Timer.transform:GetChild(2).gameObject:SetActive(false);
            self.Timer.transform:GetChild(3).gameObject:SetActive(false);
            self.timerimg=2
        elseif self.movenum<0.75  then 
            self.TimeImg=self.Timer.transform:GetChild(2):GetComponent("Image");  
            self.Timer.transform:GetChild(0).gameObject:SetActive(false);
            self.Timer.transform:GetChild(1).gameObject:SetActive(false);
            self.Timer.transform:GetChild(2).gameObject:SetActive(true);
            self.Timer.transform:GetChild(3).gameObject:SetActive(false);
            self.timerimg=3
        elseif self.movenum>0.75  then 
            self.TimeImg=self.Timer.transform:GetChild(3):GetComponent("Image");  
            self.Timer.transform:GetChild(0).gameObject:SetActive(false);
            self.Timer.transform:GetChild(1).gameObject:SetActive(false);
            self.Timer.transform:GetChild(2).gameObject:SetActive(false);
            self.Timer.transform:GetChild(3).gameObject:SetActive(true);
            self.timerimg=4
        end 
        self.TimeImg.fillAmount = 1- dis;
        self.IsTimeUpdate = true;
        self.Timer:SetActive(true);
    else
        self.TimeImg.fillAmount =0;
        self.Timer:SetActive(false);
        self.IsTimeUpdate = false;
    end
end

function NiuNiuPlayer:TimerUpdate()
    if self.IsTimeUpdate and self.Timer.activeSelf  then
        self.movenum = self.movenum + self.jishu*Time.deltaTime;
        if self.movenum>0 and self.movenum<0.25  then
        if self.timerimg==0 then 
        self.timerimg=1
        self.Timer.transform:GetChild(0).gameObject:SetActive(true);
        self.Timer.transform:GetChild(1).gameObject:SetActive(false);
        self.Timer.transform:GetChild(2).gameObject:SetActive(false);
        self.Timer.transform:GetChild(3).gameObject:SetActive(false);
        self.TimeImg=self.Timer.transform:GetChild(0):GetComponent("Image");  
        end
        elseif self.movenum>0.25 and self.movenum<0.51   then 
        if self.timerimg==1 then 
        self.timerimg=2
        self.Timer.transform:GetChild(0).gameObject:SetActive(false);
        self.Timer.transform:GetChild(1).gameObject:SetActive(true);
        self.Timer.transform:GetChild(2).gameObject:SetActive(false);
        self.Timer.transform:GetChild(3).gameObject:SetActive(false);
        self.TimeImg=self.Timer.transform:GetChild(1):GetComponent("Image");  
        end
        elseif self.movenum>0.51 and self.movenum<0.75  then 
        if self.timerimg==2 then 
        self.timerimg=3
        self.Timer.transform:GetChild(0).gameObject:SetActive(false);
        self.Timer.transform:GetChild(1).gameObject:SetActive(false);
        self.Timer.transform:GetChild(2).gameObject:SetActive(true);
        self.Timer.transform:GetChild(3).gameObject:SetActive(false);
        self.TimeImg=self.Timer.transform:GetChild(2):GetComponent("Image");  
        end
        elseif self.movenum>0.75 and  self.timerimg==3 then 
        self.timerimg=4
        self.Timer.transform:GetChild(0).gameObject:SetActive(false);
        self.Timer.transform:GetChild(1).gameObject:SetActive(false);
        self.Timer.transform:GetChild(2).gameObject:SetActive(false);
        self.Timer.transform:GetChild(3).gameObject:SetActive(true);
        self.TimeImg=self.Timer.transform:GetChild(3):GetComponent("Image");  
        end  
        self.TimeImg.fillAmount =1- self.movenum;
        if 1 - self.movenum <= 0 then
            IsTimeUpdate = false;
            if GameNextScenName ~= gameScenName.Game03 then return end;
            self.Timer:SetActive(false);
            self.timerimg=0
            self.TimeImg=self.Timer.transform:GetChild(0):GetComponent("Image"); 
            if 1 - self.movenum <= 0 and self.chairid == NiuNiuMH.MySelf_ChairID then
                NiuNiuMH.Game_State = 65535;
                NiuNiuPanel.SetShowBtn();
            end
        end
    end
end

-- 开始下注（倒计时/清除上局信息）
function NiuNiuPlayer:StartChip()
    self.IsStartBanker:SetActive(false);
    if self.chairid < 0 then return end;
    if self.IsPlayingGame == 0 then return end;
    if self.chairid == NiuNiuMH.Banker_ChairID then return end
    self:IsShowTimer(false, 0, 0);
    self:IsShowTimer(true, NiuNiuMH.D_TIMER_CHIP, 0);
end

-- 开始开牌（把Think版型显示出来）（计时应用）V
function NiuNiuPlayer:StartOpenPoker()
    self.IsStartBanker:SetActive(false);
    if self.chairid < 0 then return end;
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    if self.i64ChipValue> 0 or self.chairid==NiuNiuMH.Banker_ChairID then

        self.IsPlayingGame = 1;
    end

    if self.IsPlayingGame == 0 then return end;
    self:IsShowTimer(false, 0, 0);
    self:IsShowTimer(true, NiuNiuMH.D_TIMER_OPEN_POKER, 0);
    self.ThinkingPoker:SetActive(true);
end

-- 出牌(玩家出牌)
function NiuNiuPlayer:OutPoker(point, data)
    if self.chairid < 0 then return end;
    if data[1] == 0 then return end
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    local posnum =(self.chairid - NiuNiuMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end

    self.Poker_Over:SetActive(false);
    self.ThinkingPoker:SetActive(true);

    local p = self.Result.transform:Find("Num").localPosition

    --self.Result.transform:Find("Num").localPosition = Vector3.New(p.x, 30, 0);
    self.byNiuNiuPoint = point;
    self.playerPoker = data;
    self:IsShowTimer(false, 0, 0)
    self:OpenPokerAnimator();
    --UI显示牛牛的最终结果
    self.Result.transform:Find("Num/Num"):GetComponent('Image').sprite = NiuNiuPanel.NiuNum.transform:GetChild(self.byNiuNiuPoint):GetComponent('Image').sprite;
    self.Result.transform:Find("Num").gameObject:SetActive(true);
    self.Result.transform:Find("Num/Num"):GetComponent('Image'):SetNativeSize();
    self.Result.transform:Find("TextBg").gameObject:SetActive(false);
    self.Result:SetActive(true);
    if self.byNiuNiuPoint >= 10 then
        self.Result.transform:Find("Num").transform.localScale=Vector3.one*1.35;
        --local NiuAni = self.Result.transform:Find("Num/Num"):GetComponent("Animator")
        --NiuAni:Play("Niu" .. self.byNiuNiuPoint);
    end   
end

-- 翻牌动画
function NiuNiuPlayer:OpenPokerAnimator()
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    local firstprefeb = self.ThinkingPoker.transform:GetChild(0);
    for i = 1, self.ThinkingPoker.transform.childCount do
        self.ThinkingPoker.transform:GetChild(i - 1).localPosition = Vector3.New(firstprefeb.localPosition.x, 0, firstprefeb.localPosition.z)
    end
    local myselfpos = 0;
    local pokerdis = 35;
    local moveXpos = 30;
    local movepos = Vector3.New(0, 0, 0);
    if self.chairid == NiuNiuMH.MySelf_ChairID then
        myselfpos = 60;
        pokerdis = 90;
    end
    for i = 1, self.ThinkingPoker.transform.childCount do

        if self.byNiuNiuPoint == 0 then
            moveXpos = 40;
            movepos = Vector3.New(firstprefeb.localPosition.x +(moveXpos + myselfpos) *(i - 1), 0, 0);
        else

            if i < 4 then
                movepos = Vector3.New(firstprefeb.localPosition.x + pokerdis *(i - 1), 0, 0)
            else
                movepos = Vector3.New(firstprefeb.localPosition.x + pokerdis *(i - 1) + 25, 0, 0)
            end
        end

        local pokernum = 0;
        if self.byNiuNiuPoint == 0 then
            pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
        else
            pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
        end

        local dotween = self.ThinkingPoker.transform:GetChild(i - 1):DOLocalMove(movepos, i * 0.1, false);
  
        dotween:SetEase(DG.Tweening.Ease.Linear);

        dotween:OnComplete( 
            function()
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
            end 
        )     
        
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
    end
    self.ThinkingPoker:SetActive(true);
end

--防止没有翻成功
function NiuNiuPlayer:OpenPokerOver()
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    local firstprefeb = self.ThinkingPoker.transform:GetChild(0);
    local myselfpos = 0;
    local pokerdis = 35;
    local moveXpos = 30;
    local movepos = Vector3.New(0, 0, 0);
    if self.chairid == NiuNiuMH.MySelf_ChairID then
        myselfpos = 60;
       pokerdis = 90;
    end
    for i = 1, self.ThinkingPoker.transform.childCount do

        if self.byNiuNiuPoint == 0 then
            moveXpos = 40;
            movepos = Vector3.New(firstprefeb.localPosition.x +(moveXpos + myselfpos) *(i - 1), 0, 0);
        else
            if i < 4 then
                movepos = Vector3.New(firstprefeb.localPosition.x + pokerdis *(i - 1), 0, 0)
            else
                movepos = Vector3.New(firstprefeb.localPosition.x + pokerdis *(i - 1) + 25, 0, 0)
            end
        end
        local pokernum = 0;
        if self.byNiuNiuPoint == 0 then
            --local tb=NiuNiuPanel.Ten2tTwo(self.playerPoker[i])
            --pokernum=tb[1]*13+tb[2]
            pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
        else
            --local tb=NiuNiuPanel.Ten2tTwo(self.playerPoker[i])
            --pokernum=tb[1]*13+tb[2]
            pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
        end
        self.ThinkingPoker.transform:GetChild(i - 1).localPosition = movepos;
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
    end
    self.ThinkingPoker:SetActive(true);
    
    self.Result.transform:Find("Num/Num"):GetComponent('Image').sprite = NiuNiuPanel.NiuNum.transform:GetChild(self.byNiuNiuPoint):GetComponent('Image').sprite;
    self.Result.transform:Find("Num").gameObject:SetActive(true);
    self.Result.transform:Find("Num/Num"):GetComponent('Image'):SetNativeSize();
end


-- 下注动画
function NiuNiuPlayer:PlayingChipAnimator(chipvalue)
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextForBestFit = false;
    if self.chairid < 0 then return end;
    self.Timer:SetActive(false);
    if chipvalue == toInt64(0) then return end
    
    local num=0;
    if self.chairid ~= NiuNiuMH.Banker_ChairID then
        if chipvalue<10000 then
            num=chipvalue;
            self.SetChip.transform:Find("Text"):GetComponent('Text').text ="下注:"..tostring(num);
            self.SetChip:SetActive(true);
        elseif  chipvalue<1000000 then   
            num=chipvalue/10000;  
            if num>10 then
                self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextForBestFit = true;
                self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextMaxSize = 20;
            end
            self.SetChip.transform:Find("Text"):GetComponent('Text').text ="下注:"..tostring(num).."万";
            self.SetChip:SetActive(true);
        elseif chipvalue<100000000 then
            num=math.floor(chipvalue/10000);
            if num>1000 then
                self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextForBestFit = true;
                self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextMaxSize = 20;
            end
            self.SetChip.transform:Find("Text"):GetComponent('Text').text ="下注:"..tostring(num).."万";
            self.SetChip:SetActive(true);
        else
            num=chipvalue/100000000;
            self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextForBestFit = true;
            self.SetChip.transform:Find("Text"):GetComponent('Text').resizeTextMaxSize = 20;
            self.SetChip.transform:Find("Text"):GetComponent('Text').text ="下注:"..tostring(num).."亿";
            self.SetChip:SetActive(true);
        end
    end

    -- if self.chairid ~= NiuNiuMH.Banker_ChairID then
    --     self.SetChip.transform:Find("Text"):GetComponent('Text').text ="下注："..tostring(chipvalue);
    --     self.SetChip:SetActive(true);
    -- end
    --self.IsStartBanker:SetActive(false);
    --self:IsShowTimer(false, 0, 0);
    --self.IsPlayingGame = 1;
    --local chip = NiuNiuPanel.Musicprefeb.transform:Find("Snd_Chip"):GetComponent('AudioSource').clip
    --MusicManager:PlayX(chip);
    --local chipstoppos = NiuNiuPanel.ChipArea.transform.position;
    --下注筹码值
    self.chipvalue = chipvalue;
    self.i64ChipValue = chipvalue;
--    self.ChipArea.transform.localPosition = Vector3.New(0, 0, 10000)
--    local t = NiuNiuPlayer:ChipNumChangeTable(chipvalue);
--    local creatnum = 0;
--    for j = 1, #t-2 do
--        for i = 1, t[j] do
--            local go=nil;
--            if creatnum < 15 then
--              if #delchiptable[j] == 0 then
--                    go = newobject(NiuNiuPanel.NiuNiuChip.transform:GetChild(j - 1).gameObject);
--                    go.name = NiuNiuPanel.NiuNiuChip.transform:GetChild(j - 1).gameObject.name;
--                    go.transform:SetParent(self.ChipArea.transform);
--                    go:GetComponent('RectTransform').sizeDelta = Vector2.New(130, 130);
--                    go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
--                    local vet2 = self.ChipArea.transform:GetComponent('RectTransform').sizeDelta;
--                    go.transform.localPosition = Vector3.New(((vet2.x / 2) - math.Random(0,(vet2.x))),((vet2.y / 2) - math.Random(0,(vet2.y))), 0);
--                    creatnum = creatnum + 1;
--                    go:SetActive(true);
--                else
--                    go =delchiptable[j][1];
--                    go.transform:SetParent(self.ChipArea.transform);
--                    go:GetComponent('RectTransform').sizeDelta = Vector2.New(130, 130);
--                    go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
--                    local vet2 = self.ChipArea.transform:GetComponent('RectTransform').sizeDelta;
--                    go.transform.localPosition = Vector3.New(((vet2.x / 2) - math.Random(0,(vet2.x))),((vet2.y / 2) - math.Random(0,(vet2.y))), 0);
--                    creatnum = creatnum + 1;
--                    go:SetActive(true);
--                    table.remove(delchiptable[j],1)
--                end
--                table.insert(NiuNiuMH.NiuNiuChipObj, #NiuNiuMH.NiuNiuChipObj + 1, go);
--            end
--        end
--    end
--    self.ChipArea:SetActive(true);
--    self.ChipArea.transform.localPosition = Vector3.New(0, 0, 0)
--    -- error("开始移动筹码到中心位置");
--    local tweener = self.ChipArea.transform:DOMove(chipstoppos, 0.4, false);
--    tweener:SetEase(DG.Tweening.Ease.OutCirc);
--    tweener:OnComplete( function()
--        for i = 1, creatnum do
--            self.ChipArea.transform:GetChild(0):SetParent(NiuNiuPanel.ChipArea.transform);
--        end
--        self.ChipArea.transform.localPosition = Vector3.New(0, 0, 0)
--    end )
end

-- 下注数值转换成表个数
function NiuNiuPlayer:ChipNumChangeTable(num)
    local t = { }
    local baiwannum = math.floor(num / NiuNiuChooseChipTable[7]);
    table.insert(t, #t + 1, baiwannum);
    local shiwannum = math.floor((num - baiwannum * NiuNiuChooseChipTable[7]) / NiuNiuChooseChipTable[6]);
    table.insert(t, #t + 1, shiwannum);
    local wannum = math.floor((num - baiwannum * NiuNiuChooseChipTable[7] - shiwannum * NiuNiuChooseChipTable[6]) / NiuNiuChooseChipTable[5]);
    table.insert(t, #t + 1, wannum);
    local qiannum = math.floor((num - baiwannum * NiuNiuChooseChipTable[7] - shiwannum * NiuNiuChooseChipTable[6] - wannum * NiuNiuChooseChipTable[5]) / NiuNiuChooseChipTable[4])
    table.insert(t, #t + 1, qiannum);
    local bainum = math.floor((num - baiwannum * NiuNiuChooseChipTable[7] - shiwannum * NiuNiuChooseChipTable[6] - wannum * NiuNiuChooseChipTable[5] - qiannum * NiuNiuChooseChipTable[4]) / NiuNiuChooseChipTable[3]);
    table.insert(t, #t + 1, bainum);

    local shinum = math.floor((num - baiwannum * NiuNiuChooseChipTable[7] - shiwannum * NiuNiuChooseChipTable[6] - wannum * NiuNiuChooseChipTable[5] - qiannum * NiuNiuChooseChipTable[4] - bainum * NiuNiuChooseChipTable[3]) / NiuNiuChooseChipTable[2]);
    table.insert(t, #t + 1, shinum);
    local strlen = string.len(num);
    local genum = tonumber(string.sub(tostring(num), strlen, -1));
    table.insert(t, #t + 1, genum);
    return t;
end

-- 游戏结束动画播放
function NiuNiuPlayer:PlayingGameOverAnimator(winScore)
    if self.chairid < 0 then return end;
    if self.palyerinfo._1dwUser_Id < 0 then  return end;

    if toInt64(winScore) ==toInt64(0) and not(self.ThinkingPoker.activeSelf) then return end;
    --self:OpenPokerOver();
    local textobj = self.Result.transform:Find("TextBg").gameObject
    local startpos = textobj.transform.localPosition
    textobj:SetActive(true);
    self.i64WinScore = winScore;
 
    for i = 1, self.ThinkingPoker.transform.childCount do
        if toInt64(winScore) < toInt64(0) then
            self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
        end
    end
    self.changenum = nil;

    --游戏的最终结算动画
    if toInt64(winScore) < toInt64(0) then
        if self.chairid == NiuNiuMH.MySelf_ChairID then
            MusicManager:PlayX(NiuNiuPanel.LoseMusic);
        end
        self.Result.transform:Find("Num"):GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(true);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(false);
        textobj:GetComponent('Image').sprite = self.Result.transform:Find("TextBg/Lose"):GetComponent('Image').sprite
        self:SetNumToImage(toInt64(winScore), self.Result.transform:Find("TextBg/Lose").gameObject)
        self.changenum = self.Result.transform:Find("TextBg/Lose").gameObject
    else
        --播放输赢的声音
        if self.chairid == NiuNiuMH.MySelf_ChairID then
            if self.byNiuNiuPoint < 10 then 
                MusicManager:PlayX(NiuNiuPanel.WinMusic); 
            end
            if self.byNiuNiuPoint >= 10 then
                if self.byNiuNiuPoint % 2 == 0 then
                        MusicManager:PlayX(NiuNiuPanel.Win1Music);
                else
                    MusicManager:PlayX(NiuNiuPanel.Win2Music);
                end
            end
        end

        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(true);
        textobj:GetComponent('Image').sprite = self.Result.transform:Find("TextBg/Win"):GetComponent('Image').sprite
        -- 赢家收入值+下注值（显示数量）
        self:SetNumToImage(toInt64(winScore), self.Result.transform:Find("TextBg/Win").gameObject)
        self.changenum = self.Result.transform:Find("TextBg/Win").gameObject
    end

    self.changenum.transform.localPosition = Vector3.New(-150, 0, 0)
    self.Result.transform:Find("TextBg"):GetComponent('Image').color = Color.New(255, 255, 255, 255)
    for i = 0, self.changenum.transform.childCount - 1 do
        self.changenum.transform:GetChild(i):GetComponent('Image').color = Color.New(255, 255, 255, 255)
    end
    self.Result:SetActive(true);
    --self.Result.transform:Find("Num"):GetComponent("Image").enabled = true;
    dTime = 0;
    self.StartAni = true;
    self.StartNum = 0;
    local tweener = self.changenum.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.3, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    self.IsPlayingGame = 1;
    NiuNiuMH.CANEXIT=1;
end

function NiuNiuPlayer:PlayWinOrLose()
    self.Result.transform:Find("TextBg"):GetComponent('Image'):DOColor(Color.New(255, 255, 255, 0), 2)
    for i = 0, self.changenum.transform.childCount - 1 do
        self.changenum.transform:GetChild(i):GetComponent('Image'):DOColor(Color.New(255, 255, 255, 0), 2)
    end
end


--庄家逃跑
function NiuNiuPlayer:BankerLeaveGameOverAnimator(winScore)
    self.i64WinScore = winScore;
    for i = 1, self.ThinkingPoker.transform.childCount do
        if winScore < 0 then
            self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
        end
    end

    self.Result.transform:Find("Num").gameObject:SetActive(false)
    if tonumber(winScore) < tonumber(0) then
        self.Result.transform:Find("Num"):GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
        self.Result.transform:Find("Num").gameObject:SetActive(false)
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(true);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(false);
        self:SetNumToImage(winScore, self.Result.transform:Find("TextBg/Lose").gameObject)
    else
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(true);
        -- 赢家收入值+下注值（显示数量）
        self:SetNumToImage(winScore, self.Result.transform:Find("TextBg/Win").gameObject)
    end
    self.Result.transform:Find("Num").gameObject:SetActive(false)
    self.Result.transform:Find("TextBg").gameObject:SetActive(true)
    self.Result:SetActive(true);
    self.Result.transform:Find("Num").gameObject:SetActive(false);
    dTime = 0;
    --self.StartAni = true;
    self.IsPlayingGame = 1;
    self:GameOver();
end

-- 赢家筹码飞向自己
function NiuNiuPlayer:FreeGold(startnum, allnum, id)
    self.IsPlayingGame = 1;
    if allnum == 0 then return end
    -- error("赢家筹码飞向自己");
    local waitTime = 0.01;
    local waitnum = 1;
    if allnum - startnum < 20 then
        waitTime = 0.01;
        waitnum = 1;
    elseif allnum - startnum < 40 then
        waitTime = 0.006;
        waitnum = 2;
    elseif allnum - startnum < 60 then
        waitTime = 0.003;
        waitnum = 3;
    elseif allnum - startnum < 80 then
        waitTime = 0.001;
        waitnum = 4;
    else
        waitTime = 0.002;
        waitnum = 5;
    end
    for j = startnum, allnum do
        if GameNextScenName ~= gameScenName.Game03 then return end;
        if NiuNiuMH.Game_State ~= 5 then return end
        local pos = self.info.transform:Find("Gold").position;
        if j <= NiuNiuPanel.ChipArea.transform.childCount then

            if IsNil(NiuNiuPanel.ChipArea.transform:GetChild(j - 1).gameObject) then return end
            local dotween = NiuNiuPanel.ChipArea.transform:GetChild(j - 1):DOMove(pos, 1, false);
            NiuNiuPanel.ChipArea.transform:GetChild(j - 1):DOScale(Vector3.New(0.3, 0.3, 0.3), 0.6);
            dotween:OnComplete( function()
                if GameNextScenName ~= gameScenName.Game03 then return end;
                if IsNil(NiuNiuPanel.ChipArea.transform:GetChild(j - 1).gameObject) then return end
                NiuNiuPanel.ChipArea.transform:GetChild(j - 1).gameObject:SetActive(false)
                self:RestartGame(j);
            end );
        end
        if NiuNiuMH.Game_State ~= 5 or GameNextScenName ~= gameScenName.Game03 then return end
        if j % waitnum == 0 then
            coroutine.wait(waitTime);
        end
        if NiuNiuMH.Game_State ~= 5 or GameNextScenName ~= gameScenName.Game03 then return end
    end
end

function NiuNiuPlayer:RestartGame(num)
    if num == NiuNiuPanel.ChipArea.transform.childCount then
        NiuNiu_IsGameStartIn = false;
        --error("重新开始新一局")
    end;
end

-- 用户分数
function NiuNiuPlayer:PlayerScore(id,gold)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    error("设置用户分数=="..gold)
    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;
    NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, gold, nil);
    --NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, NiuNiuMH.PlayerScore, nil);
    if PlayerInfoSystem.PlayererInfoPanel ~= nil then 
        if NiuNiuPanel.OnClickNum == self.chairid then 
            PlayerInfoSystem.gold.text =tostring(gold) 
        end 
    end;
end


-- 用户离开
function NiuNiuPlayer:PlayerLeave()
    logYellow("用户离开")
    local posnum = self.chairid - NiuNiuMH.MySelf_ChairID;
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    NiuNiuPanel.LeavePlayerImg.transform:GetChild(posnum):Find("Text").gameObject:SetActive(false);
    NiuNiuPanel.LeavePlayerImg.transform:GetChild(posnum).gameObject:SetActive(true);
    self.playerobj:SetActive(false);
    if NiuNiuMH.Playing_State > 1 then
        if NiuNiuMH.Playing_State <= 5 and self.IsPlayingGame == 1 then
            -- 判断用户是否已经开牌
            NiuNiuPanel.LeavePlayerImg.transform:GetChild(posnum):Find("Text").gameObject:SetActive(true);
            if self.chairid == NiuNiuMH.Banker_ChairID then
               -- error("庄家逃跑");
                NiuNiuMH.IsBankerLeave = true;
            else
            end
        end
    end
    self.chipvalue = 0;
    self.chairid = -100;
    self.palyerinfo = { };
    -- 是否操作
    self.bOperate = 0;
    self.IsPlayingGame = 0
    -- 是否抢庄
    self.bRobBanker = 0;
    -- 下注值（最小）
    self.i64ChipValue = toInt64(0);
    -- 牛牛点数（0到10）
    self.byNiuNiuPoint = 0;
    -- 扑克数据
    self.playerPoker = { 0, 0, 0, 0, 0 };
    -- 赢金币
    self.i64WinScore = 0;
--    self.AllWinLoseScore = 0;
--    -- 赢次数
--    self.winCount = 0;
--    -- 牛牛次数
--    self.niuniuCount = 0;
    -- 是否正在播放表情
    self.IsExpress = false;
    self.info:SetActive(false);
    self.ThinkingPoker:SetActive(false);
    self.ThinkingPoker.transform.localPosition = self.startpokerpos
    self.Result.transform:Find("TextBg").localPosition = self.startpos;
    for i = 0, self.ThinkingPoker.transform.childCount - 1 do
        self.ThinkingPoker.transform:GetChild(i):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
    end
    -- 牛牛结果及加减金币
    self.Result:SetActive(false);
    -- 倒计时
    self.Timer:SetActive(false);
    -- 筹码创建父物体
    self.ChipArea:SetActive(false);
    self.ChipArea.transform.localPosition = Vector3.new(0, 0, 0);
    self.IsStartBanker:SetActive(false);
    self:SetChangeBg(false);
end

-- 用户状态
function NiuNiuPlayer:PlayerState(id)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    -- 0：没有状态  1：站立状态  2：坐下状态  3：同意状态  4：旁观状态   5：游戏状态  6：断线状态
     -- error("=================用户状态================" .. self.palyerinfo._11byUserStatus)
    --NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold,nil);
    --NiuNiuPanel.GoldToText(self.info.transform:Find("Gold").gameObject, NiuNiuMH.PlayerScore, nil);

    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;
    if self.palyerinfo._11byUserStatus == 3 then self:IsShowTimer(false, 0, 0); end
    if PlayerInfoSystem.PlayererInfoPanel ~= nil then if NiuNiuPanel.OnClickNum == self.chairid then PlayerInfoSystem.gold.text = tostring(self.palyerinfo._7wGold) end end;
end

-- 用户表情
function NiuNiuPlayer:PlayerBiaoQing(idx)
    error("播放用户表情");
    -- if not(self.IsExpress) then
    -- else
    --     self.IsExpress = false; 
    --     destroy(self.expressionAni); 
    --     self.expressionAni = nil;
    -- end
    logYellow("============创建表情==============")
    local creatobj = NiuNiuPanel.biaoqingprefeb.transform:Find(NiuNiuMH.NiuNiuExpressin[idx]).gameObject;
    creatobj:SetActive(true);
    self.expressionAni = newobject(creatobj);
    self.expressionAni.transform:SetParent(self.BiaoQingFather.transform);
    self.expressionAni.transform.localScale = Vector3.one;
    self.expressionAni.transform.localPosition = Vector3.New(0, 0, 0);
    self.IsExpress = true;
end

-- 控制表情动画播放次数
function NiuNiuPlayer:ListenerBiaoQing()
    if self.IsExpress and self.chairid >= 0 then
        local animatorState = self.expressionAni.transform:GetComponent("Animator"):GetCurrentAnimatorStateInfo(0);
        if animatorState.normalizedTime >= 3 then self.IsExpress = false; destroy(self.expressionAni); self.expressionAni = nil; end
    end
end

function NiuNiuPlayer:FixedUpdate()
    --  self:ListenerBiaoQing();
    if self.StartAni then
        self.StartNum = self.StartNum + 1;
        if self.StartNum == 150 then self.StartAni = false self.StartNum = 0; self:PlayWinOrLose() end

    end
    --  error("Time.time================"..Time.deltaTime)
    self:TimerUpdate();
end

-- 清理当前局重新开始
function NiuNiuPlayer:GameOver()

    self.ThinkingPoker:SetActive(false);
    self.SetChip:SetActive(false);
    -- 牛牛结果及加减金币
    self.Result:SetActive(false);

    -- 配牌完成
    self.Poker_Over:SetActive(false);

    for i = 0, self.ThinkingPoker.transform.childCount - 1 do
        self.ThinkingPoker.transform:GetChild(i):GetComponent('Image').sprite = NiuNiuPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
        self.ThinkingPoker.transform:GetChild(i):GetComponent('Image').color = Color.New(1, 1, 1, 1);
    end
    self.Result.transform:Find("Num"):GetComponent('Image').color = Color.New(1, 1, 1, 1);
    self.Result.transform:Find("Num").gameObject:SetActive(false);
    self:IsShowTimer(false, 0, 0);
    self.BankerImg:SetActive(false);
    -- 筹码创建父物体
    self.ChipArea:SetActive(false);
    self.Result.transform:Find("TextBg").localPosition = self.startpos
end


-- 比牌动画
function NiuNiuPlayer:PkPoker(winlosetab)
    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i]:IsShowTimer(false, 0, 0);
    end
    if self.chairid < 0 then return end;
end

-- 所有筹码向四周扩散
function NiuNiuPlayer:AllChipAnimator(winlosetab, worldpos)
    for i = 1, #NiuNiuAllPlayerTable do
        local playerchairid = i - 1;
        local posnum =(playerchairid - NiuNiuMH.MySelf_ChairID);
        if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
        posnum = posnum + 1;
        if winlosetab[i] ~= 0 then
            NiuNiuAllPlayerTable[posnum]:PkPoker_Player(winlosetab[i]);
        end
    end
end
-- 非庄家动画
function NiuNiuPlayer:PkPoker_Player(winorlosenum)
    if self.chairid < 0 then return end;
    self.SetChip:SetActive(false);
  --  if self.chairid == NiuNiuMH.Banker_ChairID then return end

end

function NiuNiuPlayer:SetFirstPos()
    if self.chairid < 0 then return end;
    if self.chairid ~= NiuNiuMH.Banker_ChairID then return end
    local posnum =(self.chairid - NiuNiuMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    self.ThinkingPoker.transform:DOLocalMove(self.startpokerpos, 0.3, false)
end

function NiuNiuPlayer:PaowuLine()
    dTime = dTime + 0.005;
    local movew = 0.5 * self.Wight *(dTime * 4);
    local moveh = 0.5 * self.Height *(4 -(math.pow((dTime * 4 - 2), 2)));
    if self.startpos.x < 0 then
        self.Result.transform:Find("TextBg").localPosition = self.startpos + Vector3.New(movew, moveh, 0);
    else
        self.Result.transform:Find("TextBg").localPosition = self.startpos + Vector3.New(- movew, moveh, 0);
    end
    if dTime >= 1 then self.StartAni = false; end
end

-- 数字转图片
function NiuNiuPlayer:SetNumToImage(num, imgfather)
    local findname = "win";
    local startnum = 0;
    if toInt64(num) < toInt64(0) then findname = "lose"; startnum = 1; end

    for i = 1, imgfather.transform.childCount - 1 do
        imgfather.transform:GetChild(i).gameObject:SetActive(false);
    end
    local numstr=tostring(num)
    for j = 1 + startnum, string.len(numstr) do
        local chiponevalue = tonumber(string.sub(numstr, j, j));
        local newfindname = findname .. chiponevalue;
        imgfather.transform:GetChild(j - startnum):GetComponent('Image').sprite = NiuNiuPanel.WinLoseNum.transform:Find(newfindname):GetComponent('Image').sprite
        imgfather.transform:GetChild(j - startnum).gameObject:SetActive(true);
    end
end

-- 设置庄家图片
function NiuNiuPlayer:SetChangeBg(IsChange)
    if self.chairid < 0 then return end;
    if IsChange then
        self.BankerImg:SetActive(true);
        self.BankerAnimator:Play("banker");
    else
        self.BankerImg:SetActive(false);
    end
--    error("设置庄家图片=======================");
end
--处理加载时有时UI显示错误
function  NiuNiuPlayer:SetIsStartBank()
    self.IsStartBanker:SetActive(false);
end

function NiuNiuPlayer:IsPGame()
    coroutine.wait(7);
    self.IsPlayingGame = 1;

end