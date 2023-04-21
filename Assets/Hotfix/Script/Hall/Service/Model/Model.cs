using System.Collections.Generic;
using LitJson;

namespace Hotfix.Hall.Service
{
    public class Model : Singleton.Singleton<Model>, IModule
    {
        private const string ConfigURL = "/info/customer";
        public Dictionary<string, ServiceConfig> Configs { get; } = new Dictionary<string, ServiceConfig>();
        public void Initialize()
        {
            RequestConfig();
        }
        public void UnInitialize()
        {
        }

        public void RequestConfig()
        {
            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{ConfigURL}",new FormData(), Callback);
        }
        private void Callback(bool isSuccess, string result)
        {
            if (!isSuccess) return;
            DebugHelper.Log(result);
            JsonData jsonData = JsonMapper.ToObject(result);
            if (jsonData["code"].ToString() != "0") return;
            var config = JsonMapper.ToObject<List<ServiceConfig>>(jsonData["data"].ToJson());
            Configs.Clear();
            for (int i = 0; i < config.Count; i++)
            {
                Configs.Add(config[i].name, config[i]);
            }
        }
    }

    public struct ServiceConfig
    {
        public int id;
        public string name;
        public string resources;
    }
    
}