--region *.lua
--DateGetCompend
--此文件由[BabeLua]插件自动生成

--延时事件触发工具    2020.2.18

local DeLayRun = {}
DeLayRun.Data = {}

function DeLayRun.Update()
    for k, v in pairs(DeLayRun.Data) do
        if(v ~= nil)then
            if(v[1] - UnityEngine.Time.deltaTime <= 0)then
                v[1] = 0;
                if(v[2] ~= nil)then
                    v[2]()
                    if(DeLayRun.Data[k] ~= nil and DeLayRun.Data[k][1] <= 0)then
                        v[2] = nil
                    end
                end
                if(DeLayRun.Data[k] ~= nil and DeLayRun.Data[k][1] <= 0)then
                    DeLayRun.Data[k] = nil
                end
            else
                local a = math.ceil(v[1])
                v[1] =  v[1] - UnityEngine.Time.deltaTime
                local b = math.ceil(v[1])
                if(a ~= b and v[3] ~= nil)then
                    v[3]()
                end
            end
        end
    end
end

function  DeLayRun.CheckExist(name)
    for k, v in pairs (DeLayRun.Data) do
        if(k == name and v ~= nil and v[1] > 0)then
            return true
        end
    end
    return false
end

--添加延时事件 time要延时多长时间 Func触发事件 Func1每间隔1秒触发事件 name此次延时事件的名称
function DeLayRun.AddDelay(time, Func, Func1, name)
    if(name ~= nil)then
        if(DeLayRun.CheckExist(name) == false)then
            DeLayRun.Data[name] = {time, Func, Func1}
        else
            logError("AddDelay Exist same Key")
        end
    else
        for i = 1, 1000 do
            if(DeLayRun.Data[i] == nil)then
                 DeLayRun.Data[i] = {time, Func, Func1}
                 return;
            end
        end
        logError("AddDelay fail, more than 1000")
    end
end

function DeLayRun.ClearAllDelay()
    DeLayRun.Data = {}
end

function DeLayRun.ClearTargetDelay(name)
    for k, v in pairs(DeLayRun.Data)do
        if(k == name)then
            DeLayRun.Data[name] = nil
        end
    end
end

return DeLayRun




--endregion
