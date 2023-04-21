--SlotResourcesName_New *.lua
--Date
--slot 资源管理



--endregion


SlotResourcesName = {};

local self = SlotResourcesName;
--module27/
self.dbResNameStr = string.lower(g_sSlotModuleNum) .. "game_slot_res"; --游戏db资源名称
self.dbMusicResStr = string.lower(g_sSlotModuleNum) .. "game_slot_music_res"; --音效资源
self.dbAnimationStr = string.lower(g_sSlotModuleNum) .. "game_slot_animtion_res"; --动画资源
self.adScenestr = string.lower(g_sSlotModuleNum) .. "game_slot_scene_new"; --场景资源

self.abTestStr = string.lower(g_sSlotModuleNum) .. "game_slot_test_res"; --测试资源

--------音效------------
self.bgm = "BGM"; --背景
self.btn = "btn"; -- 按钮
self.go = "Go"; --启动
self.godDownBGM = "GodDownBGM"; --财神降临
self.godStop = "GodStop"; --财神停止
self.JYMT = "JYMT"; --金玉满堂
self.line = "Line"; --线
self.rateaStop = "RateaStop"; --转动停止
self.superGold = "SuperGold"; -- 超级彩金
self.downScore = "DownScore";


