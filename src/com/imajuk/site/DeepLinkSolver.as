package com.imajuk.site 
{
    import com.imajuk.utils.StageReference;
    import com.asual.swfaddress.SWFAddress;
    import com.asual.swfaddress.SWFAddressEvent;
    import com.imajuk.logs.Logger;
    import com.imajuk.utils.DictionaryUtil;

    import flash.utils.Dictionary;
    /**
     * @private
     * ディープリンクとブラウザの戻る，進むボタンをサポートする
     * @author shinyamaharu
     */
    public class DeepLinkSolver 
    {
    	/**
         * SWFAddressを使用するかどうか
         */
        internal static var useSWFAddress : Boolean;
        private static var application : Application;
        private static var state : ApplicationStateModel;
        private static var states : Dictionary = new Dictionary(true);
        private static var parameters : String;

        public static function get isDeepLink() : Boolean
        {
        	return state && state.reserved != null;
        };
        
        private static function getStateType(e : SWFAddressEvent) : Reference
        {
            if (SWFAddress.getPath() == "/")
                return null;
               
            if (DictionaryUtil.count(states) == 0)
            {
                Logger.warning("DeepLink用にステートが登録されていません. ステートレシピのpageName属性でステートを登録する必要があります");
                return null;
            }

            var path : String = e.value.substr(1);
            path = path.split("?")[0];
            var stateType : Reference = states[path];
            
            if (!stateType)
            {
                Logger.warning("DeepLink用に"+path+"で指定されたステートが登録されていません. ステートレシピのpageName属性で登録する必要があります");
                return null;
            }
            
            return stateType;
        }
        
    	//=================================
        // SWFAddress
        //=================================
        SWFAddress.addEventListener(SWFAddressEvent.INIT, onInit);
        SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onExternalChange);
        
        private static function onInit(e : SWFAddressEvent) : void
        {
        	var stateType : Reference = getStateType(e);
            if (stateType)
            {
                state.reserved = stateType;
                Logger.info(0, "DeepLinkが指定されました.[" + stateType + "]");
            }   
        }

        /**
         * ブラウザのアドレスバーのURLが変更された
         */
        private static function onExternalChange(e : SWFAddressEvent) : void
        {
        	//=================================
        	// パラメータの変更
        	//=================================
            var p : String = SWFAddress.getParameterNames().map(function(pname:String, ...param) : String
            {
            	return pname + "=" + String(SWFAddress.getParameter(pname)) + "&";
            }).join("");

            if (parameters != p)
                StageReference.stage.dispatchEvent(new DeepLinkEvent(DeepLinkEvent.CHANGE_PARAMETER));
        	parameters = p;
        	
        	//=================================
        	// ステートの変更
        	//=================================
        	//このステートに変更された
            var stateType : Reference = getStateType(e);
            
            //ルートステートなら無視
            if (!stateType)
                return;
            
            //現在のステートと同じなら無視
            if (state.isCurrent(stateType))
                return;
                
            var log : String = "\n\tpath : " + SWFAddress.getPath();
            log += "\n\tstateType : " + stateType;
            Logger.info(0, "browser's location was changed" + log);

            //ステートを変更
            application.changeState(stateType);
        }

        internal static function initialize(
                                    application:Application, 
                                    applicationState : ApplicationStateModel) : void 
        {
        	if (!useSWFAddress)
        	   return;
        	   
        	DeepLinkSolver.application = application;        	DeepLinkSolver.state = applicationState;
        	
        	var tree:XML = applicationState.tree;
        	
            for each (var node : XML in tree.descendants()) {
            	var pageName:String = node.attribute("pageName");
            	if(pageName.length > 0)
            	   states[pageName] = Reference.fromStrings(Reference.decodeType(node.name()));
            }        	
            
        	Logger.info(1, "use SWFAddress");
            
            //this won't work so far :(
//            _mainContainer.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
//            {
//                //this won't work so far :(
//                if (e.target is IButton)
//                   SWFAddress.setStatus(e.target.toString());
//            });
//            _mainContainer.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
//            {
//                //this won't work so far :(
//                if (e.target is IButton)
//                   SWFAddress.resetStatus();
//            });
        }
                internal static function update(stateType : Reference) : void 
        {
        	if (!useSWFAddress)
        	   return;
        	   
        	if (state.isCurrent(stateType))
        	   return;
        	   
        	if (state.defaultStateType == stateType)
        	   return;
        	   
        	var path:String = state.getPath(stateType);            Logger.debug(null, "DeepLinkSolver required to update [" + path + "].");
            
            //ブラウザのロケーションバーをアップデート
            SWFAddress.setValue(path);
        }

        public static function setParapeter(o:Object) : void
        {
        	if (!useSWFAddress)
        	   return;
        	   
        	var multiple:Boolean;
        	var path:String = SWFAddress.getPath();
            path += "?";
            for (var p : String in o)
            {
                path += (multiple ? "&" : "") + p + "=" + o[p];
                multiple = true;
            }
        	
            Logger.debug(null, "DeepLinkSolver required to update [" + path + "].");
            SWFAddress.setValue(path);
        }
    }
}
