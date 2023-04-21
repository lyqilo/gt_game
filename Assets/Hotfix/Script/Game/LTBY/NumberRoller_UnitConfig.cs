namespace Hotfix.LTBY
{
    public class NumberRoller_UnitConfig
    {
        public string unitName;

        public float unitBase;

        public int howmanyUse;

        public NumberRoller_UnitConfig(string unitName, float unitBase, int howmanyUse)
        {
            this.unitName = unitName;
            this.unitBase = unitBase;
            this.howmanyUse = howmanyUse;
        }
    }
}
