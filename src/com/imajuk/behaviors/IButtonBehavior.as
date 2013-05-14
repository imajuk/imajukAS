package com.imajuk.behaviors 
{
    import org.libspark.betweenas3.tweens.ITween;

    import flash.display.DisplayObject;
    import flash.media.Sound;
    /**
     * ボタンのエフェクトとアセットのレイアウト情報を保持します.
     * @author shin.yamaharu
     */
    public interface IButtonBehavior 
    {
        function get target():DisplayObject;
        function rollOverBehavior(detail:BehaviorDetail) : ITween;
        function rollOutBehavior(detail:BehaviorDetail) : ITween;
        function downBehavior(detail:BehaviorDetail) : ITween;
        function upBehavior(detail:BehaviorDetail) : ITween;
        function disableBehavior(detail:BehaviorDetail) : ITween;
        function enableBehavior(detail:BehaviorDetail) : ITween;
        function selectedBehavior(detail:BehaviorDetail) : ITween;
        function unSelectedBehavior(detail:BehaviorDetail) : ITween;

        function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior;

        function clone() : IButtonBehavior;
        function dispose() : void;
        
        function get sound() : Sound;

        function set sound(sound : Sound) : void;

    }
}
