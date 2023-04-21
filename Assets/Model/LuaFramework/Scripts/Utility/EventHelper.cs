using System;
using System.Collections;
using System.Collections.Generic;
using LuaFramework;
using RenderHeads.Media.AVProVideo;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 事件管理
/// </summary>
public static class EventHelper
{
    public static void Add(this Button.ButtonClickedEvent buttonClickedEvent, Action action)
    {
        buttonClickedEvent.AddListener(() => { action(); });
    }

    public static void Add(this Slider.SliderEvent sliderEvent, Action<float> action)
    {
        sliderEvent.AddListener(p => { action(p); });
    }

    public static void Add(this Scrollbar.ScrollEvent scrollEvent, Action<float> action)
    {
        scrollEvent.AddListener(p => { action(p); });
    }

    public static void Add(this ScrollRect.ScrollRectEvent scrollRectEvent, Action<Vector2> action)
    {
        scrollRectEvent.AddListener(p => { action(p); });
    }

    public static void Add(this Dropdown.DropdownEvent dropdownEvent, Action<int> action)
    {
        dropdownEvent.AddListener(p => { action(p); });
    }

    public static void Add(this TMP_Dropdown.DropdownEvent dropdownEvent, Action<int> action)
    {
        dropdownEvent.AddListener(p => { action(p); });
    }

    public static void Add(this InputField.OnChangeEvent onChangeEvent, Action<string> action)
    {
        onChangeEvent.AddListener(p => { action(p); });
    }

    public static void Add(this InputField.SubmitEvent submitEvent, Action<string> action)
    {
        submitEvent.AddListener(p => { action(p); });
    }

    public static void Add(this TMP_InputField.OnChangeEvent onChangeEvent, Action<string> action)
    {
        onChangeEvent.AddListener(p => { action(p); });
    }

    public static void Add(this TMP_InputField.SubmitEvent submitEvent, Action<string> action)
    {
        submitEvent.AddListener(p => { action(p); });
    }

    public static void Add(this TMP_InputField.SelectionEvent selectionEvent, Action<string> action)
    {
        selectionEvent.AddListener(p => { action(p); });
    }

    public static void Add(this Toggle.ToggleEvent toggleEvent, Action<bool> action)
    {
        toggleEvent.AddListener(p => { action(p); });
    }

    public static void Add(this MediaPlayerEvent mediaPlayerEvent, Action<MediaPlayer, MediaPlayerEvent.EventType, ErrorCode> action)
    {
        mediaPlayerEvent.AddListener((player,eventType,error) => { action(player,eventType,error); });
    }

    public static event Action<string> OnEnterGame;

    /// <summary>
    /// 进游戏
    /// </summary>
    /// <param name="gameName">游戏名</param>
    public static void DispatchOnEnterGame(string gameName)
    {
        OnEnterGame?.Invoke(gameName);
    }

    public static event Action<BytesPack> OnSocketReceive;

    /// <summary>
    /// 收到socket消息
    /// </summary>
    /// <param name="pack"></param>
    public static void DispatchOnSocketReceive(BytesPack pack)
    {
        OnSocketReceive?.Invoke(pack);
    }
    
    /// <summary>
    /// 离开游戏
    /// </summary>
    public static event Action LeaveGame;

    public static void DispatchLeaveGame()
    {
        LeaveGame?.Invoke();
    }
}