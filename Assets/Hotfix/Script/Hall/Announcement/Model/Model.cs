using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using LitJson;

namespace Hotfix.Hall.Announcement
{
    public partial class Model : Singleton.Singleton<Model>
    {
        private const string NoticeUrl = "/info/notice";

        private TaskCompletionSource<bool> _completionSource;
        /// <summary>
        /// 请求公告
        /// </summary>
        /// <param name="config"></param>
        public void RequestNoticeConfig(Action<List<NoticeData>> config)
        {
            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{NoticeUrl}", new FormData(), (isSuccess, result) =>
            {
                if (!isSuccess)
                {
                    config?.Invoke(null);
                    return;
                }

                JsonData jsonData = JsonMapper.ToObject(result);
                if (jsonData["code"].ToString() != "0")
                {
                    config?.Invoke(null);
                    return;
                }

                config?.Invoke(JsonMapper.ToObject<List<NoticeData>>(jsonData["data"].ToJson()));
            });
        }

        /// <summary>
        /// 尝试打开公告
        /// </summary>
        /// <returns></returns>
        public async Task<bool> TryOpenNotice()
        {
            _completionSource = new TaskCompletionSource<bool>();
            ToolHelper.ShowWaitPanel();
            RequestNoticeConfig(async result =>
            {
                ToolHelper.ShowWaitPanel(false);
                if (result == null)
                {
                    _completionSource?.TrySetResult(false);
                    return;
                }

                AnnouncementPanel.Open(result);
                _completionSource?.TrySetResult(true);
            });
            bool hasConfig = await _completionSource.Task;
            return hasConfig;
        }
    }

    public struct NoticeData
    {
        public int id;
        public string title;
        public string content;
    }
}