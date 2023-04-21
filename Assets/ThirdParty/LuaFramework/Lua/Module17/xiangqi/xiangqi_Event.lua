xiangqi_Event = {}
local self = xiangqi_Event;

self.messDic = {}
function xiangqi_Event.addEvent(mess,callfun,key)
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

function xiangqi_Event.destroying()
   self.messDic = {}
end

--�ж��ڷ������Ѿ����ڼ���
function xiangqi_Event.funHand(mess,key)
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

function xiangqi_Event.removeEvent(mess,key)
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

function xiangqi_Event.dispathEvent(mess,data)
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

function xiangqi_Event.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function xiangqi_Event.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end


xiangqi_Event.xiangqi_over = "xiangqi_over";--��Ϸ�Ľ���

xiangqi_Event.xiongm_exit = "xiongm_exit";--�˳���Ϸ
xiangqi_Event.xiangqi_unload_game_res = "xiangqi_unload_game_res";--�˳������Դ
xiangqi_Event.xiongm_init = "xiongm_init";--


xiangqi_Event.xiongm_start = "xiongm_start";--��ʼת��
xiangqi_Event.xiongm_run_com = "xiongm_run_com";--�˶����

xiangqi_Event.xiongm_show_line = "xiongm_show_line";--��ʾ��
xiangqi_Event.xiongm_colse_line = "xiongm_colse_line";--�ر���ʾ��

xiangqi_Event.xiongm_init = "xiongm_init";--��Ϸ�ĳ�ʼ��
xiangqi_Event.xiongm_gold_chang = "xiongm_gold_chang";--��Ҹı�
xiangqi_Event.xiongm_show_win_gold = "xiongm_show_win_gold";--��ʾӮ�Ľ�Ҷ���
xiangqi_Event.xiongm_gold_roll_com = "xiongm_gold_roll_com";--��ҹ����ǲ������


xiangqi_Event.xiongm_show_line_anima = "xiongm_show_line_anima";--��ʾ�߶���
xiangqi_Event.xiongm_colse_line_anima = "xiongm_colse_line_anima";--��ʾ�߶���


xiangqi_Event.xiongm_show_jiugong_full_anima = "xiongm_show_jiugong_full_anima";--��ʾ�Ź���ȫ������
xiangqi_Event.xiongm_show_jiugong_full_anima_com = "xiongm_show_jiugong_full_anima_com";--��ʾ�Ź���ȫ���������

xiangqi_Event.xiongm_show_gudi = "xiongm_show_gudi";--��ʾ�̶�ͼƬ
xiangqi_Event.xiongm_close_gudi = "xiongm_close_gudi";--�رչ̶�ͼƬ


xiangqi_Event.xiongm_lihuo_bg_anima = "xiongm_lihuo_bg_anima";--�����һ��bg����
xiangqi_Event.xiongm_lihuo_btn_anima = "xiongm_lihuo_btn_anima";--�����һ��btn����
xiangqi_Event.xiongm_close_lihuo_anima = "xiongm_close_lihuo_anima";--�رղ����һ𶯻�

xiangqi_Event.xiongm_show_start_btn ="xiongm_show_start_btn";--��ʾ��ʼ��ť
xiangqi_Event.xiongm_start_btn_no_inter ="xiongm_start_btn_no_inter";--��ʼ��ť������
xiangqi_Event.xiongm_show_free_btn ="xiongm_show_free_btn";--��ʾ��Ѵ���
xiangqi_Event.xiongm_show_free_num_chang ="xiongm_show_free_num_chang";--��Ѵ����ı�

xiangqi_Event.xiongm_show_no_start_btn ="xiongm_show_no_start_btn";--��ʾ�ֶ���ť

xiangqi_Event.xiongm_show_free_tips ="xiongm_show_free_tips";--��ʾ���tips

xiangqi_Event.xiongm_start_btn_click = "xiongm_start_btn_click";--��ʼ��ť���


xiangqi_Event.xiongm_show_free_all_gold = "xiongm_show_free_all_gold";--����ܹ����˺ö���

xiangqi_Event.xiongm_show_bg = "xiongm_show_bg";--��ʾ����
xiangqi_Event.xiongm_show_free_bg_anima = "xiongm_show_free_bg_anima";--��ʾ��ѱ�������

xiangqi_Event.xiongm_show_stop_btn ="xiongm_show_stop_btn";--��ʾֹͣ��ť
xiangqi_Event.xiongm_close_stop_btn ="xiongm_close_stop_btn";--�ر�ֹͣ��ť

xiangqi_Event.xiongm_show_stop_btn_click ="xiongm_show_stop_btn_click";--ֹͣ��ť���

xiangqi_Event.xiongm_choum_chang ="xiongm_choum_chang";--����ı�

xiangqi_Event.game_once_over = "game_once_over";--���̽���

xiangqi_Event.xiongm_mianf_btn_mode ="xiongm_mianf_btn_mode";--�Բ���ʾ���תͼƬ
xiangqi_Event.xiongm_title_mode ="xiongm_title_mode";--�����ģʽ

xiangqi_Event.xiongm_load_res_com ="xiongm_load_res_com";--��Դ�������















