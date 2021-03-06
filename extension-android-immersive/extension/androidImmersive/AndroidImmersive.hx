package extension.androidImmersive;

class AndroidImmersive {
	
	#if (android)
		public static var setStatusBarColor:Int->Void = lime.system.JNI.createStaticMethod("org/haxe/extension/AndroidImmersive", "setStatusBarColor", "(I)V");
		public static var setLowProfile:Void->Void = lime.system.JNI.createStaticMethod("org/haxe/extension/AndroidImmersive", "setLowProfile", "()V");
		public static var setImmersive:Void->Void = lime.system.JNI.createStaticMethod("org/haxe/extension/AndroidImmersive", "setImmersive", "()V");
	#else
		public static var setStatusBarColor:Int->Void = function(i:Int){};
		public static var setLowProfile:Void->Void = function(){};
		public static var setImmersive:Void->Void = function(){};
	#end 

}