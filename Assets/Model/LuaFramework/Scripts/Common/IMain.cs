using System;

namespace LuaFramework
{
    public interface IMain
    {
        void InitConfiger();


        void UpdateUIProgress(float f);
        void UpdateUIDesc(string desc);
        
    }
}