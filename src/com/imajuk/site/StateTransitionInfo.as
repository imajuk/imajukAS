package com.imajuk.site
{
    import org.libspark.thread.Thread;
    /**
     * @author imajuk
     */
    internal class StateTransitionInfo
    {
    	/**
    	 * 実行される予定のステート
    	 */
        internal var queue : Array;
        /**
         * 実行中のステートを終了するThread
         */
        internal var interruption : Thread;

        public function StateTransitionInfo(queue : Array, interruption : Thread)
        {
            this.queue = queue;
            this.interruption = interruption;
        }
    }
}
