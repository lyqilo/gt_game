using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.WPBY
{
    public class WPBY_Effect : SingletonILEntity<WPBY_Effect>
    {
        Transform superPowr;
        private GameObject HaiLangLeftEffect;
        private GameObject HaiLangRightEffect;
        private GameObject SenceBackJpg;
        private GameObject SenceBackJpg2;
        private bool YC;

        protected override void FindComponent()
        {
            base.FindComponent();
            this.superPowr = this.transform.FindChildDepth("SuperPowr");
            this.HaiLangLeftEffect = this.transform.FindChildDepth("HaiLangLeft").gameObject;
            this.HaiLangRightEffect = this.transform.FindChildDepth("HaiLangRight").gameObject;
            this.SenceBackJpg = WPBYEntry.Instance.backgroundPanel.FindChildDepth("sence_bg_1").gameObject;
            this.SenceBackJpg2 = WPBYEntry.Instance.backgroundPanel.FindChildDepth("sence_bg_2").gameObject;
        }
        protected override void Awake()
        {
            base.Awake();
            this.YC = false;
        }
        public void FlyGold(WPBY_Fish fish, WPBY_Struct.FishData deadFishData, int chairId)
        {
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(chairId);
            if (player == null) return;
            if (fish.fishData.Kind == 16)
            {
                GameObject go = ToolHelper.Instantiate(WPBYEntry.Instance.goldEffectPoolAllScene.GetChild(0).gameObject);
                go.transform.SetParent(player.userGold.transform);
                go.transform.position = WPBYEntry.Instance.goldEffectPoolAllScene.GetChild(0).transform.position;
                go.transform.localScale = Vector3.one;
                go.gameObject.SetActive(true);
                WPBYEntry.Instance.DelayCall(3, () =>
                {
                    if (go != null)
                    {
                        go.transform.DOScale(Vector3.zero, 0.5f).SetEase(DG.Tweening.Ease.Linear);
                        go.transform.DOLocalMove(Vector3.zero, 0.5f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                        {
                            if (go != null)
                            {
                                ToolHelper.Destroy(go.gameObject);
                            }
                        });
                    }
                });
                return;
            }
            //float r = WPBYEntry.Instance.GetMagnificationToFishID(fish.fishData.id);
            int r = (int)Mathf.Ceil(fish.fishData.Kind / 3);
            if (r >= 25)
            {
                r = 25;
            }
            bool isFrist = true;
            GameObject goldObj = this.FindUsedGold();
            goldObj.transform.SetParent(fish.transform);
            goldObj.transform.localPosition = Vector3.zero;
            goldObj.transform.localScale = Vector3.zero;
            goldObj.transform.SetParent(player.userGold.transform);
            goldObj.gameObject.SetActive(true);
            for (int i = 0; i < r; i++)
            {
                goldObj.transform.GetChild(i).gameObject.SetActive(true);
            }
            WPBYEntry.Instance.DelayCall(0.5f, () =>
            {
                if (goldObj == null) return;

                Vector3 newPoint = new Vector3(goldObj.transform.localPosition.x + Random.Range(-r * 20, r * 20), goldObj.transform.localPosition.y + Random.Range(-r * 20, r * 20), 0);
                goldObj.transform.DOScale(Vector3.one, 0.5f).SetEase(DG.Tweening.Ease.OutBack);
                goldObj.transform.DOLocalMove(newPoint, 0.5f).SetEase(DG.Tweening.Ease.OutBack).OnComplete(() =>
                {
                    WPBYEntry.Instance.DelayCall(0.7f, () =>
                    {
                        if (goldObj == null) return;
                        goldObj.transform.DOLocalMove(Vector3.zero, Random.Range(0.3f, 0.7f)).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                        {
                            if (goldObj == null) return;
                            goldObj.gameObject.SetActive(false);
                            goldObj.transform.SetParent(WPBYEntry.Instance.goldEffectPool);
                            if (isFrist)
                            {
                                this.ShowAddGoldEffect(player.userGold.transform, chairId);
                                isFrist = false;
                            }
                        });
                    });
                });
            });
        }
        public void OnShowScure(WPBY_Fish fish, int scur, int site)
        {
            if (fish.fishData.Kind >= 18) return;
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(site);
            if (player == null) return;
            float magnification = WPBYEntry.Instance.GetMagnificationToFishID(fish.fishData.id);
            GameObject o = ToolHelper.Instantiate(this.transform.Find("Socur_0").gameObject);
            //if (magnification <= 10) {
            //    o = ToolHelper.Instantiate(this.transform.Find("Socur_0").gameObject);
            //}
            //else if (magnification <= 15) {
            //    o = ToolHelper.Instantiate(this.transform.Find("Socur_1").gameObject);
            //}
            //else
            //{
            //    o = ToolHelper.Instantiate(this.transform.Find("Socur_2").gameObject);
            //}
            o.gameObject.SetActive(true);
            o.transform.SetParent(WPBYEntry.Instance.effectScene);
            o.transform.GetComponent<TextMeshProUGUI>().text = ToolHelper.ShowRichText(scur);
            o.transform.position = fish.transform.position;
            o.transform.localScale = Vector3.one;
            WPBYEntry.Instance.DelayCall(1, () =>
            {
                if (o != null)
                {
                    ToolHelper.Destroy(o.gameObject);
                }
            });
        }
        public void ShowSuperJack(int scur, WPBY_Fish fish, int chairId)
        {
            GameObject obj = null;
            if (fish.fishData.Kind == 13)
            {
                //银鲨
                obj = ToolHelper.Instantiate(this.transform.Find("WPBU_defengpan01").gameObject);
                int ys = Random.Range(1, 3);
                WPBY_Audio.Instance.PlaySound($"YS{ys}");
            }
            else if (fish.fishData.Kind == 14)
            {
                //金鲨
                obj = ToolHelper.Instantiate(this.transform.Find("WPBU_defengpan01").gameObject);
                int js = Random.Range(1, 3);
                WPBY_Audio.Instance.PlaySound($"JS{js}");
            }
            else if (fish.fishData.Kind == 15)
            {
                //金龙
                GameObject eff = ToolHelper.Instantiate(this.transform.Find("WPBU_baozha03").gameObject);
                eff.transform.SetParent(WPBYEntry.Instance.effectScene);
                eff.transform.position = fish.transform.position;
                eff.transform.localScale = Vector3.one;
                eff.gameObject.SetActive(true);
                WPBYEntry.Instance.DelayCall(1.5f, () =>
                {
                    if (eff != null)
                    {
                        ToolHelper.Destroy(eff.gameObject);
                    }
                });
                obj = ToolHelper.Instantiate(this.transform.Find("WPBU_defengpan01").gameObject);
                int jl = Random.Range(1, 3);
                WPBY_Audio.Instance.PlaySound($"JL{jl}");
            }
            else if (fish.fishData.Kind == 16)
            {
                //金币海豚
                obj = ToolHelper.Instantiate(this.transform.Find("WPBU_defengpan02").gameObject);
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.Boss);
            }
            else if (fish.fishData.Kind == 18)
            {
                //全屏
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.QP);
            }
            else if (fish.fishData.Kind == 19)
            {
                //局部
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.JBZD);
            }
            else if (fish.fishData.Kind >= 20 && fish.fishData.Kind <= 24)
            {
                //同类
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.TL);
            }
            if (obj == null) return;
            obj.gameObject.SetActive(true);
            obj.transform.SetParent(WPBYEntry.Instance.effectScene);
            obj.transform.position = fish.transform.position;
            obj.transform.localScale = Vector3.one;
            obj.transform.FindChildDepth<TextMeshProUGUI>("goldText").text = ToolHelper.ShowRichText(scur);
            WPBYEntry.Instance.DelayCall(1, () =>
            {
                if (obj == null) return;
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(chairId);
                if (player != null)
                {
                    obj.transform.SetParent(player.transform);
                    obj.transform.DOLocalMove(new Vector3(0, 170, 0), 1).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                       {
                           WPBYEntry.Instance.DelayCall(1, () =>
                           {
                               if (obj != null)
                               {
                                   ToolHelper.Destroy(obj.gameObject);
                               }
                           });
                       });
                }
                else
                {
                    WPBYEntry.Instance.DelayCall(1, () =>
                    {
                        if (obj != null)
                        {
                            ToolHelper.Destroy(obj.gameObject);
                        }
                    });
                }
            });
        }

        public void ShowAddGoldEffect(Transform t, int site)
        {
            WPBY_Audio.Instance.PlaySound(WPBY_Audio.FlyCoin0);
        }

        public GameObject FindUsedGold()
        {
            GameObject child = null;
            for (int i = 1; i < WPBYEntry.Instance.goldEffectPool.childCount; i++)
            {
                child = WPBYEntry.Instance.goldEffectPool.GetChild(i).gameObject;
                if (!child.gameObject.activeSelf)
                {
                    return child;
                }
            }
            child = ToolHelper.Instantiate(WPBYEntry.Instance.goldEffectPool.GetChild(0).gameObject);
            child.transform.SetParent(WPBYEntry.Instance.goldEffectPool);
            child.gameObject.name = WPBYEntry.Instance.goldEffectPool.GetChild(0).gameObject.name;
            child.transform.localPosition = Vector3.one;
            child.transform.localScale = Vector3.one;
            for (int i = 0; i < child.transform.childCount; i++)
            {
                Transform trans = child.transform.GetChild(i);
                trans.gameObject.SetActive(false);
                if (i == 0)
                    trans.localPosition = new Vector3(0, 0, 0);
                else if (i == 1)
                    trans.localPosition = new Vector3(-60, 0, 0);
                else if (i == 2)
                    trans.localPosition = new Vector3(0, 60, 0);
                else if (i == 3)
                    trans.localPosition = new Vector3(60, 0, 0);
                else if (i == 4)
                    trans.localPosition = new Vector3(0, -60, 0);
                else if (i == 5)
                    trans.localPosition = new Vector3(-60, -60, 0);
                else if (i == 6)
                    trans.localPosition = new Vector3(60, -60, 0);
                else if (i == 7)
                    trans.localPosition = new Vector3(-60, 60, 0);
                else if (i == 8)
                    trans.localPosition = new Vector3(60, 60, 0);
                else if (i == 9)
                    trans.localPosition = new Vector3(0, 120, 0);
                else if (i == 10)
                    trans.localPosition = new Vector3(-60, 120, 0);
                else if (i == 11)
                    trans.localPosition = new Vector3(60, 120, 0);
                else if (i == 12)
                    trans.localPosition = new Vector3(-120, 0, 0);
                else if (i == 13)
                    trans.localPosition = new Vector3(-120, 60, 0);
                else if (i == 14)
                    trans.localPosition = new Vector3(-120, 120, 0);
                else if (i == 15)
                    trans.localPosition = new Vector3(-120, -60, 0);
                else if (i == 16)
                    trans.localPosition = new Vector3(120, 0, 0);
                else if (i == 17)
                    trans.localPosition = new Vector3(120, 60, 0);
                else if (i == 18)
                    trans.localPosition = new Vector3(120, 120, 0);
                else if (i == 19)
                    trans.localPosition = new Vector3(120, -60, 0);
                else if (i == 20)
                    trans.localPosition = new Vector3(0, 120, 0);
                else if (i == 21)
                    trans.localPosition = new Vector3(-60, -120, 0);
                else if (i == 22)
                    trans.localPosition = new Vector3(60, 120, 0);
                else if (i == 23)
                    trans.localPosition = new Vector3(-120, -120, 0);
                else if (i == 24)
                    trans.localPosition = new Vector3(120, -120, 0);
            }
            return child;
        }
        public void OnShowSuperPowrEffect(bool isshow, float time, int site)
        {
            this.superPowr.gameObject.SetActive(isshow);
            WPBYEntry.Instance.DelayCall(time, () =>
            {
                this.superPowr.gameObject.SetActive(false);
                WPBY_PlayerController.Instance.OnSetPlayerState(0, site);
            });

            for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
            {
                this.superPowr.transform.Find($"ShowGuns_{i}").gameObject.SetActive(i == site);
            }
        }
        public void OnShowHaiLang(int spriteId, int rotate)
        {
            float rate = (float)Screen.width / Screen.height;
            if (rotate == 1)
            {
                this.HaiLangLeftEffect.SetActive(true);
                this.YC = true;
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.HaiLang);
                this.HaiLangLeftEffect.transform.localPosition = new Vector3(-rate * 640 / 2, 0, 0);
                this.HaiLangLeftEffect.transform.DOLocalMoveX(rate * 640, 4.5f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                {
                    this.HaiLangLeftEffect.SetActive(false);
                    this.YC = false;
                    this.HaiLangLeftEffect.transform.localPosition = new Vector3(-1000, 0, 0);
                });
                this.SenceBackJpg.transform.SetAsFirstSibling();
                this.SenceBackJpg.transform.DOLocalMoveX(rate * 640, 3).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                {
                    this.SenceBackJpg.GetComponent<Image>().sprite = this.SenceBackJpg2.GetComponent<Image>().sprite;
                    this.SenceBackJpg.transform.localPosition = Vector3.zero;
                });
                this.SenceBackJpg2.SetActive(true);
                this.SenceBackJpg2.transform.localPosition = new Vector3(-rate * 640, 0, 0);
                this.SenceBackJpg2.transform.DOLocalMoveX(0, 3).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
              {
                  this.SenceBackJpg2.transform.localPosition = new Vector3(-rate * 640, 0, 0);
                  this.SenceBackJpg2.SetActive(false);
                  this.SenceBackJpg2.transform.SetAsFirstSibling();
              });
            }
            else if (rotate == 2)
            {
                this.YC = true;
                this.HaiLangRightEffect.SetActive(true);
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.HaiLang);
                this.HaiLangRightEffect.transform.localPosition = new Vector3(rate * 640 / 2, 0, 0);
                this.HaiLangRightEffect.transform.DOLocalMoveX(-rate * 640, 4.5f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
              {
                  this.HaiLangRightEffect.SetActive(false);
                  this.YC = false;
                  this.HaiLangRightEffect.transform.localPosition = new Vector3(1085, 0, 0);
              });
                this.SenceBackJpg.transform.DOLocalMoveX(-rate * 640, 3).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
              {
                  this.SenceBackJpg.GetComponent<Image>().sprite = this.SenceBackJpg2.GetComponent<Image>().sprite;
                  this.SenceBackJpg.transform.localPosition = Vector3.zero;
              });
                this.SenceBackJpg2.SetActive(true);
                this.SenceBackJpg2.transform.localPosition = new Vector3(rate * 640, 0, 0);
                this.SenceBackJpg2.transform.DOLocalMoveX(0, 3f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
              {
                  this.SenceBackJpg2.transform.localPosition = new Vector3(rate * 640, 0, 0);
                  this.SenceBackJpg2.SetActive(false);
              });
            }
        }
        public void OnChangeBGYuChao(int bgId)
        {
            this.SenceBackJpg2.GetComponent<Image>().sprite = WPBYEntry.Instance.backgroup.GetChild(bgId).GetComponent<Image>().sprite;
        }
        public void OnChangeBGStart(int bgId)
        {
            this.SenceBackJpg.GetComponent<Image>().sprite = WPBYEntry.Instance.backgroup.GetChild(bgId).GetComponent<Image>().sprite;
        }
        public void ShuiHuZhuan()
        {
            Transform shz = this.transform.Find("WPBU_baozha04");
            WPBY_Audio.Instance.PlaySound(WPBY_Audio.QP);
            shz.gameObject.SetActive(true);
            WPBYEntry.Instance.DelayCall(2, () =>
            {
                shz.gameObject.SetActive(false);
            });
            List<WPBY_Fish> fishlist = WPBY_FishController.Instance.OnGetFishToSence();
            this.ShowSingleBomb(fishlist);
        }

        public void ShowSingleBomb(List<WPBY_Fish> fishlist)
        {
            for (int i = 0; i < fishlist.Count; i++)
            {
                GameObject go = ToolHelper.Instantiate(this.transform.Find("WPBU_baozha01").gameObject);
                go.transform.SetParent(fishlist[i].transform);
                go.transform.localPosition = Vector3.zero;
                go.transform.localScale = Vector3.one;
                go.gameObject.SetActive(true);
                WPBYEntry.Instance.DelayCall(1, () =>
                {
                    if (go != null)
                    {
                        ToolHelper.Destroy(go.gameObject);
                    }
                });
            }
        }
        public void TLZDEffectEvent()
        {
            Transform tlzd = this.transform.Find("WPBU_baozha03");
            tlzd.gameObject.SetActive(true);
            WPBYEntry.Instance.DelayCall(1, () =>
            {
                tlzd.gameObject.SetActive(false);
            });
        }
        public void JBZDEffectEvent()
        {
            Transform jbzd = this.transform.Find("WPBU_baozha02");
            jbzd.gameObject.SetActive(true);
            WPBYEntry.Instance.DelayCall(2, () =>
            {
                jbzd.gameObject.SetActive(false);
            });
        }

        public void ShowOhterFishDead(int scur, string name, Transform par, WPBY_Fish fish)
        {
            GameObject ohterFishDeadEffect = this.transform.Find("OhterFishDead").gameObject;
            GameObject o = ToolHelper.Instantiate(ohterFishDeadEffect);
            o.SetActive(true);
            o.transform.SetParent(par);
            o.transform.localRotation = Quaternion.identity;
            o.transform.localScale = new Vector3(0.8f, 0.8f, 1);
            o.transform.position = fish.transform.position;
            WPBYEntry.Instance.DelayCall(2, () =>
            {
                if (o == null) return;
                o.transform.DOScale(new Vector3(0.3f, 0.3f, 0), 0.5f).SetEase(DG.Tweening.Ease.Linear);
                o.transform.DOLocalMove(Vector3.zero, 1).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                   {
                       ToolHelper.Destroy(o.gameObject);
                   });
            });
        }
    }
}
