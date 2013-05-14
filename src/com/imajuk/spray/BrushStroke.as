package com.imajuk.spray 
{
	
    import flash.geom.Point;

    import com.imajuk.data.ArrayIterator;

    /**
     * @author shinyamaharu
     */
    public class BrushStroke extends ArrayIterator implements IBrushStroke
    {
        public function BrushStroke(data : Array, speed:Number = 1) 
        {
            var stroke : Array = [];
            data.forEach(function(posPare : Array, idx:int, ...param):void
            {
            	if (idx % speed == 0)
            		stroke.push(posPare);
            });
            stroke = stroke.map(function(posPare : Array, ...param):Point
            {
                return new Point(posPare[0], posPare[1]);
            });
            
            super(stroke);
        }
    }
}
