package com.imajuk.utils 
{
    import com.imajuk.commands.Command;    

    import flash.utils.getTimer;    
    import flash.text.TextFormat;    
    import flash.text.TextFormatAlign;    
    import flash.text.TextField;    
    import flash.display.Sprite;
    /**
     * @author yamaharu
     * @example
     * <listing version="3.0" >
     * var d:TraceDisplay = TraceDisplay.recordProfile("WaveClient.prepareIntro");
     * _waveClient.prepareIntro();
     * d.dumpProfile();
     * </listing>
     */
    public class TraceDisplay extends Sprite 
    {

        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        private static const STARTUP_INFO_TEXT:String = "///////////// TraceDisplay ver 0.1\n";

        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------

        private static var textfield:TextField;

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        public static function recordProfile(profileLabel:String):TraceDisplay
        {
            var time:Number = getTimer();
            var closure:Function = function():void
            {
                TraceDisplay.dumpProfileCommand(profileLabel, getTimer() - time);
            };
            
            return new TraceDisplay(new Command(closure));
        }

        
        public static function dump(text:*):void
        {
            initialize();
            textfield.appendText(String(text));
        }

        public static function clear():void
        {
            initialize();
            textfield.text = STARTUP_INFO_TEXT;
        }

        private static function initialize():void
        {
            if (!StageReference.isEnabled)
            	throw new Error("com.imajuk.utils.StageReference doesn't initialize.");
            	
            if (!textfield)
            {
                createDisplay();
                clear();
            }
        }

        private static function createDisplay():void
        {
            textfield = new TextField();
            StageReference.stage.addChild(textfield);

            textfield.background = true;
            textfield.backgroundColor = 0x000000;
            textfield.textColor = 0xFFFFFF;
            textfield.autoSize = TextFormatAlign.LEFT;
            textfield.y = 100;
            
            var fmt:TextFormat = new TextFormat();
            fmt.size = 9;
            fmt.letterSpacing = 1;
            fmt.leading = .5;
            textfield.defaultTextFormat = fmt;
        }

        private static function dumpProfileCommand(label:String, time:Number):void
        {
            dump("\t" + String(time));
            dump(" mSec.");
            dump("\t" + label + "\n");
        }

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function TraceDisplay(command:Command) 
        {
            myCommand = command;
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        private var myCommand:Command;

        
        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------

        public function dumpProfile():void
        {
            myCommand.execute();
        }
    }
}

