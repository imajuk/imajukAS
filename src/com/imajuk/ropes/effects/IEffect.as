package com.imajuk.ropes.effects
{
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public interface IEffect
    {
        function exec(cp : ControlPoint, model:IRopeShape) : Point;

        function execLoopEndTask() : void;

        function execLoopStartTask() : void;
    }
}
