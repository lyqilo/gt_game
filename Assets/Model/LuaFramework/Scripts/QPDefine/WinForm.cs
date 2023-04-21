using System;
using System.Collections;
using System.IO;
using UnityEngine;

namespace QPDefine
{
    
    public class WinForm
    {
        
        public void CopyToClipboardIMG(string imgPath)
        {
        }

        
        public IEnumerator CaptureScreenShot2(int width, int height, GameObject parent, string savePath = null, Camera camera = null, bool isCopy = false)
        {
            yield return new WaitForEndOfFrame();
            Texture2D screenShot = new Texture2D(width, height, (TextureFormat)3, false);
            bool flag = camera == null;
            if (flag)
            {
                camera = Camera.current;
            }
            Vector2 v2 = camera.WorldToScreenPoint(parent.transform.position);
            int x = (int)v2.x;
            int y = (int)v2.y;
            screenShot.ReadPixels(new Rect((float)(x - width / 2), (float)(y - height / 2), (float)width, (float)height), 0, 0);
            screenShot.Apply();
            byte[] bytes = ImageConversion.EncodeToPNG(screenShot);
            bool flag2 = savePath == null;
            if (flag2)
            {
                savePath = Application.dataPath + "/Screenshot.png";
            }
            bool flag3 = File.Exists(savePath);
            if (flag3)
            {
                File.Delete(savePath);
            }
            File.WriteAllBytes(savePath, bytes);
            if (isCopy)
            {
                this.CopyToClipboardIMG(savePath);
            }
            yield break;
        }

        
        public void CaptureScreenShot(int width, int height, GameObject parent, string savePath, Camera camera)
        {
            parent.GetComponent<MonoBehaviour>().StartCoroutine(this.CaptureScreenShot2(width, height, parent, savePath, camera, false));
        }

        
        public void CaptureScreenShotAndCopy(int width, int height, GameObject parent, string savePath, Camera camera)
        {
            parent.GetComponent<MonoBehaviour>().StartCoroutine(this.CaptureScreenShot2(width, height, parent, savePath, camera, true));
        }

        
        public static string SelectFile(string type)
        {
            return string.Empty;
        }

        
        public static void SelectFile(Action<string> action)
        {
            string empty = string.Empty;
        }

        
        public static string SaveCutScreenPath()
        {
            return string.Empty;
        }

        
        public static WinForm instacne = new WinForm();
    }
}
