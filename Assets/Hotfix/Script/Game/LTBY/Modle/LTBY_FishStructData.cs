using System.Collections.Generic;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 普通产鱼
    /// </summary>
    public class SCFishTracesList
    {
        public int fish_road;
        public byte fish_array;
        public float create_interval;
        public bool is_called;
        public bool after_tide_first;
        public List<Fish_Traces> fish_traces;
    }

    public class Fish_Traces
    {
        public int fish_uid;
        public int fish_type;
        public int fish_layer;
        public int fish_stage;
        public bool is_aced;
        public int groupIndex;
        public float y;
        public float x;
    }

    /// <summary>
    /// 服务器请求客户端同步鱼
    /// </summary>
    public class SCSyncFishReq
    {
        public int req_player_id;
    }

    /// <summary>
    /// 服务器返回客户端同步鱼
    /// </summary>
    public class SCSyncFishRsp
    {
        public byte fish_array;

        public int fish_road;

        public int move_delay;

        public int road_idx;
        public float move_t;

        public List<Fish_Traces> fish_traces;
    }

    /// <summary>
    /// 捕获
    /// </summary>
    public class SCHitFish
    {
        public int fish_uid;
        public int chair_idx;
        public long user_score;

        /// <summary>
        /// 收益
        /// </summary>
        public long earn;

        public int fish_value;

        /// <summary>
        /// 倍数
        /// </summary>
        public int multiple;
    }

    /// <summary>
    /// 特殊捕鱼
    /// </summary>
    public class SCHitSpecialFish : SCHitFish
    {
        public bool death;

        public int grow_stage;

        public int hit_bullet_type;

        public List<Shock_Fishes> shock_fishes;

        public List<Drop_Props> drop_props;

        public WheelTwo wheel;
    }


    /// <summary>
    /// 弹头捕获
    /// </summary>
    public class SCTorpedoHit : SCHitFish
    {
        public long score;

        public int propId;
        public int remain;

        public float y;
        public float x;
    }

    /// <summary>
    /// 锁鱼
    /// </summary>
    public class SCLockFish
    {
        public int fish_uid;
        public int chair_idx;

        public bool is_open;
    }

    /// <summary>
    /// 切换场景
    /// </summary>
    public class SCChangeScene
    {
        public int scene_index;
    }

    /// <summary>
    /// 游戏信息
    /// </summary>
    public class SCGameInfoNotify
    {
        public bool user_pool;

        public bool multi_shoot;

        public bool crazy_speed;

        public List<int> award_fish;
    }

    /// <summary>
    /// 聚宝盆的数值监听
    /// </summary>
    public class SCTreasureFishInfo
    {
        public int fish_uid;

        public int fish_value;

        public int accum_money;

        public int cur_stage;
    }


    /// <summary>
    /// 捕获聚宝盆
    /// </summary>
    public class SCTreasureFishCatched
    {
        public int chair_idx;
        public int ratio;
        public int fish_uid;
        public int fish_value;
        public int accum_money;
        public int multiple;
        public bool death;
        public long earn;
        public long user_score;
        public int cur_stage;
        public bool display_multiple;
    }


    public class SCSetProbability
    {
        public int code;
        public int chair_idx;
        public int gun_ratio;
        public int gun_level;
        public string msg;
    }

    public class CSHitFish
    {
        public int fish_uid;
        public int bullet_id;
        public List<int> screen_fishes;
    }

    public class CSSyncFishRsp
    {
        public List<FishArrayData> fish_array;
        public List<FishRoad> fish_road;
        public int move_delay;
        public int road_idx;
        public int move_t;

        public List<Fish_Traces> fish_traces;
        public int req_player_id;
        public bool finish;
    }

    public class Drop_Props
    {
        public int id;
        public int count;
        public int ratio;
        public int time;
        public int multiple;
    }

    public class Shock_Fishes
    {
        public int id;
        public int count;
        public int ratio;
        public int time;
        public int multiple;
    }

    public class WheelTwo
    {
        public int ratio;
        public List<int> wheels;
    }
}