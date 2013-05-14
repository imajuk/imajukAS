package com.imajuk.ropes.effects
{

    /**
     * @author imajuk
     */
    public class EffectUtil
    {
        /**
         * example
         * [1,   5,                  15,   85,                  95,  110], //key frames
         * [0,   0,                   1,    1,                   0,    0], //effect levels (0~1)
         * [  null, Quadratic.easeInOut, null, Quadratic.easeInOut, null]  //easings among keyframes
         */
        public static function createMask(points:Array, value:Array, easings:Array) : Vector.<Number>
        {
            if (points.length != value.length) throw new Error('invalid parameter.');
            if (easings.length != points.length-1) throw new Error('invalid easing parameter.');
            
            const last_point_id : int = points.length - 1;
            
            var    effectMask : Vector.<Number> = new Vector.<Number>(),
                next_point_id : int,
                       easing : Function,
                            i : int,
                            j : int,
                            k : int,
                            v : Number;
                
            for (i = 0; i < last_point_id; i++)
            {
                next_point_id = points[i + 1];
                       easing = easings[i];
                            v = value[i];
                
                for (j = k; j < next_point_id; j++)
                {
                    if (easing is Function)
                        effectMask[j] = easing(j - k, v, value[i + 1] - v, next_point_id - k);
                    else
                        effectMask[j] = v;
                }
                k = j;
            }
            
            
            return effectMask;
        }

        public static function invertMask(effectMask : Vector.<Number>) : Vector.<Number>
        {
            var result : Vector.<Number> = effectMask.concat();
            for (var i : int = 0, l : int = result.length; i < l; i++)
            {
                result[i] = 1 - result[i];
                trace('i: ' + (i), result[i]);
            }
            return result;
        }
    }
}
