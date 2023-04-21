using System;
using System.Collections.Generic;
using LuaFramework;
using UnityEngine;

namespace Hotfix
{
    public partial class CustomEvent
    {
        public const string MDM_3D_LeaderBoard = "MDM_3D_LeaderBoard";
    }
}

namespace Hotfix.Hall.LeaderBoard
{
    public class Model : Singleton.Singleton<Model>,IModule
    {
        public readonly List<Tuple<byte, string>> Titles = new List<Tuple<byte, string>>()
        {
            new Tuple<byte, string>(1, "Rich Ranking"),
            new Tuple<byte, string>(2, "Winner Ranking"),
        };

        private bool _isinit;

        public CAction<HallStruct.LeaderBoard.sRankInfo> OnLeaderBoardMessage { get; set; }

        private Dictionary<byte, Tuple<long, HallStruct.LeaderBoard.sRankInfo>> infoDic =
            new Dictionary<byte, Tuple<long, HallStruct.LeaderBoard.sRankInfo>>();

        public void Initialize()
        {
            if (_isinit) UnInitialize();
            _isinit = true;
            AddEvent();
        }

        public void UnInitialize()
        {
            _isinit = false;
            RemoveEvent();
        }

        private void AddEvent()
        {
            HotfixMessageHelper.AddListener(CustomEvent.MDM_3D_LeaderBoard, OnRecieveMessage);
        }

        private void RemoveEvent()
        {
            HotfixMessageHelper.RemoveListener(CustomEvent.MDM_3D_LeaderBoard, OnRecieveMessage);
        }

        public Tuple<long, HallStruct.LeaderBoard.sRankInfo> GetRankInfo(byte type)
        {
            infoDic.TryGetValue(type, out var info);
            return info;
        }

        public void ReqLeaderBoardList(byte type)
        {
            infoDic.TryGetValue(type, out var data);
            if (data != null && !CheckTime(data.Item1))//这里判断是否有过请求  或者请求时间间隔是否满足再次请求需求
            {
                OnLeaderBoardMessage?.Invoke(data.Item2);
                return;
            }

            HotfixGameComponent.Instance.Send(DataStruct.LeaderBoard.MDM_3D_RANK,
                DataStruct.LeaderBoard.C2S_GET_RANK_LIST, new HallStruct.sCommonINT8() {nValue = type}.Buffer,
                SocketType.Hall);
        }

        private bool CheckTime(long reqTime)
        {
            long serverTime = TimeComponent.Instance.GetServerTime();
            if (serverTime <= 0) return false;//服务器时间没有
            DateTime server = serverTime.StampToDatetime();
            DateTime req = reqTime.StampToDatetime();
            return server.Day != req.Day;
        }

        private void OnRecieveMessage(object data)
        {
            if (!(data is BytesPack msg)) return;
            switch (msg.sid)
            {
                case DataStruct.LeaderBoard.S2C_GET_RANK_LIST_RESP:
                    var info = new HallStruct.LeaderBoard.sRankInfo(new ByteBuffer(msg.bytes));
                    infoDic[info.nType] = new Tuple<long, HallStruct.LeaderBoard.sRankInfo>(0, info);
                    DebugHelper.LogError($"{LitJson.JsonMapper.ToJson(info)}");
                    OnLeaderBoardMessage?.Invoke(info);
                    break;
            }
        }
    }
}