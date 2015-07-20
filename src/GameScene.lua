local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

--创建场景
function GameScene.create()
    local scene = GameScene.new()
    return scene
end

--安全过度场景
function GameScene:gotoScene()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(GameScene.create())
    else
        cc.Director:getInstance():runWithScene(GameScene.create())
    end
end

--构造方法
function GameScene:ctor()
    self.draw = nil             --初始化绘制节点
    self.ScheldID = nil         --定时器ID
    self.isTouch = false        --可视为定时器开关  当触摸时 开启 否则关闭
    self.LineLong = 0          -- 桥的起始长度
    self.LineSpeed = 5              --桥的增长速度
    self.isRotating = false         --旋转动画控制器
    self.StartPoint = cc.p(0,0)
    self:init()
    
    --text
    self.layerout = nil
end

--初始化界面
function GameScene:init()
    
    
    self.layerout = ccui.Layout:create()
    self.layerout:setBackGroundColor(cc.c3b(1,1,1))
    self.layerout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    self.layerout:setContentSize(cc.size(500,900))
    self.layerout:setPosition(cc.p(50,400))
    self:addChild(self.layerout)

    self.draw = cc.DrawNode:create()
    self.layerout:addChild(self.draw)

    --绑定触摸时间
    local function onTouchBegan(touch, event)
        self.isTouch = true;
        self:LongChange();
        print("dfgfdg"..touch:getLocation().y)
        return true
    end
    local function onTouchMoved(touch, event)
    end
    local function onTouchEnded(touch, event)
        if self.ScheldID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.ScheldID)
            self.ScheldID = nil
        end
        self.isTouch = false     
        self.LineLong = 0
        self:LineRotation()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameScene:LineRotation()
--    self.isRotating = true
    self.draw:runAction(cc.Spawn:create(cc.RotateTo:create(1,90),cc.ScaleBy:create(1,0.5)))
--self.draw:setRotation(90)
end

--桥长度更新函数
function GameScene:LongChange()
    if self.ScheldID ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.ScheldID)
        self.ScheldID = nil
    end
    local function updataLine()
        if self.isTouch == true and self.isRotating == false then
            if self.draw ~= nil then
                self.draw:clear()
            end
            self.LineLong = self.LineLong + self.LineSpeed
            self.draw:drawSegment(self.StartPoint,cc.p(0,self.LineLong),2,cc.c4b(1,1,1,1.0))
            print(self.LineLong)
        end
    end
    self.ScheldID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updataLine, 1/60, false)
end


return GameScene
