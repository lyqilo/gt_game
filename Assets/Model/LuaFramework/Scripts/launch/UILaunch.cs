using System;
using DG.Tweening;
using Framework.Assets;
using Spine.Unity;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.Video;

namespace LuaFramework
{
    public class UILaunch : MonoBehaviour
    {
        private Slider _progress;
        private VideoPlayer _video;
        private Button _skipBtn;
        private Text _progressDesc;
        private Text _desc;

        public Action OnVideoComplete { get; set; }
        public Action<float> OnProgressChange { get; set; }
        private bool isWellComplete = false;
        private SkeletonGraphic anim;

        private void Awake()
        {
            _progress = FindChild<Slider>(transform, "Slider");
            _video = FindChild<VideoPlayer>(transform, "Video Player");
            _skipBtn = FindChild<Button>(transform, "SkipBtn");
            _progressDesc = FindChild<Text>(transform, "Content");
            _desc = FindChild<Text>(transform, "Desc");
            anim = FindChild<SkeletonGraphic>(transform, $"tilet_1/Anim");
            _progress.value = 0;
            _progressDesc.text = $"{0f:P2}";
            
            if (!ResigterVideo())
            {
                Model.Instance.UpdateRes(this);
            }
            else
            {
                OnVideoComplete =()=>
                {
                    Model.Instance.UpdateRes(this);
                };
                PlayVideo();
            }

            anim.transform.localScale = Vector3.zero;
            anim.transform.DOScale(1, 0.5f).SetEase(Ease.OutBack);
        }

        private void PlayVideo()
        {
            _video.Play();
        }

        private bool ResigterVideo()
        {
            if (_video != null)
            {
                _video.loopPointReached += VideoOnloopPointReached;
            }

            if (_skipBtn != null)
            {
                _skipBtn.onClick.RemoveAllListeners();
                _skipBtn.onClick.AddListener(OnClickSkip);
            }

            return _video != null && _video.clip != null && _skipBtn != null;
        }

        private void OnClickSkip()
        {
            _video.time = _video.length - 1;
        }
        private void VideoOnloopPointReached(VideoPlayer source)
        {
            OnVideoComplete?.Invoke();
        }
        

        private void Update()
        {
            if (_video == null || _video.clip == null) return;
            if (isWellComplete) return;
            if (_video.time < _video.length - 1) return;
            isWellComplete = true;
            DOTween.To(() => _video.targetCameraAlpha, x => _video.targetCameraAlpha = x, 0, 1);
        }

        public void SetProgress(float progress)
        {
            _progress.value = progress;
            _progressDesc.text = $"{progress:P2}";
        }

        public void SetDesc(string desc)
        {
            _desc.text = desc;
        }
        
        private Transform FindChild(Transform parent, string childName)
        {
            Transform child = parent.Find(childName);
            if (child != null) return child;
            for (int i = 0; i < parent.childCount; i++)
            {
                child = FindChild(parent.GetChild(i), childName);
                if (child != null) return child;
            }

            return child;
        }

        private T FindChild<T>(Transform parent, string childName) where T : Component
        {
            Transform child = FindChild(parent, childName);
            if (child == null) return null;
            return child.GetComponent<T>();
        }
    }
}
