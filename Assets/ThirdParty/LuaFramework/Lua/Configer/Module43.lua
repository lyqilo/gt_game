Module43Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module43.Code.Game71Panel",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "百人牛牛",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "百人牛牛",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module43/module43.unity3d",
    }
}