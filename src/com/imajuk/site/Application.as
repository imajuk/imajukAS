package com.imajuk.site
{
    import com.asual.swfaddress.SWFAddress;
    import com.asual.swfaddress.SWFAddressEvent;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import com.imajuk.threads.ThreadUtil;

    import flash.display.Sprite;

    /**
     * Sophie AS3 Application.
     * 
     * <p>
     * Sophie AS3を使用するにはこのクラスのインスタンスを生成し実行します.
     * </p>
     * 
     * @author imajuk
     */
    public class Application 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
    	/**
         * コンストラクタ.
         * @param appName       このアプリケーションの名前です.
         *                      <p>
         *                      アプリケーション名には任意の名前が使用できます. 
         *                      この名前はアプリケーション実行時のロギングにのみ利用されます.
         *                      </p>
         * @param mainContainer アプリケーションが保持するビューのトップレベルのコンテナです.
         *                      <p>
         *                      このコンテナ内にはレイヤーと呼ばれる4つのコンテナがアプリケーションにより生成されます.
         *                      これらのレイヤーにアクセスするには<code>ApplicationLayer</code>クラスを使用します.
         *                      </p>
         * @param useSwfAddress SWFAddressを使用するかどうかを指定します.
         *                      <p>
         *                      <code>true</code>を指定するとSWFAddressを使用します.
         *                      ブラウザのアドレスバーに現在のステートが表示されるようになるほか、
         *                      ディープリンクやブラウザのバックボタンなどが使用可能になります.
         *                      </p>
         * @see ApplicationLayer
         * @see Reference#Reference()
         * @see com.imajuk.logs.Logger
         */
        public function Application(
                            appName:String, 
                            mainContainer : Sprite, 
                            useSwfAddress:Boolean = false
                        ) 
        {
        	Logger.release(
        	    appName + 
        	    "\n\n\tConstructed By Sophie AS3 ver1.0.0  @ http://www.imajuk.com/sophieAS3"
        	);
        	
            this.mainContainer = mainContainer;
            Reference.mainAppDomain = mainContainer.loaderInfo.applicationDomain;
            
            DeepLinkSolver.useSWFAddress = useSwfAddress;
            
            //resister current Application domain
            AppDomainRegistry.getInstance().resisterAppDomain(mainContainer);
            
            //validation of framework requirement
            ApplicationUtils.initialize(this);
            ApplicationUtils.checkMetaTag();
            
            //prepare to use layers
            ApplicationLayer.initialize(this);
        }
        //--------------------------------------------------------------------------
        //
        //  API for user
        //
        //--------------------------------------------------------------------------
    	/**
    	 *  アプリケーションを開始します.
    	 *  @param receipt     アプリケーションが使用するアセットのレシピ
    	 *                     <p>以下はレシピの詳細です.</p>
    	 *                         
    	 *  <listing version="3.0">
         * &lt;{Recipe.ASSET}&gt;
         * 
         *     &lt;!-- load assets/yourAsset1.swf, and then inject it to YourView --&gt;
         *     &lt;{new Reference(YourView)}  src=&quot;assets/yourAsset1.swf&quot;  /&gt;
         *     
         *     &lt;!-- load assets/yourAsset2.swf, it's never injected --&gt;
         *     &lt;{Reference.NOTHING}        src=&quot;assets/yourAsset2.swf&quot;  /&gt;
         *     
         * &lt;/{Recipe.ASSET}&gt;
         * </listing>
         *  <b>アセットレシピのXMLノード名</b>
         *  <p>
         *  アセットレシピでは、XMLルートノード名を<code>Recipe.ASSET</code>と指定し、
         *  その他のノード名には<code>Reference</code>オブジェクトを使用して生成したいオブジェクトを指定します.
         *  </p>
         *  <p>
         *  XMLルートノード以外の各ノードは<code>src</code>属性をもちます.
         *  これはアセットへのパスです.
         *  </p>
         *  <b>アセットのインジェクト</b>
         *  <p>
         *  アセットのロード終了後<code>Reference</code>オブジェクトで指定したクラスのインスタンスが生成されます.
         *  このときロードされたアセットがインジェクトされます.
         *  </p>
         *  <p>
         *  たとえば上記の例では、<code>YourView</code>オブジェクトを必要とするステートが開始された際に
         *  assets/yourAsset1.swfがロードされ、<code>YourView</code>オブジェクトが生成されます.
         *  このとき<code>YourView</code>オブジェクトのコンストラクタにアセットが渡されます.
         *  このようにしてフレームワークが自動生成したオブジェクトはステート内で参照できる事が保証されます.
         *  </p>
         *  <p>
         *  アセットのロード後ユーザ定義クラスの生成が必要がない場合は、XMLノード名に<code>Reference.NOTHING</code>を指定します.
         *  この場合、フレームワークはロードするアセットの拡張子から生成するべきオブジェクトのタイプを自動的に判別します.
         *  たとえば、ロードしたアセットがビットマップ画像だった場合<code>Bitmap</code>クラスがインスタンス化されます.
         *  このインスタンス化されたビットマップ画像は<code>AssetFactory.create(assetPath)</code>で参照できます. 
         *  どのような拡張子にどのようなクラスが対応するかは○を参照してください.
         *  </p>
         *  <p>
         *  <code>Reference.NOTHING</code>に指定されたアセットがswfだった場合、
         *  <code>AssetFactory.create(identify)</code>でswfにコンパイルされているクラスがインスタンス化できます.
         *  たとえばロードされたアセットにリンケージされたクラス<code>YourLinkagedClass</code>が存在した場合は、
         *  <code>AssetFactory.create("YourLinkagedClass")</code>で<code>YourLinkagedClass</code>オブジェクトをインスタンス化できます.
         *  </p>
         *  <b>アセットがロードされるタイミング</b>
         *  <p>
         *  アセットはそのアセットを必要とするオブジェクトが要求されたときに初めてロードされます.
         *  <code>Reference.NOTHING</code>指定されたアセットはアプリケーションが開始され
         *  デフォルト指定されたステートが開始する前にすべてロードされます.
         *  </p>
         *  <b>アセットロード時のプログレスビュー</b>
         *  <p>
         *  アセットのロード時にプログレスビューを使用したい場合はステート内で定義します.
         *  詳しくは○を参照してください.
         *  </p>
         *  <p>
         *  インスタンス化されたオブジェクトは、ステート内で<code>getView(new Reference(View))</code>とすればアクセスできます.
         *  </p>
         *  
         * @param stateReceipt     アプリケーションのステートを定義するレシピ
         * <p>
         * ステートレシピはアプリケーションがとりうるステートを定義したXMLです.
         * </p>
         * <listing version="3.0">
         * &lt;{Recipe.STATE}&gt;
         * 
         *     &lt;{new Reference(StateA)} /&gt;
         *     &lt;{new Reference(StateB)} &gt;
         *     &lt;!-- StateB won't be interrupted if state will be changed from StateB to StateC --&gt;
         *         &lt;{new Reference(StateC)} /&gt;
         *     &lt;/{new Reference(StateB)} &gt;
         *     
         * &lt;/{Recipe.STATE}&gt;
         * </listing>
         * <b>ステートレシピのXMLノード名</b>
         * <p>
         * ステートレシピでは、XMLルートノード名を<code>Recipe.STATE</code>と指定し、
         * その他のノード名には<code>Reference</code>オブジェクトを使用して生成したいステートを指定します.
         * </p>
         * <b>ステートの親子関係</b>
         * <p>
         * ステートは排他的に動作します. たとえば、上記の例では、
         * アプリケーションがステートAの状態のときにステートBへ遷移した場合、
         * ステートAは終了しステートBが新しいアプリケーションの状態になります.
         * </p>
         * <p>
         * ただしステート間に親子関係があり、親ステートから子ステートへの遷移だった場合は親ステートは終了しません.
         * これによってステートの重なりを表現できます. たとえばステートBからステートCへ遷移した場合、
         * ステートB終了せずにステートCが起動します.
         * </p>
         * <p>
         * また、アプリケーションのディープリンク機能を使用し、ブラウザから直接深い階層のステートを呼び出した場合、
         * ステートCの親・祖先にあたるステートが全て起動します.　たとえば、ステートCにディープリンクされたURLを開いた場合
         * まずステートBが起動し、次にステートCが起動します.
         * </p>
         *  
         *  @param defaultState     アプリケーションの開始時に最初に実行されるステートです.
         *                          <p>
         *                          このステートはステートレシピで定義されている必要があります.
         *                          </p>
         *  @see    Recipe
         *  @see    StateThread
    	 */
    	public function start(
    	                   assetReceipt : XML, 
    	                   stateReceipt:XML,
    	                   defaultState:Reference
    	                 ) : void 
        {
        	//=================================
            // Threadを初期化します
            // （Sophie AS3はThreadをベースにしています）
            //=================================
            ThreadUtil.initAsEnterFrame();
            
        	AssetRecipeValidator.validate(assetReceipt);
        	
            var state:ApplicationStateModel = 
                new ApplicationStateModel(this, defaultState, stateReceipt);
                
            stateControler = 
                new ApplicationStateControler(state);
            
            DisplayManager.initialize(state);
            InstanceRegistory.getInstance().registerReceipt(assetReceipt);
            DeepLinkSolver.initialize(this, state);
            
            //=================================
            // start default State
            //=================================
            if (DeepLinkSolver.useSWFAddress)
                SWFAddress.addEventListener(SWFAddressEvent.INIT, function() : void
                {
                    stateControler.startDefaultState();
                });
            else
                stateControler.startDefaultState();
        }
        //--------------------------------------------------------------------------
        //
        //  Variables for framework
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * アプリケーションのStateを管理するオブジェクトです.
         * アプリケーションはchangeState()が呼ばれると
         * Stateの変更をApplicationStateThreadに委譲します.
         */
        internal var stateControler : ApplicationStateControler;
        /**
         * @private
         * アプリケーションが保持するビューのトップレベルのコンテナです.
         */
        internal var mainContainer : Sprite;
        //--------------------------------------------------------------------------
        //
        //  API for framework
        //
        //--------------------------------------------------------------------------        /**
         * @private
         * ステートを変更します.
         * 指定した新しいステートを開始します. 現在実行中のステートを終了するかどうかはステートレシピで定義されます.
         * @param   stateType 新しいステートのタイプ
         * @return  ステートが変更されるかどうか。変更される場合はtrue,変更されない場合はfalseを返します
         */
        internal function changeState(stateType : Reference) : Boolean 
        {
        	if (!stateType)
        	   return false;
        	
    		var result:Boolean;
        	try
        	{
        		result = stateControler.change(stateType);
        	}
        	catch(e:Error)
        	{
        		Logger.error(e, this, "ステートの遷移に失敗しました");
        	}
        	
            return result; 
        }
        
        /**
         * @private
         */
        internal function get flashVars():Object
        {
        	return DocumentClass.flashVars;
        }
    }
}
