package com.imajuk.commands 
{
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	

	/**
	 * 非同期コマンドテスト用の非同期コマンド
	 * 実行後1秒後に終了する
	 * @author yamaharu
	 */
	public class AsyncTestCommand extends AbstractAsyncCommand implements IAsynchronousCommand 
	{
		private var _timer : Timer;

		public function AsyncTestCommand (__closure : Function, ...__param) 
		{
			super(__closure, __param);
		}

		override public function execute () : ICommand
        {
            _isExecuting = true;
			_timer = new Timer(500, 1);
			_timer.addEventListener(TimerEvent.TIMER, function(e : TimerEvent):void
			{
				execWithDelay();
			});
			_timer.start();
			
			return this;
        }

        override public function pause():Boolean
        {
            if(!super.pause())
                return false;
            
            if(_timer)
                _timer.stop();
                
            return true;
        }

        override public function resume():Boolean
        {
            if(!super.resume())
                return false;
                
            if(_timer)
                _timer.start();
                
            return true;
        }

        override public function stop():Boolean
        {
            if(!super.stop())
                return false;
                
            if(_timer)
                _timer.stop();
                
            return true;
        }

        override public function clone () : ICommand
		{
			return new AsyncTestCommand(myClosure, myArguments);
        }

        private function execWithDelay () : void
		{
			super.execute();
			super.finish();
		}
	}
}
