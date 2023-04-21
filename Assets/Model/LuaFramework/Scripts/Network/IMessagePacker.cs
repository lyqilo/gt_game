using System;

namespace LuaFramework
{
    public interface IMessagePacker
    {
        string SerializeToText(object obj);

        byte[] SerializeToByteArray(object obj);

        byte[] SerializeToByteArray(object obj1, object obj2);

        byte[] SerializeToByteArray(object obj1, object obj2, object obj3);

        byte[] DeserializeFrom(byte[] bytes);

        object DeserializeFrom(Type type, byte[] bytes);

        object DeserializeFrom(Type type, byte[] bytes, int index, int count);

        T DeserializeFrom<T>(object obj2);

        T DeserializeFrom<T>(object obj1, object obj2);

        T DeserializeFrom<T>(object obj1, object obj2, object obj3);

        T DeserializeFrom<T>(string str);

        object DeserializeFrom(Type type, string str);
    }
}
