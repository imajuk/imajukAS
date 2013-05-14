package com.imajuk.data 
{

    /**
     * TODO write tests
     * @author shinyamaharu
     */
    public class VectorIterator implements IIterator
    {
    	//--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * コンストラクタ.
         * 
         * <p>走査したい<code>Array</code>を渡します.</p>
         * <p>set iterated Array</p>
         * 
         * @param array 走査したい<code>Array</code>.
         *              <p>iterated <code>Array</code></p>
         */
        public function VectorIterator(vector:*) 
        {
            _position = 0;
            myVector = vector;
        }   

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var myVector:Vector.<*>;

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var _position:Number;

        /**
         * @copy IIterator#position
         */
        public function get position():int
        {
            return _position;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
        
        /**
         * まだイテレートする対象があるかどうかを返します.
         * 
         * <p>Returns whether component has a next iterated object.</p>
         */
        public function hasNext():Boolean
        {
            return _position < myVector.length;
        }   

        /**
         * イテレーションの次の対象を返します.
         * 
         * <p>Returns a next iterated object.</p>
         */
        public function next():*
        {
            return myVector[_position ++];
        }
        
        public function clone():VectorIterator
        {
            return new VectorIterator(myVector.concat());
        }
    }
}
