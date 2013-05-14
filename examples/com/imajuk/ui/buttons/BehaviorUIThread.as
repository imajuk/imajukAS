package com.imajuk.ui.buttons
{
    import com.bit101.components.VBox;
    import com.bit101.components.Tab;
    import com.bit101.components.ComboBox;
    import com.bit101.components.Component;
    import com.bit101.components.HBox;
    import com.bit101.components.PushButton;
    import com.bit101.utils.MinimalConfigurator;
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import com.imajuk.utils.DisplayObjectUtil;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    /**
     * @author shinyamaharu
     */
    public class BehaviorUIThread extends Thread
    {
        private static var num : int;
        private var button : IButton;
        private var tab : Tab;
        private var vbox : Component;
        private var add : PushButton;
        private var combos : LinkList = new LinkList();
        private var buttonToCombo : Dictionary = new Dictionary(true);
        private var label : String;
        private var x : int;
        private var y : int;
        private var context : String;
        private var behaviorCreater : BehaviorCreater;
        private var page : int;

        public function BehaviorUIThread(
                            button : IButton, 
                            tab : Tab, 
                            label:String, 
                            context:String, 
                            behaviorCreater:BehaviorCreater
                        )
        {
            super();
            
            this.x = x;
            this.y = y;
            this.tab = tab;
            this.button = button;
            this.label = label;
            this.context = context;
            this.behaviorCreater = behaviorCreater;
        }

        override protected function run() : void
        {
            vbox = new VBox(null, 30, 10);
            behaviorCreater.resister(vbox, context);
            
            tab.addPage(label);
            tab.addChildToPage(num, vbox);
            tab.addChildToPage(num, new PushButton(null, 780, 255, "update"));
            
            page = num;
            
            num++;
            
            next(addBehaviorUI);
        }
        
        private function addBehaviorUI() : void
        {
            var hbox:HBox = new HBox(vbox);
            
            var xml:XML = 
                <comps>
                    <PushButton id="add" width="20" label="+" mouseEnabled="false" alpha=".5" />
                    <ComboBox id="behavior" label="behavior" defaultLabel="behavior" width="120" />
                </comps>;
            
            var config:MinimalConfigurator = new MinimalConfigurator(hbox);
            config.parseXML(xml);
            
            add = config.getCompById("add") as PushButton;
            var combo:ComboBox = config.getCompById("behavior") as ComboBox;
            combo.addItem({label:BehaviorParamsUI.COLOR, data:BehaviorParamsUI.COLOR});
            combo.addItem({label:BehaviorParamsUI.COLORLIZE, data:BehaviorParamsUI.COLORLIZE});
            combo.addItem({label:BehaviorParamsUI.TRANSPARENT, data:BehaviorParamsUI.TRANSPARENT});
            combo.addItem({label:BehaviorParamsUI.SWAP_IMAGE, data:BehaviorParamsUI.SWAP_IMAGE});
            combo.addItem({label:BehaviorParamsUI.MATRIX, data:BehaviorParamsUI.MATRIX});
            combo.addItem({label:BehaviorParamsUI.FRAME_STEP, data:BehaviorParamsUI.FRAME_STEP});
            
            combos.push(combo);
            buttonToCombo[add] = combo;
            
            next(waitInput);
        }

        private function waitInput() : void
        {
            var n : LinkListNode = combos.first;
            while (n)
            {
                event(ComboBox(n.data), Event.SELECT, function(e : Event) : void
                {
                    var combo : ComboBox = ComboBox(e.target);
                    buildBehaviorParams(combo);
                    if (combo.parent == add.parent)
                    {
                        add.alpha = 1;
                        add.mouseEnabled = true;
                    } 
                    waitInput();
                });
                n = n.next;
            }
            
            event(tab.getContent(page), MouseEvent.CLICK, function(e:MouseEvent) : void
            {
                if (e.target is PushButton)
                {
                    var btn:PushButton = PushButton(e.target);
                    switch(btn.label)
                    {
                        case "x":
                            removeBehaviorUI(btn);
                            break;
                        case "update":
                            behaviorCreater.create();
                            break;
                    }
                }
                    
                waitInput();
            });
            
            event(add, MouseEvent.CLICK, function() : void
            {
                add.label = "x";
                addBehaviorUI();
            });
        }

        private function removeBehaviorUI(btn:PushButton) : void
        {
            DisplayObjectUtil.removeChild(btn.parent);
            var n : LinkListNode = combos.first;
            while (n)
            {
                if (n.data == buttonToCombo[btn])
                {
                    combos.remove(n);
                    buttonToCombo[btn] = null;
                    break;
                }
                n = n.next;
            }
        }

        private function buildBehaviorParams(combo:ComboBox) : void
        {
            var behaviorClass:String = combo.selectedItem.data;
            
            //remove old params component
            var hbox:HBox = combo.parent as HBox;
            DisplayObjectUtil.getAllChildren(hbox).forEach(function(comp:Component, ...param) : void
            {
                if (comp.name == "behavior" || comp.name == "add")
                    return;
                DisplayObjectUtil.removeChild(comp);
            });
            
            //add new params component
            var config:MinimalConfigurator = new MinimalConfigurator(hbox);
            config.parseXML(BehaviorParamsUI.getRecipe(behaviorClass));
            
            var spr : Sprite = AbstractButton(button).asset as Sprite;
            setComboItems(config.getCompById("target") as ComboBox, "whole", spr);
                
            //for image swap
            setComboItems(config.getCompById("onImage") as ComboBox, "choose target", spr);
            setComboItems(config.getCompById("offImage") as ComboBox, "choose target", spr);
        }

        private function setComboItems(combo : ComboBox, defaultLabel : String, spr:Sprite) : void
        {
            if (!combo) return;
            if (!spr) return;
            
            combo.defaultLabel = defaultLabel;
            if (spr)
                DisplayObjectUtil.getAllChildren(spr).forEach(function(d : DisplayObject, ...param) : void
                {
                    combo.addItem({label:d.name, data:d.name});
                });
        }
        
        override protected function finalize() : void
        {
        }
    }
}

