FruitsSlotEvent = {}
local self = FruitsSlotEvent;

self.messDic = {}
function FruitsSlotEvent.addEvent(mess,callfun,key)
    if self.messDic[mess]==nil then
       self.messDic[mess] = {};
       table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
    else
       if self.funHand(mess,key)==false then
          table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
       end
    end
   
end

function FruitsSlotEvent.destroying()
   self.messDic = {}
end

--�ж��ڷ������Ѿ����ڼ���
function FruitsSlotEvent.funHand(mess,key)
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

function FruitsSlotEvent.removeEvent(mess,key)
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

function FruitsSlotEvent.dispathEvent(mess,data)
    if self.messDic[mess]==nil then
       return;
    end
   -- error("_____mess________"..mess);
    local tab = self.messDic[mess];
    local len = #tab;
    for i=1,len do
        tab[i].callfun({mess=mess,data=data});
    end    
end

function FruitsSlotEvent.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function FruitsSlotEvent.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end


FruitsSlotEvent.game_over = "game_over";--��Ϸ�Ľ���
FruitsSlotEvent.game_start = "game_start";--��ʼת��
FruitsSlotEvent.game_run_com = "game_run_com";--�˶����
FruitsSlotEvent.game_play_select_run = "game_play_select_run";--�����еĶ���
FruitsSlotEvent.game_img_play_com = "game_img_play_com";--�е�ͼƬ�����������
FruitsSlotEvent.game_tes_play_com = "game_tes_play_com";--���⶯���������
FruitsSlotEvent.game_bell_value = "game_bell_value";--���ص�����ֵ
FruitsSlotEvent.game_bell_start = "game_bell_start";--��ʼ������Ϸ
FruitsSlotEvent.game_bell_over = "game_bell_over";--����������Ϸ
FruitsSlotEvent.game_init = "game_init";--��Ϸ�ĳ�ʼ��
FruitsSlotEvent.game_gold_chang = "game_gold_chang";--��Ҹı�
FruitsSlotEvent.game_show_win_gold = "game_show_win_gold";--��ʾӮ�Ľ�Ҷ���
FruitsSlotEvent.game_gold_roll_com = "game_gold_roll_com";--��ҹ����ǲ������
FruitsSlotEvent.game_show_colse_lock_bg = "game_show_colse_lock_bg";--��ʾ������ʾ��������
FruitsSlotEvent.game_play_stop_light_anima = "game_play_stop_light_anima";--���Ż���ֹͣ�ȵĶ���
FruitsSlotEvent.game_show_free = "game_show_free";--�����������Ѵ�����ʾ
FruitsSlotEvent.game_start_btn_inter = "game_start_btn_inter";--��ʼ��ť�Ŀɵ��
FruitsSlotEvent.game_start_btn_click = "game_start_btn_click";--��ť����Ŀ�ʼ
FruitsSlotEvent.game_once_over = "game_once_over";--���̽���




FruitsSlotEvent.game_exit = "game_exit";--�˳���Ϸ







