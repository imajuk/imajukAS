package com.imajuk.site
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.utils.DisplayObjectUtil;
    import flash.display.Sprite;
    import flash.utils.getQualifiedClassName;
    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.assertEquals;
    import org.libspark.as3unit.assert.async;
    import org.libspark.as3unit.assert.fail;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;





    use namespace test;
    use namespace before;
    use namespace after;

    internal class ApplicationErrorTest extends Sprite
    {
        before function setup() : void
        {
            ThreadUtil.initAsEnterFrame();
            
            AppDomainRegistry.getInstance().resisterAppDomain(DocumentClass.container);
        }

        /**
         * 登録されてないViewの呼び出し
         */
        test function UNRESOLVABLE_ASSET() : void
        {
        	Logger.release("UNRESOLVABLE_ASSET");
        	
            try
            {
                InstanceRegistory.getInstance().getAsset(new Reference(Dummy));
                fail("failed");
            }
            catch(e : ApplicationError)
            {
                assertEquals(ApplicationError.UNRESOLVABLE_ASSET.id, e.errorID);
                assertEquals("__Dummyは登録されていません.", e.message);
            }
        }

        /**
         * Stateのinitialize()が実装されてない
         */
        test function CALL_ABSTRACT() : void
        {
        	Logger.release("CALL_ABSTRACT");
            
            new ErrorCatchThread(
                function() : void
                {
                    new DummyState().start();
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.CALL_ABSTRACT.id,      e.errorID);
                    assertEquals(ApplicationError.CALL_ABSTRACT.message, e.message);
                })
            ).start();
        }

        /**
         * Viewの生成中にエラーが発生
         */
        test function CONSTRUCTION_PROBLEM() : void
        {
        	Logger.release("CONSTRUCTION_PROBLEM");
            
            new ErrorCatchThread(
                function() : void
                {
                	var receipt:XML = <root><{new Reference(ErrorView)} src="dammy.gif" /></root>;
                	var a:ApplicationAssetLoader = new ApplicationAssetLoader();
                	a.getConstructionTaskFromRecipe(receipt).start();
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.CONSTRUCTION_PROBLEM.id,      e.errorID);
                    assertEquals("com.imajuk.site::ErrorViewの生成に失敗しました.コンストラクタ内で以下のエラーが発生しました.\n[REASON]ERRORRRRR", e.message);
                })
            ).start();

        }
        
        test function FAILED_ASSET_LOADING():void
        {
        	Logger.release("FAILED_ASSET_LOADING");
        	
        	new ErrorCatchThread(
                function() : void
                {
                    new DummyState2().start();
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_ASSET_LOADING.id,      e.errorID);
                    assertEquals("com.imajuk.site::DummyState2で[inject]指定されたViewのアセットのローディングに失敗しました.\n[REASON]com.imajuk.site::DummyVewはアセットレシピ内で定義されていません.", e.message);
                })
            ).start();
        }
        
        
        /**
         * レシピにないステートを参照
         */
        test function NO_DEFINATION_IN_STATE_RECEIPT():void
        {
        	Logger.release("NO_DEFINATION_IN_STATE_RECEIPT");
        	
            new ErrorCatchThread(
                function() : void
                {
                    var tree : XML = <root><{new Reference(StateA)} /></root>;
                    var m : ApplicationStateModel = new ApplicationStateModel(null, new Reference(), tree);
                    m.getPath(new Reference(StateB));
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.NO_DEFINATION_IN_STATE_RECEIPT.id, e.errorID);
                    assertEquals("レシピにないステートcom.imajuk.site::StateBを参照しようとしました. このステートはステートレシピ内で定義されていません。レシピを確認してください。", e.message);
                })
            ).start();
        }
        
        test function CANT_UESE_WITHOUT_APP_INSTANCE():void
        {
        	Logger.release("CANT_UESE_WITHOUT_APP_INSTANCE");
        	
        	new ErrorCatchThread(
                function() : void
                {
                    ApplicationLayer.getLayer(ApplicationLayer.BACKGROUND);
                    fail();
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.CANT_UESE_WITHOUT_APP_INSTANCE.id, e.errorID);
                    assertEquals("Applicationインスタンスがまだ生成されていないのでcom.imajuk.site::ApplicationLayerは使用できません.", e.message);
                })
            ).start();
        }
        
        test function INVALID_LAYER_NAME():void
        {
        	Logger.release("INVALID_LAYER_NAME");
        	
            new ErrorCatchThread(
                function() : void
                {
                	new Application("app", DocumentClass.container);
                    ApplicationLayer.getLayer("hoge");
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.INVALID_LAYER_NAME.id, e.errorID);
                    assertEquals("hogeという名前のレイヤーは存在しません。", e.message);
                })
            ).start();
        }
        
        test function FAILED_RESISTER_APP_DOMAIN():void
        {
        	Logger.release("FAILED_RESISTER_APP_DOMAIN");
        	
            new ErrorCatchThread(
                function() : void
                {
                    AppDomainRegistry.getInstance().resisterAppDomain(new Sprite());
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_RESISTER_APP_DOMAIN.id, e.errorID);
                    assertEquals("ApplicationDomainを登録しようとしましたが失敗しました.指定されたコンテナはロードされたものではないか、表示リスト内にありません.", e.message);
                })
            ).start();
        }
        
        test function FAILED_LOOK_UP_APP_DOMAIN():void
        {
        	Logger.release("FAILED_LOOK_UP_APP_DOMAIN");
        	
            new ErrorCatchThread(
                function() : void
                {
                    AppDomainRegistry.getInstance().reset();
                	AppDomainRegistry.getInstance().getAppDomain(getQualifiedClassName(Dummy));
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_LOOK_UP_APP_DOMAIN.id, e.errorID);
                    assertEquals("::Dummyを参照しようとしましたが失敗しました. ApplicationDomainが登録されていません. com.imajuk.site::AppDomainRegistry.getInstance().resisterAppDomain()を呼び出してApplicationDomainを登録してください.", e.message);
                })
            ).start();
        }
        
        test function FAILED_LOOK_UP_APP_CLASS():void
        {
        	Logger.release("FAILED_LOOK_UP_APP_CLASS");
        	
            new ErrorCatchThread(
                function() : void
                {
                    AppDomainRegistry.getInstance().getAppDomain(getQualifiedClassName(Dummy));
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_LOOK_UP_APP_CLASS.id, e.errorID);
                    assertEquals("登録されたApplicationDomainにはクラス[::Dummy]が見つかりませんでした.", e.message);
                })
            ).start();
        }
        
        test function TRIED_TO_USE_UNREGISTED_VIEW2():void
        {
            Logger.release("TRIED_TO_USE_UNREGISTED_VIEW2");
            
            new ErrorCatchThread(
                function() : void
                {
                	new Application("", DocumentClass.container);
                    new DummyState3().start();
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_ADDING_VIEW.id, e.errorID);
                    assertEquals("Viewの配置に失敗しました. 配置メソッドにnullが渡されました. \n（配置しようとしたViewがフレームワークによる自動生成を期待したものだった場合、そのViewはステートへの登録に失敗している可能性があります.[inject]タグを使ってViewが登録されているか確認してください.）", e.message);
                })
            ).start();
        }
        
        test function CONSTRUCTION_PROBLEM_global_controler():void
        {
        	Logger.release("CONSTRUCTION_PROBLEM_global_controler");
            
            new ErrorCatchThread(
                function() : void
                {
                	ApplicationControlerFactory.create(DummyState4, new Application("app", DocumentClass.container));
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.CONSTRUCTION_PROBLEM.id, e.errorID);
                    assertEquals("com.imajuk.site::DummyState4の生成に失敗しました.コンストラクタ内で以下のエラーが発生しました.\n[REASON]ERRORRRRR", e.message);
                })
            ).start();
        }
        
        /**
         * レシピにないオブジェクトを参照しようとした
         */
        test function TRIED_TO_REFER_UNREGISTED_VIEW():void
        {
            Logger.release("TRIED_TO_REFER_UNREGISTED_VIEW");
            
            new ErrorCatchThread(
                function() : void
                {
                    InstanceRegistory.getInstance().getReceipt("HOGE");
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.TRIED_TO_REFER_UNREGISTED_VIEW.id, e.errorID);
                    assertEquals("HOGEはアセットレシピ内で定義されていません.", e.message);
                })
            ).start();
        }
        
        /**
         * 要素のないレシピを使おうとした
         */
        test function NO_ASSETS_DEFINITION_IN_RECIPE():void
        {
            Logger.release("NO_ASSETS_DEFINITION_IN_RECIPE");
            
            new ErrorCatchThread(
                function() : void
                {
                    var recipe:XML = <root></root>;
                	new ApplicationAssetLoader().getConstructionTaskFromRecipe(recipe);
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.NO_ASSETS_DEFINITION_IN_RECIPE.id, e.errorID);
                    assertEquals("アプリケーションがロードするべきアセットが定義されていません.アセットレシピには少なくも一つの要素が必要です.", e.message);
                })
            ).start();
        }
        
        /**
         * コンパイルされてないクラスをレシピで指定した
         */
        test function FAILED_LOOK_UP_APP_CLASS_IN_RECIPE():void
        {
            Logger.release("FAILED_LOOK_UP_APP_CLASS_IN_RECIPE");
            
            new ErrorCatchThread(
                function() : void
                {
                    var recipe:XML = <{Recipe.ASSET}><DOESNT_EXIST src="dammy.gif"/></{Recipe.ASSET}>;
                    //StateAにはDOESNT_EXISTは[inject]指定されていないのでコンパイルされない
                    var recipe2:XML = <{Recipe.STATE}><{new Reference(StateA)}/></{Recipe.STATE}>;
                    var app:Application = new Application("app", DocumentClass.container);
                    app.start(recipe, recipe2, new Reference(StateA));
                    
                }, async(
                function(e:ApplicationError) : void
                {
                    assertEquals(ApplicationError.FAILED_LOOK_UP_APP_CLASS_IN_RECIPE.id, e.errorID);
                    assertEquals("レシピに記載されたクラスDOESNT_EXISTの参照に失敗しました.[REASON]登録されたApplicationDomainにはクラス[DOESNT_EXIST]が見つかりませんでした.", e.message);
                })
            ).start();
        }
        

        after function teardown() : void
        {
        	AppDomainRegistry.getInstance().reset();
        	ApplicationLayer.reset();
        	DisplayObjectUtil.removeAllChildren(DocumentClass.container);
        }
    }
}
import com.imajuk.site.StateA;

import flash.display.Sprite;

class Dummy
{
}

class DomainContainer extends Sprite
{
	public var a:StateA;
}

class DomainContainer2 extends Sprite
{
    public var a:StateA;
}

