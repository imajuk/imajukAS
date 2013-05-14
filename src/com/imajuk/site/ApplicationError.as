package com.imajuk.site 
{
    /**
     * アプリケーション内で発生する可能性のあるエラーを定義します
     * 
     * @author imajuk
     */
    public class ApplicationError extends Error 
    {
    	//--------------------------------------------------------------------------
    	//  ステート、グローバルコントローラの生成に関するエラー
    	//--------------------------------------------------------------------------
        public static const CALL_ABSTRACT                      : Object = {id:10000, message:"このメソッドは抽象メソッドです.　サブクラスはこのメソッドを実装しなければなりません."};
        public static const FAILED_ASSET_LOADING               : Object = {id:10001, message:"$で[inject]指定されたViewのアセットのローディングに失敗しました.\n[REASON]$"};
        public static const CONSTRUCTION_PROBLEM               : Object = {id:10002, message:"$の生成に失敗しました.コンストラクタ内で以下のエラーが発生しました.\n[REASON]$"};
        public static const FAILED_ADDING_VIEW                 : Object = {id:10003, message:"Viewの配置に失敗しました. 配置メソッドにnullが渡されました. \n（配置しようとしたViewがフレームワークによる自動生成を期待したものだった場合、そのViewはステートへの登録に失敗している可能性があります.[inject]タグを使ってViewが登録されているか確認してください.）"};
        public static const MUST_REGISTER_PROGRESS_VIEW_IN_CONSTRUCTOR : Object
                                                                        = {id:10004, message:"プログレスビューの登録はステートのコンストラクタで行う必要があります"};
        public static const MULTIPLE_SAME_NAME_STATE           : Object = {id:10005, message:"親子関係のあるステートで$が重複しています."};
    	//--------------------------------------------------------------------------
    	//  参照に関するエラー
    	//--------------------------------------------------------------------------
        public static const FAILED_RESISTER_APP_DOMAIN         : Object = {id:20000, message:"ApplicationDomainを登録しようとしましたが失敗しました.指定されたコンテナはロードされたものではないか、表示リスト内にありません."};
        public static const FAILED_LOOK_UP_APP_DOMAIN          : Object = {id:20001, message:"$を参照しようとしましたが失敗しました. ApplicationDomainが登録されていません. com.imajuk.site::AppDomainRegistry.getInstance().resisterAppDomain()を呼び出してApplicationDomainを登録してください."};
        public static const FAILED_LOOK_UP_APP_CLASS           : Object = {id:20002, message:"登録されたApplicationDomainにはクラス[$]が見つかりませんでした."};
        public static const FAILED_LOOK_UP_APP_CLASS_IN_RECIPE : Object = {id:20003, message:"レシピに記載されたクラス$の参照に失敗しました.[REASON]$"};
        public static const CANT_UESE_WITHOUT_APP_INSTANCE     : Object = {id:20004, message:"Applicationインスタンスがまだ生成されていないので$は使用できません."};
        public static const INVALID_LAYER_NAME                 : Object = {id:20005, message:"$という名前のレイヤーは存在しません。"};
        public static const UNRESOLVABLE_ASSET                 : Object = {id:20006, message:"$は登録されていません."};
        public static const TRIED_TO_REFER_UNREGISTED_VIEW     : Object = {id:20007, message:"$はアセットレシピ内で定義されていません."};
        public static const NO_DEFINATION_IN_STATE_RECEIPT     : Object = {id:20008, message:"レシピにないステート$を参照しようとしました. このステートはステートレシピ内で定義されていません。レシピを確認してください。"};
        public static const NO_ASSETS_DEFINITION_IN_RECIPE     : Object = {id:20009, message:"アプリケーションがロードするべきアセットが定義されていません.アセットレシピには少なくも一つの要素が必要です."};
        //--------------------------------------------------------------------------
        //  コンパイルに関するエラー
        //--------------------------------------------------------------------------
        public static const LACK_OF_COMPILER_OPTION            : Object = {id:30000, message:"コンパイラオプションに-keep-as3-metadata=injectを指定する必要があります"};
        //--------------------------------------------------------------------------
        //  想定外のエラー
        //--------------------------------------------------------------------------
        public static const FAILED_INJECT : Object = {id:90000, message:"unexpected error... $ seemed to be failed of injection."};
        
        /**
         * コンストラクタ
         */
        public function ApplicationError(message : * = "", id : * = 0)
        {
            super(message, id);
        }

        /**
         * ApplicationErrorインスタンスを生成
         */
        public static function create(error : Object, ...param) : Error
        {
            return new ApplicationError(
                error.message.split("$")
                    .map(
                        function(s:String, idx:int, ...rest):String
                        {
                        	return (idx == 0) ? s : (param[idx-1] || "") + s;
                        }
                    )
                    .join(""),
                error.id
                );
        }
    }
}
