package com.imajuk.interfaces 
{
    import org.libspark.thread.Thread;    
    
    /**
     * @author yamaharu
     */
    public interface IProgressView extends IDisplayObject
    {
        function build(...pram):void;
        
        function update(value:Number):void;
        /**
         * 進捗状況を表すプレゼンテーションが完全に終了しているかどうかを返します.
         * IProgressViewによってはロード完了後も進捗状況を表すプレゼンテーションを
         * 継続する必要があるため、このプロパティを適切に実装する必要があります.
         */
        function get isComplete():Boolean;
        
        function show():Thread;
        
        function hide():Thread;

        function destroy() : void;
    }
}
