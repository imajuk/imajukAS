package com.imajuk.service
{
    import co.uk.mikestead.net.URLFileVariable;
    import co.uk.mikestead.net.URLRequestBuilder;

    import com.adobe.serialization.json.JSON;
    import com.imajuk.logs.Logger;
    import com.imajuk.utils.ObjectUtil;

    import org.libspark.thread.Thread;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * jQueryの$.ajax()メソッドと互換性のあるオブジェクト
     * JSからASに移植する際に使用
     * 
     * @author imajuk
     */
    public class Ajax extends EventDispatcher
    {
        public static const TYPE_JSON : String = "json";
        private static const TYPE_XML : String = "xml";
        public var debug : Boolean;
        private var checkingTimeout : uint;
        private var error : Function;
        private var success : Function;
        private var timeout : Function;
        private var loader : URLLoader;
        private var dataType : String;

        /**
         * @param timeoutSec    タイムアウト（秒）
         */
        public function access(param : Object, timeoutSec : Number = 10, binaryUploading:Boolean = false) : void
        {
            var url      : String = param.url,
                method   : String = param.type,
                variable : URLVariables = new URLVariables(),
                request  : URLRequest = new URLRequest(),
                data     : Object = param.data;
                
            if (!url || url.length <= 0)
                throw new Error("URL is not found.");

            // callback when success
            success = param.success;

            // callback when error
            error = param.error;

            // callback when timeout
            timeout = param.timeout;
            
            // data type (json or xml)
            dataType = param.dataType;
            
            delete param.url;
            delete param.type;
            delete param.dataType;
            delete param.success;
            delete param.error;
            delete param.timeout;
            
            
            // variables
            for (var prop : String in data)
                variable[prop] = data[prop];

            if (binaryUploading)
            {
                variable.bin = new URLFileVariable(variable.bin, "e-card");   
                request = new URLRequestBuilder(variable).build();
            }
            else
                request.data = variable;
                
            request.url = url;
            request.method = method;

            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onSuccess);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            // loader.addEventListener(Event.OPEN, openHandler);
            // loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            // loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);

            checkingTimeout = setTimeout(function() : void
            {
                loader.close();
                timeout({reason:"timeout"});
            }, timeoutSec * 1000);

            try
            {
                loader.load(request);
            }
            catch (error : Error)
            {
                stopCheckingTImeout();
                Logger.warning("Unable to load requested document.[REASON]" + error.message);
            }
        }

        private function stopCheckingTImeout() : void
        {
            clearTimeout(checkingTimeout);
        }

        private function onSuccess(event : Event) : void
        {
            stopCheckingTImeout();
            
            var response    : *,
                dumpRowData : Function = function():void
                {
                    ObjectUtil.dump(loader.data);
                };
                
            if (debug) dumpRowData();
            
            try{
                switch(dataType)
                {
                    case TYPE_JSON:
                        response = JSON.decode(loader.data);
                        break;
                    case TYPE_XML:
                        response = XML(loader.data);
                        break;
                }
            }
            catch(e:Error)
            {
                Logger.warning("parsing result was failed.[REASON]" + e.message);
                dumpRowData();
            }
                
            success(response);
            
            dispatchEvent(new AjaxEvent(AjaxEvent.SUCCESS));
        }

        private function onError(event : Event) : void
        {
            stopCheckingTImeout();
            error({reason:event.type});
        }

        /**
         * jQuery.ajax()にわたすパラメータと互換があります
         * バイナリをアップロードする場合はuploadBin: trueを使用します.
         * 
         * パラメータ例
         * param : Object = 
                {
                    dataType : "json", 
                    cache    : false, 
                    url      : API.POST, 
                    type     : "POST", 
                    data     : data,
                    uploadBin: true,
                    success  : function(responce:Object):void{onCallback(responce);}, 
                    error    : function(responce:Object):void{onLoginError(responce);}, 
                    timeout  : function(responce:Object):void{onLoginError(responce);}
                };
         */
        public static function access(param : Object, timeoutSec:int = 10) : Thread
        {
            return new AjaxThread(param, timeoutSec);
        }
    }
}
import com.imajuk.service.Ajax;
import com.imajuk.service.AjaxEvent;

import org.libspark.thread.Thread;

class AjaxThread extends Thread 
{
    private var param      : Object;
    private var ajax       : Ajax;
    private var timeoutSec : int;

    public function AjaxThread(param : Object, timeoutSec:int)
    {
        super();
        this.param = param;
        this.timeoutSec = timeoutSec;
        
        var f_success : Function = param.success,
            f_error   : Function = param.error,
            f_timeout : Function = param.timeout;
        
        param.error = function(a:Object):void{
            try
            {
                f_error(a);
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.ACCESS_WAS_ERROR));
            }
            catch(e:Error)
            {
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.ACCESS_WAS_ERROR_ALSO_ERROR_IN_CALLBACK + "[REASON]" + e.message));
            }
        };
        param.timeout = function(a:Object):void{
            try
            {
                f_timeout(a);
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.ACCESS_WAS_TIMEOUT));
            }
            catch(e:Error)
            {
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.ACCESS_WAS_TIMEOUT_AND_ERROR_IN_CALLBACK + "[REASON]" + e.message));
            }
        };
        param.success = function(a:Object):void{
            try
            {
                f_success(a);
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.SUCCESS));
            }
            catch(e:Error)
            {
                ajax.dispatchEvent(new AjaxEvent(AjaxEvent.ACCESS_WAS_SUCCESS_BUT_ERROR_IN_CALLBACK + "[REASON]" + e.message));
            }
            interrupt();
        };
    }

    override protected function run() : void
    {
        if (isInterrupted) return;
        interrupted(function():void{});
        
        ajax = new Ajax();
        ajax.access(param, timeoutSec, param.hasOwnProperty("uploadBin"));
        
        event(ajax, AjaxEvent.ACCESS_WAS_ERROR, function(e:AjaxEvent) : void
        {
            throw new Error(e.type);
        });
        event(ajax, AjaxEvent.ACCESS_WAS_ERROR_ALSO_ERROR_IN_CALLBACK, function(e:AjaxEvent) : void
        {
            throw new Error(e.type);
        });
        event(ajax, AjaxEvent.SUCCESS, function() : void
        {
        });
        event(ajax, AjaxEvent.ACCESS_WAS_SUCCESS_BUT_ERROR_IN_CALLBACK, function(e:AjaxEvent) : void
        {
            throw new Error(e.type);
        });
    }

    override protected function finalize() : void
    {
    }
}
