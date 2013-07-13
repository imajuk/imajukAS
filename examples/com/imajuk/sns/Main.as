package com.imajuk.sns
{
    import fl.controls.TextInput;

    import com.bit101.components.PushButton;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    /**
     * 
     * 中国の代表的なSNSでシェアリンクを送るためのクラス.
     * 需要はないと思うけど一応..
     * 
     * a simple lib for share link with Chinese popular SNS.
     * @author imajuk
     *  
     */
    public class Main extends Sprite
    {
        public function Main()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            var sns : Array = [
                    CHINESE_SNS.RENREN, 
                    CHINESE_SNS.KAIXIN, 
                    CHINESE_SNS.DOUBAN, 
                    CHINESE_SNS.SINA, 
                    CHINESE_SNS.QQ, 
                    CHINESE_SNS.MSN
                ],
                ta   : TextInput,
                dest : String = "http://wonderfl.net",
                pic  : String = "https://www.kayac.com/img/contact/img_wonderfl.jpg";

            var that:Sprite = this;
            sns.forEach(function(sn : String, idx : int, ...param) : void
            {
                new PushButton(that, 270, 10 + idx * 20, sn, function() : void
                {
                    CHINESE_SNS.open(sn, ta.text, dest, pic, dest);
                });
            }, this);

            ta = addChild(new TextInput()) as TextInput;
            ta.width = 250;
            ta.height = 100;
            ta.x = 10;
            ta.y = 10;
            ta.text = "世界好！";
        }
    }
}
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.navigateToURL;

class CHINESE_SNS
{
    public static const RENREN : String = "RENREN";
    public static const KAIXIN : String = "KAIXIN";
    public static const DOUBAN : String = "DOUBAN";
    public static const SINA   : String = "SINA";
    public static const QQ     : String = "QQ";
    public static const MSN    : String = "MSN";

    /**
     * open new window and show SNS official form for sharing a link.
     * this method must be called in callback(event handler) by user's interaction or its call stacks,
     * otherwise some browser prevents pop up window.
     * 
     * SNSのシェアリンクページを開きます.
     * このメソッドはユーザインタラクションのコールバック内に記述する必要があります。
     * これはFlashPlayerの制限としてコールバックのスタック内でしかウィンドウのポップアップが許されていないからです。
     */
    public static function open(type : String, text : String = null, dest : String = null, pic : String = null, title : String = null) : void
    {
        var url : String = "",
        param : URLVariables = new URLVariables(),
        request : URLRequest = new URLRequest();

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
                param.title = text;
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
                url = 'http://share.v.t.qq.com/index.php?c=share&a=index&title=' + encodeURIComponent(text) + '&url=' + encodeURIComponent(dest) + '&pic=' + encodeURIComponent(pic);
                break;
            case MSN:
                url = 'http://profile.live.com/badge';
                param.title = title;
                param.url = dest;
                param.msg = text;
                param.screenshot = pic;
                break;
            default:
                throw new Error("unrecognize SNS type");
        }

        request.url = url;
        request.data = param;

        navigateToURL(request, "_blank");
    }
}