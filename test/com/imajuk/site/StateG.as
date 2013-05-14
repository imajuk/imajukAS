package com.imajuk.site 
{

    /**
     * @author shinyamaharu
     */
    public class StateG extends MockStateThread 
    {
    	[inject]
    	public var view:ViewA;
    	
        public function StateG()
        {
            super("G");
        }
    }
}
