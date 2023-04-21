using UnityEngine;
using LuaFramework;

public class Base : MonoBehaviour
{

    private AppFacade m_Facade;

    protected AppFacade facade
    {
        get
        {
            if (m_Facade == null)
            {
                m_Facade = AppFacade.Instance;
            }
            return m_Facade;
        }
    }

    protected LuaManager LuaManager
    {
        get
        {
            return facade.GetManager<LuaManager>(); ;
        }
    }

    protected ResourceManager ResManager
    {
        get
        {
            return facade.GetManager<ResourceManager>();
        }
    }

    protected NetworkManager NetManager
    {
        get
        {
            return facade.GetManager<NetworkManager>();
        }
    }

    protected MusicManager SoundManager
    {
        get
        {
            return facade.GetManager<MusicManager>();    
        }
    }



    protected TimerManager TimerManager
    {
        get
        {
            return facade.GetManager<TimerManager>();
        }
    }

    protected ObjectPoolManager ObjPoolManager
    {
        get
        {
            return facade.GetManager<ObjectPoolManager>();
        }
    }
}
