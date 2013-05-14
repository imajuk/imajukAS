package com.imajuk.ui.buttons.group
{
    import com.imajuk.ui.buttons.IButton;

    import flash.utils.setTimeout;

    /**
     * @author imajuk
     */
    public class ButtonOparation
    {
        public static const SELECT : String = "SELECT";
        public static const UNSELECT : String = "UNSELECT";
        public static const ENABLE : String = "ENABLE";
        public static const DISABLE : String = "DISABLE";
        public static const ROLLOVER : String = "ROLLOUT";
        public static const ROLLOUT : String = "ROLLOUT";

        private var isDisableOparation : Boolean;
        private var isEnabledOparation : Boolean;
        private var isSelectOparation : Boolean;
        private var isUnSelectOparation : Boolean;
        private var isRolloverOparation : Boolean;
        private var isRolloutOparation : Boolean;

        public function ButtonOparation(...oparations)
        {
            isRolloverOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.ROLLOVER;
            });
            isRolloutOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.ROLLOUT;
            });
            isDisableOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.DISABLE;
            });
            isEnabledOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.ENABLE;
            });
            isSelectOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.SELECT;
            });
            isUnSelectOparation = oparations.some(function(s : String, ...param) : Boolean
            {
                return s == ButtonOparation.UNSELECT;
            });

        }
        
        public function toString() : String {
            return  "ButtonOparation[" + 
                        "\n\tisRolloverOparation:" + isRolloverOparation +
                        "\n\tisRolloutOparation:"  + isRolloutOparation +
                        "\n\tisDisableOparation:"  + isDisableOparation +
                        "\n\tisEnabledOparation:"  + isEnabledOparation +
                        "\n\tisSelectOparation:"   + isSelectOparation +
                        "\n\tisUnSelectOparation:" + isUnSelectOparation +
                    "\n]";
        }

        internal function oparate(btn : IButton, value : Boolean) : void
        {
            if (isRolloverOparation)
            {
                if (value)
                    btn.rollOverEffect();
                else
                    btn.rollOutEffect();
            }

            if (isRolloutOparation)
            {
                if (value)
                    btn.rollOverEffect();
                else
                    btn.rollOutEffect();
            }

            //------------------------
            // mouseEnabled操作によるイベントバブリングの停止を防ぐため、
            // mouseEnabledの操作は1フレーム後にする
            //------------------------
            if (isEnabledOparation)
                setTimeout(function():void{
                    btn.mouseEnabled = value;
                }, 100);
            if (isDisableOparation)
                setTimeout(function():void{
                    btn.mouseEnabled = !value;
                }, 100);

            if (btn.selectable)
            {
                if (value && btn.toggle) return;
                
                if (isUnSelectOparation)
                    btn.selected = !value;
                if (isSelectOparation)
                    btn.selected = value;
            }
        }
    }
}
