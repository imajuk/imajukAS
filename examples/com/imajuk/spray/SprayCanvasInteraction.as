package com.imajuk.spray 
{
    import flash.geom.Point;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * @author shinyamaharu
     */
    public class SprayCanvasInteraction 
    {
        private var canvas : Sprite;
        private var cursor : Point;
        private var sample : SplaySample;

        public function SprayCanvasInteraction(
                            canvas : Sprite, 
                            sample : SplaySample,                             cursor : Point
                        ) 
        {
            this.sample = sample;
            this.canvas = canvas;
            this.cursor = cursor;
        	
            canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);            canvas.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }

        private function mouseUpHandler(event : MouseEvent) : void 
        {
            sample.drawingMaterial.changeBrushSizeTo(0);
        }

        private function mouseDownHandler(event : MouseEvent) : void 
        {
            cursor.x = event.localX;            cursor.y = event.localY;
        	
        	sample.changeDrawingMaterial();
            sample.changeTone();
        }

        public function interrpt() : void 
        {
            canvas.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            canvas.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }
    }
}
