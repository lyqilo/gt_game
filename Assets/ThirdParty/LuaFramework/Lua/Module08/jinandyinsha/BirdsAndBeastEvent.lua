BirdsAndBeastEvent = {}
local self = BirdsAndBeastEvent;

self.messDic = {}
function BirdsAndBeastEvent.addEvent(mess,callfun,key)
    if self.messDic[mess]==nil then
       self.messDic[mess] = {};
       table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
    else
       if self.funHand(mess,key)==false then
          table.insert(self.messDic[mess],#self.messDic[mess]+1,{callfun=callfun,key=key});
       end
    end
   
end

function BirdsAndBeastEvent.destroying()
   self.messDic = {}
end

--�ж��ڷ������Ѿ����ڼ���
function BirdsAndBeastEvent.funHand(mess,key)
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

function BirdsAndBeastEvent.removeEvent(mess,key)
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

function BirdsAndBeastEvent.dispathEvent(mess,data)
    if self.messDic[mess]==nil then
       return;
    end
    --error("_____mess________"..mess);
    local tab = self.messDic[mess];
    local len = #tab;
    for i=1,len do
        tab[i].callfun({mess=mess,data=data});
    end    
end

function BirdsAndBeastEvent.guid()
    local seed = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    local tb = {};
    for i=1,32 do
       table.insert(tb,seed[math.random(1,16)]);
    end
    local sid = table.concat(tb);
    return sid;
end

function BirdsAndBeastEvent.hander(args,fun)
    return function (...)
             fun(args,...);
         end
end

BirdsAndBeastEvent.allpushchang = "allpushchang";--����ע�ĸı䣬�������ȫ���˵���ע
BirdsAndBeastEvent.mypushmoneychang = "mypushmoneychang";--�Լ���ע�ĸı�
BirdsAndBeastEvent.pushmoneymultiplechang = "pushmoneymultiplechang";--��ע�ı����ı�
BirdsAndBeastEvent.hischang = "hischang";--��ʷ��¼  ��ʵ����·��
BirdsAndBeastEvent.choumchang = "choumchang";--����ı�
BirdsAndBeastEvent.gamestatechang = "gamestatechang";--��Ϸ״̬�ĸı�
BirdsAndBeastEvent.gametimerchang = "gametimerchang";--��Ϸʱ��ĸı�
BirdsAndBeastEvent.startrun = "startrun";--��������Ҫ�˶�����
BirdsAndBeastEvent.gamenewinit = "gamenewinit";--��ʾһ�ֵĿ�ʼ��һ�㶼������������ʾ
BirdsAndBeastEvent.startchip = "startchip";--��ʼ��ע
BirdsAndBeastEvent.stopchip = "stopchip";--ֹͣ��ע
BirdsAndBeastEvent.gameover = "gameover";--��Ϸ����
BirdsAndBeastEvent.myinfochang = "myinfochang";--�����Ϣ�ĸı�
BirdsAndBeastEvent.openPushchang = "openPushchang";--�������Ľ�� ��Ҫ����ʾ��ע�����Ӧע��Ч��
BirdsAndBeastEvent.gamewinchang = "gamewinchang";--�����Ӯ
BirdsAndBeastEvent.gameinit = "gameinit";--�ŵ�½��Ϸ�յ��Ŀ������



BirdsAndBeastEvent.openmypushpanel = "openmypushpanel";--�򿪹ر���ע���
BirdsAndBeastEvent.openmypushcom = "openmypushcom";--���Ž�Ҷ���
BirdsAndBeastEvent.creatgoldanima = "creatgoldanima";--������Ҷ���
BirdsAndBeastEvent.animaresdowncom = "animaresdowncom";--������Դ�������

BirdsAndBeastEvent.startspecialanima = "startspecialanima";--��ʼ�������⶯��
BirdsAndBeastEvent.oncestopspecialanima = "oncestopspecialanima";--ֹͣ�������⶯��

BirdsAndBeastEvent.stopspecialanima = "stopspecialanima";--��ɲ������⶯��

BirdsAndBeastEvent.showgameloading = "showgameloading";--�򿪹ر�������Ϸ��ͼ��


BirdsAndBeastEvent.exitgame = "exitgame";--�˳���Ϸ
BirdsAndBeastEvent.unload_game_res = "unload_game_res";--���ab

BirdsAndBeastEvent.continuechipiter = "continuechipiter";--��ѹ�ǲ��ǿ�����


BirdsAndBeastEvent.reflushuserlist = "reflushuserlist";--ˢ���û��б�






