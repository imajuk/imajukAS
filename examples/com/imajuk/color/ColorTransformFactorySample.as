package com.imajuk.color
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.ColorChooser;
    import com.bit101.components.Component;
    import com.bit101.components.HUISlider;
    import com.bit101.components.Panel;
    import com.bit101.utils.MinimalConfigurator;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class ColorTransformFactorySample extends Sprite
    {
        [Embed (source="test5.png")]
        private var img : Class;
        [Embed (source="test.png")]
        private var img2 : Class;
        private var img_tint : DisplayObject;
        private var img_tint2 : DisplayObject;
        private var config_tint : MinimalConfigurator;
        private var config_tint2 : MinimalConfigurator;
        private var img_light : *;
        private var config_light : MinimalConfigurator;
        private var img_inv : *;
        private var config_inv : MinimalConfigurator;

        public function ColorTransformFactorySample()
        {
            Component.initStage(stage);
            
            //=================================
            // Tint
            //=================================
            var xml : XML = <comp>
                    <VBox x="10" y="10">
                        <Panel id="prv_tint" width="104" height="104" />
                        <Label text="TINT" />
                        <ColorChooser id="tint" value="0" usePopup="true" />
                        <HUISlider id="alp" label="alpha" value="1" minimum="0" maximum="1" width="140"/>
                        <HUISlider id="amt" label="amount" value="1" minimum="0" maximum="1" width="140"/>
                    </VBox>
                </comp>;

            img_tint = new img();
            img_tint.x = img_tint.y = 2;
            config_tint = init(xml, img_tint, "prv_tint");
            config_tint.getCompById("tint").addEventListener(Event.CHANGE, changeTint);
            config_tint.getCompById("alp").addEventListener(Event.CHANGE, changeTint);
            config_tint.getCompById("amt").addEventListener(Event.CHANGE, changeTint);
            
            //=================================
            // 2way Tint
            //=================================
            var xml_tint2 : XML = <comp>
                    <VBox x="130" y="10">
                        <Panel id="prv_tint2" width="104" height="104" />
                        <Label text="2way TINT" />
                        <ColorChooser id="tint2a" value="0" usePopup="true" />
                        <ColorChooser id="tint2b" value="0xffffff" usePopup="true" />
                        <HUISlider id="amt2" label="amount" value="1" minimum="0" maximum="1" width="140"/>
                    </VBox>
                </comp>;

            img_tint2 = new img2();
            img_tint2.x = img_tint2.y = 2;
            config_tint2 = init(xml_tint2, img_tint2, "prv_tint2");
            config_tint2.getCompById("tint2a").addEventListener(Event.CHANGE, changeTint2);
            config_tint2.getCompById("tint2b").addEventListener(Event.CHANGE, changeTint2);
            config_tint2.getCompById("amt2").addEventListener(Event.CHANGE, changeTint2);
            
            //=================================
            // lightness
            //=================================
            var xml_light : XML = <comp>
                    <VBox x="250" y="10">
                        <Panel id="prv_light" width="104" height="104" />
                        <Label text="LIGHTNESS" />
                        <CheckBox id="offset" label="lightness_offset"/>
                        <HUISlider id="light" label="lightness" value="0" minimum="-255" maximum="255" width="140"/>
                        <HUISlider id="amt_light" label="amount" value="1" minimum="0" maximum="1" width="140"/>
                    </VBox>
                </comp>;

            img_light = new img();
            img_light.x = img_light.y = 2;
            config_light = init(xml_light, img_light, "prv_light");
            config_light.getCompById("light").addEventListener(Event.CHANGE, changeLightness);
            config_light.getCompById("amt_light").addEventListener(Event.CHANGE, changeLightness);

            //=================================
            // Negative
            //=================================
            var xml_inv : XML = <comp>
                    <VBox x="370" y="10">
                        <Panel id="prv_inv" width="104" height="104" />
                        <Label text="INVERT" />
                        <HUISlider id="invert" label="invert" value="0" minimum="0" maximum="1" width="140"/>
                    </VBox>
                </comp>;

            img_inv = new img();
            img_inv.x = img_inv.y = 2;
            config_inv = init(xml_inv, img_inv, "prv_inv");
            config_inv.getCompById("invert").addEventListener(Event.CHANGE, changeInvert);
        }

        private function changeInvert(event : Event) : void
        {
            var amt : Number = Number(HUISlider(config_inv.getCompById("invert")).value);
            img_inv.transform.colorTransform = 
                    ColorTransformUtils.createInvert(amt);
        }

        private function changeLightness(event : Event) : void
        {
            var light : Number = Number(HUISlider(config_light.getCompById("light")).value);
            var amt : Number = Number(HUISlider(config_light.getCompById("amt_light")).value);
            img_light.transform.colorTransform = 
                CheckBox(config_light.getCompById("offset")).selected ? 
                    ColorTransformUtils.createLightness_offset(light, amt):
                    ColorTransformUtils.createLightness(light, amt);
        }

        private function changeTint2(event : Event) : void
        {
            var color : uint = ColorChooser(config_tint2.getCompById("tint2a")).value;
            var color2 : uint = ColorChooser(config_tint2.getCompById("tint2b")).value;
            var amt : Number = Number(HUISlider(config_tint2.getCompById("amt2")).value);
            img_tint2.transform.colorTransform = 
                ColorTransformUtils.create2WayTint(
                    Color.fromRGB(color), 
                    Color.fromRGB(color2), 
                    amt
                );
        }

        private function init(xml : XML, sample:DisplayObject, prev:String) : MinimalConfigurator
        {
            var config : MinimalConfigurator = new MinimalConfigurator(this);
            config.parseXML(xml);

            Panel(config.getCompById(prev)).addRawChild(sample);

            return config;
        }

        private function changeTint(event : Event) : void
        {
            var color : uint = ColorChooser(config_tint.getCompById("tint")).value;
            var alp : Number = Number(HUISlider(config_tint.getCompById("alp")).value);
            var amt : Number = Number(HUISlider(config_tint.getCompById("amt")).value);
            alp *= 255;
            img_tint.transform.colorTransform = ColorTransformUtils.createTint(Color.fromARGB(uint(uint(alp << 24) | color)), amt);
        }
    }
}
