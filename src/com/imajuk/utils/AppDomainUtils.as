package com.imajuk.utils
{
    import flash.system.ApplicationDomain;
    /**
     * @author imajuk
     */
    public class AppDomainUtils
    {
        public static function equals(d1 : ApplicationDomain, d2 : ApplicationDomain) : Boolean
        {
            var o1:* = d1.getDefinition("Object"),
                o2:* = d2.getDefinition("Object");
                
            return o1 === o2;
        }
    }
}
