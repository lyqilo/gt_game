Module14Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module14.WhiteSnakeFish.MainPanel",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "白蛇传",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "白蛇传",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module14/game_white_snake_music.unity3d",
        [2] = "module14/module14.unity3d",
        [3] = "module14/game_white_snake_music.unity3d.manifest",
    }
}