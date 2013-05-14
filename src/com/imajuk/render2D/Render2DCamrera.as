package com.imajuk.render2D
{
    import flash.geom.Matrix;

    /**
     * @author shinyamaharu
     */
    public class Render2DCamrera
    {
        public static const TOP : String = "TOP";
        public static const CENTER : String = "CENTER";
        public var transformPoint : String = CENTER;
        public var width : int;
        public var height : int;
        public var x : Number = 0;
        public var y : Number = 0;
        public var rad : Number = 0;
        private var _scale : Number = 1;

        private var initX : Number;
        private var initY : Number;
        private var initScale : Number;
        private var _actualScale : Number;

        /**
         * コンストラクタを直接呼び出す事は非推奨です.
         * カメラはRender2D.createCamera()メソッドで生成してください.
         * 
         * @param width     ターゲット座標系におけるカメラのサイズ（ピクセル）です.
         * @param height    ターゲット座標系におけるカメラのサイズ（ピクセル）です.
         */
        public function Render2DCamrera(width : int, height : int, x : Number = 0, y : Number = 0, scale : Number = 1)
        {
            this.width = width;
            this.height = height;
            this.x = x;
            this.y = y;
            this._scale = scale;
            this._actualScale = 1 / _scale;

            initX = x;
            initY = y;
            initScale = _scale;
        }

        public function get centerX() : Number
        {
            return x + width * _actualScale * .5;
        }

        public function get centerY() : Number
        {
            return y + height * _actualScale * .5;
        }

        // public function rotate(value : Number) : void
        // {
        // var m : Matrix = new Matrix(1, 0, 0, 1, x, y);
        //
        // m.concat(rm1);
        // m.rotate(value);
        // m.concat(rm2);
        //
        // x = m.tx;
        // y = m.ty;
        // rad += value;
        // }

        public function reset() : void
        {
            x = initX;
            y = initY;
            _scale = initScale;
        }

        /**
         * ワールド座標系でのカメラの左端の座標
         */
        public function get left() : Number
        {
            return x;
        }

        /**
         * ワールド座標系でのカメラの右端の座標
         */
        public function get right() : Number
        {
            return x + width * (_actualScale);
        }

        public function get scale() : Number
        {
            return _scale;
        }

        public function set scale(value : Number) : void
        {
            // 実際のスケール
            var s : Number = _actualScale;
            // 目標のスケール
            var s2 : Number = 1 / value;
            // 係数
            var s3 : Number = s2 / s;
            // 変形の原点
            var cx : Number, cy : Number;
            switch(transformPoint)
            {
                case TOP:
                    cx = centerX;
                    cy = y;
                    break;
                case CENTER:
                    cx = centerX;
                    cy = centerY;
                    break;
            }

            var m : Matrix = new Matrix(s, 0, 0, s, x, y);

            m.translate(-cx, -cy);
            m.scale(s3, s3);
            m.translate(cx, cy);

            x = m.tx;
            y = m.ty;
            _scale = value;
            _actualScale = 1 / _scale;
        }

        public function get actualWidth() : Number
        {
            return width * _actualScale;
        }

    }
}
