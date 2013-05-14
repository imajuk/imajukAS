package com.imajuk.animations
{
    import com.imajuk.animations.Pool;    
    import com.imajuk.animations.AvoidChara;    
    import com.imajuk.animations.Speed;    

    import org.libspark.thread.Thread;

    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;    

    /**
     * @author yamaharu
     */
    public class AbstractMovingCharactorThread extends Thread 
    {
        protected var speed:Speed;
        protected var moving:Number;
        private var classRef:Class;

        protected var _charactor:AvoidChara;
        
        public function set charactor(charactor:AvoidChara):void
        {
            _charactor = charactor;
        }

        private var _pool:Pool;
        
        public function set pool(pool:Pool):void
        {
            _pool = pool;
        }
        
        public function AbstractMovingCharactorThread(speed:Speed)
        {
            super();
            this.speed = speed;
            this.moving = speed.random();
            classRef = getDefinitionByName(getQualifiedClassName(this)) as Class;
        }

        override public function toString():String
        {
            return _charactor.toString() + String(speed) + String(_pool);
        }

        override protected function finalize():void
        {
            _pool.checkIn(_charactor.id, _charactor);
            _charactor.parent.removeChild(_charactor);
            _charactor = null;
            speed = null;
        }

        public function clone():AbstractMovingCharactorThread
        {
            return new classRef(speed);
        }
    }
}
