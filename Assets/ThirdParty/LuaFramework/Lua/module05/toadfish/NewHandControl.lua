local _CNewHandControl = class("_CNewHandControl");
local CAtlasNumber = GameRequire("AtlasNumber");
local TotalStep = 4;

local STEP_OPREATION = {
    [1] = {isClickScreen=true,}, 
    [2] = {isClickScreen=false,},
    [3] = {isClickScreen=false,},
    [4] = {isClickScreen=true,},
};

local SWITCH_STATE = {
    SwitchWait   = 0,
    SwitchAction = 1,
};

function _CNewHandControl:ctor()
    self._isScalePaotai = false;
end


--�����������
function _CNewHandControl:CompleteNewHand()
    G_GlobalGame:DispatchEventByStringKey("NewHandEnd");
    self._isNewHand = false;
    
end

--��ʼ��
function _CNewHandControl:Init(transform,_curChairId)
    self._step = 1;
    self._isNewHand = true;
    self.gameObject = transform.gameObject;
    self.transform  = transform;
    self.transform:SetParent(_parent);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localScale    = Vector3.New(1,1,1);
    self._bg  = self.transform:Find("Bg");
    local event = Util.AddComponent("EventTriggerListener", self._bg.gameObject);
    event.onClick = handler(self,self.OnBgClick);

    self._infoPos = self.transform:Find("InfoPos");

    local alignView = self._infoPos.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;

    self._playerPanel = self._infoPos:Find("DownPlayer");
    local count = self._playerPanel.childCount;
    self._players = {};
    self._players[1] = self._playerPanel:Find("Player1");
    self._players[2] = self._playerPanel:Find("Player2");
    self._players[1].localPosition = Vector3.New(190,0,0);
    self._players[2].localPosition = Vector3.New(-480,0,0);
    self._players[1].gameObject:SetActive(false);
    self._players[2].gameObject:SetActive(false);
    if _curChairId==0 or _curChairId==2 then
        self._curPlayer = self._players[1];
    else
        self._curPlayer = self._players[2];
    end
    self._arrow =  self._curPlayer:Find("Arraw");

    --��ǰ
    self._curPlayer = self._curPlayer;
    self._steps = self._infoPos:Find("Steps");



    self.steps = {};
    for i=1,TotalStep do
        self.steps[i] = self._steps:Find("Step" .. i);
    end
    self._curStepTrans = self.steps[self._step];
    self._curStepTrans.gameObject:SetActive(true);

    --������̨
    local player = G_GlobalGame._goFactory:createGuidePlayer();
    self._playerTransform = player.transform;
    local localPosition = self._playerTransform.localPosition;
    local localScale    = self._playerTransform.localScale;
    self._playerTransform:SetParent(self._curPlayer);
    self._playerTransform.localPosition = localPosition;
    self._playerTransform.localScale = localScale;
    self._paos=self._playerTransform:Find("Paos");
    self._paoBg = self._playerTransform:Find("Bg");

    --������
    --event = Util.AddComponent("EventTriggerListener", self._paoBg.gameObject);
    --event.onClick = handler(self,self.OnAddClick);

    --�л���
    self._switchPao         = self._playerTransform:Find("SwitchPao");
    if self._switchPao then
        eventTrigger  = Util.AddComponent("EventTriggerListener",self._switchPao.gameObject);
        eventTrigger.onClick= handler(self,self.OnAddClick);
    end

    --�ӵ�����
    self.multiplePanel  = self._playerTransform:Find("Info");
    local numberImage = self.multiplePanel:Find("Numbers");
    local count = numberImage.childCount;
    local child,image;
    self.multipleSprite = {};
    for i=1,count do
        child = numberImage:GetChild(i-1);
        image = child:GetComponent("Image");
        self.multipleSprite[child.gameObject.name] = image.sprite;
    end
--    local numberImage   = self.multiplePanel:Find("Numbers"):GetComponent("ImageAnima");
--    self.multipleSprite = {};
--    local count=numberImage.lSprites.Count;
--    for i=0,count-1 do
--        self.multipleSprite[tostring(i)] =numberImage.lSprites[i];
--    end

    local function createMultipleNumber(chr)
        return self.multipleSprite[chr];
    end

    self.multipleNumber = CAtlasNumber.New(createMultipleNumber);
    self.multipleNumber:SetParent(self.multiplePanel);
    self.multipleNumber:SetLocalPosition(numberImage.localPosition);
    self.multipleNumber:SetNumber(0);
    self.multipleNumber:SetLocalScale(Vector3.New(0.8,0.8,0.8));
    --self.multipleNumber:Hide();

    --�Ϸ�
    local trans =self.steps[3]:Find("Add");
    event = Util.AddComponent("EventTriggerListener", trans.gameObject);
    event.onClick = handler(self,self.OnAddScoreClick);
    --�·�
    --[[
    trans =self.steps[3]:Find("Remove");
    event = Util.AddComponent("EventTriggerListener", trans.gameObject);
    event.onClick = handler(self,self.OnRemoveScoreClick);
    --]]
    self._paotaiType = G_GlobalGame.Enum_PaotaiType.Paotai_1;
    self:UpdatePaotai();

    self._switchState =SWITCH_STATE.SwitchWait;
    --��ʼ��
    self:InitStep();
    self._curChairId = _curChairId;
end

--�Ƿ��ڽ�����������
function _CNewHandControl:IsInNewHand()
    return self._isNewHand;
end

--�������
function _CNewHandControl:OnBgClick()
    if self._switchState == SWITCH_STATE.SwitchAction then
        return ;
    end
    if STEP_OPREATION[self._step].isClickScreen then
        self:NextStep();
        self._switchState = SWITCH_STATE.SwitchWait;
    end
end

--��Ӱ�ť���
function _CNewHandControl:OnAddClick()
    if self._switchState == SWITCH_STATE.SwitchAction and self._step~=2 then
        return ;
    end
    self._paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetNextPaotai(self._paotaiType);
    self:UpdatePaotai();
    G_GlobalGame:DispatchEventByStringKey("NotifySwitchPao");
    self._isScalePaotai = false; 
    self:StartNextStep();
end

--���ٰ�ť���
function _CNewHandControl:OnRemoveClick()
    if self._switchState == SWITCH_STATE.SwitchAction then
        return ;
    end
    --self._paotaiType,self.bullet_mulriple = Fish3DPlayer.RmoveBulletMethod();
    --self:UpdatePaotai();
    self:StartNextStep();
end

--�Ϸ�
function _CNewHandControl:OnAddScoreClick()
    if self._switchState == SWITCH_STATE.SwitchAction then
        return ;
    end
    -- Fish3DPlayerInfoPanel.OnAddGold();
    G_GlobalGame:DispatchEventByStringKey("NotifyAddScore");
    self:StartNextStep();
end

--�·ְ�ť���
function _CNewHandControl:OnRemoveScoreClick()
    if self._switchState == SWITCH_STATE.SwitchAction then
        return ;
    end
    G_GlobalGame:DispatchEventByStringKey("NotifyRemoveScore");
    self:StartNextStep();
end

function _CNewHandControl:StartNextStep()
    self._switchState =SWITCH_STATE.SwitchAction;
    local function stepToNext()
        coroutine.wait(0.6);
        self:NextStep();
        self._switchState =SWITCH_STATE.SwitchWait; 
    end
    coroutine.start(stepToNext);
end

--��һ��
function _CNewHandControl:NextStep()
    self:EndStep();
    self._step = self._step + 1;
    if self._step> TotalStep then
        self._isNewHand = false;
        GameObject.Destroy(self.gameObject);
        self:CompleteNewHand();
    else
        self._curStepTrans.gameObject:SetActive(false); 
        self._curStepTrans = self.steps[self._step];
        self._curStepTrans.gameObject:SetActive(true);  
        self:InitStep();
    end
end


function _CNewHandControl:EndStep()
    if self._step == 1 then

    elseif self._step == 2 then
        self._isScalePaotai = false;
    elseif self._step == 3 then
        
    end
end

function _CNewHandControl:InitStep()
    if self._step == 1 then
        self._curPlayer.gameObject:SetActive(true);
    elseif self._step == 2 then
        self._arrow.gameObject:SetActive(false);
        self._isScalePaotai = true;
        if self._paoBody then
            local function doScaleBig(_handler1,_handler2)
                if self._paoBody and self._isScalePaotai then
                    local dotween = self._paoBody:DOScale(1.3,1);
                    dotween:OnComplete(function ()
                        _handler1(_handler2,_handler1);
                    end)
                end
            end
            local function doScaleSmall(_handler1,_handler2)
                if self._paoBody and self._isScalePaotai then
                    local dotween = self._paoBody:DOScale(1,1);
                    dotween:OnComplete(function ()
                        _handler1(_handler2,_handler1);
                    end)
                end
            end
            --����С �ȱ�С����
            doScaleBig(doScaleSmall,doScaleBig);
        end
        
    elseif self._step == 3 then 
        self._curPlayer.gameObject:SetActive(false);
    end
end


function _CNewHandControl:UpdatePaotai()
    if self._paotai then
        destroy(self._paotai.gameObject);
        self._paotai = nil;
    end
    --��̨
    local paotai = G_GlobalGame._goFactory:createPaotai(self._paotaiType,true);
    self._paotai = paotai.transform;
    local localPosition = self._paotai.localPosition;
    local localScale    = self._paotai.localScale;
    self._paotai:SetParent(self._paos);
    self._paotai.localPosition = localPosition;
    self._paotai.localScale = localScale;
    self._paoBody = self._paotai:Find("Body");


    self._bulletType= G_GlobalGame.FunctionsLib.FUNC_GetBulletTypeByPaotaiType(self._paotaiType);
    self._multiple  = G_GlobalGame.FunctionsLib.FUNC_GetBulletMultiple(self._bulletType);
    self._multiple = self._multiple or 0;
    self.multipleNumber:SetNumber(self._multiple);
    self.multipleNumber:Display();
end

function _CNewHandControl:RenewBulletValueText(value)
    if value then
        if not GlobalFishNumberStringValue[value] then
            GlobalFishNumberStringValue[value]=tostring(value);
        end
        self.bulletValueText.text=GlobalFishNumberStringValue[value];
    end
end

return _CNewHandControl;
