using System.Collections.Generic;
using LitJson;
using LuaFramework;

namespace Hotfix.Fulinmen
{
    public partial class Model
    {
        public const ushort MDM_GF_GAME = DataStruct.GameStruct.MDM_GF_GAME;
        public const ushort MDM_ScenInfo = DataStruct.GameSceneStruct.MDM_ScenInfo;
        public const ushort SUB_CS_GAME_START = 0; //启动游戏
        
        public const ushort SUB_SC_GAME_START = 0; //启动游戏
        public const ushort SUB_SC_GAME_OVER = 1; //游戏开始
        public const ushort SUB_SC_UPDATE_PRIZE_POOL = 5; //游戏结算


        public const string StartFailed = "StartFailed";
        public const string StartRoll = "StartRoll";
        public const string DJJYRoll = "DJJYRoll";
        public const string ForceStopRoll = "ForceStopRoll";
        public const string ShowResult = "ShowResult";
        public const string ShowFree = "ShowFree";
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
        public void LoginGame()
        {
            //登录游戏
            REQ_LOGINGAME login = new REQ_LOGINGAME(0,0,GameLocalMode.Instance.SCPlayerInfo.DwUser_Id, GameLocalMode.Instance.SCPlayerInfo.Password, GameLocalMode.Instance.MechinaCode, 0,0);
            HotfixGameComponent.Instance.Send(DataStruct.LoginGameStruct.MDM_GR_LOGON, DataStruct.LoginGameStruct.SUB_GR_LOGON_GAME, login.ByteBuffer, SocketType.Game);
        }

        private void OnReceiveSceneInfo(BytesPack bytesPack)
        {
            if (bytesPack.session.Id != (int) SocketType.Game) return;
            switch (bytesPack.sid)
            {
                case DataStruct.GameSceneStruct.SUB_GF_SCENE:
                    SceneInfo = new FulinmenStruct.SceneInfo(new ByteBuffer(bytesPack.bytes));
                    FreeCount = SceneInfo.FreeCount;
                    IsScene = true;
                    ResultInfo = new FulinmenStruct.ResultInfo()
                    {
                        ImgTable = SceneInfo.ImgTable,
                        GoldNum = SceneInfo.GoldNum,
                        LineTypeTable = SceneInfo.LineTypeTable,
                        fuType = SceneInfo.fuType,
                        WinScore = SceneInfo.WinScore,
                        FreeCount = SceneInfo.FreeCount,
                        GoldModelNum = SceneInfo.GoldModelNum,
                        allOpenRate = SceneInfo.allOpenRate,
                    };
                    DebugHelper.LogError($"{JsonMapper.ToJson(SceneInfo)}");
                    HotfixGameMessageHelper.PostEvent($"{bytesPack.mid}|{bytesPack.sid}", SceneInfo);
                    break;
            }
        }

        private void OnReceiveGameInfo(BytesPack bytesPack)
        {
            switch (bytesPack.sid)
            {
                case SUB_SC_GAME_OVER:
                    ResultInfo = new FulinmenStruct.ResultInfo(new ByteBuffer(bytesPack.bytes));
                    FreeCount = ResultInfo.FreeCount;
                    DebugHelper.LogError($"{JsonMapper.ToJson(ResultInfo)}");
                    HotfixGameMessageHelper.PostEvent($"{bytesPack.mid}|{bytesPack.sid}", ResultInfo);
                    break;
                case SUB_SC_UPDATE_PRIZE_POOL:
                    FulinmenStruct.JackpotInfo jackpotInfo = new FulinmenStruct.JackpotInfo(new ByteBuffer(bytesPack.bytes));
                    HotfixGameMessageHelper.PostEvent($"{bytesPack.mid}|{bytesPack.sid}", jackpotInfo);
                    break;
            }
            IsScene = false;
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

    public struct FulinmenStruct
    {
        public struct SceneInfo : IGameData
        {
            public int bet; //当前下注
            public List<int> chipList; //下注列表
            public List<int> fuTimes; //大福小福倍数
            public List<byte> ImgTable; //
            public List<int> GoldNum;
            public List<List<byte>> LineTypeTable;
            public List<int> fuType;
            public long WinScore;
            public byte FreeCount;
            public byte GoldModelNum;
            public long allOpenRate;

            public SceneInfo(ByteBuffer buffer)
            {
                bet = buffer.ReadInt32();
                chipList = new List<int>();
                for (int i = 0; i < Data.Chiplistcount; i++)
                {
                    chipList.Add(buffer.ReadInt32());
                }
                fuTimes = new List<int>();
                for (int i = 0; i < 2; i++)
                {
                    fuTimes.Add(buffer.ReadInt32());
                }

                ImgTable = new List<byte>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    ImgTable.Add(buffer.ReadByte());
                }

                GoldNum = new List<int>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    GoldNum.Add(buffer.ReadInt32());
                }

                LineTypeTable = new List<List<byte>>();
                for (int i = 0; i < Data.Alllinecount; i++)
                {
                    List<byte> temp = new List<byte>();
                    for (int j = 0; j < Data.Columncount; j++)
                    {
                        temp.Add(buffer.ReadByte());
                    }
                    LineTypeTable.Add(temp);
                }

                fuType = new List<int>();
                for (int i = 0; i < 3; i++)
                {
                    fuType.Add(buffer.ReadInt32());
                }

                WinScore = buffer.ReadInt64();
                FreeCount = buffer.ReadByte();
                GoldModelNum = buffer.ReadByte();
                allOpenRate = buffer.ReadInt64();
            }
        }

        public struct ResultInfo : IGameData
        {
            public List<byte> ImgTable;
            public List<int> GoldNum;
            public List<List<byte>> LineTypeTable;
            public List<int> fuType;
            public long WinScore;
            public byte FreeCount;
            public byte GoldModelNum;
            public long allOpenRate;

            public ResultInfo(ByteBuffer buffer)
            {
                ImgTable = new List<byte>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    ImgTable.Add(buffer.ReadByte());
                }

                GoldNum = new List<int>();
                for (int i = 0; i < Data.Allimgcount; i++)
                {
                    GoldNum.Add(buffer.ReadInt32());
                }

                LineTypeTable = new List<List<byte>>();
                for (int i = 0; i < Data.Alllinecount; i++)
                {
                    List<byte> temp = new List<byte>();
                    for (int j = 0; j < Data.Columncount; j++)
                    {
                        temp.Add(buffer.ReadByte());
                    }
                    LineTypeTable.Add(temp);
                }

                fuType = new List<int>();
                for (int i = 0; i < 3; i++)
                {
                    fuType.Add(buffer.ReadInt32());
                }
                WinScore = buffer.ReadInt64();
                FreeCount = buffer.ReadByte();
                GoldModelNum = buffer.ReadByte();
                allOpenRate = buffer.ReadInt64();
            }
        }

        public struct JackpotInfo : IGameData
        {
            public uint jackpot;

            public JackpotInfo(ByteBuffer buffer)
            {
                jackpot = buffer.ReadUInt32();
            }
        }
    }
}