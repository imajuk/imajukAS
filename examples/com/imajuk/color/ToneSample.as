package com.imajuk.color 
{
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import fl.motion.easing.Exponential;
    import com.bit101.components.Label;
    import com.bit101.components.RangeSlider;

    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class ToneSample extends Sprite 
    {
        private static const EDIT_MODE : Boolean = false;
        private var tone : Array;
        private var isInitialized : Boolean;
        private var canvas : BitmapData;
        private var rect : Rectangle;

        public function ToneSample()
        {
        	canvas = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
        	addChild(new Bitmap(canvas));
        	
        	rect = new Rectangle();
        	
            var c : int = 0;
            var py : int = 0;
            tone = [
                    {name:"PALE", tone:ColorTone.PALE}, 
                    {name:"LIGHT_GRAYISH", tone:ColorTone.LIGHT_GRAYISH}, 
                    {name:"GRAYISH", tone:ColorTone.GRAYISH}, 
                    {name:"DARK_GRAYISH", tone:ColorTone.DARK_GRAYISH}, 
                    {name:"LIGHT", tone:ColorTone.LIGHT},                     {name:"SOFT", tone:ColorTone.SOFT},                     {name:"DULL", tone:ColorTone.DULL},                     {name:"DARK", tone:ColorTone.DARK},                     {name:"BRIGHT", tone:ColorTone.BRIGHT},                     {name:"STRONG", tone:ColorTone.STRONG},                     {name:"DEEP", tone:ColorTone.DEEP}, 
                    {name:"VIVID", tone:ColorTone.VIVID}
                ];
                
            tone = [
                    {name:"GRAYISH", tone:ColorTone.LIGHT_GRAYISH},                     {name:"SOFT", tone:ColorTone.SOFT},                     {name:"PALE", tone:ColorTone.PALE},                     {name:"PALE", tone:ColorTone.PALE},                     {name:"BRIGHT", tone:ColorTone.BRIGHT},                     {name:"PALE", tone:ColorTone.PALE},                     {name:"LIGHT", tone:ColorTone.LIGHT},                     {name:"DEEP", tone:ColorTone.DEEP},                     {name:"LIGHT_GRAYISH", tone:ColorTone.LIGHT_GRAYISH} 
                ];
                
            while(c < tone.length)
            {
            	new Label(this, 5, py, tone[c].name);
            	
            	if (EDIT_MODE)
            	{
                    var s : RangeSlider = new RangeSlider(RangeSlider.HORIZONTAL, this, 510, py + 15, getClosure(c));
                    s.minimum = 0;
                    s.maximum = 100;
                    s.lowValue = tone[c].tone[0];                    s.highValue = tone[c].tone[1];
                    s.setSize(80, 10);
                    
                    var v : RangeSlider = new RangeSlider(RangeSlider.HORIZONTAL, this, 595, py + 15, getClosure2(c));
                    v.minimum = 0;
                    v.maximum = 100;
                    v.lowValue = tone[c].tone[2];
                    v.highValue = tone[c].tone[3];
                    v.setSize(80, 10);
            	}
            	
                py += 30;
                c++;
            }
            
            isInitialized = true;
            draw();
            
//            setInterval(draw, 1);
            
        }

        private function getClosure(c : int) : Function 
        {
            return function(e:Event):void
            {
            	if (!isInitialized)
            	   return;
            	   
            	tone[c].tone[0] = RangeSlider(e.target).lowValue;            	tone[c].tone[1] = RangeSlider(e.target).highValue;
            	draw();
            };
        }

        private function getClosure2(c : int) : Function 
        {
            return function(e : Event):void
            {
                if (!isInitialized)
                   return;
                   
            	tone[c].tone[2] = RangeSlider(e.target).lowValue;
                tone[c].tone[3] = RangeSlider(e.target).highValue;
                draw();
            };
        }

        private function draw() : void 
        {
            var t : uint = getTimer();
            var c : int = 0;
            var px : int = 50;
            var py : int = 0;
            while(c < tone.length)
            {
                var internalY : int = 0;
                while(internalY < 30)
                {
                    var h : int = Exponential.easeIn(Math.random(), 1, 9, 1);                    var color : uint = ColorTone.getToneAs(tone[c].tone, Math.random() * 360).rgb;
                    rect.x = px;                    rect.y = py + internalY;
                    rect.width = stage.stageWidth - px;                    rect.height = h;
                    canvas.fillRect(rect, color);                    internalY += h;
                    if (internalY > 30) internalY = 30;
                }
                py += internalY + 0;
                c++;
            }
            
            trace(getTimer() - t);
        }
    }
}
