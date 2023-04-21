using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;
using Object = UnityEngine.Object;
namespace LuaFramework
{
    
    public class UnityWebRequestAsync : MonoBehaviour
    {                
        public float Progress
        {
            get
            {
                bool flag = this.pak.Request == null;
                float result;
                if (flag)
                {
                    result = 0f;
                }
                else
                {
                    result = this.pak.Request.downloadProgress;
                }
                return result;
            }
        }
              
        public ulong ByteDownloaded
        {
            get
            {
                bool flag = this.pak.Request == null;
                ulong result;
                if (flag)
                {
                    result = 0UL;
                }
                else
                {
                    result = this.pak.Request.downloadedBytes;
                }
                return result;
            }
        }

        
        public void Update()
        {
            bool flag = this.pak == null;
            if (!flag)
            {
                bool flag2 = this.pak.Request == null;
                if (!flag2)
                {
                    bool flag3 = this.isCancel;
                    if (flag3)
                    {
                        this.tcs.SetResult(false);
                    }
                    else
                    {
                        bool flag4 = this.pak.func != null;
                        if (flag4)
                        {
                            double num = (this.downSize + this.ByteDownloaded) / 1024.0;
                            double num2 = this.allSize / 1024UL;
                            float num3 = Mathf.Clamp(Convert.ToSingle(num / num2), 0f, 0.9999f);
                            this.pak.func?.Invoke(num3, this.pak.Request.downloadHandler);
                        }
                        bool flag5 = this.pak.Request.isNetworkError || this.pak.Request.isHttpError;
                        if (flag5)
                        {
                          // Log.Error(string.Format("Down {0} : {1}", this.pak.urlPath, this.pak.Request.error));
                            this.pak.func?.Invoke(-1, this.pak.urlPath);
                            this.isCancel = true;
                            this.pak.Request?.Dispose();
                            this.pak = null;
                            Object.Destroy(base.gameObject);
                        }
                        else
                        {
                            bool flag6 = !this.pak.Request.isDone;
                            if (!flag6)
                            {
                                this.downSize += this.ByteDownloaded;
                                string localPath = this.pak.localPath;
                                bool flag7 = !localPath.IsNullOrEmpty();
                                if (flag7)
                                {
                                    byte[] data = this.pak.Request.downloadHandler.data;
                                    this.Save(localPath, data);
                                }
                                bool flag8 = this.currentCount == this.count - 1 && this.pak.Request.isDone;
                                if (flag8)
                                {
                                    this.pak.func?.Invoke(1, this.pak.Request.downloadHandler);
                                }
                                this.currentCount++;
                                this.pak.Request?.Dispose();
                                this.pak = null;
                                this.tcs.SetResult(true);
                            }
                        }
                    }
                }
            }
        }

        
        public void Save(string path, byte[] bytes)
        {
            string directoryName = Path.GetDirectoryName(path);
            bool flag = !Directory.Exists(directoryName);
            if (flag)
            {
                Directory.CreateDirectory(directoryName);
            }
            File.WriteAllBytes(path, bytes);
        }

        
        public Task<bool> DownloadAsync(UnityWebPacket packet)
        {
            this.pak = packet;
            this.tcs = new TaskCompletionSource<bool>();
            this.pak.urlPath = this.pak.urlPath.Replace(" ", "%20");
            this.pak.Request = UnityWebRequest.Get(this.pak.urlPath);
            this.pak.Request.SendWebRequest();
            return this.tcs.Task;
        }

        
        public async Task<bool> DownloadAsync(List<UnityWebPacket> packets, Action callBack = null)
        {
            this.allSize = 0UL;
            this.downSize = 0UL;
            this.currentCount = 0;
            this.count = packets.Count;
            foreach (UnityWebPacket p in packets)
            {
                this.allSize += p.size;
              //  p = null;
            }

            foreach (UnityWebPacket p2 in packets)
            {
                await this.DownloadAsync(p2);
              //  p2 = null;
            }

            if (callBack != null)
            {
                callBack();
            }
            Object.Destroy(base.gameObject);
            return true;
        }

        
        public async Task<bool> DownloadAsync(UnityWebDownPacketQueue packets, Action callBack = null)
        {
            this.downSize = 0UL;
            this.currentCount = 0;
            this.allSize = packets.Size;
            this.count = packets.Count;
            foreach (UnityWebPacket p in packets.paks)
            {
                await this.DownloadAsync(p);
               // p = null;
            }

            if (callBack != null)
            {
                callBack();
            }
            Object.Destroy(base.gameObject);
            return true;
        }

        
        public void Dispose()
        {
            bool flag = this.pak == null;
            if (!flag)
            {
                UnityWebPacket unityWebPacket = this.pak;
                if (unityWebPacket != null)
                {
                    UnityWebRequest request = unityWebPacket.Request;
                    if (request != null)
                    {
                        request.Dispose();
                    }
                }
                this.isCancel = false;
            }
        }

        
        private void OnDestroy()
        {
            this.Dispose();
        }

        
        public UnityWebPacket pak;

        
        public int count = 0;

        
        public int currentCount = 0;

        
        public ulong allSize = 0UL;

        
        public ulong downSize = 0UL;

        
        public bool isCancel;

        
        public TaskCompletionSource<bool> tcs;
    }
}
