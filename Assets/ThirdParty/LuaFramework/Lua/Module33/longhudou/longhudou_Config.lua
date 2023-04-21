longhudou_Config = {};
local self = longhudou_Config;

self.six = 0;		--6
self.seven= 1;		--7
self.eight= 2;		--8
self.nine= 3;		--9
self.cattle= 4;		--牛
self.chicken= 5;	--鸡
self.monkey= 6;		--猴
self.horse= 7;		--马
self.wild= 8;		--龙（wild）
self.tiger= 9;		--虎
self.maxwild1=10;   --大龙1（客户端自己的 当免费游戏的时候 要把一列的龙变成大龙）
self.maxwild2=11;   --大龙2
self.maxwild3=12;   --大龙3

self.six_img= "six_img"; 		--6
self.seven_img= "seven_img";		--7
self.eight_img= "eight_img";		--8
self.nine_img= "nine_img";			--9
self.cattle_img= "cattle_img";		--牛
self.chicken_img= "chicken_img"; 		--鸡
self.monkey_img= "monkey_img";		--猴
self.horse_img= "horse_img"; 		--马
self.wild_img= "wild_img";		--龙（wild）
self.tiger_img= "tiger_img";		--虎
self.maxwild1_img= "maxwild1_img";		
self.maxwild2_img= "maxwild2_img";		
self.maxwild3_img= "maxwild3_img";		

function longhudou_Config.isWild(val)
    if val== self.wild or  val== self.maxwild1 or  val== self.maxwild2 or  val== self.maxwild3 then
       return true;
    end
    return false;
end

self.resimg_config =
{
   [self.six] = {normalimg=self.six_img,animaimg="six_img",count=24,loop = 2,animatype = 1},-- animatype 1 闪 2 边框动画 3 边框加文字动画
   [self.seven] = {normalimg=self.seven_img,animaimg="seven_img",count=24,loop = 2,animatype = 1},
   [self.eight] = {normalimg=self.eight_img,animaimg="eight_img",count=24,loop = 2,animatype = 1},
   [self.nine] = {normalimg=self.nine_img,animaimg="nine_img",count=24,loop = 2,animatype = 1},
   [self.cattle] = {normalimg=self.cattle_img,animaimg="cattle_anima_",count=24,loop = 2,animatype = 3},
   [self.chicken] = {normalimg=self.chicken_img,animaimg="chicken_anima_",count=24,loop = 2,animatype = 3},
   [self.monkey] = {normalimg=self.monkey_img,animaimg="monkey_anima_",count=24,loop = 2,animatype = 3},
   [self.horse] = {normalimg=self.horse_img,animaimg="horse_anima_",count=24,loop = 2,animatype = 3},
   [self.wild] = {normalimg=self.wild_img,animaimg="wild_anima_",count=24,loop = 2,animatype = 3},
   [self.tiger] = {normalimg=self.tiger_img,animaimg="tiger_anima_",count=24,loop = 2,animatype = 3},
   [self.maxwild1] = {normalimg=self.maxwild1_img,animaimg="anima_toum",count=41,loop = 1,animatype = 2},
   [self.maxwild2] = {normalimg=self.maxwild2_img,animaimg="long_anima_",count=41,loop = 1,animatype = 3},
   [self.maxwild3] = {normalimg=self.maxwild3_img,animaimg="anima_toum",count=41,loop = 1,animatype = 2},
}

--运动的时间
self.runtimer_config = 
{
    [1] = 0;
    [2] = 0.1;
    [3] = 0.2;
    [4] = 0.3;
    [5] = 0.4;
}
--运动开始前的等待时间
self.runwaittimer_config = 
{
    [1] = 0.0;
    [2] = 0.15;
    [3] = 0.3;
    [4] = 0.45;
    [5] = 0.6;
}
--产生运动图片
self.runnum_config = 
{
    [1] = 0.5;
    [2] = 0.6;
    [3] = 0.7;
    [4] = 0.8;
    [5] = 0.9;
}

self.runstoptimer_config = 
{
    [1] = 0.1;
    [2] = 0.7;
    [3] = 1.3;
    [4] = 1.9;
    [5] = 2.5;
}

--1,5列的概率（客户产生运动的 不是服务器开奖的概率）
self.rand_1 = 
{
    [1] = {rate=8,src=self.six},
    [2] = {rate=8,src=self.seven},
    [3] = {rate=8,src=self.eight},
    [4] = {rate=8,src=self.nine},
    [5] = {rate=8,src=self.cattle},
    [6] = {rate=8,src=self.chicken},
    [7] = {rate=8,src=self.monkey},
    [8] = {rate=8,src=self.horse},
    [9] = {rate=18,src=self.wild},
    [10] = {rate=18,src=self.tiger},
};
--免费的时候 只出红色
self.rand_2 = 
{
    [1] = {rate=18,src=self.tiger},
    [2] = {rate=18,src=self.wild},
    [3] = {rate=18,src=self.horse},
    [4] = {rate=18,src=self.monkey},
    [5] = {rate=18,src=self.chicken},
    [6] = {rate=10,src=self.cattle}
};

self.defalut_show_img = 
{
   [1] = {self.monkey,self.monkey,self.monkey},
   [2] = {self.horse,self.horse,self.horse},
   [3] = {self.wild,self.wild,self.wild},
   [4] = {self.tiger,self.tiger,self.tiger},
   [5] = {self.cattle,self.cattle,self.cattle}
}
