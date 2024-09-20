package backend.cppFiles;

import openfl.Lib;
import lime.app.Application;

class CppAPI
{
	#if cpp
	public static function obtainRAM():Int
	{
		return WindowsData.obtainRAM();
	}

	public static function darkMode()
	{
		WindowsData.setWindowColorMode(DARK);
	}

	public static function lightMode()
	{
		WindowsData.setWindowColorMode(LIGHT);
	}

	public static function setWindowOppacity(a:Float)
	{
		Lib.application.window.opacity = a;
	}

	public static function _setWindowLayered()
	{
		WindowsData._setWindowLayered();
	}

	public static function hideTaskbar()
	{
		WindowsData.hideTaskbar();
	}

	public static function restoreTaskbar()
	{
		WindowsData.restoreTaskbar();
	}

	public static function hideWindows()
	{
		WindowsData.hideWindows();
	}

	public static function restoreWindows()
	{
		WindowsData.restoreWindows();
	}
	
	public static function removeWindowIcon()
	{
		WindowsData.removeWindowIcon();
	}

	public static function allowHighDPI() {
		WindowsData.registerHighDpi();
	}
	#end
}