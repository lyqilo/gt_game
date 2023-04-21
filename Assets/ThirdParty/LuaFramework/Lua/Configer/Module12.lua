Module12Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module12.ATT.ATT_InitProt",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "CsJoinLua",

    -- 游戏的名字
    gameName = "ATT连环炮",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "ATT连环炮",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module12/game_att_main.unity3d",
        [2] = "module12/game_att_num.unity3d",
        [3] = "module12/game_att_sound.unity3d",
        [4] = "module12/game_att_icon.unity3d.manifest",
        [5] = "module12/game_att_main.unity3d.manifest",
        [6] = "module12/game_att_num.unity3d.manifest",
        [7] = "module12/game_att_sound.unity3d.manifest",
        [8] = "module12/game_att_icon.unity3d",
    }
}