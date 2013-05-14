package com.imajuk.sns
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
    /**
     * @author imajuk
     */
    public class CHINESE_SNS
    {
        public static const RENREN : String = "RENREN";
        public static const KAIXIN : String = "KAIXIN";
        public static const DOUBAN : String = "DOUBAN";
        public static const SINA   : String = "SINA";
        public static const QQ     : String = "QQ";
        public static const MSN    : String = "MSN";
        public static const QZONE  : String = "QZONE";
    
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
                    url = 'http://service.weibo.com/share/share.php';
                    if (dest) param.url = dest;
                    if (text) param.title = text;
                    if (pic) param.pic = pic;
                    break;
                case RENREN:
                    url = 'http://widget.renren.com/dialog/share';
                    if (dest) param.resourceUrl = dest;
                    if (text) param.title = text;
                    if (pic) param.pic = pic;
                    break;
                /**
                 * 开心网
                 * http://open.kaixin001.com/document.php?type=records
                 */
                case KAIXIN:
                    url = "http://www.kaixin001.com/rest/records.php";
                    if (dest) param.url = dest;
                    if (text) param.content = text;
                    param.style = 11;
                    break;
                case DOUBAN:
                    url = 'http://shuo.douban.com/!service/share';
                    if (dest) param.href = dest;
                    if (text) param.name = text;
                    if (pic) param.image = pic;
                    break;
                /**
                 * Tencent
                 * http://open.t.qq.com/apps/share/explain.php
                 * NOTE:QQ系はパラメータの順序が重要
                 */
                case QQ:
                    url = 'http://share.v.t.qq.com/index.php?c=share&a=index';
                    if (text) url += '&title=' + encodeURIComponent(text);
                    if (dest) url += '&url=' + encodeURIComponent(dest);
                    if (pic) url += '&pic=' + encodeURIComponent(pic);
                    break;
                /**
                 * QQ空间
                 * http://imgcache.qq.com/qzone/app/qzshare/onekey.html
                 * NOTE:QQ系はパラメータの順序が重要
                 */
                case QZONE:
                    url = 'http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey';
                    if (dest) url += '?url=' + encodeURIComponent(dest);
                    if (text) url += '&title=' + encodeURIComponent(text);
                    break;
                case MSN:
                    url = 'http://profile.live.com/badge';
                    if (title) param.title = title;
                    if (dest) param.url = dest;
                    if (text) param.msg = text;
                    if (pic) param.screenshot = pic;
                    break;
                default:
                    throw new Error("unrecognize SNS type");
            }
    
            request.url = url;
            request.data = param;
    
            navigateToURL(request, "_blank");
        }
    }
}
