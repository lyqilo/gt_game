using UnityEngine;

namespace Hotfix
{
    public class LoadGameComponent:Singleton<LoadGameComponent>
    {
        /// <summary>
        /// 启动游戏对应脚本
        /// </summary>
        /// <param name="gameid">游戏数据</param>
        public void LoadGameScript(GameData gameData)
        {
            DebugHelper.Log($"加载ILRuntime脚本:{gameData.scenName}");
            GameObject root = GameObject.FindGameObjectWithTag(LaunchTag._01gameTag);
            if (root == null) root = GameObject.Find(gameData.rootName);
            if (root == null)
            {
                DebugHelper.LogError($"没有找到根节点 {gameData.rootName} 1");
                return;
            }
            gameData.entry.Invoke(root);
        }
    }
}
