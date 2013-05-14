package com.imajuk.utils 
{
    import flash.utils.clearTimeout;    
    import flash.utils.setTimeout;
    
    /**
     * @author yamaharu
     */
    public class Do 
    {
    	/**
    	 * 任意の時間待ってクロージャを実行
    	 * TODO delay, method , parm のほうがいい
    	 */
        public static function later(closure:Function, delay:uint):void
        {
            if (closure == null)
                return;
                
        	var id:uint = setTimeout(function():void
                                        {
                                            closure();
                                            clearTimeout(id);
                                        }, delay);    
        }
        
        //TODO あとDo.times()とか
        //TODO 締め切りを過ぎたらクロージャを破棄.自動にする？引数にとる？later(closure:Function, delay:int, deadline:int)
    }
}
