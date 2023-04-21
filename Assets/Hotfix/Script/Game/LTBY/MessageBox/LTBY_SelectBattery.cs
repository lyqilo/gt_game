using DG.Tweening;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_SelectBattery : LTBY_Messagebox
    {
        Transform content;

        int curLevel;

        // int lastLevel;
        private Dictionary<int, Transform> itemList;
        private Dictionary<Transform, int> recordSec;
        bool checkTime;

        public LTBY_SelectBattery() : base(nameof(LTBY_SelectBattery), true)
        {
            recordSec = new Dictionary<Transform, int>();
            itemList = new Dictionary<int, Transform>();
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            DebugHelper.LogError("进入选择炮台");
            SetTitle(BatteryConfig.Frame.Title);

            SetBoardProperty(BatteryConfig.Frame.x, BatteryConfig.Frame.y, BatteryConfig.Frame.w,
                BatteryConfig.Frame.h);

            content = LTBY_Extend.Instance.LoadPrefab("LTBY_SelectBattery", contentParent);
            content.GetComponent<RectTransform>().offsetMin = Vector2.zero;
            content.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            content.FindChildDepth<Text>("Tip").text = BatteryConfig.Frame.Tip;

            board.gameObject.SetActive(false);

            itemList.Clear();

            curLevel = 0;

            RegisterEvent();

        }

        private void RegisterEvent()
        {
            LTBY_Event.ChangeBatteryLevel += LTBY_EventOnChangeBatteryLevel;
        }

        private void LTBY_EventOnChangeBatteryLevel(LTBY_Struct.CMD_S_ChangeBulletLevel obj)
        {
            if (obj.wChairID != LTBY_GameView.GameInstance.chairId) return;
            SCSetProbability data = new SCSetProbability
            {
                chair_idx = obj.wChairID,
                code = 0,
                gun_level = obj.cbGunType + 1,
                gun_ratio = obj.cbGunLevel + 1
            };
            CallSetProbability(data);
        }

        private void CallSetProbability(SCSetProbability data)
        {
            if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                if (data.code != 0)
                {
                    LTBY_ViewManager.Instance.ShowTip(data.msg);
                }
                else
                {
                    curLevel = data.gun_level;
                    Transform[] _values = itemList.GetDictionaryValues();
                    int[] _keys = itemList.GetDictionaryKeys();

                    for (int i = 0; i < _values.Length; i++)
                    {
                        _values[i].FindChildDepth("Tick").gameObject.SetActive(_keys[i] == curLevel);
                    }
                }

                ExitAction();
            }
        }

        private void UnregisterEvent()
        {
            LTBY_Event.ChangeBatteryLevel -= LTBY_EventOnChangeBatteryLevel;
        }


        public void InitContent(List<GunInfoData> gunInfo, int lastLevel)
        {
            if (lastLevel != 0)
            {
                curLevel = lastLevel;
            }
            gunInfo.OrderByDescending((a, b) =>
            {
                if (a.enable && !b.enable)
                {
                    return true;
                }

                if (b.enable && !a.enable)
                {
                    return false;
                }

                if (!a.enable && !b.enable)
                {
                    return a.gun_level < b.gun_level;
                }

                if (a.gun_level == lastLevel)
                {
                    return true;
                }
                else if (b.gun_level == lastLevel)
                {
                    return false;
                }

                if (a.is_vip && !b.is_vip)
                {
                    return true;
                }

                if (b.is_vip && !a.is_vip)
                {
                    return false;
                }

                if (a.is_vip && b.is_vip)
                {
                    return a.gun_level > b.gun_level;
                }

                if (a.is_member && !b.is_member)
                {
                    return true;
                }

                if (b.is_member && !a.is_member)
                {
                    return false;
                }

                if (a.is_member && b.is_member)
                {
                    return a.gun_level > b.gun_level;
                }

                return a.gun_level < b.gun_level;
            });
            board.gameObject.SetActive(true);
            recordSec.Clear();
            checkTime = false;
            var batteryCfg = BatteryConfig.Battery;
            Transform parent = content.FindChildDepth("ScrollView/Viewport/Content");
            for (int i = 0; i < gunInfo.Count; i++)
            {
                var guninfo = gunInfo[i];
                int _level = guninfo.gun_level;
                BatteryData config = batteryCfg[_level];
                if (config != null)
                {
                    var item = itemList.ContainsKey(_level)
                        ? itemList[_level]
                        : LTBY_Extend.Instance.LoadPrefab("LTBY_SelectBatteryItem", parent);
                    // string str = "X" + ChangeUnit(guninfo.ratio_min) + BatteryConfig.Unit + "~X" +
                    //              ChangeUnit(guninfo.ratio_max) + BatteryConfig.Unit;
                    string str = "X" + ChangeUnit(guninfo.ratio_min) + "~X" +
                                 ChangeUnit(guninfo.ratio_max);
                    item.FindChildDepth<Text>("Range/Text").text = str;
                    item.FindChildDepth("BatteryImage").GetComponent<Image>().sprite =
                        LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName);
                    item.FindChildDepth("BatteryImage").localScale = config.scale != 0
                        ? new Vector3(config.scale, config.scale, config.scale)
                        : new Vector3(1, 1, 1);
                    item.FindChildDepth<Text>("Name").text = config.name;
                    item.FindChildDepth<Text>("Des1").text = config.des1;
                    item.FindChildDepth<Text>("Des2").text = config.des2;
                    if (guninfo.enable)
                    {
                        curLevel = curLevel != 0 ? curLevel : _level;
                        int sec = guninfo.member_sec;
                        if (sec > 0)
                        {
                            checkTime = true;
                            Transform countDown = item.FindChildDepth("Countdown");
                            countDown.gameObject.SetActive(true);
                            recordSec.Add(countDown, sec);
                            countDown.GetComponent<Text>().text = ChangeTime(sec);
                        }
                        else if (sec == -1)
                        {
                            Transform countDown = item.FindChildDepth("Countdown");
                            countDown.gameObject.SetActive(true);
                            countDown.GetComponent<Text>().text = BatteryConfig.Forever;
                        }

                        UnLockItem(item, _level);
                    }
                    else
                    {
                        LockItem(item, guninfo.is_vip, guninfo.is_member, guninfo.vip_limit, _level);
                    }

                    itemList.Remove(_level);
                    itemList.Add(_level, item);
                }
            }

            if (checkTime)
            {
                StartTimer("CheckTime", 1f, () =>
                {
                    Transform[] _keys = recordSec.GetDictionaryKeys();
                    int[] _value = recordSec.GetDictionaryValues();
                    for (int i = 0; i < _keys.Length; i++)
                    {
                        recordSec[_keys[i]] = recordSec[_keys[i]] - 1;

                        if (recordSec[_keys[i]] < 0)
                        {
                            _keys[i].gameObject.SetActive(false);
                            recordSec.Remove(_keys[i]);
                        }
                        else if (checkTime)
                        {
                            _keys[i].GetComponent<Text>().text = ChangeTime(_value[i]);
                        }
                    }
                }, -1);
            }

            itemList.TryGetValue(curLevel, out Transform battery);
            battery.FindChildDepth("Tick").gameObject.SetActive(true);
        }

        private string ChangeUnit(int num)
        {
            return num.ShortNumber();
            string str;

            if (num >= 10000)
                str = Mathf.FloorToInt((float)num / 10000) + BatteryConfig.Wan;
            else if (num >= 1000)
                str = Mathf.FloorToInt((float)num / 1000) + BatteryConfig.Qian;
            else
                str = num.ToString();

            return str;
        }

        private string ChangeTime(int sec)
        {
            string str = BatteryConfig.CountdownText;

            if (sec >= 86400)
            {
                int d = Mathf.FloorToInt((float)sec / 86400);
                str = $"{str}{d}{BatteryConfig.Day}";
            }
            else
            {
                if (sec > 3600)
                {
                    var h = Mathf.FloorToInt((float)sec / 3600);
                    sec -= h * 3600;
                    str = $"{str}{h}{BatteryConfig.Hour}";
                }

                if (sec > 60)
                {
                    var m = Mathf.FloorToInt((float)sec / 60);
                    sec -= m * 60;
                    str = $"{str}{m}{BatteryConfig.Minute}";
                }

                if (sec > 0)
                {
                    str = $"{str}{sec}{BatteryConfig.Second}";
                }
            }

            return str;
        }

        private void UnLockItem(Transform item, int level)
        {
            Transform btn = item.FindChildDepth("BtnLock");
            btn.gameObject.SetActive(false);
            item.FindChildDepth("LockMask").gameObject.SetActive(false);
            item.FindChildDepth("Des1").gameObject.SetActive(true);
            item.FindChildDepth("Des2").gameObject.SetActive(true);
            AddClick(item, () => { SelectItem(item, level); });
        }

        private void LockItem(Transform item, bool isVip, bool isMember, int limitLevel, int gunLevel)
        {
            var btn = item.FindChildDepth("BtnLock");
            if (isVip)
            {
                btn.FindChildDepth<Text>("Text").text =
                    $"{BatteryConfig.VipLockText}{(limitLevel != 0 ? limitLevel : -1)}{BatteryConfig.Level}";
            }
            else if (isMember)
            {
                btn.FindChildDepth<Text>("Text").text = gunLevel == BatteryConfig.LuckyCatGunLevel ? BatteryConfig.Permanent : BatteryConfig.MemberLockText;
            }
            else
            {
                btn.FindChildDepth<Text>("Text").text = BatteryConfig.LockText;
            }
            btn.gameObject.SetActive(true);
            item.FindChildDepth("LockMask").gameObject.SetActive(true);
            item.FindChildDepth("Des1").gameObject.SetActive(false);
            item.FindChildDepth("Des2").gameObject.SetActive(false);

            AddClick(item, () =>
            {
                if (isMember)
                {
                    var tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
                    tipBox.SetTitle(MessageBoxConfig.Title);
                    tipBox.GetComponent<Text>().text = gunLevel == BatteryConfig.LuckyCatGunLevel ? MessageBoxConfig.LuckyCatLimit : MessageBoxConfig.MemberBatteryLimit;
                }
                else if (isVip)
                {
                    var tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
                    tipBox.SetTitle(MessageBoxConfig.Title);
                    tipBox.GetComponent<Text>().text = MessageBoxConfig.VipBatteryLimit;
                    tipBox.HideBtnBack();
                    tipBox.ShowBtnConfirm(() => { }, true);
                }
            });
        }

        private void SelectItem(Transform item, int level)
        {
            if (actionPlaying) return;
            LTBY_Struct.PlayerChangeGunLevel gunLevel = new LTBY_Struct.PlayerChangeGunLevel()
            {
                gunLevel = 0,
                gunGrade = (byte)(level - 1),
                wChairId = LTBY_GameView.GameInstance.chairId
            };
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_CHANGEBULLETLEVEL, gunLevel.Buffer);
            //   GC.NetworkRequest.Request("CSSetProbability",{
            //               gun_level = level,
            //});
            //这里把当前选中的炮台level存到GameView中
            if (LTBY_GameView.GameInstance != null)
            {
                LTBY_GameView.GameInstance.gun_level = level;
            }

            //这里如果是自己发送的服务器不会返回,直接改变
            LTBY_Struct.CMD_S_ChangeBulletLevel playerGunLevel = new LTBY_Struct.CMD_S_ChangeBulletLevel()
            {
                wChairID = LTBY_GameView.GameInstance.chairId,
                cbGunLevel = 0,
                cbGunType = (byte)(level-1)
            };
            LTBY_Event.DispatchChangeBatteryLevel(playerGunLevel);
        }

        protected override void EnterAction()
        {
            if (actionPlaying) return;

            checkTime = true;
            actionPlaying = true;
            board.transform.localScale = new Vector3(0, 0, 0);
            Tween tween = board.transform.DOScale(new Vector3(1, 1, 1), 0.3f).SetEase(Ease.OutBack).OnKill(() =>
            {
                actionPlaying = false;
            }).SetLink(board.gameObject);
            RunAction(tween);
        }

        protected override void OnBtnBack()
        {
            if (actionPlaying) return;
            ExitAction();
        }

        public override void ExitAction()
        {
            if (actionPlaying) return;
            actionPlaying = true;
            Tween tween = board.transform.DOScale(new Vector3(0, 0, 0), 0.3f).SetEase(Ease.InBack).OnKill(() =>
            {
                SetActive(false);
                actionPlaying = false;
                checkTime = false;
            }).SetLink(board.gameObject);
            RunAction(tween);
        }

        public override void Show()
        {
            SetActive(true);
            EnterAction();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();

            UnregisterEvent();
            StopTimer("CheckTime");
        }
    }
}