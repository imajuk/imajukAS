package com.imajuk.graphics 
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.utils.GraphicsUtil;
    import com.imajuk.utils.MathUtil;
    import com.imajuk.utils.StageReference;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Rectangle;


    /**
     * @author shinyamaharu
     */
    internal class AlignTestUtil 
    {
    	private static const TEST_RECT_WIDTH:int = 50;
        private static const TEST_RECT_HEIGHT:int = 100;
        internal static const TEST_SCALE:Number = -1.3;
        internal static const TEST_ROTATION : Number = 33.3;
        internal static var target : Sprite;
        private static var containers : Array = [];
        private static var debugColor:Number;
        

        /**
    	 * テスト用のスプライトを返す
    	 * 自身の原点からランダムな位置に50x100の矩形が描画されている.
    	 */
        internal static function getTestView() : Sprite
        {
        	target = new Sprite();
        	target.name = "_target_";
        	
            var drawingRect:Rectangle = 
            	new Rectangle(
            		int(MathUtil.random(-100, 100)),
            		int(MathUtil.random(-100, 100)),
            		TEST_RECT_WIDTH, 
            		TEST_RECT_HEIGHT
            	);
            	
            GraphicsUtil.drawRect(target.graphics, drawingRect, debugColor, .5);
            
            return target;
        }
        
        /**
         * ランダムな位置に配置
         */
        public static function placeRandomPos(d : DisplayObject) : void
        {
        	var stw:int = StageReference.stage.stageWidth;        	var sth:int = StageReference.stage.stageHeight;
            var x : int = int(Math.random() * stw);
            var y : int = int(Math.random() * sth);
            d.x = x;
            d.y = y;
        }
        
        /**
         * Stage上に表示されているSpriteのグローバル座標系でのバウンス
         */
        internal static function get globalPixelBounds() : Rectangle
        {
            var stw : int = StageReference.stage.stageWidth;
            var sth : int = StageReference.stage.stageHeight;
            var bitmap : BitmapData = new BitmapData(stw + 400, sth + 300, true, 0);
            
            //ターゲット以外を非表示にする
            containers.forEach(function(b:Bitmap, ...param) : void
            {
            	b.visible = false;
            });
            
            //ステージを描画
            bitmap.draw(StageReference.stage);
            
            //非表示にしたオブジェクトを元に戻す
            containers.forEach(function(b:Bitmap, ...param) : void
            {
                b.visible = true;
            });
            
            var trim:Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);
            
            //ターゲットの描画領域を返す
            return trim;
        }
        
        /**
         * コンテナ視認用ビットマップを生成し配置する
         */
        internal static function fillColor(coordinateSpace:DisplayObjectContainer, w:int = 0, h:int = 0):DisplayObjectContainer
        {
            if (w == 0)
                w = (coordinateSpace is Stage || coordinateSpace is DocumentClass) ? StageReference.stage.stageWidth : coordinateSpace.width;
            if (h == 0)
                h = (coordinateSpace is Stage || coordinateSpace is DocumentClass) ? StageReference.stage.stageHeight : coordinateSpace.height;
            
            var color : uint = coordinateSpace is Stage ? 0 : 0x11000000;
            var b : Bitmap = new Bitmap(new BitmapData(w, h, true, color));

            containers.push(coordinateSpace.addChild(b));

            return coordinateSpace;
        }
        
        internal static function testSpriteIn(coordinateSpace:DisplayObjectContainer):void
        {
            //コンテナにテスト用スプライトを追加
            coordinateSpace.addChild(target);
            
            //ランダムな座標を設定
            AlignTestUtil.placeRandomPos(target);
        }

        internal static function drawMockOrigin():void
        {
            //テスト用Spriteの原点描画用
            var displayObjectOrigin:Sprite = new Sprite();
            GraphicsUtil.drawPoint(displayObjectOrigin.graphics, DisplayObjectUtil.getGlobalPosition(target), debugColor, .7);
            StageReference.stage.addChild(displayObjectOrigin);
        }

        internal static function removeMock(coordinateSpace:DisplayObjectContainer):void
        {
            var a:Array = [];
            for (var i:int = 0;i < coordinateSpace.numChildren;i++) 
            {
                if (!(coordinateSpace.getChildAt(i) is DocumentClass))
                    a.push(coordinateSpace.getChildAt(i));
            }
            a.forEach(function(c:DisplayObject, ...param):void
            {
                coordinateSpace.removeChild(c);
            });
        }

        public static function initialize() : void
        {
        	debugColor = Math.random() * 0xFFFFFF;
        	containers = [];
        }

        public static function tearDown(coordinateSpaceTarget:DisplayObjectContainer) : void
        {
        	if (coordinateSpaceTarget)
                AlignTestUtil.removeMock(coordinateSpaceTarget);
                
            DisplayObjectUtil.removeAllChildren(DocumentClass.container);
            DisplayObjectUtil.removeAllChildren(StageReference.stage);
        }
        
    }
}
