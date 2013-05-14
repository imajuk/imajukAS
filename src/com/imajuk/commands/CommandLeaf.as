package com.imajuk.commands 
{
    import com.imajuk.commands.ILoopable;	
    import com.imajuk.events.AsyncEvent;	
	import com.imajuk.data.IComponent;

	import flash.events.Event;	
	/**
     * コマンドコンポーネントのコンポジット構造におけるリーフ.
     * 
     * <p>'Composite Pattern'におけるLeafを表現するクラスです.<br/>
     * 1つの<code>ICommand</code>を内包します.</p>
     * <p>This express a leaf of CommandComponent.'Leaf' means a leaf in 'Composite Pattern'.<br/>
     * This class has a command.</p>
     * 
     * @author	yamaharu
     * @see		ICommand
     * @see		CommandComponent
     * @see		CommandComposite
     */
    public class CommandLeaf extends CommandComponent implements IComponent, IAsynchronousCommand 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * コンストラクタ.
         * 
         * @param command	内包するコマンド
         * 					<p>included command</p>
         */
        public function CommandLeaf(command:ICommand) 
        {
            //複数のCommandItemが一つのICommandインスタンスをコンポジット（参照）する可能性があるため、
            //ICommandをバリューオブジェクトとして扱う
            myCommand = command.clone();
            myCommand.addEventListener(Event.COMPLETE, dispatchEvent);
            myCommand.addEventListener(AsyncEvent.START, dispatchEvent);
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var myCommand:ICommand;

        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * 内包しているコマンドが終了しているかどうかを返します.
         * 
         * <p>returns whether command was completed or not.</p>
         */
        override public function get isCompleted():Boolean
        {
            return myCommand.isCompleted;
        }

		/**
         * 内包しているコマンドが実行中かどうかを返します.
         * 
         * <p>returns whether command is executing or not.</p>
         */
        override public function get isExecuting():Boolean
        {
            var cmd:IAsynchronousCommand = myCommand as IAsynchronousCommand;
            return (cmd) ? IAsynchronousCommand(cmd).isExecuting : false;
        }

        /**
         * 内包しているコマンドが一時停止中かどうかを返します.
         * 
         * <p>returns whether command is pausing or not.</p>
         */
        override public function get isPausing():Boolean
        {
            if (isIAsynchronousCommand)
                return IAsynchronousCommand(myCommand).isPausing;
            else
                return false;
        }
        
        /**
		 * @private
		 */
        override public function set sequential(value:Boolean):void
        {
			//do nothing
        }

        /**
         * 内包している<code>ICommand</code>をループ実行するかどうか.
         */
        override  public function set loop(value:Boolean):void
        {
            super.loop = value;
            if (isLoopable)
                ILoopable(myCommand).loop = value;
        }

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        private function get isIAsynchronousCommand():Boolean
        {
            return myCommand is IAsynchronousCommand;
        }

        /**
         * @private
         */
        private function get isLoopable():Boolean
        {
            return myCommand is ILoopable;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * 内包しているコマンドを実行します.
         * 
         * <p>execute included command in component.</p>
         */
        override public function execute():ICommand
        {
            myCommand.execute();
            return this;
        }
        
         /**
         * 内包しているコマンドを一時停止します.
         * 
         * <p>一時停止したコマンドを再開する場合は、<code>resume()</code>メソッドを使用します.<br/>
         * このメソッドは、コマンドを再開できるという意味で、完全にコマンドを停止する<code>stop()</code>メソッドとは異なります.</p>
         * 
         * @see #resume
         * @see #stop
         */
        override public function pause():Boolean
        {
            if (isIAsynchronousCommand)
                return IAsynchronousCommand(myCommand).pause();
                
            return false;
        }

        /**
         * 内包している一時停止しているコマンドを再開します.
         * 
         * <p>resume paused command.</p> 
         */
        override public function resume():Boolean
        {
            if (isIAsynchronousCommand)
                return IAsynchronousCommand(myCommand).resume();
                
            return false;
        }

        /**
         * 内包しているコマンドの実行を完全に停止します.
         * 
         * <p>stop executing command.</p>
         */
        override public function stop():Boolean
        {
            if (isIAsynchronousCommand)
                return IAsynchronousCommand(myCommand).stop();
            
            return false;
        }

        /**
		 * @private
		 */
        override public function add(child:IComponent):void 
        {
			//do nothig
        }
    }
}
