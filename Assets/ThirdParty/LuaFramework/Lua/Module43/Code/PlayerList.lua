--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local PlayerList = {}
local self = PlayerList

function PlayerList.Init()
    self.PlayerArr = {}
end

function PlayerList.AddPlayer(player)
    logError("AddPlayer1")
    if(self.PlayerArr[TableUserInfo._1dwUser_Id] == nil)then
        logError("添加玩家成功: "..TableUserInfo._1dwUser_Id)
        self.PlayerArr[TableUserInfo._1dwUser_Id] = player
    else
        logError("添加玩家失败: "..TableUserInfo._1dwUser_Id)
    end
end

function PlayerList.RemovePlayer(id)
     if(self.PlayerArr[id] ~= nil)then
        self.PlayerArr[id] = nil
     else
        logError("删除玩家失败： "..tostring(id))
     end
end

function PlayerList.UpdatePlayerGold(data)
    for k, v in pairs(self.PlayerArr)do
        if(v.Id == data._uid) then
            v.Money = data._gold
            return
        end
    end
    logError("更新金币失败: "..tostring(data._uid))
end

function PlayerList.RemovePlayer(player)

end

function PlayerList.UpdatePlayerListUI()
    
end

function PlayerList.Dispose()
    for k, v in pairs(self.PlayerArr)do
        if(v ~= nil)then
            v:ResetData()
        end
    end
    self.PlayerArr = {}
end

return PlayerList
--endregion
