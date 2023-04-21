using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using UnityEngine.Networking;
using UnityEngine.UI;

namespace LuaFramework
{
    public class DownloadPicManager : Manager
    {
        private Color hideColor = new Color(1, 1, 1, 0.001f);

        private string path = Util.DataPath + "/ImageCache/";

        private Dictionary<int, Sprite> spriteMap = new Dictionary<int, Sprite>();

        /// <summary>
        /// 初始化
        /// </summary>
        public override void OnInitialize()
        {
            // Util.InitPath();
            path = Application.persistentDataPath + "/ImageCache/";
            //初始化头像缓存目录
            DebugTool.LogError(path);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        public override void UnInitialize()
        {
        }

        private void setSprite(int hashCode, Sprite sprite)
        {
            if (spriteMap.ContainsKey(hashCode))
            {
                spriteMap[hashCode] = sprite;
            }
            else
            {
                spriteMap.Add(hashCode, sprite);
            }
        }

        private Sprite getSprite(int hashCode)
        {
            if (spriteMap.ContainsKey(hashCode))
            {
                return spriteMap[hashCode];
            }
            else
            {
                return null;
            }
        }


        public void SetAsyncImage(string url, Image m_image)
        {
            m_image.color = hideColor;

            var hashCode = url.GetHashCode();
            var sprite = getSprite(hashCode);
            if (sprite)
            {
                m_image.sprite = sprite;
                m_image.color = Color.white;
                return;
            }

            if (!File.Exists(path + hashCode + ".png"))
            {
                StartCoroutine(DownloadImage(url, m_image));
            }
            else
            {
                StartCoroutine(LoadLocalImage(url, m_image));
            }
        }

        //网络下载头像图片
        IEnumerator DownloadImage(string url, Image m_image)
        {
            var hashCode = url.GetHashCode();

            //网络下载图片
            UnityWebRequest www = UnityWebRequest.Get(url);
            DownloadHandlerTexture downTexture = new DownloadHandlerTexture();
            www.downloadHandler = downTexture;
            yield return www;
            if (string.IsNullOrEmpty(www.error))
            {
                //获取图片信息
                Texture2D image = downTexture.texture;

                //保存图片
                byte[] pngData = image.EncodeToPNG();
                File.WriteAllBytes(path + hashCode + ".png", pngData);

                //生成Sprite并缓存
                //Sprite tempSprite = new Sprite();
                Sprite tempSprite = Sprite.Create(image, new Rect(0, 0, image.width, image.height), new Vector2(0, 0));
                setSprite(hashCode, tempSprite);

                //设置图片
                if (!m_image.IsDestroyed())
                {
                    m_image.sprite = tempSprite;
                    m_image.color = Color.white;
                }
            }
            else
            {
                DebugTool.LogError(www.error);
            }
        }

        IEnumerator LoadLocalImage(string url, Image m_image)
        {
            var hashCode = url.GetHashCode();

            //加载本地图片
            string filePath = "file:///" + path + hashCode + ".png";
            UnityWebRequest www = new UnityWebRequest(filePath);
            DownloadHandlerTexture downTexture = new DownloadHandlerTexture();
            www.downloadHandler = downTexture;
            yield return www;

            if (string.IsNullOrEmpty(www.error))
            {
                //获取图片信息
                Texture2D image = downTexture.texture;

                //生成Sprite并缓存
                //Sprite tempSprite = new Sprite();
                Sprite tempSprite = Sprite.Create(image, new Rect(0, 0, image.width, image.height), new Vector2(0, 0));
                setSprite(hashCode, tempSprite);

                //设置图片
                if (!m_image.IsDestroyed())
                {
                    m_image.sprite = tempSprite;
                    m_image.color = Color.white;
                }
            }
            else
            {
                DebugTool.LogError(www.error);
            }
        }
    }
}