package com.imajuk.interfaces 
{
    /**
     * 往復を表現するためのインターフェイスです.
     * 
     * @author yamaharu
     */
    public interface IRoundTrip extends IPlayable
    {
    	/**
         * 起点
         */
        function get from():Number;
        function set from(value:Number):void;

        /**
         * 終点
         */
        function get to():Number;
        function set to(value:Number):void;

        /**
         * 終点にいるかどうか
         */
        function get isReached():Boolean;

        /**
         * 起点にいるかどうか
         */
        function get isHome():Boolean;

        /**
         * 起点にリセット
         */
        function resetToHome():void;

        /**
         * 終点にリセット
         */
        function resetToDestination():void;

        /**
         * 終点から起点へ遷移を開始する.
         */
        function reverse():Boolean;
    }
}
