Module04Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module04.wpby.WPBYEntry", --也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Prefab",

    -- 游戏的名字
    gameName = "万炮捕鱼",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "万炮捕鱼",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module04/module04.unity3d",
    }
}