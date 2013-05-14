package com.imajuk.logs
{

    /**
     * @author imajuk
     */
    public class BasicTrace implements IOutput
    {
        public function log(string : String) : void
        {
        	trace(string);
        }
    }
}
