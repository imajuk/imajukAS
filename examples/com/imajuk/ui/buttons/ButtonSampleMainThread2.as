package com.imajuk.ui.buttons
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.Component;
    import com.bit101.components.Label;
    import com.bit101.components.Tab;
    import com.bit101.components.Window;
    import com.bit101.utils.MinimalConfigurator;
    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.behaviors.ColorlizeBehavior;
    import com.imajuk.behaviors.FrameStepBehavior;
    import com.imajuk.behaviors.ImageSwapBehavior;
    import com.imajuk.behaviors.MatrixBehavior;
    import com.imajuk.behaviors.TransparentBehavior;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;




    /**
     * @author shinyamaharu
     */
    public class ButtonSampleMainThread2 extends Thread
    {
        public static var behaviorNum : int;
        private var timeline : Sprite;
        private var button : IButton;

        public function ButtonSampleMainThread2(timeline : Sprite)
        {
            super();

            this.timeline = timeline;

            ColorBehavior;
            ColorlizeBehavior;
            TransparentBehavior;
            ImageSwapBehavior;
            MatrixBehavior;
            FrameStepBehavior;
        }

        override protected function run() : void
        {
            next(loadAssets);
        }

        private function loadAssets() : void
        {
            var a : IAssetLocation = new AssetLocation()
                .add(new URLRequest("asset.swf"), 
                    function(d : Sprite) : void
                    {
                        AppDomainRegistry.getInstance().resisterAppDomain(d);
                        button = AbstractButton.wrap(d.addChild(AssetFactory.create("$Asset0")));
                    }
                );

            var preloader : PreLoader = new PreLoader();
            var t : Thread = new PreLoaderThread(preloader, a);
            t.start();
            t.join();

            next(buildUI);
        }

        private function buildUI() : void
        {
            Component.initStage(timeline.stage);
            
            var xml:XML = 
                <comps>
                    <Window id="preview" x="10" y="10" width="150" height="150" title="PREVIEW">
                        <HBox>
                            <CheckBox id="selectable" label="selectable" />
                            <Label id="status" text="selected: false" y="-4" />
                        </HBox>
                        <CheckBox id="toggle" label="toggle" y="13"/>
                        <CheckBox id="enebled" label="enebled" selected="true" y="25"/>
                    </Window>
                </comps>;
                
            var config:MinimalConfigurator = new MinimalConfigurator(timeline);
            config.parseXML(xml);
            
            Window(config.getCompById("preview")).content.addChild(DisplayObject(button));
            button.x = 30;
            button.y = 50;
            
            var selectable:CheckBox = CheckBox(config.getCompById("selectable"));
            selectable.addEventListener(MouseEvent.CLICK, function() : void
            {
                button.selectable = selectable.selected;
            });
            
            var toggle:CheckBox = CheckBox(config.getCompById("toggle"));
            toggle.addEventListener(MouseEvent.CLICK, function() : void
            {
                button.toggle = toggle.selected;
            });
            
            var enebled:CheckBox = CheckBox(config.getCompById("enebled"));
            enebled.addEventListener(MouseEvent.CLICK, function() : void
            {
                button.mouseEnabled = enebled.selected;
            });
            
            var status : Label = config.getCompById("status") as Label;
            status.addEventListener(Event.ENTER_FRAME, function() : void
            {
                status.text = "selected: " + button.selected;
            });
            
            var tab:Tab = new Tab(timeline);
            tab.x = 10;
            tab.y = 200;
            tab.width=900;
            tab.height=300;
            
            var behaviorCreater:BehaviorCreater = new BehaviorCreater(button);
            new BehaviorUIThread(button, tab, "OVER / OUT",       BehaviorContext.ROLL_OVER_OUT,   behaviorCreater).start();
            new BehaviorUIThread(button, tab, "UP / DOWN",        BehaviorContext.DOWN_UP,         behaviorCreater).start();
            new BehaviorUIThread(button, tab, "ENABLE / DISABLE", BehaviorContext.ENABLE_DISABLE,  behaviorCreater).start();
            new BehaviorUIThread(button, tab, "SELECT / UNSELECT",BehaviorContext.SELECT_UNSELECT, behaviorCreater).start();
        }

        override protected function finalize() : void
        {
        }
    }
}

