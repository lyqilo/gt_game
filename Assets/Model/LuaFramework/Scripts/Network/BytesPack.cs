namespace LuaFramework
{
    public struct BytesPack
    {
        public BytesPack(int mid, int sid, byte[] bytes, Session se)
        {
            this.mid = mid;
            this.sid = sid;
            this.bytes = bytes;
            this.session = se;
        }

        public override string ToString()
        {
            return string.Format("mid={0},sid={1},bytes.len={2},sessionID={3}", new object[]
            {
                this.mid,
                this.sid,
                this.bytes.Length,
                this.session.Id
            });
        }

        public int mid;

        public int sid;

        public byte[] bytes;

        public Session session;
    }
}
