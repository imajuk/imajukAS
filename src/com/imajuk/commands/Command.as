package com.imajuk.commands
{
    import flash.events.Event;	    import flash.events.EventDispatcher;	

    import com.imajuk.commands.ICommand;
    /**
     * 汎用同期コマンド.
     * 
     * <p><code>Command</code>は処理をカプセル化するためのクラスで、<br/>
     * ファンクションクロージャ、またはメソッドクロージャを一つ保持します.</p>
     * <p><code>execute()</code>メソッドが実行されると、<br/>
     * 保持しているクロージャを実行し、即座にイベントを発行します.</p>
     * <p>非同期コマンドが必要な場合は<code>AbstractAsyncCommand</code>を継承したサブクラスを実装してください。</p>
     * <p>Command is used in order to general-purpose command,<br/>
     * and surpports synchronous execution.</p>
     * <p>Command has only a closure - Function closure or Method closure, <br/>
     * when <code>execute()</code> is called, Command executes it.</p>
     * <p>if you want asynchronous execution command, <br/>
     * use and implement <code>AbstractAsyncCommand</code>.</p>
     * 
     * 
     * @author yamaharu
     * @see		IAsynchronousCommand
     * @see		AbstractAsyncCommand
     */
    public class Command extends EventDispatcher implements ICommand 
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
        public function Command(closure:Function, ...param)
        {
            myClosure = closure;
            
            if(param.length > 0)
    	        myArguments = param;
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var myClosure:Function;
        /**
         * @private
         */
        internal var myArguments:Array = [];

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         */
        protected var _isCompleted:Boolean = false;

        /**
         * @copy ICommand#isCompleted
         */
        public function get isCompleted():Boolean
        {
            return _isCompleted;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: execution
        //
        //--------------------------------------------------------------------------
        
        /**
         * 保持しているクロージャを実行します.
         * 
         * <p>コマンドはただちに実行され、実行完了を通知する<code>Event.COMPLETE</code>イベントが発行されます.</p>
         * <p>execute having closure.<br/>
         * <code>Command</code> quickly execute, and dispaches <code>Event.COMPLETE</code> event means completion of execution.</p>
         */
        public function execute():ICommand
        {
            executeClosure();
            finish();
            return this;
        }

        /**
         * @private
         */
        protected function executeClosure():void
        {
            if (myArguments.length > 0)
                myClosure.apply(null, myArguments);
            else            	myClosure.apply(null);
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: completion
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected function finish():void
        {
            _isCompleted = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: utility
        //
        //--------------------------------------------------------------------------
        
        /**
         * コマンドを複製します.
         * 
         * <p>保持しているクロージャを含め複製します.</p>
         * <p>clone Command has same closure and parameters.</p>
         */
        public function clone():ICommand
        {
            if (myArguments.length > 0)
                return new Command(myClosure, myArguments);            else
                return new Command(myClosure);
        }
        
        public static function create(closure:Function):Command
        {
            return new Command(closure);
        }
    }
}
