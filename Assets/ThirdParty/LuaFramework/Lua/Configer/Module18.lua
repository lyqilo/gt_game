Module18Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module18.SHZ.shzpanel",

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "水浒传",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "水浒传",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module18/module18.unity3d",
    }
}
