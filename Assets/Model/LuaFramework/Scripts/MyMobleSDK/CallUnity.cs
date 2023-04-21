using System;
using System.Collections;
using System.Collections.Generic;
using QPDefine;
using LuaFramework;
using UnityEngine;

namespace MyMobleSDK
{
    public class CallUnity : MonoBehaviour
    {
        private void Awake()
        {
            CallUnity.instance = this;
        }

        public void AppInitIAPManager()
        {
            CalliOS.AppInitIAPManager();
        }

        public void Dispose()
        {
            UnityEngine.Object.Destroy(base.gameObject);
        }

        public void Share(FrameShareData data)
        {
            FrameSDK frameSDK = new FrameSDK();
            frameSDK.UseShare(data);
        }

        
        public static void iosOpenPhotoLibrary(bool allowsEditing = true)
        {
            CalliOS.iosOpenPhotoLibrary(allowsEditing);
        }

        
        public static void iosOpenPhotoAlbums(bool allowsEditing = true)
        {
            CalliOS.iosOpenPhotoAlbums(allowsEditing);
        }

        
        public static void iosOpenCamera(bool allowsEditing = true)
        {
            CalliOS.iosOpenCamera(allowsEditing);
        }

        
        public static void iosSaveImageToPhotosAlbum(string readAddr)
        {
            CalliOS.iosSaveImageToPhotosAlbum(readAddr);
        }

        
        public void PickImageCallBack_Base64(string base64)
        {
            bool flag = this.CallBack_PickImage_With_Base64 != null;
            if (flag)
            {
                this.CallBack_PickImage_With_Base64(base64);
            }
        }

        
        public void SaveImageToPhotosAlbumCallBack(string msg)
        {
          
            bool flag = this.CallBack_ImageSavedToAlbum != null;
            if (flag)
            {
                this.CallBack_ImageSavedToAlbum(msg);
            }
        }

                public void Base64StringToTexture2D(string base64)
        {
            
            bool flag = base64.Length > 1;
            if (flag)
            {
                Texture2D texture2D = new Texture2D(4, 4, (TextureFormat)5, false);
                try
                {
                    byte[] array = Convert.FromBase64String(base64);
                    ImageConversion.LoadImage(texture2D, array);
                }
                catch (Exception ex)
                {
                    DebugTool.LogError(ex.Message);
                }
                bool flag2 = CallUnity.luaMethodCallBack != null;
                if (flag2)
                {
                    base.StartCoroutine(this.CreateSprite(texture2D, CallUnity.luaMethodCallBack));
                    CallUnity.luaMethodCallBack = null;
                }
            }
            else
            {
                bool flag3 = CallUnity.luaMethodCallBack != null;
                if (flag3)
                {
                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodCallBack, new object[2]);
                    CallUnity.luaMethodCallBack = null;
                }
            }
        }

                public IEnumerator CreateSprite(Texture2D tex, object func = null)
        {
            Sprite sp = null;
            yield return new WaitForEndOfFrame();
            yield return sp = Sprite.Create(tex, new Rect(0f, 0f, (float)tex.width, (float)tex.height), new Vector2(0f, 0f));
            yield return new WaitForEndOfFrame();
            bool flag = func != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(func, new object[]
                {
                    sp,
                    tex
                });
            }
            yield break;
        }

                public void message(string imageName)
        {
           // Log.Debug(string.Format("CallUnity message:{0}", imageName));
            base.StartCoroutine(this.LoadAsset(Application.persistentDataPath + "/" + imageName));
        }

        
        private IEnumerator LoadAsset(string loadPath)
        {
            WWW www = new WWW("file://" + loadPath);
            yield return www;
            Texture2D nTexture = www.texture;
            yield return new WaitForEndOfFrame();
            Sprite sp;
            yield return sp = Sprite.Create(nTexture, new Rect(0f, 0f, (float)nTexture.width, (float)nTexture.height), new Vector2(0f, 0f));
            yield return new WaitForEndOfFrame();
            bool flag = CallUnity.luaMethodCallBack != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodCallBack, new object[]
                {
                    sp,
                    loadPath
                });
                CallUnity.luaMethodCallBack = null;
            }
            yield break;
        }

        
        public void MoblePayCallBack(string nValue)
        {
            bool flag = CallUnity.luaMethodCallBack != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodCallBack, new object[]
                {
                    nValue
                });
            }
        }

        
        public void MoblePayFailed(string nValue)
        {
            bool flag = CallUnity.luaMethodFiled != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodFiled, new object[]
                {
                    nValue
                });
            }
        }

        
        public static void BackMethod(object luaS, object luaF, object luaC)
        {
            CallUnity.luaMethodCallBack = luaS;
            CallUnity.luaMethodFiled = luaF;
            CallUnity.luaMethodConten = luaC;
        }

        
        public static void UnityGetXiangChe(object lua)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.UnityGetXiangChe();
        }

        
        public static void UnityGetXiangJi(object lua)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.UnityGetXiangJi();
        }

        
        public static void UnityGetPhone(object lua)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.UnityGetPhone();
        }

        
        public static void GetPhonePicture(object lua, int scale, int wh)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.GetPhonePicture(scale, wh);
        }

        
        public static void UnityGetTake(object lua)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.UnityGetTake();
        }

        
        public static void ServerBuyOk(string id)
        {
            CalliOS.ServerBuyOk(id);
        }

        
        public static void IOSPay(string name, string number)
        {
            Debug.Log("Call ios Pay interface:" + name + "==" + number);
            CalliOS.IOSPay(name, number);
        }

        
        public static void AliPay(string name, string number, object luaS, object luaF, object luaC)
        {
        }

        
        private void IOSToU(string s)
        {
            DebugTool.Log("[MsgFrom ios]" + s);
        }

        
        private void ShowProductList(string s)
        {
            bool flag = CallUnity.luaMethodCallBack != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodCallBack, new object[]
                {
                    s
                });
            }
        }

        
        public void ProvideContent(string s)
        {
            bool flag = CallUnity.luaMethodConten != null;
            if (flag)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(CallUnity.luaMethodConten, new object[]
                {
                    s
                });
            }
        }

        
        public static void IOSRequstProductInfo(string str, object lua)
        {
            CallUnity.luaMethodCallBack = lua;
            CalliOS.IOSRequstProductInfo(str);
        }

        
        public static string GetADID()
        {
            return CalliOS.GetADID();
        }

        
        public static bool ProductAvailable()
        {
            return CalliOS.ProductAvailable();
        }

        
        public static CallUnity instance;

        
        [HideInInspector]
        public List<string> productInfo = new List<string>();

        
        private static object luaMethodCallBack = null;

        
        private static object luaMethodFiled = null;

        
        private static object luaMethodConten = null;

        
        public Action<string> CallBack_PickImage_With_Base64;

        
        public Action<string> CallBack_ImageSavedToAlbum;
    }
}
