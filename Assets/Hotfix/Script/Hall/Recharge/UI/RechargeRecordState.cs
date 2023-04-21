using System.Collections.Generic;
using FancyScrollView;
using LitJson;
using UnityEngine;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargeRecordState : MonoBehaviour, IModuleDetail
    {
        public int Index { get; set; }
        private Transform list;
        private RectTransform view;
        private Scroller _scroller;
        private RecordScrollView _scrollView;

        private void Awake()
        {
            list = transform.FindChildDepth($"List");
        }

        public void Show()
        {
            gameObject.SetActive(true);
            ToolHelper.ShowWaitPanel();
            FormData formData = new FormData();
            formData.AddField("userId",$"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            Model.Instance.ReqRechargeRecordData(formData, (isSuccess, result) =>
            {
                ToolHelper.ShowWaitPanel(false);
                if (!isSuccess)
                {
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }

                DebugHelper.Log($"result:{result}");
                var json = JsonMapper.ToObject(result);
                if (!int.TryParse(json["code"].ToString(), out int code) || code != 0)
                {
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }
                OnReceiveServerData(json);
            });
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        private void OnReceiveServerData(JsonData result)
        {
            var datalist = JsonMapper.ToObject<List<CommonRecordData>>(result["data"].ToJson());
            view ??= list.FindChildDepth($"View").GetComponent<RectTransform>();
            _scroller ??= ToolHelper.CreateScroller(list.gameObject, view);
            _scrollView ??= list.gameObject.CreateOrGetComponent<RecordScrollView>();
            List<RecordData> datas = new List<RecordData>();
            for (int i = 0; i < datalist.Count; i++)
            {
                datas.Add(new RecordData(datalist[i]));
            }

            _scrollView.Init(datas, null);
        }
    }
}