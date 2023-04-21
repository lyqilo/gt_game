using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_TicketStoreTip: LTBY_Messagebox
    {
        Transform content;
        public LTBY_TicketStoreTip() : base(nameof(LTBY_TicketStoreTip), true) { }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            SetTitle(MessageBoxConfig.Title);
            content = LTBY_Extend.Instance.LoadPrefab("LTBY_TicketStoreTip",contentParent);
        }
    }
}
