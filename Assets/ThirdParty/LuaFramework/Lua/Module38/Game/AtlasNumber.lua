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
local atlasNumberFactory = {
    _nameGroupCreator = {},
    _numbersSprites = {},
};
--local AtlasNumber=class("AtlasNumber");
local AtlasNumber=class();

function AtlasNumber:ctor(_spriteCreator,_fontOffSet,_hAlignType,_vAlignType)
    self._objs      = {};
    self._imgs      = {};
    self._tranforms = {};
    self._sprites   = {};
    self.gameObject = GAMEOBJECT_NEW();
    self.transform  = self.gameObject.transform;
    --self.gameObject.name = "AtlasNumber";
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
    self._numPoses  = {};
    self._mallocLen = 0;
    self.curColor   = nil;
    self._string    = nil;
    self._spaceW    = 0;
    self._spaceH    = 0;
end

function AtlasNumber:SetNumber(num)
    if self._number == num then
        return self;
    end
    if not self._spriteCreator then
        return self;
    end
    self._number = num;
    self:_setNumber(num);
    return self;
end

--增加
function AtlasNumber:AddNumber(num)
    if self._number==nil then
        return self;
    end
    self:SetNumber(self._number + num);
    return self;
end

function AtlasNumber:Number()
    return self._number;
end

--清除掉
function AtlasNumber:Clear()
    self._number = nil;
    local curLen = self._curLen;
    for i=1,curLen do
        self._objs[i]:SetActive(false);
    end
    return self;
end

function AtlasNumber:_setNumber(num)
    local str,len
    if toInt64(num)>toInt64(0) and self._isDisplayAdd then
        str = string.format("+%s",tostring(num));
    else
        str = string.format("%s",tostring(num));
    end
    self:_setContent(str);
    return self;
end

function AtlasNumber:SetNumString(numberStr)
    self:_setContent(numberStr);
    return self;
end

function AtlasNumber:SetSpace(spaceW,spaceH)
    if spaceW then
        self._spaceW = spaceW;
    end
    if spaceH then
        self._spaceH = spaceH;
    end
    return self;
end

function AtlasNumber:_setContent(str)
    if self._string == str then
        return self;
    end
    self._string = str;
    local len = #str;
    local curLen = self._mallocLen;
    local color 
    self._width = 0;
    local chr
    for i=1,len do
        chr = string.sub(str, i, i)
        self._sprites[i] = self._spriteCreator(chr);
        if self._sprites[i]==nil then
            self._widths[i] = self._spaceW;
            self._heights[i] = self._spaceH;
        else
            --每个高度和宽度
            self._widths[i]  = self._sprites[i].rect.size.x;
            self._heights[i] = self._sprites[i].rect.size.y; 
        end

    end
    if curLen<len then
        for i=1,curLen do
            self._objs[i]:SetActive(true);
        end
        for i=curLen+1,len do
            self._objs[i] = GAMEOBJECT_NEW();
            --self._objs[i].name = "num";
            self._imgs[i] = UTIL_ADDCOMPONENT("Image",self._objs[i]); 
            self._imgs[i].raycastTarget=self._touchEnabled;
            color = self._imgs[i].color;
            if self.curColor then
                self._imgs[i].color        = self.curColor;--COLORNEW(self.curColor.r,self.curColor.g,self.curColor.b,self._alpha);
            else
                self._imgs[i].color        = COLORNEW(color.r,color.g,color.b,self._alpha);
            end
            self._tranforms[i] = self._objs[i].transform;
            self._tranforms[i]:SetParent(self.transform);
            self._tranforms[i].localScale = C_Vector3_One;
            self._tranforms[i].localEulerAngles = C_Vector3_Zero;
        end
        self._mallocLen = len;
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
        if self._sprites[i] then
            self._imgs[i].sprite = self._sprites[i];
            self._imgs[i]:SetNativeSize();
        else
            self._objs[i]:SetActive(false);
        end
    end
    self._curLen = len;
    self:_arrangePos();
    return self;
end

--显示加号
function AtlasNumber:DisplayAdd()
    self._isDisplayAdd = true;
    return self;
end

--设置alpha通道值
function AtlasNumber:SetAlpha(_a)
    local color
    if self.curColor then
        self.curColor.a = _a;
        for i=1,self._curLen do
            self._imgs[i].color = self.curColor;
        end
    else
        for i=1,self._curLen do
            color = self._imgs[i].color;
            self._imgs[i].color = COLORNEW(color.r,color.g,color.b,_a);
        end
        self._alpha = _a;
    end
    return self;
end

--设置是否接受触摸
function AtlasNumber:IsReciveTouch(isReciveTouched)
    self._touchEnabled = isReciveTouched;
    for i=1,self._curLen do
        self._imgs[i].raycastTarget = isReciveTouched;
    end
    return self;
end

--隐藏加号
function AtlasNumber:HideAdd()
    self._isDisplayAdd = false;
    return self;
end

--设置父节点
function AtlasNumber:SetParent(parent)
    self.transform:SetParent(parent);
    self.transform.localPosition = C_Vector3_Zero;
    self.transform.localScale = C_Vector3_One;
    self.transform.localRotation = C_Quaternion_Zero;
    return self;
end

--设置旋转
function AtlasNumber:SetLocalRotation(localRotation)
    self.transform.localRotation = localRotation;
    return self;
end

--设置位置
function AtlasNumber:SetPosition(position)
    self.transform.position = position;
    return self;
end

--设置坐标
function AtlasNumber:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
    return self;
end

--设置缩小比例
function AtlasNumber:SetLocalScale(localScale)
    self.transform.localScale = localScale;
    return self;
end

--设置颜色
function AtlasNumber:SetColor(color1)
    local color = {r=color1.r,g=color1.g,b=color1.b,a=color1.a};
    if color.a then
        self._alpha = color.a;
    else
        self._alpha = self._alpha or 1 ;
        color.a = self._alpha;
    end
    self.curColor = color;
    for i=1,self._curLen do
        self._imgs[i].color = color;
    end
    return self;
end

--设置名字
function AtlasNumber:SetName(name)
    self.gameObject.name = name;
end

--隐藏
function AtlasNumber:Hide()
    self.gameObject:SetActive(false);
    return self;
end

--显示
function AtlasNumber:Display()
    self.gameObject:SetActive(true);
    return self;
end

function AtlasNumber:Show()
    self.gameObject:SetActive(true);
    return self;
end

function AtlasNumber:Width()
    return self._width;
end

--偏移某个数字
function AtlasNumber:OffsetPos(index,pos)
    local v3 = V_Vector3_Value;
    local numPos= self._numPoses[index];
    if pos then
        if index>self._curLen then
            return self;
        end
        v3.x = numPos.x + pos.x;
        v3.y = numPos.y + pos.y;
        v3.z = numPos.z + pos.z;
        self._tranforms[index].localPosition = v3;  
    else
        if index>self._curLen then
            return self;
        end
        self._tranforms[index].localPosition = numPos;        
    end
    return self;
end

--隐藏某位数字
function AtlasNumber:HideNumber(index)
    index = index or self._curLen;
    if index>self._curLen or index<=0  then
        return self;
    end
    self._objs[index]:SetActive(false);
    return self;
end

--隐藏所有数字
function AtlasNumber:HideNumbers()
    for i=1,self._curLen do
        self._objs[i]:SetActive(false);
    end
    return self;
end

--显示所有数字
function AtlasNumber:ShowNumbers()
    for i=1,self._curLen do
        self._objs[i]:SetActive(true);
    end
    return self;
end

--显示所有数字
function AtlasNumber:ShowNumber(index)
    index = index or self._curLen;
    if index>self._curLen or index<=0 then
        return self;
    end
    self._objs[index]:SetActive(true);
    return self;
end

--数字位数
function AtlasNumber:NumberCount()
    return self._curLen;
end

function AtlasNumber:_arrangePos()
    self:_countLen();
    local curLen = self._curLen;
    local x,y
    local _widths = self._widths;
    local _heights = self._heights;
    local _numPoses = self._numPoses;
    local _tranforms = self._tranforms;
    local _fontOffSet = self._fontOffSet;
    if self._hAlignType == HorizontalAlignType.Left then
        --x = self._width/2;
        x = _widths[1]/2;
    elseif self._hAlignType == HorizontalAlignType.Right then
        x = -self._width + _widths[1]/2;
    elseif self._hAlignType == HorizontalAlignType.Mid then
        x = -self._width/2 + _widths[1]/2;
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
        _numPoses[i] = VECTOR3NEW(x,y+tag*_heights[i]/2,0);
        _tranforms[i].localPosition = _numPoses[i];
        x = x + _widths[i]/2;
        if i~=curLen then
            x = x + _fontOffSet + _widths[i+1]/2;
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
    return self;
end

function AtlasNumber:SetFontPadding(_offset,_isArrange)
    self._fontOffSet = _offset;
    if _isArrange then
        self:_arrangePos();
    end
    return self; 
end




function AtlasNumber.InitNumbers(transform)
    local count = transform.childCount;
    local child = nil;
    local name  = nil;
    local child2= nil;
    local childCount2 = nil;
    local newSprites;
    local image;
    local sprite;
    for i=1,count do
        child = transform:GetChild(i-1);
        name = child.gameObject.name;
        atlasNumberFactory._numbersSprites[name] = atlasNumberFactory._numbersSprites[name] or {};
        childCount2 = child.childCount;
        newSprites = atlasNumberFactory._numbersSprites[name];
        for j=1,childCount2 do
            child2 = child:GetChild(j-1);
            image = child2:GetComponent(ImageClassType);
            if image then
                sprite = image.sprite;
                newSprites[child2.gameObject.name]=image.sprite;
--                if sprite then
--                   -- newSprites[child2.gameObject.name] = UnityEngine.Sprite.Create(sprite.texture,sprite.textureRect,sprite.pivot);
--                else
--                   -- newSprites[child2.gameObject.name] = image.sprite;
--                end
            else
                image = child2:GetComponent(SpriteRendererClassType);
                if image then
                    sprite = image.sprite;
                    newSprites[child2.gameObject.name]=image.sprite;
                end
            end
        end
    end 
end

--导入sprites
function AtlasNumber.ImportSpritesWithName(nameGroup,names,sprites)
    atlasNumberFactory._numbersSprites[nameGroup] = atlasNumberFactory._numbersSprites[nameGroup] or {};
    local newSprites = atlasNumberFactory._numbersSprites[nameGroup];
    for i=1,#names do
        newSprites[names[i]] = sprites[i];
    end
end

--导入sprites
function AtlasNumber.ImportSprites(nameGroup,sprites)
    atlasNumberFactory._numbersSprites[nameGroup] = atlasNumberFactory._numbersSprites[nameGroup] or {};
    local newSprites = atlasNumberFactory._numbersSprites[nameGroup];
    for n,v in pairs(sprites) do
        newSprites[n] = v;
    end
end

local  _getSprite = function(nameGroup,name)
    local spriteGroup = atlasNumberFactory._numbersSprites[nameGroup];
    if spriteGroup then
        return spriteGroup[name];
    end
    return nil;
end


function AtlasNumber.CreateAtlasNumber(transform,...)
    local child = transform:GetChild(0);
    local nameGroup = child.gameObject.name;
    if atlasNumberFactory._nameGroupCreator[nameGroup] then

    else
        local GetAtlasNumber = function(name)
            return _getSprite(nameGroup,name);
        end
        atlasNumberFactory._nameGroupCreator[nameGroup] = GetAtlasNumber;
    end
    local atlasLabel = AtlasNumber.New(atlasNumberFactory._nameGroupCreator[nameGroup],...);
    atlasLabel:SetParent(transform);
    atlasLabel:SetLocalPosition(child.localPosition);
    atlasLabel:SetLocalScale(child.localScale);
    return atlasLabel;
end

function AtlasNumber.CreateAtlasNumberByIndex(transform,index,...)
    index = index or 0;
    local child = transform:GetChild(index);
    local nameGroup = child.gameObject.name;
    if atlasNumberFactory._nameGroupCreator[nameGroup] then

    else
        local GetAtlasNumber = function(name)
            return _getSprite(nameGroup,name);
        end
        atlasNumberFactory._nameGroupCreator[nameGroup] = GetAtlasNumber;
    end
    local atlasLabel = AtlasNumber.New(atlasNumberFactory._nameGroupCreator[nameGroup],...);
    atlasLabel:SetParent(transform);
    atlasLabel:SetLocalPosition(child.localPosition);
    atlasLabel:SetLocalScale(child.localScale);
    return atlasLabel;
end

function AtlasNumber.CreateWithGroupName(nameGroup,...)
    if atlasNumberFactory._nameGroupCreator[nameGroup] then
    else
        local GetAtlasNumber = function(name)
            return _getSprite(nameGroup,name);
        end
        atlasNumberFactory._nameGroupCreator[nameGroup] = GetAtlasNumber;
    end
    local atlasLabel = AtlasNumber.New(atlasNumberFactory._nameGroupCreator[nameGroup],...);
    return atlasLabel;
end


return AtlasNumber;