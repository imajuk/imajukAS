package com.imajuk.animations 
{
    /**
     * スピードを表すデータ型
     * 
     * @author yamaharu
     */
    public class Speed extends Range
    {
        private var _acceleration:Number;

        public function Speed(min:Number, max:Number, acceleration:Number) 
        {
        	super(min, max);
            this._acceleration = acceleration;
        }
        
        public function toString() : String {
        	return "com.imajuk.animations.Speed";
        }
        
        public function get acceleration():Number
        {
            return _acceleration;
        }
    }
}
