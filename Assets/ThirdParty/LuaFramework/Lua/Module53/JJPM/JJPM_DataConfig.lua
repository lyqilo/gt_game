JJPM_DataConfig = {}

local self = JJPM_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 10;--下注列表长度
self.HISTORY_COUNT = 7;--历史记录长度
self.GAME_PLAYER = 50;--房间人数
self.AREA_COUNT = 15;--下注区域个数

self.WinList = { { 1, 6 }, { 1, 5 }, { 1, 4 }, { 1, 3 }, { 1, 2 }, { 2, 6 }, { 2, 5 }, { 2, 4 }, { 2, 3 }, { 3, 6 }, { 3, 5 }, { 3, 4 }, { 4, 6 }, { 4, 5 }, { 5, 6 } };
self.peiLvList = { 16, 12, 10, 8, 6, 20, 16, 12, 10, 30, 20, 16, 40, 30, 80 };