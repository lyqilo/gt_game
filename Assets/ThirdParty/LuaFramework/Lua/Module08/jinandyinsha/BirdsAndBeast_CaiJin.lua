
--彩金界面
BirdsAndBeast_CaiJin = {};
local  self = BirdsAndBeast_CaiJin;

self.per = nil;
self.curtimer = 0;
self.iscount = false;
self.agetimer = 1;
self.messkey = "0";
function BirdsAndBeast_CaiJin.setPer(args)
    self.per = args;
    self.messkey = BirdsAndBeastEvent.guid(); 
    self.AddEvent();
end

function BirdsAndBeast_CaiJin.destroying()
   self.per = nil;
   self.curtimer = 0;
   self.iscount = false;
   self.agetimer = 1;
   self.messkey = "0";
end

function BirdsAndBeast_CaiJin.startCont()
   self.iscount=true;  
end
function BirdsAndBeast_CaiJin.stopCont()
   self.iscount=false;
   self.curtimer = 0;
    local va = BirdsAndBeast_GameData.pushmoney_data[BirdsAndBeastConfig.bab_jinsha];
    if va==0 then
        va = 9999;
    end
    self.shownum(va,BirdsAndBeast_GameData.caijinrate);
end
function BirdsAndBeast_CaiJin.shownum(args,rate)
    if IsNil(self.per) then 
        return;
    end
    if (args == nil) then args = 10 end
   self.CreatShowNum(self.per.transform:Find("numcont"), args * rate,"num");
end


function BirdsAndBeast_CaiJin.upDate()
    if self.iscount==false then
       return false;
    end
     self.curtimer =  self.curtimer + Time.deltaTime;
    if self.curtimer > self.agetimer then
       self.curtimer = self.curtimer - self.agetimer;
       local va = BirdsAndBeast_GameData.pushmoney_data[BirdsAndBeastConfig.bab_jinsha];
       if va==0 or va==nil then
          va = 9999;
       end
       self.shownum(va,math.random(10,99));
    end
end

function BirdsAndBeast_CaiJin.AddEvent()
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startchip,self.startCont,self.messkey);
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.gamestatechang,self.gamestatechang,self.messkey);
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame,self.exitgame,self.messkey);
end

function BirdsAndBeast_CaiJin.exitgame(args)
   self.destroying();
end

function BirdsAndBeast_CaiJin.gamestatechang()
   if BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.D_GAME_STATE_CHIP then
       self.iscount=true;  
   end
end

function BirdsAndBeast_CaiJin.RemoveEvent()
end

-- 创建数字Img显示对象
function BirdsAndBeast_CaiJin.CreatShowNum(father, numstr,numpathstr)    
   -- numstr = unitPublic.showNumberText2(tonumber(numstr)); 
    --error("___CreatShowNum___"..numstr); 
    if IsNil(father) then
       return;
    end
    local splen =  father.transform.childCount;
    local numlen = string.len(numstr);
    --local alen =  math.max(0,splen-numlen);
    if splen > numlen then
        for j =numlen , splen-1 do
            --destroy(father.transform:GetChild(j).gameObject);
            father.transform:GetChild(j).gameObject:SetActive(false);
        end
    end
    local klx = 0;
    local kw = 0;
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i);
        prefebnum = self.repaceNum(prefebnum);
        if kw ~= 0 then
            klx = kw;
        end
        if prefebnum == 10 then
            --klx = klx - 8;
            kw = kw + 14;
        else
            kw = kw + 42;
        end
        if splen < i then
            local go2 = newobject(BirdsAndBeast_GameData.iconres.transform:Find(numpathstr.."_"..prefebnum).gameObject);
            go2.transform:SetParent(father.transform);
            go2.transform.localScale = Vector3.New(1,1,1);
            go2.transform.localPosition = Vector3.New(klx, 0, 0);
            go2.name = prefebnum;
        else
            -- if tonumber(prefebnum) ~= tonumber(father.transform:GetChild(i - 1).gameObject.name) then
            local itemobj = father.transform:GetChild(i-1).gameObject;
            itemobj:SetActive(true);
            itemobj.name = prefebnum;
            --itemobj.transform.localPosition = Vector3.New(klx, 0, 0);
            itemobj:GetComponent('Image').sprite = BirdsAndBeast_GameData.iconres.transform:Find(numpathstr.."_"..prefebnum).gameObject:GetComponent('Image').sprite;
            itemobj:GetComponent('Image'):SetNativeSize();
            -- end
        end
    end
    local sy = father.transform.localPosition.y;
    father.transform.localPosition = Vector3.New(160-kw*0.45,sy,0);
end

function BirdsAndBeast_CaiJin.repaceNum(args)
    if args == "." then
        return 10;
    elseif args == "w" then
        return 11;
    elseif args == "y" then
        return 12;
    end
    return args;
end