--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

MainPanel = {};

function MainPanel:Awake(obj)
	Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
	Screen.autorotateToLandscapeLeft = true;
	Screen.autorotateToLandscapeRight = true;
	Screen.autorotateToPortrait = false;
	Screen.autorotateToPortraitUpsideDown = false;
	local CS = obj.transform:Find("BaccaraPanel");
	logYellow("cs name  " .. CS.name)
	--CS = CS:GetComponent("CsJoinLua");
	CS = CS.gameObject:AddComponent(typeof(CsJoinLua))
	--logYellow("cs name2  " .. CS.name);
    CS:LoadLua("Module20/Game_Baccara/BaccaraPanel", "BaccaraPanel");
end
