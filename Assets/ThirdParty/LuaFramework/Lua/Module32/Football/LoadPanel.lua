local LoadPanel = class("LoadPanel");

--构造
function LoadPanel:ctor(transform)
    self.transform = transform;
    --初始化UI
    self:Init();
end

--初始化UI
function LoadPanel:Init()
    self.gameObject = self.transform.gameObject;
    self.gameObject:SetActive(false);
    self.isLoading = false;
end

--异步加载
function LoadPanel:AsyncLoad(handler,_data)
    self.handler   = handler;
    self.runTime   = 0;
    self.data      = _data;
    self.isLoading = true;
    self.gameObject:SetActive(true);
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

--加载完毕
function LoadPanel:OnLoadOver()
    if self.gameObject then
        self.gameObject:SetActive(false);
    end  
end


return LoadPanel;