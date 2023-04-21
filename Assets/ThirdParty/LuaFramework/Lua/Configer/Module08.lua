Module08Configer =
{
    -- main Lua的相对路径,就是游戏第一次要调用的lua文件
    luaPath = "Module08.jinandyinsha.jinandyinsha_initProt",
    -- 也可以写成Module12/ATT/ATT_MainPanel

    -- 驱动lua脚本使用的是LuaBehaviour 还是 CsJoinLua
    driveType = "Scene",

    -- 游戏的名字
    gameName = "飞禽走兽",

    -- 游戏中UI显示或者提示用到的名字,不同的平台可能会有不同的名字
    uiName = "飞禽走兽",

    -- 要下载的文件列表
    downFiles =
    {
        [1] = "module08/game_birdsandbeast_gez.unity3d",
        [2] = "module08/game_birdsandbeast_huoz.unity3d",
        [3] = "module08/game_birdsandbeast_jingsha.unity3d",
        [4] = "module08/game_birdsandbeast_kongq.unity3d",
        [5] = "module08/game_birdsandbeast_laoy.unity3d",
        [6] = "module08/game_birdsandbeast_shiz.unity3d",
        [7] = "module08/game_birdsandbeast_tuz.unity3d",
        [8] = "module08/game_birdsandbeast_xiongm.unity3d",
        [9] = "module08/game_birdsandbeast_yaz.unity3d",
        [10] = "module08/game_birdsandbeast_yingsha.unity3d",
        [11] = "module08/game_birdsandbeast_gez.unity3d.manifest",
        [12] = "module08/game_birdsandbeast_huoz.unity3d.manifest",
        [13] = "module08/game_birdsandbeast_jingsha.unity3d.manifest",
        [14] = "module08/game_birdsandbeast_kongq.unity3d.manifest",
        [15] = "module08/game_birdsandbeast_laoy.unity3d.manifest",
        [16] = "module08/game_birdsandbeast_shiz.unity3d.manifest",
        [17] = "module08/game_birdsandbeast_tuz.unity3d.manifest",
        [18] = "module08/game_birdsandbeast_xiongm.unity3d.manifest",
        [19] = "module08/game_birdsandbeast_yaz.unity3d.manifest",
        [20] = "module08/game_birdsandbeast_yingsha.unity3d.manifest",
        [21] = "module08/module08.unity3d",
    }
}