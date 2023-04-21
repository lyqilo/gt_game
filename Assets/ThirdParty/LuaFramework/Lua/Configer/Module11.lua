Module11Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module11.ShuiGuoJi.FruitGameMain",

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "CsJoinLua",

    -- 游戏的名字
    gameName = "速度激情",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "速度激情",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module11/game_shuiguoji_music.unity3d",
        [2] = "module11/game_shuiguoji_music.unity3d.manifest",
        [3] = "module11/game_shuiguoji_res.unity3d.manifest",
        [4] = "module11/game_shuiguoji_res.unity3d",
    }
}