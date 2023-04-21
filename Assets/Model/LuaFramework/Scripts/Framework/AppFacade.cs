using LuaFramework;

public class AppFacade : Facade
{
    private static AppFacade _instance;

    public AppFacade() : base()
    {
    }

    public static AppFacade Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new AppFacade();
            }
            return _instance;
        }
        set { _instance = value; }
    }

    override protected void InitFramework()
    {
        base.InitFramework();
    }
}

