local GameDefine = GameRequire__("GameDefine");

local _CCell = class("Cell");

function _CCell:ctor()
    self._value = 0;
    self._isSet = false;
end

function _CCell:Clear()
    self._value = 0;
    self._isSet = false;
end

function _CCell:SetValue(_value)
    self._value = _value;
end

function _CCell:GetValue()
    return self._value;
end



local _CGameData = class("GameData");

function _CGameData:ctor()
    self:_init();
    self._isCount = false;
end

function _CGameData:_init()
    self.cells = {};
    local xcount = GameDefine.XCount();
    local ycount = GameDefine.YCount();
    
    for i=1,ycount do --4
        self.cells[i] = {};
        for j=1,xcount do --5
            self.cells[i][j] = _CCell.New();

        end
    end
    self.gameRet = {isCup = false,lines = {}};
end

function _CGameData:Clear()
    local xcount = GameDefine.XCount();
    local ycount = GameDefine.YCount();
    for i=1,ycount do
        for j=1,xcount do
            self.cells[i][j]:Clear();
        end
    end
    self._isCount = false;
end

--获取结果
function _CGameData:GetRet()
    self:_count();
    return self.gameRet;
end

function _CGameData:SetValue(xIndex,yIndex,value)
    self.cells[yIndex][xIndex]:SetValue(value);
end

function _CGameData:_count()
    if self._isCount then
        return ;
    end

    local maxLine = GameDefine.MaxLine();--总线数
    local lines = GameDefine.GetLines();--线的配置
    local xCount = GameDefine.XCount();--多少列
    local line;
    local xIndex,yIndex;
    local _value,_value2;
    local iconEnum = GameDefine.EnumIconType();--格子的具体数据
    local count,rCount;
    local isOff;

    self._isCount = true;
    self.gameRet.lines = {};
    self.gameRet.isCup = false;
    self.gameRet.isFreeGame = false;

    local lineData;
            --40
    for i=1,maxLine do
        line = lines[i];
        yIndex = line[1][1];
        _value = self.cells[yIndex][1]:GetValue();

        count = 1;
        rCount = 1;
        lineData = nil;
        isOff =  false;
        --if _value == iconEnum.EM_IconValue_Referee or _value == iconEnum.EM_IconValue_Court then
        if _value == iconEnum.EM_IconValue_Referee then

        else
            for j=2,5 do
                yIndex = line[j][1];
                _value2 = self.cells[yIndex][j]:GetValue();

                if not isOff then
                    
                    if _value==iconEnum.EM_IconValue_Court then
                        count = count + 1;
                        _value=self.cells[yIndex][j]:GetValue();
                    elseif _value2 == _value then
                        count = count + 1;
                        rCount = rCount + 1;
                    elseif _value2 == iconEnum.Wild then
                        count = count + 1;
                    else
                        isOff = true;
                    end


                end
            end
        end

        if rCount>=5 then
            if _value == iconEnum.EM_IconValue_Cup then
                self.gameRet.isCup = true;
                self.gameRet.cupLine = i;
            else
                lineData = {lineNO=i,value=_value,count=count,multiple=GameDefine.GetIconMultiple(_value,count)};
            end
        elseif count>=3 then
            lineData = {lineNO=i,value=_value,count=count,multiple=GameDefine.GetIconMultiple(_value,count)};
        end
        if lineData~=nil then
            table.insert(self.gameRet.lines,lineData);
        end

    end

    --免费游戏
    local yCount = GameDefine.YCount();
    local freeCells ={};
    count = 0;
    for i = 1,yCount do
        for j=1,xCount do
            if self.cells[i][j]:GetValue()== iconEnum.FreeGame then
                count = count + 1;
                freeCells[count] = {};
                freeCells[count].x = j;
                freeCells[count].y = i;
            end
        end
    end
    if count>=3 then
        self.gameRet.isFreeGame = true;
        self.gameRet.freeCells  = freeCells;
    end
end

return _CGameData;