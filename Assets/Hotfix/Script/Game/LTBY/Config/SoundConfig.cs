using System.Collections.Generic;

namespace Hotfix.LTBY
{
    public class SoundConfig
    {
        //背景
        public const string BG = "LTBY_BG";

        public const string Button = "LTBY_Button";

        //发射
        public const string Shoot = "LTBY_Shoot";

        //loading界面吃金币
        public const string LoadingCoin = "LTBY_LoadingCoin";

        //切换特殊炮台
        public const string ChangeSpecialBattery = "LTBY_ChangeSpecialBattery";

        //宝箱1,2,3,
        public const string Treasure0 = "LTBY_Treasure1";
        public const string Treasure1 = "LTBY_Treasure2";
        public const string Treasure2 = "LTBY_Treasure3";
        public const string TreasureText = "LTBY_TreasureText";

        //spine动画特效，1-3 用1，全屏的用2，闪电鱼，电磁，电钻用3
        public const string SpineAward1 = "LTBY_SpineAward1";
        public const string SpineAward2 = "LTBY_SpineAward2";
        public const string SpineAward3 = "LTBY_SpineAward3";

        public const string SpineAwardText4 = "LTBY_SpineAwardText4";

        public const string SpineAwardLight = "LTBY_SpineAwardLight";

        public const string SpineAwardDialFish = "LTBY_SpineAwardDialFish";


        //爆点，1,2,深海鲸是3
        public const string ExplosionPoint1 = "LTBY_ExplosionPoint1";
        public const string ExplosionPoint2 = "LTBY_ExplosionPoint2";
        public const string ExplosionPoint3 = "LTBY_ExplosionPoint3";

        //转盘
        public const string Wheel = "LTBY_Wheel";

        //金币大爆发
        public const string CoinOutburst = "LTBY_CoinOutburst";

        //鱼变大特效，暂用河豚
        public const string FishGrowUp = "LTBY_FishGrowUp";

        //击打鲸鱼
        public const string HitWhale = "LTBY_HitWhale";

        //电钻击鱼
        public const string DrillHitFish = "LTBY_DrillHitFish";

        //闪电链连接
        public const string LightLink = "LTBY_LightLink";

        //特殊鱼出现
        public const string FishAppear = "LTBY_FishAppear";

        //潮汐出现
        public const string Wave = "LTBY_Wave";

        //获得金币
        public const string GetCoin = "LTBY_GetCoin";

        //获得道具
        public const string GetItem = "LTBY_GetItem";

        //掉落道具
        public const string DropItem = "LTBY_DropItem";

        //刮刮卡音效
        public const string ScratchCard = "LTBY_ScratchCard";

        //狂暴开启
        public const string OpenRage = "LTBY_OpenRage";

        //锁定开启
        public const string OpenLock = "LTBY_OpenLock";

        //散射开启
        public const string OpenMultiShoot = "LTBY_OpenMultiShoot";

        //电磁发射
        public const string ElectricShoot = "LTBY_ElectricShoot";

        public const string ElectricGet = "LTBY_ElectricGet";

        //电磁持续
        public const string ElectricContinues = "LTBY_ElectricContinues";

        //电钻发射
        public const string DrillShoot = "LTBY_DrillShoot";

        public const string DrillGet = "LTBY_DrillGet";

        //电钻结束
        public const string DrillFinish = "LTBY_DrillFinish";

        //水柱子弹音效
        public const string WaterSpoutWide = "LTBY_WaterSpout_Wide";
        public const string WaterSpoutSmall = "LTBY_WaterSpout_Small";

        //鱼相关音效
        public const string FishSound1 = "LTBY_bj140";
        public const string FishSound2 = "LTBY_sw129";
        public const string FishSound3 = "LTBY_sw131";
        public const string FishSound4 = "LTBY_bj109";
        public const string FishSound5 = "LTBY_sw109";
        public const string FishSound6 = "LTBY_sw132";
        public const string FishSound7 = "LTBY_bj129";
        public const string FishSound8 = "LTBY_bj126";
        public const string FishSound9 = "LTBY_bj123";
        public const string FishSound10 = "LTBY_sw128";
        public const string FishSound11 = "LTBY_bj133";
        public const string FishSound12 = "LTBY_cc127";
        public const string FishSound14 = "LTBY_sw125";
        public const string FishSound15 = "LTBY_sw124";
        public const string FishSound16 = "LTBY_cc136";
        public const string FishSound17 = "LTBY_cc144";
        public const string FishAppearSound145 = "LTBY_FishAppearSound145";

        //龙相关
        //龙盘
        public const string DragonEffect1 = "LTBY_DragonEffect1";

        //爆分
        public const string DragonEffect2 = "LTBY_DragonEffect2";

        //龙spine动画
        public const string DragonSpineAward = "LTBY_DragonSpineAward";

        //雷皇龙相关
        //捕获喊话
        public const string ElectricDragonDie = "LTBY_ElectricDragonDie";

        //开始全屏电鱼喊话
        public const string AOEElectricSkill = "LTBY_AOEElectricSkill";

        //龙珠全屏闪电音效
        public const string AOEElectricSound = "LTBY_AOEElectricSound";

        //滚倍数音效
        public const string RollMultiple = "LTBY_RollMultiple";

        //龙珠飞音效
        public const string DragonBallFly = "LTBY_DragonBallFly";


        //免费抽奖相关
        public const string FreeLotteryChange = "LTBY_FreeLotteryChange";
        public const string FreeLotteryMove = "LTBY_FreeLotteryMove";
        public const string FreeLotteryRotate = "LTBY_FreeLotteryRotate";
        public const string FreeLotteryOpen = "LTBY_FreeLotteryOpen";

        //召唤
        public const string Summon = "LTBY_Summon";

        //免费子弹
        public const string FreeBG = "LTBY_FreeBG";
        public const string FreeShoot = "LTBY_FreeShoot";
        public const string FreeGet = "LTBY_FreeGet";
        public const string FreeFinish = "LTBY_FreeFinish";

        //转盘鱼
        public const string DialFishFrame = "LTBY_DialFishFrame";
        public const string DialFishMul1 = "LTBY_DialFishMul1";
        public const string DialFishMul2 = "LTBY_DialFishMul2";
        public const string DialFishMul3 = "LTBY_DialFishMul3";
        public const string DialFishMul4 = "LTBY_DialFishMul4";
        public const string DialFishRoll = "LTBY_DialFishRoll";
        public const string DialFishGet = "LTBY_DialFishGet";

        public const string DialFishText = "LTBY_DialFishText";

        //一网打尽
        public const string AcedLink = "LTBY_AcedLink";
        public const string AcedLinkText = "LTBY_AcedLinkText";

        //一亿分爆分
        public const string HundredMillion = "LTBY_HundredMillion";

        //捕获时的模型撒出金币（大量）的音效
        public const string JBPExplosionBig = "LTBY_JBPExplosionBig";

        //捕获时的模型撒出金币（小量）的音效
        public const string JBPExplosionSmall = "LTBY_JBPExplosionSmall";

        //捕获时的转圈摇摆动作的音效
        public const string JBPCaptureRotate = "LTBY_JBPCaptureRotate";

        //升级变身时的加速转圈音效
        public const string JBPChangeStage = "LTBY_JBPChangeStage";

        //升级变身时的闪光音效
        public const string JBPChangeStageFlash = "LTBY_JBPChangeStageFlash";

        //最后一阶段捕获时展现过程里面倍率和金币弹出来的音效
        public const string JBPFlashNum = "LTBY_JBPFlashNum";

        //最后一阶段捕获时展现过程里面金币洒落的音效
        public const string JBPCoinDrop = "LTBY_JBPCoinDrop";

        //最后一个阶段捕获时的语音
        public const string JBPFinalVoice = "LTBY_JBPFinalVoice";

        //结算界面出现的语音
        public const string JBPSettleVoice = "LTBY_145";

        public static Dictionary<string, string> AllAudio = new Dictionary<string, string>()
        {
            {"BG", "LTBY_BG"},
            {"Button", "LTBY_Button"},
            //发射
            {"Shoot", "LTBY_Shoot"},
            //loading界面吃金币
            {"LoadingCoin", "LTBY_LoadingCoin"},
            //切换特殊炮台
            {"ChangeSpecialBattery", "LTBY_ChangeSpecialBattery"},
            //宝箱1,2,3,
            {"Treasure0", "LTBY_Treasure1"},
            {"Treasure1", "LTBY_Treasure2"},
            {"Treasure2", "LTBY_Treasure3"},
            {"TreasureText", "LTBY_TreasureText"},
            //spine动画特效，1-3 用1，全屏的用2，闪电鱼，电磁，电钻用3
            {"SpineAward1", "LTBY_SpineAward1"},
            {"SpineAward2", "LTBY_SpineAward2"},
            {"SpineAward3", "LTBY_SpineAward3"},
            {"SpineAwardText4", "LTBY_SpineAwardText4"},
            {"SpineAwardLight", "LTBY_SpineAwardLight"},
            {"SpineAwardDialFish", "LTBY_SpineAwardDialFish"},
            //爆点，1,2,深海鲸是3
            {"ExplosionPoint1", "LTBY_ExplosionPoint1"},
            {"ExplosionPoint2", "LTBY_ExplosionPoint2"},
            {"ExplosionPoint3", "LTBY_ExplosionPoint3"},
            //转盘
            {"Wheel", "LTBY_Wheel"},
            //金币大爆发
            {"CoinOutburst", "LTBY_CoinOutburst"},
            //鱼变大特效，暂用河豚
            {"FishGrowUp", "LTBY_FishGrowUp"},
            //击打鲸鱼
            {"HitWhale", "LTBY_HitWhale"},
            //电钻击鱼
            {"DrillHitFish", "LTBY_DrillHitFish"},
            //闪电链连接
            {"LightLink", "LTBY_LightLink"},
            //特殊鱼出现
            {"FishAppear", "LTBY_FishAppear"},
            //潮汐出现
            {"Wave", "LTBY_Wave"},
            //获得金币
            {"GetCoin", "LTBY_GetCoin"},
            //获得道具
            {"GetItem", "LTBY_GetItem"},
            //掉落道具
            {"DropItem", "LTBY_DropItem"},
            //刮刮卡音效
            {"ScratchCard", "LTBY_ScratchCard"},
            //狂暴开启
            {"OpenRage", "LTBY_OpenRage"},
            //锁定开启
            {"OpenLock", "LTBY_OpenLock"},
            //散射开启
            {"OpenMultiShoot", "LTBY_OpenMultiShoot"},
            //电磁发射
            {"ElectricShoot", "LTBY_ElectricShoot"},
            {"ElectricGet", "LTBY_ElectricGet"},
            //电磁持续
            {"ElectricContinues", "LTBY_ElectricContinues"},
            //电钻发射
            {"DrillShoot", "LTBY_DrillShoot"},
            {"DrillGet", "LTBY_DrillGet"},
            //电钻结束
            {"DrillFinish", "LTBY_DrillFinish"},
            //水柱子弹音效
            {"WaterSpoutWide", "LTBY_WaterSpout_Wide"},
            {"WaterSpoutSmall", "LTBY_WaterSpout_Small"},
            //鱼相关音效
            {"FishSound1", "LTBY_bj140"},
            {"FishSound2", "LTBY_sw129"},
            {"FishSound3", "LTBY_sw131"},
            {"FishSound4", "LTBY_bj109"},
            {"FishSound5", "LTBY_sw109"},
            {"FishSound6", "LTBY_sw132"},
            {"FishSound7", "LTBY_bj129"},
            {"FishSound8", "LTBY_bj126"},
            {"FishSound9", "LTBY_bj123"},
            {"FishSound10", "LTBY_sw128"},
            {"FishSound11", "LTBY_bj133"},
            {"FishSound12", "LTBY_cc127"},
            {"FishSound14", "LTBY_sw125"},
            {"FishSound15", "LTBY_sw124"},
            {"FishSound16", "LTBY_cc136"},
            {"FishSound17", "LTBY_cc144"},
            {"FishAppearSound145", "LTBY_FishAppearSound145"},
            //龙相关
            //龙盘
            {"DragonEffect1", "LTBY_DragonEffect1"},
            //爆分
            {"DragonEffect2", "LTBY_DragonEffect2"},
            //龙spine动画
            {"DragonSpineAward", "LTBY_DragonSpineAward"},
            //雷皇龙相关
            //捕获喊话
            {"ElectricDragonDie", "LTBY_ElectricDragonDie"},
            //开始全屏电鱼喊话
            {"AOEElectricSkill", "LTBY_AOEElectricSkill"},
            //龙珠全屏闪电音效
            {"AOEElectricSound", "LTBY_AOEElectricSound"},
            //滚倍数音效
            {"RollMultiple", "LTBY_RollMultiple"},
            //龙珠飞音效
            {"DragonBallFly", "LTBY_DragonBallFly"},
            //免费抽奖相关
            {"FreeLotteryChange", "LTBY_FreeLotteryChange"},
            {"FreeLotteryMove", "LTBY_FreeLotteryMove"},
            {"FreeLotteryRotate", "LTBY_FreeLotteryRotate"},
            {"FreeLotteryOpen", "LTBY_FreeLotteryOpen"},
            //召唤
            {"Summon", "LTBY_Summon"},
            //免费子弹
            {"FreeBG", "LTBY_FreeBG"},
            {"FreeShoot", "LTBY_FreeShoot"},
            {"FreeGet", "LTBY_FreeGet"},
            {"FreeFinish", "LTBY_FreeFinish"},
            //转盘鱼
            {"DialFishFrame", "LTBY_DialFishFrame"},
            {"DialFishMul1", "LTBY_DialFishMul1"},
            {"DialFishMul2", "LTBY_DialFishMul2"},
            {"DialFishMul3", "LTBY_DialFishMul3"},
            {"DialFishMul4", "LTBY_DialFishMul4"},
            {"DialFishRoll", "LTBY_DialFishRoll"},
            {"DialFishGet", "LTBY_DialFishGet"},
            {"DialFishText", "LTBY_DialFishText"},
            //一网打尽
            {"AcedLink", "LTBY_AcedLink"},
            {"AcedLinkText", "LTBY_AcedLinkText"},
            //一亿分爆分
            {"HundredMillion", "LTBY_HundredMillion"},
            //捕获时的模型撒出金币（大量）的音效
            {"JBPExplosionBig", "LTBY_JBPExplosionBig"},
            //捕获时的模型撒出金币（小量）的音效
            {"JBPExplosionSmall", "LTBY_JBPExplosionSmall"},
            //捕获时的转圈摇摆动作的音效
            {"JBPCaptureRotate", "LTBY_JBPCaptureRotate"},
            //升级变身时的加速转圈音效
            {"JBPChangeStage", "LTBY_JBPChangeStage"},
            //升级变身时的闪光音效
            {"JBPChangeStageFlash", "LTBY_JBPChangeStageFlash"},
            //最后一阶段捕获时展现过程里面倍率和金币弹出来的音效
            {"JBPFlashNum", "LTBY_JBPFlashNum"},
            //最后一阶段捕获时展现过程里面金币洒落的音效
            {"JBPCoinDrop", "LTBY_JBPCoinDrop"},
            //最后一个阶段捕获时的语音
            {"JBPFinalVoice", "LTBY_JBPFinalVoice"},
            //结算界面出现的语音
            {"JBPSettleVoice", "LTBY_145"},
        };
    }
}