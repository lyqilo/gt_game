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
    self._freeCount=0
    self.cells = {};
    local xcount = GameDefine.XCount();
    local ycount = GameDefine.YCount();
    for i=1,ycount do
        self.cells[i] = {};
        for j=1,xcount do
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

function _CGameData:_FreeCount(_count)
    self._freeCount=_count
end

function _CGameData:_count()
    if self._isCount then
        return ;
    end
    local maxLine = GameDefine.MaxLine();
    local lines = GameDefine.GetLines();
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local line;
    local xIndex,yIndex;
    local _value,_value2;
    local iconEnum = GameDefine.EnumIconType();
    local count;
    local multiple=0;

    self._isCount = true;
    self.gameRet.lines = {};
    self.gameRet.isFreeGame = false;
    self.gameRet.totalMultiple = 0;
    self.gameRet.sepCells = {};
    self.gameRet.freeCells = {};
    self.gameRet.wildCells = {};
    self.gameRet.comCells= {};

    local lineData;
    local comCount = 0;
    local isExists = {};
    for i = 1,yCount do
        isExists[i] = {};
    end

    for i=1,maxLine do
        line = lines[i];
        yIndex = line[1][1];
        _value = self.cells[yIndex][1]:GetValue();
        count = 1;
        lineData = nil;
        if _value == iconEnum.EM_IconValue_BookSun then

        else
            for j=2,xCount do
                yIndex = line[j][1];
                _value2 = self.cells[yIndex][j]:GetValue();
                if _value2 == iconEnum.EM_IconValue_BookSun then
                    break;
                elseif _value2 == _value then
                    count = count + 1;
                elseif _value2 == iconEnum.Wild then
                    count = count + 1;

                elseif _value == iconEnum.Wild then
                    _value = _value2;
                    count = count + 1;
                else
                    break;
                end
            end
        end

        multiple = GameDefine.GetIconMultiple(_value,count);
        if (multiple>0) then
            lineData = {lineNO=i,value=_value,count=count,multiple=multiple};
            for j=1,count do
                yIndex = line[j][1];
                if isExists[yIndex][j]~=1 then
                    isExists[yIndex][j] = 1;
                    comCount = comCount + 1;
                    self.gameRet.comCells[comCount] = {x=j,y=yIndex};
                end
            end
            self.gameRet.totalMultiple = self.gameRet.totalMultiple + multiple;
        end

        if lineData~=nil then
            table.insert(self.gameRet.lines,lineData);
        end
    end

    logYellow("具体线数据")
    logTable(self.gameRet.lines)

    local freeCells = self.gameRet.freeCells;
    local wildCells = self.gameRet.wildCells;
    local sepCells = self.gameRet.sepCells;
    count = 0;
    local wCount,sCount = 0,0;

    for i = 1,yCount do
        for j=1,xCount do

            if self._freeCount<=0 then
                if self.cells[i][j]:GetValue()== iconEnum.EM_IconValue_BookSun then
                    sCount = sCount +1;
                    sepCells[sCount] = {x=j,y=i};
                end
            end

            if self.cells[i][j]:GetValue()== iconEnum.FreeGame then
                count = count + 1;
                freeCells[count] = {x=j,y=i};

            elseif self.cells[i][j]:GetValue()== iconEnum.Wild then
                wCount = wCount + 1;
                wildCells[wCount] = {x=j,y=i};
            end

        end
    end

    multiple = GameDefine.GetIconMultiple(iconEnum.EM_IconValue_BookSun,sCount);
    if multiple>0 then
        self.gameRet.sepCells = sepCells;
        self.gameRet.totalMultiple = self.gameRet.totalMultiple + multiple;
    else
        self.gameRet.sepCells = {};
    end

end

return _CGameData;