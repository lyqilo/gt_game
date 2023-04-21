local LoadPanel = class("LoadPanel");

function LoadPanel:ctor(transform)
    self.transform = transform;
    --初始化UI
    self:Init();
end

function LoadPanel:Init()
    if self.transform then
        self.gameObject = self.transform.gameObject;
        self.gameObject:SetActive(false);
    end
    self.isLoading = false;
end

function LoadPanel:AsyncLoad(handler,_data)
    self.handler   = handler;
    self.runTime   = 0;
    self.data      = _data;
    self.isLoading = true;
    if self.gameObject then
        self.gameObject:SetActive(true);
    end 
end

function LoadPanel:Update(_dt)
    self.runTime = self.runTime + _dt;
    if not self.handler then
        --完成了
        self:OnLoadOver();
        self.isLoading = false;
        return ;
    end

    local isComplete,precent = self.handler(self.runTime,self.data,self);

    if isComplete or precent==100 then
        --完成了
        self:OnLoadOver();
        self.isLoading = false;
    end
end

--是否正在加载
function LoadPanel:IsLoading()
    return self.isLoading;
end

function LoadPanel:OnLoadOver()
    if self.gameObject then
        self.gameObject:SetActive(false);
    end  
end


return LoadPanel;