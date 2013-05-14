package com.imajuk.ui.scroll 
{
    /**
     * @author imajuk
     */
    public class ScrollCaluculator 
    {
        private var inputBase : int;
        private var outputBase : int;
        private var outputTarget : int;

        public function ScrollCaluculator(inputBase : int, outputBase : int, outputTarget : int) 
        {
            this.outputTarget = outputTarget;
            this.outputBase = outputBase;
            this.inputBase = inputBase;
        }

        public function get isNeedScroll() : Boolean
        {
            return outputTarget > outputBase;
        }

        public function getDestination(inputValue : Number) : int
        {
            var normalizedPos : Number = inputValue / inputBase;
            var diff : Number = outputTarget - outputBase;
            return -diff * normalizedPos;
        }
    }
}
