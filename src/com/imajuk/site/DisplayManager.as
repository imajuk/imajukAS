package com.imajuk.site 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.utils.DisplayObjectUtil;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;



    /**
     * @author shinyamaharu
     */
    internal class DisplayManager 
    {
        /**
         * @private
         * 寿命がステートに依存したアセットです.
         * ステートの終了とともに破棄されます.
         */
        private static var temporaryAssets : Array = [];
        private static var state : ApplicationStateModel;

        /**
         * 非永続的なビューをメインコンテナに追加します.
         * このアセットはステートの終了時に自動的に削除されます
         * @param child         追加するアセット
         * @param stateType     このステートが終了するとアセットを破棄します
         * @param layer         ビューを追加する場所となるレイヤーです
         */
        internal static function addTemporaryView(
                                    view     : DisplayObject, 
                                    state    : ReferencableViewThread,
                                    stateRef : Reference, 
                                    layer    : String = null
                                ) : void
        {
            temporaryAssets.push(
                {
                	stateRef :stateRef, 
                	asset    :ApplicationLayer.getLayer(layer || ApplicationLayer.CONTENT).addChild(view), 
                	layer    :layer,
                    state    :state
                }
            );        }

        /**
         * 永続的なアセットをメインコンテナに追加します.
         * このアセットをフレームワークが削除する事はありません
         */
        public static function addParmanentAsset(child : DisplayObject, layer:String) : void
        {
        	ApplicationLayer.getLayer(layer).addChild(child);
        }
        
        /**
         * 非永続的なアセットのリストを返します
         */
        private static function getTemporaryAsset() : Array 
        {
            return temporaryAssets.map(function(o:Object, ...param):DisplayObject
            {
            	return o.asset;
            });
        }
        
        /**
         * @private
         * 削除候補のアセットを表示リストから破棄する
         */
        internal static function removeTemporaryAssets() : void 
        {
            temporaryAssets = temporaryAssets.filter(
                function(o : Object, ...param):Boolean
                {
                	var stateRef:Reference = o.stateRef; 
                    if (state.isCurrent(stateRef) ||                         state.isAncestor(stateRef))
                               return true;
                    
                    if (StateThread(o.state).autoRemoveTemporaryView)
                    {
                        var d:DisplayObject = o.asset;
                        Logger.info(2, "✕　" + d + " was removed from stage.");
                        DisplayObjectUtil.removeChild(d);
                    }
                    return false;
                }
            );
        }

        public static function initialize(state : ApplicationStateModel) : void      
        {
            DisplayManager.state = state;
        }

        /**
         * 登録された非永続的アセットを操作します
         * @param effect    DisplayObjectを引数にとりThreadインスタンスを返すクロージャです
         *                  具体的な非表示エフェクトの実装になります
         */
        public static function oparateTemporaryAssets(effect:Function) : Thread 
        {
            return ThreadUtil.pararel(
                        getTemporaryAsset().map(
                            function(d : DisplayObject, ...param):Thread
                            {
                                return effect(d);
                            }
                        )
                   );
        }
    }
}
