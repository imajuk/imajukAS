package com.imajuk.spray 
{
	import flash.display.BitmapData;
    /**
     * @author shinyamaharu
     */
    public class SprayDef 
    {
        private var _layer : BitmapData;
        private var _spray : Spray;

        public function SprayDef(layer:BitmapData, spray:Spray)         {
    		
            _spray = spray;
            _layer = layer;
        }
        
        public function get layer() : BitmapData
        {
            return _layer;
        }
        
        public function get spray() : Spray
        {
            return _spray;
        }
    }
}
