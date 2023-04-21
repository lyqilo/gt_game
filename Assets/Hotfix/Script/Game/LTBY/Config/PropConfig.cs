namespace Hotfix.LTBY
{
    public class PropConfig
    {
       public static PropData ScratchCard = new PropData() { id = 1, name = "Scratch Card" };
        public static PropData Coin = new PropData() { id = 100, name = "gold"};
        public static PropData Ticket = new PropData() { id = 200, name = "Gift Ticket" };
        public static PropData Drill1 = new PropData() { id = 300, name = "Rocket (Drop)", mul = "" };
        public static PropData Electric1 = new PropData() { id = 400, name = "Electro cannon (drop)", mul = "" };
        public static PropData Bullet = new PropData() { id = 500, name = "Universal Bullet"};
        public static PropData Missile1 = new PropData() { id = 600, name = "Bronze Bullet" };
        public static PropData Missile2 = new PropData() { id = 601, name = "Silver Bullet" };
        public static PropData Missile3 = new PropData() { id = 602, name = "Gold Warhead" };
        public static PropData Missile4 = new PropData() { id = 603, name = "platinum warhead" };
        public static PropData Summon = new PropData() { id = 700, name = "Summon" };
        public static PropData FreeBattery = new PropData() { id = 800, name = "Free Cannon" };
        public static PropData FreeAddTime = new PropData() { id = 801, name = "Free cannon plus time" };
        public static PropData FreeAddMul = new PropData() { id = 802, name = "Free cannon plus number" };
        public static PropData DragonBall = new PropData() { id = 900, name = "DragonBall"};


        public static bool CheckIsScratchCard(int id)
        {
            return id == ScratchCard.id;
        }

        public static bool CheckIsTicket(int id)
        {
            return id == Ticket.id;
        }

        public static bool CheckIsCoin(int id)
        {
            return id == Coin.id;
        }

        public static bool CheckIsDrill(int id)
        {
            return id == Drill1.id;
        }

        public static bool CheckIsElectric(int id)
        {
            return id == Electric1.id;
        }

        public static bool CheckIsMissile(int id)
        {
            return id >= Missile1.id && id <= Missile4.id;
        }

        public static bool CheckIsSummon(int id)
        {
            return id == Summon.id;
        }

        public static bool CheckIsFreeBattery(int id)
        {
            return id == FreeBattery.id;
        }

        public static bool CheckIsFreeAddTime(int id)
        {
            return id == FreeAddTime.id;
        }

        public static bool CheckIsFreeAddMul(int id)
        {
            return id == FreeAddMul.id;
        }

        public static bool CheckIsDragonBall(int id)
        {
            return id == DragonBall.id;
        }
    }

    public class PropData
    {
        public int id;
        public string name;
        public string mul;
    }
}
