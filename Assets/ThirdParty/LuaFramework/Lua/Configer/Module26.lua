Module26Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module26.xxx",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "LuaBehaviour",

    -- 游戏的名字
    gameName = "xxx",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "xxxxxx",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "modulexxx/xxx.unity3d",
    }
}