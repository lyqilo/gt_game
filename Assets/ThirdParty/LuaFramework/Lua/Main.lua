--主入口函数。从这里开始lua逻辑
function Main()					
	print("==================Main Start==================")	 	

end

--场景切换通知
function OnLevelWasLoaded(level)
	
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end

function CsSocketReceive(mainID, subID, buffer, size, socketID)
    Network.OnSocket(mainID,subID,buffer,size,socketID);
end

function CsSocketException(args, ...)
    Network.OnException(args,...);
end