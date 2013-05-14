package com.imajuk.ui.combobox 
{
    import com.imajuk.utils.StageReference;

    import flash.display.Stage;
    import flash.events.Event;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    /**
     * @author shin.yamaharu
     */
    internal class ComboBoxHitArea extends Sprite 
    {
        private var hitAreaBMP:Bitmap;
        private var offset:int = 30;
        private var isNeededHitTest:Boolean = false;
        private var debug : Boolean;

        public function ComboBoxHitArea(debug:Boolean = false)
        {
            this.debug = debug;
            this.mouseEnabled = false;
        	this.mouseChildren = false;
        	
            this.hitAreaBMP = addChild(new Bitmap()) as Bitmap;
            
            var st:Stage = StageReference.stage;
            addEventListener(Event.ENTER_FRAME, function():void
            {
                if (!isNeededHitTest)
            	   return;
            	   
                if (!hitTestPoint(st.mouseX, st.mouseY))
                {
                	stopHitTest();
            	   dispatchEvent(new ComboBoxEvent(ComboBoxEvent.OUT_OF_HITAREA, 0, null, null));
                }
            });
        }

        internal function update(w:int, h:int):void
        {
            hitAreaBMP.bitmapData = new BitmapData(w, h + offset, true, debug ? 0x33FF0000 : 0);
        }

        internal function startHitTest() : void 
        {
            isNeededHitTest = true;
        }

        internal function stopHitTest() : void 
        {
            isNeededHitTest = false;
        }
    }
}
