package backend.window;

import lime.ui.Window;

#if windows
@:cppFileCode('#
#include <Windows.h>
#include <windowsx.h>
#include <cstdio>
#include <iostream>
#include <tchar.h>
#include <dwmapi.h>
#include <winuser.h>
#include <winternl.h>
#include <Shlobj.h>
#include <commctrl.h>
#include <string>
#include <stdlib.h>
#include <stdio.h>
#include <strsafe.h>
#include <shellapi.h>

#define UNICODE

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "ntdll.lib")
#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Shell32.lib")
#pragma comment(lib, "gdi32.lib")
')#end
class SnailWindowUtils {

    #if windows @:functionCode('
    HWND window = GetActiveWindow();

    COLORREF color;
    if (r == 0xFE && g == 0xFE && b == 0xFE) {
        color = 0xFFFFFFFE; 
    } else {
        color = RGB(r, g, b);
    }
        
    DwmSetWindowAttribute(window, 35, &color, sizeof(COLORREF));
    DwmSetWindowAttribute(window, 34, &color, sizeof(COLORREF));

    UpdateWindow(window);
    ')#end
    public static function changeWindowColor(r:ByteUInt=0xff, g:ByteUInt=0xff, b:ByteUInt=0xff){}


    //yeah, fuck it, now it's based on chroma :fire:
    #if windows @:functionCode('
    HWND hWnd = GetActiveWindow();
    res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
    if (res)
    {
        SetLayeredWindowAttributes(hWnd, RGB(r, g, b), active?1:0, LWA_COLORKEY);
    }
    ') #end
    public static function transparentWindow(active:Bool = true, r:ByteUInt=1, g:ByteUInt=1, b:ByteUInt=1, ?res:Int = 0){}

    #if windows @:functionCode('
    HWND hWnd = GetActiveWindow();

    if (SetLayeredWindowAttributes != nullptr) {
        LONG_PTR style = GetWindowLongPtr(hWnd, GWL_EXSTYLE);
        SetWindowLongPtr(hWnd, GWL_EXSTYLE, style | WS_EX_LAYERED);

        SetLayeredWindowAttributes(hWnd, RGB(0, 0, 0), opacity, LWA_ALPHA);
    }
    ') #end
    public static function setWindowOpacity(opacity:Float=255){/*FlxG.stage.window.opacity = opacity; sorry neo, this doesn't work*/}

    public static function setBorderlessWindow(hide:Bool){
        lime.app.Application.current.window.borderless = hide;
    }

    #if windows @:functionCode('
    NOTIFYICONDATA m_NID;

        memset(&m_NID, 0, sizeof(m_NID));
        m_NID.cbSize = sizeof(m_NID);
        m_NID.hWnd = GetForegroundWindow();
        m_NID.uFlags = NIF_MESSAGE | NIIF_WARNING | NIS_HIDDEN;

        m_NID.uVersion = NOTIFYICON_VERSION_4;

        if (!Shell_NotifyIcon(NIM_ADD, &m_NID))
            return FALSE;

        Shell_NotifyIcon(NIM_SETVERSION, &m_NID);

        m_NID.uFlags |= NIF_INFO;
        m_NID.uTimeout = 1000;
        m_NID.dwInfoFlags = NULL;

        LPCTSTR lTitle = title.c_str();
        LPCTSTR lDesc = desc.c_str();

        if (StringCchCopy(m_NID.szInfoTitle, sizeof(m_NID.szInfoTitle), lTitle) != S_OK)
            return FALSE;

        if (StringCchCopy(m_NID.szInfo, sizeof(m_NID.szInfo), lDesc) != S_OK)
            return FALSE;

    return Shell_NotifyIcon(NIM_MODIFY, &m_NID);
    ') #end
    public static function sendNotification(title:String = "", desc:String = ""){return 0;}
    /*@:functionCode('
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    ')
    public static function setWallpaper(path:String){}

    @:functionCode('
    var path = new String(260);
        SystemParametersInfo(SPI_GETDESKWALLPAPER, 260, path, 0);
        return path;
    ')
    public static function saveWallpaper(){}*/

    #if windows @:functionCode('
    HWND hWnd = GetActiveWindow();
    RECT rect;
    GetWindowRect(hWnd, &rect);
    int x, y;
    int width = rect.right - rect.left;
    int height = rect.bottom - rect.top;
    x = (GetSystemMetrics (SM_CXSCREEN) - width) / 2;
    y = (GetSystemMetrics (SM_CYSCREEN) - height) / 2;
    MoveWindow (hWnd, x, y, width, height, TRUE);
    ') #end
    public static function centerWindow(){}

    #if windows @:functionCode('
    HWND hWnd = GetActiveWindow();
    x = (GetSystemMetrics (SM_CXSCREEN) - 1280) / 2;
    return x;
    ') #end
    public static function getWindowCenterPosX(x:Int = 0){return x;}

    #if windows @:functionCode('
    HWND hWnd = GetActiveWindow();
    y = (GetSystemMetrics (SM_CYSCREEN) - 720) / 2;
    return y;
    ')#end
    public static function getWindowCenterPosY(y:Int = 0){return y;}
}