using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;

	// Token: 0x0200024A RID: 586
	public class ImageAnima : MonoBehaviour
	{
		// Token: 0x1700011D RID: 285
		// (get) Token: 0x0600276A RID: 10090 RVA: 0x001042B4 File Offset: 0x001024B4
		public float showerWidth
		{
              
			get
			{
				bool flag = this.shower == null;
				float result;
				if (flag)
				{
					result = 0f;
				}
				else
				{
					result = this.shower.rectTransform.rect.width;
				}
				return result;
			}
		}

		// Token: 0x1700011E RID: 286
		// (get) Token: 0x0600276B RID: 10091 RVA: 0x001042F8 File Offset: 0x001024F8
		public float showerHeight
		{
			get
			{
				bool flag = this.shower == null;
				float result;
				if (flag)
				{
					result = 0f;
				}
				else
				{
					result = this.shower.rectTransform.rect.height;
				}
				return result;
			}
		}

		// Token: 0x0600276C RID: 10092 RVA: 0x0010433C File Offset: 0x0010253C
		private void Awake()
		{
			this.shower = base.GetComponent<Image>();
			bool flag = this.shower == null;
			if (!flag)
			{
				this.defaultSprite = this.shower.sprite;
				bool flag2 = string.IsNullOrEmpty(this.movieName);
				if (flag2)
				{
					this.movieName = "movieName";
				}
			}
		}

		// Token: 0x0600276D RID: 10093 RVA: 0x00104396 File Offset: 0x00102596
		private void Start()
		{
			this.playDefault();
		}

		// Token: 0x0600276E RID: 10094 RVA: 0x001043A0 File Offset: 0x001025A0
		protected void _play(int iFrame)
		{
			bool flag = iFrame >= this.FrameCount;
			if (flag)
			{
				iFrame = 0;
			}
			this.curFrame = iFrame;
			bool flag2 = this.lSprites.Count <= this.curFrame;
			if (flag2)
			{
				this.playSprite(null);
			}
			else
			{
				this.playSprite(this.lSprites[this.curFrame]);
			}
			bool flag3 = this.shower == null;
			if (!flag3)
			{
				this.shower.SetNativeSize();
			}
			bool flag4 = this.dMovieEvents.ContainsKey(iFrame);
			if (flag4)
			{
				foreach (object obj in this.dMovieEvents[iFrame])
				{
                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(obj, new object[]
					{
						iFrame
					});

                    
				}
			}
		}

		// Token: 0x0600276F RID: 10095 RVA: 0x001044A8 File Offset: 0x001026A8
		protected void _play()
		{
			bool flag = this.curFrame >= this.FrameCount;
			if (flag)
			{
				this.curFrame = 0;
			}
			bool flag2 = this.lSprites.Count <= this.curFrame;
			if (flag2)
			{
				this.playSprite(null);
			}
			else
			{
				this.playSprite(this.lSprites[this.curFrame]);
			}
			bool flag3 = this.dMovieEvents.ContainsKey(this.curFrame);
			if (flag3)
			{
				foreach (object obj in this.dMovieEvents[this.curFrame])
				{
                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(obj, new object[]
					{
						this.curFrame
					});
				}
			}
		}

		// Token: 0x1700011F RID: 287
		// (get) Token: 0x06002770 RID: 10096 RVA: 0x0010459C File Offset: 0x0010279C
		public int FrameCount
		{
			get
			{
				return this.lSprites.Count;
			}
		}

		// Token: 0x06002771 RID: 10097 RVA: 0x001045BC File Offset: 0x001027BC
		private void Update()
		{
			bool flag = this.isPlaying || this.debugPlayer || this.playerAlways;
			if (flag)
			{
				this.fDelta += Time.deltaTime;
				bool flag2 = this.fDelta > this.fSep || this.fDelta < 0f;
				if (flag2)
				{
					bool flag3 = this.fDelta < 0f;
					if (flag3)
					{
						this.fDelta = 0f;
					}
					else
					{
						this.fDelta -= this.fSep;
					}
					this.curFrame++;
					bool flag4 = this.curFrame >= this.FrameCount;
					if (flag4)
					{
						bool flag5 = this.playerAlways || this.debugPlayer;
						if (flag5)
						{
							this._play(this.curFrame);
						}
						else
						{
							bool flag6 = this.playerCount > 1;
							if (flag6)
							{
								this.playerCount--;
								this._play(this.curFrame);
							}
							else
							{
								this.isPlaying = false;
								this.playerCount = 0;
								this.playDefault();
								this.actionEnd();
							}
						}
					}
					else
					{
						this._play(this.curFrame);
					}
				}
			}
		}

		// Token: 0x06002772 RID: 10098 RVA: 0x00104708 File Offset: 0x00102908
		public void Play()
		{
			this.playerAlways = false;
			bool flag = this.isPlaying;
			if (flag)
			{
				bool flag2 = this.playerCount == 1;
				if (flag2)
				{
				}
			}
			else
			{
				this.isPlaying = true;
				this.playerCount = 1;
				this.curFrame = 0;
				this.fDelta = 0f;
				this._play();
			}
		}

		// Token: 0x06002773 RID: 10099 RVA: 0x00104764 File Offset: 0x00102964
		public void Play(int count)
		{
			this.playerAlways = false;
			bool flag = this.isPlaying;
			if (flag)
			{
				this.playerCount = count;
			}
			else
			{
				this.isPlaying = true;
				this.playerCount = count;
				this.curFrame = 0;
				this.fDelta = 0f;
				this._play();
			}
		}

		// Token: 0x06002774 RID: 10100 RVA: 0x001047B8 File Offset: 0x001029B8
		public void PlayAlways()
		{
			this.playerAlways = true;
			bool flag = this.isPlaying;
			if (!flag)
			{
				this._play(0);
				this.isPlaying = true;
			}
		}

		// Token: 0x06002775 RID: 10101 RVA: 0x001047EC File Offset: 0x001029EC
		public void Stop()
		{
			this.isPlaying = false;
			this.playerAlways = false;
			this.playerCount = 0;
			this.actionEnd();
		}

		// Token: 0x06002776 RID: 10102 RVA: 0x0010480C File Offset: 0x00102A0C
		public void StopPlay()
		{
			this.playerAlways = false;
			bool flag = this.isPlaying;
			if (flag)
			{
				this.playerCount = 1;
			}
			else
			{
				this.playerCount = 0;
			}
		}

		// Token: 0x06002777 RID: 10103 RVA: 0x0010483F File Offset: 0x00102A3F
		protected void playDefault()
		{
			this.curFrame = 0;
			this.playSprite(this.defaultSprite);
		}

		// Token: 0x06002778 RID: 10104 RVA: 0x00104858 File Offset: 0x00102A58
		protected void playSprite(Sprite spr)
		{
			bool flag = this.shower == null;
			if (!flag)
			{
				bool flag2 = spr == null;
				if (flag2)
				{
					this.shower.enabled = false;
				}
				else
				{
					this.shower.sprite = spr;
					this.shower.enabled = true;
				}
			}
		}

		// Token: 0x06002779 RID: 10105 RVA: 0x001048B4 File Offset: 0x00102AB4
		public void StopAndRevert()
		{
			this.playerAlways = false;
			bool flag = this.isPlaying;
			if (flag)
			{
				this.Stop();
			}
			this.curFrame = 0;
			this.playDefault();
		}

		// Token: 0x0600277A RID: 10106 RVA: 0x001048EC File Offset: 0x00102AEC
		public void AddEvent(int frame, object delEvent)
		{
			bool flag = !this.dMovieEvents.ContainsKey(frame);
			if (flag)
			{
				this.dMovieEvents.Add(frame, new List<object>());
			}
			this.dMovieEvents[frame].Add(delEvent);
		}

		// Token: 0x0600277B RID: 10107 RVA: 0x00104934 File Offset: 0x00102B34
		public void RemoveEvent(int frame, object delEvent)
		{
			bool flag = !this.dMovieEvents.ContainsKey(frame);
			if (!flag)
			{
				this.dMovieEvents.Remove(frame);
			}
		}

		// Token: 0x0600277C RID: 10108 RVA: 0x00104968 File Offset: 0x00102B68
		private void actionEnd()
		{
			bool flag = this.actionOverEvent != null;
			if (flag)
			{
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(this.actionOverEvent, new object[]
				{
					this.actionOverObj
				});
			}
		}

		// Token: 0x0600277D RID: 10109 RVA: 0x001049A5 File Offset: 0x00102BA5
		public void SetEndEvent(object actionEvent)
		{
			this.actionOverObj = null;
			this.actionOverEvent = actionEvent;
		}

		// Token: 0x0600277E RID: 10110 RVA: 0x001049B6 File Offset: 0x00102BB6
		public void SetEndEvent(LuaTable _lt, object actionEvent)
		{
			this.actionOverObj = _lt;
			this.actionOverEvent = actionEvent;
		}

		// Token: 0x0600277F RID: 10111 RVA: 0x001049C7 File Offset: 0x00102BC7
		public void ClearEndEvent()
		{
			this.actionOverObj = null;
			this.actionOverEvent = null;
		}

		// Token: 0x06002780 RID: 10112 RVA: 0x001049D8 File Offset: 0x00102BD8
		public void AddSprite(Sprite spr)
		{
			this.lSprites.Add(spr);
		}

		// Token: 0x06002781 RID: 10113 RVA: 0x001049E8 File Offset: 0x00102BE8
		public void InsertSprite(Sprite spr, int index)
		{
			this.lSprites.Insert(index, spr);
		}

		// Token: 0x06002782 RID: 10114 RVA: 0x001049F9 File Offset: 0x00102BF9
		public void AddNullSprite()
		{
			this.lSprites.Add(null);
		}

		// Token: 0x06002783 RID: 10115 RVA: 0x00104A09 File Offset: 0x00102C09
		public void ClearAll()
		{
			this.lSprites.Clear();
		}

		// Token: 0x06002784 RID: 10116 RVA: 0x00104A18 File Offset: 0x00102C18
		public void SetDefaultSprite(Sprite spr)
		{
			this.defaultSprite = spr;
		}

		// Token: 0x06002785 RID: 10117 RVA: 0x00104A22 File Offset: 0x00102C22
		public void RemoveSprite(int index)
		{
			this.lSprites.RemoveAt(index);
		}

		// Token: 0x06002786 RID: 10118 RVA: 0x00104A32 File Offset: 0x00102C32
		public void RemoveSprite(Sprite spr)
		{
			this.lSprites.Remove(spr);
		}

		// Token: 0x06002787 RID: 10119 RVA: 0x00104A44 File Offset: 0x00102C44
		public Sprite GetSprite(int index)
		{
			bool flag = this.lSprites.Count <= index;
			Sprite result;
			if (flag)
			{
				result = null;
			}
			else
			{
				result = this.lSprites[index];
			}
			return result;
		}

		// Token: 0x04000589 RID: 1417
		public int curFrame = 0;

		// Token: 0x0400058A RID: 1418
		public float fDelta = 0f;

		// Token: 0x0400058B RID: 1419
		public float fSep = 0.05f;

		// Token: 0x0400058C RID: 1420
		public string movieName;

		// Token: 0x0400058D RID: 1421
		[SerializeField]
		public List<Sprite> lSprites = new List<Sprite>();

		// Token: 0x0400058E RID: 1422
		public Sprite defaultSprite = null;

		// Token: 0x0400058F RID: 1423
		public Image shower;

		// Token: 0x04000590 RID: 1424
		public Dictionary<int, List<object>> dMovieEvents = new Dictionary<int, List<object>>();

		// Token: 0x04000591 RID: 1425
		public bool debugPlayer = false;

		// Token: 0x04000592 RID: 1426
		public bool isPlaying = false;

		// Token: 0x04000593 RID: 1427
		public bool playerAlways = false;

		// Token: 0x04000594 RID: 1428
		public int playerCount = 0;

		// Token: 0x04000595 RID: 1429
		public object actionOverEvent;

		// Token: 0x04000596 RID: 1430
		public LuaTable actionOverObj;
	}

