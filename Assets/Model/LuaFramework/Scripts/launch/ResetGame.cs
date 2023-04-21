using System;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LuaFramework
{
    // Token: 0x02000203 RID: 515
    public class ResetGame : MonoBehaviour
    {
        // Token: 0x060025A5 RID: 9637 RVA: 0x000FA6EC File Offset: 0x000F88EC
        public void Awake()
        {
            SceneManager.LoadSceneAsync(AppConst.BeginScenName, 0);
            UnityEngine.Object.Destroy(base.gameObject);
        }
    }
}
