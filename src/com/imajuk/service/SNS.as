package com.imajuk.service
{
    import flash.display.StageDisplayState;
    import com.imajuk.utils.StageReference;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    
    /**
     * 代表的なSNSでリンクシェアまたはツィートするためのクラスです.
     * 
     * @author imajuk
     */
    public class SNS
    {
        public static const RENREN  : String = "RENREN";
        public static const KAIXIN  : String = "KAIXIN";
        public static const DOUBAN  : String = "DOUBAN";
        public static const SINA    : String = "SINA";
        public static const QQ      : String = "QQ";
        public static const QQ_ZONE : String = "QQ_ZONE";
        public static const MSN     : String = "MSN";
        private static var defaultText        : String = "";
        private static var defaultTitle       : String = "";
        private static var defaultDestination : String = "";
        private static var defaultImage       : String = "";
        private static var isInitialized : Boolean;
        
        public static function initialize(
                                    destination:String, 
                                    defaultText:String, 
                                    defaultImage:String = "",
                                    defaultTitle:String = ""
                                ) : void
        {
            isInitialized          = true;
            SNS.defaultText        = defaultText || "";
            SNS.defaultImage       = defaultImage || "";
            SNS.defaultDestination = destination || "";
            SNS.defaultTitle       = defaultTitle || "";
        }
        
        /**
         * SNSのシェアリンクページを開きます.
         * このメソッドはユーザインタラクションのコールバック内に記述する必要があります。
         * これはFlashPlayerの制限としてコールバックのスタック内でしかウィンドウのポップアップが許されていないからです。
         */
        public static function open(type:String, text:String = null, dest:String = null, pic:String = null, title:String = null):void
        {
            if (!isInitialized)
            {
                if (!text || text.length==0)
                    throw new Error("SNS not initialized and has no any default texts.");
            }
            
            text  = !text ? defaultText : text;
            dest  = !dest ? defaultDestination : dest;
            pic   = !pic  ? defaultImage : pic;
            title = !title  ? defaultTitle : title;
            
            var url:String = "",
                param:URLVariables = new URLVariables(),
                request:URLRequest = new URLRequest();
            
            switch(type)
            {
                case SINA:
                    url = 'http://v.t.sina.com.cn/share/share.php';
                    param.url = dest;
                    param.title = text;
                    param.pic = pic;
                    break;
                    
                case RENREN:
                    url = 'http://widget.renren.com/dialog/share';
                    param.resourceUrl = dest;
                    param.title = title;
                    param.pic = pic;
                    break;
                    
                case KAIXIN:
                    url = "http://www.kaixin001.com/rest/records.php";
                    param.url = dest;
                    param.content = text;
                    param.style = 11;
                    break;

                case DOUBAN:
                    url = 'http://shuo.douban.com/!service/share';
                    param.href = dest;
                    param.name = text;
                    param.image = pic;
                    break;

                case QQ:
                    url = 
                        'http://share.v.t.qq.com/index.php?c=share&a=index&title=' + encodeURIComponent(title) + 
                        '&url=' + encodeURIComponent(dest) + 
                        '&pic=' + encodeURIComponent(pic);
                    break;

                case QQ_ZONE:
                    url = 
                        'http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=' + encodeURIComponent(dest) + 
                        '&title=' + encodeURIComponent(title);
                    break;

                case MSN:
                    url = 'http://profile.live.com/badge';
                    param.title = title;
                    param.url = dest;
                    param.msg  = text;
                    param.screenshot = pic;
                    break;
                    
                default:
                    throw new Error("unrecognize SNS type");
            }
            
            request.url = url;
            request.data = param;
            
            StageReference.stage.displayState = StageDisplayState.NORMAL;
            navigateToURL(request, "_blank");
        }
    }
}
