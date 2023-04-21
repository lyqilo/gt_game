
using System.IO;

namespace YooAsset.Editor
{
    public class CollectSpriteAtlas : IFilterRule
    {
        public bool IsCollectAsset(FilterRuleData data)
        {
            return Path.GetExtension(data.AssetPath).Equals(".spriteatlas");
        }
    }
}