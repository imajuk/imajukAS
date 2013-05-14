package com.imajuk.slideshow 
{
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.utils.DisplayObjectUtil;
    import fl.motion.easing.Exponential;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import org.libspark.thread.Thread;



    /**
     * 簡易スライドショーの抽象クラス
     * 複数のDisplayObjectを子供に持つDisplayObjectContainerを食わすと
     * スライドショーにしてくれる.
     * 
     * テンプレートメソッドパターンを使用しています。
     * サブクラスで、getShowCurrentThread()、getHidePreviousThread()を上書きして
     * スライドのトランジションをカスタマイズしてください。
     * 
     * @author shin.yamaharu
     */
    public class AbstractImageContainerThread extends Thread 
    {
    	//このコンテナのモデル.一つのコンテナに一つのモデルが割り当てられる
        private var model:ImageContainerModel;
        //コンテナの識別子.modelはThreadの終了とともに毎回破棄されるため、modelはこの識別子でデータを管理する.
        protected var identify:String;
        //コンテナに含まれるDisplayObject.スライドショーにおけるスライド.
        protected var images:Array;
        //どのスライドを表示するかのインデックス
        protected var imageIndex:int;
        //トランジションの継続時間.        protected var duration:Number;        protected var duration_off:Number;
        //トランジションのイージング.
        protected var easing : Function;
        protected var easing_hide : Function;
        //トランジションのThread
        private var effect:Thread;
        
        //同じidentifyのAbstractImageContainerThreadは排他的に動作する
        //この辞書でidentifyと実行中のインスタンスをひもづける
        private static var motions : Dictionary = new Dictionary(true);
        
        //PararelExecuterはinterrupt()した際、内包するThreadをinterrupt()するまでに1フレームかかるようだ
        //この際別のPararelExecuterがinterrupt()されると、内包するThreadのinterrupt()処理がキャンセルされる?
        //とにかくバグっぽいのでinterrupt()用に参照を持っておくようにした
        private var forInterrupt : Array;
        

        public function AbstractImageContainerThread(
                            identify:String,
                            imagesContainer:Sprite,
                            imageIndex:int,
                            duration:Number = .7,                            duration_off:Number = .7,
                            easing:Function = null,
                            easing_hide:Function = null
                        )
        {
            super();
            
            this.imageIndex = imageIndex;
            this.images = DisplayObjectUtil.getAllChildren(imagesContainer);
            this.identify = identify;
            this.duration = duration;            this.duration_off = duration_off;
            this.easing = (easing == null) ? Exponential.easeInOut : easing;            this.easing_hide = (easing_hide == null) ? Exponential.easeOut : easing_hide;
            
            if (images.length <= 1)
                throw new Error("指定されたコンテナ内のアセットが" + images.length + 
                                "です.コンテナには少なくとも2つ以上のアセットが必要です.");
            
            ThreadUtil.interrupt(motions[identify]);
            motions[identify] = this;
        }

        override protected function run():void
        {
        	//TODO Dirty patch -2をわたすと全部消える
            if (imageIndex == -2)
            {
            	ThreadUtil.pararel(getHidePreviousThread()).start();
                interrupt();
            	return;
            }
            
            if (ImageContainerModel.getCurrent(identify) == imageIndex)
            {                interrupt();
                return;
            }
            
            if (isInterrupted)
                return;
                
            interrupted(function():void
            {
            	//実行中のビヘイビアを全て終了
            	forInterrupt.forEach(function(t:Thread,...param):void
                {
                	t.interrupt();
                });            });
                
            this.model = new ImageContainerModel(identify, imageIndex);
            
        	ThreadUtil.interrupt(effect);
                
            forInterrupt = getExecuteEffect();
            effect = ThreadUtil.pararel(forInterrupt);
            effect.start();
            effect.join();
        }

        protected function hideAll() : Thread 
        {
        	return new Thread();
        }

        private function getExecuteEffect():Array
        {
            var a:Array = [];

            if (previous)
                a = a.concat(getHidePreviousThread());
                
            a = a.concat(getShowCurrentThread());
            
            return a;
        }

        /**
         * DisplayObjectの切り替えトランジションを変更するにはこのメソッドを実装する.
         * 現在のDisplayObjectを表示するトランジション
         */
        protected function getShowCurrentThread():Array
        {
            return [];        }

        /**
         * DisplayObjectの切り替えトランジションを変更するにはこのメソッドを実装する.
         * 前のDisplayObjectを非表示にするトランジション
         */
        protected function getHidePreviousThread():Array
        {
            return [];        }

        protected function get current():DisplayObject
        {
            return images[ImageContainerModel.getCurrent(identify)];
        }

        protected function get previous():DisplayObject
        {
            var prev:int = ImageContainerModel.getPrevious(identify);
            
            if (prev == -1)
        	   return null;
        	else
               return images[prev];
        }

        /**
         * モデルをリセットします.
         * @param   リセットしたいモデルの識別子
         */
        protected static function reset(identify : String) : void 
        {
        	ImageContainerModel.reset(identify);
        }

        protected function get getCurrentIndex() : int
        {
            return ImageContainerModel.getCurrent(identify);
        }

        protected function get getPreviousIndex() : int
        {
            return ImageContainerModel.getPrevious(identify);
        }
    }
}
