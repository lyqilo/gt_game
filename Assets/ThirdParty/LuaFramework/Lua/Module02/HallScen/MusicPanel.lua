
MusicPanel={}
local self =MusicPanel
self.m_luaBeHaviour = nil
self.transform=nil

function MusicPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("MusicPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)


    self.mainPanel=self.transform:Find("mainPanel")

    self.CloseBtn=self.mainPanel:Find("CloseBtn")
    --self.MyBackpackMask=self.transform:Find("zhezhao")

    self.BgMusicOpenBtn = self.mainPanel:Find("Image/BgMusic/dk"):GetComponent("Toggle");
    self.BgMusicCloseBtn = self.mainPanel:Find("Image/BgMusic/gb"):GetComponent("Toggle");

    self.BgSoundOpenBtn = self.mainPanel:Find("Image/BgSound/dk"):GetComponent("Toggle");
    self.BgSoundCloseBtn = self.mainPanel:Find("Image/BgSound/gb"):GetComponent("Toggle");


    self.m_luaBeHaviour:AddClick(self.CloseBtn.gameObject, self.RenWuPanelClose);


    -- self.BgMusicOpenBtn.onValueChanged:RemoveAllListeners();
    -- self.BgMusicOpenBtn.onValueChanged:AddListener(self.BgMusicBtnOnClick);
    -- self.BgSoundOpenBtn.onValueChanged:RemoveAllListeners();
    -- self.BgSoundOpenBtn.onValueChanged:AddListener(self.BgSoundBtnOnClick);

    self.BgMusicBtn = self.mainPanel:Find("Image/YYText/Slider").gameObject;
    self.BgSoundBtn = self.mainPanel:Find("Image/YXText/Slider").gameObject;

    self.m_luaBeHaviour:AddSliderEvent(self.BgMusicBtn, self.BgMusicBtnOnClick);
    self.m_luaBeHaviour:AddSliderEvent(self.BgSoundBtn, self.BgSoundBtnOnClick);
end

function MusicPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end
    local soundValue = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    soundValue = PlayerPrefs.GetString("SoundValue");
    --else
    --    soundValue = 1
    --end

    if soundValue ~= nil then
        self.BgSoundBtn.transform:GetComponent("Slider").value = tonumber(soundValue)
    else
        self.BgSoundBtn.transform:GetComponent("Slider").value = 1
    end

    local musicValue = MusicManager:GetMusicVolume();
    --if PlayerPrefs.HasKey("MusicValue") then
    --    musicValue = PlayerPrefs.GetString("MusicValue");
    --else
    --    musicValue = 1
    --end
    if musicValue ~= nil then
        self.BgMusicBtn.transform:GetComponent("Slider").value = tonumber(musicValue)
    else
        self.BgMusicBtn.transform:GetComponent("Slider").value = 1
    end
end

function MusicPanel.RenWuPanelClose()
    HallScenPanel.PlayeBtnMusic()
    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform=nil
end
-- function MusicPanel.BgMusicBtnOnClick(value)
--     -- local go = self.BgMusicBtn:GetComponent('Button')
--     -- go.interactable = false;
--     HallScenPanel.PlayeBtnMusic()
--     if value then
--         HallScenPanel.PlayeBgMusic(true);
--         AllSetGameInfo._5IsPlayAudio = true;
--     else
--         HallScenPanel.PlayeBgMusic(false);
--         AllSetGameInfo._5IsPlayAudio = false;
--     end ;
--     PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
--     PlayerPrefs.SetString("isCanPlayMusic", tostring(AllSetGameInfo._5IsPlayAudio));
--     GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
-- end
-- --> (点击事件) 设置静音
-- function MusicPanel.BgSoundBtnOnClick(value)
--     HallScenPanel.PlayeBtnMusic()
--     if value then
--         AllSetGameInfo._6IsPlayEffect = true;
--     else
--         AllSetGameInfo._6IsPlayEffect = false;
--     end ;
--     PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
--     GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
-- end

function MusicPanel.BgMusicBtnOnClick(value)
    --local isplay = AllSetGameInfo._5IsPlayAudio;
    --if value == 0 then
    --    AllSetGameInfo._5IsPlayAudio = false;
    --else
    --    AllSetGameInfo._5IsPlayAudio = true;
    --end
    MusicManager:SetValue(MusicManager:GetSoundVolume(), tonumber(value));
    MusicManager:SetMusicMute(value <= 0);
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    ----PlayerPrefs.SetString("isCanPlayMusic", tostring(AllSetGameInfo._5IsPlayAudio));
    --
    --PlayerPrefs.SetString("MusicValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    --if not isplay and value > 0 then
    --    HallScenPanel.PlayeBgMusic();
    --end
    --local soundValue = 1
    --if PlayerPrefs.HasKey("SoundValue") then
    --    soundValue = PlayerPrefs.GetString("SoundValue");
    --end
    --MusicManager:SetValue(tonumber(soundValue), tonumber(value))
end

--> (点击事件) 设置静音
function MusicPanel.BgSoundBtnOnClick(value)
    --if value == 0 then
    --    AllSetGameInfo._6IsPlayEffect = false;
    --else
    --    AllSetGameInfo._6IsPlayEffect = true;
    --end
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    ----PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --
    --PlayerPrefs.SetString("SoundValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    local musicValue = MusicManager:GetMusicVolume();
    --if PlayerPrefs.HasKey("MusicValue") then
    --    musicValue = PlayerPrefs.GetString("MusicValue");
    --end
    MusicManager:SetValue(tonumber(value), tonumber(musicValue))
    MusicManager:SetSoundMute(value <= 0);
end