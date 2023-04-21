local eventIDCreator=ID_Creator(1);
--事件ID定义
SI_EventID ={
    NotifySceneInfo         = eventIDCreator(1), --通知场景消息
    ChangeBet               = eventIDCreator(), --改变底注
    ChangeLine              = eventIDCreator(),  --改变倍数
    ResponseGameData        = eventIDCreator(),  --响应时间
    NotifyUIClearBrick      = eventIDCreator(),  --删除砖
    NotifyUIClearDrill      = eventIDCreator(),  --清除钻头
    NotifyUIJiLeiShow       = eventIDCreator(),  --通知界面显示积累奖
    NotifyUIClearStone      = eventIDCreator(),  --通知钻头
    NotifyUIMoveStone       = eventIDCreator(),  --通知移动宝石
    NotifyUIFallStone       = eventIDCreator(),  --通知下落宝石
    NotifyUIBalance         = eventIDCreator(),  --通知结算
    NotifyUIChangeNextStage = eventIDCreator(),  --通知切换到下一关
    NotifyStartGame         = eventIDCreator(),  --通知开始游戏
    NotifyUICaiJin          = eventIDCreator(),  --通知彩金
    NotifyDragonMission     = eventIDCreator(),  --开始龙珠关卡
    NotifyUserEnter         = eventIDCreator(),  --收到玩家进入消息
    NotifyChangeGold        = eventIDCreator(),  --收到玩家金钱改变消息
    NotifyAddGold           = eventIDCreator(),  --收到玩家金币增加
    NofitySynchGold         = eventIDCreator(),  --同步金币数
    NotifyChangeDragonData  = eventIDCreator(),  --龙珠等级改变

    FallDownOverCallBack    = eventIDCreator(),  -- 下落完毕回调
    ClearDrillOverCallBack  = eventIDCreator(),  --清除锥子完毕回调
    JiLeiShowCallBack       = eventIDCreator(),  --积累奖显示完毕
    ClearStoneLinesCallBack = eventIDCreator(),  --清除连线
    MoveStoneOverCallback   = eventIDCreator(),  --移动完成
    NextStageOverCallback   = eventIDCreator(),  --关卡切换结束

    NotifyOpenStartGame     = eventIDCreator(),  --开启游戏


    ResponsePlayerList      = eventIDCreator(),  --玩家列表回调
};
