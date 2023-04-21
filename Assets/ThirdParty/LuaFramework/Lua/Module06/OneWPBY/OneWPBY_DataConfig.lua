OneWPBY_DataConfig = {}

local self = OneWPBY_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 10;--下注列表长度
self.HISTORY_COUNT = 7;--历史记录长度
self.GAME_PLAYER = 4;--房间人数
self.AREA_COUNT = 15;--下注区域个数
self.BULLET_COUNT = 10--
self.MAX_FISH_KIND = 1;
self.MAX_BULLET = 256;
self.MAX_FISH = 35;
self.MAX_FISH_BUFFER = 100;
self.MAX_YUCHAOFISH_BUFFER = 2000;
self.MAX_FISH_POINT = 6;
self.MAX_FISH_COUNT = 50;
self.MAX_DEAD_FISH = 30;
self.MAX_PROBABILITY = 100000;
self.YuWangYuChaoCount = 3;
self.CreateFishGroupCount = 15;
self.MAX_YuChaoCount = 5;
self.MAX_BackgroundPicture = 18;
self.MAX_CalcFishMaxOdd = 20;

self.FishKind = {
    "fish_01", --小黄鱼
    "fish_02", --小草鱼
    "fish_04", --扁嘴鱼    
    "fish_06", --小丑鱼
    "fish_09", --灯笼鱼
    "fish_11", --燕尾鱼
    "fish_14", --短吻鱼
    "fish_13", --公主鱼
    "fish_10", --乌龟
    "fish_08", --龙虾
    "fish_12", --蝴蝶鱼
    "fish_15", --蝙蝠鱼
    "fish_16", --银鲨
    "fish_17", --金鲨
    "fish_19", --金龙
    "fish_20", --金币海豚
    "fish_21", --李逵
    "fish_22", --水浒传 全屏炸弹
    "fish_27", --局部炸弹
    "fish_40", --同类炸弹1
    "fish_41", --同类炸弹2
    "fish_42", --同类炸弹3
    "fish_43", --同类炸弹4
    "fish_44", --同类炸弹5
}
self.FishType = {
    "XiaoHuangYu"; -- 小黄鱼
    "XiaoCaoYu"; -- 小草鱼
    "BianZuiYu"; -- 扁嘴鱼
    "XiaoChouYu"; -- 小丑鱼
    "DengLongYu"; -- 灯笼鱼
    "YanWeiYu"; -- 燕尾鱼
    "DuanWenYu"; -- 短吻鱼
    "GongZhuYu"; -- 公主鱼
    "WuGui"; -- 乌龟
    "LanLingYu"; -- 龙虾
    "HuDieYu"; -- 蝴蝶鱼
    "BianFuYu"; -- 蝙蝠鱼
    "YinSha"; -- 银鲨
    "JinSha"; -- 金鲨    
    "JinLong"; -- 金龙
    "JinBiHaiTun"; -- 金币海豚 18
    "LiKui"; -- 李逵
    "ShuiHuZhuan"; -- 水浒传 全屏炸弹
    "JuBuZhaDan"; -- 局部炸弹
    "TongLeiZhaDan1"; -- 同类炸弹1
    "TongLeiZhaDan2"; -- 同类炸弹2
    "TongLeiZhaDan3"; -- 同类炸弹3
    "TongLeiZhaDan4"; -- 同类炸弹4
    "TongLeiZhaDan5"; -- 同类炸弹5
}
self.StartScale = {
    1.2, 1.5, 1.5, 2, 1.5, 1, 1, 1, 1, 1, 1.2, 1.2, 1.5, 1.5, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2
}