--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-07-14 16:34:45
]]
XYSGJ_SmallGame = {};

local self = XYSGJ_SmallGame;

self.transform = nil
self.bg_Hide = nil
self.bg_Show = nil
self.movePos = nil

local CileNum = 5

local nowWheel = 1

local grilIndex = 0

local fatherImage = nil

local ClickIndex = 0

local AllWinScor = 0

local isEnd = false

local isSelfSend = false

local fun = nil
local winScore = 0

self.ZP1RotTable = {
    [1] = { 0, -180, -360 },
    [2] = { -45, -90, -135, -225, -270, -315 }
}

self.MFtable = { 3, 5, 7, 10, 12 }
self.CMtable = { 5, 7, 10, 12, 15, 25, 35, 50 }

function XYSGJ_SmallGame:Init(Obj)
    self.transform = Obj.transform

    self.mainPanel = self.transform:Find("mainPanel")

    self.ZP_1 = self.mainPanel:Find("ZP1")
    self.ZP1_Tip = self.ZP_1:Find("ZP1_5")
    self.ZP1_Tip.localScale = Vector3.New(0, 0, 0)
    self.ZP1_JT = self.ZP_1:Find("ZP1_0/ZP1_4")
    self.ZP1_MFJL = self.ZP_1:Find("ZP1_5/mfxz")
    self.ZP1_CMJL = self.ZP_1:Find("ZP1_5/cmjl")

    self.ZP_2 = self.mainPanel:Find("ZP2")
    self.ZP2_ZheZhao = self.ZP_2:Find("ZP1_0/zhehzao")
    self.ZP2_ZheZhao.gameObject:SetActive(true)

    self.ZP2_Tip = self.ZP_2:Find("ZP1_5")
    self.ZP2_Text1 = self.ZP_2:Find("ZP1_5/ZP2_Text1"):GetComponent("TextMeshProUGUI");
    self.ZP2_Tip.localScale = Vector3.New(0, 0, 0)

    self.ZP2_1 = self.ZP_2:Find("ZP1_0/ZP1_1")--转盘1
    self.ZP2_2 = self.ZP_2:Find("ZP1_0/ZP1_1/Image")--转盘2
    self.ZP2_JT = self.ZP_2:Find("ZP1_0/ZP1_4")

    self.ZP_3 = self.mainPanel:Find("ZP3")

    self.ZP3XIA = self.ZP_3:Find("ZP3_5")
    self.ZP3XIA.gameObject:SetActive(false)

    self.ZP3_ZCount = self.ZP3XIA:Find("ZP5_Text3"):GetComponent("TextMeshProUGUI")
    self.ZP3_AddCount = self.ZP3XIA:Find("ZP5_Text2"):GetComponent("TextMeshProUGUI")

    self.ZP3_MFPan = self.ZP_3:Find("ZP3_0/MFPan")
    self.ZP3_CMPan = self.ZP_3:Find("ZP3_0/CMPan")
    self.XZCount = self.ZP_3:Find("ZP3_0/ZP3_2/ZP3_Text1"):GetComponent("TextMeshProUGUI")
    self.ZP3_ZheZhao = self.ZP_3:Find("ZP3_0/zhehzao")

    self.ZP3_Tip = self.ZP_3:Find("ZP3_6")

    self.ZP3_Text1 = self.ZP3_Tip:Find("ZP3_6_2/ZP3_6_2_Text1"):GetComponent("TextMeshProUGUI");--mian  fei 
    self.ZP3_Text2 = self.ZP3_Tip:Find("ZP3_6_3/ZP3_6_3_Text2"):GetComponent("TextMeshProUGUI");--mian  fei 


    self.ZP3_Tip.localScale = Vector3.New(0, 0, 0)

    self.ZP3_ZheZhao.gameObject:SetActive(true)
end
function XYSGJ_SmallGame.Run()
    self.ZP3XIA.gameObject:SetActive(false)
    self.ZP3XIA.localPosition = Vector3.New(24, -100, 0)

    if XYSGJEntry.SmallGameData.nGameType == 1 then
        self.ZP1_MFJL.gameObject:SetActive(false)
        self.ZP1_CMJL.gameObject:SetActive(true)
        self.ZP2_2.gameObject:SetActive(true)
        self.ZP3_Text2.transform.parent.gameObject:SetActive(true)
        self.ZP3_Text2.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nOdd)
        self.ZP3_Text1.transform.parent.gameObject:SetActive(false)
        self.ZP3_Text1.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nFreeTimes)
        self.ZP3_CMPan.gameObject:SetActive(true)
        self.ZP3_MFPan.gameObject:SetActive(false)
        self.ZP_2:Find("ZP1_0/ZP1_1/Image").gameObject:SetActive(true)
    else
        self.ZP2_2.gameObject:SetActive(false)
        self.ZP1_MFJL.gameObject:SetActive(true)
        self.ZP1_CMJL.gameObject:SetActive(false)
        self.ZP3_Text2.transform.parent.gameObject:SetActive(false)
        self.ZP3_Text2.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nOdd)
        self.ZP3_Text1.transform.parent.gameObject:SetActive(true)
        self.ZP3_Text1.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nFreeTimes)
        self.ZP3_CMPan.gameObject:SetActive(false)
        self.ZP3_MFPan.gameObject:SetActive(true)
        self.ZP_2:Find("ZP1_0/ZP1_1/Image").gameObject:SetActive(false)
    end

    fun = coroutine.start(function()
        self.ZP_1.localScale = Vector3(0, 0, 0)
        self.ZP_2.localScale = Vector3(0, 0, 0)
        self.ZP_3.localScale = Vector3(0, 0, 0)
        coroutine.wait(0.1)
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuangchang, 1.2);
        XYSGJEntry.tipSmallGame.gameObject:SetActive(true)
        coroutine.wait(1.2)
        XYSGJEntry.tipSmallGame.gameObject:SetActive(false)
        for i = 1, #XYSGJEntry.zpPostable do
            if XYSGJEntry.zpPostable[i] == 1 then
                self.ZP_1.localPosition = Vector3.New(self.ZP_1.localPosition.x, 80, 0)
            elseif XYSGJEntry.zpPostable[i] == 4 then
                self.ZP_1.localPosition = Vector3.New(self.ZP_1.localPosition.x, 0, 0)
            elseif XYSGJEntry.zpPostable[i] == 7 then
                self.ZP_1.localPosition = Vector3.New(self.ZP_1.localPosition.x, -80, 0)
            elseif XYSGJEntry.zpPostable[i] == 2 then
                self.ZP_2.localPosition = Vector3.New(self.ZP_2.localPosition.x, 80, 0)
            elseif XYSGJEntry.zpPostable[i] == 5 then
                self.ZP_2.localPosition = Vector3.New(self.ZP_2.localPosition.x, 0, 0)
            elseif XYSGJEntry.zpPostable[i] == 8 then
                self.ZP_2.localPosition = Vector3.New(self.ZP_2.localPosition.x, -80, 0)
            elseif XYSGJEntry.zpPostable[i] == 3 then
                self.ZP_3.localPosition = Vector3.New(self.ZP_3.localPosition.x, 80, 0)
            elseif XYSGJEntry.zpPostable[i] == 6 then
                self.ZP_3.localPosition = Vector3.New(self.ZP_3.localPosition.x, 0, 0)
            elseif XYSGJEntry.zpPostable[i] == 9 then
                self.ZP_3.localPosition = Vector3.New(self.ZP_3.localPosition.x, -80, 0)
            end
        end
        self.transform.gameObject:SetActive(true)
        coroutine.wait(0.2)
        self.ZP_1.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 1);
        self.ZP_2.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 1)
        self.ZP_3.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 1):OnComplete(function()

            XYSGJ_SmallGame.ZP1ROT()
        end)
    end)
end
function XYSGJ_SmallGame.ZP1ROT()
    self.ZP_1.transform:SetSiblingIndex(3)
    local fun1 = coroutine.start(function()
        local jlRot = 0
        if XYSGJEntry.SmallGameData.nGameType == 1 then
            jlRot = self.ZP1RotTable[1][math.random(1, 3)]
        else
            jlRot = self.ZP1RotTable[2][math.random(1, 6)]
        end
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuanpan, 5);
        self.ZP_1:Find("ZP1_0"):Find("ZP1_1"):DORotate(Vector3.New(0, 0, -360 * 8 + jlRot), 5):OnComplete(function()
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jg);
            self.ZP1_Tip.transform:DOScale(Vector3.New(1, 1, 1), 0.5):OnComplete(
                    self.ZP_1.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 0.8):OnComplete(function()
                        self.ZP2ROT()
                    end))
        end)
    end)
    self.ZP_1.transform:DOScale(Vector3.New(0.8, 0.8, 1.2), 0.8):OnComplete(fun1)
end
function XYSGJ_SmallGame.ZP2ROT()
    self.ZP_2.transform:SetSiblingIndex(3)
    self.ZP2_ZheZhao.gameObject:SetActive(false)
    local fun1 = coroutine.start(function()
        local jlRot = 0
        self.ZP2_Text1.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nGameCount)--第三次次数
        if XYSGJEntry.SmallGameData.nGameType == 1 then
            if XYSGJEntry.SmallGameData.nGameCount == 3 then
                local tb = { 0, -270 }
                jlRot = tb[math.random(1, 2)]
            elseif XYSGJEntry.SmallGameData.nGameCount == 10 then
                jlRot = -45
            elseif XYSGJEntry.SmallGameData.nGameCount == 2 then
                jlRot = -90
            elseif XYSGJEntry.SmallGameData.nGameCount == 7 then
                jlRot = -135
            elseif XYSGJEntry.SmallGameData.nGameCount == 1 then
                jlRot = -180
            elseif XYSGJEntry.SmallGameData.nGameCount == 5 then
                local tb = { -225, -315 }
                jlRot = tb[math.random(1, 2)]
            end
            self.ZP_2:Find("ZP1_0/ZP1_1/Image").gameObject:SetActive(true)
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuanpan, 5);
            self.ZP_2:Find("ZP1_0/ZP1_1/Image"):DORotate(Vector3.New(0, 0, -360 * 8 + jlRot), 5):OnComplete(function()
                XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jg);
                self.ZP2_Tip.transform:DOScale(Vector3.New(1, 1, 1), 0.8):OnComplete(function()
                    self.ZP_2.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 0.8):OnComplete(function()
                        XYSGJ_SmallGame.ZP3ROT()
                    end)
                end)
            end)
        else
            if XYSGJEntry.SmallGameData.nGameCount == 1 then
                jlRot = 0
            elseif XYSGJEntry.SmallGameData.nGameCount == 5 then
                jlRot = -45
            elseif XYSGJEntry.SmallGameData.nGameCount == 3 then
                local tb = { -90, -225 }
                jlRot = tb[math.random(1, 2)]
            elseif XYSGJEntry.SmallGameData.nGameCount == 4 then
                local tb = { -135, -315 }
                jlRot = tb[math.random(1, 2)]
            elseif XYSGJEntry.SmallGameData.nGameCount == 2 then
                local tb = { -180, -270 }
                jlRot = tb[math.random(1, 2)]
            end
            self.ZP_2:Find("ZP1_0/ZP1_1/Image").gameObject:SetActive(false)
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuanpan, 5);
            self.ZP_2:Find("ZP1_0/ZP1_1"):DORotate(Vector3.New(0, 0, -360 * 8 + jlRot), 5):OnComplete(function()
                XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jg);
                self.ZP2_Tip.transform:DOScale(Vector3.New(1, 1, 1), 0.5):OnComplete(function()
                    self.ZP_2.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 0.8):OnComplete(function()
                        XYSGJ_SmallGame.ZP3ROT()
                    end)
                end)
            end)
        end
    end)
    self.ZP_2.transform:DOScale(Vector3.New(0.8, 0.8, 1.2), 0.8):OnComplete(fun1)
end

function XYSGJ_SmallGame.ZP3ROT()
    self.ZP3_ZheZhao.gameObject:SetActive(false)
    self.ZP_3.transform:SetSiblingIndex(3)

    local MFNum = XYSGJEntry.SmallGameData.nFreeTimes --免费总次数
    local CMNum = XYSGJEntry.SmallGameData.nOdd       --筹码总次数
    local _Count = XYSGJEntry.SmallGameData.nGameCount;--旋转的次数

    _Count = #XYSGJEntry.SmallGameData.nGameinfo

    self.XZCount.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nGameCount)
    local AllCount = 0
    local fun1 = coroutine.start(function()
        self.ZP3XIA.gameObject:SetActive(true)
        self.ZP3XIA:DOLocalMove(Vector3.New(24, -240, 0), 0.7)
        self.ZP3_ZCount.text = XYSGJEntry.ShowText(0)
        self.ZP3_AddCount.text = XYSGJEntry.ShowText(0)
        coroutine.wait(0.8)

        while _Count > 0 do
            if XYSGJEntry.SmallGameData.nGameType == 1 then
                local num = XYSGJEntry.SmallGameData.nGameinfo[_Count]
                local jlRot = 0
                if XYSGJEntry.SmallGameData.nGameinfo[_Count] == 5 then
                    jlRot = -180
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 7 then
                    jlRot = -90
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 10 then
                    jlRot = -0
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 12 then
                    jlRot = -270
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 15 then
                    jlRot = -225
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 25 then
                    jlRot = -135
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 35 then
                    jlRot = -315
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 50 then
                    jlRot = -45
                end
                XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuanpan, 5);

                self.ZP3_CMPan:DORotate(Vector3.New(0, 0, -360 * 8 + jlRot), 5):OnComplete(function()

                    logYellow("转盘旋转")
                    self.ZP3_AddCount.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nGameinfo[_Count])

                    Util.RunWinScore(XYSGJEntry.SmallGameData.nGameinfo[_Count], 0, 0.8, function(value)
                        self.currentRunGold = math.ceil(value);
                        self.ZP3_AddCount.text = XYSGJEntry.ShowText(self.currentRunGold);
                    end)

                    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jf);

                    Util.RunWinScore(AllCount, (AllCount + XYSGJEntry.SmallGameData.nGameinfo[_Count]), 1, function(value)
                        self.currentRunGold = math.ceil(value);
                        self.ZP3_ZCount.text = XYSGJEntry.ShowText(self.currentRunGold);
                    end)
                    AllCount = AllCount + XYSGJEntry.SmallGameData.nGameinfo[_Count]
                    _Count = _Count - 1
                    self.XZCount.text = XYSGJEntry.ShowText(_Count)
                end)
                coroutine.wait(7.5)
            else
                local num = XYSGJEntry.SmallGameData.nGameinfo[_Count]
                local jlRot = 0
                if XYSGJEntry.SmallGameData.nGameinfo[_Count] == 3 then
                    local tb = { 0, -90 }
                    jlRot = tb[math.random(1, 2)]
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 5 then
                    local tb = { -180, -270 }
                    jlRot = tb[math.random(1, 2)]
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 7 then
                    local tb = { -135, -315 }
                    jlRot = tb[math.random(1, 2)]
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 10 then
                    jlRot = -225
                elseif XYSGJEntry.SmallGameData.nGameinfo[_Count] == 12 then
                    jlRot = -45
                end
                XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_zhuanpan, 5);
                self.ZP3_MFPan:DORotate(Vector3.New(0, 0, -360 * 8 + jlRot), 5):OnComplete(function()

                    self.ZP3_AddCount.text = XYSGJEntry.ShowText(XYSGJEntry.SmallGameData.nGameinfo[_Count])

                    Util.RunWinScore(XYSGJEntry.SmallGameData.nGameinfo[_Count], 0, 0.8, function(value)
                        self.currentRunGold = math.floor(value);
                        self.ZP3_AddCount.text = XYSGJEntry.ShowText(self.currentRunGold);
                    end)

                    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jf);
                    Util.RunWinScore(AllCount, (AllCount + XYSGJEntry.SmallGameData.nGameinfo[_Count]), 1, function(value)
                        self.currentRunGold = math.ceil(value);
                        self.ZP3_ZCount.text = XYSGJEntry.ShowText(self.currentRunGold);
                    end)
                    AllCount = AllCount + XYSGJEntry.SmallGameData.nGameinfo[_Count]
                    _Count = _Count - 1
                    self.XZCount.text = XYSGJEntry.ShowText(_Count)
                end)
                coroutine.wait(7.5)
            end
        end
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.zhuanpan_jg);
        self.ZP3_Tip.transform:DOScale(Vector3.New(1, 1, 1), 0.8):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            XYSGJ_SmallGame.Close();
        end)
    end)
    self.ZP_3.transform:DOScale(Vector3.New(0.8, 0.8, 1.2), 0.8):SetEase(DG.Tweening.Ease.Linear):OnComplete(fun1)
end

function XYSGJ_SmallGame.Close()
    self.transform.gameObject:SetActive(false)
    XYSGJ_SmallGame.SmallGameClean()
    XYSGJEntry.ResultData.isSmallGame = 0
    XYSGJEntry.isSmallGame = false
    if XYSGJEntry.SmallGameData.nGameType == 1 then
        XYSGJ_Result.ShowSmallResult(XYSGJEntry.CurrentChip * XYSGJEntry.SmallGameData.nOdd)
    else
        XYSGJEntry.freeText.text = ShowRichText(XYSGJEntry.SmallGameData.nFreeTimes);
        XYSGJ_Result.CheckFree()
    end
end

function XYSGJ_SmallGame.SmallGameClean()
    self.ZP2_ZheZhao.gameObject:SetActive(true)
    self.ZP3_ZheZhao.gameObject:SetActive(true)
    self.ZP1_Tip.localScale = Vector3.New(0, 0, 0)
    self.ZP2_Tip.localScale = Vector3.New(0, 0, 0)
    self.ZP3XIA.gameObject:SetActive(false)
    self.ZP3XIA.localPosition = Vector3.New(24, -100, 0)
    self.ZP3_Tip.localScale = Vector3.New(0, 0, 0)

end