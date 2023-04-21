namespace LuaFramework
{
    public interface IMessageDispatcher
    {
        void Update();

        void Dispense(byte[] messageBytes, int len);

        void Dispense(BytesPack pack);
    }
}

