package;


import lime.app.Config;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {
	
	
	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	
	
	public static function init (config:Config):Void {
		
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
		
		var rootPath = null;
		
		if (config != null && Reflect.hasField (config, "rootPath")) {
			
			rootPath = Reflect.field (config, "rootPath");
			
		}
		
		if (rootPath == null) {
			
			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end
			
		}
		
		Assets.defaultRootPath = rootPath;
		
		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_tahoma_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_tahomabd_ttf);
		
		#end
		
		var data, manifest, library;
		
		data = '{"name":null,"assets":"aoy4:sizei2347y4:typey5:IMAGEy9:classNamey58:__ASSET__mobiledisplay_img_soft_keyboard_keyboard_icon_pngy2:idy55:mobiledisplay%2Fimg%2Fsoft-keyboard%2Fkeyboard-icon.pnggoR0i70163R1R2R3y63:__ASSET__mobiledisplay_img_soft_keyboard_keyboard_landscape_pngR5y60:mobiledisplay%2Fimg%2Fsoft-keyboard%2Fkeyboard-landscape.pnggoR0i74203R1R2R3y62:__ASSET__mobiledisplay_img_soft_keyboard_keyboard_portrait_pngR5y59:mobiledisplay%2Fimg%2Fsoft-keyboard%2Fkeyboard-portrait.pnggoR0i698368R1y4:FONTR3y25:__ASSET__fonts_tahoma_ttfR5y18:fonts%2Ftahoma.ttfgoR0i649608R1R11R3y27:__ASSET__fonts_tahomabd_ttfR5y20:fonts%2Ftahomabd.ttfgh","version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		
		
		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_icon_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_landscape_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_portrait_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__fonts_tahoma_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__fonts_tahomabd_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends flash.utils.ByteArray { }


#elseif (desktop || cpp)

@:image("../mobiledisplay/assets/img/soft-keyboard/keyboard-icon.png") #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_icon_png extends lime.graphics.Image {}
@:image("../mobiledisplay/assets/img/soft-keyboard/keyboard-landscape.png") #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_landscape_png extends lime.graphics.Image {}
@:image("../mobiledisplay/assets/img/soft-keyboard/keyboard-portrait.png") #if display private #end class __ASSET__mobiledisplay_img_soft_keyboard_keyboard_portrait_png extends lime.graphics.Image {}
@:font("assets/fonts/tahoma.ttf") #if display private #end class __ASSET__fonts_tahoma_ttf extends lime.text.Font {}
@:font("assets/fonts/tahomabd.ttf") #if display private #end class __ASSET__fonts_tahomabd_ttf extends lime.text.Font {}
@:file("") #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__fonts_tahoma_ttf') #if display private #end class __ASSET__fonts_tahoma_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "fonts/tahoma.ttf"; #end name = "Tahoma"; super (); }}
@:keep @:expose('__ASSET__fonts_tahomabd_ttf') #if display private #end class __ASSET__fonts_tahomabd_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "fonts/tahomabd.ttf"; #end name = "Tahoma Negreta"; super (); }}


#end

#if (openfl && !flash)

@:keep @:expose('__ASSET__OPENFL__fonts_tahoma_ttf') #if display private #end class __ASSET__OPENFL__fonts_tahoma_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__fonts_tahoma_ttf (); src = font.src; name = font.name; super (); }}
@:keep @:expose('__ASSET__OPENFL__fonts_tahomabd_ttf') #if display private #end class __ASSET__OPENFL__fonts_tahomabd_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__fonts_tahomabd_ttf (); src = font.src; name = font.name; super (); }}


#end
#end