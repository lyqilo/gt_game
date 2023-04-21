HorizontalAlignType = {
    Left    = 1,
    Mid     = 2,
    Right   = 3,
};

VerticalAlignType = {
    Top = 1,
    Mid = 2,
    Bottom = 3,
};

local AtlasNumber=class("AtlasNumber");

function AtlasNumber:ctor(_spriteCreator,_fontOffSet,_hAlignType,_vAlignType)
    self._objs      = {};
    self._imgs      = {};
    self._tranforms = {};
    self._sprites   = {};
    self.gameObject = GameObject.New();
    self.transform  = self.gameObject.transform;
    self.gameObject.name = "AtlasNumber";
    self._vec = vector:new();
    self._fontOffSet= _fontOffSet or 0;
    self._hAlignType= _hAlignType or HorizontalAlignType.Mid;
    self._vAlignType= _vAlignType or VerticalAlignType.Mid;
    self._spriteCreator = _spriteCreator; 
    self._width     = 0;
    self._height    = 0;
    self._isDisplayAdd = false;
    self._curLen    = 0;
    --self._fontW     = _fontW;
    self._widths    = {};
    self._heights   = {};
    self._touchEnabled = false;
    self._alpha     = 1;
end

function AtlasNumber:SetNumber(num)
    if self._number == num then
        return ;
    end
    if not self._spriteCreator then
        return ;
    end
    self._number = num;
    self:_setNumber(num);
end

--增加
function AtlasNumber:AddNumber(num)
    if self._number==nil then
        return ;
    end
    self:SetNumber(self._number + num);
end

function AtlasNumber:Number()
    return self._number;
end

--清除掉
function AtlasNumber:Clear()
    self._number = nil;
    local curLen = self._curLen;
    for i=1,curLen do
        if i<=len then
            self._objs[i]:SetActive(true);
        else
            self._objs[i]:SetActive(false);
        end
    end
end
function AtlasNumber:SetNumString(numberStr)
    self:_setContent(tostring(numberStr));
end

function AtlasNumber:_setContent(str)
    local len = #str;
    local curLen = self._curLen;
    local color
    self._width = 0;
    local chr
    local preW= 0;
    local preH= 0;
    for i=1,len do
        chr = string.sub(str, i, i)
        self._sprites[i] = self._spriteCreator(chr);
        if self._sprites[i]==nil then
            self._widths[i] = preW;
            self._heights[i] = preH;
        else
            --每个高度和宽度
            self._widths[i]  = self._sprites[i].rect.size.x;
            self._heights[i] = self._sprites[i].rect.size.y;
            preW = self._widths[i];
            preH = self._heights[i];
        end

    end

    if curLen<len then
        for i=1,curLen do
            self._objs[i]:SetActive(true);
        end
        for i=curLen+1,len do
            self._objs[i] = GameObject.New();
            self._objs[i].name = "num";
            self._imgs[i] = Util.AddComponent("Image",self._objs[i]);
            self._imgs[i].raycastTarget=self._touchEnabled;
            color = self._imgs[i].color;
            self._imgs[i].color        = Color.New(color.r,color.g,color.b,self._alpha);
            self._tranforms[i] = self._objs[i].transform;
            self._tranforms[i]:SetParent(self.transform);
            self._tranforms[i].localScale = Vector3.New(1,1,1);
            self._tranforms[i].localRotation = Quaternion.Euler(0,0,0);
        end
    else
        for i=1,curLen do
            if i<=len then
                self._objs[i]:SetActive(true);
            else
                self._objs[i]:SetActive(false);
            end
        end
    end
    for i=1,len do
        self._imgs[i].sprite = self._sprites[i];
        self._imgs[i]:SetNativeSize();
    end
    self._curLen = len;
    self:_arrangePos();
end
function AtlasNumber:_setNumber(num)
    local str,len
	
    if math.floor(num)>0 and self._isDisplayAdd then
        str = string.format("+%s",ShortNumber(num));
    else
        str = string.format("%s",ShortNumber(num));
    end
    self:_setContent(str);
end

--显示加号
function AtlasNumber:DisplayAdd()
    self._isDisplayAdd = true;
end

--设置alpha通道值
function AtlasNumber:SetAlpha(_a)
    local color
    for i=1,self._curLen do
        color = self._imgs[i].color;
        self._imgs[i].color = Color.New(color.r,color.g,color.b,_a);
    end
    self._alpha = _a;
end

--设置是否接受触摸
function AtlasNumber:IsReciveTouch(isReciveTouched)
    self._touchEnabled = isReciveTouched;
    for i=1,self._curLen do
        self._imgs[i].raycastTarget = isReciveTouched;
    end
end

--隐藏加号
function AtlasNumber:HideAdd()
    self._isDisplayAdd = false;
end

--设置父节点
function AtlasNumber:SetParent(parent)
    self.transform:SetParent(parent);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localRotation = Quaternion.Euler(0,0,0);
end

--设置旋转
function AtlasNumber:SetLocalRotation(localRotation)
    self.transform.localRotation = localRotation;
end

--设置位置
function AtlasNumber:SetPosition(position)
    self.transform.position = position;
end

--设置坐标
function AtlasNumber:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

--设置缩小比例
function AtlasNumber:SetLocalScale(localScale)
    self.transform.localScale = localScale;
end

--隐藏
function AtlasNumber:Hide()
    self.gameObject:SetActive(false);
end

--显示
function AtlasNumber:Display()
    self.gameObject:SetActive(true);
end

function AtlasNumber:Width()
    return self._width;
end

function AtlasNumber:_arrangePos()
    self:_countLen();
    local curLen = self._curLen;
    local x,y
    if self._hAlignType == HorizontalAlignType.Left then
        --x = self._width/2;
        x = self._widths[1]/2;
    elseif self._hAlignType == HorizontalAlignType.Right then
        x = -self._width + self._widths[1]/2;
    elseif self._hAlignType == HorizontalAlignType.Mid then
        x = -self._width/2 + self._widths[1]/2;
    end
    local tag=0
    if self._vAlignType == VerticalAlignType.Top then
        y = self._height;
        tag = -1;
    elseif self._vAlignType == VerticalAlignType.Mid then
        y = 0;
        tag = 0;
    elseif self._vAlignType == VerticalAlignType.Bottom then
        y = -self._height;
        tag = 1;
    end

    for i=1,curLen do
        self._tranforms[i].localPosition = Vector3.New(x,y+tag*self._heights[i]/2,0);
        x = x + self._widths[i]/2;
        if i~=curLen then
            x = x + self._fontOffSet + self._widths[i+1]/2;
        end
    end
end

--
function AtlasNumber:_countLen()
    self._width = 0;
    self._height    = 0
    for i=1,self._curLen do
        self._width = self._width + self._widths[i];
        if self._height< self._heights[i] then
            self._height = self._heights[i];
        end
    end
    self._width = self._width + (self._curLen-1)* self._fontOffSet;
end

function AtlasNumber:SetFontPadding(_offset,_isArrange)
    self._fontOffSet = _offset;
    if _isArrange then
        self:_arrangePos();
    end 
end


return AtlasNumber;