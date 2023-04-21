using System;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Fulinmen
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
                Button btn = child.CreateOrGetComponent<Button>();
                for (int j = 0; j < child.transform.childCount; j++)
                {
                    child.transform.GetChild(j).gameObject.SetActive(false);
                }

                child.transform.FindChildDepth($"{num}").gameObject.SetActive(true);
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() => { Call?.Invoke(num); });
            }

            var helper = EventTriggerHelper.Get(gameObject);
            helper.onClick = (o, data) => { gameObject.SetActive(false); };
        }
    }
}