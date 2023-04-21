flm_Config = {};
local self = flm_Config;
self.nine = 0;		--9
self.ten = 1;		--10
self.j= 2;		--J
self.q= 3;			--Q
self.k= 4;		--K
self.cai= 5;	--财(青蛙)
self.shou= 6;		--寿（女孩）
self.fu= 7;		--福（男孩）
self.shiz= 8;		--狮子（龙）
self.wild= 9;		--听用（鱼）
self.bianpao= 10;		--鞭炮	
self.gold= 11;		--金币

self.nine_img = "nine_img";		--9
self.ten_img = "ten_img";		--10
self.j_img= "j_img";		--J
self.q_img= "q_img";			--Q
self.k_img= "k_img";		--K
self.cai_img= "cai_img";		--财
self.shou_img= "shou_img";		--寿
self.fu_img= "fu_img";		--福
self.shiz_img= "shiz_img";		--狮子
self.wild_img= "wild_img";		--听用
self.bianpao_img= "bianpao_img";		--鞭炮	
self.gold_img= "gold_img";		--金币

self.resimg_config =
{
   [self.nine] = {normalimg=self.nine_img,animaimg="nine_anima_",count=20,loop = 2,animatype = 3},-- animatype 1 闪 2 边框动画 3 边框加文字动画
   [self.ten] = {normalimg=self.ten_img,animaimg="ten_anima_",count=20,loop = 2,animatype = 3},
   [self.j] = {normalimg=self.j_img,animaimg="j_anima_",count=20,loop = 2,animatype = 3},
   [self.q] = {normalimg=self.q_img,animaimg="q_anima_",count=20,loop = 2,animatype = 3},
   [self.k] = {normalimg=self.k_img,animaimg="k_anima_",count=20,loop = 2,animatype = 3},
   [self.cai] = {normalimg=self.cai_img,animaimg="cai_anima_",count=20,loop = 2,animatype = 3},
   [self.shou] = {normalimg=self.shou_img,animaimg="shou_anima_",count=20,loop = 2,animatype = 3},
   [self.fu] = {normalimg=self.fu_img,animaimg="fu_anima_",count=20,loop = 2,animatype = 3},
   [self.shiz] = {normalimg=self.shiz_img,animaimg="shiz_anima_",count=20,loop = 2,animatype = 3},
   [self.wild] = {normalimg=self.wild_img,animaimg="wild_anima_",count=20,loop = 2,animatype = 3},
   [self.bianpao] = {normalimg=self.bianpao_img,animaimg="bianpao_anima_",count=20,loop = 2,animatype = 3},
   [self.gold] = {normalimg=self.gold_img,animaimg="gold_anima_",count=20,loop = 2,animatype = 3},
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
    [1] = {rate=8,src=self.nine},
    [2] = {rate=8,src=self.ten},
    [3] = {rate=8,src=self.shou},
    [4] = {rate=8,src=self.gold},
    [5] = {rate=8,src=self.shou},
    [6] = {rate=8,src=self.bianpao},
    [7] = {rate=8,src=self.shiz},
    [8] = {rate=8,src=self.cai},
    [9] = {rate=8,src=self.k},
    [10] = {rate=8,src=self.q},
    [11] = {rate=8,src=self.j},
    [12] = {rate=6,src=self.ten},
    [13] = {rate=6,src=self.wild}
};

self.defalut_show_img = 
{
   [1] = {self.wild,self.wild,self.wild},
   [2] = {self.wild,self.wild,self.wild},
   [3] = {self.wild,self.wild,self.wild},
   [4] = {self.wild,self.wild,self.wild},
   [5] = {self.wild,self.wild,self.wild}
}
self.line_config = 
{
    [1] =  {5,6,7,8,9},    --1
    [2] =  {0,1,2,3,4},    --2
    [3] =  {10,11,12,13,14},    --3
    [4] =  {0,6,12,8,4},    --4
    [5] =  {10,6,2,8,14},    --5
    [6] =  {0,1,7,13,14},    --6
    [7] =  {10,11,7,3,4},    --7
    [8] =  {5,11,12,13,9},    --8
    [9] =  {5,1,2,3,9},    --9
    [10] = {0,6,7,8,4},    --10
    [11] = {10,6,7,8,14},    --11
    [12] = {0,6,2,8,4},    --12
    [13] = {10,6,12,8,14},    --13
    [14] = {5,1,7,3,9},    --14
    [15] = {5,11,7,13,9},    --15
    [16] = {5,6,2,8,9},    --16
    [17] = {5,6,12,8,9},    --17
    [18] = {0,11,2,13,4},    --18
    [19] = {10,1,12,3,14},    --19
    [20] = {5,1,12,3,9},    --20
    [21] = {5,11,2,13,9},    --21
    [22] = {0,1,12,3,4},    --22
    [23] = {10,11,2,13,14},    --23
    [24] = {0,11,12,13,4},    --24
    [25] = {10,1,2,3,14}     --25
}

self.starlin = "starlin";--来做FruitsSlot_Line
self.starsamll = "starbell";--来自铃铛
