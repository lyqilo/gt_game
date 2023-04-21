using System;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class HallMarquee : MonoBehaviour
    {
        private Image _head;
        private Text _name;
        private Text _game;
        private Text _score;

        List<string> nameList = new List<string>()
        {
            "Wieland",
            "Jorine",
            "Daan",
            "Mary",
            "Marygrace",
            "Pia",
            "Charmaine",
            "Sirena",
            "Retha",
        };

        List<string> gameList = new List<string>()
        {
            "Dragon Legend",
            "Fruit slot 777",
            "Fortune Panda",
            "Fartune Gods",
            "Fruit Mary",
            "Gold Digger",
            "High Jump",
            "3D Fishing",
            "Fulinmen",
        };

        private Sequence _tween;
        private Slider _slider;
        private bool isShow;

        private void Awake()
        {
            _slider = transform.GetComponent<Slider>();
            _name = transform.FindChildDepth<Text>("name");
            _game = transform.FindChildDepth<Text>("game");
            _score = transform.FindChildDepth<Text>("score");
            _head = transform.FindChildDepth<Image>("HeadMask/Mask/HeadIcon");
        }

        private void Update()
        {
            if (isShow) return;
            Show();
        }

        private void Show()
        {
            isShow = true;
            int score = UnityEngine.Random.Range(10000, 10000000);
            string name = nameList[UnityEngine.Random.Range(0, nameList.Count)];
            string game = gameList[UnityEngine.Random.Range(0, gameList.Count)];
            _name.SetText(name);
            _game.SetText(game);
            _score.SetText(score.ShortNumber());

            _head.sprite = ILGameManager.Instance.GetHeadIcon((uint) UnityEngine.Random.Range(0, 8));
            _tween = DOTween.Sequence();
            _tween.Append(_slider.DOValue(0, 0.5f).SetLink(gameObject));
            _tween.AppendInterval(6);
            _tween.Append(_slider.DOValue(1, 0.5f).SetLink(gameObject));
            _tween.AppendInterval(4);
            _tween.OnComplete(() =>
            {
                isShow = false;
            });
        }

        private void OnDisable()
        {
            _tween?.Kill();
            _slider.value = 1;
            isShow = false;
        }
    }
}