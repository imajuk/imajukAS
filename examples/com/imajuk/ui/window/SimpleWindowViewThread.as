package com.imajuk.ui.window 
{
    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.slideshow.FadeImageContainerThread;
    import com.imajuk.threads.InvorkerThread;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.ui.buttons.group.ButtonGroup;
    import com.imajuk.ui.scroll.Scroll;
    import com.imajuk.ui.scroll.view.Bar;
    import com.imajuk.ui.scroll.view.BarBG;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.SerialExecutor;

    import flash.display.Sprite;


    /**
     * Windowのコンテントになる実装クラスのサンプルです.
     * IWindowContentBuilderの実装クラスはWindowThreadからの各要求に応えます.
     * このウィンドウは5ページからなる画像を持っていてタブで切り替えることができます.
     * また、ページの大きさによってスクロールバーを表示します.
     * 
     * @author shinyamaharu
     */
    public class SimpleWindowViewThread extends AbstractWindowContent implements IWindowContentBuilder
    {
        private var book : Sprite;
        private var tabs : ButtonGroup;
        /**
		 * コンストラクタ
		 * @param timeline
		 * @param asset
		 */
        public function SimpleWindowViewThread(windowAsset : Sprite, identifier:String)
        {
            super(windowAsset, identifier);
        }

        /**
		 * ウィンドウを閉じるためのボタンを構築します.
		 */
        override protected function buildCloseButton() : IButton
        {
            var btn : IButton = 
                AbstractButton.wrapByName(windowAsset, "closeBtn")
                    .context(BehaviorContext.ROLL_OVER_OUT)
                    .behave(ColorBehavior.createTint(Color.fromARGB(0x9E9D9D), 1, "btn", Color.fromARGB(0xc1c1c1), 1));
            
        	//IButtonの表示状態を初期化
        	Sprite(btn).alpha = 0;
        	
            return btn;
        }

		/**
         * ウィンドウコンテントを初期化するThreadを返します.
         */
		override public function getInitializeContentThread() : Thread
        {
            return new InvorkerThread(function():void
            {
	            book = AssetFactory.create("$Info") as Sprite; 
	
//				DisplayObjectUtil.invisibleAllChildren(book);
		        
		        tabs = 
                    AbstractButton.wrapByName(windowAsset, "tab")
                        .context(BehaviorContext.ROLL_OVER_OUT)
                        .behave(ColorBehavior.createTint(Color.fromARGB(0x999898), 1, "bg", Color.fromARGB(0xc8c8c8), 1)) as ButtonGroup;
            });
        }
        
        override public function getInitializeScrollThread() : Thread
        {
            scroll = windowAsset.addChild(new Scroll(book, 500, 337, Bar, BarBG, SampleArrow)) as Scroll;
            scroll.x = 35;            scroll.y = 76;
            scroll.scrollBarSize = 250;
            scroll.bar_bg_margin = 2;
            scroll.container_scrollbar_margin = 60;
            
            //特にThreadで返す必要のない場合はこのように空のThreadを返してもかまいません
            return new Thread();
        }
        
        override public function getStartContentThread() : Thread
        {
            //ウィンドウ中のページ遷移の動作定義
            var pagingExecution : Function = 
	            function(page : int):Thread
	            {
                	var s : SerialExecutor = new SerialExecutor();
	                
	                //ページ切り替え処理
	                s.addThread(
	                	new InvorkerThread(
	                		function():void
			                {
					            var t:Thread = 
					            	new FadeImageContainerThread(identifier, book, page, .3);
					            t.start();
					            t.join();
			                }
			            )
			        );
	                
	                //ページ切り替え後処理
	                s.addThread(
	                	new InvorkerThread(
	                		function():void
			                {
			                	scroll.reset();
			                }
			            )
			        );
	                
	                return s;
	            };
	        
            // タブを機能させる
            tabs.isXOR = true;

            return new Thread();
        }
        
        override public function dispose() : Thread
        {
            tabs.isXOR = false;
        	return super.dispose();
        }
    }
}
