using UnityEngine;
using UnityEngine.UI;

/// <summary>  
/// 屏幕适配  
/// </summary>  
[RequireComponent(typeof(CanvasScaler))]
public class UIAdapt : MonoBehaviour
{
    public float screenHeight;
    public float screenWidth;

    void Awake()
    {
        UpdateCamera();
    }

    void UpdateCamera()
    {
        screenHeight = Screen.height;
        screenWidth = Screen.width;

        var canvas = GetComponent<CanvasScaler>();

        Rect r = new Rect();
        if (screenHeight / screenWidth > 0.5625f)//更方的屏幕 1280*720
        {
            canvas.matchWidthOrHeight = 0;
        }
        else if (screenHeight / screenWidth < 0.5625f)//更长的屏幕720*1280  
        {
            canvas.matchWidthOrHeight = 1;
        }
        else 
        {
            canvas.matchWidthOrHeight = 0.5f;
        }
    }
}