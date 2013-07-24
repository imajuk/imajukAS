package com.imajuk.logs
{
    import com.imajuk.utils.StageReference;
    import flash.display.Stage;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    /**
     * @author imajuk
     */
    internal class STTxField implements IOutput
    {
        private static var DEBUG : TextField;
        
        public function STTxField()
        {
            build();
        }

        private function build() : Boolean
        {
            const stage : Stage = StageReference.stage;
            if (!stage) return false;
            if (DEBUG)  return true;

            DEBUG = new TextField();
            DEBUG.width = 500;
            DEBUG.height = 500;
            DEBUG.autoSize = TextFieldAutoSize.LEFT;
            stage.addChild(DEBUG);

            const tfm : TextFormat = new TextFormat();
            tfm.size = 20;
            DEBUG.defaultTextFormat = tfm;
            
            return true;
        }


        public function log(s : String) : void
        {
            if (!build()) return;
            
            DEBUG.appendText("\n" + s);
        }
    }
}
