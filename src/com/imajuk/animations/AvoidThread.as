package com.imajuk.animations 
{
    import com.imajuk.threads.TimeKeeperThread;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import org.libspark.thread.Thread;


    
    /**
     * 大量のキャラクターを生成するスレッド
     * @author yamaharu
     */
    public class AvoidThread extends Thread 
    {
        private var action:Function;
        private var creation:Function;

        /**
         * @param container     キャラクターを配置するコンテナ
         * @param creator       キャラクターを生成するファクトリ  
         * @param duration      このスレッドの継続時間
         * @param multiple      1Tickに生成するキャラクターの数
         */
        public function AvoidThread(
                            creator:IAvoidFctory,
                            container:DisplayObjectContainer,
                            duration:Number = Infinity,
                            multiple:int = 1
                            )
        {
            super();
            
            if(duration != Infinity)
                new TimeKeeperThread(this, duration).start();
                
            action = function():void
            {
                //割り込みハンドラを設定
                setInterrupted();
                
                if (checkInterrupted())
                    return;
                    
                next(creation);
            };
            
            creation = function():void
            {
                setInterrupted();
                next(action);

                for (var i:int = 0;i < multiple; i++)
                { 
                    //create charactor
                    var chara:DisplayObject = creator.create();
                    if (chara is NullAvoidChara)
                        return;
                        
                    container.addChild(chara);
                }

            };
        }

        override protected function run():void
        {
            action();
        }

        private function setInterrupted():void
        {
            interrupted(function():void
            {
                trace(this, "interrupt");
            });
        }

        protected override function finalize():void
        {
            trace(this + " : finalize " + [ currentThread ]);
            action:
            Function;
        }
    }
}
