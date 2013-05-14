package com.imajuk.site 
{

    /**
     * @author shinyamaharu
     */
    public class StateJ extends MockStateThread 
    {
        public function StateJ()
        {
            super("J");
        }
        
        [postProcess]
        public function postprocess():void
        {
        	Log.logs += "postProcess[" + name + "(" + sid + ")]";
        }
    }
}
