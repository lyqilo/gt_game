using LitJson;

namespace Hotfix
{
    public static class SaveHelper
    {
        /// <summary>
        ///     json
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static T Get<T>(string key, string path = null) where T : BaseSave
        {
            if (!ES3.KeyExists(key, path)) return null;
            var str = ES3.Load<string>(key, path);
            var t = JsonMapper.ToObject<T>(str);
            return t;
        }

        /// <summary>
        ///     返回int类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static int GetInt(string key, string path = null)
        {
            return ES3.KeyExists(key, path) ? ES3.Load<int>(key, path) : 0;
        }

        /// <summary>
        ///     返回int类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static T GetStruct<T>(string key, string path = null) where T : struct
        {
            return ES3.KeyExists(key, path) ? ES3.Load<T>(key, path) : default;
        }
        /// <summary>
        ///     返回float类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static float GetFloat(string key, string path = null)
        {
            return ES3.KeyExists(key, path) ? ES3.Load<float>(key, path) : 0f;
        }

        /// <summary>
        ///     返回string类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string GetString(string key, string path = null)
        {
            return ES3.KeyExists(key, path) ? ES3.Load<string>(key, path) : null;
        }

        /// <summary>
        ///     返回bool类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static bool GetBool(string key, string path = null)
        {
            return ES3.KeyExists(key, path) && ES3.Load<bool>(key, path);
        }

        /// <summary>
        ///     返回double类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static double GetDouble(string key, string path = null)
        {
            return ES3.KeyExists(key, path) ? ES3.Load<double>(key, path) : 0;
        }

        /// <summary>
        ///     json存
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="key">键</param>
        /// <param name="t">值</param>
        /// <param name="path"></param>
        public static void Save<T>(string key, T t, string path = null) where T : BaseSave
        {
            string json = JsonMapper.ToJson(t);
            ES3.Save<string>(key, json, path);
        }

        /// <summary>
        ///     存其余类型
        /// </summary>
        /// <typeparam name="T">类型，只适用于基础类型</typeparam>
        /// <param name="key">键</param>
        /// <param name="t">基础类型值</param>
        /// <param name="path"></param>
        public static void SaveCommon<T>(string key, T t, string path = null)
        {
            ES3.Save<T>(key, t, path);
        }

        /// <summary>
        ///     删除某个值
        /// </summary>
        /// <param name="key">键</param>
        /// <param name="path"></param>
        public static void Delete(string key, string path = null)
        {
            if (ES3.KeyExists(key, path)) ES3.DeleteKey(key, path);
        }

        /// <summary>
        ///     清楚所有
        /// </summary>
        public static void DeleteAll(string path = null)
        {
            ES3.DeleteFile(path);
        }
    }

    public class BaseSave
    {
    }
}