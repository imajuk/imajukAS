package com.imajuk.display
{
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.logs.Logger;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.service.ProgressInfo;

    import org.libspark.thread.Thread;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;



    /**
     * BitmapDataをロードできるSpriteです.
     * 次の例ではLazyLoaderインスタンスのレイアウトとフェードインを実行しています.
     * BitmapDataがロードされていなければロード終了後に、
     * BitmapDataが既にロードされていれば即座にこの操作は実行されます.
     * このようにBitmapDataのロードが終了しているかどうかを意識する事なく
     * インスタンスに対する操作を実行できます.
     * 
     * var f : Function = 
                function(image:LazyLoader):void
                {
                    DisplayObjectUtil.fitToRectangle(image, guide.width, guide.height, DisplayObjectUtil.AUTO_INSIDE);
                    image.x = guide.x + (guide.width - image.width) * .5;
                    image.y = guide.y + (guide.height - image.height) * .5;
                    
                    new TweensyThread(image, 0, 1, Exponential.easeInOut, {alpha:0}, {alpha:1}).start();
                };
            
       lazyLoader.doLazy(f);
     * 
     * @author shin.yamaharu
     */
    public class LazyLoader extends Sprite
    {
        public var id : int;
        private var bitmap : Bitmap;
        private var doLater : Array = [];

        public function LazyLoader(id:int, bitmapDataURL : String, smoothing:Boolean = true)
        {
            this.id = id;
            this._bitmapDataURL = bitmapDataURL;
            this.smoothing = smoothing;
        }
        
        override public function toString() : String
        {
            return "LazyLoader[" + id + "]";
        }
        
        private var _bitmapDataURL : String;
        public function get bitmapDataURL() : String
        {
            return _bitmapDataURL;
        }

        public function set smoothing(value : Boolean):void
        {
            doLazy(
                function(...param):void
                {
                    bitmap.smoothing = value;
                }
            );
        }
        
        public function get bitmapData() : BitmapData
        {
        	if (bitmap)
                return bitmap.bitmapData.clone();
            else
                throw new Error("the bitamp isn't loaded still.");
        }
        
        public function set bitmapData(value : BitmapData) : void
        {
            if (bitmap)
                bitmap.bitmapData = value;
            else
                throw new Error("the bitamp isn't loaded still.");
        }

        public function load(progressView:IProgressView) : Thread
        {
        	//=================================
        	// ロードするべきイメージがなければ何もしない
        	//=================================
        	if (_bitmapDataURL.length == 0)
        	   return new Thread();
            //=================================
            // 既にロードされていればなにもしない
            //=================================
            if (bitmap)
                return new Thread();

            //=================================
            // イメージをロードするThreadを返す
            //=================================
            return PreLoaderThread.create(
                        _bitmapDataURL, 
                        function(b : Bitmap):void
                        {
                            Logger.info(2, id + " / " + _bitmapDataURL + " loaded.");
                            bitmap = addChild(b) as Bitmap;
                            init();
                            onComplete();
                        }, 
                        null, 
                        new ProgressInfo(
                            true, 
                            progressView,
                            null
                        )
                   );
        }

        private function onComplete() : void
        {
        	var me:LazyLoader = this;
            doLater.forEach(
                function(lazy:Function, ...p):void
                {
                	lazy.apply(null, [me]);
                }
            );
            doLater = [];
        }

        /**
         * このインスタンスに対する操作を登録します.
         * BitmapDataがロードされていれば即座に、
         * まだロードされていなければロード後に操作は実行されます.
         * 
         * @param lazy  このItemImageインスタンスを引数にとるクロージャ
         */
        public function doLazy(lazy : Function) : void
        {
        	if (bitmap)
        	   lazy(this);
        	else
        	   doLater.push(lazy);
        }

        public function init() : void
        {
            alpha = 0;
        }
    }
}
