TBNNPlayer = { };
--local self = TBNNPlayer;

local ChoosePokerNum = 0;

local palyerchairid = 0;
local NiuNiuChooseChipTable = { 1, 10, 100, 1000, 10000, 100000, 1000000 };

local dTime = 0;
function TBNNPlayer:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end
-- 绑定lua代码
function TBNNPlayer.CreatPlayer(chairid)

end

function TBNNPlayer:Start(obj)--玩家数据初始化
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
    self.isPlayPoker=false

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
function TBNNPlayer:InitInfo(chairid)
    self.chipvalue = 0;
    self.chairid = chairid;--自己座位id
    self.playerobj:SetActive(true);
    self.info:SetActive(true);
    self.SetChip:SetActive(false);
    self:SetChangeBg(false);
    self.IsStartBanker:SetActive(false);

    local posnum = self.chairid - TBNNMH.MySelf_ChairID;
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    TBNNPanel.LeavePlayerImg.transform:GetChild(posnum).gameObject:SetActive(false);

    self.info.name = "Info" .. self.chairid;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    self.winCount = 0;
    self.niuniuCount = 0;
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(self.palyerinfo._7wGold);--自己现有的金币
    TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold,nil);

    --self:SetGold(0);
    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;--自己的昵称
    local imgurl = "";
    --self.info.transform:Find("Head/Head"):GetComponent("RectTransform").sizeDelta=Vector2.New(90,90);

    --设置系统默认头像
    self:SetHead();

    --自己设置头像
    if (self.palyerinfo._4bCustomHeader > 0) then
        imgurl = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" ..
        self.palyerinfo._1dwUser_Id .. "." .. self.palyerinfo._5szHeaderExtensionName;
        local  headstr = self.palyerinfo._1dwUser_Id .. "." .. self.palyerinfo._5szHeaderExtensionName;
        --UpdateFile.downHead(imgurl,headstr,nil,self.info.transform:Find("Head/Head").gameObject);
    else
    end

    self.Timer:SetActive(false);

    -- 其他玩家进入在抢庄时进入（可以加入游戏）
    if chairid ~= TBNNMH.MySelf_ChairID then        
        if TBNNMH.Playing_State == TBNNMH.SUB_SC_ROB_BANKER and self.bOperate == 0 then
            self.IsPlayingGame=1;
            self:IsShowTimer(true, TBNNMH.D_TIMER_ROB_BANKER, TBNNMH.Playing_Time*1000);
        --elseif TBNNMH.Playing_State>3 and  TBNNMH.Playing_State< 8 then
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_GAME_RESULT then
            self.IsPlayingGame=1;
        else
            self.IsPlayingGame=0;
        end
    end
end
--设置金币显示
function TBNNPlayer:SetGold(num)
    local n=TBNNMH.PlayerScore-num;
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(n);--自己现有的金币
    TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, n,nil);
end
--设置金币显示
function TBNNPlayer:SetBankGold(id)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    self.info.transform:Find("Gold"):GetComponent('Text').text = tostring(self.palyerinfo._7wGold);--自己现有的金币
    TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold, nil);
end
--设置头像
function TBNNPlayer:SetHead()
    logYellow("设置头像")
    if TBNNMH.MySelf_ChairID == self.chairid then
        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.GetHeadIcon();
    else
        self.info.transform:Find("Head/Head"):GetComponent('Image').sprite=HallScenPanel.headIcons.transform:GetChild(math.random(0,HallScenPanel.headIcons.transform.childCount-1)):GetComponent("Image").sprite;
    end
end


-- 用户场景
function TBNNPlayer:SetInitValue(data, passTime)

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
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
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
    if self.chairid == TBNNMH.Banker_ChairID then 
        self.IsPlayingGame = 1 
    end

    --空状态
    if TBNNMH.Game_State == TBNNMH.D_GAME_STATE_NULL then
        self.IsPlayingGame = 1;
        error("空状态=============");
        self.IsPlayingGame = 1;
        self:IsShowTimer(false, 0, 0)
        if self.chairid == TBNNMH.MySelf_ChairID and self.IsPlayingGame == 1 then
         -- error("自己空状态=============");
            NiuNiu_IsGameStartIn = false;
            TBNNMH.Game_State = 0;
            TBNNPanel.SetShowBtn()
        end
    -- 抢庄
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_ROB_BANKER then

    -- 下注
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_CHIP then
        error("下注============="..self.bOperate);
        self.IsPlayingGame=0
        if  self.bOperate == 0 then
            self:IsShowTimer(false, 0, 0)
            self:PlayingChipAnimator(self.i64ChipValue);
        elseif self.bOperate == 1 then
            if self.chairid ~= TBNNMH.Banker_ChairID then 
                self:IsShowTimer(true, TBNNMH.D_TIMER_CHIP, passTime); 
            end
            if self.chairid == TBNNMH.MySelf_ChairID and self.IsPlayingGame == 1 then
                TBNNMH.Game_State = 2;
                TBNNPanel.SetShowBtn()
            end
        end

    --发牌
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_SEND_POKER then
            --error("确定庄家动画")
        self.IsPlayingGame=1
        if self.IsPlayingGame == 0 then return end
        self.ThinkingPoker:SetActive(true);
        self:PlayingChipAnimator(self.i64ChipValue);
        if self.playerPoker[1]>0 then self.ThinkingPoker:SetActive(true) end;--判断扑克数据是否为空
        if self.chairid == TBNNMH.MySelf_ChairID then
            for i = 1, self.ThinkingPoker.transform.childCount do
                local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
            end
        else
            for i = 1, self.ThinkingPoker.transform.childCount do
                local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
            end
        end
    -- 开牌
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_OPEN_POKER then
        error("开牌")
        if self.i64ChipValue> 0 or self.chairid==TBNNMH.Banker_ChairID then 
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
            self.Poker_Over:SetActive(true);
        elseif self.bOperate == 0 then
            self:IsShowTimer(true, TBNNMH.D_TIMER_OPEN_POKER, passTime);        
            if self.playerPoker[1]>0 then self.ThinkingPoker:SetActive(true) end;

            if self.chairid == TBNNMH.MySelf_ChairID then
                TBNNMH.Game_State = 3;
                TBNNPanel.SetShowBtn()
                for i = 1, self.ThinkingPoker.transform.childCount do
                    local pokernum =(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[1]) * 13 +(string.split(Util.OutPutPokerValue(self.playerPoker[i]), ",")[2]);
                    self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
                end
            end
        end
    --游戏结算
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_GAME_RESULT then
        --error("确定庄家动画")
        self.IsPlayingGame = 1;
        TBNNMH.Playing_Time=0;
        self.ThinkingPoker:SetActive(false);
        return;
    --游戏结束
    elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_GAME_END then
        error("-- 游戏结束");
        self:GameOver();
     end
end


--玩家基本信息配置（初始化..默认不显示）
function TBNNPlayer:FindCompent()
    -- 玩家基础信息
    self.info = self.transform:Find("Info").gameObject;
    self.info:SetActive(false);
    --配牌完成
    self.Poker_Over = self.transform:Find("Over").gameObject;
    self.Poker_Over:SetActive(false);
    --是否为庄家
    self.BankerImg=self.transform:Find("Banker").gameObject;
    self.BankerImg:SetActive(false);
    self.BankerAnimator=self.BankerImg:GetComponent("Animator")

    -- 玩家思考牌型状态（没牛状态）
    self.ThinkingPoker = self.transform:Find("ThinkingPoker").gameObject;
        if self.chairid ~= TBNNMH.MySelf_ChairID then
            for i=1,self.ThinkingPoker.transform.childCount do 
                self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite--翻牌
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
function TBNNPlayer:SetBankerText(IsShow)
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
function TBNNPlayer:SendPoker()
    --判断是否可以发牌
    if self.chairid < 0 then return end;
    --if self.IsPlayingGame == 0 then return end;
    self.IsPlayingGame = 1
    self.ThinkingPoker.transform.localPosition = self.startpokerpos
    self:IsShowTimer(false, 0, 0);
    local posnum =(self.chairid - TBNNMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    local niuniubanker = TBNNPanel.AllPlayerFather.transform:GetChild(posnum).gameObject;

    for i = 1, self.ThinkingPoker.transform.childCount-1 do
        self.ThinkingPoker.transform:GetChild(i - 1).position = Vector3.New(niuniubanker.transform.position.x, niuniubanker.transform.position.y, 2000);
    end
    self.ThinkingPoker.transform:GetChild(self.ThinkingPoker.transform.childCount-1).gameObject:SetActive(false)

    local startpos = -80;
    local pokerdis = 50;
    self.ThinkingPoker:SetActive(true);
    if self.chairid == TBNNMH.MySelf_ChairID then
        startpos=startpos-20
        pokerdis = pokerdis + 45;
    end
    for i = 1, self.ThinkingPoker.transform.childCount-1 do
        local tweener = self.ThinkingPoker.transform:GetChild(i - 1):DOLocalMove(Vector3.New(startpos + pokerdis *(i - 1), 0, 0), 0.8, false);
        tweener:SetEase(DG.Tweening.Ease.InCubic);
        coroutine.wait(0.2);
    end
end

function TBNNPlayer:PlaySendPoker()
    if self.chairid < 0 then return end;
    if self.IsPlayingGame == 0 then return end;

    self.ThinkingPoker.transform.localPosition = self.startpokerpos
    self:IsShowTimer(false, 0, 0);

    local posnum =(self.chairid- TBNNMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    local niuniubanker = TBNNPanel.AllPlayerFather.transform:GetChild(posnum).gameObject;
    for i = self.ThinkingPoker.transform.childCount, self.ThinkingPoker.transform.childCount do
        self.ThinkingPoker.transform:GetChild(i - 1).position = Vector3.New(niuniubanker.transform.position.x, niuniubanker.transform.position.y, 2000);
    end
    self.ThinkingPoker.transform:GetChild(self.ThinkingPoker.transform.childCount-1).gameObject:SetActive(true)

    local startpos = -80;
    local pokerdis = 50;
    self.ThinkingPoker:SetActive(true);

    if self.chairid == TBNNMH.MySelf_ChairID then
        startpos=startpos-20
        pokerdis = pokerdis + 45;
    end
    for i = 1, self.ThinkingPoker.transform.childCount-1 do
        self.ThinkingPoker.transform:GetChild(i - 1).localPosition=Vector3.New(startpos + pokerdis *(i - 1), 0, 0);
    end
    
    for i = self.ThinkingPoker.transform.childCount, self.ThinkingPoker.transform.childCount do
        local tweener = self.ThinkingPoker.transform:GetChild(i - 1):DOLocalMove(Vector3.New(startpos + pokerdis *(i - 1), 0, 0), 0.8, false);
        tweener:SetEase(DG.Tweening.Ease.InCubic);
        -- local chip = TBNNPanel.Musicprefeb.transform:Find("Snd_SendCard"):GetComponent('AudioSource').clip
        -- MusicManager:PlayX(chip);
        coroutine.wait(0.2);
    end
end


self.movenum=0;
self.jishu=0;
self.IsTimeUpdate=false;

-- 配牌/叫庄/下注 倒计时(包含显示与否)
function TBNNPlayer:IsShowTimer(byshowtimer, alltime, oldtime)
    if self.chairid < 0 then  return end;
    if self.IsPlayingGame == 0 then  return end;
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

function TBNNPlayer:TimerUpdate()
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
            if 1 - self.movenum <= 0 and self.chairid == TBNNMH.MySelf_ChairID then
                TBNNMH.Game_State = 65535;
                TBNNPanel.SetShowBtn();
            end
        end
    end
end

-- 开始下注（倒计时/清除上局信息）
function TBNNPlayer:StartChip()
    self.IsStartBanker:SetActive(false);
    if self.chairid < 0 then return end;
    if self.IsPlayingGame == 0 then return end;
    if self.chairid == TBNNMH.Banker_ChairID then return end
    self:IsShowTimer(false, 0, 0);
    self:IsShowTimer(true, TBNNMH.D_TIMER_CHIP, 0);
end

-- 开始开牌（把Think版型显示出来）（计时应用）V
function TBNNPlayer:StartOpenPoker()
    self.IsStartBanker:SetActive(false);
    if self.chairid < 0 then return end
    if self.chairid < 0 then return end

    if self.i64ChipValue> 0 or self.chairid==TBNNMH.Banker_ChairID then
        self.IsPlayingGame = 1;
    end
    if self.IsPlayingGame == 0 then return end;
    self:IsShowTimer(false, 0, 0);
    self:IsShowTimer(true, TBNNMH.D_TIMER_OPEN_POKER, 0);
    self.ThinkingPoker:SetActive(true);
end

-- 出牌(玩家出牌)
function TBNNPlayer:OutPoker(point, data)
    logYellow("=========玩家出牌==============")
    if self.chairid < 0 then return end;
    if data[1] == 0 then return end

    local posnum =(self.chairid - TBNNMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    self.Poker_Over:SetActive(false);
    self.ThinkingPoker:SetActive(true);
    local p = self.Result.transform:Find("Num").localPosition
    --self.Result.transform:Find("Num").localPosition = Vector3.New(p.x, 30, 0);
    self.byNiuNiuPoint = point;
    self.playerPoker = data;
    self:IsShowTimer(false, 0, 0)
    self:OpenPokerAnimator();
    --UI显示牛牛的最终结果
    self.Result.transform:Find("Num/Num"):GetComponent('Image').sprite = TBNNPanel.NiuNum.transform:GetChild(self.byNiuNiuPoint):GetComponent('Image').sprite;
    self.Result.transform:Find("Num").gameObject:SetActive(true);
    self.Result.transform:Find("Num/Num"):GetComponent('Image'):SetNativeSize();
    self.Result.transform:Find("TextBg").gameObject:SetActive(false);
    if self.chairid ==TBNNMH.MySelf_ChairID then
        self.Result.transform:Find("winORlose").gameObject:SetActive(false);
    end
    
    self.Result:SetActive(true);

    if self.byNiuNiuPoint == 0 then
        MusicManager:PlayX(TBNNPanel.N0); 
    elseif self.byNiuNiuPoint == 1 then
        MusicManager:PlayX(TBNNPanel.N1); 
    elseif self.byNiuNiuPoint == 2 then
        MusicManager:PlayX(TBNNPanel.N2); 
    elseif self.byNiuNiuPoint == 3 then
        MusicManager:PlayX(TBNNPanel.N3);
    elseif self.byNiuNiuPoint == 4 then
        MusicManager:PlayX(TBNNPanel.N4);
    elseif self.byNiuNiuPoint == 5 then
        MusicManager:PlayX(TBNNPanel.N5);
    elseif self.byNiuNiuPoint == 6 then
        MusicManager:PlayX(TBNNPanel.N6);
    elseif self.byNiuNiuPoint == 7 then
        MusicManager:PlayX(TBNNPanel.N7);
    elseif self.byNiuNiuPoint == 8 then
        MusicManager:PlayX(TBNNPanel.N8); 
    elseif self.byNiuNiuPoint == 9 then
        MusicManager:PlayX(TBNNPanel.N9);
    elseif self.byNiuNiuPoint == 10 then
        MusicManager:PlayX(TBNNPanel.N10);
    elseif self.byNiuNiuPoint == 11 then
        MusicManager:PlayX(TBNNPanel.N11);
    elseif self.byNiuNiuPoint == 12 then
        MusicManager:PlayX(TBNNPanel.N12);
    elseif self.byNiuNiuPoint == 13 then
        MusicManager:PlayX(TBNNPanel.N13);
    elseif self.byNiuNiuPoint == 14 then
        MusicManager:PlayX(TBNNPanel.N14);
    end
end

-- 翻牌动画
function TBNNPlayer:OpenPokerAnimator()
    local firstprefeb = self.ThinkingPoker.transform:GetChild(0);
    for i = 1, self.ThinkingPoker.transform.childCount do
        self.ThinkingPoker.transform:GetChild(i - 1).localPosition = Vector3.New(firstprefeb.localPosition.x, 0, firstprefeb.localPosition.z)
    end
    local myselfpos = 0;
    local pokerdis = 35;
    local moveXpos = 30;
    local movepos = Vector3.New(0, 0, 0);
    if self.chairid == TBNNMH.MySelf_ChairID then
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
        dotween:OnComplete( function()
            self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
        end )        
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
    end
    self.ThinkingPoker:SetActive(true);
end

--防止没有翻成功
function TBNNPlayer:OpenPokerOver()
    local firstprefeb = self.ThinkingPoker.transform:GetChild(0);
    local myselfpos = 0;
    local pokerdis = 35;
    local moveXpos = 30;
    local movepos = Vector3.New(0, 0, 0);
    if self.chairid == TBNNMH.MySelf_ChairID then
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
        self.ThinkingPoker.transform:GetChild(i - 1).localPosition = movepos;
        self.ThinkingPoker.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
    end
    self.ThinkingPoker:SetActive(true);
    
    self.Result.transform:Find("Num/Num"):GetComponent('Image').sprite = TBNNPanel.NiuNum.transform:GetChild(self.byNiuNiuPoint):GetComponent('Image').sprite;
    self.Result.transform:Find("Num").gameObject:SetActive(true);
    self.Result.transform:Find("Num/Num"):GetComponent('Image'):SetNativeSize();
end


-- 下注动画
function TBNNPlayer:PlayingChipAnimator(chipvalue)
    logYellow("==============")
    if self.chairid < 0 then return end;
    self.Timer:SetActive(false);
    if chipvalue == toInt64(0) then return end
    local str ="x"..chipvalue
    self.SetChip.transform:Find("Text"):GetComponent('TextMeshProUGUI').text =Module55Panel.ShowText(str);
    self.SetChip:SetActive(true);
    --下注筹码值
    self.chipvalue = chipvalue;
    self.i64ChipValue = chipvalue;
end

-- 下注数值转换成表个数
function TBNNPlayer:ChipNumChangeTable(num)
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
function TBNNPlayer:PlayingGameOverAnimator(winScore)
    if self.chairid < 0 then return end;
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
        self.Result.transform:Find("Num"):GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(true);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(false);
        self.Result.transform:Find("Num/loseImage").gameObject:SetActive(true);
        self.Result.transform:Find("Num/winImage").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Lose"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        if self.chairid ==TBNNMH.MySelf_ChairID then
            self.Result.transform:Find("winORlose/loseImage").gameObject:SetActive(true);
            self.Result.transform:Find("winORlose/winImage").gameObject:SetActive(false);
            self.Result.transform:Find("winORlose/loseImage/Lose"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        end

    else
        --播放输赢的声音
        if self.chairid == TBNNMH.MySelf_ChairID then
            if self.byNiuNiuPoint < 10 then 
                MusicManager:PlayX(TBNNPanel.WinMusic); 
            end
            if self.byNiuNiuPoint >= 10 then
                if self.byNiuNiuPoint % 2 == 0 then
                    MusicManager:PlayX(TBNNPanel.Win1Music);
                else
                    MusicManager:PlayX(TBNNPanel.Win2Music);
                end
            end
        end
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(true);
        self.Result.transform:Find("Num/loseImage").gameObject:SetActive(false);
        self.Result.transform:Find("Num/winImage").gameObject:SetActive(true);
        self.Result.transform:Find("TextBg/Win"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        if self.chairid ==TBNNMH.MySelf_ChairID then
            self.Result.transform:Find("winORlose/loseImage").gameObject:SetActive(false);
            self.Result.transform:Find("winORlose/winImage").gameObject:SetActive(true);
            self.Result.transform:Find("winORlose/winImage/Win"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        end
    end
    if self.chairid ==TBNNMH.MySelf_ChairID then
        self.Result.transform:Find("winORlose").gameObject:SetActive(true)
    end
    self.Result:SetActive(true);
    dTime = 0;
    self.StartAni = true;
    self.StartNum = 0;
    self.IsPlayingGame = 1;
    TBNNMH.CANEXIT=1;
end

function TBNNPlayer:PlayWinOrLose()

end


--庄家逃跑
function TBNNPlayer:BankerLeaveGameOverAnimator(winScore)
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
        self.Result.transform:Find("Num/loseImage").gameObject:SetActive(true);
        self.Result.transform:Find("Num/winImage").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Lose"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)    
        if self.chairid ==TBNNMH.MySelf_ChairID then
            self.Result.transform:Find("winORlose/loseImage").gameObject:SetActive(true);
            self.Result.transform:Find("winORlose/winImage").gameObject:SetActive(false);
            self.Result.transform:Find("winORlose/loseImage/Lose"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        end

    else
        self.Result.transform:Find("TextBg/Lose").gameObject:SetActive(false);
        self.Result.transform:Find("TextBg/Win").gameObject:SetActive(true);
        self.Result.transform:Find("Num/loseImage").gameObject:SetActive(false);
        self.Result.transform:Find("Num/winImage").gameObject:SetActive(true);
        -- 赢家收入值+下注值（显示数量）
        self.Result.transform:Find("TextBg/Win"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        if self.chairid ==TBNNMH.MySelf_ChairID then
            self.Result.transform:Find("winORlose/loseImage").gameObject:SetActive(false);
            self.Result.transform:Find("winORlose/winImage").gameObject:SetActive(true);
            self.Result.transform:Find("winORlose/winImage/Win"):GetComponent("TextMeshProUGUI").text=Module55Panel.ShowText(winScore)
        end
    end
    self.Result.transform:Find("Num").gameObject:SetActive(false)
    self.Result.transform:Find("TextBg").gameObject:SetActive(true)
    if self.chairid ==TBNNMH.MySelf_ChairID then
        self.Result.transform:Find("winORlose").gameObject:SetActive(true)
    end

    self.Result:SetActive(true);
    self.Result.transform:Find("Num").gameObject:SetActive(false);
    dTime = 0;
    self.IsPlayingGame = 1;
    self:GameOver();
end

-- 赢家筹码飞向自己
function TBNNPlayer:FreeGold(startnum, allnum, id)
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
        if TBNNMH.Game_State ~= 5 then return end
        local pos = self.info.transform:Find("Gold").position;
        if j <= TBNNPanel.ChipArea.transform.childCount then

            if IsNil(TBNNPanel.ChipArea.transform:GetChild(j - 1).gameObject) then return end
            local dotween = TBNNPanel.ChipArea.transform:GetChild(j - 1):DOMove(pos, 1, false);
            TBNNPanel.ChipArea.transform:GetChild(j - 1):DOScale(Vector3.New(0.3, 0.3, 0.3), 0.6);
            dotween:OnComplete( function()
                if GameNextScenName ~= gameScenName.Game03 then return end;
                if IsNil(TBNNPanel.ChipArea.transform:GetChild(j - 1).gameObject) then return end
                TBNNPanel.ChipArea.transform:GetChild(j - 1).gameObject:SetActive(false)
                self:RestartGame(j);
            end );
        end
        if TBNNMH.Game_State ~= 5 or GameNextScenName ~= gameScenName.Game03 then return end
        if j % waitnum == 0 then
            coroutine.wait(waitTime);
        end
        if TBNNMH.Game_State ~= 5 or GameNextScenName ~= gameScenName.Game03 then return end
    end
end

function TBNNPlayer:RestartGame(num)
    if num == TBNNPanel.ChipArea.transform.childCount then
        NiuNiu_IsGameStartIn = false;
        --error("重新开始新一局")
    end;
end

-- 用户分数
function TBNNPlayer:PlayerScore(id,gold)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    error("设置用户分数=="..gold)
    -- if self.palyerinfo._7wGold > gold then
    --     gold=self.palyerinfo._7wGold
    -- end
    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;
    TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, gold, nil);
    --TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, TBNNMH.PlayerScore, nil);
    -- if PlayerInfoSystem.PlayererInfoPanel ~= nil then 
    --     if TBNNPanel.OnClickNum == self.chairid then 
    --       --  PlayerInfoSystem.gold.text =tostring(NowScore) 
    --     end 
    -- end;
end


-- 用户离开
function TBNNPlayer:PlayerLeave()

    local posnum = self.chairid - TBNNMH.MySelf_ChairID;
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    TBNNPanel.LeavePlayerImg.transform:GetChild(posnum):Find("Text").gameObject:SetActive(false);
    TBNNPanel.LeavePlayerImg.transform:GetChild(posnum).gameObject:SetActive(true);
    self.playerobj:SetActive(false);
    if TBNNMH.Playing_State > 1 then
        if TBNNMH.Playing_State <= 5 and self.IsPlayingGame == 1 then
            -- 判断用户是否已经开牌
            TBNNPanel.LeavePlayerImg.transform:GetChild(posnum):Find("Text").gameObject:SetActive(true);
            if self.chairid == TBNNMH.Banker_ChairID then
               -- error("庄家逃跑");
                TBNNMH.IsBankerLeave = true;
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
        self.ThinkingPoker.transform:GetChild(i):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
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
function TBNNPlayer:PlayerState(id)
    self.chairid = id;
    self.palyerinfo = NiuNiuUserInfoTable[self.chairid + 1];
    -- 0：没有状态  1：站立状态  2：坐下状态  3：同意状态  4：旁观状态   5：游戏状态  6：断线状态
     -- error("=================用户状态================" .. self.palyerinfo._11byUserStatus)
    --TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, self.palyerinfo._7wGold,nil);
    --TBNNPanel.GoldToText(self.info.transform:Find("Gold").gameObject, TBNNMH.PlayerScore, nil);

    self.info.transform:Find("Name"):GetComponent('Text').text = self.palyerinfo._2szNickName;
    if self.palyerinfo._11byUserStatus == 3 then self:IsShowTimer(false, 0, 0); end
    if PlayerInfoSystem.PlayererInfoPanel ~= nil then if TBNNPanel.OnClickNum == self.chairid then PlayerInfoSystem.gold.text = tostring(self.palyerinfo._7wGold) end end;
end

-- 用户表情
function TBNNPlayer:PlayerBiaoQing(idx)
    --error("播放用户表情");
    if not(self.IsExpress) then
    else
        self.IsExpress = false; destroy(self.expressionAni); self.expressionAni = nil;
    end
    local creatobj = TBNNPanel.biaoqingprefeb.transform:Find(TBNNMH.NiuNiuExpressin[idx]).gameObject;
    creatobj:SetActive(true);
    self.expressionAni = newobject(creatobj);
    self.expressionAni.transform:SetParent(self.BiaoQingFather.transform);
    self.expressionAni.transform.localScale = Vector3.one;
    self.expressionAni.transform.localPosition = Vector3.New(0, 0, 0);
    self.IsExpress = true;
end

-- 控制表情动画播放次数
function TBNNPlayer:ListenerBiaoQing()
    if self.IsExpress and self.chairid >= 0 then
        local animatorState = self.expressionAni.transform:GetComponent("Animator"):GetCurrentAnimatorStateInfo(0);
        if animatorState.normalizedTime >= 3 then self.IsExpress = false; destroy(self.expressionAni); self.expressionAni = nil; end
    end
end

function TBNNPlayer:FixedUpdate()
    --  self:ListenerBiaoQing();
    if self.StartAni then
        self.StartNum = self.StartNum + 1;
        if self.StartNum == 150 then self.StartAni = false self.StartNum = 0; self:PlayWinOrLose() end

    end
    --  error("Time.time================"..Time.deltaTime)
    self:TimerUpdate();
end

-- 清理当前局重新开始
function TBNNPlayer:GameOver()
    logYellow("===清理当前局重新开始===")
    self.ThinkingPoker:SetActive(false);
    self.SetChip:SetActive(false);
    -- 牛牛结果及加减金币
    self.Result:SetActive(false);

    -- 配牌完成
    self.Poker_Over:SetActive(false);

    for i = 0, self.ThinkingPoker.transform.childCount - 1 do
        self.ThinkingPoker.transform:GetChild(i):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
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
function TBNNPlayer:PkPoker(winlosetab)
    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i]:IsShowTimer(false, 0, 0);
    end
    if self.chairid < 0 then return end;
end

-- 所有筹码向四周扩散
function TBNNPlayer:AllChipAnimator(winlosetab, worldpos)
    for i = 1, #NiuNiuAllPlayerTable do
        local playerchairid = i - 1;
        local posnum =(playerchairid - TBNNMH.MySelf_ChairID);
        if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
        posnum = posnum + 1;
        if winlosetab[i] ~= 0 then
            NiuNiuAllPlayerTable[posnum]:PkPoker_Player(winlosetab[i]);
        end
    end
end
-- 非庄家动画
function TBNNPlayer:PkPoker_Player(winorlosenum)
    if self.chairid < 0 then return end;
    self.SetChip:SetActive(false);
  --  if self.chairid == TBNNMH.Banker_ChairID then return end

end

function TBNNPlayer:SetFirstPos()
    if self.chairid < 0 then return end;
    if self.chairid ~= TBNNMH.Banker_ChairID then return end
    local posnum =(self.chairid - TBNNMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
    self.ThinkingPoker.transform:DOLocalMove(self.startpokerpos, 0.3, false)
end

function TBNNPlayer:PaowuLine()
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
function TBNNPlayer:SetNumToImage(num, imgfather)
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
        imgfather.transform:GetChild(j - startnum):GetComponent('Image').sprite = TBNNPanel.WinLoseNum.transform:Find(newfindname):GetComponent('Image').sprite
        imgfather.transform:GetChild(j - startnum).gameObject:SetActive(true);
    end
end

-- 设置庄家图片
function TBNNPlayer:SetChangeBg(IsChange)
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
function  TBNNPlayer:SetIsStartBank()
    self.IsStartBanker:SetActive(false);
end

function TBNNPlayer:IsPGame()
    coroutine.wait(7);
    self.IsPlayingGame = 1;

end