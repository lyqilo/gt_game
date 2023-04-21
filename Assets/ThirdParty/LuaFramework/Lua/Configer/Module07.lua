Module07Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module07.FishGame_LKPY.MainPanel",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "万炮捕鱼",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "万炮捕鱼",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module07/game_lkpy2_music.unity3d",
        [2] = "module07/game_lkpy2_music.unity3d.manifest",
        [3] = "module07/module07.unity3d",
    }
}