package com.imajuk.utils
{
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    import com.imajuk.logs.Logger;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    /**
     * required popup.js
     * @author imajuk
     */
    public class BrowserUtils
    {
        public static function OpenWindow(
                                    request : URLRequest, 
                                    windowName : String = "newWin", 
                                    width : int = 400, 
                                    height : int = 300, 
                                    location :Boolean = false, 
                                    menubar : Boolean = false, 
                                    toolbar : Boolean = false, 
                                    scrollbars : String = "auto", 
                                    resizable : String = "auto",
                                    onClose : Function = null
                                ) : void
        {
        	var useNavigateToURL : Function = 
            	function() : void
                {
                    navigateToURL(request, windowName);
                    
                    if (!ExternalInterface.available) return;
                    
                    //ウィンドウのリサイズを試みる（リンク先が同一ドメインに限り成功）
                    ExternalInterface.call("resizeWin", windowName, width, height);
                };
            
        	if (ExternalInterface.available)
            {
            	var params:String = "";
                params += "width=";
                params += width;
                params += ",height=";
                params += height;
                params += ",location=";
                params += location ? "yes" : "no";
                params += ",menubar=";
                params += menubar ? "yes" : "no";
                params += ",toolbar=";
                params += toolbar ? "yes" : "no";
                params += ",scrollbars=";
                params += scrollbars;
                params += ",resizable=";
                params += resizable;
                
                try
                {
                    var variables:String = "",
                        o:Object = request.data;
                    if (o)
                    {
                        variables = "?" + variables;
                        for (var v : String in o) {
                            variables += v + "=" + o[v];
                        }
                    }
                    trace('variables: ' + (variables));
                    ExternalInterface.call("callwin", request.url + variables, windowName, params);
                    watchWindow(onClose);
                }
                catch (e : Error)
                {
                    Logger.warning("window.open()に失敗しました.navigateToURLでウィンドウを開きます.[REASON]" + e.message);
                    useNavigateToURL();
                    watchWindow(onClose);
                }
            }
            else
            {
                Logger.warning("window.open()に失敗しました.navigateToURLでウィンドウを開きます.[REASON]ExternalInterface is not available");
                useNavigateToURL();
                watchWindow(onClose);
            }
        }

        private static function watchWindow(callback:Function) : void
        {
            if (callback == null) return;
            if (!ExternalInterface.available) return;
            
            var intvl:int = setInterval(function() : void
            {
                var result:* = ExternalInterface.call("chkwin");
                if (result || result == undefined)
                {
                    ExternalInterface.call("clearWin");
                    callback();
                    clearInterval(intvl);
                }
            }, 200);
        }

        public static function getUserAgentStrings() : String
        {
        	if (ExternalInterface.available)
                return ExternalInterface.call("eval", "navigator.userAgent.toLowerCase()");

            return "";        	
        }

        public static function getURLParameters() : Object
        {
            var o : Object = {};
        	if (ExternalInterface.available)
            {
                try
                {
            	var s:String = ExternalInterface.call("eval", "document.location.search.toString()");
                if (s.length == 0)
                    return {};
                    
            	s = s.split("?").join("");
                if (s.length == 0)
                    return {};
            	   
            	var params:Array = s.split("&");   
                params.forEach(function(param:String, ...p) : void
                {
                	var a:Array = param.split("=");
                	o[a[0]] = a[1];
                });
                }
                catch(e:Error)
                {
            	return o;
            }
            	return o;
            }
            return o;
        }
    }
}
