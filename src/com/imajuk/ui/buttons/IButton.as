package com.imajuk.ui.buttons 
{
    import com.imajuk.behaviors.BehaviorDetail;
    import com.imajuk.interfaces.IDisplayObject;
    import com.imajuk.ui.buttons.fluent.IBehaviorFluentAPI;
    /**
     * @author shin.yamaharu
     */
    public interface IButton extends IBehaviorFluentAPI, IDisplayObject
    {
        function get id() : int;        function set id(value : int) : void;
        
        function get mouseEnabled() : Boolean;        function set mouseEnabled(value : Boolean) : void;

        /**
         * このボタンが選択状態をもつかどうか
         * trueの場合はクリック時に選択状態になります
         * 選択状態のビヘイビアは設定する必要があります
         */
        function get selectable() : Boolean;        function set selectable(value : Boolean) : void;
        
        /**
         * このボタンが選択状態かどうか
         */
        function get selected() : Boolean;
        function set selected(value : Boolean) : void;
        
        /**
         * クリック時に自動的に選択、非選択状態を切り替えるかどうか
         */
        function get toggle() : Boolean;
        function set toggle(value:Boolean) : void;
        
        /**
         * ビヘイビアのエフェクトを微調整するBehaviorDetailオブジェクト
         */
        function get behaviorDetail() : BehaviorDetail
        function set behaviorDetail(value : BehaviorDetail) : void
        
        function start() : void
        function stop() : void

        /**
         * 強制的にロールオーバエフェクトを実行
         */
        function rollOverEffect() : void

        /**
         * 強制的にロールアウトエフェクトを実行
         */
        function rollOutEffect() : void
        
        function upEffect() : void;
        
        function removeBehaviorAll() : void;

        function lockBehaviors() : void;
        function unlockBehaviors() : void;
    }
}
