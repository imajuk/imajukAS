package com.imajuk.ropes.effects
{
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;


    /**
     * @author imajuk
     */
    public class Effect
    {
        private var effect : Array = [];
        private var length : uint;
        private var dic : Dictionary = new Dictionary(true);

        public function Effect(...effects)
        {
            effects.forEach(function(e : IEffect, ...param) : void
            {
                add(e);
            });
        }

        public function toString() : String
        {
            return "Effect[" + effect.toString() + "]";
        }

        public function exec(cp : ControlPoint, model:IRopeShape) : void
        {
            //コントロールポイントを初期位置に戻す
            cp.reset();
            
            if (length == 0) return;

            var i       : int,
                applied : Point;
            // エフェクトの結果（相対値）

            //最初のエフェクトを実行
            applied = IEffect(effect[i++]).exec(cp, model);
            cp.x = applied.x;
            cp.y = applied.y;
            
            //2個目以降のエフェクトがあるなら順次ミックス
            while (i < length)
            {
                applied = IEffect(effect[i++]).exec(cp, model);
                cp.x = (cp.x + applied.x) * .5;
                cp.y = (cp.y + applied.y) * .5;
            }
        }

        public function add(e : IEffect) : void
        {
            // 重複は無視する
            if (effect.some(function(e2 : IEffect, ...param) : Boolean
            {
                return e === e2;
            })) return;

            effect.push(e);
            length = effect.length;
            dic[getQualifiedClassName(e)] = e;
            
            //------------------------------------------------------------------------
            // エフェクトはコントロールポイントを初期化し順次適用していくので順番が重要になる.
            // たとえば Unlace -> Circuitの順で適用するとシェイプが崩れる.
            // そのためエフェクトをプライオリティでソートする
            //------------------------------------------------------------------------
            effect = effect.sortOn("PRIORITY", Array.DESCENDING);
        }

        public function remove(e : IEffect) : void
        {
            effect = effect.filter(function(e2 : IEffect, ...param) : Boolean
            {
                return e !== e2;
            });
            length = effect.length;
            delete dic[getQualifiedClassName(e)];
        }

        public function execLoopEndTask() : void
        {
            effect.forEach(function(e : IEffect, ...param) : void
            {
                e.execLoopEndTask();
            });
        }

        public function getEffect(effectClass : Class) : Unlace
        {
            return dic[getQualifiedClassName(effectClass)];
        }

        public function execLoopStartTask() : void
        {
            effect.forEach(function(e : IEffect, ...param) : void
            {
                e.execLoopStartTask();
            });
        }
    }
}
