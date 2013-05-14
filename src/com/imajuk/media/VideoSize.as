package  
com.imajuk.media
{
    import com.imajuk.utils.StageReference;
    /**
     * @author shinyamaharu
     */
    public class VideoSize 
    {
        public static const HORIZON_FIT_TO_STAGE : String = "HORIZON_FIT_TO_STAGE";
        public static const USE_ORIGINAL_SIZE    : String = "USE_ORIGINAL_SIZE";
        public static const FIXED_SIZE           : String = "CUSTUM";
        //ビデオの比率を変えずにステージサイズに最大に収まるサイズ
        public static const SHOW_ALL_IN_STAGE    : String = "SHOW_ALL";
        
        public var mode : String;
        public var custumWidth : int;
        public var custumHeight : int;
        internal var originalWidth : int;        internal var originalHeight : int;

        public function VideoSize(mode : String, custumWidth : int = 0, custumHeight : int = 0) 
        {
            this.mode = mode;
            this.custumWidth = custumWidth;
            this.custumHeight = custumHeight;
        }
        
        public function toString() : String {
        	return "VideoSize[" + [mode, custumWidth, custumHeight] + "]";
        }

        /**
         * モードを解決しビデオの幅を返します
         */
        public function get width() : int 
        {
        	var w:int;
        	switch(mode)
            {
                case VideoSize.HORIZON_FIT_TO_STAGE:
                    w = StageReference.stage.stageWidth;
                    break;
                    
                case VideoSize.FIXED_SIZE :
                    w = custumWidth;
                    break;
                    
                case USE_ORIGINAL_SIZE :
                    w = originalWidth;
                    break;
            }
            return w;
        }
    }
}
