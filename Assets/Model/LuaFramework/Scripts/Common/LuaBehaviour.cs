using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace LuaFramework
{
    // Token: 0x020001E8 RID: 488
    public class LuaBehaviour : BaseBehaviour, IBeginDragHandler, IEventSystemHandler, IDragHandler, IEndDragHandler, IPointerClickHandler, IDropHandler
    {
        // Token: 0x060024D9 RID: 9433 RVA: 0x000F5AA7 File Offset: 0x000F3CA7
        protected void OnClick(GameObject obj)
        {
            base.CallFunc(this.funcOnClick, new object[]
            {
                base.mLuaTable,
                obj
            });
        }

        // Token: 0x060024DA RID: 9434 RVA: 0x000F5ACA File Offset: 0x000F3CCA
        protected void OnClickEvent(GameObject obj)
        {
            this.OnClick(obj);
        }

        // Token: 0x060024DB RID: 9435 RVA: 0x000F5AD5 File Offset: 0x000F3CD5
        public void OnBeginDrag(PointerEventData eventData)
        {
            base.CallFunc(this.funcOnBeginDrag, new object[]
            {
                base.mLuaTable,
                eventData
            });
        }

        // Token: 0x060024DC RID: 9436 RVA: 0x000F5AF8 File Offset: 0x000F3CF8
        public void OnDrag(PointerEventData eventData)
        {
            base.CallFunc(this.funcOnDrag, new object[]
            {
                base.mLuaTable,
                eventData
            });
        }

        // Token: 0x060024DD RID: 9437 RVA: 0x000F5B1B File Offset: 0x000F3D1B
        public void OnEndDrag(PointerEventData eventData)
        {
            base.CallFunc(this.funcOnEndDrag, new object[]
            {
                base.mLuaTable,
                eventData
            });
        }

        // Token: 0x060024DE RID: 9438 RVA: 0x000F5B3E File Offset: 0x000F3D3E
        public void OnDrop(PointerEventData eventData)
        {
            base.CallFunc(this.funcOnDrop, new object[]
            {
                base.mLuaTable,
                eventData
            });
        }

        // Token: 0x060024DF RID: 9439 RVA: 0x000F5B61 File Offset: 0x000F3D61
        public void OnPointerClick(PointerEventData eventData)
        {
            base.CallFunc(this.funcOnPointerClick, new object[]
            {
                base.mLuaTable,
                eventData
            });
        }

        // Token: 0x060024E0 RID: 9440 RVA: 0x000F5B84 File Offset: 0x000F3D84
        public void OnWillRenderObject()
        {
            base.CallFunc(this.funcOnWillRenderObject, new object[]
            {
                base.mLuaTable,
                base.gameObject
            });
        }

        // Token: 0x060024E1 RID: 9441 RVA: 0x000F5BAC File Offset: 0x000F3DAC
        public void AnimationOnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            base.CallFunc(this.funcAnimationOnStateEnter, new object[]
            {
                base.mLuaTable,
                animator,
                stateInfo,
                layerIndex
            });
        }

        // Token: 0x060024E2 RID: 9442 RVA: 0x000F5BE1 File Offset: 0x000F3DE1
        public void AnimationOnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            base.CallFunc(this.funcAnimationOnStateExit, new object[]
            {
                base.mLuaTable,
                animator,
                stateInfo,
                layerIndex
            });
        }

        // Token: 0x060024E3 RID: 9443 RVA: 0x000F5C16 File Offset: 0x000F3E16
        public void AnimationOnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            base.CallFunc(this.funcAnimationOnStateMove, new object[]
            {
                base.mLuaTable,
                animator,
                stateInfo,
                layerIndex
            });
        }

        // Token: 0x060024E4 RID: 9444 RVA: 0x000F5C4B File Offset: 0x000F3E4B
        public void AnimationOnPlyerOver(string str)
        {
            base.transform.Rotate(Vector3.up, 12f);
            base.CallFunc(this.funcAnimationOnPlyerOver, new object[]
            {
                base.mLuaTable,
                str
            });
        }

        // Token: 0x060024E5 RID: 9445 RVA: 0x000F5C84 File Offset: 0x000F3E84
        private bool CheckEvents(GameObject go, object luafunc)
        {
            bool flag = true;
            bool flag2 = go == null;
            bool result;
            if (flag2)
            {
                result = false;
            }
            else
            {
                foreach (KeyValuePair<string, object> keyValuePair in this.AddEvents)
                {
                    bool flag3 = keyValuePair.Key.Contains(go.name) && keyValuePair.Value.GetHashCode() == luafunc.GetHashCode();
                    if (flag3)
                    {
                        Debug.LogError("绑定事件重复=" + go.name + luafunc.GetHashCode());
                        flag = false;
                    }
                }
                bool flag4 = flag;
                if (flag4)
                {
                    this.AddEvents.Add(go.name + this.AddEvents.Count.ToString(), luafunc);
                }
                result = flag;
            }
            return result;
        }

        // Token: 0x060024E6 RID: 9446 RVA: 0x000F5D7C File Offset: 0x000F3F7C
        public void AddClick(GameObject go, object luafunc)
        {
            bool flag = go == null;
            if (!flag)
            {
                this.OnEvents.Add(luafunc);
                go.GetComponent<Button>().onClick.RemoveAllListeners();
                go.GetComponent<Button>().onClick.AddListener(delegate
                {

                    AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                    {
                        go
                    });
                });
            }
        }

        // Token: 0x060024E7 RID: 9447 RVA: 0x000F5DE4 File Offset: 0x000F3FE4
        public void AddValueChangeEvent(GameObject go, object luafunc)
        {
            this.OnEvents.Add(luafunc);
            UnityAction<string> unityAction = delegate (string str)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                {
                    go,
                    str
                });
            };
            go.GetComponent<InputField>().onValueChanged.RemoveAllListeners();
            go.GetComponent<InputField>().onValueChanged.AddListener(unityAction);
        }

        // Token: 0x060024E8 RID: 9448 RVA: 0x000F5E3C File Offset: 0x000F403C
        public void AddEndEditEvent(GameObject go, object luafunc)
        {
            this.OnEvents.Add(luafunc);
            UnityAction<string> unityAction = delegate (string str)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                {
                    go,
                    str
                });
            };
            go.GetComponent<InputField>().onEndEdit.RemoveAllListeners();
            go.GetComponent<InputField>().onEndEdit.AddListener(unityAction);
        }

        // Token: 0x060024E9 RID: 9449 RVA: 0x000F5E94 File Offset: 0x000F4094
        public void AddScrollbarEvent(GameObject go, object luafunc)
        {
            this.OnEvents.Add(luafunc);
            UnityAction<float> unityAction = delegate (float f)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                {
                    f
                });
            };
            go.GetComponent<Scrollbar>().onValueChanged.RemoveAllListeners();
            go.GetComponent<Scrollbar>().onValueChanged.AddListener(unityAction);
        }

        // Token: 0x060024EA RID: 9450 RVA: 0x000F5EE0 File Offset: 0x000F40E0
        public void AddSliderEvent(GameObject go, object luafunc)
        {
            this.OnEvents.Add(luafunc);
            UnityAction<float> unityAction = delegate (float f)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                {
                    f
                });
            };
            go.GetComponent<Slider>().onValueChanged.RemoveAllListeners();
            go.GetComponent<Slider>().onValueChanged.AddListener(unityAction);
        }
        public void AddScrollRectEvent(GameObject go, object luafunc)
        {
            this.OnEvents.Add(luafunc);
            go.GetComponent<ScrollRect>().onValueChanged.RemoveAllListeners();
            UnityAction<Vector2> unityAction = delegate (Vector2 f)
            {
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(luafunc, new object[]
                {
                    f
                });
            };
            go.GetComponent<ScrollRect>().onValueChanged.AddListener(unityAction);
        }


        // Token: 0x060024EB RID: 9451 RVA: 0x000F5F2C File Offset: 0x000F412C
        public void ClearClick()
        {
            for (int i = 0; i < this.OnEvents.Count; i++)
            {
                bool flag = this.OnEvents[i] != null;
                if (flag)
                {
                    this.OnEvents[i] = null;
                }
            }
        }

        // Token: 0x060024EC RID: 9452 RVA: 0x000F5F7C File Offset: 0x000F417C
        protected void OnDestroy()
        {
            base.CallFunc(this.funcOnDestroy, new object[]
            {
                base.mLuaTable,
                base.gameObject
            });
            this.ClearClick();
            this.AddEvents.Clear();
            bool flag = this.funcAwake != null;
            if (flag)
            {
                this.funcAwake.Dispose();
                this.funcAwake = null;
            }
            bool flag2 = this.funcStart != null;
            if (flag2)
            {
                this.funcStart.Dispose();
                this.funcStart = null;
            }
            bool flag3 = this.funcUpdate != null;
            if (flag3)
            {
                this.funcUpdate.Dispose();
                this.funcUpdate = null;
            }
            bool flag4 = this.funcFixedUpdate != null;
            if (flag4)
            {
                this.funcFixedUpdate.Dispose();
                this.funcFixedUpdate = null;
            }
            bool flag5 = this.funcOnEnable != null;
            if (flag5)
            {
                this.funcOnEnable.Dispose();
                this.funcOnEnable = null;
            }
            bool flag6 = this.funcOnClick != null;
            if (flag6)
            {
                this.funcOnClick.Dispose();
                this.funcOnClick = null;
            }
            bool flag7 = this.funcOnBeginDrag != null;
            if (flag7)
            {
                this.funcOnBeginDrag.Dispose();
                this.funcOnBeginDrag = null;
            }
            bool flag8 = this.funcOnDrag != null;
            if (flag8)
            {
                this.funcOnDrag.Dispose();
                this.funcOnDrag = null;
            }
            bool flag9 = this.funcOnEndDrag != null;
            if (flag9)
            {
                this.funcOnEndDrag.Dispose();
                this.funcOnEndDrag = null;
            }
            bool flag10 = this.funcOnDrop != null;
            if (flag10)
            {
                this.funcOnDrop.Dispose();
                this.funcOnDrop = null;
            }
            bool flag11 = this.funcOnPointerClick != null;
            if (flag11)
            {
                this.funcOnPointerClick.Dispose();
                this.funcOnPointerClick = null;
            }
            bool flag12 = this.funcOnWillRenderObject != null;
            if (flag12)
            {
                this.funcOnWillRenderObject.Dispose();
                this.funcOnWillRenderObject = null;
            }
            bool flag13 = this.funcOnTriggerEnter != null;
            if (flag13)
            {
                this.funcOnTriggerEnter.Dispose();
                this.funcOnTriggerEnter = null;
            }
            bool flag14 = this.funcOnTriggerStay != null;
            if (flag14)
            {
                this.funcOnTriggerStay.Dispose();
                this.funcOnTriggerStay = null;
            }
            bool flag15 = this.funcAnimationOnStateEnter != null;
            if (flag15)
            {
                this.funcAnimationOnStateEnter.Dispose();
                this.funcAnimationOnStateEnter = null;
            }
            bool flag16 = this.funcAnimationOnStateMove != null;
            if (flag16)
            {
                this.funcAnimationOnStateMove.Dispose();
                this.funcAnimationOnStateMove = null;
            }
            bool flag17 = this.funcAnimationOnPlyerOver != null;
            if (flag17)
            {
                this.funcAnimationOnPlyerOver.Dispose();
                this.funcAnimationOnPlyerOver = null;
            }
            bool flag18 = this.funcOnDestroy != null;
            if (flag18)
            {
                this.funcOnDestroy.Dispose();
                this.funcOnDestroy = null;
            }
            bool flag19 = base.mLuaTable != null;
            if (flag19)
            {
                base.mLuaTable.Dispose();
                base.mLuaTable = null;
            }
            this.lua = null;
        }

        // Token: 0x04000338 RID: 824
        private Dictionary<string, object> AddEvents = new Dictionary<string, object>();

        // Token: 0x04000339 RID: 825
        private List<object> OnEvents = new List<object>();
    }
}
