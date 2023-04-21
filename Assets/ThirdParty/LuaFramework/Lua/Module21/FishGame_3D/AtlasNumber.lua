local VECTOR3DIS                                        = VECTOR3DIS                                       
local VECTOR3ZERO                                       = VECTOR3ZERO                                      
local VECTOR3ONE                                        = VECTOR3ONE                                       
local COLORNEW                                          = COLORNEW                                         
local QUATERNION_EULER                                  = QUATERNION_EULER                                 
local QUATERNION_LOOKROTATION                           = QUATERNION_LOOKROTATION                          
local C_Quaternion_Zero                                 = C_Quaternion_Zero                                
local C_Vector3_Zero                                    = C_Vector3_Zero                                   
local C_Vector3_One                                     = C_Vector3_One                                    
local C_Color_One                                       = C_Color_One                                      
local V_Vector3_Value                                   = V_Vector3_Value                                  
local V_Color_Value                                     = V_Color_Value                                    
local ImageAnimaClassType                               = ImageAnimaClassType                              
local ImageClassType                                    = ImageClassType                                   
local GAMEOBJECT_NEW                                    = GAMEOBJECT_NEW                                   
local BoxColliderClassType                              = BoxColliderClassType                             
local ParticleSystemClassType                           = ParticleSystemClassType                          
local UTIL_ADDCOMPONENT                                 = UTIL_ADDCOMPONENT                                
local MATH_SQRT                                         = MATH_SQRT                                        
local MATH_SIN                                          = MATH_SIN                                         
local MATH_COS                                          = MATH_COS  
local MATH_ATAN                                         = MATH_ATAN
local MATH_TAN                                          = MATH_TAN                                       
local MATH_FLOOR                                        = MATH_FLOOR                                       
local MATH_ABS                                          = MATH_ABS                                         
local MATH_RAD                                          = MATH_RAD                                         
local MATH_RAD2DEG                                      = MATH_RAD2DEG                                     
local MATH_DEG                                          = MATH_DEG                                         
local MATH_DEG2RAD                                      = MATH_DEG2RAD                                     
local MATH_RANDOM                                       = MATH_RANDOM    
local MATH_PI                                           = MATH_PI                                   



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
        self._objs[i]:SetActive(false);
    end
end

function AtlasNumber:_setNumber(num)
    local str,len
    if toInt64(num)>toInt64(0) and self._isDisplayAdd then
        str = string.format("+%s",tostring(num));
    else
        str = string.format("%s",tostring(num));
    end
    len = #str;
    local curLen = self._mallocLen;
    local color 
    self._width = 0;
    local chr
    for i=1,len do
        chr = string.sub(str, i, i)
        self._sprites[i] = self._spriteCreator(chr);
        --每个高度和宽度
        self._widths[i]  = self._sprites[i].rect.size.x;
        self._heights[i] = self._sprites[i].rect.size.y;
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
            self._imgs[i].color        = COLORNEW(color.r,color.g,color.b,self._alpha);
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
        self._imgs[i].sprite = self._sprites[i];
        self._imgs[i]:SetNativeSize();
    end
    self._curLen = len;
    self:_arrangePos();
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
        self._imgs[i].color = COLORNEW(color.r,color.g,color.b,_a);
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
    self.transform.localPosition = C_Vector3_Zero;
    self.transform.localScale = C_Vector3_One;
    self.transform.localRotation = C_Quaternion_Zero;
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

--偏移某个数字
function AtlasNumber:OffsetPos(index,pos)
    local v3 = V_Vector3_Value;
    local numPos= self._numPoses[index];
    if pos then
        if index>self._curLen then
            return ;
        end
        v3.x = numPos.x + pos.x;
        v3.y = numPos.y + pos.y;
        v3.z = numPos.z + pos.z;
        self._tranforms[index].localPosition = v3;  
    else
        if index>self._curLen then
            return ;
        end
        self._tranforms[index].localPosition = numPos;        
    end
end

--隐藏某位数字
function AtlasNumber:HideNumber(index)
    index = index or self._curLen;
    if index>self._curLen or index<=0  then
        return ;
    end
    self._objs[index]:SetActive(false);
end

--隐藏所有数字
function AtlasNumber:HideNumbers()
    for i=1,self._curLen do
        self._objs[i]:SetActive(false);
    end
end

--显示所有数字
function AtlasNumber:ShowNumbers()
    for i=1,self._curLen do
        self._objs[i]:SetActive(true);
    end
end

--显示所有数字
function AtlasNumber:ShowNumber(index)
    index = index or self._curLen;
    if index>self._curLen or index<=0 then
        return ;
    end
    self._objs[index]:SetActive(true);
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
end

function AtlasNumber:SetFontPadding(_offset,_isArrange)
    self._fontOffSet = _offset;
    if _isArrange then
        self:_arrangePos();
    end 
end


return AtlasNumber;