package com.imajuk.interfaces 
{
    /**
     * @author shinyamaharu
     */
    public interface IThread 
    {
    	function get id():uint;
    	function get name():String;
    	function set name(value:String):void;
    	function get className():String;
    	function get state():uint;
    	function get isInterrupted():Boolean;
    	function start():void;
    	function join(timeout:uint = 0):Boolean;
    	function interrupt():void;
    	function toString():String;
    }
}
