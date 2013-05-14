package com.imajuk.commands 
{
    import com.imajuk.commands.ILoopable;        import com.imajuk.events.AsyncEvent;	
    /**
     * 非同期コマンドの抽象クラス.
     * 
     * <p>非同期コマンドはこのクラスを継承し、特化する部分を実装します.
     * それぞれのサブコマンドは、コマンド終了後finish()メソッドを呼び出す責任があります.</p>
     * <p>THis is the Abstract class that implements IAsynchronousCommand,<br/>
     * and provides common properties and methods.</p>
     * <p>one asynchronous command extends this, and implements specialize something.</p>
     * 
     * @author	yamaharu
     * @see		IAsynchronousCommand
     * @see		Command
     */
    public class AbstractAsyncCommand extends Command implements IAsynchronousCommand, ILoopable 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * コンストラクタ.
         * 
         * <p>Commandクラスは、ファンクションクロージャ、またはメソッドクロージャをラップします。<br/>
         * メソッドクロージャをラップする場合は、クロージャに渡す引数を指定できます。</p>
         * <p>Command wraps function closure or method closure.<br/>
         * if you want pass some parameters, you can use second paremeter.</p>
         * 
         * @param closure		コマンドが保持するファンクションクロージャ、またはメソッドクロージャ
         * 						<p>a function closure or a method closure.</p>
         * @param param			メソッドクロージャに渡す引数.
         * 						<p>parameter of closure.</p>
         */
        public function AbstractAsyncCommand(closure:Function, ...param)
        {
            super(closure);
            
            if(param.length > 0)
            	myArguments = param;
        }        

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var _isExecuting:Boolean = false;

        /**
         * @copy IAsynchronousCommand#isExecuting
         */
        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }

        /**
         * @private
         */
        private var _isPausing:Boolean;   

        /**
         * @copy IAsynchronousCommand#isPausing
         */
        public function get isPausing():Boolean
        {
            return _isPausing;
        }

        /**
         * @private
         */
        protected var _isLooping:Boolean = false;

        public function get loop():Boolean
        {
            return _isLooping;
        }

        public function set loop(value:Boolean):void
        {
            _isLooping = value;
            
            //この後のループ処理の実装は、サブクラスでなされなければならない.
        }

        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * 保持しているクロージャを実行します.
         * 
         * <p><code>execute()</code>メソッドが呼ばれた時、<br/>
         * 同期コマンドが直ちに実行されるのに対し、非同期コマンドはそうなるとはかぎりません.<br/>
         * 直ちに実行されるかどうかは非同期コマンドの実装に依存します.</p>
         * <p><code>AbstractAsyncCommand</code>の実行が開始されると<code>AsyncEvent.START</code>イベントが通知されます.<br/>
         * また、コマンドの実行を完了すると<code>Event.COMPLETE</code>イベントが通知されます.</p>
         * <p>execute having closure.</p>
         * <p>Though <code>Command</code> quickly execute when called, not all <code>AbstractAsyncCommand</code>s doesn't.<br/>
         * It depends on implementation of sub class.</p>
         * <p><code>AbstractAsyncCommand</code> dispaches <code>AsyncEvent.START</code> event means starting of execution, <br/>
         * and dispaches <code>Event.COMPLETE</code> event means completion of execution.</p>
         */
        override public function execute():ICommand
        {
            _isExecuting = true;
            executeClosure();
            dispatchEvent(new AsyncEvent(AsyncEvent.START));
            return this;
        }

		/**
		 * コマンドを複製します.
		 * 
		 * <p><code>AbstractAsyncCommand</code>のサブクラスで実装されます.</p>
		 * <p>This method is abstract method, and is implemented in <code>AbstractAsyncCommand</code>'s sub class.</p>
		 */
        override public function clone():ICommand
        {
            throw new Error("this is abstract class,so you must implement 'clone' method.");
        }

        /**
         * @private
         */
        override protected function finish():void
        {
            if(_isLooping)
            {
                execute();
            }
            else
            {
                stop();
                super.finish();
            }
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: control command
        //
        //--------------------------------------------------------------------------
        
        /**
		 * コマンドを一時停止します.
		 * 
		 * <p><code>AbstractAsyncCommand</code>のサブクラスで実装されます.</p>
		 * <p>This method is abstract method, and is implemented in <code>AbstractAsyncCommand</code>'s sub class.</p>
		 */
         public function pause():Boolean
        {
            if(!_isExecuting)
                return false;
                
            _isPausing = true;
            _isExecuting = false;
            
            return true;
            
            //この後の処理はサブクラスで実装しなければならない.
        }
        
        /**
         * 一時停止したコマンドを再開します.
         * 
         * <p><code>AbstractAsyncCommand</code>のサブクラスで実装されます.</p>
         * <p>This method is abstract method, and is implemented in <code>AbstractAsyncCommand</code>'s sub class.</p>
         */
        public function resume():Boolean
        {
            if(!_isPausing)
                return false;
                
            _isPausing = false;
            _isExecuting = true;
            
            return true;
            //この後の処理はサブクラスで実装しなければならない.
        }

        /**
         * コマンドを完全に停止します.
         * 
         * <p><code>AbstractAsyncCommand</code>のサブクラスで実装されます.</p>
         * <p>This method is abstract method, and is implemented in <code>AbstractAsyncCommand</code>'s sub class.</p>
         */
        public function stop():Boolean
        {
            if(!_isExecuting)
                return false;
                
            _isPausing = false;
            _isExecuting = false;
            
            return true;
            
            //この後の処理はサブクラスで実装しなければならない.
        }

    }
}
