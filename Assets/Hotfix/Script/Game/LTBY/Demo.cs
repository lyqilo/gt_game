using UnityEngine;

namespace Hotfix.LTBY
{
    public class Demo : SingletonNew<Demo>
    {
        private int[] roads;
        private int index = 0;
        int fishType = 101;
        public void Update()
        {
           if(roads==null) roads= FishRoadConfig.FishRoads.GetDictionaryKeys();

            if (Input.GetKeyDown(KeyCode.Space))
            {
                if (index >= roads.Length)
                {
                    DebugHelper.LogError($"测试完成：{roads.Length}");
                    return;
                }
                DebugHelper.LogError($"测试：{index}");
                
                index++;
                SCFishTracesList sCFishTracesList = new SCFishTracesList();
                sCFishTracesList.fish_traces = new System.Collections.Generic.List<Fish_Traces>();
                sCFishTracesList.fish_array = 0;
                sCFishTracesList.fish_road = index;
                sCFishTracesList.fish_traces.Add(new Fish_Traces()
                {
                    fish_uid =1,
                    fish_type = fishType,
                    groupIndex = 0,
                    fish_stage = 0,
                    is_aced = false
                });
                LTBY_FishManager.Instance.OnFishTracesList(sCFishTracesList);

            }
            else if (Input.GetKeyDown(KeyCode.A))
            {
                fishType++;
                DebugHelper.LogError($"测试鱼：{fishType}");
                FishDataConfig config = FishConfig.Fish.FindItem(p => p.fishOrginType == fishType);
                if (config == null)
                {
                    DebugHelper.LogError($"不存在该{fishType}鱼");
                }
            }
            else if (Input.GetKeyDown(KeyCode.Escape))
            {
                fishType = 101;
                index = 0;
            }
        }
    }
}