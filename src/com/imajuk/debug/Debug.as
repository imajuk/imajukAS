package com.imajuk.debug
{
    import flash.system.Capabilities;
    /**
     * @author imajuk
     */
    public class Debug
    {
        public static function traceStackTrace(message:String="") : void
        {
            if (!Capabilities.isDebugger)
                return;
                
            try
            {
                throw new Error();
            }
            catch(e : Error)
            {
                var s:String = e.getStackTrace();
                var p:RegExp = /at\s(.*)\(\)/g;
                var a:Array = s.match(p);
                if (a)
                {
                    a[0] = message;
//                    a = a.slice(1);
                    trace(a.splice(",").join("\n"));
                }
            }
        }
    }
}
