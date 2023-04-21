ResoureceMgr = {};
local self = ResoureceMgr;
self.SpriteList = {};
self.SmallSpriteList = {};
self.SmallMoSpriteList = {};
self.Audiolist = {};
self.resSpriteHost = nil;
self.resAudioHost = nil;

function ResoureceMgr.OnInit()
    self.SpriteList = {};
    for i = 1, 11 do
        if (i == GameConfig.FRUIT_TYPE.wild) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_11");
        end

        if (i == GameConfig.FRUIT_TYPE.seven) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_10");
        end

        if (i == GameConfig.FRUIT_TYPE.bar) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_8");
        end

        if (i == GameConfig.FRUIT_TYPE.bonus) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_9");
        end

        if (i == GameConfig.FRUIT_TYPE.lingdang) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_6");
        end

        if (i == GameConfig.FRUIT_TYPE.xigua) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_2");
        end

        if (i == GameConfig.FRUIT_TYPE.yingtao) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_7");
        end

        if (i == GameConfig.FRUIT_TYPE.ningmeng) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_3");
        end

        if (i == GameConfig.FRUIT_TYPE.boluo) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_5");
        end

        if (i == GameConfig.FRUIT_TYPE.putao) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_4");
        end

        if (i == GameConfig.FRUIT_TYPE.xiangjiao) then
            self.SpriteList[i] = self.FindSpriteRes("SGDZZ_ICON_1");
        end
    end
    for i = 1, 7 do
        self.SmallSpriteList[i] = self.FindSpriteRes("SmallIcon_" .. i);
    end
    for i = 1, 7 do
        self.SmallMoSpriteList[i] = self.FindSpriteRes("SmallMoIcon_" .. i);
    end
end

function ResoureceMgr.FindSpriteRes(resName)
    if (self.resSpriteHost == nil) or tostring(self.resSpriteHost) == "null" then
        self.resSpriteHost = SlotGameEntry.transform:Find("Res/Sprite");
        if self.resSpriteHost == nil then
            return
        end
    end
    --log("host========="..tostring(self.resSpriteHost)..",name ===== ====== "..resName);
    local res = self.resSpriteHost.transform:Find(resName)
    if (res == nil) then
        error("not find res:" .. resName)
        return;
    end

    return res.gameObject:GetComponent("SpriteRenderer").sprite;
end

function ResoureceMgr.FindAudio(objName)
    --log("==================音效组件名字"..tostring(self.resAudioHost))
    if (self.resAudioHost == nil) or tostring(self.resAudioHost) == "null" then
        self.resAudioHost = SlotGameEntry.transform:Find("Res/Sound");
    end
    local res = self.resAudioHost.transform:Find(objName)
    if (res == nil) then
        error("not find res:" .. objName)
        return;
    end

    return res.gameObject:GetComponent("AudioSource");
end
function ResoureceMgr.FindObject(objName)

end
function ResoureceMgr.OnQuitGame()
    self.SpriteList = {};
    self.resSpriteHost = nil;
    self.Audiolist = {};
    self.resAudioHost = nil;
end