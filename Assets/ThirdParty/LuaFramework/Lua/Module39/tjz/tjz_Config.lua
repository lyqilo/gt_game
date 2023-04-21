tjz_Config = {};
local self = tjz_Config;

self.diamond = 0;	--方
self.club = 1;		--梅
self.spade = 2;		--红
self.heart = 3;		--黑
self.kmine = 4;		--矿锄
self.aqm = 5;		--安全帽
self.kcar = 6;		--矿车
self.kwomen = 7;	---女旷工
self.kman = 8;		--男矿工
self.jackpot = 9;	--彩金图标
self.wild = 10;     --百搭
self.scatter = 11;	--金条	免费
self.kminewild = 12;		--矿锄wild客户端定义自己用
self.aqmwild = 13;			--安全帽wild客户端定义自己用
self.kcarwild = 14;			--矿车wild客户端定义自己用		

self.diamond_img = "diamond_img";	--方
self.club_img = "club_img";			--梅
self.spade_img = "spade_img";		--红
self.heart_img = "heart_img";		--黑
self.kmine_img = "kmine_img";		--矿锄
self.aqm_img = "aqm_img";			--安全帽
self.kcar_img = "kcar_img";			--矿车
self.kwomen_img = "kwomen_img";		---女旷工
self.kman_img = "kman_img";			--男矿工
self.jackpot_img = "jackpot_img";		--彩金图标
self.wild_img = "wild_img";
self.scatter_img = "scatter_img";
self.kminewild_img = "kminewild_img";		--矿锄wild客户端定义自己用
self.aqmwild_img = "aqmwild_img";			--安全帽wild客户端定义自己用
self.kcarwild_img = "kcarwild_img";			--矿车wild客户端定义自己用	

function tjz_Config.haveWild(args)
   if args == self.wild or args == self.kminewild or args == self.aqmwild or args == self.kcarwild then
      return true;
   end
   return false;
end

self.resimg_config =
{
   [self.diamond] = {normalimg=self.diamond_img,animaimg="diamond_anima_",count=12,loop = 2,animatype = 2,icon =self.diamond },-- animatype 1 闪 2 边框动画 3 边框加文字动画 4 文字动画
   [self.club] = {normalimg=self.club_img,animaimg="club_anima_",count=12,loop = 2,animatype = 2,icon =self.club},
   [self.spade] = {normalimg=self.spade_img,animaimg="spade_anima_",count=12,loop = 2,animatype = 2,icon =self.spade},
   [self.heart] = {normalimg=self.heart_img,animaimg="heart_anima_",count=12,loop = 2,animatype = 2,icon =self.heart},
   [self.kmine] = {normalimg=self.kmine_img,animaimg="kmine_anima_",count=24,loop = 1,animatype = 2,icon =self.kmine},
   [self.aqm] = {normalimg=self.aqm_img,animaimg="aqm_anima_",count=24,loop = 1,animatype = 2,icon =self.aqm},
   [self.kcar] = {normalimg=self.kcar_img,animaimg="kcar_anima_",count=24,loop = 1,animatype = 2,icon =self.kcar},
   [self.kwomen] = {normalimg=self.kwomen_img,animaimg="kwomen_anima_",count=24,loop = 1,animatype = 2,icon =self.kwomen},
   [self.kman] = {normalimg=self.kman_img,animaimg="kman_anima_",count=24,loop = 1,animatype = 2,icon =self.kman},
   [self.jackpot] = {normalimg=self.jackpot_img,animaimg="jackpot_anima_",count=24,loop = 1,animatype = 2,icon =self.jackpot},
   [self.wild] = {normalimg=self.wild_img,animaimg="wild_anima_",count=24,loop = 1,animatype = 2,icon =self.wild},
   [self.scatter] = {normalimg=self.scatter_img,animaimg="scatter_anima_",count=24,loop = 1,animatype = 2,icon =self.scatter},
   [self.kminewild] = {normalimg=self.kminewild_img,animaimg="kminewild_anima_",count=24,loop = 1,animatype = 2,icon =self.kminewild},
   [self.aqmwild] = {normalimg=self.aqmwild_img,animaimg="aqmwild_anima_",count=24,loop = 1,animatype = 2,icon =self.aqmwild},
   [self.kcarwild] = {normalimg=self.kcarwild_img,animaimg="kcarwild_anima_",count=24,loop = 1,animatype = 2,icon =self.kcarwild},
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
    [1] = {rate=10,src=self.diamond},
    [2] = {rate=10,src=self.club},
    [3] = {rate=10,src=self.spade},
    [4] = {rate=10,src=self.heart},
    [5] = {rate=11,src=self.kmine},
    [6] = {rate=11,src=self.kwomen},
    [7] = {rate=11,src=self.kman},
    [8] = {rate=11,src=self.jackpot},
    [9] = {rate=11,src=self.wild},
    [10] = {rate=5,src=self.scatter}
};

self.defalut_show_img = 
{
   [1] = {self.wild,self.scatter,self.wild},
   [2] = {self.wild,self.scatter,self.wild},
   [3] = {self.wild,self.scatter,self.wild},
   [4] = {self.wild,self.scatter,self.wild},
   [5] = {self.wild,self.scatter,self.wild}
}

self.line_config = 
{
    [1] = {5,6,7,8,9},
    [2] = {0,1,2,3,4},
    [3] = {10,11,12,13,14},
    [4] = {0,6,12,8,4},
    [5] = {10,6,2,8,14},
    [6] = {0,1,7,3,4}, 
    [7] = {10,11,7,13,14}, 
    [8] = {5,11,12,13,9},
    [9] = {5,1,2,3,9},
    [10] = {0,6,7,8,4},
    [11] = {10,6,7,8,14},
    [12] = {0,6,2,8,4},
    [13] = {10,6,12,8,14},
    [14] = {5,1,7,3,9},
    [15] = {5,11,7,13,9},
    [16] = {5,6,2,8,9}, 
    [17] = {5,6,12,8,9},
    [18] = {0,11,2,13,4},
    [19] = {10,1,12,3,14}, 
    [20] = {5,1,12,3,9},
    [21] = {5,11,2,13,9}, 
    [22] = {0,1,12,3,4}, 
    [23] = {10,11,2,13,14}, 
    [24] = {0,11,12,13,4},
    [25] = {10,1,2,3,14}
}

self.forlin = "forlin";--来做FruitsSlot_Line
self.forfree = "forfree";--来自免费
self.forreroll = "forreroll";--来自重转

