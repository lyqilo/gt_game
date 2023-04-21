using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;

namespace LuaFramework
{
	
	public class UnityDns : MonoBehaviour
	{
		
		public async Task<UrlInfo> ParseUrl(string url)
		{
			return await this.ParseUrl(new List<string>
			{
				url
			});
		}

		
		public async Task<UrlInfo> ParseUrl(List<string> urls)
		{
			int index = 0;
			foreach (string i in urls)
			{
				try
				{

					await this.GetWWWAsync(i);
					this.urlInfo.url = i;
					this.urlInfo.index = index;
				}
				catch (Exception)
				{
					UrlInfo uinfo = new UrlInfo
					{
						conten = string.Empty,
						state = false
					};
					this.urlInfo = uinfo;
					uinfo = default(UrlInfo);
				}
				if (this.urlInfo.state)
				{
					return this.urlInfo;
				}
				index++;
			}

			return this.urlInfo;
		}

		
		private void Update()
		{

			bool flag = this.isOk;
			if (!flag)
			{
				bool flag2 = this.www == null;
				if (!flag2)
				{
					this.time += Time.deltaTime;
                    bool flag3 = !this.www.isDone&& this.time < 4;
					if (!flag3)
					{
						UrlInfo urlInfo = default(UrlInfo);
						urlInfo.state = false;
						urlInfo.conten = string.Empty;

						bool flag4 = this.www.isDone && this.www.result == UnityWebRequest.Result.Success;
						if (flag4)
						{
							string text = this.www.downloadHandler.text;
							// text = text.Replace(AppConst.AuthCode, "");
							urlInfo.conten = text;
							urlInfo.state = true;
							this.urlInfo = urlInfo;
           
                        }

                        this.isOk = true;
						this.www.Dispose();
						this.www = null;
						this.time = 0f;
						this.tcs.SetResult(true);
					}
				}
			}
		}

		
		public Task<bool> GetWWWAsync(string weburl)
		{
			this.tcs = new TaskCompletionSource<bool>();
			string uri = weburl + "?v=" + TimeHelper.Format("yyyyMMddhhmmss");
			this.isOk = false;
			this.www = UnityWebRequest.Get(uri);
			this.www.SendWebRequest();
			this.time = 0f;
			return this.tcs.Task;
		}

		
		public IEnumerator GetWWW(string weburl, Action<UrlInfo> action)
		{
			bool flag = this.isOk;
			if (flag)
			{
				yield break;
			}
			string url = weburl + "?v=" + TimeHelper.Format("yyyyMMddhhmmss");
			this.www = UnityWebRequest.Get(url);
			this.www.timeout = 6;
			yield return this.www.SendWebRequest();
			UrlInfo uinfo = default(UrlInfo);
			uinfo.conten = string.Empty;
			uinfo.state = false;
			bool flag2 = this.www.isDone && !this.www.isNetworkError && !this.www.isHttpError && this.www.downloadHandler.text.Contains(AppConst.AuthCode);
            Debug.LogError(www.isNetworkError);
			if (flag2)
			{
				string text = this.www.downloadHandler.text;
				text = text.Replace(AppConst.AuthCode, "");
				uinfo.url = weburl;
				uinfo.conten = text;
				uinfo.state = true;
				this.isOk = true;
				text = null;
			}
			action(uinfo);
			this.www.Dispose();
			yield break;
		}

		
		public static async void GetHtml(string weburl, Action<UrlInfo> action)
		{
			UrlInfo uinfo = default(UrlInfo);
			uinfo.state = false;
			await Task.Run<bool>(delegate
			{
				uinfo.url = weburl;
				uinfo.conten = UnityDns.GetHtml(weburl);
				uinfo.state = true;
				return true;
			});
			action(uinfo);
		}

		
		public static string GetHtml(string weburl)
		{
			string text = string.Empty;
			string address = weburl + "?v=" + TimeHelper.Format("yyyyMMddhhmmss");
			try
			{
				WebClient webClient = new WebClient();
				webClient.Credentials = CredentialCache.DefaultCredentials;
				byte[] bytes = webClient.DownloadData(address);
				text = Encoding.Default.GetString(bytes);
				bool flag = text.Contains(AppConst.AuthCode);
				if (flag)
				{
					text = text.Replace(AppConst.AuthCode, "");
				}
				webClient.Dispose();
			}
			catch (Exception)
			{
			}
			return text;
		}

		
		public bool isOk = false;

		
		private UnityWebRequest www;

		
		public TaskCompletionSource<bool> tcs;

		
		public UrlInfo urlInfo;

		
		public int outTime = AppConst.DnsCheckOutTime;

		
		private float time = 0f;
	}
}
