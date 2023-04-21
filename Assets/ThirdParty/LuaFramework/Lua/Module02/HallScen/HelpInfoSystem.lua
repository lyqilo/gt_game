--[[require "Common/define"
require "Data/gameData"
require "System/Color"]]
HelpInfoSystem={ }
local self=HelpInfoSystem;
local StopBtn=nil;
local nowLuaBeHaviour=nil;
-- ===========================================帮助面板信息系统======================================
function HelpInfoSystem.Open()
    if self.HelpInfoPanel == nil then
        self.HelpInfoPanel = "obj";
        
     -- ResManager:LoadAsset("hall_help", "HelpInfoPanel", self.OnCreacterChildPanel_Help);
      --LoadAssetAsync("module02/hall_help", "HelpInfoPanel", self.OnCreacterChildPanel_Help);
     self.OnCreacterChildPanel_Help(HallScenPanel.Pool("HelpInfoPanel"));
    end
end

-- 创建UI的子面板_帮助
function HelpInfoSystem.OnCreacterChildPanel_Help(prefab)
local go =prefab;
  --  local go =newobject(prefab);
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "HelpInfoPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(0.1, 0.1, 0.1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.HelpInfoPanel = go;
    HelpInfoSystem.Init(self.HelpInfoPanel, HallScenPanel.LuaBehaviour);
  --  self.HelpInfoPanel:SetActive(false);
    HelpInfoSystem.ShowPanel(self.HelpInfoPanel);
    go = nil;
   -- self.HelpBtn:GetComponent('Button').interactable = true;
  --  self.HelpBtn:GetComponent('Button'):Select();
end

function HelpInfoSystem.Init(obj,LuaBeHaviour)
nowLuaBeHaviour=LuaBeHaviour;
local t=obj.transform;
self.HelpInfoPanel=obj;
--初始化面板，绑定点击事件
self.HelpInfoPanelCloseBtn=t:Find("HelpInfoPanelCloseBtn").gameObject;

self.LeftBtnMain=t:Find("Bg/LeftBg/LeftMainInfo").gameObject;

self.LeftBtnjbcz=t:Find("jbcz").gameObject;

self.RightContent=t:Find("Bg/HelpMainBg/RightMainInfo/HelpContent").gameObject:GetComponent('Text');

self.RightWH=t:Find("Bg/HelpMainBg/RightMainInfo/HelpContent").gameObject;

self.by3dImg=t:Find("Bg/HelpMainBg/RightMainInfo/HelpContent/by3d").gameObject;

self.lkpyImg=t:Find("Bg/HelpMainBg/RightMainInfo/HelpContent/lkpy").gameObject;

self.shzImg=t:Find("Bg/HelpMainBg/RightMainInfo/HelpContent/shz").gameObject;
self.by3dImg:SetActive(false);

self.lkpyImg:SetActive(false);

self.shzImg:SetActive(false);

self.CreatNewHelpBtn();

self.HelpMainBg=t:Find("Bg/HelpMainBg").gameObject;
self.leftBg=t:Find("Bg/LeftBg").gameObject;
--绑定点击事件
LuaBeHaviour:AddClick(self.HelpInfoPanelCloseBtn,self.HelpInfoPanelCloseBtnOnClick);
end
----隐藏和显示一个transform
function HelpInfoSystem.ShowPanel(g, isShow)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0);
        --  效果测试代码
       HallScenPanel.SetXiaoGuo(g)
    else
        t.localPosition = Vector3.New(0, 1000, 0);
    end
    if self.LeftBtnjbcz.activeSelf then
    else
        self.LeftBtnMain:GetComponent('RectTransform').sizeDelta = Vector2.New(132, 433);
    end
end
-- 关闭帮助界面按钮
function HelpInfoSystem.HelpInfoPanelCloseBtnOnClick()
    self.ShowPanel(self.HelpInfoPanel);
    HallScenPanel.PlayeBtnMusic();
    StopBtn = nil;
    -- 恢复被禁用的状态
    
    if (nowLuaBeHaviour ~= GameSetsBtnInfo._LuaBehaviour) then
        destroy(self.HelpInfoPanel);
        self.HelpInfoPanel = nil;
    else
        destroy(self.HelpInfoPanel);
        self.HelpInfoPanel = nil;
    end
end

--点击基本操作按钮
function HelpInfoSystem.LeftBtnjbczOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
if StopBtn==nil  then self.SetText(arg,nil);
else
self.SetText(arg,StopBtn);
end 
 local maintext="\n左右滑动屏幕可以挑选喜爱的游戏，点击任意可选游戏桌子或机器，进入适合的房间即可开始游戏。\n点击其他功能按钮跳转相应界面。\n大厅上方的功能按钮可以隐藏。";
self.RightContent.text=tostring(maintext);
self.RightWH.transform.localPosition=Vector3.New(12,-226,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end
--点击充值按钮 
function HelpInfoSystem.LeftBtnczOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
local maintext="\n点击大厅正下方的买币按钮。\n选择买币额度。\n跳转APPstore确认支付。\n完成买币。"
self.RightContent.text=tostring(maintext);
self.RightWH.transform.localPosition=Vector3.New(12,-226,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 550);
end

--点击3D捕鱼按钮 
function HelpInfoSystem.LeftBtnby3dOnClick(arg)
self.by3dImg:SetActive(true);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring(" ");
self.RightWH.transform.localPosition=Vector3.New(12,-226,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 900);
end

--点击百家乐按钮  
function HelpInfoSystem.LeftBtnbjlOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n <b>1.基本玩法</b>\n1.百家乐游戏分为庄、闲、和与庄天王、闲天王这五门。这里庄、闲没有具体的含义。\n2.本游戏使用8副，每副52张纸牌，洗在一起，至于发牌盒子当中，由系统发牌。力争自己所压中的赌注。系统会发两部分牌，每张牌面总点数为9或者接近9来进行比较，其中K、Q、J和10都记为0.其他牌面按照合来计点。<color=#ff0000ff>（其中牌面点数相加为10，则都记为0）</color>\n<b>2．赌注面赔率</b>\n庄赔率：1:2\n闲赔率：1:2\n和赔率：1:9\n庄天王：1:3\n闲天王：1:3\n<b>3.上庄规则</b>\n1、玩家点击“上庄”按钮之后，在身上金币足够1200万的情况下成为庄家。\n2、每个玩家可以坐庄10局，局数到了之后玩家自动下庄。\n3、玩家在坐庄时如果身上的金币数量不足1200万筹码时则自动下庄。");
self.RightWH.transform.localPosition=Vector3.New(12,-490,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 1000);
end

--点击21点按钮 
function HelpInfoSystem.LeftBtnd21OnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring( "\n采用经典的维加斯5人21点牌桌进行游戏,游戏共有八副牌。\n首先进行下分操作，点击筹码选择你要下的分数，可以多次点击某个筹码下更多的分数。\n系统会给每位玩家发两张牌，并给自己发明暗各一张牌。\n发完牌后玩家依次进行要牌阶段。\n在要牌阶段中，可以选择“要牌”“加倍”“分牌”“停牌”“投降”5个操作。\n要牌：再让系统发一张牌。\n加倍：再下和当前等量分，并要一张牌后结束要牌，等待结算。\n分牌：获得两张同样的牌可以分牌，再下当前等量分数。分牌后可以对两墩同样的牌分别进行要牌操作。\n停牌：保留当前分数并等待结算。\n投降：弃掉手上牌，输当前一半的分数。\n请注意，在要牌阶段，若牌面最小值大于21，则爆牌，直接判负。\n21点黑杰克为最大，如果庄家和玩家都是黑杰克则算是平。如果庄家是普通21点，玩家是黑杰克则玩家赢。反之亦然。");
self.RightWH.transform.localPosition=Vector3.New(12,-226,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 750);
end

--点击李逵劈鱼按钮 
function HelpInfoSystem.LeftBtnlkpyOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(true);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring( " ");
self.RightWH.transform.localPosition=Vector3.New(12,-490,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 685);
end

--点击斗地主按钮 
function HelpInfoSystem.LeftBtnddzOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n<b>1.整体规则</b>\n采用最常见的三人大众斗地主游戏模式。\n准备完成后开始发牌，每人17张。\n随机玩家开始叫分，叫分1-3分，叫得地主的玩家获得底牌三张牌并展示。\n若无人叫分，则重新发牌。\n最先出完牌的一方获胜。\n<b>2.牌型规则</b>\n火箭最大，可以打任意其他的牌。\n    炸弹比火箭小，比其他牌大。都是炸弹时按牌的分值比大小。\n除火箭和炸弹外，其他牌必须要牌型相同且总张数相同才能比大小。\n单牌大小，大王>小王 >2>A>K>Q>J>10>9>8>7>6>5>4>3 ，不分花色。\n对牌、三张牌都按分值比大小。\n顺牌按最大的一张牌的分值来比大小。\n飞机带翅膀和四带二按其中的三顺和四张部分来比，带的牌影响不大。");
self.RightWH.transform.localPosition=Vector3.New(12,-226,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 820);
end

--点击水浒传按钮 
function HelpInfoSystem.LeftBtnshzOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(true);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n<b>1.连线中奖说明：</b>\n1.连续的图案必须与两侧相连，仅仅是中间的三个图案相同并不得分。\n2.可以点击压线按钮查看连线分布。\n3．若水浒传图案可以计算两边的分数，只获得最大的一边的分数。\n<b>2.筛子玩法说明：</b>\n1.玩家有一次连线成功之后即可进行猜骰子游戏。连线成功之后点击下方的“比倍”按钮进入比倍界面。\n2.玩家可以选择“大、和、小”三种进行下注，大2倍（对子4倍），和6倍，小2倍（对子4倍），若玩家猜中，则获得相应倍数的分，猜错则全部分数归零，比倍结束。\n<b>小玛丽规则：</b>\n1、玩家在水浒转的老虎机上转动时出现三条龙连线时就自动进入小玛丽界面。\n2、小玛丽为转盘游戏，玩家进入的时候自动开始转动，外围图案与中央翻滚图案一致时，可获得该图案的相应奖励。\n中央翻滚图案4个相同时，则获得3600倍奖励。\n中央翻滚图案3个相同时，则获得180倍奖。\n");
self.RightWH.transform.localPosition=Vector3.New(12,-390,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 1180);
end

--点击免费金币按钮 
function HelpInfoSystem.LeftBtnmfjbOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
 self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n<b> 1.五星好评拿大奖</b>\n点击“客服按钮”或点击相应任务的“前去查看”。\n打开手机QQ。\n给《"..UnityEngine.Application.productName .."》五星好评。\n将截图发给客服，则可获得奖励。\n奖励只能获得一次哦。\n<b>2.下载资源赢好礼</b>\n点击“前去查看”按钮。\n下载任一游戏资源包。\n直接获得游戏奖励。\n<b>3.绑定手机得金币</b>\n通过账户管理界面绑定手机号，可以直接获得一次性的金币奖励。\n<b>4.加客服领金币</b>\n点击“前去查看”按钮跳转至交流区。\n添加本游戏的官方QQ号。\n或者扫描我们官方的二维码信息。\n即可获取我们的最新游戏信息，以及与我们客服进行交流。\n<b>5.上传头像领奖励</b>\n点击游戏大厅左下角玩家头像转至个人信息界面。\n在个人信息界面只要点击玩家头像即可进入修改头像界面。\n在头像修改界面上传玩家新头像。\n成功上传并更改新头像，获取奖励。\n<b>6.首次更名赢金币</b>\n点击“前去查看”按钮跳转至个人信息界面。\n在个人信息界面首先需要修改密码。才能弹出修改昵称按钮。\n在个人信息界面点击“修改昵称”按钮。\n进入修改昵称界面，然后修改自己的昵称。\n成功更改新昵称，获取奖励\n<b>7、分享得奖励</b>\n点击“分享”按钮进入分享界面。\n在分享界面中点击“分享按钮”即可将游戏分享到QQ或者微信朋友圈。\n分享过本游戏之后每天上线即可领取金币和奖券。\n<b>8．对战赠奖券</b>\n进入游戏大厅界面，随意选择应游戏桌子图标点击进入游戏参与对战即可获得不同数额的奖券。\n点击“免费金币”按钮进入免费金币界面。\n点击“前去查看”被系统安排进入随机游戏。\n在游戏中对战即可获得不同数额的奖券。\n<b>9、每日抽奖</b>\n玩家每日登录游戏之后，即可在免费抽奖界面点击，免费抽奖按钮，抽取奖励。每日抽奖每天只能抽取一次。\n如果玩家在进入游戏的时候不小心关闭了每日抽奖界面。那么可以在界面中点开就可以看到每日抽奖项了。");
self.RightWH.transform.localPosition=Vector3.New(12,-850,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 2100);
end

--点击聚宝盆按钮 
function HelpInfoSystem.LeftBtnjbpOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n赠送币提供了玩家快速获取奖券和赠送礼物的功能。\n在获取奖券页面，选择金币额度进行兑换奖券，可以快速获取奖券。\n赠送币页面输入目标用户ID和金币数量，可以赠送礼物给目标用户。\n需要注意的是，送币数量不得低于"..SCSystemInfo._7dwPresentMinGold.."金币，并且普通账户不能进行送币操作。");
self.RightWH.transform.localPosition=Vector3.New(12,-675,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end
--点击帐号管理按钮 
function HelpInfoSystem.LeftBtnzhglOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n<b>1.修改密码</b> \n点击游戏大厅左下角的玩家头像。\n进入玩家信息界面，点击“修改密码”按钮。\n进入修改密码界面，输入新密码。\n点击确认完成修改。\n<b>2.修改昵称</b> \n点击游戏大厅左下角的玩家头像。\n进入玩家信息界面，点击“修改昵称”按钮。\n进入修改昵称界面，输入新昵称。\n[可选]改变您展示的性别。\n点击确认完成修改。\n<b>3.绑定手机</b> \n进入玩家个人信息界面。\n首先修改您的游戏登录密码。\n输入您的手机号码。\n点击获取验证码。\n输入您收到的短信中的验证码。\n点击确认完成绑定。\n请注意，部分时间段由于电信运营商负载较大，您可能会在一段时间后才收到短信，请稍等片刻并点击再次获取。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 1000);
end


--点击商城按钮 
function HelpInfoSystem.LeftBtnscOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n请首先确认您的奖券数量是否足够，若不足，可以到赠送币中快速获取，或参与游戏获取。 \n点击兑换按钮。\n根据提示输入个人信息。\n点击确定按钮。\n添加客服好友进行信息确认。\n根据客服提示获取兑换物品。\n");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end



--点击排行榜按钮 
function HelpInfoSystem.LeftBtnphbOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n1、点击“富豪榜”按钮进入富豪榜界面，玩家左右滑动屏幕可以旋转中央舞台，点击任意玩家即可查看其当前的个人信息。\n2、富豪榜只显示排名前五十的玩家，玩家每次从新进入富豪榜界面刷新一次。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end


--点击交流按钮 
function HelpInfoSystem.LeftBtnjlOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n玩家进入游戏交流区。添加本游戏的官方QQ号或者官方微信帐号。即可获取我们的最新游戏信息，以及与我们客服进行交流。\n玩家扫描我们官方的二维码信息即可添加本有的官方微信帐号。获取我们的最新游戏信息，以及与我们客服进行交流。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end


--点击设置按钮 
function HelpInfoSystem.LeftBtnszOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n玩家进入设置界面，可以对本游戏的画质以及背景音乐进行调试，已达到最佳的游戏体验性。\n玩家如果想要替换帐号，只需要点击“注销帐号”即刻退出游戏回到游戏登录界面。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end

--点击分享按钮 
function HelpInfoSystem.LeftBtnfxOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n点击“分享”按钮进入分享界面。\n在分享界面中点击“分享按钮”即可将游戏分享到QQ或者微信朋友圈。\n分享过本游戏之后每天上线即可领取金币和奖券。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end

--点击救济金 
function HelpInfoSystem.LeftBtnjjjOnClick(arg)
self.by3dImg:SetActive(false);
self.lkpyImg:SetActive(false);
self.shzImg:SetActive(false);
self.SetText(arg,StopBtn);
self.RightContent.text=tostring("\n玩家每日金币数量在低于2千的情况下，系统会每日赠送三次金币。\n玩家进入免费金币界面，点选补偿系统的“领取礼物“按钮查看领取奖励。每次可以领取5千金币。每天只能够领取四次。\n领取金币有CD时间，第一次领取后，CD时间为5分钟，第二次领取后，CD时间为30分钟，第三次领取后，CD时间为1小时。救济金每天6:00刷新领取次数。");
self.RightWH.transform.localPosition=Vector3.New(12,-615,0);
self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, 400);
end


function HelpInfoSystem.CreatBtn()

end

--点击牛牛
function HelpInfoSystem.LeftBtnNNOnClick(arg)
end

--点击财神

--点击龙珠

--点击奔驰宝马



function HelpInfoSystem.SetText(args, args1)
    HallScenPanel.PlayeBtnMusic();
    args:GetComponent('Button').interactable = false;
    args.transform:Find("PressText").gameObject:SetActive(true);
    args.transform:Find("Text").gameObject:SetActive(false);
    if StopBtn ~= nil then
        args1:GetComponent('Button').interactable = true;
        args1.transform:Find("PressText").gameObject:SetActive(false);
        args1.transform:Find("Text").gameObject:SetActive(true);
    end
    StopBtn = args;
end

--基本操作 充值 3D捕鱼 百家乐 21点 李逵劈鱼 斗地主 水浒传 免费金币 聚宝盆 帐号管理 商城 排行榜 交流 设置 分享 救济金
local helpBtnName = {
    [1] = "基本操作",
    [2] = "充    值",
    [3] = "免费金币",
    [4] = "聚 宝 盆",
    [5] = "帐号管理",
    [6] = "商    城",
    [7] = "排 行 榜",
    [8] = "交    流",
    [9] = "设    置",
    [10] = "分    享",
    [11]="救 济 金",
}

local helpBtnContent = {
    [1] = "\n左右滑动屏幕可以挑选喜爱的游戏，点击任意可选游戏桌子或机器，进入适合的房间即可开始游戏。\n点击其他功能按钮跳转相应界面。\n大厅上方的功能按钮可以隐藏。",
    [2] = "\n点击大厅正下方的买币按钮。\n选择买币额度。\n跳转APPstore确认支付。\n完成买币。",
   
    [3] = "\n<b> 1.五星好评拿大奖</b>\n点击“客服按钮”或点击相应任务的“前去查看”。\n打开手机QQ。\n给《" .. UnityEngine.Application.productName .. "》五星好评。\n将截图发给客服，则可获得奖励。\n奖励只能获得一次哦。\n<b>2.下载资源赢好礼</b>\n点击“前去查看”按钮。\n下载任一游戏资源包。\n直接获得游戏奖励。\n<b>3.绑定手机得金币</b>\n通过账户管理界面绑定手机号，可以直接获得一次性的金币奖励。\n<b>4.加客服领金币</b>\n点击“前去查看”按钮跳转至交流区。\n添加本游戏的官方QQ号。\n或者扫描我们官方的二维码信息。\n即可获取我们的最新游戏信息，以及与我们客服进行交流。\n<b>5.上传头像领奖励</b>\n点击游戏大厅左下角玩家头像转至个人信息界面。\n在个人信息界面只要点击玩家头像即可进入修改头像界面。\n在头像修改界面上传玩家新头像。\n成功上传并更改新头像，获取奖励。\n<b>6.首次更名赢金币</b>\n点击“前去查看”按钮跳转至个人信息界面。\n在个人信息界面首先需要修改密码。才能弹出修改昵称按钮。\n在个人信息界面点击“修改昵称”按钮。\n进入修改昵称界面，然后修改自己的昵称。\n成功更改新昵称，获取奖励\n<b>7、分享得奖励</b>\n点击“分享”按钮进入分享界面。\n在分享界面中点击“分享按钮”即可将游戏分享到QQ或者微信朋友圈。\n分享过本游戏之后每天上线即可领取金币和奖券。\n<b>8．对战赠奖券</b>\n进入游戏大厅界面，随意选择应游戏桌子图标点击进入游戏参与对战即可获得不同数额的奖券。\n点击“免费金币”按钮进入免费金币界面。\n点击“前去查看”被系统安排进入随机游戏。\n在游戏中对战即可获得不同数额的奖券。\n<b>9、每日抽奖</b>\n玩家每日登录游戏之后，即可在免费抽奖界面点击，免费抽奖按钮，抽取奖励。每日抽奖每天只能抽取一次。\n如果玩家在进入游戏的时候不小心关闭了每日抽奖界面。那么可以在界面中点开就可以看到每日抽奖项了。",
    [4] = "\n赠送币提供了玩家快速获取奖券和赠送礼物的功能。\n在获取奖券页面，选择金币额度进行兑换奖券，可以快速获取奖券。\n赠送币页面输入目标用户ID和金币数量，可以赠送礼物给目标用户。\n需要注意的是，送币数量不得低于" .. SCSystemInfo._7dwPresentMinGold .. "金币，并且普通账户不能进行送币操作。",
    [5] = "\n<b>1.修改密码</b> \n点击游戏大厅左下角的玩家头像。\n进入玩家信息界面，点击“修改密码”按钮。\n进入修改密码界面，输入新密码。\n点击确认完成修改。\n<b>2.修改昵称</b> \n点击游戏大厅左下角的玩家头像。\n进入玩家信息界面，点击“修改昵称”按钮。\n进入修改昵称界面，输入新昵称。\n[可选]改变您展示的性别。\n点击确认完成修改。\n<b>3.绑定手机</b> \n进入玩家个人信息界面。\n首先修改您的游戏登录密码。\n输入您的手机号码。\n点击获取验证码。\n输入您收到的短信中的验证码。\n点击确认完成绑定。\n请注意，部分时间段由于电信运营商负载较大，您可能会在一段时间后才收到短信，请稍等片刻并点击再次获取。",
    [6] = "\n请首先确认您的奖券数量是否足够，若不足，可以到赠送币中快速获取，或参与游戏获取。 \n点击兑换按钮。\n根据提示输入个人信息。\n点击确定按钮。\n添加客服好友进行信息确认。\n根据客服提示获取兑换物品。\n",
    [7] = "\n1、点击“富豪榜”按钮进入富豪榜界面，玩家左右滑动屏幕可以旋转中央舞台，点击任意玩家即可查看其当前的个人信息。\n2、富豪榜只显示排名前五十的玩家，玩家每次从新进入富豪榜界面刷新一次。",
    [8] = "\n玩家进入游戏交流区。添加本游戏的官方QQ号或者官方微信帐号。即可获取我们的最新游戏信息，以及与我们客服进行交流。\n玩家扫描我们官方的二维码信息即可添加本有的官方微信帐号。获取我们的最新游戏信息，以及与我们客服进行交流。",
    [9] = "\n玩家进入设置界面，可以对本游戏的画质以及背景音乐进行调试，已达到最佳的游戏体验性。\n玩家如果想要替换帐号，只需要点击“注销帐号”即刻退出游戏回到游戏登录界面。",
    [10] = "\n点击“分享”按钮进入分享界面。\n在分享界面中点击“分享按钮”即可将游戏分享到QQ或者微信朋友圈。\n分享过本游戏之后每天上线即可领取金币和奖券。",
    [11] = "\n玩家每日金币数量在低于2千的情况下，系统会每日赠送三次金币。\n玩家进入免费金币界面，点选补偿系统的“领取礼物“按钮查看领取奖励。每次可以领取5千金币。每天只能够领取四次。\n领取金币有CD时间，第一次领取后，CD时间为5分钟，第二次领取后，CD时间为30分钟，第三次领取后，CD时间为1小时。救济金每天6:00刷新领取次数。",
--    [18] = "\n牛牛是一款非常简单轻松，节奏明快的牌类比拼游戏。\n每次开始游戏时，会在抢庄玩家中随机选出一名庄家，随后进行押注，每次押注都是根据玩家现有金币数量计算好的，可以选取特高中低四种金币量进行下注。\n下注完成后，每位玩家从同一副牌中获得五张牌，并进行分牌。\n在要牌阶段中，可以选择“要牌”“加倍”“分牌”“停牌”“投降”5个操作。\n分牌时，将牌分为3+2张，若任意三张之和用10取余均不为0，则记为无牛；其中3张之和用10取余为0，则记为有牛；剩下2张用10取余为几则记为牛几。特殊的，剩下两张用10取余为0，记为牛牛。\n玩家牛数越高则牌型越大，牛牛为最大，若牌型大小相同则根据点数比较，点数相同则按照花色比较，不会出现平局情况。\n",
--    [19] = "\n<b>一、功能介绍</b>\n<b>线数</b>：投注数，最多达5注。\n<b>单注点数</b>：每注押注的分数，根据场次等级不同最大投注与最小投注会相应发生变化。\n<b>确定</b>：为单次开始。\n<b>托管</b>：为自动开始，当余额不足时，自动取消托管。\n<b>二、关卡介绍</b>\n游戏过程分为3关，3关分别在4X4、5X5、6X6的方型区域内随机派发宝石，其中还包括一种特殊钻头。\n<b>三、消除规则</b>\n游戏在每一关随机派发相应数量的宝石，若有符合游戏规则的宝石组合，即可获得相应游戏点数。\n每次消除后，游戏会自动生成新的宝石组合，直至不再形成符合游戏规则的宝石组合 。\n消除过程中会先消除钻头，待游戏自动生成新的宝石组合，再继续消除宝石。\n相同宝石相连越多，则获得分数越多。\n<b>四、彩金</b>\n彩金越高，龙珠模式获得奖金越高。\n<b>五、龙珠模式</b>\n龙珠等级是通过消除获得的分数而增长，同时龙珠等级对应龙珠模式的龙珠数量。\n最小为1级，龙珠模式掉落龙珠为1颗，最大为5级，龙珠模式掉落龙珠为5颗。\n<b>六、进度存档</b>\n玩家若在游戏中途离开，将自动保存当前关卡进度，有效期为7天。\n若玩家更换游戏房间，则进度自动清空。\n",

--    [20] = "\n <b>1.基本玩法</b>\n1.游戏中共有27条连线，从左侧第一竖列开始，在某一条连线上出现3-5个相同图案（财神图案除外），即可获得相应的连线奖励：\n铜币X3 ：1倍\n铜币X4 ：3倍\n铜币X5 ：5倍\n银币X3 ：3倍\n银币X4 ：5倍\n银币X5 ：10倍\n金币X3 ：5倍\n金币X4 ：10倍\n金币X5 ：20倍\n小红包X3 ：10倍\n小红包X4 ：20倍\n小红包X5 ：30倍\n中红包X3 ：20倍\n中红包X4 ：30倍\n中红包X5 ：50倍\n大红包X3 ：30倍\n大红包X4 ：50倍\n大红包X5 ：100倍\n红包混合X3 ：5倍\n红包混合X4 ：10倍\n红包混合X5 ：20倍\n元宝混合X3 ：10倍\n元宝混合X4 ：20倍\n元宝混合X5 ：30倍\n银元宝X3 ：50倍\n银元宝X4 ：100倍\n银元宝X5 ：200倍\n金元宝X3 ：100倍\n金元宝X4 ：200倍\n金元宝X5 ：400倍\n<b>2.特殊奖励 </b>\n1、幸运银箱：可以与任意图案连成线。\n2、幸运金箱：可以与任意图案连成线，并且该条连线的奖励翻倍。\n3、金玉满堂：每次启动拉霸都有一定概率触发金玉满堂，出现金玉满堂时，拉霸的每一横排内必然是相同的图案。\n4、蓬荜生辉：每次启动拉霸都有一定概率触发蓬荜生辉，出现蓬荜生辉时，拉霸的第一竖列一定都是财神图案。\n5、财神降临：当拉霸内出现5个或5个以上财神图案时，即可引发财神降临。财神降临时，根据财神图案个数给与超高倍数的奖励，并且还会获得相应的免费启动次数。在免费启动的过程中，拉霸内出现任何个数的财神图案，都会获得高倍数奖励。\n6、超级彩金：当拉霸内15个图案全部为财神时，即获得超级彩金，超级彩金的数量不是固定的，会随机变化。\n",
--    [21] = "\n<b>1.整体规则</b>\n1.奔驰宝马游戏时网络比较流行的转盘游戏，玩家在游戏当中选择坐庄还是押注。\n2.游戏当中由一名玩家选择成为庄家以后，其余玩家将可以根据自己的判断进行下注。整个游戏共有12个下注区域。分别为：红色奔驰、绿色奔驰、黄色奔驰、红色宝马、绿色宝马、黄色宝马、红色奥迪、绿色奥迪、黄色奥迪、红色大众、绿色大众、黄色大众。\n3.玩家下注结束之后出现倒计时，然后光标开始转动，光标转动结束之后所停下的位置就代表此次游戏的开奖结构。\n<b>2.上庄规则</b>\n1.玩家点击“上庄”按钮之后，在身上金币满足上庄条件的情况下成为庄家。\n2.每个玩家可以坐庄10局，局数到了之后玩家自动下庄。\n3.玩家在坐庄时如果身上的金币数量不足赔偿当前玩家下注的筹码时则自动下庄。\n<b>3.奖励</b>\n1.大三元奖项，同一个车牌的三个颜色都中奖。\n2.大四喜奖项，同一个颜色的四个车牌都中奖。\n3.随机送车牌奖项，随机开出2-11个车牌作为最终结果。\n4.普通奖项，随机开出一个车牌作为最终结果。\n",

}

function HelpInfoSystem.CreatNewHelpBtn()
    for i = 1, #helpBtnName do
        local go = newobject(self.LeftBtnjbcz);
        go.transform:SetParent(self.LeftBtnMain.transform);
        go.name = helpBtnName[i];
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.transform:Find("Text"):GetComponent("Text").text = helpBtnName[i];
        go.transform:Find("PressText"):GetComponent("Text").text = helpBtnName[i];
        go.transform:Find("PressText").gameObject:SetActive(false);
        nowLuaBeHaviour:AddClick(go, self.OnClickNewBtn);
    end
    self.LeftBtnMain.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(132, 105 *(#helpBtnName));
    self.LeftBtnMain.transform.localPosition = Vector3.New(0, -(95 *(#helpBtnName))/2, 0);
end

function HelpInfoSystem.OnClickNewBtn(args)
    self.by3dImg:SetActive(false);
    self.lkpyImg:SetActive(false);
    self.shzImg:SetActive(false);
    self.SetText(args, StopBtn);
    local num = 18;
    for i = 1, #helpBtnName do
        if helpBtnName[i] == args.name then
            num = i;
        end
    end
    self.RightContent.text = tostring(helpBtnContent[num]);
    self.RightWH.transform.localPosition = Vector3.New(12, -1000, 0);
    local h = self.RightContent.preferredHeight
    self.RightWH:GetComponent('RectTransform').sizeDelta = Vector2.New(600, h);
end





