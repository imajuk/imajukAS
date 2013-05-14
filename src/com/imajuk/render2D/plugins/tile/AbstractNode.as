package  
com.imajuk.render2D.plugins.tile
{
    import com.imajuk.render2D.Render2DCamrera;

    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class AbstractNode extends Sprite 
    {
        private static var sid : uint = 0;
        
        
        public var worldX : Number;
        public var worldY : Number;
        

        public function AbstractNode(
        					sx : Number = 0,
        					sy : Number = 0
        				)
        {
            _id = sid++;
            worldX = sx;
            worldY = sy;
        }
        
        override public function toString() : String 
        {
            return "AbstractNode " + ["id:" + _id];
        }

        protected var _id : uint;
        public function get id() : uint
        {
            return _id;
        }

        protected var _size : Number = -1;
        public function get size() : Number
        {
        	if (_size == -1)
        	   _size = Math.sqrt(width * width + height * height);
            return _size;
        }
        
        public function get left() : Number
        {
            return worldX;
        }
        
        public function get right() : Number
        {
            return worldX + width;
        }

        public function isInsideCamera(camera : Render2DCamrera) : Boolean
        {
            return right > camera.left && worldX < camera.right;
        }
    }
}
