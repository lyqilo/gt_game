using System;
using System.Collections;
using System.Collections.Generic;
using RenderHeads.Media.AVProVideo;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.Video;

public class Load : MonoBehaviour
{
    private Button _btn;

    private MediaPlayer _player;

    private Text _text;
    private int currentwidth;
    private int currentheight;

    public const string ScreenOrientation = "ScreenOrientation";
    // Start is called before the first frame update
    void Start()
    {
#if UNITY_STANDALONE_WIN
        float rate = 16f / 9;
        string orientation = UnityEngine.ScreenOrientation.Portrait.ToString();
        ES3.Save<string>(ScreenOrientation, orientation);
        if (orientation == "Portrait")
        {
            currentwidth = Screen.width;
            currentheight = (int) (Screen.width * rate);
        }
        else
        {
            currentwidth = (int) (Screen.height * rate);
            currentheight = Screen.height;
        }

        Screen.SetResolution(currentwidth, currentheight, false);
#endif

        StartScene();
    }

    public void StartScene()
    {
        SceneManager.LoadSceneAsync("Launch");
    }

}
