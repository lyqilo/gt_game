using System.Collections.Generic;

namespace Hotfix.LTBY
{
    public class LockFishConfig
    {
        public static FrameData Frame = new FrameData() 
        {
            x = 0, y = 0, w = 880, h = 540,
            Title = "Lock Settings",
            Des1 = "<color=#FFCB25FF>Check the lock fish and set the lock range. </color> Click",
            Des2 = "If there is a fish checked, it will auto lock the checked fish for auto shooting; if ",
            Des3 = "All unchecked, then you need to click on the fish to lock the catch. <color=#FFCB25FF>When auto-lock is on, click on the fish to toggle locking the target. </color>",
             BtnAll = "All",
             BtnNone = "Not",
        };

        public static Dictionary<int, bool> LockFishList = new Dictionary<int, bool>();

        public static void SetLockFishList(Dictionary<int,bool> list)
        {
            LockFishList = list;
        }
        public static void ClearFishList()
        {
            LockFishList.Clear();
        }

        public static bool IsLockFishListEmpty()
        {
            bool empty = true;
            int[] keys = LockFishList.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                if (!LockFishList[keys[i]]) continue;
                empty = false;
                break;
            }
            return empty;
        }
    }
}
