package;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author ... vikingx84
 */
class Main extends Sprite 
{
	private var inputContainer:Sprite;
	
	public function new() 
	{
		super();
		
		inputContainer = new Sprite();
		addChild(inputContainer);
		
		var csf:Float = stage.stageWidth / 480;
		var input:UniversalInputText = new UniversalInputText("", "Enter your message here", Math.ceil(300*csf), Math.ceil(60*csf), Math.ceil(30*csf), 0xffffff, false, 256, 0xcececc, false);
		inputContainer.addChild(input);
		
		stage.addEventListener(MouseEvent.CLICK, onMouse);
	}
	
	private function onMouse(e:MouseEvent):Void {
		Actuate.tween(inputContainer, 2, { y:mouseY });
	}
}
