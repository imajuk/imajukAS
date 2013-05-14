package com.imajuk.logs 
{
    import flash.system.Capabilities;
    /**
     * @author shinyamaharu
     */
    public class Logger 
    {
        public static const INFO_MARK0 : String = "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯";        public static const INFO_MARK1 : String = "> ";        public static const INFO_MARK2 : String = "# ";
        public static const DEBUG_MARK : String = ">> ";
        public static const INTERNAL_MARK : String = "<< ";
        private static const WARNING_MARK : String = "\n((( !WARNIG! ";        private static const RELEASE_MARK : String = "//--------------------------------------------------------------------------";
        private static const ERROR_MARK : String = "////////////////////////////////////////////////////";
        public static const INFO : uint         = parseInt("10000000", 2);
        public static const DEBUG : uint        = parseInt("01000000", 2);
        public static const WARNING : uint      = parseInt("00100000", 2);
        public static const RELEASE : uint      = parseInt("00010000", 2);
        public static const ERROR : uint        = parseInt("00001000", 2);
        public static const INTERNAL : uint     = parseInt("00000001", 2);
        public static const NO_FILTER : uint    = parseInt("00000000", 2);
        private static var currentFilter : uint = parseInt("00111000", 2);
        
        public static const BASIC       : IOutput = new BasicTrace();
        public static const EXTERNAL    : IOutput = new ExternalTrace();
        public static var destination : IOutput = BASIC;

        public static function info(level:int, ...param) : void 
        {
        	var s:String = "";
        	var indent:String = 
        	   new Array(level).map(function(...param):String{return s+= "  ";}).join("");
        	
        	var prefix:String  = "";
        	var postfix:String = "";
        	switch(level)
            {
                case 0:
                    prefix = INFO_MARK0 + "\n" + indent;
                    postfix = "\n" + indent + INFO_MARK0;
                    break;
                case 1:
                    prefix = INFO_MARK1;                    postfix = "";
                    break;
                case 2:
                    prefix = INFO_MARK2;                    postfix = "";
                    break;
            }        	
        	
            if ((currentFilter & INFO) >> 7 == 1)
        	   destination.log(indent + prefix + param + postfix);
        }

        public static function debug(caller:*, ...param) : void 
        {
            var m:String = "";
        	if (caller != null)
        	{
                try
                {
                    throw new Error();
                }
                catch(e:Error)
                {
                	m = Capabilities.isDebugger ? e.getStackTrace().split("\n")[2].split("/")[1].split("()").join("") : "";
                }
        	}
            var c : String = (caller == null) ? "" : caller.toString() + " : ";
            
            param = param.map(function(o : *, ...param):*
            {
            	return " " + o.toString();
            });
            
            if ((currentFilter & DEBUG) >> 6 == 1)
               destination.log(DEBUG_MARK + c + m + " ( " + param + " )");
        }
        
        public static function warning(...param) : void 
        {
            if ((currentFilter & WARNING) >> 5 == 1)
               destination.log(WARNING_MARK + param + ")))\n");
        }
        
        public static function release(...param) : void 
        {
        	//--------------------------------------------------------------------------
            //
            //  Constructor
            //
            //--------------------------------------------------------------------------
        	if ((currentFilter & RELEASE) >> 4 == 1)
        	{
        		var d:Date = new Date();
        		var date:String = "\n//\n//\t" + d.toLocaleDateString() + " " + d.toLocaleTimeString();
                param = param.map(
                    function(s:*, ...param) : *
                    {
                    	if (s is String)
                    	   return s.split("\n").join("\n// ");
                    	else
                    	   return s;
                    }
                );
                destination.log("\n\n\n" + RELEASE_MARK + "\n//\n// " + param + date + "\n//\n" + RELEASE_MARK + "\n");
        	}
        }

        public static function error(e : Error, errorOccured : * = null, message:String = null) : void         {
            if ((currentFilter & ERROR) >> 3 == 1)
            {
                var stackTrace : String = "";
                var reason:String = "\n";
                if (Capabilities.isDebugger)
                {
                    stackTrace = e.getStackTrace() + "\n";
                    reason = "\n[REASON] " + stackTrace; 
                }
                destination.log("\n" + ERROR_MARK + "\n" + (message || "a error occured in ") + errorOccured + reason + ERROR_MARK);
            }        }

        private static function internalLog(...param) : void 
        {
        	if ((currentFilter & INTERNAL) == 1)
               destination.log(INTERNAL_MARK + param);
        }
        
        public static function filter(...param) : void 
        {
            param.forEach(function(filter : uint, ...p):void
            {
                currentFilter = currentFilter | filter;
            });
            internalLog("filtered : " + currentFilter.toString(2));
        }

        public static function ignore(...param) : void 
        {
        	param.forEach(function(filter : uint, ...p):void
            {
                currentFilter = currentFilter ^ filter;
            });
            internalLog("ignored : " + currentFilter.toString(2));
        }

        public static function show(...filters : Array) : void 
        {
            filters.forEach(function(add:uint, ...param) : void
            {
                currentFilter = currentFilter | add;
            });
        }


        public static function reset() : void 
        {
        	currentFilter = NO_FILTER;
        }
    }
}
