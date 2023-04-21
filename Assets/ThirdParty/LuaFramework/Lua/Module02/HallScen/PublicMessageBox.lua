
PublicMessageBox = {};
local  self = PublicMessageBox;
local saveBtn = {};
local savemess = {};
local curshowTabe = nil;
local isshow = false;
local panel = nil;
local _luaBeHaviour = nil;
--lvl ����ȼ�
--message �ַ�����ʾ����Ϣ
--btntab ��һ��table ����{"ok","cancel"}
--callfuntab ��һ��table �Ǹ����ص��õķ��� key ��btntab��ֵ {["ok"]=fun,["cancel"]=fun,["ok_v"]=ֵ} ���ok����Ҫ���ز�������key+v
--delallmess ��true����ֻ����Ϣ�������Ϣ������ʾ ���
function PublicMessageBox.showMess(lvl,message,btntab,callfuntab,delallmess)
   local  mes = {};
   mes["level"] = lvl;
   mes["message"] = message;
   mes["btntab"] = btntab;
   mes["callfuntab"] = callfuntab;
   mes["delallmess"] = delallmess;
   if isshow==false then
      isshow = true;
      curshowTabe = mes;
      if panel==nil then
          panel = {};
    --ResManager:LoadAsset("module02/tishi_version3", "TishiPanel_Version3", self.ShowTishiMessage); 
     self.ShowTishiMessage(HallScenPanel.Pool("TishiPanel_Version3"));
      else
        panel.gameObject:SetActive(true);
        self.AddClick();   
     end
    else
      table.insert(savemess,mes);
      table.sort(savemess,self.messSort);
   end
 
end

function PublicMessageBox.setLuaBeHavi(args)
    _luaBeHaviour = args;
    table.foreachi(saveBtn,function(i,v)
      if _luaBeHaviour then         
         _luaBeHaviour:AddClick(v.gameObject,self.close);   
       end
    end)
end

function PublicMessageBox.ShowTishiMessage(args)
    panel.layer =0;
    local oldbtn =  panel.transform:Find("btn").gameObject;
    oldbtn.gameObject:SetActive(false);
    self.AddClick();
end

function PublicMessageBox.AddClick()
   --[[if GameNextScenName == gameScenName.LOGON then
       _luaBeHaviour = LogonScenPanel.luaBehaviour;
    elseif GameNextScenName == gameScenName.HALL then
       _luaBeHaviour = HallScenPanel.transform:GetComponent('LuaBehaviour');
    else
       _luaBeHaviour = GameSetsBtnInfo._LuaBehaviour;
    end]]
   -- _luaBeHaviour:AddClick(panel.transform:Find("cont").gameObject,self.test);
    if panel then
        panel.gameObject:SetActive(true);
        panel.transform:Find("Text").gameObject:GetComponent("Text").text = curshowTabe["message"];          
        if #curshowTabe["btntab"] == 1 then
            self.creatbtn(curshowTabe["btntab"][1],0);
        else
            self.creatbtn(curshowTabe["btntab"][1],-130);
            self.creatbtn(curshowTabe["btntab"][2],167);
        end
    end
end
function PublicMessageBox.test(args)

end

function PublicMessageBox.creatbtn(btnanme,mx)
--error("______________"..btnanme);
   local oldbtn =  panel.transform:Find("btn").gameObject;
   local bt = newobject(oldbtn);
   bt.gameObject:SetActive(true);
   bt.name = btnanme;
   bt.transform:Find("Text").gameObject:GetComponent("Text").text = btnanme;
   bt.transform:SetParent(panel.transform);
   bt.transform.localPosition = Vector3.New(mx,-125,0);
    if _luaBeHaviour then    
       _luaBeHaviour:AddClick(bt.gameObject,self.close);   
    end
   table.insert(saveBtn,bt);
end
function PublicMessageBox.messSort(a,b)
  return a.level>b.level;
end

function PublicMessageBox.close(args)
--error("closeclosecloseclosecloseclosecloseclose");
  if curshowTabe["callfuntab"][args.name] then
     if curshowTabe["callfuntab"][args.name.."v"] then
         curshowTabe["callfuntab"][args.name](curshowTabe["callfuntab"][args.name.."v"]);
     else
        curshowTabe["callfuntab"][args.name]();
     end    
  end
  table.foreachi(saveBtn,function (i,v)
     destroy(v);
  end)
  saveBtn = {};
  if curshowTabe["delallmess"]==true then
    isshow = false;
    savemess = {};
  elseif #savemess>=1 then
    curshowTabe =  table.remove(savemess,1);
    self.AddClick();
  else
    panel.gameObject:SetActive(false);
    isshow = false;
  end
end