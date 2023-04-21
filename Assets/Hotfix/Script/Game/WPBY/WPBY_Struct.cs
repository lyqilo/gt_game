using System.Collections.Generic;
using LuaFramework;

namespace Hotfix.WPBY
{
    public class WPBY_Struct
    {

        public class PlayerShoot
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteFloat(x);
                    _buffer.WriteFloat(y);
                    _buffer.WriteInt(chairID);
                    _buffer.WriteInt(bulletId);
                    _buffer.WriteByte(temp1);
                    _buffer.WriteByte(temp2);
                    _buffer.WriteByte(gunLevel);
                    _buffer.WriteByte(gunGrade);
                    _buffer.WriteInt(bet);

                    return _buffer;
                }
            }
            public float x;
            public float y;
            public int chairID;
            public int bulletId;
            public byte temp1;
            public byte temp2;
            public byte gunLevel;
            public byte gunGrade;
            public int bet;
        }
        /// <summary>
        /// 击中鱼
        /// </summary>
        public class HitFish
        {
            public HitFish()
            {
                fishIDList = new List<int>();
            }

            private ByteBuffer _buffer;

            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteInt(bulletId);
                    _buffer.WriteByte(type);
                    _buffer.WriteByte(isUse);
                    _buffer.WriteByte(level);
                    _buffer.WriteByte(grade);
                    _buffer.WriteInt(bet);
                    _buffer.WriteInt(wChairID);
                    for (int i = 0; i < WPBY_DataConfig.MAX_DEAD_FISH; i++)
                    {
                        _buffer.WriteInt(fishIDList.Count <= i ? 0 : fishIDList[i]);
                    }

                    return _buffer;
                }
            }

            public int bulletId;
            public byte type;
            public byte isUse;
            public byte level;
            public byte grade;
            public int bet;
            public int wChairID;
            public List<int> fishIDList;
        }

        public class ChangeGunLevel
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteInt(chairID);
                    _buffer.WriteByte(grade);
                    _buffer.WriteByte(level);
                    return _buffer;
                }
            }
            public int chairID;
            public byte grade;
            public byte level;
        }

        public class PlayerLock
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteByte(chairID);
                    _buffer.WriteInt(fishId);
                    return _buffer;
                }
            }
            public byte chairID;
            public int fishId;
        }

        public class PlayerCancelLock
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteByte(chairID);
                    return _buffer;
                }
            }
            public byte chairID;
        }
        public class HitJBZD
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteInt(chairID);
                    _buffer.WriteInt(fishId);
                    for (int i = 0; i < 20; i++)
                    {
                        _buffer.WriteInt(i >= fishlist.Count ? 0 : fishlist[i]);
                    }
                    return _buffer;
                }
            }
            public int chairID;
            public int fishId;
            public List<int> fishlist;
        }
        public class HitSHZ
        {
            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteInt(chairID);
                    _buffer.WriteInt(fishId);
                    for (int i = 0; i < WPBY_DataConfig.MAX_FISH_BUFFER; i++)
                    {
                        _buffer.WriteInt(i >= fishlist.Count ? 0 : fishlist[i]);
                    }
                    return _buffer;
                }
            }
            public int chairID;
            public int fishId;
            public List<int> fishlist;
        }
        public class Bullet
        {
            public int id;
            public byte type;
            public byte isUse;
            public byte level;
            public byte grade;
            public int chips;
        }

        public class CMD_S_CONFIG
        {
            public List<int> bulletScore;
            public byte bGID;
            public List<int> playerLockFishID;
            public List<long> playerCurScore;

            public CMD_S_CONFIG()
            {
            }

            public CMD_S_CONFIG(ByteBuffer buffer)
            {
                bulletScore = new List<int>();
                for (int i = 0; i < WPBY_DataConfig.BULLET_COUNT; i++)
                {
                    bulletScore.Add(buffer.ReadInt32());
                }

                bGID = buffer.ReadByte();
                playerLockFishID = new List<int>();
                for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
                {
                    playerLockFishID.Add(buffer.ReadInt32());
                }

                playerCurScore = new List<long>();
                for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
                {
                    playerCurScore.Add(buffer.ReadInt64());
                }
            }
        }

        public class CMD_S_PlayerGunLevel
        {
            public List<int> GunLevel;
            public List<int> GunType;
            public CMD_S_PlayerGunLevel() { }

            public CMD_S_PlayerGunLevel(ByteBuffer buffer)
            {
                GunLevel = new List<int>();
                for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
                {
                    GunLevel.Add(buffer.ReadInt32());
                }
                GunType = new List<int>();
                for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
                {
                    GunType.Add(buffer.ReadInt32());
                }
            }
        }
        public class FishPoint
        {
            public FishPoint() { }
            public FishPoint(ByteBuffer buffer)
            {
                x = buffer.ReadInt32();
                y = buffer.ReadInt32();
            }
            public int x;
            public int y;
        }
        public class LoadFish
        {
            public LoadFish() { }
            public LoadFish(ByteBuffer buffer)
            {
                Kind = buffer.ReadByte();
                id = buffer.ReadInt32();
                CreateTime = buffer.ReadInt32();
                EndTime = buffer.ReadInt32();
                fishPoint = new List<FishPoint>();
                for (int i = 0; i < WPBY_DataConfig.MAX_FISH_POINT; i++)
                {
                    FishPoint point = new FishPoint(buffer);
                    fishPoint.Add(point);
                }
                NowTime = buffer.ReadInt32();
                odd = buffer.ReadInt32();
            }
            public byte Kind;
            public int id;
            public int CreateTime;
            public int EndTime;
            public List<FishPoint> fishPoint;
            public int NowTime;
            public int odd;
        }
        public class CMD_S_PlayerEnter
        {
            public CMD_S_PlayerEnter() { }
            public CMD_S_PlayerEnter(ByteBuffer buffer)
            {
                szSize = buffer.ReadInt32();
                szLoadFish = new List<LoadFish>();
                for (int i = 0; i < WPBY_DataConfig.MAX_FISH_COUNT; i++)
                {
                    LoadFish loadFish = new LoadFish(buffer);
                    szLoadFish.Add(loadFish);
                }
            }
            public int szSize;
            public List<LoadFish> szLoadFish;

        }

        public class CMD_S_AddFish
        {
            public CMD_S_AddFish() { }
            public CMD_S_AddFish(ByteBuffer buffer)
            {
                FishCount = buffer.ReadInt32();
                loadFishList = new List<LoadFish>();
                for (int i = 0; i < 20; i++)
                {
                    LoadFish loadFish = new LoadFish(buffer);
                    loadFishList.Add(loadFish);
                }
            }
            public int FishCount;
            public List<LoadFish> loadFishList;

        }
        public class CMD_S_PlayerShoot
        {
            public CMD_S_PlayerShoot() { }
            public CMD_S_PlayerShoot(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                x = buffer.ReadFloat();
                y = buffer.ReadFloat();
                level = buffer.ReadInt32();
                type = buffer.ReadInt32();
                playCurScore = buffer.ReadInt64();
            }
            public int wChairID;
            public float x;
            public float y;
            public int level;
            public int type;
            public long playCurScore;
        }
        public class FishData
        {
            public FishData() { }
            public FishData(ByteBuffer buffer)
            {
                id = buffer.ReadInt32();
                score = buffer.ReadInt32();
            }
            public int id;
            public int score;
        }
        public class CMD_S_FishDead
        {
            public CMD_S_FishDead() { }
            public CMD_S_FishDead(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fish = new List<FishData>();
                for (int i = 0; i < WPBY_DataConfig.MAX_FISH_BUFFER; i++)
                {
                    fish.Add(new FishData(buffer));
                }
                score = buffer.ReadInt64();
            }
            public int wChairID;
            public List<FishData> fish;
            public long score;
        }

        public class CMD_S_ChangeBulletLevel
        {
            public CMD_S_ChangeBulletLevel() { }
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
        public class CMD_S_YuChaoPre
        {
            public CMD_S_YuChaoPre() { }
            public CMD_S_YuChaoPre(ByteBuffer buffer)
            {
                backId = buffer.ReadByte();
            }
            public byte backId;
        }
        public class LineInfo
        {
            public LineInfo() { }
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
            public FishLineInfo() { }
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
        public class FishTide
        {
            public FishTide() { }
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
        public class CMD_S_YuChaoCome
        {
            public CMD_S_YuChaoCome() { }
            public CMD_S_YuChaoCome(ByteBuffer buffer)
            {
                YuChaoId = buffer.ReadByte();
                fishTide = new FishTide(buffer);
            }
            public byte YuChaoId;
            public FishTide fishTide;
        }
        public class CMD_S_ZhongYiTang
        {
            public CMD_S_ZhongYiTang() { }
            public CMD_S_ZhongYiTang(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                time = buffer.ReadByte();
            }
            public int wChairID;
            public byte time;
        }
        public class CMD_S_ShuiHuZhuan
        {
            public CMD_S_ShuiHuZhuan() { }
            public CMD_S_ShuiHuZhuan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishid = buffer.ReadInt32();
            }
            public int wChairID;
            public int fishid;

        }
        public class CMD_S_JuBuZhaDan
        {
            public CMD_S_JuBuZhaDan() { }
            public CMD_S_JuBuZhaDan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishid = buffer.ReadInt32();
            }
            public int wChairID;
            public int fishid;

        }
        public class CMD_S_DaSiXi
        {
            public CMD_S_DaSiXi() { }
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

        public class CMD_S_DaSanYuan
        {
            public CMD_S_DaSanYuan() { }
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

        public class CMD_S_ShootLK
        {
            public CMD_S_ShootLK() { }
            public CMD_S_ShootLK(ByteBuffer buffer)
            {
                site = buffer.ReadInt32();
                id = buffer.ReadInt32();
                score = buffer.ReadInt32();
                Multiple = buffer.ReadInt32();
            }
            public int site;
            public int id;
            public int score;
            public int Multiple;
        }
        public class CMD_S_PlayerLock
        {
            public CMD_S_PlayerLock() { }
            public CMD_S_PlayerLock(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
                fishId = buffer.ReadInt32();
            }
            public byte chairId;
            public int fishId;
        }
        public class CMD_S_PlayerCancalLockLock
        {
            public CMD_S_PlayerCancalLockLock() { }
            public CMD_S_PlayerCancalLockLock(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
            }
            public byte chairId;
        }

        public class CMD_S_YuWang
        {
            public CMD_S_YuWang() { }
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

        public class CMD_S_YiWangDaJin
        {
            public CMD_S_YiWangDaJin() { }
            public CMD_S_YiWangDaJin(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                bullet = buffer.ReadInt32();
            }
            public int wChairID;
            public int bullet;
        }
        public class CMD_S_TongLeiZhaDan
        {
            public CMD_S_TongLeiZhaDan() { }
            public CMD_S_TongLeiZhaDan(ByteBuffer buffer)
            {
                wChairID = buffer.ReadInt32();
                fishId = buffer.ReadInt32();
                kind = buffer.ReadInt32();
            }
            public int wChairID;
            public int fishId;
            public int kind;
        }
        public class CMD_S_RobotCome
        {
            public CMD_S_RobotCome() { }
            public CMD_S_RobotCome(ByteBuffer buffer)
            {
                chairID = buffer.ReadInt32();
            }
            public int chairID;
        }

        public class CMD_S_RobotList
        {
            public CMD_S_RobotList() { }
            public CMD_S_RobotList(ByteBuffer buffer)
            {
                isRobot = new List<bool>();
                for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
                {
                    isRobot.Add(buffer.ReadByte() != 0);
                }
            }
            public List<bool> isRobot;
        }

        public class CMD_S_RobotShoot
        {
            public CMD_S_RobotShoot() { }
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
    }
}