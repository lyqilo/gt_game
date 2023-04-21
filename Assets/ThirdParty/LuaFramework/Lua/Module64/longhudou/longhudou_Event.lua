longhudou_Event = {}
local self = longhudou_Event;

self.messDic = {}
function longhudou_Event.addEvent(mess,callfun,key)
   --error("______"..mess);
    if self.messDic[mess]==nil then
       self.messDic[mess] = {};
       table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
    else
       if self.funHand(mess,key)==false then
          table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
       end
    end
   
end

function longhudou_Event.destroying()
   self.messDic = {}
end

--判断在方法是已经存在监听
function longhudou_Event.funHand(mess,key)
   if self.messDic[mess]==nil then
       return false;
    end
    local tab = self.messDic[mess];
    local len = #tab;
    for i=len,1,-1 do
        if tab[i].key == key then
           return true;
        end
    end    
    return false;
end

function longhudou_Event.removeEvent(mess,key)
    if self.messDic[mess]==nil then
       return;
    end
    local tab = self.messDic[mess];
    local len = #tab;
    for i=len,1,-1 do
        if tab[i].key == key then
           table.remove(tab,i);
        end
    end    
end

function longhudou_Event.dispathEvent(mess,data)
    if self.messDic[mess]==nil then
       return;
    end
   
    local tab = self.messDic[mess];
    local len = #tab;
    --error("_____mess________"..mess.."____"..len);
    for i=1,len do
        tab[i].callfun({mess=mess,data=data});
    end    
end

function longhudou_Event.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function longhudou_Event.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end


longhudou_Event.xiangqi_over = "xiangqi_over";--游戏的结算
longhudou_Event.xiangqi_two_reflush_over = "xiangqi_two_reflush_over";--当在免费游戏里面的时候 要把有wil的那一列 全部替换成wild

longhudou_Event.xiongm_exit = "xiongm_exit";--退出游戏
longhudou_Event.xiangqi_unload_game_res = "xiangqi_unload_game_res";--退出清除资源
longhudou_Event.xiongm_caijin_chang = "xiongm_caijin_chang";--
longhudou_Event.xiongm_normal_roll_com = "xiongm_normal_roll_com";--
longhudou_Event.xiongm_win_caijin_roll_com = "xiongm_win_caijin_roll_com";--
longhudou_Event.xiongm_long_move = "xiongm_long_move";--免费的时候 龙移动


longhudou_Event.xiongm_start = "xiongm_start";--开始转动
longhudou_Event.xiongm_run_com = "xiongm_run_com";--运动完成

longhudou_Event.xiongm_show_line = "xiongm_show_line";--显示线
longhudou_Event.xiongm_colse_line = "xiongm_colse_line";--关闭显示线

longhudou_Event.xiongm_init = "xiongm_init";--游戏的初始化
longhudou_Event.xiongm_gold_chang = "xiongm_gold_chang";--金币改变
longhudou_Event.xiongm_show_win_gold = "xiongm_show_win_gold";--显示赢的金币动画
longhudou_Event.xiongm_gold_roll_com = "xiongm_gold_roll_com";--金币滚动是不是完成


longhudou_Event.xiongm_show_line_anima = "xiongm_show_line_anima";--显示线动画
longhudou_Event.xiongm_colse_line_anima = "xiongm_colse_line_anima";--显示线动画


longhudou_Event.xiongm_show_jiugong_full_anima = "xiongm_show_jiugong_full_anima";--显示九宫和全屏动画
longhudou_Event.xiongm_show_jiugong_full_anima_com = "xiongm_show_jiugong_full_anima_com";--显示九宫和全屏动画完成

longhudou_Event.xiongm_show_gudi = "xiongm_show_gudi";--显示固定图片
longhudou_Event.xiongm_close_gudi = "xiongm_close_gudi";--关闭固定图片


longhudou_Event.xiongm_lihuo_bg_anima = "xiongm_lihuo_bg_anima";--播放烈火的bg动画
longhudou_Event.xiongm_lihuo_btn_anima = "xiongm_lihuo_btn_anima";--播放烈火的btn动画
longhudou_Event.xiongm_close_lihuo_anima = "xiongm_close_lihuo_anima";--关闭播放烈火动画

longhudou_Event.xiongm_show_start_btn ="xiongm_show_start_btn";--显示开始按钮
longhudou_Event.xiongm_start_btn_no_inter ="xiongm_start_btn_no_inter";--开始按钮不可用
longhudou_Event.xiongm_show_free_btn ="xiongm_show_free_btn";--显示免费次数
longhudou_Event.xiongm_show_free_num_chang ="xiongm_show_free_num_chang";--免费次数改变

longhudou_Event.xiongm_show_no_start_btn ="xiongm_show_no_start_btn";--显示手动按钮

longhudou_Event.xiongm_show_free_tips ="xiongm_show_free_tips";--显示免费tips

longhudou_Event.xiongm_start_btn_click = "xiongm_start_btn_click";--开始按钮点击


longhudou_Event.xiongm_show_free_all_gold = "xiongm_show_free_all_gold";--免费总共中了好多金币

longhudou_Event.xiongm_show_bg = "xiongm_show_bg";--显示背景
longhudou_Event.xiongm_show_free_bg_anima = "xiongm_show_free_bg_anima";--显示免费背景动画

longhudou_Event.xiongm_show_stop_btn ="xiongm_show_stop_btn";--显示停止按钮
longhudou_Event.xiongm_close_stop_btn ="xiongm_close_stop_btn";--关闭停止按钮

longhudou_Event.xiongm_show_stop_btn_click ="xiongm_show_stop_btn_click";--停止按钮点击

longhudou_Event.xiongm_choum_chang ="xiongm_choum_chang";--筹码改变

longhudou_Event.game_once_over = "game_once_over";--立刻结束

longhudou_Event.xiongm_mianf_btn_mode ="xiongm_mianf_btn_mode";--显不显示免费转图片
longhudou_Event.xiongm_title_mode ="xiongm_title_mode";--标题的模式

longhudou_Event.xiongm_load_res_com ="xiongm_load_res_com";--资源加载完成















