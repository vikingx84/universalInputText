package;
import lime.text.UTF8String;
import openfl.Assets;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
/** * ... * @author vikingx84 */
class Fonts 
{
	public static var TAHOMA:String = "fonts/tahoma.ttf";
	public static var TAHOMABD:String = "fonts/tahomabd.ttf";
	
	public static function getTextField(_text:UTF8String, _width:Int, _height:Int, _fontSize:Int, _fontColor:UInt = 0x4F0000, _align:TextFormatAlign = TextFormatAlign.CENTER, _font:String = "", _isInput:Bool = false):TextField {
		var textFormat:TextFormat = new TextFormat((_font == "") ? null:Assets.getFont(_font).fontName, _fontSize, _fontColor, null, null, null, null, null, _align);
		var textField:TextField = new TextField();
		
		if (_isInput) {
			textField.type = TextFieldType.INPUT;
			textField.wordWrap = false;
			textField.selectable = true;
			textField.multiline = false;
			textField.embedFonts = true;
		} else {
			textField.wordWrap = true;
			textField.selectable = false;
			textField.multiline = true;
			textField.embedFonts = true;
		}
		
		textField.text = _text;
		textField.width = _width;
		textField.height = _height;
		
		textField.defaultTextFormat = textFormat;
		textField.setTextFormat(textFormat);
		textField.antiAliasType = AntiAliasType.NORMAL;
		
		return textField;
	}
	
	public function new() {}
}