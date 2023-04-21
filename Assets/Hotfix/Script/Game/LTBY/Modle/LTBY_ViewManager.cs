using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 界面管理
    /// </summary>
    public class LTBY_ViewManager : SingletonNew<LTBY_ViewManager>
    {
        private List<LTBY_ViewBase> iViewList = null;
        private Dictionary<string, LTBY_ViewBase> iViewMap = null;
        private List<LTBY_Messagebox> iMsgboxList = null;
        private Dictionary<string, LTBY_Messagebox> iMsgboxMap = null;

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            iViewList = new List<LTBY_ViewBase>();
            iViewMap = new Dictionary<string, LTBY_ViewBase>();
            iMsgboxList = new List<LTBY_Messagebox>();
            iMsgboxMap = new Dictionary<string, LTBY_Messagebox>();
            Open<LTBY_GameView>();
        }
        /// <summary>
        /// 创建界面
        /// </summary>
        /// <param name="args">其他参数</param>
        /// <typeparam name="T">类型</typeparam>
        /// <returns></returns>
        private T CreateView<T>(params object[] args) where T : LTBY_ViewBase ,new()
        {
            T obj = new T();
            obj.Create(args);
            return obj;
        }
        /// <summary>
        /// 创建弹窗
        /// </summary>
        /// <param name="args">参数</param>
        /// <typeparam name="T">类型</typeparam>
        /// <returns></returns>
        private T CreateMessageBox<T>(params object[] args) where T : LTBY_Messagebox,new()
        {
            T obj = new T();
            obj.Create(args);
            return obj;
        }

        private T PushView<T>(bool bReplace,params object[] args) where T:LTBY_ViewBase,new()
        {
            string viewName = typeof(T).Name;
            if (bReplace)
            {
                //Replace的话，或把当前所有页面先关闭
                Release();

            }
            T view = CreateView<T>(args);

            if (view == null) return null;
            //监听页面被销毁，清除他在iViewList中的保存
            view.OnDestroyFinishHandle = baseView =>
            {
                iViewList.Remove(view);
                iViewMap.Remove(viewName);
            };
            iViewList.Add(view);
            if (iViewMap.ContainsKey(viewName)) iViewMap.Remove(viewName);
            iViewMap.Add(viewName, view);

            return view;
        }

        public void CloseAllMessageBox()
        {
            for (int i = 0; i < iMsgboxList.Count; i++)
            {
                iMsgboxList[i].OnDestroyFinishHandle = p=> { };
                iMsgboxList[i].Destroy();
            }
            iMsgboxList.Clear();
            iMsgboxMap.Clear();
        }
        public LTBY_ViewBase Open<T>( params object[] args) where T : LTBY_ViewBase,new()
        {
            return PushView<T>(false, args);
        }

        public LTBY_ViewBase Replace<T>( params object[] args) where T:LTBY_ViewBase,new()
        {
            return PushView<T>(true,args);
        }

        public T OpenMessageBox<T>(bool isSub=true,CAction callback=null,params object[] args) where T: LTBY_Messagebox,new()
        {
            string boxName = typeof(T).Name;
            string _boxName = isSub ? "LTBY_MessageBox" : boxName;
            if (string.IsNullOrEmpty(boxName)) boxName = "LTBY_MessageBox";

            T box = CreateMessageBox<T>(callback, args);

            box.transform.localPosition = Vector3.zero;
            box.OnDestroyFinishHandle = baseView=>
            {
                LTBY_Messagebox msgBox = baseView as LTBY_Messagebox;
                for (int i = 0; i < iMsgboxList.Count; i++)
                {
                    if (!iMsgboxList[i].Equals(msgBox)) continue;
                    iMsgboxList.RemoveAt(i);
                    iMsgboxMap.Remove(boxName);
                    break;
                }
            };
            iMsgboxList.Add(box);
            if (iMsgboxMap.ContainsKey(boxName)) iMsgboxMap.Remove(boxName);
            iMsgboxMap.Add(boxName, box);
            return box;
        }

        public void Close<T>(T node) where T:LTBY_ViewBase
        {
            if (CloseView(node)) return;
            if (CloseMessageBox(node as LTBY_Messagebox)) return;
        }

        private bool CloseView<T>(T view) where T:LTBY_ViewBase
        {
            var keys = iViewMap.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                if (!iViewMap[keys[i]].Equals(view)) continue;
                iViewMap.Remove(keys[i]);
                break;
            }

            for (int i = 0; i < iViewList.Count; i++)
            {
                if (!iViewList[i].Equals(view)) continue;
                view.OnDestroyFinishHandle = p => { };
                view.Destroy();
                iViewList.RemoveAt(i);
                return true;
            }
            return false;
        }

        public bool CloseMessageBox(string boxName)
        {
            iMsgboxMap.TryGetValue(boxName, out LTBY_Messagebox box);
            return box != null && CloseMessageBox(box);
        }

        private bool CloseMessageBox<T>(T box) where T : LTBY_Messagebox
        {
            if (box == null) return false;
            var keys = iMsgboxMap.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                if (!iMsgboxMap[keys[i]].Equals(box)) continue;
                iMsgboxMap.Remove(keys[i]);
                break;
            }
            for (int i = 0; i < iMsgboxList.Count; i++)
            {
                if (iMsgboxList[i] != box) continue;
                box.OnDestroyFinishHandle = p => { };
                box?.Destroy();
                // DebugHelper.LogError($"关闭界面:{typeof(T).Name}");
                iMsgboxList.RemoveAt(i);
                return true;
            }
            return false;
        }
        public override void Release()
        {
            base.Release();
            for (int i = 0; i < iViewList.Count; i++)
            {
                iViewList[i].OnDestroyFinishHandle = p => { };
                iViewList[i].Destroy();
            }
            iViewList.Clear();
            iViewMap.Clear();

            for (int i = 0; i < iMsgboxList.Count; i++)
            {
                iMsgboxList[i].OnDestroyFinishHandle = p => { };
                iMsgboxList[i].Destroy();
            }
            iMsgboxList.Clear();
            iMsgboxList.Clear();
        }

        public LTBY_ViewBase Current
        {
            get { return iViewList.Count > 0 ? iViewList[iViewList.Count - 1] : null; }
        }

        public List<LTBY_ViewBase> GetViewList
        {
            get { return iViewList; }
        }
        public T GetView<T>() where T:LTBY_ViewBase
        {
            string viewName = typeof(T).Name;
            if (iViewMap.ContainsKey(viewName)) return iViewMap[viewName] as T;
            return null;
        }

        public LTBY_Messagebox CurrentBox
        {
            get { return iMsgboxList.Count > 0 ? iMsgboxList[iMsgboxList.Count - 1] : null; }
        }
        public T GetMessageBox<T>() where T : LTBY_Messagebox
        {
            string viewName = typeof(T).Name;
            if (iMsgboxMap.ContainsKey(viewName)) return iMsgboxMap[viewName] as T;
            return null;
        }

        public void ShowTip(string openRageShoot)
        {

        }
    }
}
