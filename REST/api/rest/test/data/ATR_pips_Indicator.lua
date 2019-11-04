-- More information about this indicator can be found at:
-- http://fxcodebase.com/code/viewtopic.php?f=17&t=4971

--+------------------------------------------------------------------+
--|                               Copyright © 2018, Gehtsoft USA LLC |
--|                                            http://fxcodebase.com |
--+------------------------------------------------------------------+
--|                                 Support our efforts by donating  |
--|                                    Paypal: https://goo.gl/9Rj74e |
--|                    BitCoin : 15VCJTLaz12Amr7adHSBtL9v8XomURo9RF  |
--|                BitCoin Cash: 1BEtS465S3Su438Kc58h2sqvVvHK9Mijtg  |
--|           Ethereum : 0x8C110cD61538fb6d7A2B47858F0c0AaBd663068D  |
--|                   LiteCoin : LLU8PSY2vsq7B9kRELLZQcKf5nJQrdeqwD  |
--+------------------------------------------------------------------+

function Init()
    indicator:name("ATR pips indicator");
    indicator:description("ATR pips indicator");
    indicator:requiredSource(core.Bar);
    indicator:type(core.Indicator);

    indicator.parameters:addGroup("Calculation");
    indicator.parameters:addInteger("Period", "Period", "", 13);
    indicator.parameters:addDouble("Multiplier", "Multiplier", "", 0.7);
	indicator.parameters:addDouble("AlertLevel", "Alert Level", "", 20);
    indicator.parameters:addString("Corner", "Corner", "", "0");
    indicator.parameters:addStringAlternative("Corner", "Top-Right", "", "0");
    indicator.parameters:addStringAlternative("Corner", "Top-Left", "", "1");
    indicator.parameters:addStringAlternative("Corner", "Bottom-Right", "", "2");
    indicator.parameters:addStringAlternative("Corner", "Bottom-Left", "", "3");

    indicator.parameters:addGroup("Style");
    indicator.parameters:addColor("Neutral", "Neutral Color", "Color", core.COLOR_LABEL );
	indicator.parameters:addColor("Color", "Neutral Color", "Color", core.rgb(0, 0, 255));
    indicator.parameters:addInteger("FontSize", "Font size", "", 20);
    indicator.parameters:addInteger("H_Shift", "Horizontal shift", "", 0);
    indicator.parameters:addInteger("V_Shift", "Vertical shift", "", 50);
end

local first;
local source = nil;
local Period;
local Multiplier;
local Corner;
local ATR;
local font;
local AlertLevel;
function Prepare(nameOnly)
    source = instance.source;
    Period=instance.parameters.Period;
    Multiplier=instance.parameters.Multiplier;
    Corner=tonumber(instance.parameters.Corner);
	
	
	AlertLevel=instance.parameters.AlertLevel;
	
	
    local name = profile:id() .. "(" .. source:name() .. ", " .. instance.parameters.Period .. ", " .. instance.parameters.Multiplier .. ")";
    instance:name(name);
    if nameOnly then
        return;
    end
    ATR = core.indicators:create("ATR", source, Period);
    first = ATR.DATA:first();
    font = core.host:execute("createFont", "Arial", instance.parameters.FontSize, true, false);
end

function Update(period, mode)
   if period<source:size()-1 
   or period < first
   then
   return;
   end
   
    ATR:update(mode);
    
    local LabelColor=instance.parameters.Neutral 
    local Value1= ((ATR.DATA[period]/source:pipSize())*Multiplier);			 
 	   
	if Value1 > AlertLevel then
	LabelColor=instance.parameters.Color;
    end
    
    local Text="" .. math.floor(Multiplier*100) .. "% of ATR (" .. Period .. "):" ..  string.format("%." .. math.max(2, source:getPrecision()) .. "f",( (ATR.DATA[period]*Multiplier)/source:pipSize()))  .. " pips";
    if Corner==0 then
     core.host:execute("drawLabel1", 1,-instance.parameters.H_Shift, core.CR_RIGHT,instance.parameters.V_Shift, core.CR_TOP, core.H_Left, core.V_Bottom, font,LabelColor,  Text);
    elseif Corner==1 then
     core.host:execute("drawLabel1", 1,instance.parameters.H_Shift, core.CR_LEFT,instance.parameters.V_Shift, core.CR_TOP, core.H_Right, core.V_Bottom, font, LabelColor,  Text);
    elseif Corner==2 then
     core.host:execute("drawLabel1", 1,-instance.parameters.H_Shift, core.CR_RIGHT,-instance.parameters.V_Shift, core.CR_BOTTOM, core.H_Left, core.V_Top, font, LabelColor,  Text);
    else
     core.host:execute("drawLabel1", 1,instance.parameters.H_Shift, core.CR_LEFT,-instance.parameters.V_Shift, core.CR_BOTTOM, core.H_Right, core.V_Top, font, LabelColor,  Text);
    end 

   
end

