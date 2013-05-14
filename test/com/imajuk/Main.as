package com.imajuk
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;

    import org.libspark.as3unit.runner.AS3UnitCore;


	/**
	 * the test must be run with compiler option '-keep-as3-metadata=inject'
	 * 
	 * @author yamaharu
	 */
	public class Main extends DocumentClass 
    {
        public static const testDir : String = "file:///Users/imajuk/Documents/workspace5/imajuk_trunk/test/";

        public function Main () 
		{
		}
		
		override protected function start():void
        {
            Logger.show(Logger.DEBUG);
        	Logger.release("imajukLib testing...");
        	
			AS3UnitCore.main(AllTests);
        }
	}
}