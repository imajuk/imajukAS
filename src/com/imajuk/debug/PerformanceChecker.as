package com.imajuk.debug
{
    import com.imajuk.events.AsyncEvent;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
        /**
     * 再生フレームレートの実測値、およびFlashPlayerのシステム使用メモリを計測・表示します.
     * 
     * <p><code>PerformanceChecker</code>は<i>Singleton</i>と呼ばれる特殊なクラスです.<br/>
     * インスタンスの生成はコンストラクタの項を参照して下さい.</p>
     * 
     * @author	takahashi	(coding)
     * 			yamaharu	(design, coding, document)
     */
    public class PerformanceChecker extends Sprite
    {
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         */
        private static const PREFIX:String = "FPS : ";

        /**
         * @private
         */
        private static const stoppingFormat:TextFormat = new TextFormat(DEFAULT_FONT, DEAFULT_FONT_SIZE, STOPPING_FONT_COLOR);
        /**
         * @private
         */
        private static const defaultFormat:TextFormat = new TextFormat(DEFAULT_FONT, DEAFULT_FONT_SIZE, DEFAULT_FONT_COLOR);

        /**
         * @private
         */
        private static const BACKGROUND_COLOR:uint = 0x000000;

        /**
         * @private
         */
        private static const LEFT_MARGIN:int = 2;

        /**
         * @private
         */
        private static const DEFAULT_FONT:String = "_ゴシック";

        /**
         * @private
         */
        private static const DEAFULT_FONT_SIZE:int = 9;

        /**
         * @private
         */
        private static const DEFAULT_FONT_COLOR:uint = 0xffffff;

        /**
         * @private
         */
        private static const STOPPING_FONT_COLOR:uint = 0x999999;

        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * シングルトンインスタンスを格納.
         */
        private static var _instance:PerformanceChecker;

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         * <code>PerformanceChecker</code>インスタンスの参照を返します.
         * @return <code>PerformanceChecker</code>インスタンスへの参照.
         */
        public static function get instance():PerformanceChecker
        {
            if (!_instance)
                _instance = new PerformanceChecker(new PrivateClass());
            return _instance;
        }

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         * コンストラクタ.
         * 
         * <p><code>PerformanceChecker</code>は<i>Singleton</i>と呼ばれる特殊なクラスで、
         * ただひとつのインスタンスしか生成できない事を保証します.<br/>
         * そのため、通常のようにnewキーワードを使用してインスタンスを生成することはできません.<br/>
         * <code>PerformanceChecker</code>インスタンスを得るには<code>PerformanceChecker.instance</code>プロパティにアクセスします.<br/>
         * インスタンス生成は<code>PerformanceChecker</code>クラス自身によって行われます.</p>
         * 
         * @see PerformanceChecker#instance
         */
        public function PerformanceChecker(privateClass:PrivateClass)
        {
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         */
        private var interval:Number;

        /**
         * @private
         */
        private var timeline:DisplayObjectContainer;

        /**
         * @private
         */
        private var myTxt:TextField;

        /**
         * @private
         */
        private var count:Number;

        /**
         * @private
         */
        private var lastFrameRate:Number;

        /**
         * @private
         */
        private var lastSystemMemory:Number;
        /**
         * @private
         */
        private var _isInitialize:Boolean = false;

        /**
         * @private
         */
        private var dispatchReservation:Function;

        /**
         * @private
         */
        private var startTime:Number;

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        private var _frameRate:int;

        /**
         * 再生フレームレートの実測値を取得します.
         */
        public function get frameRate():int
        {
            return _frameRate;
        }

        /**
         * @private
         */
        private var _systemMemory:Number;

        /**
         * システム使用メモリを取得します.
         */
        public function get systemMemory():int
        {
            return _systemMemory;
        }

        /**
         * <code>PerformanceChecker</code>が初期化されているかどうかを返します.
         */
        public function get isInitialize():Boolean
        {
            return _isInitialize;
        }

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         * <code>PerformanceChecker</code>を削除します.
         * 
         * <p>このメソッドが呼ばれると<code>PerformanceChecker</code>は全ての処理の実行を停止し、
         * <code>initialize()</code>メソッドで渡された<code>DisplayObjectContainer</code>から
         * <code>removeChild()</code>されます.</p>
         */
        public static function destroy():void
        {
            instance.kill();
            _instance = null;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * <code>PerformanceChecker</code>を初期化します.
         * 
         * <p><code>PerformanceChecker</code>は、利用前に必ず一度初期化する必要があります.<br/>
         * 初期化を行わずに利用しようとすると例外が発生します.</p>
         * 
         * @param timeline	<code>PerformanceChecker</code>を格納する<code>DisplayObjectContainer</code>を指定します.<br/>
         * 					通常はドキュメントクラスや<code>Stage</code>を使用します.
         * @param interval	FPS計測のインターバルをミリ秒単位で指定します.
         * @param position	<code>PerformanceChecker</code>を表示させる座標を指定します.
         * @param autoStart	自動的に計測を開始するかどうか指定します.
         */
        public function initialize(
        							timeline:DisplayObjectContainer,
                                  	interval:Number = 500,
                                  	position:Point = null,
                                 	autoStart:Boolean = true
                                 	):void
        {
            if(isInitialize)
        		return;
        		
            _isInitialize = true;
        		
            this.timeline = timeline;
            this.interval = interval;
            
            buildView(position ? position : new Point(0, 0));
            
            if (autoStart)
                start();
        }

        /**
         * システムパフォーマンスの計測を開始します.
         * 
         * <p>計測が開始されると<code>PerformanceChecker</code>は
         * <code>AsyncEvent.START</code>イベントを配信します.</p>
         * <p>また、計測中に計測値が更新されると<code>AsyncEvent.UPDATE</code>イベントを配信します.</p>
         * 
         * @see	jp.imgsrc.events.AsyncEvent
         */
        public function start():void
        {
            if (!isInitialize)
                throw new Error("PerformanceCheckerがinitializeされていません");
            
            myTxt.setTextFormat(defaultFormat);
            stopChecking();
            resetTimer();
            startChecking();
            
            dispatchReservation = function():void
            {
                dispatchEvent(new AsyncEvent(AsyncEvent.START));
            };
        }

        /**
         * システムパフォーマンスの計測を停止します.
         * 
         * <p>計測が停止されると<code>PerformanceChecker</code>は
         * <code>AsyncEvent.STOP</code>イベントを配信します.</p>
         * 
         * @see	jp.imgsrc.events.AsyncEvent
         */
        public function stop():void
        {
            myTxt.setTextFormat(stoppingFormat);
            stopChecking();
            dispatchEvent(new AsyncEvent(AsyncEvent.STOP));
        }

        /**
         * @private
         */
        private function startChecking():void
        {
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        /**
         * @private
         */
        private function stopChecking():void
        {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        /**
         *  @private
         */
        private function buildView(position:Point):void
        {
            timeline.addChild(this);
            name = "_performanceChecker_";
            x = position.x || 0;
            y = position.y || 0;
            
            myTxt = new TextField();
            myTxt.name = "__monitor__";
            myTxt.background = true;
            myTxt.backgroundColor = BACKGROUND_COLOR;
            myTxt.autoSize = TextFieldAutoSize.LEFT;
            defaultFormat.leftMargin = LEFT_MARGIN;
            stoppingFormat.leftMargin = LEFT_MARGIN;
            stoppingFormat.italic = true;
            myTxt.defaultTextFormat = defaultFormat;
            myTxt.text = PREFIX + "*";
            
            addChild(myTxt);
        }

        /**
         * @private
         */
        private function kill():void
        {
            stopChecking();
            if(timeline && this)
            {
                //誰かから勝手にremoveChild()されることもあるのでチェック
                if(parent == timeline)
	                timeline.removeChild(this);
	
                timeline = null;
            }
            _isInitialize = false;
        }

        /**
         * @private
         */
        private function resetTimer():void
        {
            count = 0;
            startTime = getTimer();
        }

        /**
         * @private
         */
        private function update():void
        {
            //update view.
            myTxt.text = PREFIX + _frameRate + " / " + timeline.stage.frameRate + " / " + _systemMemory.toFixed(2) + " Mb";
            
            lastFrameRate = _frameRate;
            lastSystemMemory = _systemMemory;
                
            //event dispatching.
            dispatchReservedEvent();
            dispatchEvent(new AsyncEvent(AsyncEvent.UPDATE));
        }

        /**
         * @private
         */
        private function dispatchReservedEvent():void
        {
            if(dispatchReservation == null)
            	return;
            	
            dispatchReservation();
            dispatchReservation = null;
        }

        //--------------------------------------------------------------------------
        //
        //  Event handlers: 
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        private function enterFrameHandler(event:Event):void
        {
            count ++;
            if (count >= timeline.stage.frameRate * interval / 1000)
            {
                //カウントしおわった。
                _systemMemory = Number(System.totalMemory >> 20);
                _frameRate = Math.round(count * 1000 / (getTimer() - startTime));
                resetTimer();
                
                if(lastFrameRate == _frameRate)
                	return;
                if(lastSystemMemory == _systemMemory)
                	return;
                	
                update();
            }
        }
    }
}



class PrivateClass
{
}
