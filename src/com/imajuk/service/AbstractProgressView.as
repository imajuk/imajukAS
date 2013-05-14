package com.imajuk.service 
{
    import com.imajuk.interfaces.IProgressView;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    /**
     * @author yamaharu
     */
    public class AbstractProgressView extends Sprite implements IProgressView 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function AbstractProgressView(asset:DisplayObject = null)
        {
        	super();
            this.asset = asset;
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        protected var asset:DisplayObject;
        protected var isInitialized:Boolean = false;
        protected var currentProgress:Number = 0;
        internal var updateCalled : Boolean = false;

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
        /**
         * インスタンスの構築やレイアウトなどを行いインスタンスを使用可能状態にします.
         * このメソッドはテンプレートメソッドです.サブクラスで実装します.
         */
        public function build(...param):void
        {
            isInitialized = true;
        }
        
        protected function resetProgress():void
        {
        	currentProgress = 0;
        }

        /**
         * ロード進捗状況がアップデートされた時の実装.
         * サブクラスで実装しなければならない.
         */
        public function update(progress:Number):void
        {
            if(!isInitialized)
            	throw new Error(
            	   "com.imajuk.service::AbstractProgressViewにおいて" +
            	   "initialize()される前にupdate()が呼び出されました. " +
            	   "AbstractProgressViewのサブクラスのupdate()メソッド内でsuper.update()されている事" +
            	   "またはbuild()メソッド内でsuper.build()されている事を確認してください.");
            	
            if(currentProgress > progress)
            	return;

            currentProgress = progress;
            
            updateCalled = true;
            	
           //以下ProgressViewの実装をサブクラスで記述する
           //super.update()を忘れないように!
        }

        /**
         * 必要であればサブクラスで上書きする.
         * 例えば一瞬でロードが終わったときも
         * アニメーションをさせてから終了したいプログレスバーなど.
         */
        public function get isComplete():Boolean
        {
            return currentProgress == 1;
        }
        
        public function show():Thread
        {
        	return new Thread();        }
                public function hide():Thread
        {
        	return new Thread();
        }
        
        public function destroy() : void
        {
        	throw new Error("このメソッドは抽象メソッドです.サブクラスでdestroy()メソッドを実装する必要があります.");
        }
    }
}
