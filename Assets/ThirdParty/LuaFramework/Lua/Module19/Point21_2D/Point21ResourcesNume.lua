--Point21ResourcesNume.lua
--Date

--21点资源ID

--endregion

--默认的定义数

Point21ResourcesNume = {}

local self = Point21ResourcesNume

self.dbResNameStr = "module19/game_point21_2d_res" --游戏db资源名称
self.dbMusicResNameStr = "module19/game_point21_2d_music" --游戏db音乐资源名称
self.abObjResNameStr = "module19/game_point21_2d_obj" --游戏场景资源
self.abHellp = "module19/game_point21_2d_hellp"

self.abTempResStr = "module19/game_point21_2d_obj_temp"

--获取21点扑资源对应的名字 idx:扑克对应的服务器发来的byte值
function Point21ResourcesNume.getPokerNume(idx)
    local idxOXStr = string.format("%#x", idx) --转为16进制
    if (idx == 1) then
        return "heitaoA"
    elseif (idx == 2) then
        return "heitao2"
    elseif (idx == 3) then
        return "heitao3"
    elseif (idx == 4) then
        return "heitao4"
    elseif (idx == 5) then
        return "heitao5"
    elseif (idx == 6) then
        return "heitao6"
    elseif (idx == 7) then
        return "heitao7"
    elseif (idx == 8) then
        return "heitao8"
    elseif (idx == 9) then
        return "heitao9"
    elseif (idx == 10) then
        return "heitao10"
    elseif (idx == 11) then
        return "heitaoJ"
    elseif (idx == 12) then
        return "heitaoQ"
    elseif (idx == 13) then
        return "heitaoK"
    elseif (idx == 17) then
        return "hongtaoA"
    elseif (idx == 18) then
        return "hongtao2"
    elseif (idx == 19) then
        return "hongtao3"
    elseif (idx == 20) then
        return "hongtao4"
    elseif (idx == 21) then
        return "hongtao5"
    elseif (idx == 22) then
        return "hongtao6"
    elseif (idx == 23) then
        return "hongtao7"
    elseif (idx == 24) then
        return "hongtao8"
    elseif (idx == 25) then
        return "hongtao9"
    elseif (idx == 26) then
        return "hongtao10"
    elseif (idx == 27) then
        return "hongtaoJ"
    elseif (idx == 28) then
        return "hongtaoQ"
    elseif (idx == 29) then
        return "hongtaoK"
    elseif (idx == 33) then
        return "meihuaA"
    elseif (idx == 34) then
        return "meihua2"
    elseif (idx == 35) then
        return "meihua3"
    elseif (idx == 36) then
        return "meihua4"
    elseif (idx == 37) then
        return "meihua5"
    elseif (idx == 38) then
        return "meihua6"
    elseif (idx == 39) then
        return "meihua7"
    elseif (idx == 40) then
        return "meihua8"
    elseif (idx == 41) then
        return "meihua9"
    elseif (idx == 42) then
        return "meihua10"
    elseif (idx == 43) then
        return "meihuaJ"
    elseif (idx == 44) then
        return "meihuaQ"
    elseif (idx == 45) then
        return "meihuaK"
    elseif (idx == 49) then
        return "fangkuaiA"
    elseif (idx == 50) then
        return "fangkuai2"
    elseif (idx == 51) then
        return "fangkuai3"
    elseif (idx == 52) then
        return "fangkuai4"
    elseif (idx == 53) then
        return "fangkuai5"
    elseif (idx == 54) then
        return "fangkuai6"
    elseif (idx == 55) then
        return "fangkuai7"
    elseif (idx == 56) then
        return "fangkuai8"
    elseif (idx == 57) then
        return "fangkuai9"
    elseif (idx == 58) then
        return "fangkuai10"
    elseif (idx == 59) then
        return "fangkuaiJ"
    elseif (idx == 60) then
        return "fangkuaiQ"
    elseif (idx == 61) then
        return "fangkuaiK"
    end
end
function Point21ResourcesNume.getPokerNum(idx)

    local idxOXStr = string.format("%#x", idx) --转为16进制
    if (idx == 1) then
        return 1
    elseif (idx == 2) then
        return 2
    elseif (idx == 3) then
        return 3
    elseif (idx == 4) then
        return 4
    elseif (idx == 5) then
        return 5
    elseif (idx == 6) then
        return 6
    elseif (idx == 7) then
        return 7
    elseif (idx == 8) then
        return 8
    elseif (idx == 9) then
        return 9
    elseif (idx == 10) then
        return 10
    elseif (idx == 11) then
        return 10
    elseif (idx == 12) then
        return 10
    elseif (idx == 13) then
        return 10
    elseif (idx == 17) then
        return 1
    elseif (idx == 18) then
        return 2
    elseif (idx == 19) then
        return 3
    elseif (idx == 20) then
        return 4
    elseif (idx == 21) then
        return 5
    elseif (idx == 22) then
        return 6
    elseif (idx == 23) then
        return 7
    elseif (idx == 24) then
        return 8
    elseif (idx == 25) then
        return 9
    elseif (idx == 26) then
        return 10
    elseif (idx == 27) then
        return 10
    elseif (idx == 28) then
        return 10
    elseif (idx == 29) then
        return 10
    elseif (idx == 33) then
        return 1
    elseif (idx == 34) then
        return 2
    elseif (idx == 35) then
        return 3
    elseif (idx == 36) then
        return 4
    elseif (idx == 37) then
        return 5
    elseif (idx == 38) then
        return 6
    elseif (idx == 39) then
        return 7
    elseif (idx == 40) then
        return 8
    elseif (idx == 41) then
        return 9
    elseif (idx == 42) then
        return 10
    elseif (idx == 43) then
        return 10
    elseif (idx == 44) then
        return 10
    elseif (idx == 45) then
        return 10
    elseif (idx == 49) then
        return 1
    elseif (idx == 50) then
        return 2
    elseif (idx == 51) then
        return 3
    elseif (idx == 52) then
        return 4
    elseif (idx == 53) then
        return 5
    elseif (idx == 54) then
        return 6
    elseif (idx == 55) then
        return 7
    elseif (idx == 56) then
        return 8
    elseif (idx == 57) then
        return 9
    elseif (idx == 58) then
        return 10
    elseif (idx == 59) then
        return 10
    elseif (idx == 60) then
        return 10
    elseif (idx == 61) then
        return 10
    end
end
--音效类型枚举
self.EnumSoundType = {
    --获得普通21点牌的时候！
    sound_21 = "21",
    --抓起筹码的音效
    sound_bet = "Bet",
    --获得黑杰克的时候
    sound_blackjack = "BlackJack",
    --牌爆掉的时候
    sound_bust = "Bust",
    --扔筹码的音效
    sound_chip = "Chip",
    --投降的时候
    sound_surrender = "Surrender",
    --发牌
    sound_dealpoker = "DealPoker"
}

--语音枚举
self.EnumVoiceType = {
    -- 一点
    voice_m_001 = 1,
    --2点
    voice_m_002 = 2,
    --3点
    voice_m_003 = 3,
    --4点
    voice_m_004 = 4,
    --5点
    voice_m_005 = 5,
    --6点
    voice_m_006 = 6,
    --7点
    voice_m_007 = 7,
    --8点
    voice_m_008 = 8,
    -- 9点
    voice_m_009 = 9,
    --10点
    voice_m_010 = 10,
    --11点
    voice_m_011 = 11,
    --12点
    voice_m_012 = 12,
    --13点
    voice_m_013 = 13,
    --14点
    voice_m_014 = 14,
    --5点
    voice_m_015 = 15,
    --16点
    voice_m_016 = 16,
    -- 17点
    voice_m_017 = 17,
    --18点
    voice_m_018 = 18,
    --19点
    voice_m_019 = 19,
    --20点
    voice_m_020 = 20,
    --21点
    voice_m_021 = 21,
    --黑杰克
    voice_m_022 = 22,
    --不要
    voice_m_023 = 23,
    --要牌
    voice_m_024 = 24,
    -- 赢局
    voice_m_025 = 25,
    --分牌
    voice_m_026 = 26,
    --加倍
    voice_m_027 = 27,
    --投降
    voice_m_028 = 28,
    --买保险
    voice_m_029 = 29,
    --平手
    voice_m_030 = 30,
    --赢
    voice_m_win = "win",
    --输
    voice_m_lost = "lost"
}

--表情类型
self.ExpressionType = {
    bishi = 1,
    daku = 2,
    daxiao = 3,
    dianzan = 4,
    dongxin = 5,
    gaoxing = 6,
    jiayou = 7,
    jingya = 8,
    liuhan = 9,
    paizhuan = 10,
    shengqi = 11,
    touxiang = 12,
    yinxian = 13,
    zan = 14,
    zibao = 15,
    anwei = 16,
}