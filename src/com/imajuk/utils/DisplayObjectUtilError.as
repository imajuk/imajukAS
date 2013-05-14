package com.imajuk.utils {
	/**     * <code>DisplayObjectUtil</code>の<code>Error</code>クラス.     *      * @author yamaharu     */    public class DisplayObjectUtilError extends Error     {
        public static const FAILED_STAGE_REFERENCE_INIT_ID : int = 0;
        public static const FAILED_STAGE_REFERENCE_INIT : String = "stageを対象にremoveAllChildren()を実行しようとしましたが失敗しました。StageReferenceが初期化されていません.";
        
        public function DisplayObjectUtilError(message:String, id:int)        {            super(message, id);        }        }
}
