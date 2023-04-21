using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x02000250 RID: 592
	public class SpriteAnima : MonoBehaviour
	{
		// Token: 0x060027C0 RID: 10176 RVA: 0x001060D0 File Offset: 0x001042D0
		private void Awake()
		{
			this.shower = base.GetComponent<SpriteRenderer>();
			bool flag = this.shower == null;
			if (!flag)
			{
				this.defaultSprite = this.shower.sprite;
			}
		}

		// Token: 0x060027C1 RID: 10177 RVA: 0x0010610E File Offset: 0x0010430E
		private void Start()
		{
			this.playDefault();
		}

		// Token: 0x060027C2 RID: 10178 RVA: 0x00106118 File Offset: 0x00104318
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
			this.curFrame = iFrame;
			bool flag3 = this.dMovieEvents.ContainsKey(iFrame);
			if (flag3)
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

		// Token: 0x060027C3 RID: 10179 RVA: 0x00106204 File Offset: 0x00104404
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

		// Token: 0x17000124 RID: 292
		// (get) Token: 0x060027C4 RID: 10180 RVA: 0x001062F8 File Offset: 0x001044F8
		public int FrameCount
		{
			get
			{
				return this.lSprites.Count;
			}
		}

		// Token: 0x060027C5 RID: 10181 RVA: 0x00106318 File Offset: 0x00104518
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

		// Token: 0x060027C6 RID: 10182 RVA: 0x00106464 File Offset: 0x00104664
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
				this.fDelta = 0f;
				this.curFrame = 0;
				this._play(0);
			}
		}

		// Token: 0x060027C7 RID: 10183 RVA: 0x001064C0 File Offset: 0x001046C0
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
				this._play(0);
			}
		}

		// Token: 0x060027C8 RID: 10184 RVA: 0x00106514 File Offset: 0x00104714
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

		// Token: 0x060027C9 RID: 10185 RVA: 0x00106548 File Offset: 0x00104748
		public void Stop()
		{
			this.isPlaying = false;
			this.playerAlways = false;
			this.playerCount = 0;
			this.actionEnd();
		}

		// Token: 0x060027CA RID: 10186 RVA: 0x00106568 File Offset: 0x00104768
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

		// Token: 0x060027CB RID: 10187 RVA: 0x0010659C File Offset: 0x0010479C
		public void StopAndRevert()
		{
			this.playerAlways = false;
			bool flag = this.isPlaying;
			if (flag)
			{
				this.Stop();
			}
			this.playDefault();
		}

		// Token: 0x060027CC RID: 10188 RVA: 0x001065CB File Offset: 0x001047CB
		protected void playDefault()
		{
			this.curFrame = 0;
			this.playSprite(this.defaultSprite);
		}

		// Token: 0x060027CD RID: 10189 RVA: 0x001065E4 File Offset: 0x001047E4
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

		// Token: 0x060027CE RID: 10190 RVA: 0x00106640 File Offset: 0x00104840
		public void AddEvent(int frame, object delEvent)
		{
			bool flag = !this.dMovieEvents.ContainsKey(frame);
			if (flag)
			{
				this.dMovieEvents.Add(frame, new List<object>());
			}
			this.dMovieEvents[frame].Add(delEvent);
		}

		// Token: 0x060027CF RID: 10191 RVA: 0x00106688 File Offset: 0x00104888
		public void RemoveEvent(int frame, object delEvent)
		{
			bool flag = !this.dMovieEvents.ContainsKey(frame);
			if (!flag)
			{
				this.dMovieEvents.Remove(frame);
			}
		}

		// Token: 0x060027D0 RID: 10192 RVA: 0x001066BC File Offset: 0x001048BC
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

		// Token: 0x060027D1 RID: 10193 RVA: 0x001066F9 File Offset: 0x001048F9
		public void SetEndEvent(object actionEvent)
		{
			this.actionOverObj = null;
			this.actionOverEvent = actionEvent;
		}

		// Token: 0x060027D2 RID: 10194 RVA: 0x0010670A File Offset: 0x0010490A
		public void SetEndEvent(LuaTable _lt, object actionEvent)
		{
			this.actionOverObj = _lt;
			this.actionOverEvent = actionEvent;
		}

		// Token: 0x060027D3 RID: 10195 RVA: 0x0010671B File Offset: 0x0010491B
		public void ClearEndEvent()
		{
			this.actionOverObj = null;
			this.actionOverEvent = null;
		}

		// Token: 0x060027D4 RID: 10196 RVA: 0x0010672C File Offset: 0x0010492C
		public void AddSprite(Sprite spr)
		{
			this.lSprites.Add(spr);
		}

		// Token: 0x060027D5 RID: 10197 RVA: 0x0010673C File Offset: 0x0010493C
		public void InsertSprite(Sprite spr, int index)
		{
			this.lSprites.Insert(index, spr);
		}

		// Token: 0x060027D6 RID: 10198 RVA: 0x0010674D File Offset: 0x0010494D
		public void AddNullSprite()
		{
			this.lSprites.Add(null);
		}

		// Token: 0x060027D7 RID: 10199 RVA: 0x0010675D File Offset: 0x0010495D
		public void ClearAll()
		{
			this.lSprites.Clear();
		}

		// Token: 0x060027D8 RID: 10200 RVA: 0x0010676C File Offset: 0x0010496C
		public void SetDefaultSprite(Sprite spr)
		{
			this.defaultSprite = spr;
		}

		// Token: 0x060027D9 RID: 10201 RVA: 0x00106776 File Offset: 0x00104976
		public void RemoveSprite(int index)
		{
			this.lSprites.RemoveAt(index);
		}

		// Token: 0x060027DA RID: 10202 RVA: 0x00106786 File Offset: 0x00104986
		public void RemoveSprite(Sprite spr)
		{
			this.lSprites.Remove(spr);
		}

		// Token: 0x060027DB RID: 10203 RVA: 0x00106798 File Offset: 0x00104998
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

		// Token: 0x040005C3 RID: 1475
		public int curFrame = 0;

		// Token: 0x040005C4 RID: 1476
		public float fDelta = 0f;

		// Token: 0x040005C5 RID: 1477
		public float fSep = 0.05f;

		// Token: 0x040005C6 RID: 1478
		public List<Sprite> lSprites;

		// Token: 0x040005C7 RID: 1479
		public SpriteRenderer shower;

		// Token: 0x040005C8 RID: 1480
		public Sprite defaultSprite = null;

		// Token: 0x040005C9 RID: 1481
		public Dictionary<int, List<object>> dMovieEvents = new Dictionary<int, List<object>>();

		// Token: 0x040005CA RID: 1482
		public bool debugPlayer = false;

		// Token: 0x040005CB RID: 1483
		public bool isPlaying = false;

		// Token: 0x040005CC RID: 1484
		public bool playerAlways = false;

		// Token: 0x040005CD RID: 1485
		public int playerCount = 0;

		// Token: 0x040005CE RID: 1486
		public object actionOverEvent;

		// Token: 0x040005CF RID: 1487
		public LuaTable actionOverObj;
	}
}
