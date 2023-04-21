SetInfoSystem = { }
local self = SetInfoSystem;
local bgMusic = 1;
local Effect = 1;
local Brightness = 0.6;
local SetLuaBeHaviour = nil;
local gameObject = nil;
-- 游戏音量静音
local IsgameMute = false;
-- 游戏音效静音
local IsEffectMute = false;
IsMusicMuteBl = false;
IsEffectMuteBl = false;
-- 判断是否初始化
local StartBl = false;
--只初始化一次分享
IsInitShare = false;
self.updatetime = 0;
-- ===========================================设置+客服+分享信息系统======================================
function SetInfoSystem.Open(father, lua)
    if self.SetInfoPanel == nil then
        self.SetInfoPanel = "obj";
        self.father = father;
        self.lua = lua;
        --ResManager:LoadAsset("module02/hall_set", "SetInfoPanel", self.OnCreacterChildPanel_Set);
        self.OnCreacterChildPanel_Set(HallScenPanel.Pool("SetInfoPanel"));
    end
end

-- 客服
function SetInfoSystem.OpenKefu()
    if self.KefuPanel == nil then
        self.KefuPanel = "obj";

        --ResManager:LoadAsset("module02/hall_feedback", "UserFeedback", self.OnCreacterChildPanel_Kefu);
        self.OnCreacterChildPanel_Kefu(newobject(HallScenPanel.Pool("UserFeedback")));
    end
end

-- 创建UI的子面板_设置
function SetInfoSystem.OnCreacterChildPanel_Set(prefeb)
    local go = newobject(prefeb);
    go.transform:SetParent(HallScenPanel.Compose.transform);
    local newlua = HallScenPanel.LuaBehaviour
    if self.father ~= nil then
        go.transform:SetParent(self.father.transform);
        newlua = self.lua
    end ;
    go.name = "SetPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.SetInfoPanel = go;
    SetInfoSystem.Init(self.SetInfoPanel, newlua);
    SetInfoSystem.ShowPanel(self.SetInfoPanel);
end

--创建客服子界面
function SetInfoSystem.OnCreacterChildPanel_Kefu(prefeb)
    local go = newobject(prefeb);
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "UserFeedback";
    go.layer = 5;
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.KefuPanel = go;
    self.kefuCloseBtn = go.transform:Find("CloseBtn").gameObject;
    self.BgCloseBtn = go.transform:Find("BgCloseBtn").gameObject;
    --提交
    self.SureBtn = go.transform:Find("SureBtn").gameObject;
    --用户反馈内容
    self.Info = go.transform:Find("Info");
    --用户反馈图片(与上传头像方式相同)
    self.SeedImgBtn = go.transform:Find("SeedImgBtn").gameObject;
    self.SeedImgBtn.transform.localScale = Vector3.New(0, 0, 0);
    SetInfoSystem.ShowPanel(self.KefuPanel);
    HallScenPanel.LuaBehaviour:AddClick(self.kefuCloseBtn, self.KefuCloseBtnOnClick);
    HallScenPanel.LuaBehaviour:AddClick(self.BgCloseBtn, self.KefuCloseBtnOnClick);
    HallScenPanel.LuaBehaviour:AddClick(self.SeedImgBtn, self.SeedImgOnClick);
    HallScenPanel.LuaBehaviour:AddClick(self.SureBtn, self.SureBtnOnClick);
    --http://聊天服务器映射机IP:8080/FeedBackPage.aspx?ID=10025&Remark=我一般

end

function SetInfoSystem.SeedImgOnClick()
    MessageBox.CreatGeneralTipsPanel("目前本地相册不支持该平台");
    do
        return
    end
    --调用相机
    if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
        MessageBox.CreatGeneralTipsPanel("目前本地相册不支持该平台");
        return
    end ;
    if (Util.isApplePlatform) then
        -- self.waitPanel.transform:GetComponent("Image").color= Color.New(1, 1, 1, 1);  self.waitPanel:SetActive(true);
        GameObject.FindGameObjectWithTag("GuiCamera").transform.localPosition = Vector3.New(0, 10000, 0)
    end
    NetManager:CallPhoto(self.LocalPhoneCallBack);
end
-- 返回相机或者相册中的图片
local SeedImgType = 1; -- 1 表示没有上传 2 上传成功 3 上传失败
function SetInfoSystem.LocalPhoneCallBack(img, _sprite)
    error("LocalPhoneCallBack.....");
    GameObject.FindGameObjectWithTag("GuiCamera").transform.localPosition = Vector3.New(0, 0, 0)
    if img == nil and _sprite == nil then
        return
    end
    local imgUrl = PathHelp.AppHotfixResPath .. "Feedback.png";
    local bl = Util.SaveFile(img, imgUrl);
    ChangePhoto = true;
    if ChangePhoto then
        ChangePhoto = false;
        -- 上传头像
        changeimg = img;
        local url = "http://" .. gameip .. ":8075/FeedBackPage.aspx?ID=" .. SCPlayerInfo._33PlayerID .. "&Remark=" .. self.Info:GetComponent('InputField').text
        local isUpdate = NetManager:UpLoadHeaderFile(url, imgUrl);
        if isUpdate then
            SeedImgType = 2;
        else
            SeedImgType = 3;
        end
    else
    end
end

function SetInfoSystem.checkUpHead()
    if SeedImgType ~= 1 then
        if SeedImgType == 2 then
            MessageBox.CreatGeneralTipsPanel("上传附件成功");
        else
            MessageBox.CreatGeneralTipsPanel("上传附件失败，请重试");
        end
        SeedImgType = 1;
    end
end

function SetInfoSystem.SureBtnOnClick(obj)
    local str = self.Info:GetComponent('InputField').text;
    if str == nil or str == " " then
        return
    end
    if string.len(str) < 5 then
        MessageBox.CreatGeneralTipsPanel("请详细描述你要反馈得问题");
        return
    end
    if (string.find(str, "%d")) or (string.find(str, "%w")) then
        local wenzi = false
        local curByte = 0;
        for i = 1, string.len(str) do
            curByte = string.byte(str, i);
            if (curByte > 127) then
                wenzi = true
            end
        end

        if not wenzi then
            MessageBox.CreatGeneralTipsPanel("请正确描述你要反馈得问题");
            return ;
        end
    end
    if (os.time() - self.updatetime) < 60 then
        MessageBox.CreatGeneralTipsPanel("请勿频繁提交反馈");
        SetInfoSystem.KefuCloseBtnOnClick();
        return
    end ;
    obj.transform:GetComponent("Button").interactable = false;
    local content = self.Info:GetComponent('InputField').text;
    --error("content1=="..content);
    content = Util.ToHex(content);
    --error("content2=="..content);
    local configerWebUrl = "http://" .. gameip .. ":8075/FeedBackPage.aspx?ID=" .. SCPlayerInfo._33PlayerID .. "&Remark=" .. content;
    --error(configerWebUrl);
    local GetConfigerWebUrl = UnityEngine.WWW.New(configerWebUrl)
    obj.transform:GetComponent("Button").interactable = true;
    local function Configer()
        while not GetConfigerWebUrl.isDone do
        end
        if GetConfigerWebUrl.error ~= nil then
            MessageBox.CreatGeneralTipsPanel("反馈失败");
            return ;
        end
        if GetConfigerWebUrl.error == nil then
            MessageBox.CreatGeneralTipsPanel("反馈完成");
            self.updatetime = os.time();
            SetInfoSystem.KefuCloseBtnOnClick();
        end
    end
    coroutine.start(Configer);
    --MessageBox.CreatGeneralTipsPanel("反馈完成");
end

-- 关闭设置信息面板
function SetInfoSystem.KefuCloseBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    -- 恢复被禁用的状态

    destroy(self.KefuPanel);
    self.KefuPanel = nil;
end

function SetInfoSystem.Init(obj, LuaBeHaviour)
    local t = obj.transform;
    gameObject = obj;
    -- 赋值自己
    self.SetInfoPanel = obj;
    self.SetCloseBtn = t:Find("SetCloseBtn").gameObject;
    self.AccountChangeBtn = t:Find("Bg/AccountChangeBtn").gameObject;
    self.AccountChangeBtn:SetActive(gameIsOnline);
    self.RestorBtn = t:Find("Bg/RestorBtn").gameObject;
    self.RestorBtn:SetActive(false);
    if self.father ~= nil then
        self.AccountChangeBtn:SetActive(false);
    end
    self.AccountChangeBtn.transform.localPosition = Vector3.New(277, 100, 0)
    --头像基本信息
    self.HeadImg = t:Find("Bg/HeadMask/Head").gameObject;
    self.Name = t:Find("Bg/AccounSettTxt/Name").gameObject;
    self.ID = t:Find("Bg/AccounSettTxt/ID").gameObject;

    self.BgMusicMute = t:Find("Bg/BgMusic/Bg/CloseBtn").gameObject;
    self.GameEffectMute = t:Find("Bg/GameEffect/Bg/CloseBtn").gameObject;

    --开启声音  
    self.BgMusicReset = t:Find("Bg/BgMusic/Bg/OpenBtn").gameObject;
    self.GameEffectReset = t:Find("Bg/GameEffect/Bg/OpenBtn").gameObject;

    -- 绑定点击事件
    LuaBeHaviour:AddClick(self.SetCloseBtn, self.SetCloseBtnOnClick);
    LuaBeHaviour:AddClick(self.RestorBtn, self.GameRestore);
    LuaBeHaviour:AddClick(self.BgMusicMute, self.GameMute);
    LuaBeHaviour:AddClick(self.GameEffectMute, self.EffectMute);
    LuaBeHaviour:AddClick(self.BgMusicReset, self.ResetMute);
    LuaBeHaviour:AddClick(self.GameEffectReset, self.ResetMute);
    LuaBeHaviour:AddClick(self.AccountChangeBtn, self.AccountChangeBtnOnClick);

    --    LuaBeHaviour:AddSliderEvent(self.BgMusicSlider, self.GameAduio);
    --    LuaBeHaviour:AddSliderEvent(self.GameEffectSlider, self.GameSoundEffect);
    SetLuaBeHaviour = LuaBeHaviour;
    -- 这里gameIsOnline代表是否上线,上线需要屏蔽东西的
    self.AccountChangeBtn:SetActive(gameIsOnline);
    if (SetLuaBeHaviour == GameSetsBtnInfo._LuaBehaviour) then
        self.AccountChangeBtn:SetActive(false);
    end ;
    self.BgMusicReset:SetActive(false);
    self.GameEffectReset:SetActive(false);
    self.BgMusicMute:SetActive(true);
    self.GameEffectMute:SetActive(true);
    StartBl = true;
    bgMusic = AllSetGameInfo._1audio;
    Effect = AllSetGameInfo._2soundEffect;
    if AllSetGameInfo._6IsPlayEffect == false then
        self.GameEffectReset:SetActive(true);
        self.GameEffectMute:SetActive(false);
    end ;
    if AllSetGameInfo._5IsPlayAudio == false then
        self.BgMusicReset:SetActive(true);
        self.BgMusicMute:SetActive(false);
    end ;
    StartBl = false;

    --初始化基本信息
    self.HeadImg:GetComponent("Image").sprite = HallScenPanel.Compose.transform:Find("HeadImg/Image/Image"):GetComponent("Image").sprite;
    self.Name:GetComponent('Text').text = "昵称：" .. (SCPlayerInfo._05wNickName);
    self.ID:GetComponent('Text').text = "帐号：" .. tostring(SCPlayerInfo._beautiful_Id + 10000);

end

----隐藏和显示一个transform
function SetInfoSystem.ShowPanel(g)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0);
        -- HallScenPanel.SetXiaoGuo(g)
    else
        t.localPosition = Vector3.New(0, 1000, 0);
    end
end
-- 关闭设置信息面板
function SetInfoSystem.SetCloseBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    self.ShowPanel(self.SetInfoPanel);
    -- 恢复被禁用的状态
    self.father = nil

    if (SetLuaBeHaviour ~= GameSetsBtnInfo._LuaBehaviour) then
        destroy(self.SetInfoPanel);
        self.SetInfoPanel = nil;
    else
        destroy(self.SetInfoPanel);
        self.SetInfoPanel = nil;
    end ;
end


-- 恢复原本设置
function SetInfoSystem.GameRestore()
    HallScenPanel.PlayeBtnMusic();
    AllSetGameInfo._1audio = 1;
    AllSetGameInfo._2soundEffect = 1;
    AllSetGameInfo._4quality = 4;
    GameManager.SetSoundValue(AllSetGameInfo._2soundEffect, AllSetGameInfo._1audio);
    AllSetGameInfo._5IsPlayAudio = true;
    AllSetGameInfo._6IsPlayEffect = true;
    GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    self.BgMusicReset:SetActive(false);
    self.BgMusicMute:SetActive(true);
    self.GameEffectReset:SetActive(false);
    self.GameEffectMute:SetActive(true);
end

-- 设置游戏画质低
function SetInfoSystem.GameQualityLow()
    -- log("设置画质为低品质");
    HallScenPanel.PlayeBtnMusic();
    self.QualityLow:GetComponent('Button').interactable = false;
    self.QualityMid:GetComponent('Button').interactable = true;
    self.QualityHigh:GetComponent('Button').interactable = true;
    GameManager.SetGameQuality(2);
    AllSetGameInfo._4quality = 2;
end
-- 设置游戏画质中
function SetInfoSystem.GameQualityMid()
    -- log("设置画质为中品质");
    HallScenPanel.PlayeBtnMusic();
    self.QualityLow:GetComponent('Button').interactable = true;
    self.QualityMid:GetComponent('Button').interactable = false;
    self.QualityHigh:GetComponent('Button').interactable = true;
    GameManager.SetGameQuality(4);
    AllSetGameInfo._4quality = 4;
end
-- 设置游戏画质高
function SetInfoSystem.GameQualityHigh()
    -- log("设置画质为高品质");
    HallScenPanel.PlayeBtnMusic();
    self.QualityLow:GetComponent('Button').interactable = true;
    self.QualityMid:GetComponent('Button').interactable = true;
    self.QualityHigh:GetComponent('Button').interactable = false;
    GameManager.SetGameQuality(6);
    AllSetGameInfo._4quality = 6;
end

-- 设置游戏音量
function SetInfoSystem.GameAduio(args)
    if StartBl == false then
        bgMusic = args
        AllSetGameInfo._1audio = bgMusic;
        GameManager.SetSoundValue(Effect, bgMusic);
    end
end
-- 设置游戏音效
function SetInfoSystem.GameSoundEffect(args)
    if StartBl == false then
        Effect = args;
        AllSetGameInfo._2soundEffect = Effect;
        GameManager.SetSoundValue(Effect, bgMusic);
    end
end
-- 设置游戏亮度
function SetInfoSystem.GameBrightness(args)
    -- log("改变屏幕亮度");
end

-- 帐号切换
function SetInfoSystem.AccountChangeBtnOnClick()
    error("帐号切换");
    local buffer = ByteBuffer.New();
    buffer:WriteUInt16(0);
    Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGOUT, buffer, gameSocketNumber.HallSocket);
    LogonScenPanel.New().Create();
end

function SetInfoSystem.AccountChange()
    logError("帐号切换，收到服务器消息");
    GameNextScen = gameScenName.LOGON;
    HallScenPanel.logonover = false;
    --  LogonScenPanel.New().Create();
    local pos = HallScenPanel.RecFrameBtns.transform.localPosition
    if pos.x < 600 then
        HallScenPanel.RecFrameBtns.transform.localPosition = Vector3.New(1000, pos.y, pos.z)
        HallScenPanel.RecFrameBtns:SetActive(false);
    end
end

function SetInfoSystem.GameMute()
    self.EffectMute();
end
function SetInfoSystem.MuteMusic()
    AllSetGameInfo._5IsPlayAudio = false;
    --IsMusicMuteBl = false;
    MusicManager:SetMusicMute(true);
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end
function SetInfoSystem.MuteSound()
    MusicManager:SetSoundMute(true);
    --IsEffectMuteBl = false;
    AllSetGameInfo._6IsPlayEffect = false;
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end
function SetInfoSystem.PlayMusic()
    MusicManager:SetMusicMute(false);
    AllSetGameInfo._5IsPlayAudio = true;
    --IsMusicMuteBl = true;
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end
function SetInfoSystem.PlaySound()   
    MusicManager:SetSoundMute(false);
    --IsEffectMuteBl = true;
    AllSetGameInfo._6IsPlayEffect = true;
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end
function SetInfoSystem.EffectMute()
    MusicManager:SetMusicMute(true);
    MusicManager:SetSoundMute(true);
    --HallScenPanel.PlayeBtnMusic();
    --IsEffectMute = true;
    --IsEffectMuteBl = true;
    AllSetGameInfo._5IsPlayAudio = false;
    AllSetGameInfo._6IsPlayEffect = false;
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end

-- 游戏音量启用
function SetInfoSystem.ResetMute()
    MusicManager:SetMusicMute(false);
    MusicManager:SetSoundMute(false);
    --IsgameMute = false;
    --IsMusicMuteBl = false;
    AllSetGameInfo._5IsPlayAudio = true;
    --IsEffectMute = false;
    --IsEffectMuteBl = false;
    AllSetGameInfo._6IsPlayEffect = true;
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end

function SetInfoSystem.ShareOpen()
    if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
        FramePopoutCompent.Show("分享不支持该平台");
        return
    end ;
    --友盟key   

    Util.CreatDireCtory(PathHelp.AppHotfixResPath .. "head");
    local fe = io.open(PathHelp.AppHotfixResPath .. "head/bjshare.png")
    if fe == nil then
        NetManager:getLocalImag("http://" .. gameip .. ":28082/Res/FX/images/bjshare.png", PathHelp.AppHotfixResPath .. "head/bjshare.png", self.ShareOpenOver, HallScenPanel.LeftBtn);
    end
    if fe ~= nil then
        self.ShareOpenOver(0, 0);
    end
    fe:close();
end

function SetInfoSystem.ShareOpenOver(isscu, sp)
    local Sharekey = nil
    --QQ开发平台ID 
    local qqappid;
    --QQ开发平台key
    local qqappkey;
    --分享平台QQid的枚举
    local qqid;
    --分享平台微信id的枚举
    local wxid;
    if Util.isAndroidPlatform then
        Sharekey = "5829a607a40fa35a790035e0";
    end
    if Util.isApplePlatform then
        Sharekey = "5829957ac62dca78520009b1";
    end
    --分享标题
    local titel = "【3D鱼鱼乐】";
    --主要内容
    local conten = "3D捕鱼、老虎机、水浒传、经典水果机游戏让你回味经典!";
    --图片的网页地址
    --   Application.CaptureScreenshot("Test.png");
    --local imgeurl ="http://"..gameip..":8089/images/bjshare.png?v=" .. os.date("%Y%m%d%H%M%S");
    local imgeurl = PathHelp.AppHotfixResPath .. "head/bjshare.png"--Application.persistentDataPath+"/Test.png";
    --点击分享内容打开的网页地址
    local shareIP = nil;
    if GCF ~= nil then
        shareIP = GCF["noscvip"] or nil
    end
    if shareIP == nil then
        shareIP = gameip;
    end
    local weburl = "http://" .. shareIP .. ":28083/Res/FX/FX.share?v=" .. os.date("%Y%m%d%H%M%S");
    --分享平台的枚举
    local PT = { 1, 2, 3, 4 };
    --不同平台id 和 ke 不一样
    --if Util.isAndroidPlatform then qqappid="1105747315"; qqappkey="ETodzkS25GzDrG7U"; end
    --if Util.isApplePlatform then qqappid="1105821630"; qqappkey="RmVaLSmyYhjzn7Fr"; end
    if Util.isAndroidPlatform then
        qqappid = "1105747317";
        qqappkey = "ETodzkS25GzDrG7U";
    end
    if Util.isApplePlatform then
        qqappid = "1105821639";
        qqappkey = "RmVaLSmyYhjzn7Fr";
    end
    --qq  微信 的枚举
    qqid = "3";
    wxid = "1";
    --构建分享平台的参数包
    --local ID = { qqid, qqappid, qqappkey, wxid, "wxaa644bb6233bf2a3", "32e3e2bee44488800c79d1206d0c348d" };
    --local ID = { qqid, qqappid, qqappkey, wxid,"wx9b5ba6412501b319", "c08c86b875683bc4b230e7359b4edfab" };
    local ID = { qqid, qqappid, qqappkey, wxid, "wx2c84deabb768c96d", "2222d39168977b25cacbf8d8d342fb24" };
    --初始化分享
    NetManager:InitShare(Sharekey, PT, ID, titel, conten, imgeurl, weburl, self.OneKeyShareBtnOnClickCallBack);
    IsInitShare = true;
end

function SetInfoSystem.OneKeyShareBtnOnClickCallBack(args)
    --args 是分享后的回掉，成功后 args中有成功的关键字，失败后 args中有失败的关键字
    error(args);
    MessageBox.CreatGeneralTipsPanel(args);
    if not string.find(args, "成功") then
        return
    end
    if SCPlayerInfo._15bTodayShare == 0 then
        local data = { [1] = 0, }
        local buffer = ByteBuffer.New();
        buffer = SetC2SInfo(CS_ShareAndGetAward, data)
        Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_SHARE_AND_GET_AWARD, buffer, gameSocketNumber.HallSocket);
    end
end

function SetInfoSystem.ShareEndSCInfo(buffer, wSize)
    if wSize == 0 then
        MessageBox.CreatGeneralTipsPanel("分享成功,获得相应奖励");
        if self.SharePanel == nil then
            SCPlayerInfo._15bTodayShare = 1;
            SCPlayerInfo._14byHasShareDay_Id = SCPlayerInfo._14byHasShareDay_Id + 1;
            HallScenPanel.UpdatePropInfo();
        else
            self.dayInfo.transform:GetChild(SCPlayerInfo._14byHasShareDay_Id):Find("Share").gameObject:SetActive(true);
            self.dayInfo.transform:GetChild(SCPlayerInfo._14byHasShareDay_Id):Find("NoShare").gameObject:SetActive(false);
            SCPlayerInfo._15bTodayShare = 1;
            SCPlayerInfo._14byHasShareDay_Id = SCPlayerInfo._14byHasShareDay_Id + 1;
            self.ShareDay:GetComponent('Text').text = SCPlayerInfo._14byHasShareDay_Id;
            HallScenPanel.UpdatePropInfo();
        end

    else
        MessageBox.CreatGeneralTipsPanel("分享失败：" .. buffer:ReadString(wSize));
    end
end
