using LitJson;

namespace LuaFramework
{
    public static class SaveHelper
    {
        /// <summary>
        ///     json
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static T Get<T>(string key) where T : BaseSave
        {
            if (!ES3.KeyExists(key)) return null;
            var str = ES3.Load<string>(key);
            var t = JsonMapper.ToObject<T>(str);
            return t;
        }

        /// <summary>
        ///     返回int类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static int GetInt(string key)
        {
            return ES3.KeyExists(key) ? ES3.Load<int>(key) : 0;
        }

        /// <summary>
        ///     返回float类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static float GetFloat(string key)
        {
            return ES3.KeyExists(key) ? ES3.Load<float>(key) : 0f;
        }

        /// <summary>
        ///     返回string类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static string GetString(string key)
        {
            return ES3.KeyExists(key) ? ES3.Load<string>(key) : null;
        }

        /// <summary>
        ///     返回bool类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static bool GetBool(string key)
        {
            return ES3.KeyExists(key) && ES3.Load<bool>(key);
        }

        /// <summary>
        ///     返回double类型
        /// </summary>
        /// <param name="key">存的名字</param>
        /// <returns></returns>
        public static double GetDouble(string key)
        {
            return ES3.KeyExists(key) ? ES3.Load<double>(key) : 0;
        }

        /// <summary>
        ///     json存
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="key">键</param>
        /// <param name="t">值</param>
        public static void Save<T>(string key, T t) where T : BaseSave
        {
            string json = JsonMapper.ToJson(t);
            ES3.Save<string>(key, json);
        }

        /// <summary>
        ///     存其余类型
        /// </summary>
        /// <typeparam name="T">类型，只适用于基础类型</typeparam>
        /// <param name="key">键</param>
        /// <param name="t">基础类型值</param>
        public static void SaveCommon<T>(string key, T t)
        {
            ES3.Save<T>(key, t);
        }

        /// <summary>
        ///     删除某个值
        /// </summary>
        /// <param name="key">键</param>
        public static void Delete(string key)
        {
            if (ES3.KeyExists(key)) ES3.DeleteKey(key);
        }

        /// <summary>
        ///     清楚所有
        /// </summary>
        public static void DeleteAll()
        {
            ES3.DeleteFile();
        }
    }

    public class BaseSave
    {
    }
}
