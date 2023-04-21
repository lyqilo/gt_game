using UnityEngine;
using UnityEngine.UI;

namespace LuaFramework
{
    public class CreateFont : MonoBehaviour
    {
        private Font f;
        void Start()
        {
            f = Resources.Load<Font>("ARIAL");
            Text[] ts = GetComponentsInChildren<Text>();
            foreach (Text tx in ts)
            {
                tx.font = f;
            }
        }
    }
}

