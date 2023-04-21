

using System.Collections.Generic;
using UnityEngine;
using DragonBones;
using Transform = UnityEngine.Transform;
using UnityEngine.UI;
using DG.Tweening;
using System.Collections;
using TMPro;

namespace Hotfix.TouKui
{
    public class TouKui_SpecialMode : ILHotfixEntity
    {
        private HierarchicalStateMachine hsm;
        private List<IState> states;

        Transform effectNode;

        private Transform changeSceneNode;
        private UnityArmatureComponent changeSceneEffect;

        private Transform enterFreeNode;
        private UnityArmatureComponent enterFreeEffect;

        private Transform freeSelectNode;

        private UnityArmatureComponent selectPic;
        private UnityArmatureComponent selectCycle;
        private UnityArmatureComponent buttonEffect;
        private UnityArmatureComponent jinchange1;
        private UnityArmatureComponent saoguang;
        private Transform freeLightNode;
        private Transform renWuNode;
        private Button sureBtn;

        private SpecialMode currentMode;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new FreeGameLoadingState(this, hsm));
            states.Add(new SelectGameState(this, hsm));
            states.Add(new ZhuanChangeState(this, hsm));
            states.Add(new ExitSpecialModeState(this, hsm));
            states.Add(new FuDongSpecialModeState(this, hsm));
            states.Add(new GuDingSpecialModeState(this, hsm));
            states.Add(new BeiShuSpecialModeState(this, hsm));
            states.Add(new KuoSanSpecialModeState(this, hsm));

            hsm.Init(states, nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
            if (Input.GetKeyDown(KeyCode.Space))
            {
                hsm?.ChangeState(nameof(FreeGameLoadingState));
            }
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            effectNode = transform.FindChildDepth("Content/Effect");
            changeSceneNode = effectNode.FindChildDepth("ChangeScene");
            changeSceneEffect = changeSceneNode.FindChildDepth<UnityArmatureComponent>("armatureName");
            enterFreeNode = effectNode.FindChildDepth("EnterFree");
            enterFreeEffect = enterFreeNode.FindChildDepth<UnityArmatureComponent>("armatureName");
            freeSelectNode = effectNode.FindChildDepth("FreeSelect");
            selectPic = freeSelectNode.FindChildDepth<UnityArmatureComponent>("SelectPic/armatureName");
            selectCycle = freeSelectNode.FindChildDepth<UnityArmatureComponent>("SelectCycle/armatureName");
            buttonEffect = freeSelectNode.FindChildDepth<UnityArmatureComponent>("ButtonEffect/armatureName");
            jinchange1 = freeSelectNode.FindChildDepth<UnityArmatureComponent>("Free1/armatureName");
            saoguang = freeSelectNode.FindChildDepth<UnityArmatureComponent>("Free2/armatureName");

            freeLightNode = effectNode.FindChildDepth("FreeLightEffect");

            renWuNode = effectNode.FindChildDepth("FreeType");

            sureBtn = effectNode.FindChildDepth<Button>("SureBtn");
        }
        /// <summary>
        /// 添加ui事件
        /// </summary>
        private void AddListener()
        {
            sureBtn.onClick.RemoveAllListeners();
            sureBtn.onClick.Add(OnEnterFreeGame);
        }
        /// <summary>
        /// 添加消息事件
        /// </summary>
        protected override void AddEvent()
        {
            TouKui_Event.OnEnterSpecialGame += TouKui_Event_OnEnterSpecialGame;
            TouKui_Event.ExitSpecialMode += TouKui_Event_ExitSpecialMode;
            TouKui_Event.ChangeSpecialModeBackground += TouKui_Event_ChangeSpecialModeBackground;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        /// <summary>
        /// 移除消息事件
        /// </summary>
        protected override void RemoveEvent()
        {
            TouKui_Event.OnEnterSpecialGame -= TouKui_Event_OnEnterSpecialGame;
            TouKui_Event.ExitSpecialMode -= TouKui_Event_ExitSpecialMode;
            TouKui_Event.ChangeSpecialModeBackground -= TouKui_Event_ChangeSpecialModeBackground;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }


        private void OnEnterFreeGame()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            TouKui_Event.DispatchChangeSpecialModeBackground(TouKuiEntry.Instance.GameData.CurrentMode);
            TouKui_Event.DispatchSelectFreeGameComplete();
        }
        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void TouKui_Event_ExitSpecialMode()
        {
            hsm?.ChangeState(nameof(ExitSpecialModeState));
        }

        private void TouKui_Event_OnEnterSpecialGame(bool isFree, SpecialMode mode)
        {
            currentMode = mode;
            if (isFree)
            {
                hsm?.ChangeState(nameof(FreeGameLoadingState));
            }
            else
            {
                hsm?.ChangeState(nameof(ZhuanChangeState));
            }
        }

        private void TouKui_Event_ChangeSpecialModeBackground(SpecialMode mode)
        {
            freeSelectNode.gameObject.SetActive(false);
            enterFreeNode.gameObject.SetActive(false);
            sureBtn.gameObject.SetActive(false);
            selectPic.transform.parent.localPosition = new Vector3(0, 0, 0);
            selectCycle.transform.parent.localPosition = new Vector3(0, 0, 0);
            for (int i = 0; i < freeSelectNode.transform.childCount; i++)
            {
                freeSelectNode.GetChild(i).gameObject.SetActive(false);
            }
            //改变背景的时候切换到对应免费模式
            hsm?.ChangeState($"{mode}SpecialModeState");
        }

        /// <summary>
        /// 回收特效动画
        /// </summary>
        /// <param name="effect">特效动画</param>
        private void CollectEffect(GameObject effect)
        {
            if (effect == null) return;
            effect.transform.SetParent(TouKuiEntry.Instance.effectPool);
            effect.SetActive(false);
        }
        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreatHitEffect(string effectName)
        {
            //创建动画，先从对象池中获取
            Transform go = TouKuiEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = TouKuiEntry.Instance.effectList.Find(effectName);
            GameObject _go = GameObject.Instantiate(go.gameObject);
            return _go;
        }
        /// <summary>
        /// 默认状态
        /// </summary>
        private class IdleState : State<TouKui_SpecialMode>
        {
            public IdleState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.changeSceneNode.gameObject.SetActive(false);
                owner.freeSelectNode.gameObject.SetActive(false);
                owner.enterFreeNode.gameObject.SetActive(false);
                owner.sureBtn.gameObject.SetActive(false);
                owner.selectPic.transform.parent.localPosition = new Vector3(0, 0, 0);
                owner.selectCycle.transform.parent.localPosition = new Vector3(0, 0, 0);
                for (int i = 0; i < owner.freeSelectNode.transform.childCount; i++)
                {
                    owner.freeSelectNode.GetChild(i).gameObject.SetActive(false);
                }
            }
        }
        /// <summary>
        /// 进入特殊模式
        /// </summary>
        private class ZhuanChangeState : State<TouKui_SpecialMode>
        {
            public ZhuanChangeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                owner.changeSceneNode.gameObject.SetActive(true);
                owner.changeSceneEffect.AddDBEventListener(EventObject.COMPLETE, OnEffectShowComplete);
                owner.changeSceneEffect.dbAnimation.Stop();
                owner.changeSceneEffect.dbAnimation.Play("zhuanchang1", 1);
                DebugHelper.LogError($"播放转场动画");
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                TouKui_Event.DispatchChangeSpecialModeBackground(owner.currentMode);
            }

            private void OnEffectShowComplete(string type, EventObject eventObject)
            {
                string animName = eventObject.animationState.name;
                if (animName.Equals("zhuanchang1"))
                {
                    owner.changeSceneEffect.dbAnimation.Play("xingxing", 1);
                }
                else if (animName.Equals("xingxing"))
                {
                    owner.changeSceneEffect.RemoveDBEventListener(EventObject.COMPLETE, OnEffectShowComplete);
                }
            }
        }
        /// <summary>
        /// 退出特殊模式
        /// </summary>
        private class ExitSpecialModeState : State<TouKui_SpecialMode>
        {
            public ExitSpecialModeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            string animName = "";
            public override void OnEnter()
            {
                base.OnEnter();
                owner.changeSceneNode.gameObject.SetActive(true);
                owner.changeSceneEffect.AddDBEventListener(EventObject.COMPLETE, OnEffectShowComplete);
                animName = "zhuanchang2";
                owner.changeSceneEffect.dbAnimation.Play(animName, 1);
                TouKui_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                TouKuiEntry.Instance.GameData.CurrentNormalMode = SpecialMode.None;
                TouKuiEntry.Instance.GameData.isNormalFreeGame = false;
                TouKuiEntry.Instance.GameData.CurrentMode = SpecialMode.None;
                TouKuiEntry.Instance.GameData.isFreeGame = false;
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.changeSceneEffect.RemoveDBEventListener(EventObject.COMPLETE, OnEffectShowComplete);
            }

            private void OnEffectShowComplete(string type, EventObject eventObject)
            {
                if (animName.Equals("zhuanchang2"))
                {
                    animName = "xingxing";
                    owner.changeSceneEffect.dbAnimation.Play(animName, 1);
                }
                else if (animName.Equals("xingxing"))
                {
                    animName = "";
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

        /// <summary>
        /// 免费入场
        /// </summary>
        private class FreeGameLoadingState : State<TouKui_SpecialMode>
        {
            public FreeGameLoadingState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.enterFreeNode.gameObject.SetActive(true);
                owner.enterFreeEffect.AddDBEventListener(EventObject.COMPLETE, MFYX_OnAnimationEventHandler);
                owner.changeSceneEffect.AddDBEventListener(EventObject.COMPLETE, XingXing_OnAnimationEventHandler);
                owner.enterFreeEffect.dbAnimation.Play("mfyx", 1);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.BeginFreeGame);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.enterFreeEffect.RemoveDBEventListener(EventObject.COMPLETE, MFYX_OnAnimationEventHandler);
            }

            private void MFYX_OnAnimationEventHandler(string type, EventObject eventObject)
            {
                owner.enterFreeEffect.RemoveDBEventListener(EventObject.COMPLETE, MFYX_OnAnimationEventHandler);
                OnEnterFreeComplete();
            }

            private void XingXing_OnAnimationEventHandler(string type, EventObject eventObject)
            {
                owner.changeSceneEffect.RemoveDBEventListener(EventObject.COMPLETE, XingXing_OnAnimationEventHandler);
            }
            private void ZhuanChang_OnAnimationEventHandler(string type, EventObject eventObject)
            {
                owner.changeSceneEffect.RemoveDBEventListener(EventObject.COMPLETE, ZhuanChang_OnAnimationEventHandler);
                owner.changeSceneEffect.AddDBEventListener(EventObject.COMPLETE, XingXing_OnAnimationEventHandler);
                owner.changeSceneEffect.dbAnimation.Play("xingxing", 1);
            }
            private void OnEnterFreeComplete()
            {
                owner.enterFreeNode.gameObject.SetActive(false);
                Color color = owner.freeSelectNode.GetComponent<Image>().color;
                owner.freeSelectNode.GetComponent<Image>().color = new Color(color.r, color.g, color.b, 0);
                owner.freeSelectNode.gameObject.SetActive(true);
                owner.changeSceneNode.gameObject.SetActive(true);
                owner.changeSceneEffect.AddDBEventListener(EventObject.COMPLETE, ZhuanChang_OnAnimationEventHandler);
                owner.changeSceneEffect.dbAnimation.Play("zhuanchang1", 1);

                owner.freeSelectNode.GetComponent<Image>().DOFade(1, 0.2f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    hsm?.ChangeState(nameof(SelectGameState));
                });
                owner.jinchange1.transform.parent.gameObject.SetActive(true);
                owner.jinchange1.dbAnimation.Play("jinchang2", 1);
                owner.saoguang.transform.parent.gameObject.SetActive(true);
                owner.saoguang.dbAnimation.Play("shuaguang");
            }
        }
        /// <summary>
        /// 免费选型
        /// </summary>
        private class SelectGameState : State<TouKui_SpecialMode>
        {
            public SelectGameState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private Dictionary<string, SpecialMode> modeAnimDic = new Dictionary<string, SpecialMode>()
            {
                ["jinchang1"] = SpecialMode.BeiShu,
                ["hong1"] = SpecialMode.BeiShu,
                ["lv1"] = SpecialMode.FuDong,
                ["lan1"] = SpecialMode.GuDing,
                ["huang1"] = SpecialMode.KuoSan,
            };
            private Dictionary<SpecialMode, string> selectMode = new Dictionary<SpecialMode, string>()
            {
                [SpecialMode.BeiShu] = "hong2",
                [SpecialMode.FuDong] = "lv2",
                [SpecialMode.GuDing] = "lan2",
                [SpecialMode.KuoSan] = "huang2",
            };
            private Dictionary<string, string> playOrder = new Dictionary<string, string>()
            {
                ["jinchang1"] = "huang1",
                ["hong1"] = "huang1",
                ["huang1"] = "lv1",
                ["lv1"] = "lan1",
                ["lan1"] = "hong1",
            };

            int playCount = 0;
            float timer = 0;
            string currentAnimName;
            bool islunbo;
            public override void OnEnter()
            {
                base.OnEnter();
                playCount = 0;
                timer = 0;
                islunbo = false;
                owner.freeLightNode.gameObject.SetActive(true);
                owner.selectPic.AddDBEventListener(EventObject.COMPLETE, OnAnimationEventHandler);
                owner.selectPic.transform.parent.gameObject.SetActive(true);
                currentAnimName = "jinchang1";
                owner.selectPic.dbAnimation.Play(currentAnimName, 1);
                islunbo = true;
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.FreeSelectRoll);
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.selectPic.RemoveDBEventListener(EventObject.COMPLETE, OnAnimationEventHandler);
            }
            public override void Update()
            {
                base.Update();
                if (!islunbo) return;
                timer += Time.deltaTime;
                if (timer >= 0.15f)
                {
                    timer = 0;
                    playCount++;
                    SpecialMode currentmode = modeAnimDic[currentAnimName];
                    string aninName = playOrder[currentAnimName];
                    if (currentmode == TouKuiEntry.Instance.GameData.CurrentMode && playCount >= 16)//需要循环多少次
                    {
                        aninName = selectMode[TouKuiEntry.Instance.GameData.CurrentMode];
                        islunbo = false;
                    }
                    currentAnimName = aninName;
                    owner.selectPic.dbAnimation.Play(currentAnimName, 1);
                }
            }

            private void OnAnimationEventHandler(string type, EventObject eventObject)
            {
                string animName = eventObject.animationState.name;
                if (animName.Contains("2"))
                {
                    OnShowSelectResult();
                }
            }
            private void OnShowSelectResult()
            {
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.FreeSelectOK);
                owner.selectCycle.transform.parent.gameObject.SetActive(true);
                owner.selectCycle.dbAnimation.Play("quan", 1);
                owner.selectCycle.transform.parent.DOLocalMove(new Vector3(-160, 0, 0), 0.2f).SetEase(Ease.Linear).SetDelay(0.3f);
                owner.selectPic.transform.parent.DOLocalMove(new Vector3(-160, 0, 0), 0.2f).SetEase(Ease.Linear).SetDelay(0.3f).OnComplete(delegate ()
                {
                    for (int i = 0; i < owner.renWuNode.childCount; i++)
                    {
                        bool isShow = i + 1 == (int)TouKuiEntry.Instance.GameData.CurrentMode;
                        owner.renWuNode.GetChild(i).gameObject.SetActive(isShow);
                    }
                    owner.renWuNode.gameObject.SetActive(true);
                    owner.buttonEffect.transform.parent.gameObject.SetActive(true);
                    owner.buttonEffect.dbAnimation.Play("jinchang4", 1);
                    owner.sureBtn.gameObject.SetActive(true);
                });
            }
        }
        /// <summary>
        /// 扩散模式
        /// </summary>
        private class KuoSanSpecialModeState : State<TouKui_SpecialMode>
        {
            public KuoSanSpecialModeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            List<int> wildPos = new List<int>();
            private Transform rollContent;
            private Transform kuosanContent;
            private Transform icons;
            private Transform lightGroup;
            private Transform animGroup;

            private int totalCount;
            public override void OnEnter()
            {
                base.OnEnter();
                rollContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/RollContent"); //显示库
                kuosanContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/KuosanContent"); //显示库
                icons = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/Icons"); //图标库
                lightGroup = kuosanContent.FindChildDepth("LightGroup"); //显示库
                animGroup = kuosanContent.FindChildDepth("AnimGroup"); //显示库
                for (int i = 0; i < lightGroup.childCount; i++)
                {
                    lightGroup.GetChild(i).gameObject.SetActive(false);
                }
                TouKui_Event.RollComplete += TouKui_Event_RollComplete;
                kuosanContent.gameObject.SetActive(true);
            }

            private void TouKui_Event_RollComplete()
            {
                FindAllWild();
            }
            /// <summary>
            /// 找到现有的wild,扩散
            /// </summary>
            private void FindAllWild()
            {
                totalCount = 0;
                wildPos.Clear();
                for (int i = 0; i < TouKuiEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
                {
                    if (TouKuiEntry.Instance.GameData.ResultData.cbIcon[i] == 10)
                    {
                        wildPos.Add(i);
                    }
                }
                if (wildPos.Count <= 0)//如果没有wild就进入结算
                {
                    TouKui_Event.DispatchShowResult();
                    return;
                }
                KuoSan();
            }
            /// <summary>
            /// 开始向两边扩散，找到胸和屁股才扩散
            /// </summary>
            private void KuoSan()
            {
                for (int i = 0; i < wildPos.Count; i++)
                {
                    CalculateAroundSpecialIcon(wildPos[i]);
                }
            }
            /// <summary>
            /// 计算周围特殊Icon
            /// </summary>
            /// <param name="currentPos">当前位置</param>
            private void CalculateAroundSpecialIcon(int currentPos)
            {
                int currentRow = currentPos / 5;
                int currentCol = currentPos % 5;
                List<Vector2> pos = new List<Vector2>();
                //计算九宫格八个方向
                for (int i = -1; i < 2; i++)
                {
                    for (int j = -1; j < 2; j++)
                    {
                        if (i == 0 && j == 0) continue;
                        int row = currentRow + i;
                        int col = currentCol + j;
                        if (IsSpecialIcon(row, col))
                        {
                            pos.Add(new Vector2(col, row));
                        }
                    }
                }
                totalCount += pos.Count;
                if (pos.Count <= 0)
                {
                    //这个图标周围没有可以变化的
                    if (totalCount <= 0)
                    {
                        TouKui_Event.DispatchShowResult();
                    }
                    return;
                }
                Transform orgin = rollContent.GetChild(currentCol).GetComponent<ScrollRect>().content.GetChild(currentRow);
                for (int i = 0; i < pos.Count; i++)
                {
                    Transform target = rollContent.GetChild((int)pos[i].x).GetComponent<ScrollRect>().content.GetChild((int)pos[i].y);
                    owner.Behaviour.StartCoroutine(ShowIconChangeEffect(orgin, target, (int)(pos[i].y * 5 + pos[i].x)));
                }
            }
            /// <summary>
            /// 展示改变目标icon效果
            /// </summary>
            /// <param name="orgin">原位置</param>
            /// <param name="target">目标位置</param>
            private IEnumerator ShowIconChangeEffect(Transform orgin, Transform target, int targetIndex)
            {
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.KuoSanSound);
                GameObject effect1 = owner.CreatHitEffect("BBEffect1");
                effect1.transform.SetParent(animGroup);
                effect1.transform.position = orgin.position;
                effect1.transform.localRotation = Quaternion.identity;
                effect1.transform.localScale = Vector3.one;
                effect1.SetActive(true);
                yield return new WaitForSeconds(0.5f);
                GameObject lightItem = FindUsedLight();
                lightItem.transform.position = orgin.position;
                lightItem.SetActive(true);
                lightItem.transform.DOMove(target.position, 0.5f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    GameObject effect2 = owner.CreatHitEffect("BBEffect2");
                    effect2.transform.SetParent(animGroup);
                    effect2.transform.position = target.position;
                    effect2.transform.localRotation = Quaternion.identity;
                    effect2.transform.localScale = Vector3.one;
                    effect2.SetActive(true);
                    ToolHelper.RunGoal(0, 1, 0.5f).OnComplete(delegate ()
                    {
                        lightItem.SetActive(false);
                        owner.CollectEffect(effect1);
                        owner.CollectEffect(effect2);
                        //改变这个icon的Icon
                        Sprite changeIcon = icons.FindChildDepth<Image>("Item13").sprite;
                        target.FindChildDepth<Image>("Icon").sprite = changeIcon;
                        target.gameObject.name = "Item13";
                        TouKuiEntry.Instance.GameData.ResultData.cbIcon[targetIndex] = 10;
                        ToolHelper.RunGoal(0, 1, 0.5f).OnComplete(delegate ()
                        {
                            totalCount--;
                            CalculateAroundSpecialIcon(targetIndex);
                        });
                    });
                });
            }
            /// <summary>
            /// 找可用的light
            /// </summary>
            /// <returns></returns>
            private GameObject FindUsedLight()
            {
                for (int i = 0; i < lightGroup.childCount; i++)
                {
                    if (!lightGroup.GetChild(i).gameObject.activeSelf) return lightGroup.GetChild(i).gameObject;
                }
                GameObject go = GameObject.Instantiate(lightGroup.GetChild(0).gameObject);
                go.SetActive(false);
                go.transform.SetParent(lightGroup);
                go.transform.localScale = Vector3.one;
                go.transform.localRotation = Quaternion.identity;
                go.transform.localPosition = Vector3.zero;
                return go;
            }
            /// <summary>
            /// 判断该位置是否需要变
            /// </summary>
            /// <param name="row">行 横向</param>
            /// <param name="col">列 竖向</param>
            /// <returns></returns>
            private bool IsSpecialIcon(int row, int col)
            {
                if (row >= 0 && col >= 0 && row <= 2 && col <= 4)
                {
                    int index = TouKuiEntry.Instance.GameData.ResultData.cbIcon[row * 5 + col];
                    if (index >= 6 && index <= 9) return true;
                }
                return false;
            }

            public override void OnExit()
            {
                base.OnExit();
                for (int i = animGroup.childCount - 1; i >= 0; i--)
                {
                    owner.CollectEffect(animGroup.GetChild(i).gameObject);
                }
                kuosanContent.gameObject.SetActive(false);
                TouKui_Event.RollComplete -= TouKui_Event_RollComplete;
            }
        }
        /// <summary>
        /// 固定模式
        /// </summary>
        private class GuDingSpecialModeState : State<TouKui_SpecialMode>
        {
            public GuDingSpecialModeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private Transform animContent;
            private Transform gudingContent;
            bool hasGuding;
            public override void OnEnter()
            {
                base.OnEnter();
                animContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/AnimContent"); //显示库
                gudingContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/GudingContent"); //显示库
                TouKui_Event.RollComplete += TouKui_Event_RollComplete;
                TouKui_Event.StartRoll += TouKui_Event_StartRoll;
                gudingContent.gameObject.SetActive(true);
                TouKuiEntry.Instance.GameData.FixWild.Clear();
            }

            private void TouKui_Event_StartRoll()
            {
                List<int> posList = new List<int>();
                for (int i = 0; i < TouKuiEntry.Instance.GameData.FixWild.Count; i++)
                {
                    if (TouKuiEntry.Instance.GameData.FixWild[i] != 0)
                    {
                        posList.Add(i);
                    }
                }
                for (int i = 0; i < posList.Count; i++)
                {
                    int hitIndex = posList[i];
                    int col = hitIndex / 5;
                    int raw = hitIndex % 5;
                    Transform animTrans = animContent.GetChild(raw).GetChild(0).GetChild(col);
                    GameObject effect = owner.CreatHitEffect("Item14");
                    effect.transform.SetParent(gudingContent);
                    effect.transform.localScale = Vector3.one;
                    effect.transform.localRotation = Quaternion.identity;
                    effect.transform.position = animTrans.position;
                    effect.SetActive(true);
                    effect.GetComponent<Animator>().SetTrigger("Close");
                    TouKui_Audio.Instance.PlaySound(TouKui_Audio.GuDingSound);
                }
            }

            private void TouKui_Event_RollComplete()
            {
                hasGuding = gudingContent.childCount > 0;
                for (int i = 0; i < gudingContent.childCount; i++)
                {
                    gudingContent.GetChild(i).GetComponent<Animator>().SetTrigger("Open");
                }
                owner.Behaviour.StartCoroutine(DelayShowResult(hasGuding ? 1 : 0));
            }
            private IEnumerator DelayShowResult(float timer)
            {
                yield return new WaitForSeconds(timer);
                for (int i = gudingContent.childCount - 1; i >= 0; i--)
                {
                    owner.CollectEffect(gudingContent.GetChild(i).gameObject);
                }
                TouKui_Event.DispatchShowResult();
                TouKuiEntry.Instance.GameData.FixWild = TouKuiEntry.Instance.GameData.ResultData.cbFixed;
            }

            public override void OnExit()
            {
                base.OnExit();
                for (int i = gudingContent.childCount - 1; i >= 0; i--)
                {
                    owner.CollectEffect(gudingContent.GetChild(i).gameObject);
                }
                gudingContent.gameObject.SetActive(false);
                TouKui_Event.RollComplete -= TouKui_Event_RollComplete;
                TouKui_Event.StartRoll -= TouKui_Event_StartRoll;
            }
        }
        /// <summary>
        /// 倍数模式
        /// </summary>
        private class BeiShuSpecialModeState : State<TouKui_SpecialMode>
        {
            public BeiShuSpecialModeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            Transform beishuContent;
            Transform lightGroup;
            Animator addBeiAnim;
            Transform animGroup;
            TextMeshProUGUI oddTxt;
            int currentOdd;
            public override void OnEnter()
            {
                base.OnEnter();
                beishuContent = TouKuiEntry.Instance.MainContent.FindChildDepth("XMContent");
                lightGroup = beishuContent.FindChildDepth("Content");
                animGroup = beishuContent.FindChildDepth("Anim");
                addBeiAnim = beishuContent.FindChildDepth<Animator>("ShowBei");
                oddTxt = addBeiAnim.transform.FindChildDepth<TextMeshProUGUI>("Num");
                addBeiAnim.gameObject.SetActive(true);
                currentOdd = TouKuiEntry.Instance.GameData.CurrentExtOdd;
                for (int i = 0; i < lightGroup.childCount; i++)
                {
                    lightGroup.GetChild(i).gameObject.SetActive(false);
                }
                beishuContent.gameObject.SetActive(true);
                oddTxt.text = $"x{currentOdd}".ShowRichText();
                TouKui_Event.AddSpecialBeiShu += TouKui_Event_AddSpecialBeiShu;
                TouKui_Event.RollComplete += TouKui_Event_RollComplete;
            }

            private void TouKui_Event_RollComplete()
            {
                TouKui_Event.DispatchShowResult();
            }
            private void TouKui_Event_AddSpecialBeiShu(List<Vector3> pos)
            {
                owner.Behaviour.StartCoroutine(CreateEffect(pos));
            }
            private IEnumerator CreateEffect(List<Vector3> pos)
            {
                for (int i = 0; i < pos.Count; i++)
                {
                    GameObject animObj = owner.CreatHitEffect("Item15");
                    animObj.transform.SetParent(animGroup);
                    animObj.transform.localRotation = Quaternion.identity;
                    animObj.transform.localScale = Vector3.one;
                    animObj.transform.position = pos[i];
                    animObj.SetActive(true);
                    animObj.GetComponent<Animator>().SetTrigger("Add");
                    yield return DelayShowLight(1, pos[i], animObj);
                }
            }
            private IEnumerator DelayShowLight(float timer, Vector3 pos, GameObject animObj)
            {
                GameObject lightObj = FindUsedLight(addBeiAnim.transform, pos);
                lightObj.SetActive(true);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.BeiShuSound);
                lightObj.transform.DOMove(addBeiAnim.transform.position, 0.5f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    lightObj.SetActive(false);
                    addBeiAnim.SetTrigger("Add");
                    currentOdd++;
                    TouKui_Audio.Instance.PlaySound(TouKui_Audio.JiaBei);
                    oddTxt.text = $"x{currentOdd}".ShowRichText();
                });
                yield return new WaitForSeconds(timer);
                owner.CollectEffect(animObj);
            }
            private GameObject FindUsedLight(Transform target, Vector3 pos)
            {
                GameObject obj = null;
                for (int i = 0; i < lightGroup.childCount; i++)
                {
                    if (!lightGroup.GetChild(i).gameObject.activeSelf)
                    {
                        obj = lightGroup.GetChild(i).gameObject;
                        break;
                    }
                }
                if (obj == null)
                {
                    obj = GameObject.Instantiate(lightGroup.GetChild(0).gameObject);
                }
                obj.transform.SetParent(lightGroup);
                obj.transform.position = pos;
                obj.transform.localScale = Vector3.one;
                Vector3 dir = target.position - obj.transform.position;
                float angle = (360 - Mathf.Atan2(dir.x, dir.y) * Mathf.Rad2Deg) - 90;
                obj.transform.eulerAngles = new Vector3(0, 0, angle);
                return obj;
            }

            public override void OnExit()
            {
                base.OnExit();
                beishuContent.gameObject.SetActive(false);
                TouKui_Event.AddSpecialBeiShu -= TouKui_Event_AddSpecialBeiShu;
                TouKui_Event.RollComplete -= TouKui_Event_RollComplete;
            }
        }
        /// <summary>
        /// 浮动模式
        /// </summary>
        private class FuDongSpecialModeState : State<TouKui_SpecialMode>
        {
            public FuDongSpecialModeState(TouKui_SpecialMode owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            Transform fudongContent;
            Transform animGroup;
            Transform animContent;
            Transform showBeiTrans;
            Transform lightGroup;
            Animator hitEffect;
            Transform heartGroup;
            Transform titleGroup;

            Vector3 startPos;
            int currentType;

            GameObject effect;
            int heartCount;
            int currentHeartCount = 0;

            private List<string> fudongType = new List<string>()
            {
                "2x1","2x2","2x3","3x3"
            };
            public override void OnEnter()
            {
                base.OnEnter();
                TouKui_Event.RollPrepreaComplete += TouKui_Event_RollPrepreaComplete;
                TouKui_Event.ChangeFudong += TouKui_Event_ChangeFudong;
                TouKui_Event.RollComplete += TouKui_Event_RollComplete;
                TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
                TouKui_Event.ShowFuDongWin += TouKui_Event_ShowFuDongWin;
                Init();
            }

            public override void OnExit()
            {
                base.OnExit();
                fudongContent.gameObject.SetActive(false);
                for (int i = animGroup.childCount - 1; i >= 0; i--)
                {
                    owner.CollectEffect(animGroup.GetChild(i).gameObject);
                }
                TouKui_Event.RollPrepreaComplete -= TouKui_Event_RollPrepreaComplete;
                TouKui_Event.ChangeFudong -= TouKui_Event_ChangeFudong;
                TouKui_Event.RollComplete -= TouKui_Event_RollComplete;
                TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
                TouKui_Event.ShowFuDongWin -= TouKui_Event_ShowFuDongWin;
            }
            private void Init()
            {
                fudongContent = TouKuiEntry.Instance.MainContent.FindChildDepth("HSContent");
                animContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/AnimContent"); //显示库
                animGroup = fudongContent.FindChildDepth("Anim");
                showBeiTrans = fudongContent.FindChildDepth("ShowBei");
                lightGroup = fudongContent.FindChildDepth("LightGroup");
                for (int i = 0; i < lightGroup.childCount; i++)
                {
                    lightGroup.GetChild(i).gameObject.SetActive(false);
                }
                hitEffect = showBeiTrans.FindChildDepth<Animator>("Anim");
                hitEffect.SetTrigger("Idle");
                heartGroup = showBeiTrans.FindChildDepth("Group");
                titleGroup = showBeiTrans.FindChildDepth("Title");
                fudongContent.gameObject.SetActive(true);
                if (TouKuiEntry.Instance.GameData.CurrentFuDongType == 0)
                {
                    TouKuiEntry.Instance.GameData.CurrentFuDongType = 1;
                }
                currentType = TouKuiEntry.Instance.GameData.CurrentFuDongType;
                heartCount = TouKuiEntry.Instance.GameData.CurrentFuDongExtWildCount;
                currentHeartCount = heartCount;
                bool isActive = false;
                for (int i = 0; i < heartGroup.childCount; i++)
                {
                    heartGroup.GetChild(i).gameObject.SetActive(i <= currentType);
                    Transform collect = heartGroup.GetChild(i).FindChildDepth("Collect");
                    if (currentType == 4)
                    {
                        isActive = true;
                        collect.gameObject.SetActive(true);
                    }
                    else
                    {
                        isActive = currentHeartCount > i;
                        collect.gameObject.SetActive(isActive);
                    }
                    if (isActive)
                    {
                        collect.FindChildDepth<UnityArmatureComponent>("armatureName").dbAnimation.Play("shouji2");
                    }
                }
                for (int i = 0; i < titleGroup.childCount; i++)
                {
                    titleGroup.GetChild(i).gameObject.SetActive(i + 1 == currentType);
                }
                effect = owner.CreatHitEffect(fudongType[currentType - 1]);
                effect.transform.SetParent(animGroup);
                effect.transform.position = GetEffectPos();
                effect.transform.localScale = new Vector3(1, 0, 1);
                effect.transform.localRotation = Quaternion.identity;
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(true);
                effect.gameObject.SetActive(true);
                effect.transform.DOScale(Vector3.one, 0.3f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    effect.transform.FindChildDepth("Anim").gameObject.SetActive(false);
                });
            }
            private Vector3 GetEffectPos()
            {
                int row = 0;
                int col = 0;
                Vector3 startTrans;
                Vector3 endTrans;
                Vector3 tartget = Vector3.zero;
                if (currentType == 1)
                {
                    row = UnityEngine.Random.Range(0, 3);
                    col = UnityEngine.Random.Range(0, 4);
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row).position;
                    tartget = (startTrans + endTrans) / 2;
                }
                else if (currentType == 2)
                {
                    row = UnityEngine.Random.Range(0, 2);
                    col = UnityEngine.Random.Range(0, 4);
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 1).position;
                    tartget = (startTrans + endTrans) / 2;
                }
                else if (currentType == 3)
                {
                    row = UnityEngine.Random.Range(0, 1);
                    col = UnityEngine.Random.Range(0, 4);
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 2).position;
                    tartget = (startTrans + endTrans) / 2;
                }
                else if (currentType == 4)
                {
                    row = UnityEngine.Random.Range(0, 1);
                    col = UnityEngine.Random.Range(0, 3);
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 2).GetChild(0).GetChild(row + 2).position;
                    tartget = (startTrans + endTrans) / 2;
                }
                return tartget;
            }


            private void TouKui_Event_ShowFuDongWin(bool isshow)
            {
                effect.transform.FindChildDepth<Animator>("Icon").SetTrigger(isshow ? "Run" : "Idle");
            }
            private void TouKui_Event_ChangeFudong()
            {
                heartCount = TouKuiEntry.Instance.GameData.CurrentFuDongExtWildCount;
                List<int> existList = GetExistWildIndex();
                List<int> newWildList = new List<int>();
                for (int i = 0; i < TouKuiEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
                {
                    int index = TouKuiEntry.Instance.GameData.ResultData.cbIcon[i];
                    if (index == 10)//判断是否为wild
                    {
                        if (!existList.Contains(i))
                        {
                            newWildList.Add(i);
                        }
                    }
                }
                if (newWildList.Count <= 0)
                {
                    TouKui_Event.DispatchCheckRunState();
                    return;
                }
                owner.Behaviour.StartCoroutine(ShowWildEffect(newWildList));
            }

            private IEnumerator ShowWildEffect(List<int> newWildList)
            {
                for (int i = 0; i < newWildList.Count; i++)
                {
                    bool isUpdate = false;
                    GameObject lightObj = ToolHelper.InstantiateChild(lightGroup.gameObject, i);
                    int col = newWildList[i] % 5;
                    int row = newWildList[i] / 5;
                    Transform wild = animContent.GetChild(col).GetChild(0).GetChild(row);
                    lightObj.transform.SetParent(lightGroup);
                    lightObj.transform.position = wild.position;
                    lightObj.transform.localScale = Vector3.one;
                    lightObj.SetActive(true);
                    yield return new WaitForSeconds(0.5f);
                    lightObj.transform.DOScale(0.7f, 0.5f).SetEase(Ease.Linear);
                    lightObj.transform.DOMove(showBeiTrans.position, 0.5f).SetEase(Ease.Linear).OnComplete(delegate ()
                    {
                        hitEffect.SetTrigger("Hit");
                        lightObj.SetActive(false);
                    });
                    yield return new WaitForSeconds(0.5f);
                    TouKui_Audio.Instance.PlaySound(TouKui_Audio.BeiShuSound);
                    if (currentType == 4)
                    {
                        TouKui_Event.DispatchCheckRunState();
                        yield break;
                    }
                    currentHeartCount++;
                    if (currentHeartCount >= currentType + 1)
                    {
                        isUpdate = true;
                    }
                    if (isUpdate)
                    {
                        currentHeartCount = 0;
                        currentType = TouKuiEntry.Instance.GameData.CurrentFuDongType;
                        heartGroup.GetChild(currentType).gameObject.SetActive(true);
                        for (int j = 0; j < heartGroup.childCount; j++)
                        {
                            heartGroup.GetChild(j).FindChildDepth("Collect").gameObject.SetActive(false);
                        }
                        for (int j = 0; j < titleGroup.childCount; j++)
                        {
                            titleGroup.GetChild(j).gameObject.SetActive(currentType - 1 == j);
                        }
                        yield return UpgradeFudongIcon(currentType);
                    }
                    else
                    {
                        owner.Behaviour.StartCoroutine(ShowShoujiEffect(currentHeartCount));
                    }
                }
                TouKui_Event.DispatchCheckRunState();
            }

            private IEnumerator ShowShoujiEffect(int heartCount)
            {
                UnityArmatureComponent collect = heartGroup.GetChild(heartCount - 1).FindChildDepth<UnityArmatureComponent>("Collect/armatureName");
                collect.transform.parent.gameObject.SetActive(true);
                collect.dbAnimation.Play("shouji1", 1);
                yield return new WaitForSeconds(0.5f);
                collect.dbAnimation.Play("shouji2");
            }

            /// <summary>
            /// 升级icon
            /// </summary>
            private IEnumerator UpgradeFudongIcon(int type)
            {
                if (type == 1)
                {
                    yield break;
                }
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.FuDongSound);
                if (type == 2)//如果是2x2
                {
                    yield return CreateType2();
                }
                else if (type == 3)
                {
                    yield return CreateType3();
                }
                else if (type == 4)
                {
                    yield return CreateType4();
                }
            }

            private IEnumerator CreateType4()
            {
                int row = TouKuiEntry.Instance.GameData.FuDongStartRow;
                int col = TouKuiEntry.Instance.GameData.FuDongStartCol;
                Vector3 startTrans = Vector3.zero;
                Vector3 endTrans = Vector3.zero;
                if (TouKuiEntry.Instance.GameData.FuDongStartCol == 2)
                {
                    startTrans = animContent.GetChild(col - 1).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 2).position;
                }
                else
                {
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 2).GetChild(0).GetChild(row + 2).position;
                }
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(true);
                yield return new WaitForSeconds(0.5f);
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(false);
                effect.transform.DOMove((startTrans + endTrans) / 2, 0.3f).SetEase(Ease.Linear);
                effect.transform.DOScaleX(1.5f, 0.3f).SetEase(Ease.Linear).OnComplete(delegate()
                {
                    owner.CollectEffect(effect);
                    effect = owner.CreatHitEffect(fudongType[3]);
                    effect.transform.SetParent(animGroup);
                    effect.transform.localRotation = Quaternion.identity;
                    effect.transform.localScale = Vector3.one;
                    effect.transform.position = (startTrans + endTrans) / 2;
                    effect.SetActive(true);
                });
                yield return new WaitForSeconds(0.3f);
            }

            private IEnumerator CreateType3()
            {
                int row = TouKuiEntry.Instance.GameData.FuDongStartRow;
                int col = TouKuiEntry.Instance.GameData.FuDongStartCol;
                Vector3 startTrans = Vector3.zero;
                Vector3 endTrans = Vector3.zero;
                if (TouKuiEntry.Instance.GameData.FuDongStartRow == 0)
                {
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 2).position;
                }
                else
                {
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row + 1).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row - 1).position;
                }
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(true);
                yield return new WaitForSeconds(0.5f);
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(false);
                effect.transform.DOMove((startTrans + endTrans) / 2, 0.3f).SetEase(Ease.Linear);
                effect.transform.DOScaleY(1.5f, 0.3f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    owner.CollectEffect(effect);
                    effect = owner.CreatHitEffect(fudongType[2]);
                    effect.transform.SetParent(animGroup);
                    effect.transform.localRotation = Quaternion.identity;
                    effect.transform.localScale = Vector3.one;
                    effect.transform.position = (startTrans + endTrans) / 2;
                    effect.SetActive(true);
                });
                yield return new WaitForSeconds(0.3f);
            }

            private IEnumerator CreateType2()
            {
                int row = TouKuiEntry.Instance.GameData.FuDongStartRow;
                int col = TouKuiEntry.Instance.GameData.FuDongStartCol;
                Vector3 startTrans = Vector3.zero;
                Vector3 endTrans = Vector3.zero;
                if (TouKuiEntry.Instance.GameData.FuDongStartRow == 2)
                {
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row - 1).position;
                }
                else
                {
                    startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 1).position;
                }
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(true);
                yield return new WaitForSeconds(0.5f);
                effect.transform.FindChildDepth("Anim").gameObject.SetActive(false);
                effect.transform.DOMove((startTrans + endTrans) / 2, 0.3f).SetEase(Ease.Linear);
                effect.transform.DOScaleY(2, 0.3f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    owner.CollectEffect(effect);
                    effect = owner.CreatHitEffect(fudongType[1]);
                    effect.transform.SetParent(animGroup);
                    effect.transform.localRotation = Quaternion.identity;
                    effect.transform.localScale = Vector3.one;
                    effect.transform.position = (startTrans + endTrans) / 2;
                    effect.SetActive(true);
                });
                yield return new WaitForSeconds(0.3f);
            }

            /// <summary>
            /// 获取已经存在的wild位置
            /// </summary>
            /// <returns></returns>
            private List<int> GetExistWildIndex()
            {
                int row = TouKuiEntry.Instance.GameData.FuDongStartRow;
                int col = TouKuiEntry.Instance.GameData.FuDongStartCol;
                List<int> existPos = new List<int>();
                if (currentType == 1)
                {
                    existPos.Add(row * 5 + col);
                    existPos.Add(row * 5 + col + 1);
                }
                else if (currentType == 2)
                {
                    existPos.Add(row * 5 + col);
                    existPos.Add(row * 5 + col + 1);
                    existPos.Add((row + 1) * 5 + col);
                    existPos.Add((row + 1) * 5 + col + 1);
                }
                else if (currentType == 3)
                {
                    existPos.Add(row * 5 + col);
                    existPos.Add(row * 5 + col + 1);
                    existPos.Add((row + 1) * 5 + col);
                    existPos.Add((row + 1) * 5 + col + 1);
                    existPos.Add((row + 2) * 5 + col);
                    existPos.Add((row + 2) * 5 + col + 1);
                }
                else if (currentType == 4)
                {
                    existPos.Add(row * 5 + col);
                    existPos.Add(row * 5 + col + 1);
                    existPos.Add(row * 5 + col + 2);
                    existPos.Add((row + 1) * 5 + col);
                    existPos.Add((row + 1) * 5 + col + 1);
                    existPos.Add((row + 1) * 5 + col + 2);
                    existPos.Add((row + 2) * 5 + col);
                    existPos.Add((row + 2) * 5 + col + 1);
                    existPos.Add((row + 2) * 5 + col + 2);
                }
                return existPos;
            }
            private void TouKui_Event_RollPrepreaComplete()
            {
                int row = TouKuiEntry.Instance.GameData.FuDongStartRow;
                int col = TouKuiEntry.Instance.GameData.FuDongStartCol;
                Vector3 startTrans = animContent.GetChild(col).GetChild(0).GetChild(row).position;
                Vector3 endTrans = Vector3.zero;
                if (currentType == 1)
                {
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row).position;
                }
                else if (currentType == 2)
                {
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 1).position;
                }
                else if (currentType == 3)
                {
                    endTrans = animContent.GetChild(col + 1).GetChild(0).GetChild(row + 2).position;
                }
                else if (currentType == 4)
                {
                    endTrans = animContent.GetChild(col + 2).GetChild(0).GetChild(row + 2).position;
                }
                startPos = (startTrans + endTrans) / 2;
                effect.transform.DOMove(startPos, 0.5f).SetEase(Ease.Linear);
            }
            private void TouKui_Event_RollComplete()
            {
                TouKui_Event.DispatchShowResult();
            }

            private void TouKui_Event_ShowResultComplete(bool iswin)
            {
                if (!iswin)
                {
                    TouKui_Event.DispatchChangeFudong();
                }
            }
        }
    }
}
