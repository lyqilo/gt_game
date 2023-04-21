using System.Collections;
using DG.Tweening;
using Spine;
using Spine.Unity;
using TMPro;
using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_NormalRollItem : ILHotfixEntity
    {
        private Animator anim;
        private SkeletonGraphic skele;
        private TextMeshProUGUI score;
        private bool isFree;

        public int Index;

        private int row;
        private int col;
        private Tweener tween;

        protected override void AddEvent()
        {
            base.AddEvent();
            TTTG_Event.ShowResultIcon += TTTG_EventOnShowResultIcon;
            TTTG_Event.OnHitSpecial += TTTG_EventOnOnHitSpecial;
            TTTG_Event.OnMoveItem += MoveItem;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TTTG_Event.ShowResultIcon -= TTTG_EventOnShowResultIcon;
            TTTG_Event.OnHitSpecial -= TTTG_EventOnOnHitSpecial;
            TTTG_Event.OnMoveItem -= MoveItem;
        }

        protected override void OnDestroy()
        {
            if (TTTGEntry.Instance != null)
            {
                transform.SetParent(TTTGEntry.Instance.cacheGroup);
            }

            tween?.Kill();
            base.OnDestroy();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            anim = transform.GetComponent<Animator>();
            score = transform.FindChildDepth<TextMeshProUGUI>($"Score");
            skele = transform.FindChildDepth<SkeletonGraphic>($"Anim");
        }

        public IEnumerator HitIcon()
        {
            // ReSharper disable once Unity.NoNullPropagation
            anim.SetTrigger($"Win");
            skele.gameObject.SetActive(true);
            // ReSharper disable once Unity.NoNullPropagation
            skele?.AnimationState.SetAnimation(0, $"bomb", false);
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Reel_feedback);
            yield return new WaitForSeconds(1);
            RemoveItem();
        }

        private void TTTG_EventOnOnHitSpecial(int hitIndex, Transform target)
        {
            if (Index != hitIndex) return; //不是本图标就不做处理
            Transform eff = TTTGEntry.Instance.GetEffect(TTTG_DataConfig.starEffect, TTTGEntry.Instance.transform);
            eff.gameObject.SetActive(true);
            eff.DOMove(target.position, 0.5f).OnComplete(() =>
            {
                ToolHelper.DelayRun(0.5f, () => { TTTGEntry.Instance.CollectEffect(eff.gameObject); });
            });
        }

        private void TTTG_EventOnShowResultIcon(bool _isFree)
        {
            tween?.Kill();
            tween = transform.DOLocalMove(new Vector3(0, -250, 0), 0.2f).SetDelay(0.05f * col + 0.05f * (row + 1))
                .OnComplete(RemoveItem);
        }

        private void MoveItem()
        {
            Behaviour.StartCoroutine(SetItem());
        }

        /// <summary>
        /// 设置行数
        /// </summary>
        /// <param name="itemIndex">元素索引</param>
        /// <param name="_isFree">是否为免费界面</param>
        public IEnumerator SetItem(int itemIndex = -1, bool _isFree = false)
        {
            isFree = _isFree;
            // ReSharper disable once Unity.NoNullPropagation
            anim?.SetTrigger($"Idle");
            bool isShow = row != transform.GetSiblingIndex();
            row = transform.GetSiblingIndex();
            col = transform.parent.GetSiblingIndex();
            if (itemIndex >= 0)
            {
                Index = itemIndex;
                transform.localPosition = new Vector3(0, 250, 0);
            }

            transform.localRotation = Quaternion.identity;
            transform.localScale = Vector3.one;
            score.text =
                ToolHelper.ShowRichText(TTTG_DataConfig.RateList[Index] * TTTGEntry.Instance.GameData.CurrentChip);
            tween?.Kill();
            tween = transform.DOLocalMove(new Vector3(0, 120 * (row - 1.5f), 0), 0.1f).OnComplete(() =>
            {
                if (!isShow) return;
                // ReSharper disable once Unity.NoNullPropagation
                anim?.SetTrigger($"Bounce");
                TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Reel_Stop, false);
            });
            yield return new WaitForSeconds(0.1f);
        }

        private void RemoveItem()
        {
            if (gameObject == null) return;
            gameObject.RemoveILComponent<TTTG_NormalRollItem>();
        }
    }
}