package com.imajuk.ui.bezier
{
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;

    /**
     * @author shin.yamaharu
     */
    public class ContextMenuUtil
    {
        public static function register(target : Sprite, labels : Array, callbacks : Array) : void
        {
            var myContextMenu : ContextMenu = new ContextMenu();

            myContextMenu.hideBuiltInItems();

            labels.forEach(function(label : String, idx : int, ...param) : void
            {
                var item : ContextMenuItem = new ContextMenuItem(label);
                myContextMenu.customItems.push(item);
                item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, callbacks[idx]);
            });

            target.contextMenu = myContextMenu;
        }
    }
}
