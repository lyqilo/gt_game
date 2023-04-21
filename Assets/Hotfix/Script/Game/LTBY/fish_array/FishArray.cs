using System.Collections.Generic;

namespace Hotfix.LTBY
{
    public class FishArrayData
    {
        public float x;
        public float y;
        public int fishType;
    }

    public class FishArrayList
    {
        public string ArrayName;
        public List<int> RoadList;
        public List<FishArrayData> list;
    }

    public class FishArray
    {
        public static Dictionary<int,FishArrayList> YCArray=new Dictionary<int, FishArrayList>()
        {
            {
                1, new FishArrayList()
                {
                    RoadList = new List<int>(){205},
                    ArrayName = "AIXIN",
                    list = new List<FishArrayData>()
                    {//79
                        new FishArrayData() {y = 0, x = 0, fishType = 132},//闪电海鳗
                        new FishArrayData() {y = 2, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 3, x = 0, fishType = 108},
                        new FishArrayData() {y = -8, x = 0, fishType = 108},
                        new FishArrayData() {y = -6, x = 0, fishType = 108},
                        new FishArrayData() {y = -7, x = -1, fishType = 108},
                        new FishArrayData() {y = -6, x = -2, fishType = 108},
                        new FishArrayData() {y = -5, x = -3, fishType = 108},
                        new FishArrayData() {y = -4, x = -4, fishType = 108},
                        new FishArrayData() {y = -3, x = -5, fishType = 108},
                        new FishArrayData() {y = -2, x = -6, fishType = 108},
                        new FishArrayData() {y = -1, x = -7, fishType = 108},
                        new FishArrayData() {y = 0, x = -8, fishType = 108},
                        new FishArrayData() {y = 1, x = -9, fishType = 108},
                        new FishArrayData() {y = 1, x = -9, fishType = 108},
                        new FishArrayData() {y = 2, x = -9, fishType = 108},
                        new FishArrayData() {y = 4, x = -8, fishType = 108},
                        new FishArrayData() {y = 5, x = -7, fishType = 108},
                        new FishArrayData() {y = 6, x = -6, fishType = 108},
                        new FishArrayData() {y = 6, x = -5, fishType = 108},
                        new FishArrayData() {y = 6, x = -3.8f, fishType = 108},
                        new FishArrayData() {y = 6, x = -2.6f, fishType = 108},
                        new FishArrayData() {y = 7, x = -3.8f, fishType = 108},
                        new FishArrayData() {y = 7, x = -5, fishType = 108},
                        new FishArrayData() {y = 5, x = -3.2f, fishType = 108},
                        new FishArrayData() {y = 4, x = -1, fishType = 108},
                        new FishArrayData() {y = 4, x = -2.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 4, x = -6.6f, fishType = 108},
                        new FishArrayData() {y = 5, x = -6, fishType = 108},
                        new FishArrayData() {y = 5, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = 5, x = -1.7f, fishType = 108},
                        new FishArrayData() {y = -1, x = -5.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -4.75f, fishType = 108},
                        new FishArrayData() {y = 3, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -1.3f, fishType = 108},
                        new FishArrayData() {y = 3, x = -9, fishType = 108},
                        new FishArrayData() {y = 1, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -3.5f, fishType = 108},
                        new FishArrayData() {y = -4, x = -2.7f, fishType = 108},
                        new FishArrayData() {y = -5, x = -1.8f, fishType = 108},
                        new FishArrayData() {y = -7, x = 1, fishType = 108},
                        new FishArrayData() {y = -6, x = 2, fishType = 108},
                        new FishArrayData() {y = -5, x = 3, fishType = 108},
                        new FishArrayData() {y = -4, x = 4, fishType = 108},
                        new FishArrayData() {y = -3, x = 5, fishType = 108},
                        new FishArrayData() {y = -2, x = 6, fishType = 108},
                        new FishArrayData() {y = -1, x = 7, fishType = 108},
                        new FishArrayData() {y = 0, x = 8, fishType = 108},
                        new FishArrayData() {y = 1, x = 9, fishType = 108},
                        new FishArrayData() {y = 1, x = 9, fishType = 108},
                        new FishArrayData() {y = 2, x = 9, fishType = 108},
                        new FishArrayData() {y = 4, x = 8, fishType = 108},
                        new FishArrayData() {y = 5, x = 7, fishType = 108},
                        new FishArrayData() {y = 6, x = 6, fishType = 108},
                        new FishArrayData() {y = 6, x = 5, fishType = 108},
                        new FishArrayData() {y = 6, x = 3.8f, fishType = 108},
                        new FishArrayData() {y = 6, x = 2.6f, fishType = 108},
                        new FishArrayData() {y = 7, x = 3.8f, fishType = 108},
                        new FishArrayData() {y = 7, x = 5, fishType = 108},
                        new FishArrayData() {y = 5, x = 3.2f, fishType = 108},
                        new FishArrayData() {y = 4, x = 1, fishType = 108},
                        new FishArrayData() {y = 4, x = 2.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 4, x = 6.6f, fishType = 108},
                        new FishArrayData() {y = 5, x = 6, fishType = 108},
                        new FishArrayData() {y = 5, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = 5, x = 1.7f, fishType = 108},
                        new FishArrayData() {y = -1, x = 5.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = 4.75f, fishType = 108},
                        new FishArrayData() {y = 3, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = 1.35f, fishType = 108},
                        new FishArrayData() {y = 3, x = 9, fishType = 108},
                        new FishArrayData() {y = 1, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = 3.5f, fishType = 108},
                        new FishArrayData() {y = -4, x = 2.7f, fishType = 108},
                        new FishArrayData() {y = -5, x = 1.8f, fishType = 108}
                    }
                }
            },
            {
                2, new FishArrayList()
                {
                    RoadList = new List<int>(){206},
                    ArrayName = "AIXIN1",
                    list = new List<FishArrayData>()
                    {//79
                        new FishArrayData() {y = 0, x = 0, fishType = 109},//愤怒河豚
                        new FishArrayData() {y = -2, x = 0, fishType = 103},//比目鱼
                        new FishArrayData() {y = -3, x = 0, fishType = 103},
                        new FishArrayData() {y = 8, x = 0, fishType = 103},
                        new FishArrayData() {y = 6, x = 0, fishType = 103},
                        new FishArrayData() {y = 7, x = -1, fishType = 103},
                        new FishArrayData() {y = 6, x = -2, fishType = 103},
                        new FishArrayData() {y = 5, x = -3, fishType = 103},
                        new FishArrayData() {y = 4, x = -4, fishType = 103},
                        new FishArrayData() {y = 3, x = -5, fishType = 103},
                        new FishArrayData() {y = 2, x = -6, fishType = 103},
                        new FishArrayData() {y = 1, x = -7, fishType = 103},
                        new FishArrayData() {y = 0, x = -8, fishType = 103},
                        new FishArrayData() {y = -1, x = -9, fishType = 103},
                        new FishArrayData() {y = -1, x = -9, fishType = 103},
                        new FishArrayData() {y = -2, x = -9, fishType = 103},
                        new FishArrayData() {y = -4, x = -8, fishType = 103},
                        new FishArrayData() {y = -5, x = -7, fishType = 103},
                        new FishArrayData() {y = -6, x = -6, fishType = 103},
                        new FishArrayData() {y = -6, x = -5, fishType = 103},
                        new FishArrayData() {y = -6, x = -3.8f, fishType = 103},
                        new FishArrayData() {y = -6, x = -2.6f, fishType = 103},
                        new FishArrayData() {y = -7, x = -3.8f, fishType = 103},
                        new FishArrayData() {y = -7, x = -5, fishType = 103},
                        new FishArrayData() {y = -5, x = -3.2f, fishType = 103},
                        new FishArrayData() {y = -4, x = -1, fishType = 103},
                        new FishArrayData() {y = -4, x = -2.4f, fishType = 103},
                        new FishArrayData() {y = -2, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = -4, x = -6.6f, fishType = 103},
                        new FishArrayData() {y = -5, x = -6, fishType = 103},
                        new FishArrayData() {y = -5, x = -4.7f, fishType = 103},
                        new FishArrayData() {y = -5, x = -1.7f, fishType = 103},
                        new FishArrayData() {y = 1, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = 2, x = -4.75f, fishType = 103},
                        new FishArrayData() {y = -3, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = -3, x = -1.3f, fishType = 103},
                        new FishArrayData() {y = -3, x = -9, fishType = 103},
                        new FishArrayData() {y = -1, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = -6.5f, fishType = 103},
                        new FishArrayData() {y = 3, x = -3.5f, fishType = 103},
                        new FishArrayData() {y = 4, x = -2.7f, fishType = 103},
                        new FishArrayData() {y = 5, x = -1.8f, fishType = 103},
                        new FishArrayData() {y = 7, x = 1, fishType = 103},
                        new FishArrayData() {y = 6, x = 2, fishType = 103},
                        new FishArrayData() {y = 5, x = 3, fishType = 103},
                        new FishArrayData() {y = 4, x = 4, fishType = 103},
                        new FishArrayData() {y = 3, x = 5, fishType = 103},
                        new FishArrayData() {y = 2, x = 6, fishType = 103},
                        new FishArrayData() {y = 1, x = 7, fishType = 103},
                        new FishArrayData() {y = 0, x = 8, fishType = 103},
                        new FishArrayData() {y = -1, x = 9, fishType = 103},
                        new FishArrayData() {y = -1, x = 9, fishType = 103},
                        new FishArrayData() {y = -2, x = 9, fishType = 103},
                        new FishArrayData() {y = -4, x = 8, fishType = 103},
                        new FishArrayData() {y = -5, x = 7, fishType = 103},
                        new FishArrayData() {y = -6, x = 6, fishType = 103},
                        new FishArrayData() {y = -6, x = 5, fishType = 103},
                        new FishArrayData() {y = -6, x = 3.8f, fishType = 103},
                        new FishArrayData() {y = -6, x = 2.6f, fishType = 103},
                        new FishArrayData() {y = -7, x = 3.8f, fishType = 103},
                        new FishArrayData() {y = -7, x = 5, fishType = 103},
                        new FishArrayData() {y = -5, x = 3.2f, fishType = 103},
                        new FishArrayData() {y = -4, x = 1, fishType = 103},
                        new FishArrayData() {y = -4, x = 2.4f, fishType = 103},
                        new FishArrayData() {y = -2, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = -4, x = 6.6f, fishType = 103},
                        new FishArrayData() {y = -5, x = 6, fishType = 103},
                        new FishArrayData() {y = -5, x = 4.7f, fishType = 103},
                        new FishArrayData() {y = -5, x = 1.7f, fishType = 103},
                        new FishArrayData() {y = 1, x = 5.5f, fishType = 103},
                        new FishArrayData() {y = 2, x = 4.75f, fishType = 103},
                        new FishArrayData() {y = -3, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = -3, x = 1.35f, fishType = 103},
                        new FishArrayData() {y = -3, x = 9, fishType = 103},
                        new FishArrayData() {y = -1, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = 6.5f, fishType = 103},
                        new FishArrayData() {y = 3, x = 3.5f, fishType = 103},
                        new FishArrayData() {y = 4, x = 2.7f, fishType = 103},
                        new FishArrayData() {y = 5, x = 1.8f, fishType = 103}
                    }
                }
            },
            {
                3, new FishArrayList()
                {
                    RoadList = new List<int>(){207},
                    ArrayName = "HUDIE", list = new List<FishArrayData>()
                    {//75
                        new FishArrayData() {y = 0, x = 0, fishType = 140},//闪电蜻蜓
                        new FishArrayData() {y = 1, x = -1, fishType = 102},//蜻蜓鱼
                        new FishArrayData() {y = 1.7f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = 2.4f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 3.3f, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = 4.2f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 4.9f, x = -1.5f, fishType = 102},
                        new FishArrayData() {y = 5.5f, x = -0.9f, fishType = 102},
                        new FishArrayData() {y = 1, x = 1, fishType = 102},
                        new FishArrayData() {y = 1.7f, x = 1.55f, fishType = 102},
                        new FishArrayData() {y = 2.4f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = 3.3f, x = 2.45f, fishType = 102},
                        new FishArrayData() {y = 4.2f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = 4.9f, x = 1.5f, fishType = 102},
                        new FishArrayData() {y = 5.5f, x = 0.9f, fishType = 102},
                        new FishArrayData() {y = 5.9f, x = 0, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = -1.7f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = -2.4f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -3.3f, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = -4.2f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -4.9f, x = -1.5f, fishType = 102},
                        new FishArrayData() {y = -5.5f, x = -0.9f, fishType = 102},
                        new FishArrayData() {y = -1, x = 1, fishType = 102},
                        new FishArrayData() {y = -1.7f, x = 1.55f, fishType = 102},
                        new FishArrayData() {y = -2.4f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = -3.3f, x = 2.45f, fishType = 102},
                        new FishArrayData() {y = -4.2f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = -4.9f, x = 1.5f, fishType = 102},
                        new FishArrayData() {y = -5.5f, x = 0.9f, fishType = 102},
                        new FishArrayData() {y = -5.9f, x = 0, fishType = 102},
                        new FishArrayData() {y = 0.55f, x = 2.2f, fishType = 102},
                        new FishArrayData() {y = -0.55f, x = 2.2f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 101},//蝴蝶鱼
                        new FishArrayData() {y = 0, x = -3.5f, fishType = 139},//闪电蝴蝶
                        new FishArrayData() {y = 0, x = -5, fishType = 101},
                        new FishArrayData() {y = 1, x = -3, fishType = 101},
                        new FishArrayData() {y = 2, x = -4, fishType = 101},
                        new FishArrayData() {y = 3, x = -5, fishType = 101},
                        new FishArrayData() {y = 4, x = -6, fishType = 101},
                        new FishArrayData() {y = 5, x = -7, fishType = 101},
                        new FishArrayData() {y = 0.6f, x = -5.7f, fishType = 101},
                        new FishArrayData() {y = 1.2f, x = -6.6f, fishType = 101},
                        new FishArrayData() {y = 2, x = -7.5f, fishType = 101},
                        new FishArrayData() {y = 2.8f, x = -8.5f, fishType = 101},
                        new FishArrayData() {y = 3.65f, x = -9.25f, fishType = 101},
                        new FishArrayData() {y = 4.4f, x = -10.1f, fishType = 101},
                        new FishArrayData() {y = 5.2f, x = -9.2f, fishType = 101},
                        new FishArrayData() {y = 5.6f, x = -8.2f, fishType = 101},
                        new FishArrayData() {y = -1, x = -3, fishType = 101},
                        new FishArrayData() {y = -2, x = -4, fishType = 101},
                        new FishArrayData() {y = -3, x = -5, fishType = 101},
                        new FishArrayData() {y = -4, x = -6, fishType = 101},
                        new FishArrayData() {y = -5, x = -7, fishType = 101},
                        new FishArrayData() {y = -0.8f, x = -6, fishType = 101},
                        new FishArrayData() {y = -1.6f, x = -7, fishType = 101},
                        new FishArrayData() {y = -2.4f, x = -8, fishType = 101},
                        new FishArrayData() {y = -3.2f, x = -9, fishType = 101},
                        new FishArrayData() {y = -4, x = -10, fishType = 101},
                        new FishArrayData() {y = -4.9f, x = -10.1f, fishType = 101},
                        new FishArrayData() {y = -5.4f, x = -9.2f, fishType = 101},
                        new FishArrayData() {y = -5.6f, x = -8.2f, fishType = 101},
                        new FishArrayData() {y = 1, x = -9, fishType = 104},//热带黄鱼
                        new FishArrayData() {y = -1, x = -9, fishType = 104},
                        new FishArrayData() {y = 1, x = -11, fishType = 104},
                        new FishArrayData() {y = -1, x = -11, fishType = 104},
                        new FishArrayData() {y = 1, x = -13, fishType = 104},
                        new FishArrayData() {y = -1, x = -13, fishType = 104},
                        new FishArrayData() {y = 1, x = -15, fishType = 104},
                        new FishArrayData() {y = -1, x = -15, fishType = 104},
                        new FishArrayData() {y = 1, x = -17, fishType = 104},
                        new FishArrayData() {y = -1, x = -17, fishType = 104},
                        new FishArrayData() {y = 1, x = -19, fishType = 104},
                        new FishArrayData() {y = -1, x = -19, fishType = 104},
                        new FishArrayData() {y = 0, x = -21, fishType = 104}
                    }
                }
            },
            {
                4, new FishArrayList()
                {
                    RoadList = new List<int>(){208},
                    ArrayName = "HUDIE1", list = new List<FishArrayData>()
                    {//71
                        new FishArrayData() {y = 0, x = 0, fishType = 124},//大金鲨
                        new FishArrayData() {y = 1.1f, x = -0.1f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = 2, x = -0.25f, fishType = 105},
                        new FishArrayData() {y = 3, x = -0.3f, fishType = 105},
                        new FishArrayData() {y = 4, x = -0.45f, fishType = 105},
                        new FishArrayData() {y = 5, x = -0.55f, fishType = 105},
                        new FishArrayData() {y = 6, x = -0.6f, fishType = 105},
                        new FishArrayData() {y = 6.75f, x = 0.6f, fishType = 105},
                        new FishArrayData() {y = 7.2f, x = 1.8f, fishType = 105},
                        new FishArrayData() {y = 7.6f, x = 3.2f, fishType = 105},
                        new FishArrayData() {y = 5.13f, x = 3.69f, fishType = 105},
                        new FishArrayData() {y = 4.19f, x = 3.33f, fishType = 105},
                        new FishArrayData() {y = 3.42f, x = 2.73f, fishType = 105},
                        new FishArrayData() {y = 2.47f, x = 2.18f, fishType = 105},
                        new FishArrayData() {y = 1.64f, x = 1.79f, fishType = 105},
                        new FishArrayData() {y = 5.98f, x = 4.17f, fishType = 105},
                        new FishArrayData() {y = 0.95f, x = -2, fishType = 103},//比目鱼
                        new FishArrayData() {y = 1.85f, x = -2, fishType = 103},
                        new FishArrayData() {y = 2.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = 3.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = 4.75f, x = -2, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = -2.1f, fishType = 103},
                        new FishArrayData() {y = 5.9f, x = -3.15f, fishType = 103},
                        new FishArrayData() {y = 5.95f, x = -4.45f, fishType = 103},
                        new FishArrayData() {y = 5.1f, x = -6.55f, fishType = 103},
                        new FishArrayData() {y = 5.7f, x = -5.8f, fishType = 103},
                        new FishArrayData() {y = 1.1f, x = -6.25f, fishType = 103},
                        new FishArrayData() {y = 0.75f, x = -5.25f, fishType = 103},
                        new FishArrayData() {y = 0.5f, x = -4.25f, fishType = 103},
                        new FishArrayData() {y = 0.6f, x = -2.95f, fishType = 103},
                        new FishArrayData() {y = 7, x = 4.54f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = 7.84f, x = 4.53f, fishType = 105},
                        new FishArrayData() {y = 4.35f, x = -7.21f, fishType = 103},//比目鱼
                        new FishArrayData() {y = 2.73f, x = -7.31f, fishType = 103},
                        new FishArrayData() {y = 3.53f, x = -7.6f, fishType = 103},
                        new FishArrayData() {y = 1.86f, x = -6.82f, fishType = 103},
                        new FishArrayData() {y = -1.1f, x = -0.1f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = -2, x = -0.25f, fishType = 105},
                        new FishArrayData() {y = -3, x = -0.3f, fishType = 105},
                        new FishArrayData() {y = -4, x = -0.45f, fishType = 105},
                        new FishArrayData() {y = -5, x = -0.55f, fishType = 105},
                        new FishArrayData() {y = -6, x = -0.6f, fishType = 105},
                        new FishArrayData() {y = -6.75f, x = 0.6f, fishType = 105},
                        new FishArrayData() {y = -7.2f, x = 1.8f, fishType = 105},
                        new FishArrayData() {y = -7.6f, x = 3.2f, fishType = 105},
                        new FishArrayData() {y = -5.13f, x = 3.69f, fishType = 105},
                        new FishArrayData() {y = -4.19f, x = 3.33f, fishType = 105},
                        new FishArrayData() {y = -3.42f, x = 2.73f, fishType = 105},
                        new FishArrayData() {y = -2.47f, x = 2.18f, fishType = 105},
                        new FishArrayData() {y = -1.64f, x = 1.79f, fishType = 105},
                        new FishArrayData() {y = -5.98f, x = 4.17f, fishType = 105},
                        new FishArrayData() {y = -0.95f, x = -2, fishType = 103},//比目鱼
                        new FishArrayData() {y = -1.85f, x = -2, fishType = 103},
                        new FishArrayData() {y = -2.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = -3.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = -4.75f, x = -2, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = -2.1f, fishType = 103},
                        new FishArrayData() {y = -5.9f, x = -3.15f, fishType = 103},
                        new FishArrayData() {y = -5.95f, x = -4.45f, fishType = 103},
                        new FishArrayData() {y = -5.1f, x = -6.55f, fishType = 103},
                        new FishArrayData() {y = -5.7f, x = -5.8f, fishType = 103},
                        new FishArrayData() {y = -1.2f, x = -6.3f, fishType = 103},
                        new FishArrayData() {y = -0.65f, x = -5.4f, fishType = 103},
                        new FishArrayData() {y = -0.5f, x = -4.25f, fishType = 103},
                        new FishArrayData() {y = -0.6f, x = -2.95f, fishType = 103},
                        new FishArrayData() {y = -7, x = 4.54f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = -7.84f, x = 4.53f, fishType = 105},
                        new FishArrayData() {y = -4.35f, x = -7.21f, fishType = 103},//比目鱼
                        new FishArrayData() {y = -2.73f, x = -7.31f, fishType = 103},
                        new FishArrayData() {y = -3.53f, x = -7.6f, fishType = 103},
                        new FishArrayData() {y = -1.86f, x = -6.82f, fishType = 103}
                    }
                }
            },
            {
                5, new FishArrayList()
                {//112
                    RoadList = new List<int>(){213},
                    ArrayName = "WENZI", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 3, x = 10, fishType = 129},//美人鱼
                        new FishArrayData() {y = -3, x = 10, fishType = 129},
                        new FishArrayData() {y = 1, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 2, x = 0, fishType = 108},
                        new FishArrayData() {y = 3, x = 0, fishType = 108},
                        new FishArrayData() {y = -1, x = 0, fishType = 108},
                        new FishArrayData() {y = -2, x = 0, fishType = 108},
                        new FishArrayData() {y = -3, x = 0, fishType = 108},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -3, fishType = 108},
                        new FishArrayData() {y = 1, x = -3, fishType = 108},
                        new FishArrayData() {y = 2, x = -3, fishType = 108},
                        new FishArrayData() {y = 3, x = -3, fishType = 108},
                        new FishArrayData() {y = -1, x = -3, fishType = 108},
                        new FishArrayData() {y = -2, x = -3, fishType = 108},
                        new FishArrayData() {y = -3, x = -3, fishType = 108},
                        new FishArrayData() {y = 0, x = -5.9f, fishType = 108},
                        new FishArrayData() {y = 1, x = -6.2f, fishType = 108},
                        new FishArrayData() {y = 2, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -6.8f, fishType = 108},
                        new FishArrayData() {y = -1, x = -5.6f, fishType = 108},
                        new FishArrayData() {y = -2, x = -5.3f, fishType = 108},
                        new FishArrayData() {y = -3, x = -5, fishType = 108},
                        new FishArrayData() {y = 0, x = -7.7f, fishType = 108},
                        new FishArrayData() {y = 1, x = -7.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = -7.1f, fishType = 108},
                        new FishArrayData() {y = -1, x = -8, fishType = 108},
                        new FishArrayData() {y = -2, x = -8.3f, fishType = 108},
                        new FishArrayData() {y = -3, x = -8.6f, fishType = 108},
                        new FishArrayData() {y = 0, x = -6.8f, fishType = 108},
                        new FishArrayData() {y = 0, x = -12, fishType = 108},
                        new FishArrayData() {y = 1, x = -12, fishType = 108},
                        new FishArrayData() {y = 2, x = -12, fishType = 108},
                        new FishArrayData() {y = 3, x = -12, fishType = 108},
                        new FishArrayData() {y = -1, x = -12, fishType = 108},
                        new FishArrayData() {y = -2, x = -12, fishType = 108},
                        new FishArrayData() {y = -3, x = -12, fishType = 108},
                        new FishArrayData() {y = 0, x = -11, fishType = 108},
                        new FishArrayData() {y = 2.5f, x = -10, fishType = 108},
                        new FishArrayData() {y = 1.5f, x = -9.6f, fishType = 108},
                        new FishArrayData() {y = 0.5f, x = -10, fishType = 108},
                        new FishArrayData() {y = 3, x = -11, fishType = 108},
                        new FishArrayData() {y = 0, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 1, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 2, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -1, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -15.5f, fishType = 108},
                        new FishArrayData() {y = 2.5f, x = -14.5f, fishType = 108},
                        new FishArrayData() {y = 1.5f, x = -14.1f, fishType = 108},
                        new FishArrayData() {y = 0.5f, x = -14.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -15.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -1, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = 1, x = -19.9f, fishType = 108},
                        new FishArrayData() {y = 2, x = -19.3f, fishType = 108},
                        new FishArrayData() {y = 3, x = -18.7f, fishType = 108},
                        new FishArrayData() {y = 1, x = -21.1f, fishType = 108},
                        new FishArrayData() {y = 2, x = -21.7f, fishType = 108},
                        new FishArrayData() {y = 3, x = -22.3f, fishType = 108},
                        new FishArrayData() {y = 7, x = 10, fishType = 112},//乌龟
                        new FishArrayData() {y = 7, x = 6, fishType = 112},
                        new FishArrayData() {y = 7, x = 2, fishType = 112},
                        new FishArrayData() {y = 7, x = -2, fishType = 112},
                        new FishArrayData() {y = 7, x = -6, fishType = 112},
                        new FishArrayData() {y = 7, x = -10, fishType = 112},
                        new FishArrayData() {y = 7, x = -14, fishType = 112},
                        new FishArrayData() {y = 7, x = -18, fishType = 112},
                        new FishArrayData() {y = 7, x = -22, fishType = 112},
                        new FishArrayData() {y = -7, x = 10, fishType = 112},
                        new FishArrayData() {y = -7, x = 6, fishType = 112},
                        new FishArrayData() {y = -7, x = 2, fishType = 112},
                        new FishArrayData() {y = -7, x = -2, fishType = 112},
                        new FishArrayData() {y = -7, x = -6, fishType = 112},
                        new FishArrayData() {y = -7, x = -10, fishType = 112},
                        new FishArrayData() {y = -7, x = -14, fishType = 112},
                        new FishArrayData() {y = -7, x = -18, fishType = 112},
                        new FishArrayData() {y = -7, x = -22, fishType = 112},
                        new FishArrayData() {y = -7, x = -26, fishType = 112},
                        new FishArrayData() {y = -7, x = -30, fishType = 112},
                        new FishArrayData() {y = -7, x = -34, fishType = 112},
                        new FishArrayData() {y = -7, x = -38, fishType = 112},
                        new FishArrayData() {y = 7, x = -26, fishType = 112},
                        new FishArrayData() {y = 7, x = -30, fishType = 112},
                        new FishArrayData() {y = 7, x = -34, fishType = 112},
                        new FishArrayData() {y = 7, x = -38, fishType = 112},
                        new FishArrayData() {y = 4, x = -32, fishType = 103},//比目鱼
                        new FishArrayData() {y = 4, x = -39, fishType = 103},
                        new FishArrayData() {y = 6, x = -38, fishType = 103},
                        new FishArrayData() {y = -4, x = -30, fishType = 103},
                        new FishArrayData() {y = -5, x = -32, fishType = 103},
                        new FishArrayData() {y = 5, x = -34, fishType = 103},
                        new FishArrayData() {y = 4, x = -25, fishType = 103},
                        new FishArrayData() {y = 0, x = -40, fishType = 103},
                        new FishArrayData() {y = -2, x = -38, fishType = 103},
                        new FishArrayData() {y = -3, x = -28, fishType = 103},
                        new FishArrayData() {y = 2, x = -24, fishType = 103},
                        new FishArrayData() {y = -2, x = -26, fishType = 103},
                        new FishArrayData() {y = 6, x = -36, fishType = 103},
                        new FishArrayData() {y = -3, x = -36, fishType = 103},
                        new FishArrayData() {y = 2, x = -40, fishType = 103},
                        new FishArrayData() {y = 6, x = -26, fishType = 103},
                        new FishArrayData() {y = 0, x = -24, fishType = 103},
                        new FishArrayData() {y = 5, x = -30, fishType = 103},
                        new FishArrayData() {y = -4, x = -34, fishType = 103},
                        new FishArrayData() {y = 5.99f, x = -27.85f, fishType = 103}
                    }
                }
            },
            {
                6, new FishArrayList()
                {
                    RoadList = new List<int>()
                    {
                        214,215
                    },
                    ArrayName = "WUJIAOXING", list = new List<FishArrayData>()
                    {//35
                        new FishArrayData() {y = 0, x = 0, fishType = 106},//狮头鱼
                        new FishArrayData() {y = 0, x = -12.7f, fishType = 106},
                        new FishArrayData() {y = 0, x = -10.5f, fishType = 106},
                        new FishArrayData() {y = 0, x = -8.3f, fishType = 106},
                        new FishArrayData() {y = 0, x = -6.35f, fishType = 106},
                        new FishArrayData() {y = 0, x = -4.15f, fishType = 106},
                        new FishArrayData() {y = 0, x = -2.15f, fishType = 106},
                        new FishArrayData() {y = 1.84f, x = -11.72f, fishType = 106},
                        new FishArrayData() {y = 4.95f, x = -9.72f, fishType = 106},
                        new FishArrayData() {y = 6.46f, x = -8.85f, fishType = 106},
                        new FishArrayData() {y = 9.42f, x = -7.29f, fishType = 106},
                        new FishArrayData() {y = 11.04f, x = -6, fishType = 106},
                        new FishArrayData() {y = 9.41f, x = -4.64f, fishType = 106},
                        new FishArrayData() {y = 6.39f, x = -3.29f, fishType = 106},
                        new FishArrayData() {y = 4.75f, x = -2.46f, fishType = 106},
                        new FishArrayData() {y = 1.84f, x = -0.61f, fishType = 106},
                        new FishArrayData() {y = 7.88f, x = -12.83f, fishType = 107},//七彩鱼
                        new FishArrayData() {y = 8, x = -10.41f, fishType = 107},
                        new FishArrayData() {y = 8, x = -8.09f, fishType = 107},
                        new FishArrayData() {y = 8, x = -5.93f, fishType = 107},
                        new FishArrayData() {y = 8, x = -3.21f, fishType = 107},
                        new FishArrayData() {y = 8, x = -1.09f, fishType = 107},
                        new FishArrayData() {y = 8, x = 1.22f, fishType = 107},
                        new FishArrayData() {y = 6.11f, x = -12.26f, fishType = 107},
                        new FishArrayData() {y = 4.52f, x = -11.14f, fishType = 107},
                        new FishArrayData() {y = 2.85f, x = -9.97f, fishType = 107},
                        new FishArrayData() {y = 1.2f, x = -9.03f, fishType = 107},
                        new FishArrayData() {y = -1.45f, x = -7.43f, fishType = 107},
                        new FishArrayData() {y = -3.33f, x = -5.78f, fishType = 107},
                        new FishArrayData() {y = -1.43f, x = -4.33f, fishType = 107},
                        new FishArrayData() {y = 1.34f, x = -2.95f, fishType = 107},
                        new FishArrayData() {y = 3, x = -1.95f, fishType = 107},
                        new FishArrayData() {y = 4.52f, x = -0.85f, fishType = 107},
                        new FishArrayData() {y = 6.17f, x = 0.41f, fishType = 107},
                        new FishArrayData() {y = 4, x = -6, fishType = 109}//愤怒河豚
                    }
                }
            },
            {
                7, new FishArrayList()
                {
                    RoadList = new List<int>()
                    {
                        216,217
                    },
                    ArrayName = "WUXING", list = new List<FishArrayData>()
                    {//107
                        new FishArrayData() {y = 0, x = 0, fishType = 102},//蜻蜓鱼
                        new FishArrayData() {y = 1.3f, x = -0.04f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -0.26f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -0.84f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -1.06f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -0.2f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -0.45f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -0.75f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -1.1f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -1.3f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -1.7f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -2.9f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -1.3f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -1.7f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -2.9f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -2.74f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -3.14f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -3.45f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -4.03f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -4.25f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -3, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -3.35f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -3.8f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -4.25f, fishType = 102},
                        new FishArrayData() {y = 0, x = -20.35f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -20.05f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -19.74f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -19.25f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -18.85f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -18.63f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -20.05f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -19.74f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -19.25f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -18.85f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -18.54f, fishType = 102},
                        new FishArrayData() {y = 0, x = -19, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -18.7f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -18.3f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -17.9f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -17.5f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -17.1f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -18.7f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -18.3f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -17.9f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -17.5f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -17.1f, fishType = 102},
                        new FishArrayData() {y = 0, x = -17.65f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -17.26f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -16.95f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -16.55f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -16.32f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -15.75f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -17.35f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -16.95f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -16.55f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -16.24f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -15.75f, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 0, x = -7, fishType = 108},
                        new FishArrayData() {y = 0, x = -15, fishType = 108},
                        new FishArrayData() {y = 0, x = -13, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -14, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -12, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -6, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -8, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -13, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -7, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -9, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -11, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -14, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -12, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -6, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -8, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -10, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -13, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -9, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -11, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -7, fishType = 108},
                        new FishArrayData() {y = 6, x = -10, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -14, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -12, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -6, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -8, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -13, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -7, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -9, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -11, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -14, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -12, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -6, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -8, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -10, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -13, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -9, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -11, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -7, fishType = 108},
                        new FishArrayData() {y = -6, x = -10, fishType = 108},
                        new FishArrayData() {y = 0, x = -10, fishType = 140}//闪电蜻蜓
                    }
                }
            },
            {
                8, new FishArrayList()
                {
                    RoadList = new List<int>()
                    {
                        222,223
                    },
                    ArrayName = "YUANXING", list = new List<FishArrayData>()
                    {//44
                        new FishArrayData() {y = 0, x = 0, fishType = 129},//美人鱼
                        new FishArrayData() {y = 2.5f, x = 7.6f, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 4.7f, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = 6.5f, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = 7.6f, x = 2.5f, fishType = 108},
                        new FishArrayData() {y = 8, x = 0, fishType = 108},
                        new FishArrayData() {y = 7.6f, x = -2.5f, fishType = 108},
                        new FishArrayData() {y = 6.5f, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = 4.7f, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = 2.8f, x = -7.95f, fishType = 108},
                        new FishArrayData() {y = -3.05f, x = -7.6f, fishType = 108},
                        new FishArrayData() {y = -4.7f, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = -6.5f, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = -7.6f, x = -2.5f, fishType = 108},
                        new FishArrayData() {y = -8, x = 0, fishType = 108},
                        new FishArrayData() {y = -7.6f, x = 2.5f, fishType = 108},
                        new FishArrayData() {y = -6.5f, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = -4.7f, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = -2.5f, x = 7.6f, fishType = 108},
                        new FishArrayData() {y = 2.3f, x = 5.5f, fishType = 103},//比目鱼
                        new FishArrayData() {y = 4.2f, x = 4.2f, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = 2.3f, fishType = 103},
                        new FishArrayData() {y = 6, x = 0, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = -2.3f, fishType = 103},
                        new FishArrayData() {y = 4.2f, x = -4.2f, fishType = 103},
                        new FishArrayData() {y = 2.85f, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = -2.85f, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = -4.2f, x = -4.3f, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = -2.3f, fishType = 103},
                        new FishArrayData() {y = -6, x = 0, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = 2.3f, fishType = 103},
                        new FishArrayData() {y = -4.3f, x = 4, fishType = 103},
                        new FishArrayData() {y = -2.3f, x = 5.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = 6, fishType = 103},
                        new FishArrayData() {y = 2, x = 3.5f, fishType = 121},//金炸弹鱼
                        new FishArrayData() {y = 3.5f, x = 2, fishType = 121},
                        new FishArrayData() {y = 4, x = 0, fishType = 121},
                        new FishArrayData() {y = 3.5f, x = -2, fishType = 121},
                        new FishArrayData() {y = 2, x = -3.5f, fishType = 121},
                        new FishArrayData() {y = -2, x = -3.5f, fishType = 121},
                        new FishArrayData() {y = -3.5f, x = -2, fishType = 121},
                        new FishArrayData() {y = -4, x = 0, fishType = 121},
                        new FishArrayData() {y = -3.5f, x = 2, fishType = 121},
                        new FishArrayData() {y = -2, x = 3.5f, fishType = 121}
                    }
                }
            },
        };
        public static Dictionary<int, FishArrayList> Array = new Dictionary<int, FishArrayList>()
        {
            {
                1, new FishArrayList()
                {
                    ArrayName = "AIXIN",
                    list = new List<FishArrayData>()
                    {//79
                        new FishArrayData() {y = 0, x = 0, fishType = 132},//闪电海鳗
                        new FishArrayData() {y = 2, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 3, x = 0, fishType = 108},
                        new FishArrayData() {y = -8, x = 0, fishType = 108},
                        new FishArrayData() {y = -6, x = 0, fishType = 108},
                        new FishArrayData() {y = -7, x = -1, fishType = 108},
                        new FishArrayData() {y = -6, x = -2, fishType = 108},
                        new FishArrayData() {y = -5, x = -3, fishType = 108},
                        new FishArrayData() {y = -4, x = -4, fishType = 108},
                        new FishArrayData() {y = -3, x = -5, fishType = 108},
                        new FishArrayData() {y = -2, x = -6, fishType = 108},
                        new FishArrayData() {y = -1, x = -7, fishType = 108},
                        new FishArrayData() {y = 0, x = -8, fishType = 108},
                        new FishArrayData() {y = 1, x = -9, fishType = 108},
                        new FishArrayData() {y = 1, x = -9, fishType = 108},
                        new FishArrayData() {y = 2, x = -9, fishType = 108},
                        new FishArrayData() {y = 4, x = -8, fishType = 108},
                        new FishArrayData() {y = 5, x = -7, fishType = 108},
                        new FishArrayData() {y = 6, x = -6, fishType = 108},
                        new FishArrayData() {y = 6, x = -5, fishType = 108},
                        new FishArrayData() {y = 6, x = -3.8f, fishType = 108},
                        new FishArrayData() {y = 6, x = -2.6f, fishType = 108},
                        new FishArrayData() {y = 7, x = -3.8f, fishType = 108},
                        new FishArrayData() {y = 7, x = -5, fishType = 108},
                        new FishArrayData() {y = 5, x = -3.2f, fishType = 108},
                        new FishArrayData() {y = 4, x = -1, fishType = 108},
                        new FishArrayData() {y = 4, x = -2.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 4, x = -6.6f, fishType = 108},
                        new FishArrayData() {y = 5, x = -6, fishType = 108},
                        new FishArrayData() {y = 5, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = 5, x = -1.7f, fishType = 108},
                        new FishArrayData() {y = -1, x = -5.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -4.75f, fishType = 108},
                        new FishArrayData() {y = 3, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -1.3f, fishType = 108},
                        new FishArrayData() {y = 3, x = -9, fishType = 108},
                        new FishArrayData() {y = 1, x = -7.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -3.5f, fishType = 108},
                        new FishArrayData() {y = -4, x = -2.7f, fishType = 108},
                        new FishArrayData() {y = -5, x = -1.8f, fishType = 108},
                        new FishArrayData() {y = -7, x = 1, fishType = 108},
                        new FishArrayData() {y = -6, x = 2, fishType = 108},
                        new FishArrayData() {y = -5, x = 3, fishType = 108},
                        new FishArrayData() {y = -4, x = 4, fishType = 108},
                        new FishArrayData() {y = -3, x = 5, fishType = 108},
                        new FishArrayData() {y = -2, x = 6, fishType = 108},
                        new FishArrayData() {y = -1, x = 7, fishType = 108},
                        new FishArrayData() {y = 0, x = 8, fishType = 108},
                        new FishArrayData() {y = 1, x = 9, fishType = 108},
                        new FishArrayData() {y = 1, x = 9, fishType = 108},
                        new FishArrayData() {y = 2, x = 9, fishType = 108},
                        new FishArrayData() {y = 4, x = 8, fishType = 108},
                        new FishArrayData() {y = 5, x = 7, fishType = 108},
                        new FishArrayData() {y = 6, x = 6, fishType = 108},
                        new FishArrayData() {y = 6, x = 5, fishType = 108},
                        new FishArrayData() {y = 6, x = 3.8f, fishType = 108},
                        new FishArrayData() {y = 6, x = 2.6f, fishType = 108},
                        new FishArrayData() {y = 7, x = 3.8f, fishType = 108},
                        new FishArrayData() {y = 7, x = 5, fishType = 108},
                        new FishArrayData() {y = 5, x = 3.2f, fishType = 108},
                        new FishArrayData() {y = 4, x = 1, fishType = 108},
                        new FishArrayData() {y = 4, x = 2.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 4, x = 6.6f, fishType = 108},
                        new FishArrayData() {y = 5, x = 6, fishType = 108},
                        new FishArrayData() {y = 5, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = 5, x = 1.7f, fishType = 108},
                        new FishArrayData() {y = -1, x = 5.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = 4.75f, fishType = 108},
                        new FishArrayData() {y = 3, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = 1.35f, fishType = 108},
                        new FishArrayData() {y = 3, x = 9, fishType = 108},
                        new FishArrayData() {y = 1, x = 7.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = 3.5f, fishType = 108},
                        new FishArrayData() {y = -4, x = 2.7f, fishType = 108},
                        new FishArrayData() {y = -5, x = 1.8f, fishType = 108}
                    }
                }
            },
            {
                2, new FishArrayList()
                {
                    ArrayName = "AIXIN1",
                    list = new List<FishArrayData>()
                    {//79
                        new FishArrayData() {y = 0, x = 0, fishType = 109},//愤怒河豚
                        new FishArrayData() {y = -2, x = 0, fishType = 103},//比目鱼
                        new FishArrayData() {y = -3, x = 0, fishType = 103},
                        new FishArrayData() {y = 8, x = 0, fishType = 103},
                        new FishArrayData() {y = 6, x = 0, fishType = 103},
                        new FishArrayData() {y = 7, x = -1, fishType = 103},
                        new FishArrayData() {y = 6, x = -2, fishType = 103},
                        new FishArrayData() {y = 5, x = -3, fishType = 103},
                        new FishArrayData() {y = 4, x = -4, fishType = 103},
                        new FishArrayData() {y = 3, x = -5, fishType = 103},
                        new FishArrayData() {y = 2, x = -6, fishType = 103},
                        new FishArrayData() {y = 1, x = -7, fishType = 103},
                        new FishArrayData() {y = 0, x = -8, fishType = 103},
                        new FishArrayData() {y = -1, x = -9, fishType = 103},
                        new FishArrayData() {y = -1, x = -9, fishType = 103},
                        new FishArrayData() {y = -2, x = -9, fishType = 103},
                        new FishArrayData() {y = -4, x = -8, fishType = 103},
                        new FishArrayData() {y = -5, x = -7, fishType = 103},
                        new FishArrayData() {y = -6, x = -6, fishType = 103},
                        new FishArrayData() {y = -6, x = -5, fishType = 103},
                        new FishArrayData() {y = -6, x = -3.8f, fishType = 103},
                        new FishArrayData() {y = -6, x = -2.6f, fishType = 103},
                        new FishArrayData() {y = -7, x = -3.8f, fishType = 103},
                        new FishArrayData() {y = -7, x = -5, fishType = 103},
                        new FishArrayData() {y = -5, x = -3.2f, fishType = 103},
                        new FishArrayData() {y = -4, x = -1, fishType = 103},
                        new FishArrayData() {y = -4, x = -2.4f, fishType = 103},
                        new FishArrayData() {y = -2, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = -4, x = -6.6f, fishType = 103},
                        new FishArrayData() {y = -5, x = -6, fishType = 103},
                        new FishArrayData() {y = -5, x = -4.7f, fishType = 103},
                        new FishArrayData() {y = -5, x = -1.7f, fishType = 103},
                        new FishArrayData() {y = 1, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = 2, x = -4.75f, fishType = 103},
                        new FishArrayData() {y = -3, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = -3, x = -1.3f, fishType = 103},
                        new FishArrayData() {y = -3, x = -9, fishType = 103},
                        new FishArrayData() {y = -1, x = -7.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = -6.5f, fishType = 103},
                        new FishArrayData() {y = 3, x = -3.5f, fishType = 103},
                        new FishArrayData() {y = 4, x = -2.7f, fishType = 103},
                        new FishArrayData() {y = 5, x = -1.8f, fishType = 103},
                        new FishArrayData() {y = 7, x = 1, fishType = 103},
                        new FishArrayData() {y = 6, x = 2, fishType = 103},
                        new FishArrayData() {y = 5, x = 3, fishType = 103},
                        new FishArrayData() {y = 4, x = 4, fishType = 103},
                        new FishArrayData() {y = 3, x = 5, fishType = 103},
                        new FishArrayData() {y = 2, x = 6, fishType = 103},
                        new FishArrayData() {y = 1, x = 7, fishType = 103},
                        new FishArrayData() {y = 0, x = 8, fishType = 103},
                        new FishArrayData() {y = -1, x = 9, fishType = 103},
                        new FishArrayData() {y = -1, x = 9, fishType = 103},
                        new FishArrayData() {y = -2, x = 9, fishType = 103},
                        new FishArrayData() {y = -4, x = 8, fishType = 103},
                        new FishArrayData() {y = -5, x = 7, fishType = 103},
                        new FishArrayData() {y = -6, x = 6, fishType = 103},
                        new FishArrayData() {y = -6, x = 5, fishType = 103},
                        new FishArrayData() {y = -6, x = 3.8f, fishType = 103},
                        new FishArrayData() {y = -6, x = 2.6f, fishType = 103},
                        new FishArrayData() {y = -7, x = 3.8f, fishType = 103},
                        new FishArrayData() {y = -7, x = 5, fishType = 103},
                        new FishArrayData() {y = -5, x = 3.2f, fishType = 103},
                        new FishArrayData() {y = -4, x = 1, fishType = 103},
                        new FishArrayData() {y = -4, x = 2.4f, fishType = 103},
                        new FishArrayData() {y = -2, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = -4, x = 6.6f, fishType = 103},
                        new FishArrayData() {y = -5, x = 6, fishType = 103},
                        new FishArrayData() {y = -5, x = 4.7f, fishType = 103},
                        new FishArrayData() {y = -5, x = 1.7f, fishType = 103},
                        new FishArrayData() {y = 1, x = 5.5f, fishType = 103},
                        new FishArrayData() {y = 2, x = 4.75f, fishType = 103},
                        new FishArrayData() {y = -3, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = -3, x = 1.35f, fishType = 103},
                        new FishArrayData() {y = -3, x = 9, fishType = 103},
                        new FishArrayData() {y = -1, x = 7.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = 6.5f, fishType = 103},
                        new FishArrayData() {y = 3, x = 3.5f, fishType = 103},
                        new FishArrayData() {y = 4, x = 2.7f, fishType = 103},
                        new FishArrayData() {y = 5, x = 1.8f, fishType = 103}
                    }
                }
            },
            {
                3, new FishArrayList()
                {
                    ArrayName = "DLY",
                    list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 106},
                        new FishArrayData() {y = -2.14f, x = -2.15f, fishType = 106},
                        new FishArrayData() {y = 1.99f, x = -2.27f, fishType = 106},
                        new FishArrayData() {y = -0.17f, x = -4.54f, fishType = 106}
                    }
                }
            },
            {
                4, new FishArrayList()
                {
                    ArrayName = "DNY", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 107},
                        new FishArrayData() {y = 2.81f, x = -1.07f, fishType = 107},
                        new FishArrayData() {y = -3.06f, x = -1.21f, fishType = 107}
                    }
                }
            },
            {
                5, new FishArrayList()
                {
                    ArrayName = "HUDIE", list = new List<FishArrayData>()
                    {//75
                        new FishArrayData() {y = 0, x = 0, fishType = 140},//闪电蜻蜓
                        new FishArrayData() {y = 1, x = -1, fishType = 102},//蜻蜓鱼
                        new FishArrayData() {y = 1.7f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = 2.4f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 3.3f, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = 4.2f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 4.9f, x = -1.5f, fishType = 102},
                        new FishArrayData() {y = 5.5f, x = -0.9f, fishType = 102},
                        new FishArrayData() {y = 1, x = 1, fishType = 102},
                        new FishArrayData() {y = 1.7f, x = 1.55f, fishType = 102},
                        new FishArrayData() {y = 2.4f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = 3.3f, x = 2.45f, fishType = 102},
                        new FishArrayData() {y = 4.2f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = 4.9f, x = 1.5f, fishType = 102},
                        new FishArrayData() {y = 5.5f, x = 0.9f, fishType = 102},
                        new FishArrayData() {y = 5.9f, x = 0, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = -1.7f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = -2.4f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -3.3f, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = -4.2f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -4.9f, x = -1.5f, fishType = 102},
                        new FishArrayData() {y = -5.5f, x = -0.9f, fishType = 102},
                        new FishArrayData() {y = -1, x = 1, fishType = 102},
                        new FishArrayData() {y = -1.7f, x = 1.55f, fishType = 102},
                        new FishArrayData() {y = -2.4f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = -3.3f, x = 2.45f, fishType = 102},
                        new FishArrayData() {y = -4.2f, x = 2.1f, fishType = 102},
                        new FishArrayData() {y = -4.9f, x = 1.5f, fishType = 102},
                        new FishArrayData() {y = -5.5f, x = 0.9f, fishType = 102},
                        new FishArrayData() {y = -5.9f, x = 0, fishType = 102},
                        new FishArrayData() {y = 0.55f, x = 2.2f, fishType = 102},
                        new FishArrayData() {y = -0.55f, x = 2.2f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 101},//蝴蝶鱼
                        new FishArrayData() {y = 0, x = -3.5f, fishType = 139},//闪电蝴蝶
                        new FishArrayData() {y = 0, x = -5, fishType = 101},
                        new FishArrayData() {y = 1, x = -3, fishType = 101},
                        new FishArrayData() {y = 2, x = -4, fishType = 101},
                        new FishArrayData() {y = 3, x = -5, fishType = 101},
                        new FishArrayData() {y = 4, x = -6, fishType = 101},
                        new FishArrayData() {y = 5, x = -7, fishType = 101},
                        new FishArrayData() {y = 0.6f, x = -5.7f, fishType = 101},
                        new FishArrayData() {y = 1.2f, x = -6.6f, fishType = 101},
                        new FishArrayData() {y = 2, x = -7.5f, fishType = 101},
                        new FishArrayData() {y = 2.8f, x = -8.5f, fishType = 101},
                        new FishArrayData() {y = 3.65f, x = -9.25f, fishType = 101},
                        new FishArrayData() {y = 4.4f, x = -10.1f, fishType = 101},
                        new FishArrayData() {y = 5.2f, x = -9.2f, fishType = 101},
                        new FishArrayData() {y = 5.6f, x = -8.2f, fishType = 101},
                        new FishArrayData() {y = -1, x = -3, fishType = 101},
                        new FishArrayData() {y = -2, x = -4, fishType = 101},
                        new FishArrayData() {y = -3, x = -5, fishType = 101},
                        new FishArrayData() {y = -4, x = -6, fishType = 101},
                        new FishArrayData() {y = -5, x = -7, fishType = 101},
                        new FishArrayData() {y = -0.8f, x = -6, fishType = 101},
                        new FishArrayData() {y = -1.6f, x = -7, fishType = 101},
                        new FishArrayData() {y = -2.4f, x = -8, fishType = 101},
                        new FishArrayData() {y = -3.2f, x = -9, fishType = 101},
                        new FishArrayData() {y = -4, x = -10, fishType = 101},
                        new FishArrayData() {y = -4.9f, x = -10.1f, fishType = 101},
                        new FishArrayData() {y = -5.4f, x = -9.2f, fishType = 101},
                        new FishArrayData() {y = -5.6f, x = -8.2f, fishType = 101},
                        new FishArrayData() {y = 1, x = -9, fishType = 104},//热带黄鱼
                        new FishArrayData() {y = -1, x = -9, fishType = 104},
                        new FishArrayData() {y = 1, x = -11, fishType = 104},
                        new FishArrayData() {y = -1, x = -11, fishType = 104},
                        new FishArrayData() {y = 1, x = -13, fishType = 104},
                        new FishArrayData() {y = -1, x = -13, fishType = 104},
                        new FishArrayData() {y = 1, x = -15, fishType = 104},
                        new FishArrayData() {y = -1, x = -15, fishType = 104},
                        new FishArrayData() {y = 1, x = -17, fishType = 104},
                        new FishArrayData() {y = -1, x = -17, fishType = 104},
                        new FishArrayData() {y = 1, x = -19, fishType = 104},
                        new FishArrayData() {y = -1, x = -19, fishType = 104},
                        new FishArrayData() {y = 0, x = -21, fishType = 104}
                    }
                }
            },
            {
                6, new FishArrayList()
                {
                    ArrayName = "HUDIE1", list = new List<FishArrayData>()
                    {//71
                        new FishArrayData() {y = 0, x = 0, fishType = 124},//大金鲨
                        new FishArrayData() {y = 1.1f, x = -0.1f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = 2, x = -0.25f, fishType = 105},
                        new FishArrayData() {y = 3, x = -0.3f, fishType = 105},
                        new FishArrayData() {y = 4, x = -0.45f, fishType = 105},
                        new FishArrayData() {y = 5, x = -0.55f, fishType = 105},
                        new FishArrayData() {y = 6, x = -0.6f, fishType = 105},
                        new FishArrayData() {y = 6.75f, x = 0.6f, fishType = 105},
                        new FishArrayData() {y = 7.2f, x = 1.8f, fishType = 105},
                        new FishArrayData() {y = 7.6f, x = 3.2f, fishType = 105},
                        new FishArrayData() {y = 5.13f, x = 3.69f, fishType = 105},
                        new FishArrayData() {y = 4.19f, x = 3.33f, fishType = 105},
                        new FishArrayData() {y = 3.42f, x = 2.73f, fishType = 105},
                        new FishArrayData() {y = 2.47f, x = 2.18f, fishType = 105},
                        new FishArrayData() {y = 1.64f, x = 1.79f, fishType = 105},
                        new FishArrayData() {y = 5.98f, x = 4.17f, fishType = 105},
                        new FishArrayData() {y = 0.95f, x = -2, fishType = 103},//比目鱼
                        new FishArrayData() {y = 1.85f, x = -2, fishType = 103},
                        new FishArrayData() {y = 2.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = 3.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = 4.75f, x = -2, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = -2.1f, fishType = 103},
                        new FishArrayData() {y = 5.9f, x = -3.15f, fishType = 103},
                        new FishArrayData() {y = 5.95f, x = -4.45f, fishType = 103},
                        new FishArrayData() {y = 5.1f, x = -6.55f, fishType = 103},
                        new FishArrayData() {y = 5.7f, x = -5.8f, fishType = 103},
                        new FishArrayData() {y = 1.1f, x = -6.25f, fishType = 103},
                        new FishArrayData() {y = 0.75f, x = -5.25f, fishType = 103},
                        new FishArrayData() {y = 0.5f, x = -4.25f, fishType = 103},
                        new FishArrayData() {y = 0.6f, x = -2.95f, fishType = 103},
                        new FishArrayData() {y = 7, x = 4.54f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = 7.84f, x = 4.53f, fishType = 105},
                        new FishArrayData() {y = 4.35f, x = -7.21f, fishType = 103},//比目鱼
                        new FishArrayData() {y = 2.73f, x = -7.31f, fishType = 103},
                        new FishArrayData() {y = 3.53f, x = -7.6f, fishType = 103},
                        new FishArrayData() {y = 1.86f, x = -6.82f, fishType = 103},
                        new FishArrayData() {y = -1.1f, x = -0.1f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = -2, x = -0.25f, fishType = 105},
                        new FishArrayData() {y = -3, x = -0.3f, fishType = 105},
                        new FishArrayData() {y = -4, x = -0.45f, fishType = 105},
                        new FishArrayData() {y = -5, x = -0.55f, fishType = 105},
                        new FishArrayData() {y = -6, x = -0.6f, fishType = 105},
                        new FishArrayData() {y = -6.75f, x = 0.6f, fishType = 105},
                        new FishArrayData() {y = -7.2f, x = 1.8f, fishType = 105},
                        new FishArrayData() {y = -7.6f, x = 3.2f, fishType = 105},
                        new FishArrayData() {y = -5.13f, x = 3.69f, fishType = 105},
                        new FishArrayData() {y = -4.19f, x = 3.33f, fishType = 105},
                        new FishArrayData() {y = -3.42f, x = 2.73f, fishType = 105},
                        new FishArrayData() {y = -2.47f, x = 2.18f, fishType = 105},
                        new FishArrayData() {y = -1.64f, x = 1.79f, fishType = 105},
                        new FishArrayData() {y = -5.98f, x = 4.17f, fishType = 105},
                        new FishArrayData() {y = -0.95f, x = -2, fishType = 103},//比目鱼
                        new FishArrayData() {y = -1.85f, x = -2, fishType = 103},
                        new FishArrayData() {y = -2.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = -3.9f, x = -2, fishType = 103},
                        new FishArrayData() {y = -4.75f, x = -2, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = -2.1f, fishType = 103},
                        new FishArrayData() {y = -5.9f, x = -3.15f, fishType = 103},
                        new FishArrayData() {y = -5.95f, x = -4.45f, fishType = 103},
                        new FishArrayData() {y = -5.1f, x = -6.55f, fishType = 103},
                        new FishArrayData() {y = -5.7f, x = -5.8f, fishType = 103},
                        new FishArrayData() {y = -1.2f, x = -6.3f, fishType = 103},
                        new FishArrayData() {y = -0.65f, x = -5.4f, fishType = 103},
                        new FishArrayData() {y = -0.5f, x = -4.25f, fishType = 103},
                        new FishArrayData() {y = -0.6f, x = -2.95f, fishType = 103},
                        new FishArrayData() {y = -7, x = 4.54f, fishType = 105},//大眼金鱼
                        new FishArrayData() {y = -7.84f, x = 4.53f, fishType = 105},
                        new FishArrayData() {y = -4.35f, x = -7.21f, fishType = 103},//比目鱼
                        new FishArrayData() {y = -2.73f, x = -7.31f, fishType = 103},
                        new FishArrayData() {y = -3.53f, x = -7.6f, fishType = 103},
                        new FishArrayData() {y = -1.86f, x = -6.82f, fishType = 103}
                    }
                }
            },
            {
                7, new FishArrayList()
                {
                    ArrayName = "QT", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = 2, x = -1, fishType = 102},
                        new FishArrayData() {y = 1, x = -1, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = -2, x = -1, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = 2, x = -2, fishType = 102},
                        new FishArrayData() {y = 1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 102},
                        new FishArrayData() {y = -2, x = -2, fishType = 102},
                        new FishArrayData() {y = -1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -3, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 102},
                    }
                }
            },
            {
                8, new FishArrayList()
                {
                    ArrayName = "QT2", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = 2, x = -1, fishType = 102},
                        new FishArrayData() {y = 1, x = -1, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = -2, x = -1, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = 2, x = -2, fishType = 102},
                        new FishArrayData() {y = 1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 140},
                        new FishArrayData() {y = -2, x = -2, fishType = 102},
                        new FishArrayData() {y = -1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -3, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 102},
                    }
                }
            },
            {
                9, new FishArrayList()
                {
                    ArrayName = "SHANDIAN", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 132},
                        new FishArrayData() {y = -2.97f, x = -5, fishType = 102},
                        new FishArrayData() {y = 1.88f, x = -8, fishType = 102},
                        new FishArrayData() {y = -2.5f, x = -7, fishType = 102},
                        new FishArrayData() {y = 1.22f, x = -10, fishType = 102},
                        new FishArrayData() {y = -2.27f, x = -9, fishType = 102},
                        new FishArrayData() {y = 0.56f, x = -12, fishType = 102}
                    }
                }
            },
            {
                10, new FishArrayList()
                {//112
                    ArrayName = "WENZI", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 3, x = 10, fishType = 129},//美人鱼
                        new FishArrayData() {y = -3, x = 10, fishType = 129},
                        new FishArrayData() {y = 1, x = 0, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 2, x = 0, fishType = 108},
                        new FishArrayData() {y = 3, x = 0, fishType = 108},
                        new FishArrayData() {y = -1, x = 0, fishType = 108},
                        new FishArrayData() {y = -2, x = 0, fishType = 108},
                        new FishArrayData() {y = -3, x = 0, fishType = 108},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -3, fishType = 108},
                        new FishArrayData() {y = 1, x = -3, fishType = 108},
                        new FishArrayData() {y = 2, x = -3, fishType = 108},
                        new FishArrayData() {y = 3, x = -3, fishType = 108},
                        new FishArrayData() {y = -1, x = -3, fishType = 108},
                        new FishArrayData() {y = -2, x = -3, fishType = 108},
                        new FishArrayData() {y = -3, x = -3, fishType = 108},
                        new FishArrayData() {y = 0, x = -5.9f, fishType = 108},
                        new FishArrayData() {y = 1, x = -6.2f, fishType = 108},
                        new FishArrayData() {y = 2, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -6.8f, fishType = 108},
                        new FishArrayData() {y = -1, x = -5.6f, fishType = 108},
                        new FishArrayData() {y = -2, x = -5.3f, fishType = 108},
                        new FishArrayData() {y = -3, x = -5, fishType = 108},
                        new FishArrayData() {y = 0, x = -7.7f, fishType = 108},
                        new FishArrayData() {y = 1, x = -7.4f, fishType = 108},
                        new FishArrayData() {y = 2, x = -7.1f, fishType = 108},
                        new FishArrayData() {y = -1, x = -8, fishType = 108},
                        new FishArrayData() {y = -2, x = -8.3f, fishType = 108},
                        new FishArrayData() {y = -3, x = -8.6f, fishType = 108},
                        new FishArrayData() {y = 0, x = -6.8f, fishType = 108},
                        new FishArrayData() {y = 0, x = -12, fishType = 108},
                        new FishArrayData() {y = 1, x = -12, fishType = 108},
                        new FishArrayData() {y = 2, x = -12, fishType = 108},
                        new FishArrayData() {y = 3, x = -12, fishType = 108},
                        new FishArrayData() {y = -1, x = -12, fishType = 108},
                        new FishArrayData() {y = -2, x = -12, fishType = 108},
                        new FishArrayData() {y = -3, x = -12, fishType = 108},
                        new FishArrayData() {y = 0, x = -11, fishType = 108},
                        new FishArrayData() {y = 2.5f, x = -10, fishType = 108},
                        new FishArrayData() {y = 1.5f, x = -9.6f, fishType = 108},
                        new FishArrayData() {y = 0.5f, x = -10, fishType = 108},
                        new FishArrayData() {y = 3, x = -11, fishType = 108},
                        new FishArrayData() {y = 0, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 1, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 2, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -1, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -16.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -15.5f, fishType = 108},
                        new FishArrayData() {y = 2.5f, x = -14.5f, fishType = 108},
                        new FishArrayData() {y = 1.5f, x = -14.1f, fishType = 108},
                        new FishArrayData() {y = 0.5f, x = -14.5f, fishType = 108},
                        new FishArrayData() {y = 3, x = -15.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -1, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -2, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = -3, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = 0, x = -20.5f, fishType = 108},
                        new FishArrayData() {y = 1, x = -19.9f, fishType = 108},
                        new FishArrayData() {y = 2, x = -19.3f, fishType = 108},
                        new FishArrayData() {y = 3, x = -18.7f, fishType = 108},
                        new FishArrayData() {y = 1, x = -21.1f, fishType = 108},
                        new FishArrayData() {y = 2, x = -21.7f, fishType = 108},
                        new FishArrayData() {y = 3, x = -22.3f, fishType = 108},
                        new FishArrayData() {y = 7, x = 10, fishType = 112},//乌龟
                        new FishArrayData() {y = 7, x = 6, fishType = 112},
                        new FishArrayData() {y = 7, x = 2, fishType = 112},
                        new FishArrayData() {y = 7, x = -2, fishType = 112},
                        new FishArrayData() {y = 7, x = -6, fishType = 112},
                        new FishArrayData() {y = 7, x = -10, fishType = 112},
                        new FishArrayData() {y = 7, x = -14, fishType = 112},
                        new FishArrayData() {y = 7, x = -18, fishType = 112},
                        new FishArrayData() {y = 7, x = -22, fishType = 112},
                        new FishArrayData() {y = -7, x = 10, fishType = 112},
                        new FishArrayData() {y = -7, x = 6, fishType = 112},
                        new FishArrayData() {y = -7, x = 2, fishType = 112},
                        new FishArrayData() {y = -7, x = -2, fishType = 112},
                        new FishArrayData() {y = -7, x = -6, fishType = 112},
                        new FishArrayData() {y = -7, x = -10, fishType = 112},
                        new FishArrayData() {y = -7, x = -14, fishType = 112},
                        new FishArrayData() {y = -7, x = -18, fishType = 112},
                        new FishArrayData() {y = -7, x = -22, fishType = 112},
                        new FishArrayData() {y = -7, x = -26, fishType = 112},
                        new FishArrayData() {y = -7, x = -30, fishType = 112},
                        new FishArrayData() {y = -7, x = -34, fishType = 112},
                        new FishArrayData() {y = -7, x = -38, fishType = 112},
                        new FishArrayData() {y = 7, x = -26, fishType = 112},
                        new FishArrayData() {y = 7, x = -30, fishType = 112},
                        new FishArrayData() {y = 7, x = -34, fishType = 112},
                        new FishArrayData() {y = 7, x = -38, fishType = 112},
                        new FishArrayData() {y = 4, x = -32, fishType = 103},//比目鱼
                        new FishArrayData() {y = 4, x = -39, fishType = 103},
                        new FishArrayData() {y = 6, x = -38, fishType = 103},
                        new FishArrayData() {y = -4, x = -30, fishType = 103},
                        new FishArrayData() {y = -5, x = -32, fishType = 103},
                        new FishArrayData() {y = 5, x = -34, fishType = 103},
                        new FishArrayData() {y = 4, x = -25, fishType = 103},
                        new FishArrayData() {y = 0, x = -40, fishType = 103},
                        new FishArrayData() {y = -2, x = -38, fishType = 103},
                        new FishArrayData() {y = -3, x = -28, fishType = 103},
                        new FishArrayData() {y = 2, x = -24, fishType = 103},
                        new FishArrayData() {y = -2, x = -26, fishType = 103},
                        new FishArrayData() {y = 6, x = -36, fishType = 103},
                        new FishArrayData() {y = -3, x = -36, fishType = 103},
                        new FishArrayData() {y = 2, x = -40, fishType = 103},
                        new FishArrayData() {y = 6, x = -26, fishType = 103},
                        new FishArrayData() {y = 0, x = -24, fishType = 103},
                        new FishArrayData() {y = 5, x = -30, fishType = 103},
                        new FishArrayData() {y = -4, x = -34, fishType = 103},
                        new FishArrayData() {y = 5.99f, x = -27.85f, fishType = 103}
                    }
                }
            },
            {
                11, new FishArrayList()
                {
                    ArrayName = "WUJIAOXING", list = new List<FishArrayData>()
                    {//35
                        new FishArrayData() {y = 0, x = 0, fishType = 106},//狮头鱼
                        new FishArrayData() {y = 0, x = -12.7f, fishType = 106},
                        new FishArrayData() {y = 0, x = -10.5f, fishType = 106},
                        new FishArrayData() {y = 0, x = -8.3f, fishType = 106},
                        new FishArrayData() {y = 0, x = -6.35f, fishType = 106},
                        new FishArrayData() {y = 0, x = -4.15f, fishType = 106},
                        new FishArrayData() {y = 0, x = -2.15f, fishType = 106},
                        new FishArrayData() {y = 1.84f, x = -11.72f, fishType = 106},
                        new FishArrayData() {y = 4.95f, x = -9.72f, fishType = 106},
                        new FishArrayData() {y = 6.46f, x = -8.85f, fishType = 106},
                        new FishArrayData() {y = 9.42f, x = -7.29f, fishType = 106},
                        new FishArrayData() {y = 11.04f, x = -6, fishType = 106},
                        new FishArrayData() {y = 9.41f, x = -4.64f, fishType = 106},
                        new FishArrayData() {y = 6.39f, x = -3.29f, fishType = 106},
                        new FishArrayData() {y = 4.75f, x = -2.46f, fishType = 106},
                        new FishArrayData() {y = 1.84f, x = -0.61f, fishType = 106},
                        new FishArrayData() {y = 7.88f, x = -12.83f, fishType = 107},//七彩鱼
                        new FishArrayData() {y = 8, x = -10.41f, fishType = 107},
                        new FishArrayData() {y = 8, x = -8.09f, fishType = 107},
                        new FishArrayData() {y = 8, x = -5.93f, fishType = 107},
                        new FishArrayData() {y = 8, x = -3.21f, fishType = 107},
                        new FishArrayData() {y = 8, x = -1.09f, fishType = 107},
                        new FishArrayData() {y = 8, x = 1.22f, fishType = 107},
                        new FishArrayData() {y = 6.11f, x = -12.26f, fishType = 107},
                        new FishArrayData() {y = 4.52f, x = -11.14f, fishType = 107},
                        new FishArrayData() {y = 2.85f, x = -9.97f, fishType = 107},
                        new FishArrayData() {y = 1.2f, x = -9.03f, fishType = 107},
                        new FishArrayData() {y = -1.45f, x = -7.43f, fishType = 107},
                        new FishArrayData() {y = -3.33f, x = -5.78f, fishType = 107},
                        new FishArrayData() {y = -1.43f, x = -4.33f, fishType = 107},
                        new FishArrayData() {y = 1.34f, x = -2.95f, fishType = 107},
                        new FishArrayData() {y = 3, x = -1.95f, fishType = 107},
                        new FishArrayData() {y = 4.52f, x = -0.85f, fishType = 107},
                        new FishArrayData() {y = 6.17f, x = 0.41f, fishType = 107},
                        new FishArrayData() {y = 4, x = -6, fishType = 109}//愤怒河豚
                    }
                }
            },
            {
                12, new FishArrayList()
                {
                    ArrayName = "WUXING", list = new List<FishArrayData>()
                    {//107
                        new FishArrayData() {y = 0, x = 0, fishType = 102},//蜻蜓鱼
                        new FishArrayData() {y = 1.3f, x = -0.04f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -0.26f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -0.84f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -1.06f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -0.2f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -0.45f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -0.75f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -1.1f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -1.55f, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -1.3f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -1.7f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -2.9f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -1.3f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -1.7f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -2.1f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -2.9f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2.45f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -2.74f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -3.14f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -3.45f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -4.03f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -4.25f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -3, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -3.35f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -3.8f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -4.25f, fishType = 102},
                        new FishArrayData() {y = 0, x = -20.35f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -20.05f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -19.74f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -19.25f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -18.85f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -18.63f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -20.05f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -19.74f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -19.25f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -18.85f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -18.54f, fishType = 102},
                        new FishArrayData() {y = 0, x = -19, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -18.7f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -18.3f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -17.9f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -17.5f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -17.1f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -18.7f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -18.3f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -17.9f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -17.5f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -17.1f, fishType = 102},
                        new FishArrayData() {y = 0, x = -17.65f, fishType = 102},
                        new FishArrayData() {y = 1.3f, x = -17.26f, fishType = 102},
                        new FishArrayData() {y = 2.6f, x = -16.95f, fishType = 102},
                        new FishArrayData() {y = 3.9f, x = -16.55f, fishType = 102},
                        new FishArrayData() {y = 5.2f, x = -16.32f, fishType = 102},
                        new FishArrayData() {y = 6.5f, x = -15.75f, fishType = 102},
                        new FishArrayData() {y = -1.3f, x = -17.35f, fishType = 102},
                        new FishArrayData() {y = -2.6f, x = -16.95f, fishType = 102},
                        new FishArrayData() {y = -3.9f, x = -16.55f, fishType = 102},
                        new FishArrayData() {y = -5.2f, x = -16.24f, fishType = 102},
                        new FishArrayData() {y = -6.5f, x = -15.75f, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 0, x = -7, fishType = 108},
                        new FishArrayData() {y = 0, x = -15, fishType = 108},
                        new FishArrayData() {y = 0, x = -13, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -14, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -12, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -6, fishType = 108},
                        new FishArrayData() {y = 1.2f, x = -8, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -13, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -7, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -9, fishType = 108},
                        new FishArrayData() {y = 2.4f, x = -11, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -14, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -12, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -6, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -8, fishType = 108},
                        new FishArrayData() {y = 3.6f, x = -10, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -13, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -9, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -11, fishType = 108},
                        new FishArrayData() {y = 4.8f, x = -7, fishType = 108},
                        new FishArrayData() {y = 6, x = -10, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -14, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -12, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -6, fishType = 108},
                        new FishArrayData() {y = -1.2f, x = -8, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -13, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -7, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -9, fishType = 108},
                        new FishArrayData() {y = -2.4f, x = -11, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -14, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -12, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -6, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -8, fishType = 108},
                        new FishArrayData() {y = -3.6f, x = -10, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -13, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -9, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -11, fishType = 108},
                        new FishArrayData() {y = -4.8f, x = -7, fishType = 108},
                        new FishArrayData() {y = -6, x = -10, fishType = 108},
                        new FishArrayData() {y = 0, x = -10, fishType = 140}//闪电蜻蜓
                    }
                }
            },
            {
                13, new FishArrayList()
                {
                    ArrayName = "XY", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},
                        new FishArrayData() {y = 1.48f, x = -1.73f, fishType = 108},
                        new FishArrayData() {y = 1.49f, x = 1.37f, fishType = 108},
                        new FishArrayData() {y = -1.82f, x = -1.52f, fishType = 108},
                        new FishArrayData() {y = -1.8f, x = 1.44f, fishType = 108}
                    }
                }
            },
            {
                14, new FishArrayList()
                {
                    ArrayName = "XY1", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},
                        new FishArrayData() {y = -1.33f, x = -1.43f, fishType = 108},
                        new FishArrayData() {y = -2.12f, x = -3.38f, fishType = 108},
                        new FishArrayData() {y = 1.18f, x = -1.61f, fishType = 108},
                        new FishArrayData() {y = 1.78f, x = -3.62f, fishType = 108}
                    }
                }
            },
            {
                15, new FishArrayList()
                {
                    ArrayName = "XYQ", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = -0.6f, x = -1, fishType = 102},
                        new FishArrayData() {y = 0.6f, x = -1, fishType = 102},
                        new FishArrayData() {y = -1.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 1.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5.5f, fishType = 102}
                    }
                }
            },
            {
                16, new FishArrayList()
                {
                    ArrayName = "XYQ1", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 101},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 101},
                        new FishArrayData() {y = 0, x = -3, fishType = 101},
                        new FishArrayData() {y = -1, x = -1, fishType = 101},
                        new FishArrayData() {y = 1, x = -1, fishType = 101}
                    }
                }
            },
            {
                17, new FishArrayList()
                {
                    ArrayName = "XYQ2", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 101},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 139},
                        new FishArrayData() {y = 0, x = -3, fishType = 101},
                        new FishArrayData() {y = -1, x = -1, fishType = 101},
                        new FishArrayData() {y = 1, x = -1, fishType = 101}
                    }
                }
            },
            {
                18, new FishArrayList()
                {
                    ArrayName = "YUANXING", list = new List<FishArrayData>()
                    {//44
                        new FishArrayData() {y = 0, x = 0, fishType = 129},//美人鱼
                        new FishArrayData() {y = 2.5f, x = 7.6f, fishType = 108},//小丑鱼
                        new FishArrayData() {y = 4.7f, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = 6.5f, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = 7.6f, x = 2.5f, fishType = 108},
                        new FishArrayData() {y = 8, x = 0, fishType = 108},
                        new FishArrayData() {y = 7.6f, x = -2.5f, fishType = 108},
                        new FishArrayData() {y = 6.5f, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = 4.7f, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = 2.8f, x = -7.95f, fishType = 108},
                        new FishArrayData() {y = -3.05f, x = -7.6f, fishType = 108},
                        new FishArrayData() {y = -4.7f, x = -6.5f, fishType = 108},
                        new FishArrayData() {y = -6.5f, x = -4.7f, fishType = 108},
                        new FishArrayData() {y = -7.6f, x = -2.5f, fishType = 108},
                        new FishArrayData() {y = -8, x = 0, fishType = 108},
                        new FishArrayData() {y = -7.6f, x = 2.5f, fishType = 108},
                        new FishArrayData() {y = -6.5f, x = 4.7f, fishType = 108},
                        new FishArrayData() {y = -4.7f, x = 6.5f, fishType = 108},
                        new FishArrayData() {y = -2.5f, x = 7.6f, fishType = 108},
                        new FishArrayData() {y = 2.3f, x = 5.5f, fishType = 103},//比目鱼
                        new FishArrayData() {y = 4.2f, x = 4.2f, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = 2.3f, fishType = 103},
                        new FishArrayData() {y = 6, x = 0, fishType = 103},
                        new FishArrayData() {y = 5.5f, x = -2.3f, fishType = 103},
                        new FishArrayData() {y = 4.2f, x = -4.2f, fishType = 103},
                        new FishArrayData() {y = 2.85f, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = -2.85f, x = -5.5f, fishType = 103},
                        new FishArrayData() {y = -4.2f, x = -4.3f, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = -2.3f, fishType = 103},
                        new FishArrayData() {y = -6, x = 0, fishType = 103},
                        new FishArrayData() {y = -5.5f, x = 2.3f, fishType = 103},
                        new FishArrayData() {y = -4.3f, x = 4, fishType = 103},
                        new FishArrayData() {y = -2.3f, x = 5.5f, fishType = 103},
                        new FishArrayData() {y = 0, x = 6, fishType = 103},
                        new FishArrayData() {y = 2, x = 3.5f, fishType = 121},//金炸弹鱼
                        new FishArrayData() {y = 3.5f, x = 2, fishType = 121},
                        new FishArrayData() {y = 4, x = 0, fishType = 121},
                        new FishArrayData() {y = 3.5f, x = -2, fishType = 121},
                        new FishArrayData() {y = 2, x = -3.5f, fishType = 121},
                        new FishArrayData() {y = -2, x = -3.5f, fishType = 121},
                        new FishArrayData() {y = -3.5f, x = -2, fishType = 121},
                        new FishArrayData() {y = -4, x = 0, fishType = 121},
                        new FishArrayData() {y = -3.5f, x = 2, fishType = 121},
                        new FishArrayData() {y = -2, x = 3.5f, fishType = 121}
                    }
                }
            },
        };

        public static Dictionary<int, FishArrayList> NormalArray = new Dictionary<int, FishArrayList>()
        {
            {
                1, new FishArrayList()
                {
                    ArrayName = "QT", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = 2, x = -1, fishType = 102},
                        new FishArrayData() {y = 1, x = -1, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = -2, x = -1, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = 2, x = -2, fishType = 102},
                        new FishArrayData() {y = 1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 102},
                        new FishArrayData() {y = -2, x = -2, fishType = 102},
                        new FishArrayData() {y = -1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -3, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 102},
                    }
                }
            },
            {
                2, new FishArrayList()
                {
                    ArrayName = "XYQ1", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 101},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 101},
                        new FishArrayData() {y = 0, x = -3, fishType = 101},
                        new FishArrayData() {y = -1, x = -1, fishType = 101},
                        new FishArrayData() {y = 1, x = -1, fishType = 101}
                    }
                }
            },
            {
                3, new FishArrayList()
                {
                    ArrayName = "QT2", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = 2, x = -1, fishType = 102},
                        new FishArrayData() {y = 1, x = -1, fishType = 102},
                        new FishArrayData() {y = 0, x = -1, fishType = 102},
                        new FishArrayData() {y = -2, x = -1, fishType = 102},
                        new FishArrayData() {y = -1, x = -1, fishType = 102},
                        new FishArrayData() {y = 2, x = -2, fishType = 102},
                        new FishArrayData() {y = 1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -2, fishType = 140},
                        new FishArrayData() {y = -2, x = -2, fishType = 102},
                        new FishArrayData() {y = -1, x = -2, fishType = 102},
                        new FishArrayData() {y = 0, x = -3, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5, fishType = 102},
                    }
                }
            },
            {
                4, new FishArrayList()
                {
                    ArrayName = "XYQ2", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 101},
                        new FishArrayData() {y = 0, x = -1.5f, fishType = 139},
                        new FishArrayData() {y = 0, x = -3, fishType = 101},
                        new FishArrayData() {y = -1, x = -1, fishType = 101},
                        new FishArrayData() {y = 1, x = -1, fishType = 101}
                    }
                }
            },
            {
                5, new FishArrayList()
                {
                    ArrayName = "DLY",
                    list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 106},
                        new FishArrayData() {y = -2.14f, x = -2.15f, fishType = 106},
                        new FishArrayData() {y = 1.99f, x = -2.27f, fishType = 106},
                        new FishArrayData() {y = -0.17f, x = -4.54f, fishType = 106}
                    }
                }
            },
            {
                6, new FishArrayList()
                {
                    ArrayName = "DNY", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 107},
                        new FishArrayData() {y = 2.81f, x = -1.07f, fishType = 107},
                        new FishArrayData() {y = -3.06f, x = -1.21f, fishType = 107}
                    }
                }
            },
            {
                7, new FishArrayList()
                {
                    ArrayName = "XY", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},
                        new FishArrayData() {y = 1.48f, x = -1.73f, fishType = 108},
                        new FishArrayData() {y = 1.49f, x = 1.37f, fishType = 108},
                        new FishArrayData() {y = -1.82f, x = -1.52f, fishType = 108},
                        new FishArrayData() {y = -1.8f, x = 1.44f, fishType = 108}
                    }
                }
            },
            {
                8, new FishArrayList()
                {
                    ArrayName = "XY1", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 108},
                        new FishArrayData() {y = -1.33f, x = -1.43f, fishType = 108},
                        new FishArrayData() {y = -2.12f, x = -3.38f, fishType = 108},
                        new FishArrayData() {y = 1.18f, x = -1.61f, fishType = 108},
                        new FishArrayData() {y = 1.78f, x = -3.62f, fishType = 108}
                    }
                }
            },
            {
                9, new FishArrayList()
                {
                    ArrayName = "XYQ", list = new List<FishArrayData>()
                    {
                        new FishArrayData() {y = 0, x = 0, fishType = 102},
                        new FishArrayData() {y = -0.6f, x = -1, fishType = 102},
                        new FishArrayData() {y = 0.6f, x = -1, fishType = 102},
                        new FishArrayData() {y = -1.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 1.2f, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 0, x = -2.5f, fishType = 102},
                        new FishArrayData() {y = 0, x = -4, fishType = 102},
                        new FishArrayData() {y = 0, x = -5.5f, fishType = 102}
                    }
                }
            },
        };
    }
}