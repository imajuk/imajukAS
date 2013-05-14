package com.imajuk.animations 
{
    import com.imajuk.animations.Range;    

    import flash.display.BitmapData;    
    import flash.display.DisplayObject;    

    /**
     * @author yamaharu
     */
    public class AbstractAvoidFactory implements IAvoidFctory 
    {
        protected var range:Range;
        private var _pool:Pool;
        private var frequensy:Number;
        private var movingThread:AbstractMovingCharactorThread;

        /**
         * コンストラクタ
         * @param charactors
         * @param range         生成時の座標の範囲
         * @param amount        1画面に生成する最大数
         * @param frequensy     生成する頻度（0 > frequensy >= 1）
         */
        public function AbstractAvoidFactory(
                            charactors:Array,
                            range:Range,
                            movingThread:AbstractMovingCharactorThread,
                            amount:uint = 10,
                            frequensy:Number = 1
                            ) 
        {
            this.range = range;
            this.frequensy = frequensy;
            this.movingThread = movingThread;
            
            _pool = new Pool(amount);
            for (var i:int = 0;i < amount; i++) 
            {
                //select charactor
                var charaRef:Class = charactors[Math.floor(Math.random() * charactors.length)];
                //create charactor
                _pool.checkIn(i, new AvoidChara(new charaRef(0, 0) as BitmapData, i));
            }
        }

        public function create():DisplayObject
        {
            var chara:AvoidChara;
            if (Math.random() > frequensy)
                chara = new NullAvoidChara();
            else
                chara = _pool.checkOut() || new NullAvoidChara();
            
            if (chara is NullAvoidChara)
                return chara;
                
            //move charactor
            var m:AbstractMovingCharactorThread = movingThread.clone(); 
            m.charactor = chara;
            m.pool = _pool;
            m.start();
            
            creationHock(chara);
                    
            return chara;
        }
        
        protected function creationHock(chara:AvoidChara):void
        {
        }
    }
}
