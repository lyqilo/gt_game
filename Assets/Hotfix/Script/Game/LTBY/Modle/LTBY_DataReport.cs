using System;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{

    public class ReportMapData
    {
        public Dictionary<string, long> Get;
        public Dictionary<string, long> Cost;
        public Dictionary<string, long> Extra;
        public long EnterScore = 0;
        public long CalcScore = 0;
        public long ShowScore = 0;
        public long MaxScore = 0;
    }
    public class LTBY_DataReport : SingletonNew<LTBY_DataReport>
    {
        private int UpdateKey;
        private ReportMapData ReportMap;
        private int ShootPackage;
        private int HitPackage;
        private long curElectricDragonScore = 0;//统计当前雷皇龙总共的分数（由于雷皇龙电到的闪电鱼,一网打尽,转盘鱼和河豚都不会算到里面 但是服务器统计算了）

        public void AddShootPackage()
        {
            ShootPackage++;
        }
        public void AddHitPackage()
        {
            HitPackage++;
        }
        public override void Init(Transform iLEntity = null)
        {
            // UpdateKey = LTBY_Extend.Instance.StartTimer(Report, 120);
            ReportMap = new ReportMapData()
            {
                Get = new Dictionary<string, long>(),
                Cost = new Dictionary<string, long>(),
                Extra = new Dictionary<string, long>(),
                EnterScore = 0,
                CalcScore = 0,
                ShowScore = 0,
                MaxScore = 0,
            };

            ShootPackage = 0;
            HitPackage = 0;
        }
        public override void Release()
        {
            // Report();
            // LTBY_Extend.Instance.StopTimer(UpdateKey);
        }
        public void SetEnterScore(long score)
        {
            ReportMap.EnterScore = score;
            ReportMap.CalcScore = score;
            ReportMap.MaxScore = score;
        }
        public void Get(string key, long num)
        {
            if (!ReportMap.Get.ContainsKey(key)) ReportMap.Get.Add(key, 0);
            ReportMap.Get[key] += num;
            ReportMap.CalcScore += num;

            if (ReportMap.CalcScore > ReportMap.MaxScore)
            {
                ReportMap.MaxScore = ReportMap.CalcScore;
            }
            // DebugHelper.LogError($"玩家通过{key}获得：{num}");
        }
        public void Cost(string key, long num)
        {
            if (!ReportMap.Cost.ContainsKey(key)) ReportMap.Cost.Add(key, 0);
            ReportMap.Cost[key] += num;
            ReportMap.CalcScore -= num;
            //DebugHelper.LogError($"玩家通过{key} 消耗:{num}");
        }
        public void Extra(string key, long num)
        {
            if (!ReportMap.Extra.ContainsKey(key)) ReportMap.Extra.Add(key, 0);
            ReportMap.Extra[key] += num;
            //DebugHelper.LogError($"玩家通过{key}获得额外收益：{num}");
        }
        private void Report() {
            //ReportMap.ShowScore = LTBY_GameView.GameInstance.GetUserScore();

            //        GC.NetworkRequest.Request("CSUserLog",{
            //            type = 0,
            //    score = tostring(GC.GameInstance:GetUserScore()),
            //    content = Json.encode(ReportMap),
            //});
            //logError(Json.encode(ReportMap));
            //logError("发射包"..ShootPackage);
            //logError("击中包"..HitPackage);
        }
        /// <summary>
        /// 上报雷皇龙被捕获
        /// </summary>
        /// <param name="batteryRatio"></param>
        /// <param name="fishUid"></param>
        /// <param name="chairId"></param>
        public void ReportElectricDragonCapture(int batteryRatio, int fishUid, int chairId)
        {

        }
        /// <summary>
        /// 收到服务器推送的雷皇龙结算消息
        /// </summary>
        /// <param name="chairId"></param>
        public void ReportElectricDragonScore(int chairId)
        {

        }
        /// <summary>
        /// 雷皇龙加分上报
        /// </summary>
        /// <param name="score"></param>
        /// <param name="multiple"></param>
        /// <param name="chairId"></param>
        public void ReportElectricDragonAddScore(long score, int multiple, int chairId)
        {

        }
        /// <summary>
        /// 玩家切后台上报
        /// </summary>
        /// <param name="userScore"></param>
        /// <param name="chairId"></param>
        public void ReportEnterInBackground(long userScore, int chairId)
        {
            //            local data = {
            //        type = "用户切到后台",
            //        ['chairId'] = chairId,
            //        time = os.date("%c"),
            //    }

            //        GC.NetworkRequest.Request("CSUserLog",{
            //        type = 1,
            //        score = tostring(userScore),
            //        content = Json.encode(data),
            //    })

            //    if (showDebug) then
            //        logError("用户切到后台 "..tostring(Json.encode(data)));
            //end
        }
        /// <summary>
        /// 玩家切回前台上报
        /// </summary>
        /// <param name="userScore"></param>
        /// <param name="gold"></param>
        /// <param name="chairId"></param>
        public void ReportBackFromBackground(ulong userScore, ulong gold, int chairId)
        {
            
        }
        /// <summary>
        /// 上报雷皇龙特效为空 不会结算加钱
        /// </summary>
        public void ReportSpineAwardEffectIsNil()
        {

        }
        /// <summary>
        /// 上报flyIcon的传入坐标为空
        /// </summary>
        /// <param name="traceBack"></param>
        public void ReportFlyCoinAimPosNil(object traceBack)
        {

        }
        /// <summary>
        /// 自己的雷皇龙特效销毁的时候上报
        /// </summary>
        /// <param name="traceBack"></param>
        public void ReportDestroyElectricDragon(object traceBack)
        {

        }
        /// <summary>
        /// 上报创建雷皇龙时 正在后台
        /// </summary>
        /// <param name="chairId"></param>
        public void ReportElectricInBackground(int chairId)
        {

        }

        public void ResetElectricDragonScore()
        {
            curElectricDragonScore = 0;
        }

        public void AddElectricDragonScore(long earn)
        {
            curElectricDragonScore += earn;
        }
    }
}
