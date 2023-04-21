using System;
using System.Collections.Generic;


namespace LuaFramework
{
    public class MessageDispatcher : IMessageDispatcher
    {
        public static void dispense()
        {
            MessageDispatcher.Qframe.Clear();
            MessageDispatcher.Qsokets.Clear();
            MessageDispatcher.isSendMessge = true;
        }

        public void Update()
        {
            bool flag = !MessageDispatcher.isSendMessge;
            if (!flag)
            {
                object obj = MessageDispatcher.obj1;
                lock (obj)
                {
                    this.ExecuteQframe();
                }
                object obj2 = MessageDispatcher.obj2;
                lock (obj2)
                {
                    this.ExecuteQsokets();
                }
            }
        }

        public void ExecuteQframe()
        {
            while (MessageDispatcher.Qframe.Count > 0)
            {
                this.ResolveMessage(MessageDispatcher.Qframe.Dequeue());
            }
        }

        public void ExecuteQsokets()
        {
            while (MessageDispatcher.Qsokets.Count > 0)
            {
                this.SendMessageToLua((BytesPack)MessageDispatcher.Qsokets.Dequeue());
            }
        }

        public static void AddMessage(string _event, object data)
        {
            object obj = MessageDispatcher.obj1;
            lock (obj)
            {
                MessageDispatcher.Qframe.Enqueue(new KeyValuePair<string, object>(_event, data));
            }
        }

        public static void AddMessage(object obj)
        {
            object obj2 = MessageDispatcher.obj2;
            lock (obj2)
            {
                MessageDispatcher.Qsokets.Enqueue(obj);
            }
        }

        public void OnDestroy()
        {
            MessageDispatcher.Qframe.Clear();
            MessageDispatcher.Qsokets.Clear();
        }

        public void ResolveMessage(object data)
        {
            bool flag = data == null;
            if (!flag)
            {
                string text = string.Empty;
                KeyValuePair<string, object> keyValuePair = (KeyValuePair<string, object>)data;
                string[] array = keyValuePair.Key.Split(new char[]
                {
                    '#'
                });
                text = ((array.Length != 0) ? array[0] : keyValuePair.Key);
                string a = text;
                if (!(a == "CsSocketReceive"))
                {
                    if (!(a == "ConstLuaFuncName"))
                    {
                        if (a == "CsSocketException")
                        {
                            AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                            {
                                keyValuePair.Value.ToString()
                            });
                        }
                    }
                    else
                    {
                        bool flag2 = array.Length == 2;
                        if (flag2)
                        {
                            AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                           {
                                array[1]
                            });
                        }
                        else
                        {
                            bool flag3 = array.Length == 3;
                            if (flag3)
                            {
                                AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                              {
                                    array[1],
                                    array[2]
                                });
                            }
                            else
                            {
                                bool flag4 = array.Length == 4;
                                if (flag4)
                                {
                                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                                 {
                                        array[1],
                                        array[2],
                                        array[3]
                                    });
                                }
                                else
                                {
                                    bool flag5 = array.Length == 5;
                                    if (flag5)
                                    {
                                        AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                                      {
                                            array[1],
                                            array[2],
                                            array[3],
                                            array[4]
                                        });
                                    }
                                    else
                                    {
                                        bool flag6 = array.Length == 6;
                                        if (flag6)
                                        {
                                            AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                                           {
                                                array[1],
                                                array[2],
                                                array[3],
                                                array[4],
                                                array[5]
                                            });
                                        }
                                        else
                                        {
                                            bool flag7 = array.Length == 7;
                                            if (flag7)
                                            {
                                                AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                                              {
                                                    array[1],
                                                    array[2],
                                                    array[3],
                                                    array[4],
                                                    array[5],
                                                    array[6]
                                                });
                                            }
                                            else
                                            {
                                                bool flag8 = array.Length == 8;
                                                if (flag8)
                                                {
                                                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                                                  {
                                                        array[1],
                                                        array[2],
                                                        array[3],
                                                        array[4],
                                                        array[5],
                                                        array[6],
                                                        array[7]
                                                    });
                                                }
                                                else
                                                {
                                                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(keyValuePair.Value, Array.Empty<object>());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(text, new object[]
                    {
                        int.Parse(array[1]),
                        int.Parse(array[2]),
                        keyValuePair.Value,
                        int.Parse(array[3]),
                        int.Parse(array[4])
                    });
                }
            }
        }

        public void Dispense(byte[] messageBytes, int len)
        {
            throw new NotImplementedException();
        }

        public void Dispense(BytesPack pack)
        {
            MessageDispatcher.AddMessage(pack);
        }

        public void SendMessageToLua(BytesPack pack)
        {

            string funcName = "Network.OnSocket";
            ByteBuffer byteBuffer = new ByteBuffer(pack.bytes);
            string text = string.Format("{0}{1}", pack.mid.ToString(), pack.session.Id);
            EventHelper.DispatchOnSocketReceive(pack);
            try
            {
                LuaManager luaManager = AppFacade.Instance.GetManager<LuaManager>();
                if (luaManager!=null)
                {
                    luaManager.CallFunction(funcName, new object[]
                    {
                        text,
                        pack.sid,
                        byteBuffer,
                        pack.bytes.Length,
                        pack.session.Id

                    });
                }
            }
            catch (Exception ex)
            {
                DebugTool.LogFormat(string.Format("SendMessageToLua error:{0}", ex.Message));
            }
        }

        public static Queue<KeyValuePair<string, object>> Qframe = new Queue<KeyValuePair<string, object>>();

        public static Queue<object> Qsokets = new Queue<object>();

        public static readonly object obj1 = new object();

        public static readonly object obj2 = new object();

        public static int SpaceTime = 1;

        public static bool isSendMessge = true;
    }
}
