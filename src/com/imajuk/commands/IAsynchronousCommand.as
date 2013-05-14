package com.imajuk.commands 
{
    /**
     * 非同期コマンドのインターフェイス.
     * 
     * <p>コマンドの停止、一時停止、再開メソッドを定義します.</p>
     * <p>Interface for asynchronous command.<br/>
     * this defines methods stopping and pauseing and resuming, 
     * and property tells execution.</p>
     * 
     * @author	yamaharu
     * @see 	ICommand
     */
    public interface IAsynchronousCommand extends ICommand 
    {
        /**
         * 非同期コマンドが実行中かどうかを返します.
         * <p>returns whether command is executing or not.</p>
         */
        function get isExecuting():Boolean;

        /**
         * 非同期コマンドが一時停止中かどうかを返します.
         * <p>returns whether command is pausing or not.</p>
         */
        function get isPausing():Boolean;

        /**
         * 非同期コマンドを一時停止します.
         * <p>pause execution of command.</p>
         */
        function pause():Boolean;

        /**
         * 非同期コマンドを完全に停止します.
         * <p>stop execution of command.</p>
         */
        function stop():Boolean;

        /**
         * 一時停止した非同期コマンドを再開します.
         * <p>resume execution of command.</p>
         */
        function resume():Boolean
    }
}
