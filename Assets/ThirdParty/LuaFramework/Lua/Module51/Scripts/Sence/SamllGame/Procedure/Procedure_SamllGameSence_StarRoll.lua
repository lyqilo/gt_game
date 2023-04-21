Procedure_SamllGameSence_StarRoll = {}
local self = Procedure_SamllGameSence_StarRoll

self.ProcedureName = "Procedure_SamllGameSence_StarRoll"
self.NextProcedureName = "Procedure_SamllGameSence_ShowResult"

function Procedure_SamllGameSence_StarRoll:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_StarRoll:OnAwake()
end

function Procedure_SamllGameSence_StarRoll:OnDestroy()
end

function Procedure_SamllGameSence_StarRoll:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);

    local mgr = sence.SenceHost.transform:Find("SamllGame_RollMgr");
    for i = 1, mgr.childCount do
        mgr:GetChild(i - 1):GetComponent("Animator"):SetTrigger("hide");
    end
    --TODO 开始转
    local time = 0
    LogicDataSpace.isSmallGameStart = true;
    LogicDataSpace.isSmallGameEnd = false;
    for i = 1, #LogicDataSpace.samlGameCenterRoll do
        local f = function()
            LogicDataSpace.samlGameCenterRoll[i]:Start();
        end
        SlotGameEntry.AddCallBack(time, f);
        time = time + 0.1
    end

    local length = #LogicDataSpace.samlGameRollIcon * 2 + (#LogicDataSpace.samlGameRollIcon - (#LogicDataSpace.samlGameRollIcon - LogicDataSpace.lastStopIndex))
    local time = 0
    local dSpeed = 1;
    local aSpeed = 5;
    local star = true;
    for i = LogicDataSpace.lastStarIndex, length do
        local runNextIcon = function()
            local index = i;
            index = index % #LogicDataSpace.samlGameRollIcon;
            if (index <= 0) then
                index = #LogicDataSpace.samlGameRollIcon;
            end
            LogicDataSpace.samlGameRollIcon[index]:Show();
            MainGameSence.PlaySound(MainGameSence.AudioEnum.MaliWheelPitch);
        end
        SlotGameEntry.AddCallBack(time, runNextIcon);
        --TODO 加速
        if (aSpeed <= 5 and star == true) then
            aSpeed = aSpeed - 1
            if (aSpeed == 1) then
                star = false
            end
            time = time + (aSpeed * 0.05);
        elseif (i > length - 10) then--TODO 减速
            dSpeed = dSpeed + 1;
            time = time + (dSpeed * 0.05);
        else
            time = time + 0.07
        end
    end
    LogicDataSpace.lastStarIndex = LogicDataSpace.lastStopIndex
    local stop = function()
        local time2 = 0
        LogicDataSpace.isSmallGameEnd = true;
        for i = 1, #LogicDataSpace.samlGameCenterRoll do
            local f = function()
                LogicDataSpace.samlGameCenterRoll[i]:Stop();
            end
            SlotGameEntry.AddCallBack(time2, f);
            time2 = time2 + 0.5
        end
    end
    local showCount = 0;
    -- if LogicDataSpace.IconType == 8 then
    --     MainGameSence.PlaySound(MainGameSence.AudioEnum.Bomb);
    -- else
    --     local binggoarr = {};
    --     for i = 1, #LogicDataSpace.samlCenterResult do
    --         if LogicDataSpace.samlCenterResult[i] == LogicDataSpace.IconType then
    --             table.insert(binggoarr, #binggoarr + 1, i);
    --         end
    --     end
    --     if #binggoarr > 0 then
    --         MainGameSence.PlaySound(MainGameSence.AudioEnum.MaliBingo);
    --         LogicDataSpace.samlGameRollIcon[LogicDataSpace.lastStopIndex]:ShowX();
    --         local sence = SenceMgr.FindSence(Sen)
    --         for i = 1, #binggoarr do
    --             LogicDataSpace.samlGameCenterRoll[binggo[i]].m_objs[1]:ShowSelect(true);
    --             LogicDataSpace.samlGameCenterRoll[binggo[i]].m_objs[2]:ShowSelect(true);
    --         end
    --     else
    --         LogicDataSpace.samlGameRollIcon[LogicDataSpace.lastStopIndex]:ShowX();
    --     end
    -- end
    -- LogicDataSpace.samlGameRollIcon[LogicDataSpace.lastStopIndex]:ShowX();
    for i = 1, 4 do
        local show = function()
            if showCount == 0 then
                error(LogicDataSpace.IconType);
                if LogicDataSpace.IconType == 8 then
                    MainGameSence.PlaySound(MainGameSence.AudioEnum.Bomb);
                else
                    local binggoarr = {};
                    for i = 1, #LogicDataSpace.samlCenterResult do
                        if LogicDataSpace.samlCenterResult[i] == LogicDataSpace.IconType then
                            table.insert(binggoarr, #binggoarr + 1, i);
                        end
                    end
                    LogicDataSpace.samlGameRollIcon[LogicDataSpace.lastStopIndex]:Show();
                    if #binggoarr > 0 then
                        MainGameSence.PlaySound(MainGameSence.AudioEnum.MaliBingo);
                        for i = 1, #binggoarr do
                            mgr:GetChild(binggoarr[i] - 1):GetComponent("Animator"):SetTrigger("show");
                        end
                    else
                    end
                end
            end
            showCount = showCount + 1;
            LogicDataSpace.samlGameRollIcon[LogicDataSpace.lastStopIndex]:Show();
        end
        SlotGameEntry.AddCallBack(time + (i * 0.2), show);
    end
    local showResult = function()
        sence.ProMgr:RunProcedure(Procedure_SamllGameSence_ShowResult.ProcedureName);
    end
    SlotGameEntry.AddCallBack(3, stop);
    SlotGameEntry.AddCallBack(time + 2, showResult);
end