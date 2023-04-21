using System;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.BQTP
{
    public class UIAuto : MonoBehaviour
    {
        public static UIAuto Add(GameObject go, Action<int> callBack)
        {
            UIAuto auto = go.CreateOrGetComponent<UIAuto>();
            auto.Call = callBack;
            return auto;
        }

        private Action<int> Call { get; set; }

        private void Awake()
        {
            Transform autoContent = transform.FindChildDepth("Content");
            for (int i = 0; i < Data.AutoList.Count; i++)
            {
                int num = Data.AutoList[i];
                GameObject child = autoContent.gameObject.InstantiateChild(i);
                Button btn = child.GetComponent<Button>();
                TextMeshProUGUI desc = child.GetComponent<TextMeshProUGUI>();
                desc.SetText(num > 1000 ? "∞" : $"{num}");
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() =>
                {
                    Call?.Invoke(num);
                });
            }

            var helper = EventTriggerHelper.Get(gameObject);
            helper.onClick = (o, data) => { gameObject.SetActive(false); };
        }
    }
}