using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_MedalTip: LTBY_Messagebox
    {
        Transform content;
        public LTBY_MedalTip() : base(nameof(LTBY_MedalTip), true) { }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);

            SetTitle(MedalConfig.Frame.Title);
            SetBoardProperty(MedalConfig.Frame.x, MedalConfig.Frame.y, MedalConfig.Frame.w, MedalConfig.Frame.h);
            content = LTBY_Extend.Instance.LoadPrefab("LTBY_MedalTip", contentParent);
            content.FindChildDepth<Text>("CurVipLevel").text = MedalConfig.Frame.VipText;
            //content.FindChildDepth<Text>("CurVipLevel/Num").text= "";
            content.FindChildDepth<Text>("CurMedalText").text = MedalConfig.Frame.MedalText;
            content.FindChildDepth<Text>("Des1").text = (MedalConfig.Frame.Des1);
            content.FindChildDepth<Text>("Des2").text = (MedalConfig.Frame.Des2);
            content.FindChildDepth<Text>("Des3").text = (MedalConfig.Frame.Des3);
        }
    }
}
