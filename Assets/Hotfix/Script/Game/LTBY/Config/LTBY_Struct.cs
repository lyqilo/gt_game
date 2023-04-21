using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 捕鱼结构体
    /// </summary>
    public class LTBY_Struct
    {
        public class CMD_S_CONFIG
        {
            public CMD_S_CONFIG()
            {
            }

            public CMD_S_CONFIG(ByteBuffer byteBuffer)
            {
                bulletScore = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.BULLET_COUNT; i++)
                {
                    bulletScore.Add(byteBuffer.ReadInt32());
                }

                bGID = byteBuffer.ReadByte();
                playerLockFishID = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
                {
                    playerLockFishID.Add(byteBuffer.ReadInt32());
                }

                playerCurScore = new List<long>();
                for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
                {
                    playerCurScore.Add(byteBuffer.ReadInt64());
                }
            }

            /// <summary>
            /// 子弹分数
            /// </summary>
            public List<int> bulletScore;

            /// <summary>
            /// 背景ID
            /// </summary>
            public byte bGID;

            /// <summary>
            /// 玩家锁定鱼的ID 正为锁定 负为没有锁定
            /// </summary>
            public List<int> playerLockFishID;

            /// <summary>
            /// 玩家当前分数
            /// </summary>
            public List<long> playerCurScore;
        }

        /// <summary>
        /// 玩家炮台等级
        /// </summary>
        public class CMD_S_PlayerGunLevel
        {
            public CMD_S_PlayerGunLevel()
            {
            }

            public CMD_S_PlayerGunLevel(ByteBuffer byteBuffer)
            {
                GunLevel = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
                {
                    GunLevel.Add(byteBuffer.ReadInt32());
                }

                GunType = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
                {
                    GunType.Add(byteBuffer.ReadInt32());
                }
            }

            public List<int> GunLevel;
            public List<int> GunType;
        }

        public class LoadFish
        {
            public LoadFish()
            {
            }

            public LoadFish(ByteBuffer buffer)
            {
                Kind = buffer.ReadByte();
                id = buffer.ReadInt32();
                CreateTime = buffer.ReadInt32();
                EndTime = buffer.ReadInt32();
                // fishPoint = new List<FishPoint>();
                // for (int i = 0; i < LTBY_DataConfig.MAX_FISH_POINT; i++)
                // {
                //     fishPoint.Add(new FishPoint(buffer));
                // }
                nRoad = buffer.ReadInt32();
                cbGroupId = buffer.ReadByte();
                cbGroupNo = buffer.ReadByte();
                NowTime = buffer.ReadInt32();
                mul = buffer.ReadInt32();
                cbStage = buffer.ReadByte();
                cbIsAced = buffer.ReadByte() == 1;
                cbJBPStage = buffer.ReadByte();
                cbJBPMul = buffer.ReadInt32();
                cbJBPScore = buffer.ReadInt32();
            }

            public byte Kind;
            public int id;
            public int CreateTime;

            public int EndTime;

            // public List<FishPoint> fishPoint;
            public int nRoad; //鱼线
            public byte cbGroupId; //鱼阵id
            public byte cbGroupNo; //鱼阵鱼编号
            public int NowTime; //当前已过时间
            public int mul; //倍数
            public byte cbStage; //河豚阶段
            public bool cbIsAced; //是否一网打尽
            public byte cbJBPStage; //聚宝盆阶段
            public int cbJBPMul;//聚宝盆倍数
            public int cbJBPScore;//举报盆下方分数
        }

        public class FishPoint
        {
            public FishPoint()
            {
            }

            public FishPoint(ByteBuffer buffer)
            {
                x = buffer.ReadInt32();
                y = buffer.ReadInt32();
            }

            public int x;
            public int y;
        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        public class CMD_S_PlayerEnter
        {
            public CMD_S_PlayerEnter()
            {
            }

            public CMD_S_PlayerEnter(ByteBuffer buffer)
            {
                szSize = buffer.ReadInt32();
                szLoadFish = new List<LoadFish>();
                for (int i = 0; i < LTBY_DataConfig.MAX_FISH_COUNT; i++)
                {
                    szLoadFish.Add(new LoadFish(buffer));
                }
            }

            public int szSize;
            public List<LoadFish> szLoadFish;
        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        public class CMD_S_Player_YC_Enter
        {
            public CMD_S_Player_YC_Enter()
            {
            }

            public CMD_S_Player_YC_Enter(ByteBuffer buffer)
            {
                szSize = buffer.ReadInt32();
                YcId = buffer.ReadByte();
                szLoadFish = new List<LoadFish>();
                for (int i = 0; i < LTBY_DataConfig.MAX_FISH_YC_COUNT; i++)
                {
                    szLoadFish.Add(new LoadFish(buffer));
                }
            }

            public int szSize;
            public byte YcId;
            public List<LoadFish> szLoadFish;
        }

        /// <summary>
        /// 增加鱼
        /// </summary>
        public class CMD_S_AddFish
        {
            public CMD_S_AddFish()
            {
            }

            public CMD_S_AddFish(ByteBuffer buffer)
            {
                FishCount = buffer.ReadInt32();
                loadFishList = new List<LoadFish>();
                for (int i = 0; i < 20; i++)
                {
                    loadFishList.Add(new LoadFish(buffer));
                }
            }

            public int FishCount;
            public List<LoadFish> loadFishList;
        }

        /// <summary>
        /// 玩家发炮
        /// </summary>
        public class CMD_S_PlayerShoot
        {
            public CMD_S_PlayerShoot()
            {
            }

            public CMD_S_PlayerShoot(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                x = buffer.ReadFloat();
                y = buffer.ReadFloat();
                level = buffer.ReadInt32();
                grade = buffer.ReadInt32();
                playCurScore = buffer.ReadInt64();
            }

            public int wChairID;
            public float x;
            public float y;
            public int level;
            public int grade;
            public long playCurScore;
        }

        /// <summary>
        /// 死亡鱼数据
        /// </summary>
        public class FishData
        {
            public FishData()
            {
            }

            public FishData(ByteBuffer buffer)
            {
                id = buffer.ReadInt32();
                score = buffer.ReadInt32();
            }

            public int id;
            public int score;
        }

        /// <summary>
        /// 鱼死亡
        /// </summary>
        public class CMD_S_FishDead
        {
            public CMD_S_FishDead()
            {
            }

            public CMD_S_FishDead(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fish = new List<FishData>();
                for (int i = 0; i < LTBY_DataConfig.MAX_DEAD_FISH; i++)
                {
                    fish.Add(new FishData(buffer));
                }

                score = buffer.ReadInt64();
            }

            public int wChairID;
            public List<FishData> fish;
            public long score;
            public int electricDragonMultiple;
        }

        /// <summary>
        /// 切换炮台
        /// </summary>
        public class CMD_S_ChangeBulletLevel
        {
            public CMD_S_ChangeBulletLevel()
            {
            }

            public CMD_S_ChangeBulletLevel(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                cbGunType = buffer.ReadByte();
                cbGunLevel = buffer.ReadByte();
            }

            public int wChairID;
            public byte cbGunType;
            public byte cbGunLevel;
        }

        /// <summary>
        /// 鱼潮即将来临
        /// </summary>
        public class CMD_S_YuChaoComePre
        {
            public CMD_S_YuChaoComePre()
            {
            }

            public CMD_S_YuChaoComePre(ByteBuffer buffer)
            {
                backId = buffer.ReadByte();
            }

            public byte backId;
        }

        /// <summary>
        /// 鱼线
        /// </summary>
        public class LineInfo
        {
            public LineInfo()
            {
            }

            public LineInfo(ByteBuffer buffer)
            {
                type = buffer.ReadInt32();
                Points = new List<FishPoint>();
                for (int i = 0; i < 6; i++)
                {
                    Points.Add(new FishPoint(buffer));
                }
            }

            public int type;
            public List<FishPoint> Points;
        }

        public class FishLineInfo
        {
            public FishLineInfo()
            {
            }

            public FishLineInfo(ByteBuffer buffer)
            {
                line = new LineInfo(buffer);
                Kind = buffer.ReadInt32();
                startDelayTime = buffer.ReadInt32();
                delayTime = buffer.ReadInt32();
                fishNum = buffer.ReadInt32();
                livedTime = buffer.ReadInt32();
            }

            public LineInfo line;
            public int Kind;
            public int startDelayTime;
            public int delayTime;
            public int fishNum;
            public int livedTime;
        }

        /// <summary>
        /// 鱼群
        /// </summary>
        public class FishTide
        {
            public FishTide()
            {
            }

            public FishTide(ByteBuffer buffer)
            {
                fishTideStartTime = buffer.ReadInt64();
                fishTideCurTime = buffer.ReadInt64();
                Rotate = buffer.ReadByte();
                lineNum = buffer.ReadInt32();
                fishLines = new List<FishLineInfo>();
                for (int i = 0; i < 50; i++)
                {
                    fishLines.Add(new FishLineInfo(buffer));
                }
            }

            public long fishTideStartTime;
            public long fishTideCurTime;
            public byte Rotate;
            public int lineNum;
            public List<FishLineInfo> fishLines;
        }

        /// <summary>
        /// 鱼潮来临
        /// </summary>
        public class CMD_S_YuChaoCome
        {
            public CMD_S_YuChaoCome()
            {
            }

            public CMD_S_YuChaoCome(ByteBuffer buffer)
            {
                YuChaoId = buffer.ReadByte();
            }

            public byte YuChaoId;
        }

        /// <summary>
        /// 打死忠义堂
        /// </summary>
        public class CMD_S_ZhongYiTang
        {
            public CMD_S_ZhongYiTang()
            {
            }

            public CMD_S_ZhongYiTang(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                time = buffer.ReadByte();
            }

            public int wChairID;
            public byte time;
        }

        /// <summary>
        /// 打死水浒传(全屏）
        /// </summary>
        public class CMD_S_ShuiHuZhuan
        {
            public CMD_S_ShuiHuZhuan()
            {
                fishid = new List<int>();
                fishScore = new List<int>();
            }

            public CMD_S_ShuiHuZhuan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishid = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.MAX_DEAD_FISH; i++)
                {
                    fishid.Add(buffer.ReadInt32());
                }

                fishScore = new List<int>();
                for (int i = 0; i < LTBY_DataConfig.MAX_DEAD_FISH; i++)
                {
                    fishScore.Add(buffer.ReadInt32());
                }
            }

            public int wChairID;
            public List<int> fishid; //特殊鱼id
            public List<int> fishScore; //得分
        }

        /// <summary>
        /// 打死局部炸弹
        /// </summary>
        public class CMD_S_JuBuZhaDan
        {
            public CMD_S_JuBuZhaDan()
            {
            }

            public CMD_S_JuBuZhaDan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishid = buffer.ReadInt32();
            }

            public int wChairID;
            public int fishid;
        }

        /// <summary>
        /// 打死大四喜
        /// </summary>
        public class CMD_S_DaSiXi
        {
            public CMD_S_DaSiXi()
            {
            }

            public CMD_S_DaSiXi(ByteBuffer buffer)
            {
                fish_id = buffer.ReadInt32();
                wChairID = buffer.ReadInt32();
                score = buffer.ReadInt32();
            }

            public int fish_id;
            public int wChairID;
            public int score;
        }

        /// <summary>
        /// 打死大三元
        /// </summary>
        public class CMD_S_DaSanYuan
        {
            public CMD_S_DaSanYuan()
            {
            }

            public CMD_S_DaSanYuan(ByteBuffer buffer)
            {
                fish_id = buffer.ReadInt32();
                wChairID = buffer.ReadInt32();
                score = buffer.ReadInt32();
            }

            public int fish_id;
            public int wChairID;
            public int score;
        }

        /// <summary>
        /// 打死奇遇蟹
        /// </summary>
        public class CMD_S_QiYuXie
        {
            public int wChairID; //椅子号
            public byte time; //持续时间
            public CMD_S_QiYuXie(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                time = buffer.ReadByte();
            }
        }

        /// <summary>
        /// 打死大奖章鱼
        /// </summary>
        public class CMD_S_DaJiangZhangYu
        {
            public CMD_S_DaJiangZhangYu()
            {
            }

            public CMD_S_DaJiangZhangYu(ByteBuffer buffer)
            {
                id = buffer.ReadInt32();
                wChairID = buffer.ReadInt32();
                odd1 = buffer.ReadInt32();
                odd2 = buffer.ReadInt32();
                odd3 = buffer.ReadInt32();
            }

            public int id;
            public int wChairID; //椅子号
            public int odd1;
            public int odd2;
            public int odd3;
        }

        /// <summary>
        /// 打中李逵（聚宝盆）
        /// </summary>
        public class CMD_S_ShootLK
        {
            public CMD_S_ShootLK()
            {
            }

            public CMD_S_ShootLK(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                id = buffer.ReadInt32();
                score = buffer.ReadInt32();
                Multiple = buffer.ReadInt32();
                isDeaded = buffer.ReadByte();
                cbJBPStage = buffer.ReadByte();
                culScore = buffer.ReadInt32();
                culPlayerScore = buffer.ReadInt64();
            }

            public int wChairID;
            public int id;
            public int score;
            public int Multiple;
            public byte isDeaded; // 是否死亡
            public byte cbJBPStage; // 当前等级
            public int culScore; // 当前分数
            public long culPlayerScore; //玩家当前分数
        }

        /// <summary>
        /// 玩家锁定
        /// </summary>
        public class CMD_S_PlayerLock
        {
            public CMD_S_PlayerLock()
            {
            }

            public CMD_S_PlayerLock(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
                fishId = buffer.ReadInt32();
            }

            public byte chairId;
            public int fishId;
        }

        /// <summary>
        /// 玩家取消锁定
        /// </summary>
        public class CMD_S_PlayerCancalLock
        {
            public CMD_S_PlayerCancalLock()
            {
            }

            public CMD_S_PlayerCancalLock(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
            }

            public byte chairId;
        }

        /// <summary>
        /// 打死鱼王
        /// </summary>
        public class CMD_S_YuWang
        {
            public CMD_S_YuWang()
            {
            }

            public CMD_S_YuWang(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                kind = buffer.ReadInt32();
                kingID = buffer.ReadInt32();
                fish = new List<LoadFish>();
                for (int i = 0; i < 40; i++)
                {
                    fish.Add(new LoadFish(buffer));
                }
            }

            public int wChairID;
            public int kind;
            public int kingID;
            public List<LoadFish> fish;
        }

        /// <summary>
        /// 打死一网打尽
        /// </summary>
        public class CMD_S_YiWangDaJin
        {
            public CMD_S_YiWangDaJin()
            {
            }

            public CMD_S_YiWangDaJin(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                bullet = buffer.ReadInt32();
            }

            public int wChairID;
            public int bullet;
        }

        /// <summary>
        /// 打死同类炸弹
        /// </summary>
        public class CMD_S_TongLeiZhaDan
        {
            public CMD_S_TongLeiZhaDan()
            {
            }

            public CMD_S_TongLeiZhaDan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishid = buffer.ReadInt32();
                kind = buffer.ReadInt32();
            }

            public int wChairID;
            public int fishid;
            public int kind;
        }

        /// <summary>
        /// 机器人进入
        /// </summary>
        public class CMD_S_RobotCome
        {
            public CMD_S_RobotCome()
            {
            }

            public CMD_S_RobotCome(ByteBuffer buffer)
            {
                chairID = buffer.ReadInt32();
            }

            public int chairID;
        }

        /// <summary>
        /// 机器人列表
        /// </summary>
        public class CMD_S_RobotList
        {
            public CMD_S_RobotList()
            {
            }

            public CMD_S_RobotList(ByteBuffer buffer)
            {
                isRobot = new List<byte>();
                for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
                {
                    isRobot.Add(buffer.ReadByte());
                }
            }

            public List<byte> isRobot;
        }

        /// <summary>
        /// 机器人射击
        /// </summary>
        public class CMD_S_RobotShoot
        {
            public CMD_S_RobotShoot()
            {
            }

            public CMD_S_RobotShoot(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
                level = buffer.ReadByte();
                type = buffer.ReadByte();
                isLock = buffer.ReadByte();
            }

            public byte chairId;
            public byte level;
            public byte type;
            public byte isLock;
        }


        //-------------------------------------------玩家请求--------------------------------------------------
        /// <summary>
        /// 玩家发炮
        /// </summary>
        public class PlayerShoot
        {
            public PlayerShoot()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();

                    buffer = new ByteBuffer();
                    buffer.WriteFloat(x);
                    buffer.WriteFloat(y);
                    buffer.WriteInt(wChairId);
                    buffer.WriteInt(bulletId);
                    buffer.WriteByte(temp1);
                    buffer.WriteByte(temp2);
                    buffer.WriteByte(gunLevel);
                    buffer.WriteByte(gunGrade);
                    buffer.WriteInt(bet);
                    return buffer;
                }
            }

            public float x;
            public float y;
            public int wChairId;
            public int bulletId;
            public byte temp1;
            public byte temp2;
            public byte gunLevel;
            public byte gunGrade;
            public int bet;
        }

        /// <summary>
        /// 玩家命中鱼
        /// </summary>
        public class PlayerHitFish
        {
            public PlayerHitFish()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();
                    buffer = new ByteBuffer();
                    buffer.WriteInt(bulletId);
                    buffer.WriteByte(type);
                    buffer.WriteByte(isUse);
                    buffer.WriteByte(gunLevel);
                    buffer.WriteByte(gunGrade);
                    buffer.WriteInt(bet);
                    buffer.WriteInt(wChairId);
                    if (hitFishList == null) hitFishList = new List<short>();
                    for (int i = 0; i < LTBY_DataConfig.MAX_DEAD_FISH; i++)
                    {
                        buffer.WriteShort((ushort) (i >= hitFishList.Count ? 0 : hitFishList[i]));
                    }

                    return buffer;
                }
            }

            public int bulletId;
            public byte type;
            public byte isUse;
            public byte gunLevel;
            public byte gunGrade;
            public int bet;
            public int wChairId;
            public List<short> hitFishList;
        }

        /// <summary>
        /// 玩家改变炮台等级
        /// </summary>
        public class PlayerChangeGunLevel
        {
            public PlayerChangeGunLevel()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();

                    buffer = new ByteBuffer();
                    buffer.WriteInt(wChairId);
                    buffer.WriteByte(gunGrade);
                    buffer.WriteByte(gunLevel);
                    return buffer;
                }
            }

            public int wChairId;
            public byte gunGrade;
            public byte gunLevel;
        }

        /// <summary>
        /// 玩家打死全屏后发送鱼id
        /// </summary>
        public class PlayerHitShuiHuZhuan
        {
            public PlayerHitShuiHuZhuan()
            {
                killFishIds = new List<int>(LTBY_DataConfig.MAX_FISH_BUFFER);
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();

                    buffer = new ByteBuffer();
                    buffer.WriteInt(wChairId);
                    buffer.WriteInt(fishId);
                    for (int i = 0; i < killFishIds.Count; i++)
                    {
                        buffer.WriteInt(killFishIds[i]);
                    }

                    return buffer;
                }
            }

            public int wChairId;
            public int fishId;
            public List<int> killFishIds;
        }

        /// <summary>
        /// 玩家打死鱼王
        /// </summary>
        public class PlayerHitYW
        {
            public PlayerHitYW()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();

                    buffer = new ByteBuffer();
                    buffer.WriteInt(wChairID);
                    return buffer;
                }
            }

            public int wChairID;
        }

        /// <summary>
        /// 玩家打死同类炸弹
        /// </summary>
        public class PlayerHitTLZD
        {
            public PlayerHitTLZD()
            {
                killFishIds = new List<short>(200);
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    buffer?.Close();

                    buffer = new ByteBuffer();
                    buffer.WriteInt(wChairId);
                    buffer.WriteInt(fishId);
                    for (int i = 0; i < killFishIds.Count; i++)
                    {
                        buffer.WriteInt(killFishIds[i]);
                    }

                    return buffer;
                }
            }

            public int wChairId;
            public int fishId;
            public List<short> killFishIds;
        }

        /// <summary>
        /// 玩家打死局部炸弹
        /// </summary>
        public class PlayerHitJBZD
        {
            public PlayerHitJBZD()
            {
                killFishIds = new List<int>(20);
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    if (buffer != null)
                    {
                        buffer.Close();
                    }

                    buffer = new ByteBuffer();
                    buffer.WriteInt(wChairId);
                    buffer.WriteInt(fishId);
                    for (int i = 0; i < killFishIds.Count; i++)
                    {
                        buffer.WriteInt(killFishIds[i]);
                    }

                    return buffer;
                }
            }

            public int wChairId;
            public int fishId;
            public List<int> killFishIds;
        }

        /// <summary>
        /// 玩家锁定
        /// </summary>
        public class PlayerLockFish
        {
            public PlayerLockFish()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    if (buffer != null)
                    {
                        buffer.Close();
                    }

                    buffer = new ByteBuffer();
                    buffer.WriteByte(wChairId);
                    buffer.WriteInt(fishId);
                    return buffer;
                }
            }

            public byte wChairId;
            public int fishId;
        }

        /// <summary>
        /// 玩家取消锁定
        /// </summary>
        public class PlayerCancelLockFish
        {
            public PlayerCancelLockFish()
            {
            }

            private ByteBuffer buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    if (buffer != null)
                    {
                        buffer.Close();
                    }

                    buffer = new ByteBuffer();
                    buffer.WriteByte(wChairId);
                    return buffer;
                }
            }

            public byte wChairId;
        }

        public class PropStatus
        {
            public int chairId;
            public int propId;
            public int status;
        }
    }
}