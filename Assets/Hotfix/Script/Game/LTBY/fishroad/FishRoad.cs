using System.Collections.Generic;

namespace Hotfix.LTBY
{
    public class FishDataSave
    {
        public List<Data> data;

        public class Data
        {
            public int Index;
            public string roadName;
            public int totalTime;
            public List<int> subTime;
            public List<float> mtlist;
        }
    }

    public class FishRoadList
    {
        public string RoadName;
        public List<FishRoad> list;
    }

    public class FishRoadConfig
    {
        public static Dictionary<int, FishRoadList> FishRoads = new Dictionary<int, FishRoadList>()
        {
            {1, new FishRoadList() {RoadName = "Long_1", list = new List<FishRoad>() { }}},

            {2, new FishRoadList() {RoadName = "Long_2", list = new List<FishRoad>() { }}},
            {3, new FishRoadList() {RoadName = "Long_3", list = new List<FishRoad>() { }}},
            {4, new FishRoadList() {RoadName = "Long_4", list = new List<FishRoad>() { }}},
            //{
            //    4, new FishRoadList()//-1
            //    {
            //        RoadName = "D01", list = new List<FishRoad>()
            //        {
            //            new FishRoad() {y = 1.56f, x = -30.23f, offsetX = 0f, offsetY = 0f, speed = 1f},
            //            new FishRoad() {y = -6.29f, x = 32.09f, offsetX = -16.12f, offsetY = -32.69f, speed = 0.3f}
            //        }
            //    }
            //},
            {
                5, new FishRoadList()//-1
                {
                    RoadName = "D02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 20.86f, x = -13.75f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.88f, x = 34.04f, offsetX = -60.99f, offsetY = -23.08f, speed = 0.3f},
                        new FishRoad() {y = 8.73f, x = -32.74f, offsetX = 29.54f, offsetY = -34.17f, speed = 0.3f},
                    }
                }
            },
            {
                6, new FishRoadList()//-1
                {
                    RoadName = "D03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9.18f, x = 29.33f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -21.09f, x = -15.85f, offsetX = 4.94f, offsetY = 36.13f, speed = 0.3f},
                    }
                }
            },
            {
                7, new FishRoadList()//-1
                {
                    RoadName = "D04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -18.98f, x = -12.23f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 3.51f, x = 32.07f, offsetX = -30.63f, offsetY = 19.67f, speed = 0.3f},
                        new FishRoad() {y = 2.75f, x = -28.96f, offsetX = 19.62f, offsetY = -29.78f, speed = 0.3f},
                    }
                }
            },
            {
                8, new FishRoadList()//+1
                {
                    RoadName = "DSZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.79f, x = 22.62f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -13.14f, x = -30.13f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                9, new FishRoadList()//+1
                {
                    RoadName = "DSZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.79f, x = 22.62f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.02f, x = -33.42f, offsetX = 41.79f, offsetY = -18.64f, speed = 0.3f},
                    }
                }
            },
            {
                10, new FishRoadList()//+1
                {
                    RoadName = "DXS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -17.51f, x = -0.44f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 19.79f, x = 13.28f, offsetX = -33.07f, offsetY = -28.04f, speed = 0.3f},
                    }
                }
            },
            {
                11, new FishRoadList()//+1
                {
                    RoadName = "DXY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.62f, x = -0.43f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.85f, x = 31.03f, offsetX = -43.37f, offsetY = 22.87f, speed = 0.3f},
                    }
                }
            },
            {
                12, new FishRoadList()//+-1
                {
                    RoadName = "DXY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.3f, x = -14.17f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.82f, x = 30.81f, offsetX = -42.94f, offsetY = 14.92f, speed = 0.3f},
                    }
                }
            },
            {
                13, new FishRoadList()//+1
                {
                    RoadName = "DXZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.15f, x = 19.94f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 13.74f, x = -29.88f, offsetX = 52.36f, offsetY = -10.22f, speed = 0.3f},
                    }
                }
            },
            {
                14, new FishRoadList()//-1
                {
                    RoadName = "DXZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14.88f, x = 0.56f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 1.58f, x = -33.66f, offsetX = 55.28f, offsetY = 24.37f, speed = 0.3f},
                    }
                }
            },
            {
                15, new FishRoadList()//-1
                {
                    RoadName = "DYS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -10.72f, x = 29.45f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 25.99f, x = -1.21f, offsetX = -57.16f, offsetY = -39.64f, speed = 0.3f},
                    }
                }
            },
            {
                16, new FishRoadList()//-1
                {
                    RoadName = "DYS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -11.44f, x = 29.57f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 21.33f, x = -30.93f, offsetX = 4.85f, offsetY = -30.88f, speed = 0.3f},
                    }
                }
            },
            {
                17, new FishRoadList()//-1
                {
                    RoadName = "DYX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 10.42f, x = 27.03f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -25.19f, x = -19.14f, offsetX = -18.61f, offsetY = 40.37f, speed = 0.3f},
                    }
                }
            },
            {
                18, new FishRoadList()//-1
                {
                    RoadName = "DYZ03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 8.8f, x = 26.04f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -8.21f, x = -28.99f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                19, new FishRoadList()//+1
                {
                    RoadName = "DYZ04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 8.8f, x = 26.04f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.91f, x = -28.5f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                20, new FishRoadList()
                {
                    RoadName = "DYZ05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5.32f, x = 25.68f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.48f, x = -35.12f, offsetX = 42.68f, offsetY = -16.35f, speed = 0.3f},
                    }
                }
            },
            {
                21, new FishRoadList()
                {
                    RoadName = "DZS05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -8.3f, x = -26.62f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 18.49f, x = 29.97f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                22, new FishRoadList()
                {
                    RoadName = "DZX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 1.59f, x = -28.56f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -25.87f, x = 3.3f, offsetX = 46.99f, offsetY = 43.27f, speed = 0.3f},
                    }
                }
            },
            {
                23, new FishRoadList()
                {
                    RoadName = "DZX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 12.84f, x = -25.44f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -22.85f, x = 16.13f, offsetX = 16.37f, offsetY = 26.03f, speed = 0.3f},
                    }
                }
            },
            {
                24, new FishRoadList()//+1
                {
                    RoadName = "DZY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 7.41f, x = -25.61f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -4.78f, x = 31.56f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                25, new FishRoadList()
                {
                    RoadName = "DZY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.75f, x = -26.04f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -4.78f, x = 31.56f, offsetX = -22.55f, offsetY = 21.04f, speed = 0.3f},
                    }
                }
            },
            {
                26, new FishRoadList()
                {
                    RoadName = "DZY04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.16f, x = -26.09f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.05f, x = -0.24f, offsetX = 0f, offsetY = 0f, speed = 0.6f},
                        new FishRoad() {y = -12.07f, x = 34.15f, offsetX = 14.86f, offsetY = 3.49f, speed = 0.4f},
                    }
                }
            },
            {
                27, new FishRoadList()
                {
                    RoadName = "DZY05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5.89f, x = -25.03f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -7.05f, x = 34f, offsetX = -12.88f, offsetY = 17.64f, speed = 0.4f},
                    }
                }
            },
            {
                28, new FishRoadList()
                {
                    RoadName = "JIASU01", list = new List<FishRoad>()//-1
                    {
                        new FishRoad() {y = 5.06f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 1.81f, x = -4.03f, offsetX = 13.84f, offsetY = 13.64f, speed = 0.5f},
                        new FishRoad() {y = -3.05f, x = 8.52f, offsetX = -5.99f, offsetY = -5.99f, speed = 1.8f},
                        new FishRoad() {y = 4.55f, x = 29.94f, offsetX = 0f, offsetY = 0f, speed = 2f},
                    }
                }
            },
            {
                29, new FishRoadList()
                {
                    RoadName = "JIASU02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 17.61f, x = -7.33f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.83f, x = -0.1f, offsetX = -11.47f, offsetY = -9.5f, speed = 0.5f},
                        new FishRoad() {y = -0.83f, x = 29.75f, offsetX = -14.67f, offsetY = -8.68f, speed = 1f},
                    }
                }
            },
            {
                30, new FishRoadList()
                {
                    RoadName = "JIASU03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 11.57f, x = 25.98f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 3.94f, x = 8.16f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = -0.23f, x = -1.82f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -4.72f, x = -12.65f, offsetX = 0f, offsetY = 0f, speed = 1.8f},
                        new FishRoad() {y = -11.85f, x = -30.27f, offsetX = 0f, offsetY = 0f, speed = 1.8f},
                    }
                }
            },
            {
                31, new FishRoadList()
                {
                    RoadName = "JIASU04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 3.04f, x = 26.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.18f, x = 1.26f, offsetX = 2.52f, offsetY = -17.8f, speed = 0.5f},
                        new FishRoad() {y = 3.26f, x = -31.17f, offsetX = 7.11f, offsetY = 11.22f, speed = 1f},
                    }
                }
            },
            {
                32, new FishRoadList()
                {
                    RoadName = "JIASU05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.47f, x = -26.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.15f, x = -1.63f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 18.11f, x = 27.92f, offsetX = 0f, offsetY = 0f, speed = 0.8f},
                    }
                }
            },
            {
                33, new FishRoadList()
                {
                    RoadName = "JIASU06", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 17.91f, x = -10.88f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.66f, x = -4.22f, offsetX = -16.58f, offsetY = -11.55f, speed = 0.5f},
                        new FishRoad() {y = -5.91f, x = 30.93f, offsetX = -15.66f, offsetY = -3.43f, speed = 1f},
                    }
                }
            },
            {
                34, new FishRoadList()
                {
                    RoadName = "JIASU07", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 4.37f, x = -27.76f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.07f, x = -1.41f, offsetX = -7.25f, offsetY = -20.73f, speed = 0.5f},
                        new FishRoad() {y = 14.07f, x = 32.28f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                35, new FishRoadList()
                {
                    RoadName = "JIASU08", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5.06f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 1.81f, x = 4.03f, offsetX = -13.84f, offsetY = 13.64f, speed = 0.5f},
                        new FishRoad() {y = -3.05f, x = -8.52f, offsetX = 5.99f, offsetY = -5.99f, speed = 1.8f},
                        new FishRoad() {y = 4.55f, x = -29.94f, offsetX = 0f, offsetY = 0f, speed = 2f},
                    }
                }
            },
            {
                36, new FishRoadList()
                {
                    RoadName = "JIASU09", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 17.61f, x = 7.33f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.83f, x = 0.1f, offsetX = 11.47f, offsetY = -9.5f, speed = 0.5f},
                        new FishRoad() {y = -0.83f, x = -29.75f, offsetX = 14.67f, offsetY = -8.68f, speed = 1f},
                    }
                }
            },
            {
                37, new FishRoadList()
                {
                    RoadName = "JIASU10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 11.57f, x = -25.98f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 3.94f, x = -8.16f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = -0.23f, x = 1.82f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -4.72f, x = 12.65f, offsetX = 0f, offsetY = 0f, speed = 1.8f},
                        new FishRoad() {y = -11.85f, x = 30.27f, offsetX = 0f, offsetY = 0f, speed = 1.8f},
                    }
                }
            },
            {
                38, new FishRoadList()
                {
                    RoadName = "JIASU11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 3.04f, x = -26.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.18f, x = -1.26f, offsetX = -2.52f, offsetY = -17.8f, speed = 0.5f},
                        new FishRoad() {y = 3.26f, x = 31.17f, offsetX = -7.11f, offsetY = 11.22f, speed = 1f},
                    }
                }
            },
            {
                39, new FishRoadList()
                {
                    RoadName = "JIASU12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.47f, x = 26.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.15f, x = 1.63f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 18.11f, x = -27.92f, offsetX = 0f, offsetY = 0f, speed = 0.8f},
                    }
                }
            },
            {
                40, new FishRoadList()
                {
                    RoadName = "JIASU13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 17.91f, x = 10.88f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.66f, x = 4.22f, offsetX = 16.58f, offsetY = -11.55f, speed = 0.5f},
                        new FishRoad() {y = -5.91f, x = -30.93f, offsetX = 15.66f, offsetY = -3.43f, speed = 1f},
                    }
                }
            },
            {
                41, new FishRoadList()
                {
                    RoadName = "JIASU14", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 4.37f, x = 27.76f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.07f, x = 1.41f, offsetX = 7.25f, offsetY = -20.73f, speed = 0.5f},
                        new FishRoad() {y = 14.07f, x = -32.28f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                42, new FishRoadList()//+1
                {
                    RoadName = "TS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.45f, x = -24.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 8.11f, x = 28.44f, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                43, new FishRoadList()//+1
                {
                    RoadName = "TS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 7.65f, x = -23.97f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -7.69f, x = 26.98f, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                44, new FishRoadList()
                {
                    RoadName = "TS03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.19f, x = 20f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.23f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.2f},
                    }
                }
            },
            {
                45, new FishRoadList()
                {
                    RoadName = "TS04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.5f, x = 20f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -19.74f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.2f},
                    }
                }
            },
            {
                46, new FishRoadList()
                {
                    RoadName = "TS05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5.51f, x = -23.18f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -4.54f, x = 28.02f, offsetX = -10.26f, offsetY = 38.97f, speed = 0.3f},
                    }
                }
            },
            {
                47, new FishRoadList()
                {
                    RoadName = "TS06", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -8.07f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 10.41f, x = -27.78f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                48, new FishRoadList()
                {
                    RoadName = "TS07", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 8.68f, x = 24.96f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -5.62f, x = -27.17f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                49, new FishRoadList()
                {
                    RoadName = "TS08", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 3.65f, x = 26.73f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.56f, x = -28.31f, offsetX = 16.77f, offsetY = -25.35f, speed = 0.3f},
                    }
                }
            },
            {
                50, new FishRoadList()
                {
                    RoadName = "TS09", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -4.78f, x = -24.56f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.19f, x = -5.19f, offsetX = 0f, offsetY = 0f, speed = 0.8f},
                        new FishRoad() {y = -1.04f, x = 8.3f, offsetX = -1.96f, offsetY = -8.88f, speed = 0.8f},
                        new FishRoad() {y = 4.5f, x = -30.38f, offsetX = 47.27f, offsetY = 12.27f, speed = 0.3f},
                    }
                }
            },
            {
                51, new FishRoadList()//-1
                {
                    RoadName = "XSX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 12.97f, x = 2.57f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -19.9f, x = -13.55f, offsetX = 57.29f, offsetY = 11.65f, speed = 1f},
                    }
                }
            },
            {
                52, new FishRoadList()
                {
                    RoadName = "XSX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13.99f, x = -11.91f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -18.7f, x = 12.94f, offsetX = 38.74f, offsetY = 14.21f, speed = 1f},
                    }
                }
            },
            {
                53, new FishRoadList()
                {
                    RoadName = "XSX10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.85f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -1.66f, x = -20f, offsetX = 41.41f, offsetY = 4.21f, speed = 0.7f},
                        new FishRoad() {y = -6.92f, x = 15f, offsetX = -12.81f, offsetY = -12.29f, speed = 0.7f},
                        new FishRoad() {y = 8.18f, x = 0.7f, offsetX = 17.9f, offsetY = 1.76f, speed = 0.7f},
                        new FishRoad() {y = -15.01f, x = -4.74f, offsetX = -34.04f, offsetY = 22.14f, speed = 0.7f},
                    }
                }
            },
            {
                54, new FishRoadList()
                {
                    RoadName = "XSX12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.48f, x = -13.54f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -15.78f, x = 11.98f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                55, new FishRoadList()
                {
                    RoadName = "XSX14", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.81f, x = 10.63f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -16.87f, x = -11.98f, offsetX = 36.47f, offsetY = 1.06f, speed = 0.7f},
                    }
                }
            },
            {
                56, new FishRoadList()
                {
                    RoadName = "XSX15", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.37f, x = 12.73f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -16.28f, x = -16.62f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                57, new FishRoadList()//-1
                {
                    RoadName = "XSY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.47f, x = -14.74f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -3.28f, x = 25.36f, offsetX = -28.06f, offsetY = -18.32f, speed = 1f},
                    }
                }
            },
            {
                58, new FishRoadList()
                {
                    RoadName = "XSY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.47f, x = -14.74f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.68f, x = 25.85f, offsetX = -52.67f, offsetY = -39.13f, speed = 1f},
                    }
                }
            },
            {
                59, new FishRoadList()
                {
                    RoadName = "XSY03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.78f, x = 11.2f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -5.13f, x = 26.38f, offsetX = -93.39f, offsetY = -13.81f, speed = 1f},
                    }
                }
            },
            {
                60, new FishRoadList()//-1
                {
                    RoadName = "XSY11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 16.08f, x = -5.61f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -7.44f, x = 28.7f, offsetX = -37.01f, offsetY = -19.25f, speed = 0.7f},
                    }
                }
            },
            {
                61, new FishRoadList()
                {
                    RoadName = "XSY16", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 18.77f, x = -0.98f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -3.96f, x = 28.65f, offsetX = -64.53f, offsetY = -20.18f, speed = 0.7f},
                    }
                }
            },
            {
                62, new FishRoadList()
                {
                    RoadName = "XSY17", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 20.17f, x = -14.18f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -5.82f, x = 34.8f, offsetX = -41.36f, offsetY = -23.89f, speed = 0.7f},
                    }
                }
            },
            {
                63, new FishRoadList()//-1
                {
                    RoadName = "XSZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 16.72f, x = -6.62f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.8f, x = -25.4f, offsetX = 29.12f, offsetY = -13.83f, speed = 1f},
                    }
                }
            },
            {
                64, new FishRoadList()
                {
                    RoadName = "XSZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 16.72f, x = -6.62f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.8f, x = -25.4f, offsetX = 78.34f, offsetY = -10.45f, speed = 1f},
                    }
                }
            },
            {
                65, new FishRoadList()
                {
                    RoadName = "XSZ03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.69f, x = 14.38f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -3.41f, x = -23.94f, offsetX = 18.32f, offsetY = -17.88f, speed = 1f},
                    }
                }
            },
            {
                66, new FishRoadList()
                {
                    RoadName = "XSZ04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.69f, x = 14.38f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -7.79f, x = -25.98f, offsetX = 27.88f, offsetY = -9.56f, speed = 0.6f},
                    }
                }
            },
            {
                67, new FishRoadList()
                {
                    RoadName = "XSZ13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.59f, x = 9.71f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -7.17f, x = -26.38f, offsetX = 60.85f, offsetY = -19.2f, speed = 0.7f},
                    }
                }
            },
            {
                68, new FishRoadList()//-1
                {
                    RoadName = "XXS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.05f, x = -0.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 12.88f, x = -1.59f, offsetX = 49.04f, offsetY = -2.32f, speed = 1f},
                    }
                }
            },
            {
                69, new FishRoadList()
                {
                    RoadName = "XXS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.05f, x = -0.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 12.88f, x = -1.59f, offsetX = -40.81f, offsetY = -2.74f, speed = 1f},
                    }
                }
            },
            {
                70, new FishRoadList()
                {
                    RoadName = "XXS10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.91f, x = -1.02f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.76f, x = 30f, offsetX = -22.23f, offsetY = 19.31f, speed = 0.7f},
                        new FishRoad() {y = 2.1f, x = -30f, offsetX = 0.97f, offsetY = -25.25f, speed = 0.7f},
                        new FishRoad() {y = 5.12f, x = 30f, offsetX = -11.54f, offsetY = 17.05f, speed = 0.7f},
                        new FishRoad() {y = 15.59f, x = -12.57f, offsetX = -16.62f, offsetY = -19.31f, speed = 0.7f},
                    }
                }
            },
            {
                71, new FishRoadList()
                {
                    RoadName = "XXS11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.54f, x = -0.05f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.38f, x = -27.62f, offsetX = 8.74f, offsetY = 11.33f, speed = 0.7f},
                        new FishRoad() {y = 2.05f, x = 30.96f, offsetX = -5.29f, offsetY = -23.52f, speed = 0.7f},
                        new FishRoad() {y = 17.86f, x = -16.67f, offsetX = -12.08f, offsetY = -29.48f, speed = 0.7f},
                    }
                }
            },
            {
                72, new FishRoadList()
                {
                    RoadName = "XXS12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.48f, x = -15f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 16.56f, x = 12.52f, offsetX = 22.55f, offsetY = -32.91f, speed = 0.7f},
                        new FishRoad() {y = -15.87f, x = 13.97f, offsetX = -65.71f, offsetY = 10.49f, speed = 0.7f},
                    }
                }
            },
            {
                73, new FishRoadList()
                {
                    RoadName = "XXS13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.64f, x = -10.52f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = -1.73f, x = 27.19f, offsetX = 4.53f, offsetY = 29.99f, speed = 0.7f},
                        new FishRoad() {y = 18.23f, x = 3.56f, offsetX = -29.78f, offsetY = -27.73f, speed = 0.7f},
                        new FishRoad() {y = 0.97f, x = -28.38f, offsetX = 29.13f, offsetY = -13.49f, speed = 0.7f},
                        new FishRoad() {y = 15f, x = 15.16f, offsetX = 25.14f, offsetY = -19.55f, speed = 0.7f},
                    }
                }
            },
            {
                74, new FishRoadList()
                {
                    RoadName = "XXS17", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -20.69f, x = -14.47f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 22.57f, x = 12.51f, offsetX = 14.3f, offsetY = -44.22f, speed = 0.7f},
                        new FishRoad() {y = -21.85f, x = -20.58f, offsetX = 32.63f, offsetY = 21.67f, speed = 0.7f},
                    }
                }
            },
            {
                75, new FishRoadList()//-1
                {
                    RoadName = "XXY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.05f, x = -0.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.26f, x = -25.85f, offsetX = 7.7f, offsetY = 18.5f, speed = 1f},
                    }
                }
            },
            {
                76, new FishRoadList()
                {
                    RoadName = "XXY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.05f, x = -0.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.26f, x = -25.85f, offsetX = 78.78f, offsetY = 27.79f, speed = 1f},
                    }
                }
            },
            {
                77, new FishRoadList()
                {
                    RoadName = "XXY15", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.94f, x = -12.52f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 1.19f, x = 28.48f, offsetX = -16.51f, offsetY = 50.82f, speed = 0.7f},
                    }
                }
            },
            {
                78, new FishRoadList()
                {
                    RoadName = "XXZ14", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.18f, x = 10.63f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.97f, x = -28.91f, offsetX = 50.82f, offsetY = 31.29f, speed = 0.7f},
                    }
                }
            },
            {
                79, new FishRoadList()
                {
                    RoadName = "XXZ16", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14.91f, x = 10.56f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 11.83f, x = -30.55f, offsetX = 49.08f, offsetY = 8.41f, speed = 0.7f},
                    }
                }
            },
            {
                80, new FishRoadList()
                {
                    RoadName = "XYS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.3f, x = 24.74f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.45f, x = -16.77f, offsetX = -3.63f, offsetY = -31.16f, speed = 1f},
                    }
                }
            },
            {
                81, new FishRoadList()
                {
                    RoadName = "XYS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.3f, x = 24.74f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.14f, x = -0.89f, offsetX = -53.47f, offsetY = -24.17f, speed = 1f},
                    }
                }
            },
            {
                82, new FishRoadList()
                {
                    RoadName = "XYS03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 4.43f, x = 25.63f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.14f, x = -0.89f, offsetX = -53.47f, offsetY = -24.17f, speed = 1f},
                    }
                }
            },
            {
                83, new FishRoadList()
                {
                    RoadName = "XYS13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.24f, x = 30.59f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.83f, x = -1.29f, offsetX = -67.86f, offsetY = -34.22f, speed = 1f},
                    }
                }
            },
            {
                84, new FishRoadList()
                {
                    RoadName = "XYX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.4f, x = 25.05f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -15.97f, x = -0.58f, offsetX = -19.21f, offsetY = 17.95f, speed = 1f},
                    }
                }
            },
            {
                85, new FishRoadList()
                {
                    RoadName = "XYX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9.47f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -15.97f, x = -0.58f, offsetX = -52.93f, offsetY = 27.6f, speed = 0.4f},
                    }
                }
            },
            {
                86, new FishRoadList()
                {
                    RoadName = "XYX03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 26.02f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -15.97f, x = -0.58f, offsetX = -49.92f, offsetY = 55.04f, speed = 0.6f},
                    }
                }
            },
            {
                87, new FishRoadList()
                {
                    RoadName = "XYX14", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.07f, x = 29.83f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 14.78f, x = -6.58f, offsetX = -36.25f, offsetY = -19.2f, speed = 0.7f},
                        new FishRoad() {y = -16.13f, x = 12.84f, offsetX = -20.82f, offsetY = 3.56f, speed = 0.7f},
                    }
                }
            },
            {
                88, new FishRoadList()
                {
                    RoadName = "XYX15", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -1.83f, x = 26.38f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 17.91f, x = -6.69f, offsetX = -25.35f, offsetY = -32.58f, speed = 0.7f},
                        new FishRoad() {y = -15.43f, x = 9.93f, offsetX = -37.11f, offsetY = 11.11f, speed = 0.7f},
                    }
                }
            },
            {
                89, new FishRoadList()
                {
                    RoadName = "XYX16", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5.57f, x = 20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = 0.59f, x = -32.51f, offsetX = 19.65f, offsetY = -21.7f, speed = 0.7f},
                        new FishRoad() {y = -2.93f, x = 29.13f, offsetX = -15.45f, offsetY = 27f, speed = 0.7f},
                        new FishRoad() {y = -16.96f, x = -12.56f, offsetX = -11.93f, offsetY = 46.05f, speed = 0.7f},
                    }
                }
            },
            {
                90, new FishRoadList()
                {
                    RoadName = "XYZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -1.73f, x = 26.51f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.24f, x = -25.49f, offsetX = 8.23f, offsetY = 23.37f, speed = 1f},
                    }
                }
            },
            {
                91, new FishRoadList()
                {
                    RoadName = "XYZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -9.6f, x = 26.38f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.24f, x = -25.49f, offsetX = 3.8f, offsetY = 47.53f, speed = 0.6f},
                    }
                }
            },
            {
                92, new FishRoadList()
                {
                    RoadName = "XYZ03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 11.02f, x = 25.98f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -3.81f, x = -27.13f, offsetX = 8.19f, offsetY = -38.75f, speed = 0.4f},
                    }
                }
            },
            {
                93, new FishRoadList()
                {
                    RoadName = "XYZ04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.39f, x = 25.1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 10.71f, x = -24.79f, offsetX = -3.36f, offsetY = -25.14f, speed = 0.6f},
                    }
                }
            },
            {
                94, new FishRoadList()
                {
                    RoadName = "XYZ05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -1.42f, x = 26.2f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.22f, x = -25.94f, offsetX = 8.67f, offsetY = -22.75f, speed = 0.7f},
                    }
                }
            },
            {
                95, new FishRoadList()
                {
                    RoadName = "XYZ10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.81f, x = 20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = 6.77f, x = -0.54f, offsetX = 0f, offsetY = 7.81f, speed = 0.7f},
                        new FishRoad() {y = -1.68f, x = -30f, offsetX = -7.61f, offsetY = 7.81f, speed = 0.7f},
                        new FishRoad() {y = -5.48f, x = -0.62f, offsetX = -8.63f, offsetY = -4.75f, speed = 0.7f},
                        new FishRoad() {y = -0.43f, x = 30.52f, offsetX = -2.23f, offsetY = -5.46f, speed = 0.7f},
                    }
                }
            },
            {
                96, new FishRoadList()
                {
                    RoadName = "XYZ11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.02f, x = 30.48f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 8.31f, x = -27.19f, offsetX = -10.25f, offsetY = -19.2f, speed = 0.7f},
                        new FishRoad() {y = -15.43f, x = 12.89f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                97, new FishRoadList()
                {
                    RoadName = "XYZ12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.8f, x = 29.72f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.22f, x = -31.13f, offsetX = 20.07f, offsetY = -26.76f, speed = 0.7f},
                    }
                }
            },
            {
                98, new FishRoadList()
                {
                    RoadName = "XYZ17", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.46f, x = 20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = 23.75f, x = -1.38f, offsetX = -46.92f, offsetY = -39.43f, speed = 0.7f},
                        new FishRoad() {y = -21.62f, x = -0.4f, offsetX = 25.82f, offsetY = 16.14f, speed = 0.7f},
                        new FishRoad() {y = 11.82f, x = -31.76f, offsetX = 43.81f, offsetY = 12.1f, speed = 0.7f},
                    }
                }
            },
            {
                99, new FishRoadList()
                {
                    RoadName = "XZS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -8.6f, x = -23.94f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.29f, x = 0.53f, offsetX = 26.91f, offsetY = -20.71f, speed = 0.6f},
                    }
                }
            },
            {
                100, new FishRoadList()
                {
                    RoadName = "XZS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.58f, x = -25.4f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.29f, x = 0.53f, offsetX = 48.42f, offsetY = -38.59f, speed = 0.4f},
                    }
                }
            },
            {
                101, new FishRoadList()
                {
                    RoadName = "XZS03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.58f, x = -25.4f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.71f, x = 12.92f, offsetX = 28.06f, offsetY = -46.74f, speed = 0.6f},
                    }
                }
            },
            {
                102, new FishRoadList()
                {
                    RoadName = "XZS04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 2.3f, x = -25.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.45f, x = 16.91f, offsetX = 17.88f, offsetY = -16.38f, speed = 1f},
                    }
                }
            },
            {
                103, new FishRoadList()
                {
                    RoadName = "XZS15", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.24f, x = -25.62f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 8.47f, x = 27.3f, offsetX = 5.61f, offsetY = -23.74f, speed = 0.7f},
                        new FishRoad() {y = 16.18f, x = -15.91f, offsetX = -14.57f, offsetY = -53.1f, speed = 0.7f},
                    }
                }
            },
            {
                104, new FishRoadList()
                {
                    RoadName = "XZS16", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.49f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = 19.21f, x = 14.71f, offsetX = 22.78f, offsetY = -34.41f, speed = 0.7f},
                        new FishRoad() {y = -6.06f, x = 28.89f, offsetX = -75.28f, offsetY = -12.42f, speed = 0.7f},
                        new FishRoad() {y = 17.94f, x = -17.21f, offsetX = -25.91f, offsetY = -23.25f, speed = 0.7f},
                    }
                }
            },
            {
                105, new FishRoadList()
                {
                    RoadName = "XZS17", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 2.77f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = -5.59f, x = 31.93f, offsetX = -3.46f, offsetY = 28.71f, speed = 0.7f},
                        new FishRoad() {y = -22.65f, x = -22.31f, offsetX = -9.57f, offsetY = 65.6f, speed = 0.7f},
                        new FishRoad() {y = 20.06f, x = 15.16f, offsetX = 5.65f, offsetY = -22.5f, speed = 0.7f},
                    }
                }
            },
            {
                106, new FishRoadList()
                {
                    RoadName = "XZX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 2.3f, x = -25.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -18.79f, x = 0.62f, offsetX = 50.46f, offsetY = 52.1f, speed = 0.6f},
                    }
                }
            },
            {
                107, new FishRoadList()
                {
                    RoadName = "XZX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 2.3f, x = -25.8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -18.79f, x = 0.62f, offsetX = 35.32f, offsetY = 25.45f, speed = 0.4f},
                    }
                }
            },
            {
                108, new FishRoadList()
                {
                    RoadName = "XZX03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9.25f, x = -24.92f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -16.38f, x = 17.98f, offsetX = 0f, offsetY = 0f, speed = 0.6f},
                    }
                }
            },
            {
                109, new FishRoadList()
                {
                    RoadName = "XZX12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -1.67f, x = -27.4f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 16.29f, x = 16.29f, offsetX = 25.25f, offsetY = -26.11f, speed = 0.7f},
                        new FishRoad() {y = -16.02f, x = -15.81f, offsetX = -19.53f, offsetY = 9.28f, speed = 0.7f},
                    }
                }
            },
            {
                110, new FishRoadList()
                {
                    RoadName = "XZY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.56f, x = -24.47f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.65f, x = 27.22f, offsetX = -2.57f, offsetY = -13.12f, speed = 1f},
                    }
                }
            },
            {
                111, new FishRoadList()
                {
                    RoadName = "XZY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.56f, x = -24.47f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.65f, x = 27.22f, offsetX = -4.16f, offsetY = -40.03f, speed = 0.4f},
                    }
                }
            },
            {
                112, new FishRoadList()
                {
                    RoadName = "XZY03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.56f, x = -24.47f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.15f, x = 26.95f, offsetX = -28.24f, offsetY = -18.5f, speed = 0.6f},
                    }
                }
            },
            {
                113, new FishRoadList()
                {
                    RoadName = "XZY04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.56f, x = -24.47f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9.83f, x = 26.2f, offsetX = -9.47f, offsetY = 15.84f, speed = 1f},
                    }
                }
            },
            {
                114, new FishRoadList()
                {
                    RoadName = "XZY05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.31f, x = -24.96f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9.83f, x = 26.2f, offsetX = -4.51f, offsetY = 22.48f, speed = 1f},
                    }
                }
            },
            {
                115, new FishRoadList()
                {
                    RoadName = "XZY06", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -8.19f, x = -23.94f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = -10f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 4f, x = 10f, offsetX = 0f, offsetY = 0f, speed = 4f},
                        new FishRoad() {y = 8f, x = 26.2f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                116, new FishRoadList()
                {
                    RoadName = "XZY10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.81f, x = -20f, offsetX = 0f, offsetY = 0f, speed = 0.9f},
                        new FishRoad() {y = 6.77f, x = 0.54f, offsetX = 0f, offsetY = 7.81f, speed = 0.7f},
                        new FishRoad() {y = -1.68f, x = 30f, offsetX = 7.61f, offsetY = 7.81f, speed = 0.7f},
                        new FishRoad() {y = -5.48f, x = 0.62f, offsetX = 8.63f, offsetY = -4.75f, speed = 0.7f},
                        new FishRoad() {y = -0.43f, x = -30.52f, offsetX = 2.23f, offsetY = -5.46f, speed = 0.7f},
                    }
                }
            },
            {
                117, new FishRoadList()
                {
                    RoadName = "XZY11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 1.51f, x = -28.81f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0.22f, x = 28.75f, offsetX = 4.86f, offsetY = 17.69f, speed = 0.7f},
                        new FishRoad() {y = -3.24f, x = -28.81f, offsetX = 2.48f, offsetY = -15.97f, speed = 0.7f},
                    }
                }
            },
            {
                118, new FishRoadList()
                {
                    RoadName = "XZY13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.34f, x = -24.28f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 18.5f, x = 11.22f, offsetX = 6.58f, offsetY = -40.68f, speed = 0.7f},
                        new FishRoad() {y = -7.39f, x = 26.7f, offsetX = -71.64f, offsetY = -13.81f, speed = 0.7f},
                    }
                }
            },
            {
                119, new FishRoadList()
                {
                    RoadName = "XZY14", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 4.86f, x = -24.76f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 3.18f, x = 27.46f, offsetX = -1.94f, offsetY = -31.5f, speed = 0.7f},
                    }
                }
            },
            {
                120, new FishRoadList()//-1
                {
                    RoadName = "YOUZUO", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.4f},
                        new FishRoad() {y = 0f, x = -45f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.4f},
                    }
                }
            },
            {
                121, new FishRoadList()
                {
                    RoadName = "ZSX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.78f, x = -0.43f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -16.48f, x = 0.86f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                122, new FishRoadList()
                {
                    RoadName = "ZSX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.98f, x = 13.02f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -19.23f, x = -14.13f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                    }
                }
            },
            {
                123, new FishRoadList()
                {
                    RoadName = "ZSY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13.78f, x = -16.61f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9.62f, x = 24.71f, offsetX = -36.01f, offsetY = -10.26f, speed = 0.5f},
                    }
                }
            },
            {
                124, new FishRoadList()
                {
                    RoadName = "ZSY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13.81f, x = -12.53f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 4.54f, x = 24.86f, offsetX = -36.3f, offsetY = -38.57f, speed = 0.25f},
                    }
                }
            },
            {
                125, new FishRoadList()
                {
                    RoadName = "ZSZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.45f, x = 13.47f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -6.51f, x = -24.51f, offsetX = 37.98f, offsetY = -5.82f, speed = 0.5f},
                    }
                }
            },
            {
                126, new FishRoadList()
                {
                    RoadName = "ZSZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14.21f, x = 21.65f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.22f, x = -23.58f, offsetX = 36.1f, offsetY = -23.28f, speed = 0.5f},
                    }
                }
            },
            {
                127, new FishRoadList()
                {
                    RoadName = "ZUOYOU", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -45f, offsetX = 0f, offsetY = 0f, speed = 0.4f},
                        new FishRoad() {y = 0f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 0f, x = -45f, offsetX = 0f, offsetY = 0f, speed = 0.4f},
                    }
                }
            },
            {
                128, new FishRoadList()
                {
                    RoadName = "ZXS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15.04f, x = -14.49f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2.06f, x = -2.49f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.85f, x = 2.09f, offsetX = 23.73f, offsetY = -9.02f, speed = 1f},
                    }
                }
            },
            {
                129, new FishRoadList()
                {
                    RoadName = "ZXS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14.28f, x = 0.49f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.09f, x = 0.81f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                130, new FishRoadList()
                {
                    RoadName = "ZXY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.62f, x = -15.73f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 8.34f, x = 25.55f, offsetX = -44.79f, offsetY = 9.96f, speed = 0.25f},
                    }
                }
            },
            {
                131, new FishRoadList()
                {
                    RoadName = "ZXY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.38f, x = 12.23f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2.27f, x = 25.25f, offsetX = -76.16f, offsetY = 24.86f, speed = 0.5f},
                    }
                }
            },
            {
                132, new FishRoadList()
                {
                    RoadName = "ZXZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.23f, x = 7.45f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 5.72f, x = -28.23f, offsetX = 64.65f, offsetY = 22.49f, speed = 0.6f},
                    }
                }
            },
            {
                133, new FishRoadList()
                {
                    RoadName = "ZXZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14.8f, x = 16.38f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -3.5f, x = -25.98f, offsetX = 13.49f, offsetY = 33.15f, speed = 0.5f},
                    }
                }
            },
            {
                134, new FishRoadList()
                {
                    RoadName = "ZYS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -11.89f, x = 24.76f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 14.53f, x = -22.89f, offsetX = 0f, offsetY = 0f, speed = 0.6f},
                    }
                }
            },
            {
                135, new FishRoadList()
                {
                    RoadName = "ZYS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.84f, x = 26.63f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15.24f, x = -24.31f, offsetX = -20.64f, offsetY = -35.32f, speed = 0.6f},
                    }
                }
            },
            {
                136, new FishRoadList()
                {
                    RoadName = "ZYX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9.96f, x = 24.17f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -13.76f, x = -25.45f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                    }
                }
            },
            {
                137, new FishRoadList()
                {
                    RoadName = "ZYX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.84f, x = 40f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -20.53f, x = -1.81f, offsetX = -56.86f, offsetY = 47.96f, speed = 0.6f},
                    }
                }
            },
            {
                138, new FishRoadList()
                {
                    RoadName = "ZYZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.41f, x = 24.46f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.16f, x = -25.57f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                139, new FishRoadList()
                {
                    RoadName = "ZYZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.92f, x = 27.38f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.16f, x = -25.57f, offsetX = 11.21f, offsetY = -28.86f, speed = 0.7f},
                    }
                }
            },
            {
                140, new FishRoadList()
                {
                    RoadName = "ZYZ03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9.12f, x = 24.01f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9.19f, x = -25.69f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                141, new FishRoadList()
                {
                    RoadName = "ZZS01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -8.88f, x = -24.76f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 16.27f, x = 16.67f, offsetX = 16.08f, offsetY = -23.46f, speed = 0.7f},
                    }
                }
            },
            {
                142, new FishRoadList()
                {
                    RoadName = "ZZS02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -9.12f, x = -24.86f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -0.44f, x = 24.46f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                        new FishRoad() {y = 15.54f, x = -15.73f, offsetX = -13.42f, offsetY = -11.74f, speed = 0.7f},
                    }
                }
            },
            {
                143, new FishRoadList()
                {
                    RoadName = "ZZX01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5.69f, x = -24.91f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -17.21f, x = 2.9f, offsetX = 47.88f, offsetY = 30.56f, speed = 0.7f},
                    }
                }
            },
            {
                144, new FishRoadList()
                {
                    RoadName = "ZZX02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.89f, x = -24.82f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -17.21f, x = 2.9f, offsetX = 56.26f, offsetY = 58.15f, speed = 0.7f},
                    }
                }
            },
            {
                145, new FishRoadList()
                {
                    RoadName = "ZZY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.89f, x = -24.26f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 6.92f, x = 26.04f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                146, new FishRoadList()
                {
                    RoadName = "ZZY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7.02f, x = -22.14f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0.89f, x = 25.65f, offsetX = -15.87f, offsetY = 27.53f, speed = 0.7f},
                        new FishRoad() {y = -14.06f, x = -28.83f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                147, new FishRoadList()
                {
                    RoadName = "ZZY03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.98f, x = -23.08f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -8.16f, x = 25.68f, offsetX = 0f, offsetY = 0f, speed = 0.7f},
                    }
                }
            },
            {
                148, new FishRoadList()
                {
                    RoadName = "ZZY04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 6.98f, x = -23.08f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1.61f, x = 27.43f, offsetX = -41.66f, offsetY = -4.4f, speed = 0.7f},
                    }
                }
            },
            {
                149, new FishRoadList()
                {
                    RoadName = "ZZZ01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -2.65f, x = -24.1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -5.82f, x = 10.56f, offsetX = 10.65f, offsetY = -8.98f, speed = 0.3f},
                        new FishRoad() {y = 6.31f, x = 10.95f, offsetX = 15.09f, offsetY = 0.1f, speed = 0.8f},
                        new FishRoad() {y = 7.39f, x = -24.44f, offsetX = -7.04f, offsetY = -6.98f, speed = 0.3f},
                    }
                }
            },
            {
                150, new FishRoadList()
                {
                    RoadName = "ZZZ02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -10.06f, x = 23.28f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 17.52f, x = -18.37f, offsetX = -15.25f, offsetY = -18.76f, speed = 0.3f},
                    }
                }
            },
            {
                151, new FishRoadList()
                {
                    RoadName = "ZZZ03", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.54f, x = 12.28f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -16.97f, x = -13.96f, offsetX = 38.18f, offsetY = 2.66f, speed = 0.3f},
                    }
                }
            },
            {
                152, new FishRoadList()
                {
                    RoadName = "ZZZ04", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.37f, x = 13.21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 17.21f, x = -20.86f, offsetX = 35.81f, offsetY = -3.26f, speed = 0.3f},
                    }
                }
            },
            {
                153, new FishRoadList()
                {
                    RoadName = "ZZZ05", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5.23f, x = -24.22f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 20.17f, x = 7.18f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = -6.56f, x = 26.3f, offsetX = -44.02f, offsetY = -8.68f, speed = 0.3f},
                    }
                }
            },
            {
                154, new FishRoadList()
                {
                    RoadName = "ZZZ06", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15.19f, x = -7.94f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9.96f, x = 30.14f, offsetX = -77.93f, offsetY = -13.71f, speed = 0.3f},
                    }
                }
            },
            {
                155, new FishRoadList()
                {
                    RoadName = "ZZZ07", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -0.69f, x = 23.18f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 8.83f, x = -26.83f, offsetX = -9.47f, offsetY = -24.76f, speed = 0.3f},
                    }
                }
            },
            {
                156, new FishRoadList()
                {
                    RoadName = "ZZZ08", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -16.13f, x = 10.06f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 13.18f, x = -25.36f, offsetX = 53.59f, offsetY = -2.29f, speed = 0.3f},
                    }
                }
            },
            {
                157, new FishRoadList()
                {
                    RoadName = "JINGYU", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -13.97f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 35f, x = 35f, offsetX = 0f, offsetY = -40f, speed = 0.35f},
                    }
                }
            },
            {
                158, new FishRoadList()
                {
                    RoadName = "JINGYU1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13.97f, x = 35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -35f, x = -35f, offsetX = 0f, offsetY = 40f, speed = 0.35f},
                    }
                }
            },
            {
                159, new FishRoadList()
                {
                    RoadName = "JINGYU2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13.97f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -35f, x = 35f, offsetX = 0f, offsetY = 40f, speed = 0.35f},
                    }
                }
            },
            {
                160, new FishRoadList()
                {
                    RoadName = "JINGYU3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -13.97f, x = 35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 35f, x = -35f, offsetX = 0f, offsetY = -40f, speed = 0.35f},
                    }
                }
            },
            {
                161, new FishRoadList()
                {
                    RoadName = "ywdjs1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13f, x = -5f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -17f, offsetX = -5.25f, offsetY = 5.25f, speed = 1f},
                        new FishRoad() {y = -9f, x = -8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 13f, x = 15f, offsetX = 10.5f, offsetY = -5.25f, speed = 1f},
                    }
                }
            },
            {
                162, new FishRoadList()
                {
                    RoadName = "ywdjs2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13f, x = 5f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 17f, offsetX = 5.25f, offsetY = 5.25f, speed = 1f},
                        new FishRoad() {y = -9f, x = 8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 13f, x = -15f, offsetX = -10.5f, offsetY = -5.25f, speed = 1f},
                    }
                }
            },
            {
                163, new FishRoadList()
                {
                    RoadName = "ywdjs3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 13f, x = 3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -10f, offsetX = -5.25f, offsetY = 5.25f, speed = 1.33f},
                        new FishRoad() {y = -9f, x = 0f, offsetX = -5.25f, offsetY = -5.25f, speed = 1.33f},
                        new FishRoad() {y = 0f, x = 10f, offsetX = 5.25f, offsetY = -5.25f, speed = 1.33f},
                        new FishRoad() {y = 13f, x = -3f, offsetX = 5.25f, offsetY = 5.25f, speed = 1.33f},
                    }
                }
            },
            {
                164, new FishRoadList()
                {
                    RoadName = "ywdjx1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -13f, x = 5f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 17f, offsetX = 5.25f, offsetY = -5.25f, speed = 1f},
                        new FishRoad() {y = 9f, x = 8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -13f, x = -15f, offsetX = -10.5f, offsetY = 5.25f, speed = 1f},
                    }
                }
            },
            {
                165, new FishRoadList()
                {
                    RoadName = "ywdjx2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -13f, x = -5f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -17f, offsetX = -5.25f, offsetY = -5.25f, speed = 1f},
                        new FishRoad() {y = 9f, x = -8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -13f, x = 15f, offsetX = 10.5f, offsetY = 5.25f, speed = 1f},
                    }
                }
            },
            {
                166, new FishRoadList()
                {
                    RoadName = "ywdjx3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -13f, x = -3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 10f, offsetX = 5.25f, offsetY = -5.25f, speed = 1.33f},
                        new FishRoad() {y = 9f, x = 0f, offsetX = 5.25f, offsetY = 5.25f, speed = 1.33f},
                        new FishRoad() {y = 0f, x = -10f, offsetX = -5.25f, offsetY = 5.25f, speed = 1.33f},
                        new FishRoad() {y = -13f, x = 3f, offsetX = -5.25f, offsetY = -5.25f, speed = 1.33f},
                    }
                }
            },
            {
                167, new FishRoadList()
                {
                    RoadName = "ywdjy1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -11f, x = 21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 9f, x = 0f, offsetX = 5.25f, offsetY = 10.5f, speed = 0.66f},
                        new FishRoad() {y = -11f, x = -21f, offsetX = -10.5f, offsetY = 5.25f, speed = 0.66f},
                    }
                }
            },
            {
                168, new FishRoadList()
                {
                    RoadName = "ywdjy2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 11f, x = 21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9f, x = 0f, offsetX = 5.25f, offsetY = -10.5f, speed = 0.66f},
                        new FishRoad() {y = 11f, x = -21f, offsetX = -10.5f, offsetY = -5.25f, speed = 0.66f},
                    }
                }
            },
            {
                169, new FishRoadList()
                {
                    RoadName = "ywdjy3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -1f, x = 21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 9f, x = 10f, offsetX = 5.25f, offsetY = 5.25f, speed = 1f},
                        new FishRoad() {y = -9f, x = -10f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 1f, x = -21f, offsetX = -5.25f, offsetY = -5.25f, speed = 1f},
                    }
                }
            },
            {
                170, new FishRoadList()
                {
                    RoadName = "ywdjz1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 11f, x = -21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9f, x = 0f, offsetX = -5.25f, offsetY = -10.5f, speed = 0.66f},
                        new FishRoad() {y = 11f, x = 21f, offsetX = 10.5f, offsetY = -5.25f, speed = 0.66f},
                    }
                }
            },
            {
                171, new FishRoadList()
                {
                    RoadName = "ywdjz2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -11f, x = -21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 9f, x = 0f, offsetX = -5.25f, offsetY = 10.5f, speed = 0.66f},
                        new FishRoad() {y = -11f, x = 21f, offsetX = 10.5f, offsetY = 5.25f, speed = 0.66f},
                    }
                }
            },
            {
                172, new FishRoadList()
                {
                    RoadName = "ywdjz3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 1f, x = -21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -9f, x = -10f, offsetX = -5.25f, offsetY = -5.25f, speed = 1f},
                        new FishRoad() {y = 9f, x = 10f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -1f, x = 21f, offsetX = 5.25f, offsetY = 5.25f, speed = 1f},
                    }
                }
            },
            {
                173, new FishRoadList()
                {
                    RoadName = "djzyy1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5, x = 21, offsetX = 0, offsetY = 0, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = -21, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = -21, offsetX = -10, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = 21, offsetX = 0, offsetY = -10, speed = 1},
                    }
                }
            },
            {
                174, new FishRoadList()
                {
                    RoadName = "djzyy2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5, x = 21, offsetX = 0, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = -21, offsetX = 5, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = -21, offsetX = -10, offsetY = 0, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = 21, offsetX = 0, offsetY = 10, speed = 1},
                    }
                }
            },
            {
                175, new FishRoadList()
                {
                    RoadName = "djzyy3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5, x = 21, offsetX = 0, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = -21, offsetX = 5, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = -21, offsetX = -10, offsetY = 0, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = 21, offsetX = 0, offsetY = -10, speed = 1},
                    }
                }
            },
            {
                176, new FishRoadList()
                {
                    RoadName = "djzyy4", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5, x = 21, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = -21, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = -21, offsetX = -10, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = 21, offsetX = 0, offsetY = 10, speed = 1},
                    }
                }
            },
            {
                177, new FishRoadList()
                {
                    RoadName = "djzyz1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5, x = -21, offsetX = 0, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = 21, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = 21, offsetX = 10, offsetY = 0, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = -21, offsetX = 0, offsetY = 10, speed = 1},
                    }
                }
            },
            {
                178, new FishRoadList()
                {
                    RoadName = "djzyz2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5, x = -21, offsetX = 0, offsetY = 0, speed = 1},
                        new FishRoad() {y = -5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = -5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = -5, x = 21, offsetX = 5, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = 21, offsetX = 10, offsetY = 0, speed = 1},
                        new FishRoad() {y = 5, x = 5, offsetX = 0, offsetY = -10, speed = 1},
                        new FishRoad() {y = 5, x = -5, offsetX = 0, offsetY = 10, speed = 1},
                        new FishRoad() {y = 5, x = -21, offsetX = 0, offsetY = -10, speed = 1},
                    }
                }
            },
            {
                179, new FishRoadList()
                {
                    RoadName = "djzyz3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -5f, x = -21f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -5f, x = -5f, offsetX = 0f, offsetY = -10f, speed = 1f},
                        new FishRoad() {y = -5f, x = 5f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = -5f, x = 21f, offsetX = 5f, offsetY = -10f, speed = 1f},
                        new FishRoad() {y = 5f, x = 21f, offsetX = 10f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 5f, x = 5f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = 5f, x = -5f, offsetX = 0f, offsetY = -10f, speed = 1f},
                        new FishRoad() {y = 5f, x = -21f, offsetX = 0f, offsetY = 10f, speed = 1f},
                    }
                }
            },
            {
                180, new FishRoadList()
                {
                    RoadName = "djzyz4", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 5f, x = -21f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = 5f, x = -5f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = 5f, x = 5f, offsetX = 0f, offsetY = -10f, speed = 1f},
                        new FishRoad() {y = 5f, x = 21f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = -5f, x = 21f, offsetX = 10f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -5f, x = 5f, offsetX = 0f, offsetY = -10f, speed = 1f},
                        new FishRoad() {y = -5f, x = -5f, offsetX = 0f, offsetY = 10f, speed = 1f},
                        new FishRoad() {y = -5f, x = -21f, offsetX = 0f, offsetY = -10f, speed = 1f},
                    }
                }
            },
            {
                181, new FishRoadList()
                {
                    RoadName = "jbpsy1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 0f, offsetY = 0f, y = 15f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -13f, offsetY = 7f, y = 2f, offsetX = 0f, speed = 0.8f},
                        new FishRoad() {x = 0f, offsetY = -7f, y = -5f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 13f, offsetY = -7f, y = 2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 0f, offsetY = 7f, y = 9f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -23f, offsetY = 7f, y = 2f, offsetX = 0f, speed = 0.7f},
                    }
                }
            },
            {
                182, new FishRoadList()
                {
                    RoadName = "jbpsz1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 0f, offsetY = 0f, y = 15f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 13f, offsetY = 7f, y = 2f, offsetX = 0f, speed = 0.8f},
                        new FishRoad() {x = 0f, offsetY = -7f, y = -5f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -13f, offsetY = -7f, y = 2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 0f, offsetY = 7f, y = 9f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 23f, offsetY = 7f, y = 2f, offsetX = 0f, speed = 0.7f},
                    }
                }
            },
            {
                183, new FishRoadList()
                {
                    RoadName = "jbpxy1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 0f, offsetY = 0f, y = -15f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -13f, offsetY = -7f, y = -2f, offsetX = 0f, speed = 0.8f},
                        new FishRoad() {x = 0f, offsetY = 7f, y = 5f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 13f, offsetY = 7f, y = -2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 0f, offsetY = -7f, y = -9f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -23f, offsetY = -7f, y = -2f, offsetX = 0f, speed = 0.7f},
                    }
                }
            },
            {
                184, new FishRoadList()
                {
                    RoadName = "jbpxz1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 0f, offsetY = 0f, y = -15f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 13f, offsetY = -7f, y = -2f, offsetX = 0f, speed = 0.8f},
                        new FishRoad() {x = 0f, offsetY = 7f, y = 5f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -13f, offsetY = 7f, y = -2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 0f, offsetY = -7f, y = -9f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 23f, offsetY = -7f, y = -2f, offsetX = 0f, speed = 0.7f},
                    }
                }
            },
            {
                185, new FishRoadList()
                {
                    RoadName = "jbpys1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 23f, offsetY = 0f, y = 6f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -9f, offsetY = -7f, y = -5f, offsetX = 0f, speed = 0.45f},
                        new FishRoad() {x = -23f, offsetY = -8f, y = 1f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 27f, offsetY = 17f, y = 2f, offsetX = -8f, speed = 0.3f},
                    }
                }
            },
            {
                186, new FishRoadList()
                {
                    RoadName = "jbpyx1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 23f, offsetY = 0f, y = -6f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -9f, offsetY = 7f, y = 5f, offsetX = 0f, speed = 0.45f},
                        new FishRoad() {x = -23f, offsetY = 8f, y = -1f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 27f, offsetY = -17f, y = -2f, offsetX = -8f, speed = 0.3f},
                    }
                }
            },
            {
                187, new FishRoadList()
                {
                    RoadName = "jbpyz", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = 22f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -22f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 0.26f},
                        new FishRoad() {x = 26f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 0.28f},
                    }
                }
            },
            {
                188, new FishRoadList()
                {
                    RoadName = "jbpzs1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = -23f, offsetY = 0f, y = 6f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 9f, offsetY = -7f, y = -5f, offsetX = 0f, speed = 0.45f},
                        new FishRoad() {x = 23f, offsetY = -8f, y = 1f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -27f, offsetY = 17f, y = 2f, offsetX = 8f, speed = 0.3f},
                    }
                }
            },
            {
                189, new FishRoadList()
                {
                    RoadName = "jbpzx1", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = -23f, offsetY = 0f, y = -6f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 9f, offsetY = 7f, y = 5f, offsetX = 0f, speed = 0.45f},
                        new FishRoad() {x = 23f, offsetY = 8f, y = -1f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = -27f, offsetY = -17f, y = -2f, offsetX = 8f, speed = 0.3f},
                    }
                }
            },
            {
                190, new FishRoadList()
                {
                    RoadName = "jbpzz", list = new List<FishRoad>()
                    {
                        new FishRoad() {x = -22f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 1f},
                        new FishRoad() {x = 22f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 0.26f},
                        new FishRoad() {x = -26f, offsetY = 0f, y = -2f, offsetX = 0f, speed = 0.28f},
                    }
                }
            },
            {
                191, new FishRoadList()
                {
                    RoadName = "LJ", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = -3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = -9f, offsetX = 12f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = -15f, offsetX = -12f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                192, new FishRoadList()
                {
                    RoadName = "LJ1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = 3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = 9f, offsetX = -12f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = 15f, offsetX = 12f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                193, new FishRoadList()
                {
                    RoadName = "LJ2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = 3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = 9f, offsetX = -12f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = 15f, offsetX = 12f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                194, new FishRoadList()
                {
                    RoadName = "LJ3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = -3f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = -9f, offsetX = 12f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = -15f, offsetX = -12f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                195, new FishRoadList()
                {
                    RoadName = "LJ4", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = -2f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = -8f, offsetX = 11f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = -14f, offsetX = -11f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                196, new FishRoadList()
                {
                    RoadName = "LJ5", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = 2f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = 8f, offsetX = -11f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = 14f, offsetX = 11f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                197, new FishRoadList()
                {
                    RoadName = "LJ6", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = 2f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = 8f, offsetX = -11f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = 14f, offsetX = 11f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                198, new FishRoadList()
                {
                    RoadName = "LJ7", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = -2f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = -8f, offsetX = 11f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = -14f, offsetX = -11f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                199, new FishRoadList()
                {
                    RoadName = "LJ8", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = -1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = -7f, offsetX = 10f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = -13f, offsetX = -10f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                200, new FishRoadList()
                {
                    RoadName = "LJ9", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = 1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -2f, x = 7f, offsetX = -10f, offsetY = 12f, speed = 2f},
                        new FishRoad() {y = -14f, x = 13f, offsetX = 10f, offsetY = 12f, speed = 2f},
                    }
                }
            },
            {
                201, new FishRoadList()
                {
                    RoadName = "LJ10", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = 1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = 7f, offsetX = -10f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = 13f, offsetX = 10f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                202, new FishRoadList()
                {
                    RoadName = "LJ11", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = -1f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 2f, x = -7f, offsetX = 10f, offsetY = -12f, speed = 2f},
                        new FishRoad() {y = 14f, x = -13f, offsetX = -10f, offsetY = -12f, speed = 2f},
                    }
                }
            },
            {
                203, new FishRoadList()
                {
                    RoadName = "LJ12", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                204, new FishRoadList()
                {
                    RoadName = "LJ13", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 1f},
                    }
                }
            },
            {
                205, new FishRoadList()
                {
                    RoadName = "LJAIXIN", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.6f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0.6f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 0.4f},
                    }
                }
            },
            {
                206, new FishRoadList()
                {
                    RoadName = "LJAIXIN1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0.6f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0.6f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                207, new FishRoadList()
                {
                    RoadName = "LJHUDIE", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = 0f, x = 45, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                208, new FishRoadList()
                {
                    RoadName = "LJHUDIE1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = 0f, x = 35f, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                209, new FishRoadList()
                {
                    RoadName = "LJTINGLIU", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -7.99f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 0f, x = -40f, offsetX = 0f, offsetY = 0f, speed = 2f},
                    }
                }
            },
            {
                210, new FishRoadList()
                {
                    RoadName = "LJTINGLIU1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 8f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 7.99f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 0f, x = 40f, offsetX = 0f, offsetY = 0f, speed = 2f},
                    }
                }
            },
            {
                211, new FishRoadList()
                {
                    RoadName = "LJTINGLIU2", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -8f, offsetX = 0f, offsetY = 0f, speed = 1.3f},
                        new FishRoad() {y = 0f, x = -7.99f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 0f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 1.5f},
                    }
                }
            },
            {
                212, new FishRoadList()
                {
                    RoadName = "LJTINGLIU3", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 8f, offsetX = 0f, offsetY = 0f, speed = 1.3f},
                        new FishRoad() {y = 0f, x = 7.99f, offsetX = 0f, offsetY = 0f, speed = 0.5f},
                        new FishRoad() {y = 0f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 1.5f},
                    }
                }
            },
            {
                213, new FishRoadList()
                {
                    RoadName = "LJWENZI", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -40f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 60f, offsetX = 0f, offsetY = 0f, speed = 0.28f},
                    }
                }
            },
            {
                214, new FishRoadList()
                {
                    RoadName = "LJWUJIAOXING", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -3.5f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = -3.5f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.28f},
                    }
                }
            },
            {
                215, new FishRoadList()
                {
                    RoadName = "LJWUJIAOXING1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 4.4f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = 4.4f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 0.28f},
                    }
                }
            },
            {
                216, new FishRoadList()
                {
                    RoadName = "LJWUXING", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -35f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = 45f, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                217, new FishRoadList()
                {
                    RoadName = "LJWUXING1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 43f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 0f, x = -42f, offsetX = 0f, offsetY = 0f, speed = 0.25f},
                    }
                }
            },
            {
                218, new FishRoadList()
                {
                    RoadName = "LJXY", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 14f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 14f, x = 30f, offsetX = -0.29f, offsetY = -44.42f, speed = 0.8f},
                    }
                }
            },
            {
                219, new FishRoadList()
                {
                    RoadName = "LJXY1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -14f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -14f, x = -30f, offsetX = -0.29f, offsetY = 44.42f, speed = 0.8f},
                    }
                }
            },
            {
                220, new FishRoadList()
                {
                    RoadName = "LJXY01", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 15f, x = -25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = 15f, x = 30f, offsetX = -0.29f, offsetY = -45.42f, speed = 0.8f},
                    }
                }
            },
            {
                221, new FishRoadList()
                {
                    RoadName = "LJXY02", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -15f, x = 25f, offsetX = 0f, offsetY = 0f, speed = 1f},
                        new FishRoad() {y = -15f, x = -30f, offsetX = -0.29f, offsetY = 45.42f, speed = 0.8f},
                    }
                }
            },
            {
                222, new FishRoadList()
                {
                    RoadName = "LJYUANXING", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 0.35f},
                        new FishRoad() {y = 0f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                223, new FishRoadList()
                {
                    RoadName = "LJYUANXING1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 0f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                        new FishRoad() {y = 0f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 0.3f},
                    }
                }
            },
            {
                224, new FishRoadList()
                {
                    RoadName = "LJZQWG", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -7f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 6f},
                        new FishRoad() {y = -6f, x = 8f, offsetX = 0f, offsetY = 0f, speed = 3f},
                        new FishRoad() {y = 0f, x = 2f, offsetX = -6.03f, offsetY = -4.88f, speed = 4.5f},
                        new FishRoad() {y = 6f, x = 8f, offsetX = -6.72f, offsetY = 5.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 14f, offsetX = 5.37f, offsetY = 5.42f, speed = 4.5f},
                        new FishRoad() {y = -6f, x = 8f, offsetX = 6.42f, offsetY = -3.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 2f, offsetX = -6.03f, offsetY = -4.88f, speed = 4.5f},
                        new FishRoad() {y = 6f, x = 8f, offsetX = -6.72f, offsetY = 5.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 14f, offsetX = 5.37f, offsetY = 5.42f, speed = 4.5f},
                        new FishRoad() {y = -6f, x = 8f, offsetX = 6.42f, offsetY = -3.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 2f, offsetX = -6.03f, offsetY = -4.88f, speed = 4.5f},
                        new FishRoad() {y = 13f, x = 2f, offsetX = 0f, offsetY = 0f, speed = 4.5f},
                    }
                }
            },
            {
                225, new FishRoadList()
                {
                    RoadName = "LJZQWG1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 7f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 6f},
                        new FishRoad() {y = 6f, x = -8f, offsetX = 0f, offsetY = 0f, speed = 3f},
                        new FishRoad() {y = 0f, x = -2f, offsetX = 6.03f, offsetY = 4.88f, speed = 4.5f},
                        new FishRoad() {y = -6f, x = -8f, offsetX = 6.72f, offsetY = -5.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -14f, offsetX = -5.37f, offsetY = -5.42f, speed = 4.5f},
                        new FishRoad() {y = 6f, x = -8f, offsetX = -6.42f, offsetY = 3.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -2f, offsetX = 6.03f, offsetY = 4.88f, speed = 4.5f},
                        new FishRoad() {y = -6f, x = -8f, offsetX = 6.72f, offsetY = -5.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -14f, offsetX = -5.37f, offsetY = -5.42f, speed = 4.5f},
                        new FishRoad() {y = 6f, x = -8f, offsetX = -6.42f, offsetY = 3.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -2f, offsetX = 6.03f, offsetY = 4.88f, speed = 4.5f},
                        new FishRoad() {y = -13f, x = -2f, offsetX = 0f, offsetY = 0f, speed = 4.5f},
                    }
                }
            },
            {
                226, new FishRoadList()
                {
                    RoadName = "LJZQXCY", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = -9f, x = 30f, offsetX = 0f, offsetY = 0f, speed = 6f},
                        new FishRoad() {y = -7f, x = 8.5f, offsetX = 0f, offsetY = 0f, speed = 3f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = -6.53f, offsetY = -5.88f, speed = 4.5f},
                        new FishRoad() {y = 7f, x = 8.5f, offsetX = -7.22f, offsetY = 6.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 16f, offsetX = 5.87f, offsetY = 6.42f, speed = 4.5f},
                        new FishRoad() {y = -7f, x = 8.5f, offsetX = 6.92f, offsetY = -4.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = -6.53f, offsetY = -5.88f, speed = 4.5f},
                        new FishRoad() {y = 7f, x = 8.5f, offsetX = -7.22f, offsetY = 6.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 16f, offsetX = 5.87f, offsetY = 6.42f, speed = 4.5f},
                        new FishRoad() {y = -7f, x = 8.5f, offsetX = 6.92f, offsetY = -4.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = -6.53f, offsetY = -5.88f, speed = 4.5f},
                        new FishRoad() {y = 13f, x = 0f, offsetX = 0f, offsetY = 0f, speed = 4.5f},
                    }
                }
            },
            {
                227, new FishRoadList()
                {
                    RoadName = "LJZQXCY1", list = new List<FishRoad>()
                    {
                        new FishRoad() {y = 9f, x = -30f, offsetX = 0f, offsetY = 0f, speed = 6f},
                        new FishRoad() {y = 7f, x = -8.5f, offsetX = 0f, offsetY = 0f, speed = 3f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = 6.53f, offsetY = 5.88f, speed = 4.5f},
                        new FishRoad() {y = -7f, x = -8.5f, offsetX = 7.22f, offsetY = -6.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -16f, offsetX = -5.87f, offsetY = -6.42f, speed = 4.5f},
                        new FishRoad() {y = 7f, x = -8.5f, offsetX = -6.92f, offsetY = 4.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = 6.53f, offsetY = 5.88f, speed = 4.5f},
                        new FishRoad() {y = -7f, x = -8.5f, offsetX = 7.22f, offsetY = -6.35f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = -16f, offsetX = -5.87f, offsetY = -6.42f, speed = 4.5f},
                        new FishRoad() {y = 7f, x = -8.5f, offsetX = -6.92f, offsetY = 4.98f, speed = 4.5f},
                        new FishRoad() {y = 0f, x = 0f, offsetX = 6.53f, offsetY = 5.88f, speed = 4.5f},
                        new FishRoad() {y = -13f, x = 0f, offsetX = 0f, offsetY = 0f, speed = 4.5f},
                    }
                }
            }
        };
    }


    public class FishRoad
    {
        public float y;
        public float x;
        public float offsetX;
        public float offsetY;
        public float speed;
    }
}