using System;
using DG.Tweening;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.Video;

public class LoadStart : MonoBehaviour
{
    public VideoPlayer player;

    public Button skipBtn;

    private bool isWellComplete = false;
    // Start is called before the first frame update
    private void Awake()
    {
        if (player != null)
        {
            player.loopPointReached += PlayerOnloopPointReached;
        }

        if (skipBtn != null)
        {
            skipBtn.onClick.RemoveAllListeners();
            skipBtn.onClick.AddListener(OnClickSkip);
        }

        if (player == null || player.clip == null) SceneManager.LoadSceneAsync("Start");
    }

    private void Update()
    {
        if (player == null || player.clip == null) return;
        if (isWellComplete) return;
        if (player.time < player.length - 1) return;
        isWellComplete = true;
        DOTween.To(() => player.targetCameraAlpha, x => player.targetCameraAlpha = x, 0, 1);
    }

    private void OnClickSkip()
    {
        player.time = player.length - 1;
    }

    private void PlayerOnloopPointReached(VideoPlayer source)
    {
        SceneManager.LoadSceneAsync("Start");
    }
}
