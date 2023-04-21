Module51Configer = {
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    --luaPath = "Module51.Scripts.Core.SlotGameEntry", --也可以写成Module12/ATT/ATT_MainPanel
    luaPath = "Module51.SGXML.SGXMLEntry",
    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Prefab",
    -- 游戏的名字
    gameName = "水果小玛丽",
    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "水果小玛丽",
    -- 要下载的文件列表
    downFiles = {
        [1] = "module51/module51.unity3d"
    }
}
