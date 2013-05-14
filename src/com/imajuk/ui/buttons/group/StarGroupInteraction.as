package com.imajuk.ui.buttons.group
{
    import com.imajuk.ui.buttons.IButton;
    /**
     * @author imajuk
     */
    internal class StarGroupInteraction extends XORGroupInteraction
    {
        public function StarGroupInteraction(
                            buttons : Array,
                            defaultSelectedButtonIndex:int,
                            interactionTypes:Array,
                            oparation:ButtonOparation) 
        {
            super(buttons, defaultSelectedButtonIndex, interactionTypes, oparation);
        }
        

        override internal function setXORStatus(inactiveButtonIndex : int) : void
        {
            if (inactiveButtonIndex < 0) return;

            buttons.forEach(
                function(btn:IButton, idx:int, ...param):void
                {
                    var oparateValue:Boolean = idx <= inactiveButtonIndex;
                    oparation.oparate(btn, oparateValue);
                }
            );
        }

    }
}
