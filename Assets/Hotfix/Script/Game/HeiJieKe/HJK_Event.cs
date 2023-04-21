namespace Hotfix.HeiJieKe
{
    public class HJK_Event
    {
        public static event CAction<HJK_Struct.CMD_SC_GAME_FREE> OnSceneData;

        /// <summary>
        /// 场景消息
        /// </summary>
        /// <param name="sceneData"></param>
        public static void DispatchOnSceneData(HJK_Struct.CMD_SC_GAME_FREE sceneData)
        {
            OnSceneData?.Invoke(sceneData);
        }

        public static event CAction OnStartChip;

        /// <summary>
        /// 开始下注
        /// </summary>
        public static void DispatchOnStartChip()
        {
            OnStartChip?.Invoke();
        }

        public static event CAction<HJK_Struct.CMD_SC_PLAYER_CHIP> OnPlayerChip;

        /// <summary>
        /// 玩家下注
        /// </summary>
        public static void DispatchOnPlayerChip(HJK_Struct.CMD_SC_PLAYER_CHIP playerChip)
        {
            OnPlayerChip?.Invoke(playerChip);
        }

        public static event CAction<HJK_Struct.CMD_SC_SEND_POKER> OnSendPoker;

        /// <summary>
        /// 发牌
        /// </summary>
        public static void DispatchOnSendPoker(HJK_Struct.CMD_SC_SEND_POKER sendPoker)
        {
            OnSendPoker?.Invoke(sendPoker);
        }

        public static event CAction OnCheckInsurance;

        /// <summary>
        /// 保险
        /// </summary>
        public static void DispatchOnCheckInsurance()
        {
            OnCheckInsurance?.Invoke();
        }

        public static event CAction<HJK_Struct.CMD_SC_PLAYER_INSURANCE> OnCheckPlayerInsurance;

        /// <summary>
        /// 玩家保险
        /// </summary>
        public static void DispatchOnCheckPlayerInsurance(HJK_Struct.CMD_SC_PLAYER_INSURANCE playerInsurance)
        {
            OnCheckPlayerInsurance?.Invoke(playerInsurance);
        }

        public static event CAction<HJK_Struct.CMD_SC_LOOK_ZJ_BLAKC_JACK> OnCheckBankerHJK;

        /// <summary>
        /// 庄家黑杰克
        /// </summary>
        public static void DispatchOnCheckBankerHJK(HJK_Struct.CMD_SC_LOOK_ZJ_BLAKC_JACK bankerHJK)
        {
            OnCheckBankerHJK?.Invoke(bankerHJK);
        }

        public static event CAction<HJK_Struct.CMD_SC_NORMAL_OPERATE> OnNormalOperate;

        /// <summary>
        /// 普通操作
        /// </summary>
        public static void DispatchOnNormalOperate(HJK_Struct.CMD_SC_NORMAL_OPERATE normalOperate)
        {
            OnNormalOperate?.Invoke(normalOperate);
        }

        public static event CAction<HJK_Struct.CMD_SC_PLAYER_NORMAL_OPERATE> OnPlayerNormalOperate;

        /// <summary>
        /// 玩家普通操作
        /// </summary>
        public static void DispatchOnPlayerNormalOperate(HJK_Struct.CMD_SC_PLAYER_NORMAL_OPERATE normalOperate)
        {
            OnPlayerNormalOperate?.Invoke(normalOperate);
        }

        public static event CAction<HJK_Struct.CMD_SC_LOOK_ZJ_SECOND_POKER> LookSecondPoker;

        /// <summary>
        /// 查看庄家第二张牌
        /// </summary>
        public static void DispatchLookSecondPoker(HJK_Struct.CMD_SC_LOOK_ZJ_SECOND_POKER normalOperate)
        {
            LookSecondPoker?.Invoke(normalOperate);
        }

        public static event CAction<HJK_Struct.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP> PlayerEnterOnChip;

        /// <summary>
        /// 下注时玩家进入
        /// </summary>
        public static void DispatchPlayerEnterOnChip(HJK_Struct.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP player)
        {
            PlayerEnterOnChip?.Invoke(player);
        }

        public static event CAction<HJK_Struct.CMD_SC_GAME_END> OnGameEnd;

        /// <summary>
        /// 游戏结束
        /// </summary>
        /// <param name="gameEnd"></param>
        public static void DispatchOnGameEnd(HJK_Struct.CMD_SC_GAME_END gameEnd)
        {
            OnGameEnd?.Invoke(gameEnd);
        }

        public static event CAction<HJK_Struct.CMD_SC_CHIP_LIST> OnChipList;

        /// <summary>
        /// 游戏列表
        /// </summary>
        /// <param name="chipList"></param>
        public static void DispatchOnChipList(HJK_Struct.CMD_SC_CHIP_LIST chipList)
        {
            OnChipList?.Invoke(chipList);
        }

        public static event CAction<HJK_Struct.CMD_SC_STOP_CHIP> OnStopChip;

        /// <summary>
        /// 停止下注
        /// </summary>
        /// <param name="stopChip"></param>
        public static void DispatchOnStopChip(HJK_Struct.CMD_SC_STOP_CHIP stopChip)
        {
            OnStopChip?.Invoke(stopChip);
        }

        public static event CAction<HJK_Struct.SUB_SC_CHIP_ERROR> OnChipError;

        /// <summary>
        /// 停止下注
        /// </summary>
        /// <param name="chipError"></param>
        public static void DispatchOnChipError(HJK_Struct.SUB_SC_CHIP_ERROR chipError)
        {
            OnChipError?.Invoke(chipError);
        }

        public static event CAction OnHeart;

        /// <summary>
        /// 心跳
        /// </summary>
        public static void DispatchOnHeart()
        {
            OnHeart?.Invoke();
        }

        public static event CAction<GameUserData> OnPlayerEnter;

        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerEnter(GameUserData data)
        {
            OnPlayerEnter?.Invoke(data);
        }
        public static event CAction<GameUserData> OnPlayerExit;

        /// <summary>
        /// 玩家退出
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerExit(GameUserData data)
        {
            OnPlayerExit?.Invoke(data);
        }
        
        public static event CAction<GameUserData> OnPlayerScoreChange;

        /// <summary>
        /// 玩家分数改变
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerScoreChange(GameUserData data)
        {
            OnPlayerScoreChange?.Invoke(data);
        }
        
        public static event CAction<GameUserData> OnPlayerStatusChange;

        /// <summary>
        /// 玩家状态改变
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerStatusChange(GameUserData data)
        {
            OnPlayerStatusChange?.Invoke(data);
        }
    }
}