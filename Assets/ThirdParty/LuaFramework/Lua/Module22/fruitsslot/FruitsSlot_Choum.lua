FruitsSlot_Choum = {}
local self = FruitsSlot_Choum

self.per = nil
--self.itemcont = nil;
self.selectbtn = nil
self.selectchoumnumcont = nil

self.ischoumMove = false
self.choumSpos = nil
self.choumEpos = nil

--self.jiantup = nil;
--self.jiantdown = nil;

--self.closebtn = nil;

self.choumnum = 0
self.curchomindex = 1
self.numtext = nil

function FruitsSlot_Choum.setPer(args, mypush)
   self.per = args
   self.mypush = mypush
   --self.itemcont = self.per.transform:Find("itemcont/itemcontsp/cont");
   self.selectbtn = self.per.transform:Find("btncont")
   self.selectchoumnumcont = self.per.transform:Find("btncont/numcont")
   self.selectchoumnumcont.localPosition = Vector3.New(200, 3, 0)
   --   self.jiantup = self.per.transform:Find("jiantup");
   --   self.jiantdown = self.per.transform:Find("jiantdown");
   --   self.closebtn = self.per.transform:Find("itemcont/closebtn");
   --   self.jiantdown.gameObject:SetActive(false);
   --   self.closebtn.gameObject:SetActive(false);
   self.addEvent()
   --   local pos = self.itemcont.transform.localPosition;
   --   self.choumSpos = Vector3.New(pos.x,pos.y,pos.z);
   --   self.choumEpos = Vector3.New(pos.x,pos.y+328,pos.z);
end

function FruitsSlot_Choum.addEvent()
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_init, self.gameInit)
   FruitsSlot_Data.luabe:AddClick(self.selectbtn.gameObject, self.selectChoumHander)
   --   FruitsSlot_Data.luabe:AddClick(self.closebtn.gameObject,self.selectHander);
   --    for i=1,4 do
   --       FruitsSlot_Data.luabe:AddClick(self.itemcont.transform:Find("item_"..(i-1).."/btn").gameObject,self.itemSelectHander);
   --   end
end

function FruitsSlot_Choum.removeEvent()
end

function FruitsSlot_Choum.selectChoumHander(args)
   if FruitsSlot_Data.byFreeCnt > 0 then
      return
   end
   FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false)
   self.curchomindex = self.curchomindex + 1
   if self.curchomindex > self.choumnum then
      self.curchomindex = 1
   end
   FruitsSlot_Data.curSelectChoum = FruitsSlot_Data.choumtable[self.curchomindex]
   error(FruitsSlot_Data.curSelectChoum)
   FruitsSlot_PushFun.CreatShowNum(
      self.selectbtn.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum,
      "allpush_",
      true,
      21,
      true,
      120,
      -55
   )
   FruitsSlot_PushFun.CreatShowNum(
      self.mypush.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
      "my_gold_",
      false,
      25,
      true,
      180,
      -43
   )
   self.selectbtn.transform:Find("numcont").localPosition = Vector3.New(25, 3, 0)
end

function FruitsSlot_Choum.selectHander(args)
   --error("____selectHanderselectHander__");
   if self.ischoumMove == true then
      return
   end

   FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false)
   self.ischoumMove = true
   local pos = nil
   if self.itemcont.transform.localPosition.y > -150 then
      pos = self.choumSpos
      self.jiantdown.gameObject:SetActive(false)
      self.jiantup.gameObject:SetActive(true)
      self.closebtn.gameObject:SetActive(false)
   else
      pos = self.choumEpos
      self.jiantdown.gameObject:SetActive(true)
      self.jiantup.gameObject:SetActive(false)
      self.closebtn.gameObject:SetActive(true)
   end
   local tween = self.itemcont.transform:DOLocalMove(pos, 0.5, false)
   tween:OnComplete(
      function(args)
         self.ischoumMove = false
      end
   )
end

function FruitsSlot_Choum.chouMove(args)
end

function FruitsSlot_Choum.itemSelectHander(args)
   if FruitsSlot_Data.byFreeCnt > 0 then
      return
   end
   FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false)
   FruitsSlot_Data.curSelectChoum = tonumber(args.transform.name)
   error(FruitsSlot_Data.curSelectChoum)
   FruitsSlot_PushFun.CreatShowNum(
      self.selectbtn.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum,
      "allpush_",
      true,
      21,
      true,
      120,
      -55
   )
   FruitsSlot_PushFun.CreatShowNum(
      self.mypush.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
      "my_gold_",
      false,
      25,
      true,
      180,
      -43
   )
   self.selectHander()
   self.selectbtn.transform:Find("numcont").localPosition = Vector3.New(25, 3, 0)
end

function FruitsSlot_Choum.gameInit(args)
   --error("_________gameInit_________");
   --   for i=1,4 do
   --       self.itemcont.transform:Find("item_"..(i-1).."/btn").transform.name = FruitsSlot_Data.choumtable[i];
   --       FruitsSlot_PushFun.CreatShowNum(self.itemcont.transform:Find("item_"..(i-1).."/numcont"),FruitsSlot_Data.choumtable[i],"allpush_",true,38,true,150,-65);
   --   end
   self.choumnum = #FruitsSlot_Data.choumtable
   self.curchomindex = 1
   for i = 1, self.choumnum do
      if FruitsSlot_Data.choumtable[i] == FruitsSlot_Data.curSelectChoum then
         self.curchomindex = i
      end
   end
   FruitsSlot_PushFun.CreatShowNum(
      self.selectbtn.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum,
      "allpush_",
      true,
      21,
      true,
      120,
      -55
   )

   FruitsSlot_PushFun.CreatShowNum(
      self.mypush.transform:Find("numcont"),
      FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
      "my_gold_",
      false,
      25,
      true,
      180,
      -43
   )
   self.selectbtn.transform:Find("numcont").localPosition = Vector3.New(25, 3, 0)

end
