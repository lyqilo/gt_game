using LuaFramework;

namespace Hotfix
{
    public class HotfixActionHelper
    {
        public static event CAction<BytesPack> OnSocketReceive;

        public static void DispatchOnSocketReceive(BytesPack pack)
        {
            OnSocketReceive?.Invoke(pack);
        }

        public static event CAction OnEnterGame;

        /// <summary>
        /// 进入游戏
        /// </summary>
        public static void DispatchOnEnterGame()
        {
            OnEnterGame?.Invoke();
        }

        public static event CAction<BytesPack> OnLoginGame;

        public static void DispatchOnLoginGame(BytesPack pack)
        {
            OnLoginGame?.Invoke(pack);
        }

        /// <summary>
        /// 离开游戏
        /// </summary>
        public static event CAction LeaveGame;

        public static void DispatchLeaveGame()
        {
            LeaveGame?.Invoke();
        }

        /// <summary>
        /// 重连游戏
        /// </summary>
        public static event CAction ReconnectGame;

        public static void DispatchReconnectGame()
        {
            ReconnectGame?.Invoke();
        }

        /// <summary>
        /// 加载游戏内帮助
        /// </summary>
        public static event CAction LoadGameRule;

        public static void DispatchLoadGameRule()
        {
            LoadGameRule?.Invoke();
        }

        /// <summary>
        /// 加载游戏内退出
        /// </summary>
        public static event CAction LoadGameExit;

        public static void DispatchLoadGameExit()
        {
            LoadGameExit?.Invoke();
        }

        /// <summary>
        /// 加载游戏内音乐
        /// </summary>
        public static event CAction<bool> LoadGameMusic;

        public static void DispatchLoadGameMusic(bool isOpen)
        {
            LoadGameMusic?.Invoke(isOpen);
        }

        /// <summary>
        /// 加载游戏内音乐
        /// </summary>
        public static event CAction<bool> LoadGameSound;

        public static void DispatchLoadGameSound(bool isOpen)
        {
            LoadGameSound?.Invoke(isOpen);
        }
    }
}