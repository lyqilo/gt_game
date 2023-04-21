InCamer = { };
local self = InCamer;

function InCamer:Begin(obj)
       if IsNil(obj) then return end
       obj=obj.transform.parent:GetChild(0).gameObject;
       obj:SetActive(false);
end

--���������
function InCamer:OnBecameVisible(obj)
       if IsNil(obj) then return end
       obj=obj.transform.parent:GetChild(0).gameObject;
       obj:SetActive(true);
end

--���������
function InCamer:OnBecameInvisible(obj)
       if IsNil(obj) then return end
       obj=obj.transform.parent:GetChild(0).gameObject;
       obj:SetActive(false);
end