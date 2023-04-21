FruitsSlot_Config = {};
local self = FruitsSlot_Config;

self.select_img_play_com_type_line = 1;--���ߵĲ���ͼ�궯��
self.select_img_play_com_type_bell = 2;--�����Ĳ���

self.E_FULL_SCREEN_NULL = 0;	--����ȫ��
self.E_FULL_SCREEN_FRUIT = 1;	--ȫ��ˮ��
self.E_FULL_SCREEN_BAR = 2;		--ȫ��BAR
self.E_FULL_SCREEN_SEVEN = 3;	--ȫ��7


--self.e_fruit_cherry = 0;--ӣ��
self.e_fruit_lemon = 0;		--����
self.e_fruit_grape = 1;		--����
self.e_fruit_watermelon = 2;	--����
self.e_bar_small = 3;		--СBAR
self.e_bar_mid = 4;			--��BAR
self.e_bar_big = 5;			--��BAR
self.e_seven_small = 6;		--С7
self.e_seven_mid = 7;		--��7
self.e_seven_big = 8;		--��7	
self.e_wild = 9;				--WILD
self.e_bell = 10;			--����

self.e_double_wild = 11;--wild ����ǿͻ��˶���ı�ʾ��wild��������Ҫ�ǿ��Էŵ�resimg_config�������� ���Զ���

--self.e_fruit_cherry_img = "fruit_cherry";--ӣ��
self.e_seven_mid_img = "seven_mid";		--��7
self.e_fruit_grape_img = "fruit_grape";		--����
self.e_fruit_watermelon_img = "fruit_watermelon";	--����
self.e_fruit_lemon_img = "e_fruit_lemon";		--����
self.e_bar_small_img = "bar_small";		--СBAR
self.e_bar_mid_img = "e_bar_mid";			--��BAR
self.e_bar_big_img = "bar_big";			--��BAR
self.e_seven_small_img = "seven_small";		--С7
self.e_seven_big_img = "seven_big";		--��7	
self.e_wild_img = "wild";				--WILD
self.e_bell_img = "bell";			--����

--self.e_fruit_cherry_anima = "fruit_cherry_anima";--ӣ��
self.e_seven_mid_anima = "seven_mid_anima";--ӣ��
self.e_fruit_grape_anima = "fruit_grape_anima";		--����
self.e_fruit_watermelon_anima = "fruit_watermelon_anima";	--����
self.e_fruit_lemon_anima = "e_fruit_lemon_anima";		--����
self.e_bar_small_anima = "bar_small_anima";		--СBAR
self.e_bar_mid_anima = "e_bar_mid_anima";			--��BAR
self.e_bar_big_anima = "bar_big_anima";			--��BAR
self.e_seven_small_anima = "seven_small_anima";		--С7
self.e_seven_big_anima = "seven_big_anima";		--��7	
self.e_wild_anima = "wild_anima";				--WILD
self.e_bell_anima = "bell_anima";			--����
self.e_double_wild_anima = "double_wild_anima";--��wild����

self.resimg_config =
{
   --[self.e_fruit_cherry] = {cfname=self.e_fruit_cherry_img,animaimg=self.e_fruit_cherry_anima,count=17},
   
   [self.e_fruit_lemon] = {cfname=self.e_fruit_lemon_img,animaimg=self.e_fruit_lemon_anima,count=4,loop = 8},
   [self.e_fruit_grape] = {cfname=self.e_fruit_grape_img,animaimg=self.e_fruit_grape_anima,count=4,loop = 8},
   [self.e_fruit_watermelon] = {cfname=self.e_fruit_watermelon_img,animaimg=self.e_fruit_watermelon_anima,count=4,loop = 8},
   [self.e_bar_small] = {cfname=self.e_bar_small_img,animaimg=self.e_bar_small_anima,count=4,loop = 8},
   [self.e_bar_mid] = {cfname=self.e_bar_mid_img,animaimg=self.e_bar_mid_anima,count=4,loop = 8},
   [self.e_bar_big] = {cfname=self.e_bar_big_img,animaimg=self.e_bar_big_anima,count=4,loop = 8},
   [self.e_seven_small] = {cfname=self.e_seven_small_img,animaimg=self.e_seven_small_anima,count=4,loop = 8},
   [self.e_seven_mid] = {cfname=self.e_seven_mid_img,animaimg=self.e_seven_mid_anima,count=4,loop = 8},
   [self.e_seven_big] = {cfname=self.e_seven_big_img,animaimg=self.e_seven_big_anima,count=4,loop = 8},
   [self.e_wild] = {cfname=self.e_wild_img,animaimg=self.e_wild_anima,count=16,loop = 2},
   [self.e_bell] = {cfname=self.e_bell_img,animaimg=self.e_bell_anima,count=15,loop = 2},
   [self.e_double_wild] = {cfname=self.e_wild_img,animaimg=self.e_double_wild_anima,count=16,loop = 2} 
}

self.resimg_full_anima_config = 
{
   [self.E_FULL_SCREEN_FRUIT] = {showicon="full_fruit_icon",showbg="full_fruit_bg",timer=3},
   [self.E_FULL_SCREEN_BAR] = {showicon="full_bar_icon",showbg="full_bar_bg",timer=3},
   [self.E_FULL_SCREEN_SEVEN] = {showicon="full_seven_icon",showbg="full_seven_bg",timer=3}
}
--�˶���ʱ��
self.runtimer_config = 
{
    [1] = 2.0;
    [2] = 2.3;
    [3] = 2.6;
    [4] = 2.9;
    [5] = 3.2;
}
--Ҫ���ɺö�ͼƬ�˶�
self.runimglen_config = 
{
    [1] = 7;
    [2] = 8;
    [3] = 9;
    [4] = 10;
    [5] = 11;
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
    [1] = 0.2;
    [2] = 0.5;
    [3] = 0.8;
    [4] = 1.1;
    [5] = 1.4;
}

--�ĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
self.zurate = 
{
    [1] = {rate=30,cfname="shuiguo"},
    [2] = {rate=30,cfname="bar"},
    [3] = {rate=30,cfname="z7"},
    [4] = {rate=10,cfname="wild"}
};
--��һ�е�ʱ�� ������wild
self.first_zurate = 
{
    [1] = {rate=40,cfname="shuiguo"},
    [2] = {rate=30,cfname="bar"},
    [3] = {rate=30,cfname="z7"}
};
   --- [4] = {rate=25,cfname="wild"}
--ˮ���ĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
self.shuiguo = 
{
    [1] = {rate=10,cfname=self.e_bell_img},
    [2] = {rate=30,cfname=self.e_fruit_grape_img},
    [3] = {rate=30,cfname=self.e_fruit_watermelon_img},
    [4] = {rate=30,cfname=self.e_fruit_lemon_img}
};

--bar�ĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
self.bar = 
{
    [1] = {rate=10,cfname=self.e_bell_img},
    [2] = {rate=30,cfname=self.e_bar_small_img},
    [3] = {rate=30,cfname=self.e_bar_big_img},
    [4] = {rate=30,cfname=self.e_bar_mid_img}
};
--777��ĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
self.z7 = 
{
    [1] = {rate=10,cfname=self.e_bell_img},
    [2] = {rate=30,cfname=self.e_seven_small_img},
    [3] = {rate=30,cfname=self.e_seven_mid_img},
    [4] = {rate=30,cfname=self.e_seven_big_img}
};
--wild��ĸ��ʣ��ͻ������˶��� ���Ƿ����������ĸ��ʣ�
self.wild = 
{
     [1] = {rate=100,cfname=self.e_wild_img}
};
self.randSecondimg_1 = 
{
    [1] = self.e_fruit_lemon ;--����
    [2] = self.e_fruit_grape ;		--����
    [3] = self.e_fruit_watermelon;	--����
};
self.randSecondimg_2 = 
{
    [1] = self.e_bar_small;		--СBAR
    [2] = self.e_bar_big;			--��BAR
    [3] = self.e_seven_small;		--С7
    [4] = self.e_seven_mid;		--��7
    [5] = self.e_seven_big;		--��7	
    [6] = self.e_bell;			--����
};

self.line_config = 
{
   [1] = {0,1,2,3,4}, 
   [2] = {5,6,7,8,9}, 
   [3] = {10,11,12,13,14}, 
   [4] = {0,1,7,13,14},
   [5] = {10,11,7,3,4},
   [6] = {0,11,2,13,4},
   [7] = {10,1,12,3,14},
   [8] = {0,6,12,8,4},
   [9] = {10,6,2,8,14}, 
   [10] = {5,1,2,3,9},
   [11] = {5,11,12,13,9}
}

self.defalut_show_img = 
{
   [1] = {self.e_wild,self.e_bar_big,self.e_bell},
   [2] = {self.e_fruit_watermelon,self.e_bar_big,self.e_seven_big},
   [3] = {self.e_fruit_grape,self.e_bar_small,self.e_seven_small},
   [4] = {self.e_seven_mid,self.e_bar_big,self.e_seven_big},
   [5] = {self.e_wild,self.e_bar_big,self.e_bell}
}

self.sound_btn = "s_btn";--��ť������
self.sound_click_bell = "s_click_bell";--�����������
self.sound_gold_add = "s_gold_add";--�������
self.sound_enter_bell_on = "s_enter_bell_on";--��ȥС������Ϸǰ
self.sound_bell_game = "s_bell_game";--С������Ϸ��
self.sound_free = "s_free";--����Ѵ�����ʱ��
self.sound_start = "s_start";--��ʼ��Ϸ
self.sound_full ="s_full";--ȫ������
self.sound_run_stop = "s_run_stop";--ÿ��ת��ֹͣ
self.sound_line = "s_line";--���ߵ�����

self.starlin = "starlin";--����FruitsSlot_Line
self.starbell = "starbell";--��������
