package;
import lime.system.DisplayMode;
import lime.system.System;

import nativetext.event.NativeTextEvent;
import nativetext.NativeText;
import nativetext.NativeTextField;
import nativetext.NativeTextFieldAlignment;
import nativetext.NativeTextFieldConfig;
import nativetext.NativeTextFieldKeyboardType;
import nativetext.NativeTextFieldReturnKeyType;

import openfl.display.DisplayObjectContainer;
import lime.text.UTF8String;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

import openfl.text.TextField;
import openfl.events.FocusEvent;

import extension.androidImmersive.AndroidImmersive;



/** * ... * @author ... vikingx84 */
class UniversalInputText extends Sprite
{
	private static var textFields:Array<UniversalInputText> = new Array<UniversalInputText>();
	
	public static function setVisibleAll(_bool:Bool):Void {
		var i:Int = textFields.length;
		while (--i >= 0) {
			textFields[i].setVisible(_bool);
		}
	}
	
	private var inputField:TextField;
	private var defaultTextField:TextField;
	private var defaultText:UTF8String;
	private var color:UInt;
	private var defaultColor:UInt;
	
	private var nativePoint:Point = new Point();
	private var config:NativeTextFieldConfig;
	public var nativeTextField:NativeTextField;
	private var maxChars:Int;
	private var size:Int;
	private var textFieldWidth:Int;
	private var numbers:Bool = false;
	
	public function new(_text:UTF8String, _defaultText:UTF8String, _width:Int, _height:Int, _size:Int, _color:UInt, _numbers:Bool = false, _maxChars:Int = 64, _defaultColor:UInt = 0xcececc, _isPassword:Bool = false)
	{
		super();
		numbers = _numbers;
		textFieldWidth = _width;
		size = _size;
		defaultText = _defaultText;
		defaultColor = _defaultColor;
		color = _color;
		maxChars = _maxChars;
		
		#if (android || ios)
			NativeText.Initialize();
			config = {
				x: 0,
				y: 0,
				width: _width,
				height: NativeTextField.AUTOSIZE,
				visible: true,
				enabled: true,
				placeholder: defaultText,
				fontAsset: "assets/font/OpenSans-Regular.ttf",		// TODO: No effect yet
				fontSize: 55,
				fontColor: _color,
				textAlignment: NativeTextFieldAlignment.Left,
				keyboardType: NativeTextFieldKeyboardType.Default,
				returnKeyType: NativeTextFieldReturnKeyType.Done,
			};
			
			config.isPassword = _isPassword;
			
			if (_numbers) config.keyboardType = NativeTextFieldKeyboardType.Decimal;
			
			nativeTextField = new NativeTextField(config);
			nativeTextField.SetText(_text);
			
			addEventListener(Event.ENTER_FRAME, update);
			
			nativeTextField.addEventListener(NativeTextEvent.FOCUS_OUT, onNativeFocus);
		#else
			inputField = Fonts.getTextField("", _width, _height, _size, _color, openfl.text.TextFormatAlign.LEFT, Fonts.TAHOMA, true);
			if (_numbers) inputField.restrict = "0-9";
			
			inputField.maxChars = _maxChars;
			inputField.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			inputField.addEventListener(FocusEvent.FOCUS_OUT, onFocus);
			inputField.displayAsPassword = _isPassword;
			addChild(inputField);
			
			defaultTextField = Fonts.getTextField(_defaultText, _width, _height, _size, _defaultColor, openfl.text.TextFormatAlign.LEFT, Fonts.TAHOMA);
			defaultTextField.mouseEnabled = false;
			addChild(defaultTextField);
			
			updateInputText();
		#end
		
		textFields.push(this);
	}
	
	private function onNativeFocus(e:NativeTextEvent):Void {
		AndroidImmersive.setImmersive();
	}
	
	public function setVisible(_bool:Bool):Void {
		#if (android || ios)
			config.visible = _bool;
			nativeTextField.Configure(config);
		#else
			inputField.visible = _bool;
		#end
	}
	
	public function setFocus():Void {
		#if (android || ios)
			nativeTextField.SetFocus();
		#else
			stage.focus = inputField;
		#end
	}
	
	public function update(e:MouseEvent):Void {
		#if (android || ios)
			var str:UTF8String = nativeTextField.GetText();
			if (numbers) {
				var numList:String = "0123456789";
				var i:Int = 0;
				var filtered:String = "";
				
				while (i < str.length) {
					if (numList.indexOf(str.charAt(i)) >= 0) {
						filtered = filtered + str.charAt(i);
					}
					i++;
				}
				if (str != filtered) {
					str = filtered;
					nativeTextField.SetText(str);
				}
			}	
			
			if (str.length > maxChars) {
				nativeTextField.ClearFocus();
				str = str.substr(0, maxChars);
				nativeTextField.SetText(str);
			}
			setXY(nativePoint.x, nativePoint.y);
		#else
		#end
	}
	
	private function onFocus(e:FocusEvent):Void {
		if (e.type == FocusEvent.FOCUS_IN) defaultTextField.visible = false;
		if (e.type == FocusEvent.FOCUS_OUT) updateInputText();
		
		if (e.type == FocusEvent.FOCUS_OUT) AndroidImmersive.setImmersive();
	}
	
	public function setXY(_x:Float, _y:Float):Void {
		#if (android || ios)
			nativePoint.setTo(_x, _y);
			var point:Point = new Point(_x * scaleX, _y * scaleY);
			var totalScale:Float = 1;
			var doc:DisplayObjectContainer = this;
			while (doc.parent != null) {
				doc = doc.parent;
				
				point.x += doc.x;
				point.y += doc.y;
				
				point.x = point.x * doc.scaleX;
				point.y = point.y * doc.scaleY;
				
				totalScale = totalScale * doc.scaleX;
			}
			var mode:DisplayMode = System.getDisplay(0).supportedModes[0];
			point.x = point.x * (Math.min(mode.width, mode.height) / System.getDisplay(0).currentMode.width);
			point.y = point.y * (Math.max(mode.width, mode.height) / System.getDisplay(0).currentMode.height);
			
			if (config.x != point.x || config.y != point.y) {
				config.x = point.x;
				config.y = point.y;
				
				config.width = Math.ceil(textFieldWidth * totalScale);
				config.fontSize = Math.ceil(size * totalScale);
				
				nativeTextField.Configure(config);
			}
		#else
			inputField.x = defaultTextField.x = _x;
			inputField.y = defaultTextField.y = _y;
		#end
	}
	
	public function setWidth(_width:Float):Void {
		#if (android || ios)
			config.width = _width;
			nativeTextField.Configure(config);
		#else
			inputField.width = _width;
		#end
	}
	
	public var text(get, set):String;
	private function get_text():String {
		#if (android || ios)
			return nativeTextField.GetText();
		#else
			return inputField.text;
		#end
	}
	private function set_text(_str:UTF8String):String {
		#if (android || ios)
			nativeTextField.SetText(_str);
		#else
			inputField.text = _str;
		#end
		updateInputText();
		return _str;
	}
	
	
	private function updateInputText():Void {
		#if (android || ios)
		#else
			if (inputField.text == "") {
				defaultTextField.visible = true;
			} else {
				defaultTextField.visible = false;
			}
		#end
	}
	
	public var length(get, never):Int;
	private function get_length():Int {
		#if (android || ios)
			return nativeTextField.GetText().length;
		#else
			return inputField.text.length;
		#end
	}
	
	
	public var selectable(get, set):Bool;
	private function get_selectable():Bool {
		#if (android || ios)
			return config.enabled;
		#else
			return inputField.selectable;
		#end
	}
	private function set_selectable(_bool:Bool):Bool {
		#if (android || ios)
			config.enabled = _bool;
			nativeTextField.Configure(config);
		#else
			inputField.selectable = _bool;
		#end
		return _bool;
	}
	
	public function destroy():Void {
		#if (android || ios)
			nativeTextField.ClearFocus();
			nativeTextField.Destroy();
			removeEventListener(Event.ENTER_FRAME, update);
			nativeTextField.removeEventListener(NativeTextEvent.FOCUS_OUT, onNativeFocus);
		#else
			inputField.removeEventListener(FocusEvent.FOCUS_IN, onFocus);
			inputField.removeEventListener(FocusEvent.FOCUS_OUT, onFocus);
			removeChild(inputField);
			inputField = null;
			
			removeChild(defaultTextField);
			defaultTextField = null;
		#end
		
		var i:Int = textFields.length;
		while (--i >= 0) {
			if (textFields[i] == this) {
				textFields.splice(i, 1);
			}
		}
	}
	
	
}