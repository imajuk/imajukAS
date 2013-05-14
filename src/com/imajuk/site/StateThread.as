package com.imajuk.site 
{
    import com.imajuk.utils.StageReference;
    import flash.display.Stage;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.ui.buttons.IButton;

    import org.libspark.thread.Thread;

    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;



    /**
     * ステートを表現するThread
     * フレームワーク内でコントローラとして振る舞う
     * 
     * @author shinyamaharu
     */
    public class StateThread extends ReferencableViewThread     {
        /**
         * ステート終了時にテンポラリビューを表示リストから削除するかどうか
         * デフォルトはtrueです。
         */
        protected var _autoRemoveTemporaryView : Boolean = true;
        public function get autoRemoveTemporaryView() : Boolean
        {
            return _autoRemoveTemporaryView;
        }
        
        protected function get stage():Stage
        {
            return StageReference.stage;
        }
        
        /**
         * ビューの片付けという典型的な処理のためのシンタックスシュガーを提供します.
         * ビューのhideビヘイビアの実行、init()メソッドの呼び出しをするThreadを返します.
         * note: 表示リストからビューを取り除くタスクはframeworkが担当する事に注意して下さい.
         * このタスクを自動で行わないようにするにはautoRemoveTemporaryViewプロパティにfalseを設定します.
         */
        protected function tearDownView(view : *, callback : Function = null) : Thread
        {
            return new ViewTeardownThread(view, callback);
        }

        /**
         * ボタンのインタラクションという典型的な処理のためのシンタックスシュガーを提供します.
         */
        protected function waitButtonMouseDown(view:InteractiveObject, func : Function, justOnce:Boolean = false) : void 
        {
        	interrupted(function():void{});
            if (isInterrupted) return;
            
        	event(view, MouseEvent.MOUSE_DOWN, 
            	function(e : MouseEvent):void
                {
                    var btn : IButton = e.target as IButton;
                    if (!btn)
                    {
                        next(function():void
                        {
                        	waitButtonMouseDown(view, func, justOnce);
                        });
                        return;
                    }
                    
                    func(btn);
    
                  	if (justOnce)
                  	     return;
                  	
                    next(function():void
                    {
                        waitButtonMouseDown(view, func);
                    });    
                }
            );
        }

        /**
         * Threadの一時停止という典型的な処理のためのシンタックスシュガーを提供します.
         */
        protected function infinityLoop() : void
        {
            ThreadUtil.infinityLoop();
        }
    }
}
