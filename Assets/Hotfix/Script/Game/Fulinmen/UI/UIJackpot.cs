using System;
using LuaFramework;
using TMPro;
using UnityEngine;

namespace Hotfix.Fulinmen
{
    public class UIJackpot : MonoBehaviour
    {
        public static UIJackpot Add(GameObject go)
        {
            return go.CreateOrGetComponent<UIJackpot>();
        }
        long _currentCaijin = 0;
        float _caijinCha = 0;
        long _caijinGold = 0;

        float _timer = 5;
        bool _isCanSend = false;
        private TextMeshProUGUI _mosaicNum;

        private void Awake()
        {
            _mosaicNum = transform.FindChildDepth<TextMeshProUGUI>("Content/Mosaic/MosaicNum");//彩金
            HotfixGameMessageHelper.AddListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_UPDATE_PRIZE_POOL}",
                OnJackpotUpdate);
        }

        private void OnDestroy()
        {
            HotfixGameMessageHelper.RemoveListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_UPDATE_PRIZE_POOL}",
                OnJackpotUpdate);
        }

        private void Update()
        {
            if (_caijinGold <= 0) return;
            _currentCaijin += Mathf.CeilToInt(Time.deltaTime * _caijinCha*0.2f);
            _mosaicNum.SetText(_currentCaijin.ShortNumber().ShowRichText());
        }

        private void OnJackpotUpdate(IGameData gameData)
        {
            if (!(gameData is FulinmenStruct.JackpotInfo jackpotInfo)) return;
            if (_caijinGold > 0)
            {
                if (jackpotInfo.jackpot <= _currentCaijin)
                {
                    _currentCaijin = jackpotInfo.jackpot;
                }
                else
                {
                    _caijinCha = jackpotInfo.jackpot - _currentCaijin;
                }
            }
            else
            {
                _currentCaijin = jackpotInfo.jackpot / 2;
                _caijinCha = _currentCaijin;
            }

            _caijinGold = jackpotInfo.jackpot;
        }
    }
}