xiangqi_Config = {};
local self = xiangqi_Config;

self.pawn = 0;		--卒
self.bcannon = 1;		--炮
self.knight= 2;		--马
self.rook= 3;			--车
self.elephant= 4;		--象
self.guard= 5;		--士
self.rcannon= 6;		--炮
self.horse= 7;		--马
self.chariot= 8;		--车
self.minister= 9;		--相
self.advisor= 10;		--仕		
self.general= 11;		--将
self.king= 12;			--帅

self.pawn_img= "pawn_img"; 		--卒
self.bcannon_img= "bcannon_img";		--炮
self.knight_img= "knight_img";		--马
self.rook_img= "rook_img";			--车
self.elephant_img= "elephant_img";		--象
self.guard_img= "guard_img"; 		--士
self.rcannon_img= "rcannon_img";		--炮
self.horse_img= "horse_img"; 		--马
self.chariot_img= "chariot_img";		--车
self.minister_img= "minister_img";		--相
self.advisor_img= "advisor_img"; 		--仕		
self.general_img= "general_img"; 		--将
self.king_img= "king_img"; 			--帅

self.resimg_config =
{
   [self.pawn] = {normalimg=self.pawn_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},-- animatype 1 闪 2 边框动画 3 边框加文字动画
   [self.bcannon] = {normalimg=self.bcannon_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},
   [self.knight] = {normalimg=self.knight_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},
   [self.rook] = {normalimg=self.rook_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},
   [self.elephant] = {normalimg=self.elephant_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},
   [self.guard] = {normalimg=self.guard_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},
   [self.rcannon] = {normalimg=self.rcannon_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=1},
   [self.horse] = {normalimg=self.horse_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=1},
   [self.chariot] = {normalimg=self.chariot_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=1},
   [self.minister] = {normalimg=self.minister_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=1},
   [self.advisor] = {normalimg=self.advisor_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=1},
   [self.general] = {normalimg=self.general_img,animaimg="general_anima_",count=20,loop = 1,animatype = 3,icolor=3},
   [self.king] = {normalimg=self.king_img,animaimg="king_anima_",count=20,loop = 1,animatype = 3,icolor=3},
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
    [1] = {rate=8,src=self.pawn},
    [2] = {rate=8,src=self.bcannon},
    [3] = {rate=8,src=self.knight},
    [4] = {rate=8,src=self.rook},
    [5] = {rate=8,src=self.elephant},
    [6] = {rate=8,src=self.guard},
    [7] = {rate=8,src=self.rcannon},
    [8] = {rate=8,src=self.horse},
    [9] = {rate=8,src=self.chariot},
    [10] = {rate=8,src=self.minister},
    [11] = {rate=8,src=self.advisor},
    [12] = {rate=6,src=self.general},
    [13] = {rate=6,src=self.king}
};
--免费的时候 只出红色
self.rand_2 = 
{
    [1] = {rate=18,src=self.rcannon},
    [2] = {rate=18,src=self.horse},
    [3] = {rate=18,src=self.chariot},
    [4] = {rate=18,src=self.minister},
    [5] = {rate=18,src=self.advisor},
    [6] = {rate=10,src=self.king}
};

self.defalut_show_img = 
{
   [1] = {self.king,self.king,self.king},
   [2] = {self.king,self.king,self.king},
   [3] = {self.king,self.king,self.king},
   [4] = {self.king,self.king,self.king},
   [5] = {self.king,self.king,self.king}
}

