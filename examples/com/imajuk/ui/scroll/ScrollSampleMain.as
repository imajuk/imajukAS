﻿package com.imajuk.ui.scroll {
    import com.imajuk.constructions.DocumentClass;    import com.imajuk.logs.Logger;    import com.imajuk.ui.UIType;    import flash.display.Bitmap;    import flash.display.BitmapData;    import flash.display.StageQuality;    import org.libspark.thread.EnterFrameThreadExecutor;    import org.libspark.thread.Thread;    /**     * @author shinyamaharu     */    public class ScrollSampleMain extends DocumentClass     {        public function ScrollSampleMain()        {            super(StageQuality.HIGH);                        Thread.initialize(new EnterFrameThreadExecutor());                        Logger.filter(Logger.DEBUG, Logger.INFO);            Logger.release("ScrollSampleMain");        }        override protected function start() : void        {            minimum(15, 15);            custumApperane(255, 15);        };        private function minimum(x : int, y : int) : void         {        	//コンテンツは任意のDisplayObjectです            var content:Content = new Content();            //Scrollを可視範囲とともに生成します        	var scroll:Scroll = addChild(new Scroll(content, 200, 200)) as Scroll;        	//ScrollはDisplayObjectなので任意の位置に配置できます.(コンテンツはScrollにaddChild()されます        	scroll.x = x;            scroll.y = y;            //また他のDisplayObjectをaddChild()したり、グラフィクスを描画するのも自由です            scroll.graphics.lineStyle(2, 0xDFDFDF);            scroll.graphics.drawRect(0, 0, 200, 200);            //スクロールバーのサイズを変更できます        	scroll.scrollBarSize = 200;        	//スクロールバーのバーが0または1の位置にある時の背景とバーのマージンです            scroll.bar_bg_margin = 2;            //スクロールバーのハンドルサイズ。0より大きい値を指定するとハンドルサイズは固定されます。            //0または指定しないとハンドルはスクロール可能範囲を表すように自動的に伸縮します            scroll.handleSize = 20;                        scroll.start();        }                private function custumApperane(x : int, y : int) : void         {            var content:Content = new Content();            var bmp:Bitmap = new Bitmap(new BitmapData(content.width, content.height, true, 0));            bmp.bitmapData.draw(content, content.transform.matrix);            var scroll:Scroll = addChild(new Scroll(content, 200, 200, Bar, BarBG, Arrow)) as Scroll;            scroll.x = x;
            scroll.y = y;
            scroll.arrowtype = UIType.INTEGRATED;            scroll.barAndArrowSeparateMargin = 10;            scroll.arrowAndArrowMargin = 2;            scroll.scrollBarSize = 200;            scroll.bar_bg_margin = 1;            scroll.graphics.lineStyle(2, 0xDFDFDF);            scroll.graphics.drawRect(0, 0, 200, 200);//            scroll.handleSize = 20;            addChild(scroll);            scroll.start();        }
    }}import com.imajuk.ui.scroll.view.NullArrow;
import flash.display.BitmapData;
import com.imajuk.ui.scroll.view.Bar;
import com.imajuk.ui.IUIView;
import com.imajuk.utils.MathUtil;import flash.display.Shape;import flash.display.Sprite;import flash.filters.BevelFilter;
class Content extends Sprite{    public function Content()     {        for (var i : int = 0;i <= 200;i++)         {            var s : Shape = new Shape();            s.graphics.beginFill(Math.random() * 0xFFFFFF);            s.graphics.drawRoundRect(-10, -10, 20, 20, Math.random() * 20, Math.random() * 20);            s.graphics.endFill();            s.x = MathUtil.random(-20, 200);            s.y = MathUtil.random(0, 1000);            s.rotation = Math.random() * 360;            s.filters = [new BevelFilter(1, 45, 0xFFFFFF, .5, 0, .5, 2, 2)];            addChild(s);        }                graphics.lineStyle(1);        graphics.moveTo(0, 0);        graphics.lineTo(200, 0);    }}class Arrow extends NullArrow implements IUIView{    public function Arrow()     {        graphics.beginFill(0xCCCCCC);        graphics.drawCircle(0, 0, 5);        graphics.endFill();        graphics.beginFill(0xFFFFFF);        graphics.moveTo(0, -2);        graphics.lineTo(3, 1);        graphics.lineTo(-3, 1);        graphics.lineTo(0, -2);        graphics.endFill();                buttonMode = true;                _size = width;    }}class Bar extends com.imajuk.ui.scroll.view.Bar implements IUIView{    override public function set externalHeight(value : int) : void    {    	graphics.clear();                var b:BitmapData = new BitmapData(2, 2, false, 0x5555CC);        b.setPixel(0, 0, 0xFFCCCCFF);        b.setPixel(1, 0, 0xFFCCCCFF);        graphics.beginBitmapFill(b);        graphics.drawRect(-3, 0, 6, value);    }}class BarBG extends com.imajuk.ui.scroll.view.Bar implements IUIView{	override public function set externalHeight(value : int) : void    {        graphics.clear();        var b:BitmapData = new BitmapData(2, 2, true, 0);        b.setPixel32(0, 0, 0xFFCCCCFF);        b.setPixel32(1, 1, 0xFFCCCCFF);        graphics.beginBitmapFill(b);        graphics.drawRect(-4, 0, 8, value);    }}