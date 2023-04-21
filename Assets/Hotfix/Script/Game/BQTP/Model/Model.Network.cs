using System.Collections.Generic;
using LuaFramework;

namespace Hotfix.BQTP
{
    public partial class Model
    {
        public const ushort MDM_GF_GAME = DataStruct.GameStruct.MDM_GF_GAME;
        public const ushort MDM_ScenInfo = DataStruct.GameSceneStruct.MDM_ScenInfo;
        public const ushort SUB_CS_GAME_START = 1; //启动游戏

        public const ushort SUB_SC_BET_FAIL = 2; //游戏开始
        public const ushort SUB_SC_START_GAME = 102; //游戏结算


        public const string StartFailed = "StartFailed";
        public const string StartRoll = "StartRoll";
        public const string StartReRoll = "StartReRoll";
        public const string ReqReRoll = "ReqReRoll";
        public const string StopRoll = "StopRoll";
        public const string ShowResult = "ShowResult";
        public const string MoveThreeRaw = "MoveThreeRaw";
        public const string RefreshGold = "RefreshGold";
        public const string Check = "Check";

        private void InitNetwork()
        {
            HotfixNetworkMessageHelper.AddListener($"{DataStruct.GameSceneStruct.MDM_ScenInfo}", OnReceiveSceneInfo);
            HotfixNetworkMessageHelper.AddListener($"{DataStruct.GameStruct.MDM_GF_GAME}", OnReceiveGameInfo);
            HotfixNetworkMessageHelper.AddListener($"{DataStruct.UserDestDataStruct.MDM_3D_TABLE_USER_DATA}",
                OnReceiveUserInfo);
            HotfixNetworkMessageHelper.AddListener($"{DataStruct.FrameStruct.MDM_3D_FRAME}", OnReceiveFrameInfo);
        }

        private void ReleaseNetwork()
        {
            HotfixNetworkMessageHelper.RemoveListener($"{DataStruct.GameSceneStruct.MDM_ScenInfo}", OnReceiveSceneInfo);
            HotfixNetworkMessageHelper.RemoveListener($"{DataStruct.GameStruct.MDM_GF_GAME}", OnReceiveGameInfo);
            HotfixNetworkMessageHelper.RemoveListener($"{DataStruct.UserDestDataStruct.MDM_3D_TABLE_USER_DATA}",
                OnReceiveUserInfo);
            HotfixNetworkMessageHelper.RemoveListener($"{DataStruct.FrameStruct.MDM_3D_FRAME}", OnReceiveFrameInfo);
        }

        public void StartGame()
        {
            if (MyGold < (ulong) CurrentChip * Data.Alllinecount && !IsFreeGame)
            {
                ToolHelper.PopSmallWindow("Insufficient gold coins, please recharge");
                HotfixMessageHelper.PostHotfixEvent(StartFailed);
                return;
            }

            var buffer = new ByteBuffer();
            buffer.WriteInt(CurrentChip);
            HotfixGameComponent.Instance.Send(MDM_GF_GAME, SUB_CS_GAME_START, buffer, SocketType.Game);
        }

        private void OnReceiveSceneInfo(BytesPack bytesPack)
        {
            if (bytesPack.session.Id != (int) SocketType.Game) return;
            switch (bytesPack.sid)
            {
                case DataStruct.GameSceneStruct.SUB_GF_SCENE:
                    SceneInfo = new BQTPStruct.SceneInfo(new ByteBuffer(bytesPack.bytes));
                    IsScene = true;
                    FreeCount = SceneInfo.freeNumber;
                    ReRollCount = SceneInfo.cbRerun;
                    HotfixGameMessageHelper.PostEvent($"{bytesPack.mid}|{bytesPack.sid}", SceneInfo);
                    break;
            }
        }

        public void LoginGame()
        {
            //登录游戏
            REQ_LOGINGAME login = new REQ_LOGINGAME(0,0,GameLocalMode.Instance.SCPlayerInfo.DwUser_Id, GameLocalMode.Instance.SCPlayerInfo.Password, GameLocalMode.Instance.MechinaCode, 0,0);
            HotfixGameComponent.Instance.Send(DataStruct.LoginGameStruct.MDM_GR_LOGON, DataStruct.LoginGameStruct.SUB_GR_LOGON_GAME, login.ByteBuffer, SocketType.Game);
        }

        private void OnReceiveGameInfo(BytesPack bytesPack)
        {
            switch (bytesPack.sid)
            {
                case SUB_SC_START_GAME:
                    ResultInfo = new BQTPStruct.ResultInfo(new ByteBuffer(bytesPack.bytes));
                    FreeCount = ResultInfo.FreeCount;
                    HotfixGameMessageHelper.PostEvent($"{bytesPack.mid}|{bytesPack.sid}", ResultInfo);
                    IsScene = false;
                    ReRollCount = ResultInfo.cbReturn;
                    if (ReRollCount <= 0) TotalFreeGold = 0;
                    break;
                case SUB_SC_BET_FAIL:
                    BQTPStruct.FailedInfo failedInfo = new BQTPStruct.FailedInfo(new ByteBuffer(bytesPack.bytes));
                    switch (failedInfo.failedType)
                    {
                        case 0:
                            ToolHelper.PopSmallWindow("Insufficient gold coins");
                            break;
                        default:
                            ToolHelper.PopSmallWindow("Fail to bet");
                            break;
                    }

                    break;
            }
        }

        private void OnReceiveUserInfo(BytesPack bytesPack)
        {
            var userData = new GameUserData(new ByteBuffer(bytesPack.bytes));
            switch (bytesPack.sid)
            {
                case DataStruct.UserDestDataStruct.SUB_3D_TABLE_USER_ENTER:
                    MyGold = userData.Gold;
                    break;
                case DataStruct.UserDestDataStruct.SUB_3D_TABLE_USER_LEAVE:
                    break;
                case DataStruct.UserDestDataStruct.SUB_3D_TABLE_USER_SCORE:
                    MyGold = userData.Gold;
                    break;
                case DataStruct.UserDestDataStruct.SUB_3D_TABLE_USER_STATUS:
                    MyGold = userData.Gold;
                    break;
            }
        }

        private void OnReceiveFrameInfo(BytesPack bytesPack)
        {
        }
    }

    public struct BQTPStruct
    {
        public struct SceneInfo : IGameData
        {
            public int freeNumber; //免费次数
            public int bet; //当前下注
            public int chipNum; //用户金币
            public List<int> chipList; //下注列表
            public byte cbRerun; //重转次数

            public SceneInfo(ByteBuffer buffer)
            {
                freeNumber = buffer.ReadInt32();
                bet = buffer.ReadInt32();
                chipNum = buffer.ReadInt32();
                chipList = new List<int>();
                for (int i = 0; i < Data.Chiplistcount; i++)
                {
                    chipList.Add(buffer.ReadInt32());
                }

                cbRerun = buffer.ReadByte();
            }
        }

        public struct ResultInfo : IGameData
        {
            public List<byte> ImgTable;
            public List<byte> LineTypeTable;
            public int WinScore;
            public int FreeCount;
            public byte cbReturn;
            public byte cbSpecialWild;

            public ResultInfo(ByteBuffer buffer)
            {
                ImgTable = new List<byte>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    ImgTable.Add(buffer.ReadByte());
                }

                LineTypeTable = new List<byte>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    LineTypeTable.Add(buffer.ReadByte());
                }

                WinScore = buffer.ReadInt32();
                FreeCount = buffer.ReadInt32();
                cbReturn = buffer.ReadByte();
                cbSpecialWild = buffer.ReadByte();
            }
        }

        public struct FailedInfo : IGameData
        {
            public byte failedType;

            public FailedInfo(ByteBuffer buffer)
            {
                failedType = buffer.ReadByte();
            }
        }
    }
}