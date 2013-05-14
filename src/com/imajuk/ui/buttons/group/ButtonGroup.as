package com.imajuk.ui.buttons.group
{
    import com.imajuk.behaviors.BehaviorDetail;
    import com.imajuk.behaviors.IButtonBehavior;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.fluent.IBehaviorFluentAPI;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.media.Sound;

    /**
     * ボタンのコレクション
     * @author imajuk
     */
    public class ButtonGroup extends Sprite implements IButton
    {
        private var buttons : Array;

        public function ButtonGroup(buttons : Array)
        {
            if (buttons.length < 2)
                throw new Error("ボタングループを生成するには少なくとも2つのInteractiveObjectが必要です.");
                
            this.buttons = buttons;
            
            buttons.forEach(
                function(b : IButton, ...param) : void
                {
                    addChild(DisplayObject(b));
                }
            );
        }
        
        //--------------------------------------------------------------------------
        //  IBehavable implementation
        //--------------------------------------------------------------------------
        /**
         * 全てのボタンにビヘイビアを適用
         */
        public function behave(behavior : IButtonBehavior) : IButton
        {
            _forEach("behave", behavior);
            return this;
        }

        public function context(contextType : String) : IButton
        {
            _forEach("context", contextType);
            return this;
        }
        
        public function sound(sound : Sound) : IButton
        {
            forEach_set("sound", sound);
            return this;
        }
        
        public function removeBehaviorAll() : void
        {
            _forEach("removeBehaviorAll");
        }
        
        //--------------------------------------------------------------------------
        //  IButton implementation
        //--------------------------------------------------------------------------
        private var _id:int;
        public function get id() : int
        {
            return _id;
        }
        public function set id(value : int) : void
        {
            _id = value;
        }
        
        private var _selectable : Boolean;
        public function get selectable() : Boolean
        {
            return _selectable;
        }
        public function set selectable(value : Boolean) : void
        {
            _selectable = value;
            forEach_set("selectable", value);
        }

        /**
         * グループ内のボタンがどれか選択状態かどうか
         */
        public function get selected() : Boolean
        {
            return buttons.some(function(b:IButton, ...param) : Boolean
            {
                return b.selected;
            });
        }
        public function set selected(value : Boolean) : void
        {
            forEach_set("selected", value);
        }

        private var _toggle : Boolean;
        public function get toggle() : Boolean
        {
            return _toggle;
        }
        public function set toggle(value : Boolean) : void
        {
            _toggle = value;
            
            presetXOROperation();
            
            if (_isXOR)
                updateXORGroup();
            
            forEach_set("toggle", value);
        }

        /**
         * 排他的オペレーションを変更します.
         * 
         * 排他的オペレーションのデフォルト値はButtonOparation.SELECTおよびButtonOparation.DISABLEです。
         * この場合グループ内のボタンがどれかクリックされると、グループ内のその他のボタンの選択状態と使用可能かどうかが排他的に変更されます。
         * このオペレーションを変更したい場合はxorOperationプロパティが使用できます。
         * xorOparationプロパティを設定するとこのボタングループは排他的ボタングループと見なされ、isXORプロパティがtrueに変更されます。
         */
        private var _xorOparation : ButtonOparation = new ButtonOparation(ButtonOparation.SELECT, ButtonOparation.DISABLE);
        public function get xorOparation() : ButtonOparation
        {
            return _xorOparation;
        }
        public function set xorOparation(value : ButtonOparation) : void
        {
            _xorOparation = value;
            _isXOR = true;
        }
        
        /**
         * このボタングループが排他的ボタングループかどうか.
         * 排他的ボタングループでは、グループ内のボタンがクリックされたときそのボタンが選択状態になりそれ以上クリックできなくなります。
         * またその際、他のボタンは自動的に非選択状態になりクリック可能になります。
         * クリック操作を経ずに任意のボタンを選択状態にするにはselectedIndexプロパティを使用します。
         * selectedIndexプロパティの操作はisXORプロパティがtrueの場合のみ有効です。
         * グループ内のボタンがクリックされたときそのボタンが選択状態になるが引き続きクリック操作を認める場合は
         * isXORプロパティをtrueにしたうえでtoggleプロパティもtrueにします.
         */
        private var xorGroup : XORGroupInteraction;
        private var _isXOR : Boolean;
        public function get isXOR() : Boolean
        {
            return _isXOR;
        }
        public function set isXOR(value : Boolean) : void
        {
            _isXOR = value;
            selectable = value;
            
            presetXOROperation();
            updateXORGroup();
        }

        private function presetXOROperation() : void
        {
            if (!_isXOR) return;

            _xorOparation = 
                _toggle ? 
                    new ButtonOparation(ButtonOparation.SELECT, ButtonOparation.ROLLOVER) : 
                    new ButtonOparation(ButtonOparation.SELECT, ButtonOparation.DISABLE);
        }

        private function updateXORGroup() : void
        {
            if (xorGroup) 
                xorGroup.dspose();
                
            if (!_isXOR) return;
            
            xorGroup = 
                new XORGroupInteraction(
                   buttons, 
                   -1, 
                   [MouseEvent.MOUSE_DOWN], 
                   _xorOparation
               );
            xorGroup.startInteraction();
        }
        
        
        /**
         * 選択状態のボタンのインデックス
         */
        public function get selectedIndex() : int
        {
            var selected : int = -1;
            if (_isXOR)
            {
                buttons.forEach(function(b : IButton, idx : int, ...param) : void
                {
                    if (b.selected) selected = idx;
                });
            }
            return selected;
        }
        public function set selectedIndex(index:int) : void
        {
            if (_isXOR)
                xorGroup.setXORStatus(index);
        }

        public function start() : void
        {
            _forEach("start");
        }

        public function stop() : void
        {
            _forEach("stop");
        }

        public function rollOverEffect() : void
        {
            _forEach("rollOverEffect");
        }

        public function rollOutEffect() : void
        {
            _forEach("rollOutEffect");
        }
        
        public function upEffect() : void
        {
            _forEach("upEffect");
        }
        
        public function lockBehaviors() : void
        {
            _forEach("lockBehavior");
        }

        public function unlockBehaviors() : void
        {
            _forEach("unlockBehavior");
        }

        public function getButton(index : int) : IButton
        {
            return buttons[index];
        }
        
        private function _forEach(methodName : String, ...param) : void
        {
            buttons.forEach(
                function(b : IBehaviorFluentAPI, ...p) : void
                {
                    var f:Function = b[methodName] as Function;
                    f.apply(b, param);
                }
            );
        }
        
        private function forEach_set(setterName : String, param:*) : void
        {
            buttons.forEach(
                function(b : IBehaviorFluentAPI, ...p) : void
                {
                    b[setterName] = param;
                }
            );
        }

        public function get behaviorDetail() : BehaviorDetail
        {
            return null;
        }

        public function set behaviorDetail(value : BehaviorDetail) : void
        {
            forEach_set("behaviorDetail", value);
        }
        
        override public function set mouseEnabled(enabled : Boolean) : void
        {
            super.mouseEnabled = enabled;
            forEach_set("mouseEnabled", enabled);
        }

        private var starGroup : StarGroupInteraction;
        private var _isStar : Boolean;
        public function get isStar() : Boolean
        {
            return _isStar;
        }
        public function set isStar(value : Boolean) : void
        {
            _isStar = value;
            selectable = value;
            
            if (starGroup) 
                starGroup.dspose();
                
            if (!value) return;
            
            starGroup = 
                new StarGroupInteraction(
                   buttons, 
                   -1, 
                   [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE], 
                   new ButtonOparation(ButtonOparation.SELECT)
               );
            starGroup.startInteraction();
        }

        public function filter(f : Function) : Array
        {
            return buttons.filter(f);
        }

        public function forEach(f : Function) : void
        {
            buttons.forEach(
                function(b : IButton, i:int, a:Array) : void
                {
                    if (f != null) f(b, i, a);
                }
            );
        }
    }
}
