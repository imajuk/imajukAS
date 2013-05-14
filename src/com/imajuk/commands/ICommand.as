package com.imajuk.commands 
{
    import flash.events.IEventDispatcher;	    /**
     * 同期コマンドのインターフェイス.
     * 
     * <p>同期コマンドの公開メソッドを定義します.</p>
     * <p>Interface for synchronous command.<br/>
     * this defines methods about synchronous command.</p>
     * 
     * @author	yamaharu
     * @see 	Command
     * @see		IAsynchronousCommand
     * @see		AbstractAsyncCommand
     */
    public interface ICommand extends IEventDispatcher
    {
        /**
         * コマンドが終了しているかどうかを返します.
         * 
         * <p>returns whether command was completed or not.</p>
         */
        function get isCompleted():Boolean;

        /**
         * 保持しているクロージャを実行します.
         * 
         * <p>execute having closure.</p>
         */
        function execute():ICommand;

        /**
         * コマンドを複製します.
         * 
         * <p>保持しているクロージャを含め複製します.</p>
         * <p>clone Command has same closure and parameters.</p>
         */
        function clone():ICommand;
    }
}
