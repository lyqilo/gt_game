using LuaFramework;
using System.Runtime.InteropServices;

namespace Hotfix
{
    /// <summary>
    /// 游戏登录
    /// </summary>
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode, Pack = 1)]
    public class REQ_LOGINGAME
    {
        public REQ_LOGINGAME()
        {
            this.ByteBuffer = new ByteBuffer();
        }

        public REQ_LOGINGAME(uint squareType, uint progressType, uint userId, string password, string mechinaCode, byte temp1, byte temp2)
        {
            this.ByteBuffer = new ByteBuffer();
            this.SquareType = squareType;
            this.ProgressType = progressType;
            this.UserID = userId;
            this.Password = password;
            this.MechinaCode = mechinaCode;
            this.Temp1 = temp1;
            this.Temp2 = temp2;
        }

        public ByteBuffer ByteBuffer { get; }
        private uint squaretype;

        public uint SquareType
        {
            get
            {
                return this.squaretype;
            }
            set
            {
                this.squaretype = value;
                this.ByteBuffer.WriteUInt32(this.squaretype);
            }
        }

        private uint progressType;

        public uint ProgressType
        {
            get
            {
                return this.progressType;
            }
            set
            {
                this.progressType = value;
                this.ByteBuffer.WriteUInt32(this.progressType);
            }
        }

        private uint userid;

        public uint UserID
        {
            get
            {
                return this.userid;
            }
            set
            {
                this.userid = value;
                this.ByteBuffer.WriteUInt32(this.userid);
            }
        }

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 33)]
        private string password;

        public string Password
        {
            get
            {
                return this.password;
            }
            set
            {
                this.password = value;
                this.ByteBuffer.WriteBytes( 33,this.password);
            }
        }

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 100)]
        private string mechinaCode;

        public string MechinaCode
        {
            get
            {
                return this.mechinaCode;
            }
            set
            {
                this.mechinaCode = value;
                this.ByteBuffer.WriteBytes(100, this.mechinaCode);
            }
        }

        private byte temp1;

        public byte Temp1
        {
            get
            {
                return this.temp1;
            }
            set
            {
                this.temp1 = value;
                this.ByteBuffer.WriteByte(this.temp1);
            }
        }

        private byte temp2;

        public byte Temp2
        {
            get
            {
                return this.temp2;
            }
            set
            {
                this.temp2 = value;
                this.ByteBuffer.WriteByte(this.temp2);
            }
        }
    }

    /// <summary>
    /// 玩家入座
    /// </summary>
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode, Pack = 1)]
    public class REQ_PLAYERINSEAT
    {
        public REQ_PLAYERINSEAT()
        {
            this.ByteBuffer = new ByteBuffer();
        }

        public ByteBuffer ByteBuffer { get; }
    }

    /// <summary>
    /// 玩家准备
    /// </summary>
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode, Pack = 1)]
    public class REQ_PLAYERPREPARE
    {
        public REQ_PLAYERPREPARE()
        {
            this.ByteBuffer = new ByteBuffer();
        }

        public REQ_PLAYERPREPARE(byte onLookerTag)
        {
            this.ByteBuffer = new ByteBuffer();
            this.OnLookerTag = onLookerTag;
        }

        public ByteBuffer ByteBuffer { get; }
        private byte onLookerTag;

        public byte OnLookerTag
        {
            get
            {
                return this.onLookerTag;
            }
            set
            {
                this.onLookerTag = value;
                this.ByteBuffer.WriteByte(this.onLookerTag);
            }
        } //旁观标志 必须等于0
    }

    public class GameUserData
    {
        public GameUserData(ByteBuffer buffer)
        {
            this.UserId = buffer.ReadUInt32();
            this.NickNameLength = buffer.ReadUInt16();
            this.NickName = buffer.ReadString(this.NickNameLength);
            this.Sex = buffer.ReadByte();
            this.CustomHeader = buffer.ReadByte();
            this.HeaderExtensionNameLength = buffer.ReadUInt16();
            this.HeaderExtensionName = buffer.ReadString(this.HeaderExtensionNameLength);
            this.SignLength = buffer.ReadUInt16();
            this.Sign = buffer.ReadString(this.SignLength);
            this.Gold = (ulong)buffer.ReadUInt64();
            this.Prize = buffer.ReadUInt32();
            this.ChairId = buffer.ReadUInt16();
            this.TableId = buffer.ReadUInt16();
            this.UserStatus = buffer.ReadByte();
        }

        public uint UserId;
        public ushort NickNameLength;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 512)]
        public string NickName;

        public byte Sex;
        public byte CustomHeader;
        public ushort HeaderExtensionNameLength;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 512)]
        public string HeaderExtensionName;

        public ushort SignLength;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 512)]
        public string Sign;

        public ulong Gold;
        public uint Prize;
        public ushort ChairId;
        public ushort TableId;
        public byte UserStatus;
    }

    /// <summary>
    /// 游戏配置信息
    /// </summary>
    public class CMD_GF_Option
    {
        public CMD_GF_Option(ByteBuffer buffer)
        {
            this.GameStatus = buffer.ReadByte();
            this.AllowLookon = buffer.ReadByte();
        }

        public byte GameStatus;
        public byte AllowLookon;
    }

    /// <summary>
    /// 系统消息
    /// </summary>
    public class CMD_GF_SystemMessage
    {
        public CMD_GF_SystemMessage(ByteBuffer buffer)
        {
            this.messageLength = buffer.ReadUInt16();
            this.message = buffer.ReadString(this.messageLength);
        }

        private ushort messageLength;
        public string message;
    }
}