local transform;
local gameObject;

 SetGameObjectLenght={};
 local self=SetGameObjectLenght;
 function SetGameObjectLenght.Awake(obj)
 gameObject=obj;
 transform=obj.transform;
 log("Awake lua----->>"..gameObject.name);
 end
 --设置滑动界面长度
 function SetGameObjectLenght.SetLenght(cellSize,spacing,pos)
  childNum=transform:childCount() ;
  if pos==0 then transform.width=(cellSize+spacing)*childNum+spacing;end
  
 end
