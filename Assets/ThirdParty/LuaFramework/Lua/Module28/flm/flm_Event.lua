flm_Event = {}
local self = flm_Event;

self.messDic = {}
function flm_Event.addEvent(mess,callfun,key)
    if self.messDic[mess]==nil then
       self.messDic[mess] = {};
       table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
    else
       if self.funHand(mess,key)==false then
          table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
       end
    end
   
end

function flm_Event.destroying()
   self.messDic = {}
end

--�ж��ڷ������Ѿ����ڼ���
function flm_Event.funHand(mess,key)
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

function flm_Event.removeEvent(mess,key)
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

function flm_Event.dispathEvent(mess,data)
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

function flm_Event.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function flm_Event.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end


flm_Event.xiongm_over = "xiongm_over";--��Ϸ�Ľ���

flm_Event.xiongm_play_select_run = "xiongm_play_select_run";--�����еĶ���

flm_Event.xiongm_img_play_com = "xiongm_img_play_com";--�е�ͼƬ�����������

flm_Event.xiongm_exit = "xiongm_exit";--�˳���Ϸ
flm_Event.xiongm_unload_game_res = "xiongm_unload_game_res";--ɾ����è����Դ
flm_Event.xiongm_init = "xiongm_init";--


flm_Event.xiongm_start = "xiongm_start";--��ʼת��
flm_Event.xiongm_run_com = "xiongm_run_com";--�˶����

flm_Event.xiongm_show_line = "xiongm_show_line";--��ʾ��
flm_Event.xiongm_colse_line = "xiongm_colse_line";--�ر���ʾ��

flm_Event.xiongm_init = "xiongm_init";--��Ϸ�ĳ�ʼ��
flm_Event.xiongm_gold_chang = "xiongm_gold_chang";--��Ҹı�
flm_Event.xiongm_show_win_gold = "xiongm_show_win_gold";--��ʾӮ�Ľ�Ҷ���
flm_Event.xiongm_gold_roll_com = "xiongm_gold_roll_com";--��ҹ����ǲ������
flm_Event.xiongm_once_show_win_gold = "xiongm_once_show_win_gold";--���ģʽ�·ɽ�� ����������ʾӮ��
flm_Event.xiongm_show_allfu = "xiongm_show_allfu";--��ʾ����
flm_Event.xiongm_close_allfu = "xiongm_close_allfu";--�رո���


flm_Event.xiongm_show_line_anima = "xiongm_show_line_anima";--��ʾ�߶���
flm_Event.xiongm_colse_line_anima = "xiongm_colse_line_anima";--��ʾ�߶���


flm_Event.xiongm_show_jiugong_full_anima = "xiongm_show_jiugong_full_anima";--��ʾ�Ź���ȫ������
flm_Event.xiongm_show_jiugong_full_anima_com = "xiongm_show_jiugong_full_anima_com";--��ʾ�Ź���ȫ���������

flm_Event.xiongm_show_gudi = "xiongm_show_gudi";--��ʾ�̶�ͼƬ
flm_Event.xiongm_close_gudi = "xiongm_close_gudi";--�رչ̶�ͼƬ


flm_Event.xiongm_lihuo_bg_anima = "xiongm_lihuo_bg_anima";--�����һ��bg����
flm_Event.xiongm_lihuo_btn_anima = "xiongm_lihuo_btn_anima";--�����һ��btn����
flm_Event.xiongm_close_lihuo_anima = "xiongm_close_lihuo_anima";--�رղ����һ𶯻�

flm_Event.xiongm_show_start_btn ="xiongm_show_start_btn";--��ʾ��ʼ��ť
flm_Event.xiongm_start_btn_no_inter ="xiongm_start_btn_no_inter";--��ʼ��ť������
flm_Event.xiongm_show_free_btn ="xiongm_show_free_btn";--��ʾ��Ѵ���
flm_Event.xiongm_show_free_num_chang ="xiongm_show_free_num_chang";--��Ѵ����ı�
flm_Event.xiongm_show_stop_btn ="xiongm_show_stop_btn";--��ʾֹͣ��ť
flm_Event.xiongm_close_stop_btn ="xiongm_close_stop_btn";--�ر�ֹͣ��ť
flm_Event.xiongm_show_no_start_btn ="xiongm_show_no_start_btn";--��ʾ�ֶ���ť

flm_Event.xiongm_show_gold_mode_btn ="xiongm_show_gold_mode_btn";--���ģʽ�İ�ť��ʾ
flm_Event.xiongm_show_gold_mode_num_chang ="xiongm_show_gold_mode_num_chang";--���ģʽ�µ����ָı�

flm_Event.xiongm_choum_chang ="xiongm_choum_chang";--����ı�
flm_Event.xiongm_show_gold_mode_com_anima ="xiongm_show_gold_mode_com_anima";--�����ɺ�Ķ���

flm_Event.xiongm_show_stop_btn_click ="xiongm_show_stop_btn_click";--ֹͣ��ť���

flm_Event.xiongm_show_free_tips ="xiongm_show_free_tips";--��ʾ���tips

flm_Event.xiongm_start_btn_click = "xiongm_start_btn_click";--��ʼ��ť���

flm_Event.game_once_over = "game_once_over";--���̽���

flm_Event.xiongm_show_free_all_gold = "xiongm_show_free_all_gold";--����ܹ����˺ö���

flm_Event.xiongm_mianf_btn_mode ="xiongm_mianf_btn_mode";--�Բ���ʾ���תͼƬ
flm_Event.xiongm_title_mode ="xiongm_title_mode";--�����ģʽ

flm_Event.xiongm_load_res_com="xiongm_load_res_com";--��Դ�������

flm_Event.xiongm_update_allfu_value="xiongm_update_allfu_value";--���¸�����ֵ

flm_Event.xiongm_show_free_bg="xiongm_show_free_bg";--�������ģʽ�ı���
flm_Event.xiongm_close_free_bg="xiongm_close_free_bg";--�ر����ģʽ�ı���
















