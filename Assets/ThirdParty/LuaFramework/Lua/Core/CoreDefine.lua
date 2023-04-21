
json = require "cjson";
FileUtil = require "cjson.util";
Event=require "events"

SystemInfo = UnityEngine.SystemInfo
PlayerPrefs = UnityEngine.PlayerPrefs
DOTween = DG.Tweening.DOTween;
--带有命名域的方法
Util = LuaFramework.Util;
Application = UnityEngine.Application;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;
UpdateState = LuaFramework.UpdateState;

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;
Session=LuaFramework.Session
ByteBuffer = LuaFramework.ByteBuffer
--获得类的实例并命名
resMgr = LuaHelper.GetResourceManager();
objMrg = LuaHelper.GetObjectPoolManager();

networkMgr = LuaHelper.GetNetManager();
MusicManager=LuaHelper.GetSoundManager();
ILRuntimeManager=LuaHelper.GetILRuntimeManager();

SceneManager = UnityEngine.SceneManagement.SceneManager
LoadSceneMode = UnityEngine.SceneManagement.LoadSceneMode
LuaBehaviour=LuaFramework.LuaBehaviour
MD5Helper=LuaFramework.MD5Helper
CsJoinLua=LuaFramework.CsJoinLua
Screen = UnityEngine.Screen
Canvas=UnityEngine.Canvas
CanvasScaler=UnityEngine.CanvasScaler
Input = UnityEngine.Input
KeyCode = UnityEngine.KeyCode
PathHelp=LuaFramework.PathHelp
UnityWebDownPacketQueue=LuaFramework.UnityWebDownPacketQueue
Caching=UnityEngine.Caching
UnityWebPacket=LuaFramework.UnityWebPacket
UnityWebRequestAsync=LuaFramework.UnityWebRequestAsync
MinMaxCurve=UnityEngine.ParticleSystem.MinMaxCurve
ConfigHelp=LuaFramework.ConfigHelp
CreateFont=LuaFramework.CreateFont
NetworkHelper=LuaFramework.NetworkHelper
--UI层级
UILayoutEnum = {
    Layer_background = 0,
    Layer_main = 1,
    Layer_panel = 2,
    Layer_popPanel = 3,
    Layer_tip = 4,
    Layer_announcement = 5,
    Layer_top = 10;
}






