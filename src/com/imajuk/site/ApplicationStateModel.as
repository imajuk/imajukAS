package com.imajuk.site 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.utils.DictionaryUtil;

    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    /**
     * ステートのモデル
     * ステートツリーの保持とステート遷移のロジックの実装
     * 
     * @author shinyamaharu
     */
    internal class ApplicationStateModel 
    {
        /**
         * @private
         * ステートユーザ定義
         */
        internal var tree : XML;
        /**
         * @private         * デフォルトのステートタイプ
         * （ディープリンク時にDeepLinkSolverから設定される）
         */
        internal var reserved : Reference;
        /**
         * @private
         * デフォルトのステートタイプ
         */
        private var _defaultStateType : Reference;
        internal function get defaultStateType() : Reference
        {
        	return reserved || _defaultStateType;
        }        /**
         * @private
         * 現在実行中のステートタイプ
         */
        internal var currentStateType : Reference = new Reference();
        /**
         * @private
         */
        private var application : Application;
        /**
         * コンストラクタ
         */
        public function ApplicationStateModel(application:Application, defaultStateType : Reference, tree:XML)         
        {
            this.application       = application;
            this._defaultStateType = defaultStateType;
            
            StateRecipeValidator.validate(tree);
            this.tree             = tree;
        }
        /**
         * 渡されたステートタイプが現在実行中のステートかどうか
         */
        internal function isCurrent(stateType : Reference) : Boolean 
        {
            return currentStateType.equals(stateType);
        }
        
        /**
         * 渡されたステートタイプが現在実行中のステートの親にあたるかどうか
         */
        internal function isParent(state : Reference) : Boolean 
        {
            return _isParent(state.encode(), currentStateType.encode());
        }
        
        /**
         * 渡されたステートが現在実行中のステートの祖先かどうか
         */
        internal function isAncestor(state : Reference) : Boolean 
        {
            if (isParent(state))
                return true;
                
            return _isAncestor(state.encode(), currentStateType.encode());
        }

        /**
         * 渡されたステートが現在実行中のステートと同じツリーに存在するかどうか
         */
        internal function isSameTree(state : Reference) : Boolean 
        {
            var current : String = currentStateType.encode();
            if (current == tree.name())
                return false;
            
            return _isSameTree(state.encode(), current);
        }
        
        /**
         * nodeA is assendant of nodeB
         */
        private function _isAncestor(nodeA : String, nodeB:String) : Boolean 
        {
        	if (_isParent(nodeA, nodeB))
        	   return true;
        	
        	var parent:Array = getParent(nodeB);
            return parent.some(function(p:XML, ...param):Boolean
            {
            	return _isAncestor(nodeA, p.name());
            });
        }
        
        /**
         * 
         */
        private function getParent(name : String) : Array 
        {
        	var nodes : XMLList = getNode(name);
                
            var parents:Array = [];
            for each (var c : XML in nodes)
            {
                parents.push(c.parent());
            }
            return parents;
        }

        private function getNode(name : String) : XMLList
        {
            return tree.descendants(name);
        }
        
        /**
         * 親ノードを取得する
         * 複数の親候補があった場合履歴をもとに親を特定する
         */
        internal function getParentWithHistory(name : String, history:Dictionary = null) : String
        {
            var node:XML = getNodeWithHistory(name, history);
            if(!node)
                return null;
                
            var parent:XML = node.parent();
            if(parent)
                return parent.name();
            else
                return null;
        }
        

        /**
         * nodeA is parent of nodeB
         */
        private function _isParent(nodeA : String, nodeB : String) : Boolean 
        {
            var b : XMLList = getNode(nodeB);
            for each (var b2 : XML in b)
            {
                if (nodeA == b2.parent().name())
                {
                    return true;
                    break;
                }
            }
            return false;
        }

        /**
         * nodeA and nodeB are in same tree
         */
        internal function _isSameTree(nodeA : String, nodeB : String) : Boolean 
        {
            if (nodeA == nodeB) return true;

            if (tree.descendants(nodeA).descendants(nodeB).length() > 0)
                return true;

            if (tree.descendants(nodeB).descendants(nodeA).length() > 0)
                return true;
            
            return false;
        }

        /**
         * 引数で渡されたステートのswfAddress用のURLを返す
         */
        internal function getPath(stateType : Reference) : String 
        {
            var node : XML = tree.descendants(stateType)[0];
            
            if(node == null)
                throw ApplicationError.create(ApplicationError.NO_DEFINATION_IN_STATE_RECEIPT, stateType.decode());
            
            var path:Array = [];
        	while(node.parent())
            {
                path.push(node.attribute("pageName"));
                node = node.parent();
            }
        	path = path.reverse();
            return path.toString().split(",").join("/");
        }

        /**
         * 渡されたノードの子孫を返す。
         */
        internal function getDecendants(state : Reference) : Array
        {
            var result : Array = [];
            var checkDuplicate:Dictionary = new Dictionary(true);
            var d : XMLList = getNode(state.encode()).descendants();
            for each (var d2 : XML in d)
            {
            	var s:String = d2.name(); 
            	if (checkDuplicate[s] == undefined)
            	{
                    result.push(s);
                    checkDuplicate[s] = true;
            	}
            }
            return result;
        }
        
        /**
         * 任意のノードをルートとするツリーを返す
         * 
         * もし対象となるノードが複数ある場合以下のルールでルートノードを特定する
         * 1. 複数候補のノードの中に現在起動中のステートを持つノードがあればそのノード
         * 2. 最初のノード
         * TODO 最初のノードではなくstateA.stateBのように特定できるようにしたい
         * 
         * @param name  ノードが持つステートの文字列表現
         */
        private function getNodeWithHistory(name : String, history:Dictionary) : XML
        {
        	var nodes : XMLList;
        	
        	if (tree.name() == name)
        		nodes = new XMLList(tree.name());
        	else
            	nodes = tree.descendants(name);

            if (nodes == null)
                return null;
            
            if (nodes.length() == 1) return nodes[0];
            
            //複数候補のノードの中に現在起動中のステートを持つノードがあればそのノードを返す
            for each (var i : XML in nodes)
                // 親
                if (DictionaryUtil.containesKey(history, i.parent().name()))
                    return getNodeWithHistory(i.parent().name(), history);
            
            //なければ最初のノードを返す
            return nodes[0];
        }

        /**
         * @private
         * 現在起動しているすべてのステート
         */
        private var active     : Array = [];
        private var active_dic : Dictionary = new Dictionary(true);
        
        public function change(stateType : Reference) : StateTransitionInfo
        {
        	//すでに指定されたステートの実行中なら何もしない
            if (isCurrent(stateType))
                return null;
                
        	//終了されるステート
            var markedAsInterrupted:Array = [];
                
            //=================================
            // 移動先に親子関係がない場合は、
            // 現在のツリーはすべて終了。ただし
            // 移動先ツリーに重複したステートがあればそのステートは終了しない
            //=================================
            if (!isSameTree(stateType))
            {
                markedAsInterrupted = active;
                active = [];
                //動作中のステートから目標ステートのツリーに含まれるステート以外を取り除く
                for (var key : String in active_dic) {
                    if (!_isSameTree(key, stateType.encode()))                   
                       delete active_dic[key];
                }
            }
            
            //=================================
            // 移動先が祖先なら祖先より下のツリーを全て終了
            //=================================
            if (isAncestor(stateType))
            {
                getDecendants(stateType).forEach(
                    function(s:String, ...param) : void
                    {
                        var t : StateThread = active_dic[s] as StateThread;
                        if(t) markedAsInterrupted.push(t);
                    }
                );
            }
            
            //=================================
            // 目標のステートから親をたどってルートまで（もしまだ起動してなければ）起動
            // 複数の経路がある場合（E→Fに遷移したときののような）エラー
            //=================================
            //目標のステートからルートまでのステート
            var markedAsExecute:Array = [];
            (function(node : String) : void
            {
                var parent : String = getParentWithHistory(node, active_dic);
                if (parent == null) return;
                //ルートノード
                if(parent == tree.name()) return;

                var parentClass:Class = getDefinitionByName(Reference.decodeType(parent))as Class;

                var parentState : StateThread = 
                    active_dic[parent] as StateThread || 
                    getStateThread(new Reference(parentClass));

                markedAsExecute.push(parentState);
                arguments.callee(parent);
                
            })(stateType.encode());
            
            //終了予定ステート候補に起動予定ステートが含まれていれば取り除く
            if (markedAsExecute.length > 0)
                markedAsInterrupted = 
                    markedAsInterrupted.filter(
                        function(s : StateThread, ...param) : Boolean
                        {
                            return !markedAsExecute.some(
                                        function(s2 : StateThread, ...param) : Boolean
                                        {
                                            return s == s2;
                                        }
                                    );
                        }
                    );
                    
            //起動予定ステートから既に実行されているステートがあればを取り除く
            markedAsExecute = markedAsExecute.filter(function(s : StateThread, ...param) : Boolean
            {
                return s.state == ThreadState.NEW;
            });
            markedAsExecute.push(getStateThread(stateType));

            
            Logger.info(0, " ApplicationState will be changed... " + currentStateType + " -> " + stateType.decode());
            Logger.info(2, "↔  changed state to : " + stateType.decode());
            
            //=================================
            // 現在実行中のステートタイプをアップデート
            //=================================
            currentStateType = stateType;
            
            return new StateTransitionInfo(
                markedAsExecute, 
                markedAsInterrupted.length > 0 ? 
                    new InterruptThread(markedAsInterrupted, this) : 
                    null
                );
        }
        
        /**
         * @private
         * 具象StateThreadインスタンスを生成します.
         */
        private function getStateThread(stateType : Reference) : StateThread 
        {
            var state : StateThread = active_dic[stateType.encode()] as StateThread;
            if (!state)
            {
                try
                {
                    var className:String = stateType.decode();
                    var c : Class = getDefinitionByName(className) as Class;
                }
                catch(e:Error)
                {
                    throw new Error(className + "を参照できませんでした. クラスの可視性やクラスがコンパイルされ参照可能な状態であるか確認してください.");
                }
                
                try
                {
                    state = StateThread(ApplicationControlerFactory.create(c, application));
                    active_dic[stateType.encode()] = state;
                }
                catch(e:Error)
                {
                    throw e;
                }
            }
            
            active.push(state);
            return state;
        }

        internal function removeActiveState(t : Thread) : void
        {
        	delete active_dic[new Reference(getDefinitionByName(getQualifiedClassName(t)) as Class).encode()];
        }
    }
}
