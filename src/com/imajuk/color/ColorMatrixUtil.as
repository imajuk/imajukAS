package com.imajuk.color 
{
    import flash.filters.ColorMatrixFilter;    
    /**
     * @author yamaharu
     */
    public class ColorMatrixUtil 
    {
        private static const IDENTITY:Array = [ 1,	0,	0,	0,	0,
						   						0,	1,	0,	0,	0,
						  						0,	0,	1,	0,	0,
						  						0,	0,	0,	1,	0 ];

        /**
         * 明るさを変更するマトリックスを返します.
         * @param amount	-255 ~ 255の値を取ります.
         * 					-255は完全に黒、255は完全に白、0は変更なしとなります.
         * @return			カラー変換が適用されたColorMatrixFilter
         * @internal
         * rscale, 0.0,    0.0,    0.0,
         * 0.0,    gscale, 0.0,    0.0,
         * 0.0,    0.0,    bscale, 0.0,
         * 0.0,    0.0,    0.0,    1.0
         */
        public static function brightness(amount:Number):ColorMatrixFilter
        {
            return new ColorMatrixFilter([ 1,		0,		0,		0,		amount,
					   						0, 		1,		0,		0,		amount,
					  						0,		0,		1,		0,		amount,
					  						0,		0,		0,		1,		0 ]);
        }

        /**
         * @internal
         * 1.0,		0.0,    0.0,    roffset,
         * 0.0,    	1.0,	0.0,    goffset,
         * 0.0,    	0.0,    1.0,	boffset,
         * 0.0,		0.0,	0.0,	1.0
         */
        public static function offset(r:Number = 0, g:Number = 0, b:Number = 0, a:Number = 0):Array
        {
            return [ 1,		0,		0,		0,		r,
   						0, 		1,		0,		0,		g,
  						0,		0,		1,		0,		b,
  						0,		0,		0,		1,		a ];
        }

        /**
         * カラーを反転するマトリックスを返します.
         * @param amount	0 ~ 255の値を取ります.
         * 					255は完全に反転、0以下の値は変更なしとなります.
         * @return			カラー変換が適用されたColorMatrixFilter
         * @internal
         * -1.0,	0.0,    0.0,    amount,
         *  0.0,	-1.0,	0.0,    amount,
         *  0.0,	0.0,    -1.0,	amount,
         *  0.0,    0.0,    0.0,    1.0
         */
        public static function invert(amount:Number):ColorMatrixFilter
        {
            if(amount <= 0)
            	return new ColorMatrixFilter(IDENTITY);
            amount = Math.min(amount, 255);

            return new ColorMatrixFilter([ -1,		0,		0,		0,		amount,
					   						0, 		-1,		0,		0,		amount,
					  						0,		0,		-1,		0,		amount,
					  						0,		0,		0,		1,		0 ]);
        }

        /**
         * カラーを着色するマトリックスを返します.
         * @param rgb		0x000000 ~ 0xFFFFF (32bit) の値を取ります.
         * @param amount	0 ~ 1 の値を取ります.
         * 					1は渡した色に完全に着色,0は変更なしとなります.
         * @return			カラー変換が適用されたColorMatrixFilter
         * @internal
         * 以下サイトのコードからほぼそのまま引っ張ってきた
         * http://www.quasimondo.com/archives/000565.php
         */
        public static function colorize(rgb:int, amount:Number = 1):ColorMatrixFilter
        {
            var r:Number;
            var g:Number;
            var b:Number;
            var inv_amount:Number;
            
            r = (((rgb >> 16) & 0xFF) / 0xFF);
            g = (((rgb >> 8) & 0xFF) / 0xFF);
            b = ((rgb & 0xFF) / 0xFF);
            inv_amount = (1 - amount);            
            return new ColorMatrixFilter([
						            		(inv_amount + (amount * r)),	(amount * r),				amount * r,					0, 0, 
						            		amount * g,						(inv_amount + amount * g),	amount * g,					0, 0, 
						            		amount * b,						amount * b,					inv_amount + amount * b,	0, 0, 
						            		0,								0,							0,							1, 0 ]);
        }
    }
}
