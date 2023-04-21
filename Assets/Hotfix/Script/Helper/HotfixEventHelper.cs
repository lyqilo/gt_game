using System;
using System.Collections.Generic;
using LuaFramework;
using RenderHeads.Media.AVProVideo;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Button = UnityEngine.UI.Button;
using Slider = UnityEngine.UI.Slider;
using Toggle = UnityEngine.UI.Toggle;

namespace Hotfix
{
    public static class HotfixEventHelper
    {
        public static void HotfixAdd(this Button.ButtonClickedEvent buttonClickedEvent, Action action)
        {
            buttonClickedEvent?.Add(action);
        }

        public static void HotfixAdd(this Slider.SliderEvent sliderEvent, Action<float> action)
        {
            sliderEvent?.Add(action);
        }

        public static void HotfixAdd(this Scrollbar.ScrollEvent scrollEvent, Action<float> action)
        {
            scrollEvent?.Add(action);
        }

        public static void HotfixAdd(this ScrollRect.ScrollRectEvent scrollRectEvent, Action<Vector2> action)
        {
            scrollRectEvent?.Add(action);
        }

        public static void HotfixAdd(this Dropdown.DropdownEvent dropdownEvent, Action<int> action)
        {
            dropdownEvent?.Add(action);
        }

        public static void HotfixAdd(this TMP_Dropdown.DropdownEvent dropdownEvent, Action<int> action)
        {
            dropdownEvent?.Add(action);
        }

        public static void HotfixAdd(this InputField.OnChangeEvent onChangeEvent, Action<string> action)
        {
            onChangeEvent?.Add(action);
        }

        public static void HotfixAdd(this InputField.SubmitEvent submitEvent, Action<string> action)
        {
            submitEvent?.Add(action);
        }

        public static void HotfixAdd(this TMP_InputField.OnChangeEvent onChangeEvent, Action<string> action)
        {
            onChangeEvent?.Add(action);
        }

        public static void HotfixAdd(this TMP_InputField.SubmitEvent submitEvent, Action<string> action)
        {
            submitEvent?.Add(action);
        }

        public static void HotfixAdd(this TMP_InputField.SelectionEvent selectionEvent, Action<string> action)
        {
            selectionEvent?.Add(action);
        }

        public static void HotfixAdd(this Toggle.ToggleEvent toggleEvent, Action<bool> action)
        {
            toggleEvent?.Add(action);
        }

        public static void HotfixAdd(this MediaPlayerEvent mediaPlayerEvent,
            Action<MediaPlayer, MediaPlayerEvent.EventType, ErrorCode> action)
        {
            mediaPlayerEvent?.Add(action);
        }
    }

    public interface IHotfixMessage
    {
        
    }

    public delegate void HotfixEventCallback(object data);
    public delegate void HotfixMessageEventCallback(params object[] data);
    public delegate void HotfixNetworkEventCallback(BytesPack data);
    public delegate void HotfixGameEventCallback(IGameData data);

    public partial class CustomEvent
    {
    }

    public class HotfixMessageHelper
    {
        private static Dictionary<string, List<HotfixEventCallback>> eventQueue
            = new Dictionary<string, List<HotfixEventCallback>>();
        private static Dictionary<string, List<HotfixMessageEventCallback>> eventMessageQueue
            = new Dictionary<string, List<HotfixMessageEventCallback>>();

        private static object _lockObj = new object();
        private static object _lockMessageObj = new object();

        public static void AddListener(string type, HotfixEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) eventQueue.Add(type, new List<HotfixEventCallback>());
            eventQueue[type].Add(callback);
        }

        public static void RemoveListener(string type, HotfixEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) return;
            eventQueue[type].Remove(callback);
        }
        public static void AddEvent(string type, HotfixMessageEventCallback callback)
        {
            if (!eventMessageQueue.ContainsKey(type)) eventMessageQueue.Add(type, new List<HotfixMessageEventCallback>());
            eventMessageQueue[type].Add(callback);
        }

        public static void RemoveEvent(string type, HotfixMessageEventCallback callback)
        {
            if (!eventMessageQueue.ContainsKey(type)) return;
            eventMessageQueue[type].Remove(callback);
        }

        public static void PostHotfixEvent(string type, object message = null)
        {
            if (eventQueue == null || !eventQueue.ContainsKey(type)) return;
            lock (_lockObj)
            {
                List<HotfixEventCallback> callbacks = eventQueue[type];
                for (int i = 0; i < callbacks.Count; i++)
                {
                    callbacks[i](message);
                }
            }
        }
        public static void PostMessageEvent(string type, params object[] message)
        {
            if (eventMessageQueue == null || !eventMessageQueue.ContainsKey(type)) return;
            lock (_lockMessageObj)
            {
                List<HotfixMessageEventCallback> callbacks = eventMessageQueue[type];
                for (int i = 0; i < callbacks.Count; i++)
                {
                    callbacks[i](message);
                }
            }
        }
    }
    
    public class HotfixNetworkMessageHelper
    {
        private static Dictionary<string, List<HotfixNetworkEventCallback>> eventQueue
            = new Dictionary<string, List<HotfixNetworkEventCallback>>();

        private static object _lockObj = new object();

        public static void AddListener(string type, HotfixNetworkEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) eventQueue.Add(type, new List<HotfixNetworkEventCallback>());
            eventQueue[type].Add(callback);
        }

        public static void RemoveListener(string type, HotfixNetworkEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) return;
            eventQueue[type].Remove(callback);
        }

        public static void PostEvent(string type, BytesPack message)
        {
            if (eventQueue == null || !eventQueue.ContainsKey(type)) return;
            lock (_lockObj)
            {
                List<HotfixNetworkEventCallback> callbacks = eventQueue[type];
                for (int i = 0; i < callbacks.Count; i++)
                {
                    callbacks[i](message);
                }
            }
        }
    }
    public class HotfixGameMessageHelper
    {
        private static Dictionary<string, List<HotfixGameEventCallback>> eventQueue
            = new Dictionary<string, List<HotfixGameEventCallback>>();

        private static object _lockObj = new object();

        public static void AddListener(string type, HotfixGameEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) eventQueue.Add(type, new List<HotfixGameEventCallback>());
            eventQueue[type].Add(callback);
        }

        public static void RemoveListener(string type, HotfixGameEventCallback callback)
        {
            if (!eventQueue.ContainsKey(type)) return;
            eventQueue[type].Remove(callback);
        }

        public static void PostEvent(string type, IGameData message)
        {
            if (eventQueue == null || !eventQueue.ContainsKey(type)) return;
            lock (_lockObj)
            {
                List<HotfixGameEventCallback> callbacks = eventQueue[type];
                for (int i = 0; i < callbacks.Count; i++)
                {
                    callbacks[i](message);
                }
            }
        }
    }
}