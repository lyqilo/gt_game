xiangqi_Config = {};
local self = xiangqi_Config;

self.pawn = 0;		--��
self.bcannon = 1;		--��
self.knight= 2;		--��
self.rook= 3;			--��
self.elephant= 4;		--��
self.guard= 5;		--ʿ
self.rcannon= 6;		--��
self.horse= 7;		--��
self.chariot= 8;		--��
self.minister= 9;		--��
self.advisor= 10;		--��		
self.general= 11;		--��
self.king= 12;			--˧

self.pawn_img= "pawn_img"; 		--��
self.bcannon_img= "bcannon_img";		--��
self.knight_img= "knight_img";		--��
self.rook_img= "rook_img";			--��
self.elephant_img= "elephant_img";		--��
self.guard_img= "guard_img"; 		--ʿ
self.rcannon_img= "rcannon_img";		--��
self.horse_img= "horse_img"; 		--��
self.chariot_img= "chariot_img";		--��
self.minister_img= "minister_img";		--��
self.advisor_img= "advisor_img"; 		--��		
self.general_img= "general_img"; 		--��
self.king_img= "king_img"; 			--˧

self.resimg_config =
{
   [self.pawn] = {normalimg=self.pawn_img,animaimg="anima_toum",count=20,loop = 1,animatype = 2,icolor=2},-- animatype 1 �� 2 �߿򶯻� 3 �߿�����ֶ���
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

--�˶���ʱ��
self.runtimer_config = 
{
    [1] = 0;
    [2] = 0.1;
    [3] = 0.2;
    [4] = 0.3;
    [5] = 0.4;
}
--�˶���ʼǰ�ĵȴ�ʱ��
self.runwaittimer_config = 
{
    [1] = 0.0;
    [2] = 0.15;
    [3] = 0.3;
    [4] = 0.45;
    [5] = 0.6;
}
--�����˶�ͼƬ
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

--1,5�еĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
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
--��ѵ�ʱ�� ֻ����ɫ
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

