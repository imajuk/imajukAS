package com.imajuk.commands 
{
    import com.imajuk.commands.FuluentDo;    

    import flash.utils.Dictionary;    
    /**
     * シーケンシャルなコマンド実行のためのファクトリ.
     * 
     * シーケンシャルなコマンド実行をするためには、CommandComponentを生成し
     * ICommandのコンポジット構造を作成する必要があります.
     * FuluentCommandは、そのコンポジット構造の生成プロセスをラップし、
     * 簡易なインターフェイスを提供するファクトリとして機能します.
     * 
     * 用語：
     *  前提コマンド  コマンド実行のトリガーとなるコマンド
     * 
     * @author yamaharu
     */
    public class FuluentCommand extends AbstractAsyncCommand implements ICommand 
    {

        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * 前提コマンドとDoコマンドを紐づけるFuluentDoインスタンスのリスト.
         * 重複するFuluentDoインスタンスのチェックに使用される.
         * 
         * たとえば、以下のような完全に重複する定義があった場合、
         * FuluentCommand.when(view.hidden).Do(somethig1).always();
         * ...
         * FuluentCommand.when(view.hidden).Do(somethig1).always();
         * 2つめのFuluentCommandは無視される.
         * 
         * また、以下のような重複する定義の場合は
         * 後からのオプションで上書きされる.
         * FuluentCommand.when(view.hidden).Do(somethig1).always();
         * ...
         * FuluentCommand.when(view.hidden).Do(somethig1);
         */
        protected static var agentList:Dictionary = new Dictionary(true);

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function FuluentCommand(dispatcher:ICommand, closure:Function = null) 
        {
            super(closure);
            myCommand = dispatcher;
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
    	
        /**
         * @private
         * Doするきっかけとなる前提コマンド
         */
        protected var myCommand:ICommand;

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------

        public static function when(command:ICommand):FuluentCommand
        {
            return new FuluentCommand(command);
        }

        public function Do(closure:*, ...param):FuluentDo
        {
            var isFunction:Boolean = closure is Function; 
            var f:Function = (isFunction) ? closure : function():void
            {
                FuluentDo(closure).create();
            };
            var doing:FuluentDo = new FuluentDo(myCommand, f); 
           	
            if(isFunction && param.length > 0)
	            doing.myArguments = param;

            return doing;
        }
    }
}
