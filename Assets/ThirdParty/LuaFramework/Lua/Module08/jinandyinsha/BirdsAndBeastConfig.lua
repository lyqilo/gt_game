BirdsAndBeastConfig = {}
local self = BirdsAndBeastConfig;

 self.bab_start  = 0;--类型的开始
self.bab_yanz   = 0;--燕子
self.bab_gez    = 1;--鸽子
self.bab_kongq  = 2;--孔雀
self.bab_laoy   = 3;--老鹰
self.bab_shiz   = 4;--狮子
self.bab_xiongm = 5;--熊猫
self.bab_houz   = 6;--猴子
self.bab_tuz    = 7;--兔子
self.bab_yins   = 8;--银鲨
self.bab_jinsha = 9;--金鲨
self.bab_zous   = 10;--走兽
self.bab_feiq   = 11;--飞禽

self.sound_2 = "kongq";
self.sound_7 = "tuz";
self.sound_10 = "yaz";
self.sound_3 = "laoy";
self.sound_4 = "shiz";
self.sound_5 = "xiongm";
self.sound_6 = "huoz";
self.sound_1 = "gez";
self.sound_9 = "jinsha";
self.sound_8 = "yinsha";

self.sound_bg = "bg";
self.sound_changan = "changan";
self.sound_endrun = "endrun";
self.sound_runing = "runing";
self.sound_shaoguang = "shaoguang";
self.sound_startrun = "startrun";
self.sound_tes = "tes";
self.sound_xiazhu = "xiazhu";
self.sound_xiazhustart = "xiazhustart";
self.sound_jies = "jies";

self.bad_tsanim = self.bab_jinsha+1;--开金沙的时候 要先爆发动画

self.anim_res = 
{
     [self.bab_yanz] = {resab   = "module08/game_birdsandbeast_yaz",    resname="bad_yaz",      res=nil,    isloading=false},
     [self.bab_gez] = {resab    = "module08/game_birdsandbeast_gez",    resname="bad_gez",      res=nil,    isloading=false},
     [self.bab_kongq] = {resab  = "module08/game_birdsandbeast_kongq",  resname="bad_kongq",    res=nil,    isloading=false},
     [self.bab_laoy] = {resab   = "module08/game_birdsandbeast_laoy",   resname="bad_laoy",     res=nil,    isloading=false},
     [self.bab_shiz] = {resab   = "module08/game_birdsandbeast_shiz",   resname="bad_shiz",     res=nil,    isloading=false},
     [self.bab_xiongm] = {resab = "module08/game_birdsandbeast_xiongm", resname="bad_xiongm",   res=nil,    isloading=false},
     [self.bab_houz] = {resab   = "module08/game_birdsandbeast_huoz",   resname="bad_huoz",     res=nil,    isloading=false},
     [self.bab_tuz] = {resab    = "module08/game_birdsandbeast_tuz",    resname="bad_tuz",      res=nil,    isloading=false},
     [self.bab_yins] = {resab   = "module08/game_birdsandbeast_yingsha",resname="bad_yingsha",  res=nil,    isloading=false},
     [self.bab_jinsha] = {resab = "module08/game_birdsandbeast_jingsha",resname="bad_jingsha",  res=nil,    isloading=false},
     --[self.bad_tsanim] = {resab = "module08/game_birdsandbeast_tes",resname="bad_tes",res=nil,isloading=false}
};

function BirdsAndBeastConfig.destroying()
    table.foreachi(self.anim_res,function(i,k)
        if (k== nil ) then
            return;
        end
       Unload(k.resab);
     end)
     self.anim_res = 
     {
       [self.bab_yanz] = {resab = "module08/game_birdsandbeast_yaz",resname="bad_yaz",res=nil,isloading=false},
      [self.bab_gez] = {resab = "module08/game_birdsandbeast_gez",resname="bad_gez",res=nil,isloading=false},
      [self.bab_kongq] = {resab = "module08/game_birdsandbeast_kongq",resname="bad_kongq",res=nil,isloading=false},
      [self.bab_laoy] = {resab = "module08/game_birdsandbeast_laoy",resname="bad_laoy",res=nil,isloading=false},
      [self.bab_shiz] = {resab = "module08/game_birdsandbeast_shiz",resname="bad_shiz",res=nil,isloading=false},
      [self.bab_xiongm] = {resab = "module08/game_birdsandbeast_xiongm",resname="bad_xiongm",res=nil,isloading=false},
      [self.bab_houz] = {resab = "module08/game_birdsandbeast_huoz",resname="bad_huoz",res=nil,isloading=false},
      [self.bab_tuz] = {resab = "module08/game_birdsandbeast_tuz",resname="bad_tuz",res=nil,isloading=false},
      [self.bab_yins] = {resab = "module08/game_birdsandbeast_yingsha",resname="bad_yingsha",res=nil,isloading=false},
      [self.bab_jinsha] = {resab = "module08/game_birdsandbeast_jingsha",resname="bad_jingsha",res=nil,isloading=false},
      --[self.bad_tsanim] = {resab = "module08/game_birdsandbeast_tes",resname="bad_tes",res=nil,isloading=false}
     };
end


self.runitem_config = 
{
     [1] = {rtype =self.bab_yins },
     [2] = {rtype =self.bab_laoy },
     [3] = {rtype =self.bab_laoy },
     [4] = {rtype =self.bab_laoy },
     [5] = {rtype =self.bab_jinsha },
     [6] = {rtype =self.bab_shiz },
     [7] = {rtype =self.bab_shiz },
     [8] = {rtype =self.bab_shiz },
     [9] = {rtype =self.bab_yins },
     [10] = {rtype =self.bab_xiongm },
     [11] = {rtype =self.bab_xiongm },
     [12] = {rtype =self.bab_jinsha },
     [13] = {rtype =self.bab_houz },
     [14] = {rtype =self.bab_houz },
     [15] = {rtype =self.bab_yins },
     [16] = {rtype =self.bab_tuz },
     [17] = {rtype =self.bab_tuz },
     [18] = {rtype =self.bab_tuz },
     [19] = {rtype =self.bab_jinsha },
     [20] = {rtype =self.bab_yanz },
     [21] = {rtype =self.bab_yanz },
     [22] = {rtype =self.bab_yanz },
     [23] = {rtype =self.bab_yins },
     [24] = {rtype =self.bab_gez },
     [25] = {rtype =self.bab_gez },
     [26] = {rtype =self.bab_jinsha },
     [27] = {rtype =self.bab_kongq },
     [28] = {rtype =self.bab_kongq }
};

self.push_config = 
{
     [1] = {rtype =self.bab_feiq },
     [2] = {rtype =self.bab_jinsha },
     [3] = {rtype =self.bab_yins },
     [4] = {rtype =self.bab_zous },
     [5] = {rtype =self.bab_kongq },
     [6] = {rtype =self.bab_laoy },
     [7] = {rtype =self.bab_shiz },
     [8] = {rtype =self.bab_xiongm },
     [9] = {rtype =self.bab_yanz },
     [10] = {rtype =self.bab_gez },
     [11] = {rtype =self.bab_houz },
     [12] = {rtype =self.bab_tuz }
}

self.special_anima_config = 
{
    [1] = {t_1 = 0,   t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.8,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55 },
    [2] = {t_1 = 0.1,t_2 = 0.23,t_3 =0,t_4 = 0.17,t_5 = 1.6,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [3] = {t_1 = 0.2, t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.4,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [4] = {t_1 = 0.3,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.2,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [5] = {t_1 = 0.4,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.0,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [6] = {t_1 = 0.5,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.8,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [7] = {t_1 = 0.6,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.6,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [8] = {t_1 = 0.7,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.4,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [9] = {t_1 = 0.8,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.2,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },
    [10] = {t_1 =0.9,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.05,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = -55  },


    [11] = {t_1 = 0,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.8,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55 },
    [12] = {t_1 = 0.1,t_2 = 0.23,t_3 =0,t_4 = 0.17,t_5 = 1.6,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [13] = {t_1 = 0.2,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.4,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [14] = {t_1 = 0.3,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.2,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [15] = {t_1 = 0.4,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 1.0,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [16] = {t_1 = 0.5,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.8,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [17] = {t_1 = 0.6,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.6,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [18] = {t_1 = 0.7,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.4,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [19] = {t_1 = 0.8,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.2,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
    [20] = {t_1 = 0.9,t_2 = 0.23,t_3 = 0,t_4 = 0.17,t_5 = 0.05,t_6 = 0.23,t_7 = 0,t_8 = 0.17,scale = 55  },
}

self.run_timer_config = 
{
    [1] = {[1]=0.9,[2]=0.8,[3]=0.7,[4]=0.6,[5]=0.5,[6]=0.4,[7]=0.3,[8]=0.2,[9]=0.1,[10]=0.09,[11]=0.08,[12]=0.065,[13]=0.05},
    [2] = {[1]=0.9,[2]=0.8,[3]=0.7,[4]=0.6,[5]=0.5,[6]=0.4,[7]=0.3,[8]=0.2,[9]=0.1,[10]=0.09,[11]=0.08,[12]=0.065,[13]=0.05}
}
