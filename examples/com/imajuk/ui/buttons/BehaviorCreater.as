package com.imajuk.ui.buttons
{
    import com.bit101.components.ComboBox;
    import com.bit101.components.Component;
    import com.bit101.components.HBox;
    import com.bit101.components.VBox;
    import com.imajuk.behaviors.IButtonBehavior;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.InstanceFactory;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.ui.buttons.fluent.IBehaviorFluentAPI;
    import com.imajuk.utils.DisplayObjectUtil;

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;


    /**
     * @author imajuk
     */
    public class BehaviorCreater
    {
        private var button : IButton;
        private var vboxies : Array = [];
        private var vboxToContext : Dictionary = new Dictionary(true);

        public function BehaviorCreater(button : IButton)
        {
            this.button = button;
        }

        public function create() : void
        {
            button.removeBehaviorAll();
            
            vboxies.forEach(function(vbox:VBox, ...param) : void
            {
                DisplayObjectUtil.getAllChildren(vbox).forEach(function(comp : Component, ...param) : void
                {
                    if (comp is HBox)
                    {
                        var combo : ComboBox = comp.getChildByName("behavior") as ComboBox;
                        if (!combo.selectedItem)
                            return;
    
                        var behaviorClass : Class = getDefinitionByName("com.imajuk.ui.buttons.behaviors::" + combo.selectedItem.data) as Class;
                        var behavior : IButtonBehavior = 
                            InstanceFactory.newInstance(
                                behaviorClass, 
                                BehaviorParamsUI.getparams(combo.selectedItem.label, comp as HBox)
                            ) as IButtonBehavior;
                            
                        var f:IBehaviorFluentAPI = button.context(vboxToContext[vbox]).behave(behavior);
                        
                        if (vboxToContext[vbox] == BehaviorContext.ROLL_OVER_OUT)
                            f.sound(AssetFactory.createSound("$Sound"));
                    }
                });
            });
        }

        public function resister(vbox : Component, context:String) : void
        {
            vboxies.push(vbox);
            vboxToContext[vbox] = context;
        }
    }
}
