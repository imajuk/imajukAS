package com.imajuk.commands 
{
    import flash.events.Event;    
    /**
     * @author yamaharu
     */
    public class FuluentDo extends FuluentCommand implements ICommand 
    {
        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------

        private static var task:Array;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function FuluentDo(dispatcher:ICommand, closure:Function)
        {
            super(dispatcher, closure);
            
            if(!task)
            	task = [];
            	
           	//リンク処理のタスクを追加.
           	//タスクはクラス変数に格納され、create()メソッドが呼ばれると、まとめて実行される.
            task.push(function():void
            {
                //すでに同じコマンドに対しておなじdoがリンクされているなら、古いリンクを削除する.
                if (isDuplication)
                    myCommand.removeEventListener(Event.COMPLETE, duplication.agent.completeHandler);
		            
                myCommand.addEventListener(Event.COMPLETE, completeHandler);
                
                //always()オプションの際の終了イベントの登録.
                if (myCommand is EventCommand && EventCommand(myCommand).killEventType)
                    EventCommand(myCommand).dispatcher.addEventListener(EventCommand(myCommand).killEventType, watchingCompleteHandler);
            });
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

		/**
		 * @private
		 */
        private var alwaysDo:Boolean;

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

		/**
		 * 重複チェック用のヘルパーへの参照.
		 */
        private function get duplication():LogHelper
        {
            return LogHelper(agentList[myClosure]);
        }

		/**
		 * すでに同じ前提コマンドに対して、おなじdoが定義されているかどうか
		 */
        private function get isDuplication():Boolean
        {
            return  agentList[myClosure] && duplication.precondition == myCommand;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
        
        /**
         * 前提コマンドと前提コマンドが終了したときに実行されるdoコマンドを
         * 紐づけるリンクを作成する.
         */
        public function create():void
        {
            if (!task)
            	return;
            	
            task.forEach(function(closure:Function, ...param):void
            {
                closure();
            });
            task = null;
        }

		/**
		 * シーケンシャルなコマンド実行を開始した後、前提コマンドも実行します.
		 * 通常は使用しません.
		 */
        override public final function execute():ICommand
        {
            create();
            
            if (myCommand is EventCommand)
                throw new Error("前提コマンド（when()に渡すコマンド）がEventCommandの場合はexecute()できません。create()を使用して下さい.");
            
            return  myCommand.execute();
        }

		/**
		 * 前提コマンドが実行されたときに、常にdoを実行するかどうか.
		 * @default	false
		 */
        public function always():FuluentDo
        {
            var f:FuluentDo = this;
            task.push(function():void
            {
                alwaysDo = true;
                //doされる予定のクロージャをキーにして、重複チェックヘルパーを作成する
                agentList[myClosure] = new LogHelper(myCommand, f);
            });
            return this;
        }

        /**
         * @private
         * 前提コマンドの終了イベントのリスナである事をやめる.
         */
        private function stopBeCompletionListener():void
        {
            myCommand.removeEventListener(Event.COMPLETE, completeHandler);
        }

        //--------------------------------------------------------------------------
        //
        //  Event handlers: discription
        //
        //--------------------------------------------------------------------------

		/**
		 * @private
		 * 前提コマンドの実行が終了した.
		 */
        protected function completeHandler(event:Event):void
        {
            //一度だけdoする場合は、リスナを削除する.
            if (!alwaysDo)
                stopBeCompletionListener();
	        
	        //doの実行
            super.executeClosure();
            finish();
        }

        /**
         * @private
         * 終了条件のイベントをキャッチした.
         */
        private function watchingCompleteHandler(event:Event):void
        {
        	alwaysDo = false;
        	stopBeCompletionListener();
        	EventCommand(myCommand).dispatcher.removeEventListener(EventCommand(myCommand).killEventType, watchingCompleteHandler);
//        	trace("always()の終了\n", EventCommand(myCommand).killEventType, "を受け取ったので", myCommand, "のCOMPLETEイベントの受信をやめます.");
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: MethodQueueElement
//
////////////////////////////////////////////////////////////////////////////////

import com.imajuk.commands.ICommand;import com.imajuk.commands.FuluentDo;

class LogHelper
{
    private var c:ICommand;
    private var l:FuluentDo;

    public function LogHelper(cmd:ICommand, fulu:FuluentDo) 
    {
        c = cmd;
        l = fulu;
    }

	/**
	 *  重複したFuluentDoインスタンスへの参照
	 */
    public function get agent():FuluentDo
    {
        return l;
    }

	/**
	 *  重複した前提コマンドへの参照
	 */
    public function get precondition():ICommand
    {
        return c;
    }
}
