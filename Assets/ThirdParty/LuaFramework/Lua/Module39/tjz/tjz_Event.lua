tjz_Event = {}
local self = tjz_Event;

self.messDic = {}
function tjz_Event.addEvent(mess,callfun,key)
    if self.messDic[mess]==nil then
       self.messDic[mess] = {};
       table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
    else
       if self.funHand(mess,key)==false then
          table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
       end
    end
   
end

function tjz_Event.destroying()
   self.messDic = {}
end

--判断在方法是已经存在监听
function tjz_Event.funHand(mess,key)
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

function tjz_Event.removeEvent(mess,key)
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

function tjz_Event.dispathEvent(mess,data)
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

function tjz_Event.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function tjz_Event.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end


tjz_Event.xiongm_over = "xiongm_over";--游戏的结算

tjz_Event.xiongm_play_select_run = "xiongm_play_select_run";--播放中的动画

tjz_Event.xiongm_img_play_com = "xiongm_img_play_com";--中的图片动画播放完成

tjz_Event.xiongm_exit = "xiongm_exit";--退出游戏
tjz_Event.xiongm_unload_game_res = "xiongm_unload_game_res";--删除熊猫的资源
tjz_Event.xiongm_init = "xiongm_init";--


tjz_Event.xiongm_start = "xiongm_start";--开始转动
tjz_Event.xiongm_run_com = "xiongm_run_com";--运动完成

tjz_Event.xiongm_show_line = "xiongm_show_line";--显示线
tjz_Event.xiongm_colse_line = "xiongm_colse_line";--关闭显示线

tjz_Event.xiongm_init = "xiongm_init";--游戏的初始化
tjz_Event.xiongm_gold_chang = "xiongm_gold_chang";--金币改变
tjz_Event.xiongm_show_win_gold = "xiongm_show_win_gold";--显示赢的金币动画
tjz_Event.xiongm_gold_roll_com = "xiongm_gold_roll_com";--金币滚动是不是完成

tjz_Event.xiongm_show_win_caijin = "xiongm_show_win_caijin";--显示中奖彩金
tjz_Event.xiongm_com_win_caijin = "xiongm_com_win_caijin";--彩金中奖完成

tjz_Event.xiongm_show_win_type = "xiongm_show_win_type";--显示中大奖
tjz_Event.xiongm_com_win_type = "xiongm_com_win_type";--中大奖完成

tjz_Event.xiongm_show_icon_up = "xiongm_show_icon_up";--显示图标升级
tjz_Event.xiongm_com_icon_up = "xiongm_com_icon_up";--图标升级完成


tjz_Event.xiongm_show_line_anima = "xiongm_show_line_anima";--显示线动画
tjz_Event.xiongm_colse_line_anima = "xiongm_colse_line_anima";--显示线动画



tjz_Event.xiongm_show_gudi = "xiongm_show_gudi";--显示固定图片
tjz_Event.xiongm_close_gudi = "xiongm_close_gudi";--关闭固定图片
tjz_Event.xiongm_move_gudi = "xiongm_move_gudi";--移动固定




tjz_Event.xiongm_show_start_btn ="xiongm_show_start_btn";--显示开始按钮
tjz_Event.xiongm_start_btn_no_inter ="xiongm_start_btn_no_inter";--开始按钮不可用
tjz_Event.xiongm_show_free_btn ="xiongm_show_free_btn";--显示免费次数
tjz_Event.xiongm_show_free_num_chang ="xiongm_show_free_num_chang";--免费次数改变
tjz_Event.xiongm_show_stop_btn ="xiongm_show_stop_btn";--显示停止按钮
tjz_Event.xiongm_close_stop_btn ="xiongm_close_stop_btn";--关闭停止按钮
tjz_Event.xiongm_show_no_start_btn ="xiongm_show_no_start_btn";--显示手动按钮

tjz_Event.xiongm_choum_chang ="xiongm_choum_chang";--筹码改变

tjz_Event.xiongm_show_stop_btn_click ="xiongm_show_stop_btn_click";--停止按钮点击

tjz_Event.xiongm_show_free_tips ="xiongm_show_free_tips";--显示免费tips

tjz_Event.xiongm_start_btn_click = "xiongm_start_btn_click";--开始按钮点击

tjz_Event.game_once_over = "game_once_over";--立刻结束

tjz_Event.xiongm_show_free_all_gold = "xiongm_show_free_all_gold";--免费总共中了好多金币

tjz_Event.xiongm_mianf_btn_mode ="xiongm_mianf_btn_mode";--显不显示免费转图片
tjz_Event.xiongm_title_mode ="xiongm_title_mode";--标题的模式

tjz_Event.xiongm_load_res_com="xiongm_load_res_com";--资源加载完成
















