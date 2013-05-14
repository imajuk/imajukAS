package com.imajuk.render2D
{
    /**
     * @author imajuk
     */
    public interface IRenderLogic
    {
        function initialize(render2D : Render2D, factory : INodeFactory) : void;

        function render() : void;
    }
}
