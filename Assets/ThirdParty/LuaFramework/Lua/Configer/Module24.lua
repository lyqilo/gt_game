Module24Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module24.SerialIndiana.MainPanel",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "龙珠探宝",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "龙珠探宝",

    -- 要下载的文件列表
    downFiles =
    {
          [1] = "module24/module24.unity3d",
--        [1] = "module24/game_serialindiana.unity3d.manifest",
--        [2] = "module24/game_serialindiana_music.unity3d.manifest",
--        [3] = "module24/game_serialindiana.unity3d",
--        [4] = "module24/game_serialindiana_music.unity3d",
    }
}