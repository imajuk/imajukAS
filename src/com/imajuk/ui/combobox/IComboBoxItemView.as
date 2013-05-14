package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.IUIView;

    import com.imajuk.color.Color;
    /**
     * @author shin.yamaharu
     */
    public interface IComboBoxItemView extends IUIView
    {
        /**
         * ベースカラーを変更する
         * TODO IComboBoxItemViewは基本的にIBUttonを継承するのでこのメソッドはいらない
         */
        function setItemColor(value:Color):void;
        /**
         * 複製したインスタンスを返す
         */
        function clone():IComboBoxItemView;
        /**
         * ComboBoxでaddItem()されたオブジェクトは最終的にこのメソッドに渡される.
         * IComboBoxItemViewの実装クラスは渡されたオブジェクトをどうレンダリングするか解決する必要がある
         */
        function setLabel(data:*):void;
    }
}
