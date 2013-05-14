package com.imajuk.ui.buttons
{
    /**
     * @author imajuk
     */
    internal class ButtonUtils
    {
        private var tButtonMode : Boolean;
        private var tMouseEnabled : Boolean;
        private var tMouseChildren : Boolean;

        public function recordInteractiveStatus(button : AbstractButton) : void
        {
            tButtonMode = button.buttonMode;
            tMouseEnabled = button.mouseEnabled;
            tMouseChildren = button.mouseChildren;
        }

        public function revertInteractiveStatus(button : AbstractButton) : void
        {
            button.buttonMode = tButtonMode;
            button.mouseEnabled = tMouseEnabled;
            button.mouseChildren = tMouseChildren;
        }
    }
}
