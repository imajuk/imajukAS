package com.imajuk.spray 
{
	
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;

    /**
     * @author shinyamaharu
     */
    public class BrushStrokeMouse implements IBrushStroke
    {
        private var sprite : DisplayObjectContainer;
        private var log : String = "////////////////////\n";

        public function BrushStrokeMouse(sprite : DisplayObjectContainer)         
        {
            this.sprite = sprite;
            
            sprite.addEventListener(MouseEvent.CLICK, function():void
            {
                trace(log);
            });
        }

        public function next() : *
        {
            var stroke : Point = new Point(sprite.mouseX, sprite.mouseY);
            
            log += stroke.x + "," + stroke.y + "\n"; 
            
            return stroke;
        }

        public function hasNext() : Boolean
        {
            return true;
        }
    }
}
