package com.imajuk.interfaces 
{
    /**
     * @author shin.yamaharu
     */
    public interface IPlayable 
    {
    	function get state () : String;
        
        /**
         * Start playing.
         */
        function start () : Boolean;
        
        /**
         * Stop playing.
         */
        function stop () : Boolean;
        
        /**
         * Pause play.
         */
        function pause () : Boolean;
        
        /**
         * Resume paused play.
         */
        function resume () : Boolean;
    }
}
