package com.imajuk.commands 
{
    import flash.events.IEventDispatcher;    

    import com.imajuk.commands.AbstractAsyncCommand;
    import com.imajuk.commands.ICommand;

    /**
     * ターゲットのイベントを受け取ると終了するコマンドです.
     * 任意のオブジェクトの任意のイベントを監視するコマンドと言い換える事も出来ます.
     * FuluentCommandのユーティリティとして使用されます.
     * 
     * @author yamaharu
     */
    public class EventCommand extends AbstractAsyncCommand implements ICommand 
    {
        private var _killEventType:String;
        private var _dispatcher:IEventDispatcher;
        private var _eventType:String;

        /**
         * コンストラクタ
         * 
         * @param dispatcher       イベントを配信するターゲット
         * @param eventType        受け取りたいイベント
         * @param killEventType    イベントを受け取るのをやめるトリガーとなるイベント
         */
        public function EventCommand(   dispatcher:IEventDispatcher,
                                        eventType:String,
                                        killEventType:String = null)
        {
            super(null);
            
            _killEventType = killEventType;
            _dispatcher = dispatcher;
            _eventType = eventType;
            
            //TODO killEventを受け取ったときこのクロージャを消す必要があるのでは？
            dispatcher.addEventListener(eventType, function():void
            {
                finish();
            });
        }
        
        public function get killEventType():String
        {
            return _killEventType;
        }
        
        public function get dispatcher():IEventDispatcher
        {
            return _dispatcher;
        }
        
        override public function clone():ICommand
        {
        	return new EventCommand(_dispatcher, _eventType, _killEventType);
        }
    }
}
