package com.imajuk.constructions 
{
    import com.imajuk.graphics.LiquidLayout;
    import com.imajuk.utils.BrowserUtils;
    import com.imajuk.utils.StageReference;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	/**
	 * @author yamaharu
	 */
	public class DocumentClass extends MovieClip 
	{
        private static var isInitialized : Boolean;

        public function DocumentClass (
		                                  quality:String = StageQuality.LOW,
		                                  align:String = null,
		                                  scaleMode:String = StageScaleMode.NO_SCALE,
		                                  dispatchRenderEvent:Boolean = true
		                              )
        {
        	//読み込まれた外部swfのDocumentClassがコンテナを上書きしてはいけない
            if (!_container)
                _container = this;
            
            var isAddedStage : Boolean, isInitLoaderInfo : Boolean;
            
            addEventListener(Event.ADDED_TO_STAGE, function():void
            {
            	removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
            	
            	isInitialized = true;
            	
                //URLパラメータの取得
                _flashVars = BrowserUtils.getURLParameters();
                
                if(!StageReference.isEnabled)
    				StageReference.initialize(_container);
    
                var st:Stage = StageReference.stage; 
                
                if (align)
        			st.align = align;
        			
                st.scaleMode = scaleMode;
                st.quality = quality;
                
                StageReference.dispatchRenderEvent = dispatchRenderEvent;
                
                LiquidLayout.initialize(st);
                
                isAddedStage = true;
            });
            loaderInfo.addEventListener(Event.INIT, function() : void
            {
                loaderInfo.removeEventListener(Event.INIT, arguments.callee);
                isInitLoaderInfo = true;
            });
            addEventListener(Event.ENTER_FRAME, function() : void
            {
                if (isAddedStage && isInitLoaderInfo)
                {
                    removeEventListener(Event.ENTER_FRAME, arguments.callee);
                    _swfWidth = loaderInfo.width;
                    _swfHeight = loaderInfo.height;
                    start();
                }
            });
        }
        
        //--------------------------------------------------------------------------
        //  Getter/Setter
        //--------------------------------------------------------------------------
        /**
         * ローカルで実行されているかどうかを返します
         */
        public static function get isExecutingAtLocal():Boolean
        {
            return container.loaderInfo.url.indexOf("file://") > -1;
        }
        
        private static var _container : Sprite;
        public static function get container():Sprite
        {
            return _container;
        }

        private static var _flashVars : Object;
        public static function get flashVars() : Object
        {
        	if (!isInitialized)
        	   throw new Error("flashVarsプロパティはstart()が呼ばれるまで使用できません.");
        	   
        	return _flashVars;
        }

        public static function hasFlashVar(parameterName : String) : Boolean
        {
            if (!isInitialized)
                throw new Error("hasFlashVarはstart()が呼ばれるまで使用できません.");
        	
            return _flashVars.hasOwnProperty(parameterName);
        }

        public static function getFlashVar(parameterName : String) : Object
        {
            if (!isInitialized)
                throw new Error("getFlashVarはstart()が呼ばれるまで使用できません.");
        	
            return _flashVars[parameterName];
        }
        
        /**
         * swfの幅を返します.Stage.stageWidthとの違いに注意して下さい.
         */
        private static var _swfWidth : int;
        public static function get swfWidth() : int
        {
            return _swfWidth;
        }

        /**
         * swfの高さを返します.Stage.stageHeightとの違いに注意して下さい.
         */
        private static var _swfHeight : int;
        public static function get swfHeight() : int
        {
            return _swfHeight;
        }
        
        //--------------------------------------------------------------------------
        //  Methods
        //--------------------------------------------------------------------------
        /**
         * グローバルなセッティングが終わった後に呼び出されます.
         */
        protected function start():void
        {
            throw new Error("DocumentClassはstart()メソッドを実装して使用します.");
        }
    }
}
