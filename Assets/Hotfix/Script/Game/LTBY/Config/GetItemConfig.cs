namespace Hotfix.LTBY
{
    public class GetItemConfig
    {
        public class ItemTextData
        {
            public string coinName;
        }
        public class MedalData
        {
            public string imageBundleName;
            public string imageName;
        }
        public static ItemTextData ItemText = new ItemTextData() { coinName = "gold", };

        public static MedalData Medal = new GetItemConfig.MedalData() { imageBundleName = "res_messagebox", imageName = "xui_xzsj", };

        public static MedalData Item = new GetItemConfig.MedalData() { imageBundleName = "res_messagebox", imageName = "xui_gxhd", };
    }
}

