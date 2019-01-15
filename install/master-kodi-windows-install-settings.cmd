@echo off
setlocal enabledelayedexpansion

rem Win32/64
rem need tools : curl.exe, nircmdc.exe, sed.exe, sqlite3.exe, file-convert.exe, wget.exe
rem Kodi v17.6 "Krypton"

cls

set kodiVer=18.0

set fontsUrl=https://github.com/jeryuni/fonts/raw/master
set sysFont=NanumBarunGothicBold.ttf
set smiFont=cinema.ttf

set addonsPath=%APPDATA%\kodi\addons
set fontsPath=%APPDATA%\kodi\media\Fonts
set userdataPath=%APPDATA%\kodi\userdata
set userdataAddonPath=%userdataPath%\addon_data
set guisettins=%userdataPath%\guisettings.xml
set addonsDb=%userdataPath%\Database\Addons27.db

set tempPath=%TEMP%\kodi
mkdir "%tempPath%" >nul 2>nul

set toolsUrl=https://github.com/jeryuni/windows/raw/master/tools
set wget=wget.exe -q --show-progress --no-check-certificate -O
set curl=curl.exe --create-dirs -kL#o
set sudo=nircmdc.exe elevate

set pass=%1
if not defined pass set pass=0

set kodiPath=%ProgramFiles%\kodi
if not exist "%kodiPath%\kodi.exe" goto :download

:checkVer
if %pass% equ pass goto :installAddons
echo ### Kodi ���� Ȯ�� ###
echo.
for /f "usebackq" %%i in (`powershell -command ^(Get-Item \"%kodiPath%\kodi.exe\"^).VersionInfo.FileVersion`) do if %%i==%kodiVer% goto :reset

:download
echo ### Kodi �ٿ�ε� ###
set kodiDown=http://mirrors.kodi.tv/releases/windows/win64/kodi-18.0-Leia_rc4-x64.exe
if not exist "%SystemRoot%\SysWOW64" set kodiDown=http://mirrors.kodi.tv/releases/windows/win32/kodi-18.0-Leia_rc4-x86.exe
%wget% "%tempPath%\%kodi%-%kodiVer%.exe" %kodiDown%
echo.

:install
call :kill
echo ### Kodi ��ġ ###
"%ProgramFiles(x86)%\kodi\Uninstall.exe" /S >nul 2>nul
"%ProgramFiles%\kodi\Uninstall.exe" /S >nul 2>nul
"%tempPath%\%kodi%-%kodiVer%.exe" /S
timeout /t 2 /nobreak >nul 2>nul
echo.
if not exist "%kodiPath%\kodi.exe" goto :eof

:reset
call :kill
if %pass% equ pass goto :fonts
echo ### Kodi �ʱ�ȭ ###
%sudo% sed.exe -i "s/\"true\"/\"false\"/i" "%kodiPath%\addons\service.xbmc.versioncheck\resources\settings.xml"
rd /s /q "%APPDATA%\kodi" >nul 2>nul
echo.

:fonts
call :kill
if %pass% equ pass goto :installAddons
echo ### Kodi �۲� �ٿ�ε� ###
mkdir "%fontsPath%" >nul 2>nul
echo + �ý��� �۲� %sysFont% �ٿ�ε� ###
%wget% "%fontsPath%\arial.ttf" %fontsUrl%/%sysFont%"
echo + �ڸ� �۲� %smiFont% �ٿ�ε� ###
%wget% "%fontsPath%\%smiFont%" %fontsUrl%/%smiFont%
echo.

:installAddons
call :start
echo ### Kodi �⺻ �ֵ�� ��ġ [����] ###
echo - �ֵ�� (Add-ons)
echo   - ���� ���Ͽ��� ��ġ (Install from zip file)
echo   - https://forum.kodi.tv/showthread.php?tid=307568
echo     + https://github.com/Alanon202/repository.alanon/raw/master/leia/repository.alanon/repository.alanon-1.0.2.zip
echo     + https://github.com/marcelveldt/repository.marcelveldt/raw/master/repository.marcelveldt/repository.marcelveldt-1.0.1.zip
echo - ����ҿ��� ��ġ (Install from repository) - ��� ����� (All repositories)
echo   - ���� (Look and feel)
echo     - ��Ų (Skin)
echo         + Eminence 2 MOD 3.X + �ƴϿ� (No)
echo     - �̹��� �÷��� (Image collections)
echo       + Movie Genre Icons - White
echo       + Weather Fanart - Faded
echo       + Weather Icons - 3D Coloured
echo     - ��� (Languages)
echo         + Korean + �ƴϿ� (No)
echo   - ���α׷� �ֵ�� (Program add-ons)
echo     + Global Search
echo     + Keymap Editor
rem echo   - ���� (Services)
rem echo     + Nextup Service Notification
echo   - ���� �ֵ�� (Video add-ons)
rem echo     + Library Data Provider
echo     + Google Drive
echo     + YouTube
echo   - ���� (Weather)
echo     + Gismeteo
echo.
pause
echo.

:settingAddonsManual
call :start
echo ### Kodi �ֵ�� ���� [����] ###
echo - �ֵ�� (Add-ons) - �� �ֵ�� (My add-ons) - ��ü (All)
echo   - AutoCompletion for virtual keyboard (plugin.program.autocompletion)
echo     - Autocompletion
echo       + Autocompletion language = ko
echo   - ExtendedInfo Script (script.extendedinfo)
echo     - TheMovieDB
echo       + Language for TheMovieDB requests = ko
echo       + Include adult actors / movies = üũ
echo     - Autocompletion
echo       + Autocompletion language = ko
echo   - Global Search (script.globalsearch)
echo     - �Ϲ� (General)
echo       + ��� �˻� (Search Actor) = üũ
echo       + Search Directors = üũ
rem echo   - Nextup Service Notification (service.nextup.notification)
rem echo     - Settings
rem echo       + The number of seconds before the end to show the notification = 15
rem echo       + Include watched episode = üũ
rem echo   - Skin Helper Service Widgets (script.skin.helper.widgets)
echo   - Google Drive (plugin.googledrive)
echo     - Services
echo       + Source server port - http://localhost:<port>/source = 18587
echo   - The Movie Database (metadata.themoviedb.org)
echo     - �Ϲ�
echo       + ��ȣ ��� (Preferred Language) = ko
echo       + ��� ���� ���� (Preferred Certification Country) = kr
echo       + Add also IMDb ratings = üũ
echo   - The TVDB (metadata.tvdb.com)
echo     - �Ϲ�
echo       + ��� = ko
echo       + Also get ratings from IMDb = üũ
echo   - Version Check (service.xbmc.versioncheck)
echo     - �Ϲ� (General)
echo       + Kodi ������ �˻��ϰڽ��ϱ�? (Enable Kodi version check?) = üũ ����
echo   - YouTube (plugin.video.youtube)
echo     - ��� (Advenced)
echo       + ���� ������ �� (Enable setup-wizard) = üũ ����
echo.
pause
echo.

:setting
call :kill
echo ### Kodi XML ���� ###
set xml=%kodiPath%\addons\skin.estuary\xml\Font.xml
echo + %xml% = 3,130 Arial - Default
%sudo% sed.exe -i -e "s/\"Default\" idloc[^>]*>/\"Arial\">/" -e "s/\"Arial\" idloc[^>]*>/\"Default\">/i" "%xml%"
set xml=%APPDATA%\Kodi\addons\skin.eminence.2.mod\16x9\Font.xml
echo + %xml% = 4,531 Arial - Default
sed.exe -i -e "1,20s/\"Default\"/\"Arial\"/" -e "21,$s/\"Arial\"/\"Default\"/i" "%xml%"
set xml=%APPDATA%\Kodi\addons\resource.language.ko_kr\resources\langinfo.xml
echo + %xml% = 6,13 M'��' D'��' - MM'��' DD'��' / 7 xx h - hh
sed.exe -i -e "s/ M'/ MM'/" -e "s/ D'/ DD'/" -e "s/xx h\:/hh\:/i" "%xml%"
echo.
pause
echo.

:guisettings
call :kill
echo ### Kodi �⺻ ���� - Eminence 2.0 MOD ��Ų ���� ###
echo - %guisettins%
echo - �������̽� (Interface)
echo   + ������ (Expert)
echo   - ��Ų (Skin)
echo     + ��Ų (Skin) = Eminence 2.0 MOD + �� (Yes)
echo   - ���� (Regional)
echo     + ��� (Language) = Korean
echo     + Ű���� ���̾ƿ� (Keyboard layouts) = Korean ������, English QWERTY
echo - ���̺귯�� (Library)
echo   - �Ϲ� (General)
echo     + ���� Ȯ���� ���� (Show file extensions) = üũ ����
echo - �ý��� (System)
echo   - �ֵ�� (Add-ons)
rem echo     + ������Ʈ (Updates) =  (Never check for updates)
rem -e "s/\(<addonupdates\) [^>]*>[^<]*/\1>2/" ^
echo     + �� �� ���� �ҽ� (Unknown sources) = üũ + �� (Yes)
echo - �÷��̾� (Player)
echo   - ���� (Videos)
echo     + ȭ�鿡 ��� ���� (Sync playback to display) = üũ
echo   - ��� (Language)
echo     + ��ȣ�ϴ� �ڸ� ��� (Preferred subtitle language) = Korean
echo     + �ؽ�Ʈ �ڸ��� ����� �۲� (Font to use for text subtitle) = cinema.ttf
echo     + ũ�� (Size) = 42
echo     + ��Ÿ�� (Style) = ����
echo - ���� (Services)
echo   - ��Ʈ�� (Control)
echo     + HTTP�� ���� ���� ���� ��� (Allow remote control via HTTP) = üũ
echo     + ����ڸ� (Username) = ��ĭ
echo     + �ٸ� �ý����� ���α׷��� ���� ���� ���� ��� (Allow remote control from applications on other systems) = üũ
echo   - UPnP / DLNA
echo     + UPnP ���� ��� (Enable UPnP support) = üũ
echo     + �� ���̺귯�� ���� (Share my libraries) = üũ
echo     + ���� UPnP �÷��̾� �˻� (Look for remote UPnP players) = üũ
echo     + UPnP�� ���� ���� ���� ��� (Allow remote control via UPnP) = üũ
echo   - ���� (Weather)
echo      + ���� ���� ���� (Service for weather information) = Gismeteo
file-convert.exe ansi "%guisettins%"
sed.exe -i ^
-e "s/\(<settinglevel>\)[^<]*/\13/i" ^
-e "s/\(\"lookandfeel.skin\"\)[^<]*/\1>skin.eminence.2.mod/i" ^
-e "s/\(\"locale.country\"\)[^<]*/\1>Korea (12h)/i" ^
-e "s/\(\"locale.language\"\)[^<]*/\1>resource.language.ko_kr/i" ^
-e "s/\(\"locale.keyboardlayouts\"\)[^<]*/\1>Korean ������|English QWERTY/i" ^
-e "s/\(\"filelists.showextensions\"\)[^<]*/\1>false/i" ^
-e "s/\(\"addons.unknownsources\"\)[^<]*/\1>true/i" ^
-e "s/\(\"videoplayer.usedisplayasclock\"\)[^<]*/\1>true/i" ^
-e "s/\(\"locale.subtitlelanguage\"\)[^<]*/\1>Korean/i" ^
-e "s/\(\"subtitles.font\"\)[^<]*/\1>cinema.ttf/i" ^
-e "s/\(\"subtitles.height\"\)[^<]*/\1>42/i" ^
-e "s/\(\"subtitles.style\"\)[^<]*/\1>0/i" ^
-e "s/\(\"services.webserver\"\)[^<]*/\1>true/i" ^
-e "s/\(\"services.webserverusername\"\)[^<]*/\1>/i" ^
-e "s/\(\"services.esallinterfaces\"\)[^<]*/\1>true/i" ^
-e "s/\(\"services.upnp\"\)[^<]*/\1>true/i" ^
-e "s/\(\"services.upnpserver\"\)[^<]*/\1>true/i" ^
-e "s/\(\"services.upnpcontroller\"\)[^<]*/\1>true/i" ^
-e "s/\(\"services.upnprenderer\"\)[^<]*/\1>true/i" ^
-e "s/\(\"weather.addon\"\)[^<]*/\1>weather.gismeteo/i" ^
"%guisettins%"
file-convert.exe utf8 "%guisettins%"
echo.
pause
echo.

rem :settingAddonsAuto
rem call :kill
rem echo ### Kodi �ֵ�� ���� ###
rem echo   - Eminence 2.0 MOD (skin.eminence.2.mod)
rem echo     + �ڵ� ������Ʈ = üũ ����
rem call :blacklist 1 skin.eminence.2.mod
rem echo.

:editSkin
call :kill
echo ### Eminence 2.0 MOD ��Ų XML ���� ###
set skinPath=%addonsPath%\skin.eminence.2.mod
set xml=%skinPath%\addon.xml
echo + %xml% = 4 version="3.0.2" - version="100"
sed.exe -i "4s/\(version=\).*/\1\"100\"/i" "%xml%"
set xml=%skinPath%\16x9\Defaults.xml
echo + %xml% = 149 delay="8000" time="4000" repeat="12000" - delay="3000" time="1000" repeat="3000"
sed.exe -i "s/delay=\"[0-9]\+\" time=\"[0-9]\+\" repeat=\"[0-9]\+\"/delay=\"3000\" time=\"1000\" repeat=\"3000\"/i" "%xml%"
set xml=%skinPath%\16x9\Home.xml
echo + %xml% = 34 EnableExtraFanart - EnableExtraFanart,false
sed.exe -i "s/\(EnableExtraFanart\)/\1,flase/i" "%xml%"
set xml=%skinPath%\16x9\Includes_Furniture.xml
echo + %xml% = 1220,1300 System.Time(hh:mm) - System.Time
sed.exe -i "s/(hh\:mm)//" "%xml%"
set xml=%skinPath%\16x9\MyVideoNav.xml
echo + %xml% = 196 multiimage - DisableExtraFanart
sed.exe -i "s/multiimage/DisableExtraFanart/i" "%xml%"
set xml=%skinPath%\16x9\Viewtype_Icon.xml
echo + %xml% = 341,371 DialogBG - $VAR[HighlightColor]
sed.exe -i "330,380s/DialogBG/\$VAR\[HighlightColor\]/i" "%xml%"
echo + %skinPath%\16x9\Viewtype_*.xml = justify - left
for /r "%skinPath%\16x9" %%f in (Viewtype_*.xml) do sed.exe -i "s/justify/left/i" "%%f"
echo.
pause
echo.

:settingSkin
call :kill
echo ### Eminence 2.0 MOD ��Ų ���� ###
set skinSettingPath=%userdataAddonPath%\skin.eminence.2.mod\settings.xml
echo - %skinSettingPath%
echo - ��Ų ����
echo   - Ȩ
echo     + Home tile icon = special://skin/icons/Ȩ.png
echo     + Home hearder text = �̵�� ����
echo     + Home bar colour and opacity = b2181818
echo   - Widgets
echo     + Show showcase widget on down = üũ ����
echo     + Allow widget reloading = üũ ����
echo     + Show widget posters = On Up
echo     + Show the widget item duration = üũ
echo     + Colour and opacity of the primary widget tile = b2181818
echo     + Colour and opacity of the secondary widget tile = b2181818
echo   - Background
echo     + Backgrounds rotation time = 15 seconds
echo     + Use dark interface = üũ
echo     + Show background video = üũ
echo     + Dim the settings screen = üũ
echo     + Background colour and opacity = b2181818
echo   - Library options
echo     + Show media flags = üũ
echo       + Choose flags = Coloured flags
echo     + Show duration flags = üũ
echo     + Use HH:MM duration format = üũ
echo     + Info displayed for episodes = Total Episodes
echo   - Video OSD
echo     + Show infos when pressing info = üũ
echo     + Show the info panel when video is paused = üũ
echo     + OSD Opacity = 70%
echo   - Headder ^& Hubs
echo     + Match header tile with highlight colour = üũ
echo     + Use bar in Hub menus = üũ
echo   - Colours
echo     + Pramary highlight colour = b323729b
echo   - Resources
echo     + Genre icons = Movie Genre Icons - White
echo     + Weather fanart = Weather Fanart - Faded
echo     + Weather icons = Weather Icons - 3D Colored
echo     + Show studio icons on video info screens = üũ
echo     + Studio icons = Studio Icons - White
echo.
rem -e "s/\(\"AlphabetScrollbar\"[^>]*\)>[^<]*/\1>true/i" ^
rem -e "s/\(\"showscrollbars\"[^>]*\)>[^<]*/\1>true/i" ^
file-convert.exe ansi "%skinSettingPath%"
sed.exe -i ^
-e "s/Media Center/�̵�� ����/i" ^
-e "s/\(\"home.headericon\"[^>]*\)>[^<]*/\1>special:\/\/skin\/extras\/icons\/0-home.png/i" ^
-e "s/\(\"HomeBarColor\"[^>]*\)>[^<]*/\1>b2181818/i" ^
-e "s/\(\"DisableShowcase\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"widgets.persistent\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"home.widgetposters\"[^>]*\)>[^<]*/\1>On Up/i" ^
-e "s/\(\"home.showduration\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"WidgetPrimaryColor\"[^>]*\)>[^<]*/\1>b2181818/i" ^
-e "s/\(\"WidgetSecondaryColor\"[^>]*\)>[^<]*/\1>b2181818/i" ^
-e "s/\(\"RotationLimit\"[^>]*\)>[^<]*/\1>3/i" ^
-e "s/\(\"darkoverlay\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"background.showvideo\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"darkensettings\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"BackgroundColor\"[^>]*\)>[^<]*/\1>b2181818/i" ^
-e "s/\(\"furniture.showflags\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"colouredflags\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"furniture.showtime\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"helperduration\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"episodesflags\"[^>]*\)>[^<]*/\1>Total Episodes/i" ^
-e "s/\(\"videoosd.showinfo\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"videoosd.showinfoonpause\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"OSDColor\"[^>]*\)>[^<]*/\1>70%/i" ^
-e "s/\(\"header.colormatch\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"hubbars\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"HighlightColor\"[^>]*\)>[^<]*/\1>b323729b/i" ^
-e "s/\(\"genre.icons.name\"[^>]*\)>[^<]*/\1>Movie Genre Icons - White/i" ^
-e "s/\(\"genre.icons.path\"[^>]*\)>[^<]*/\1>resource:\/\/resource.images.moviegenreicons.white\//i" ^
-e "s/\(\"genre.icons.ext\"[^>]*\)>[^<]*/\1>.jpg/i" ^
-e "s/\(\"weather.fanart.name\"[^>]*\)>[^<]*/\1>Weather Fanart - Faded/i" ^
-e "s/\(\"weather.fanart.path\"[^>]*\)>[^<]*/\1>resource:\/\/resource.images.weatherfanart.faded\//i" ^
-e "s/\(\"weather.fanart.ext\"[^>]*\)>[^<]*/\1>.jpg/i" ^
-e "s/\(\"weathericons.name\"[^>]*\)>[^<]*/\1>Weather Icons - 3D Coloured/i" ^
-e "s/\(\"weathericons.path\"[^>]*\)>[^<]*/\1>resource:\/\/resource.images.weathericons.3d-coloured\//i" ^
-e "s/\(\"weathericons.ext\"[^>]*\)>[^<]*/\1>.png/i" ^
-e "s/\(\"show.studio.logos\"[^>]*\)>[^<]*/\1>true/i" ^
-e "s/\(\"studio.logos.name\"[^>]*\)>[^<]*/\1>Studio Icons - White/i" ^
-e "s/\(\"studio.logos.path\"[^>]*\)>[^<]*/\1>resource:\/\/resource.images.studios.white\//i" ^
-e "s/\(\"studio.logos.ext\"[^>]*\)>[^<]*/\1>true/i" ^
"%skinSettingPath%"
file-convert.exe utf8 "%skinSettingPath%"
echo.
pause
echo.

:editSkinHomeMenue
call :start
echo ### Eminence 2.0 MOD ��Ų �޴� ���� [����] ###
echo - https://icons8.com/icons/
echo - ��Ų ���� - Ȩ - Customise home menu
echo   + ����, ����, Live TV, ����, ���α׷� = ����
echo   + �ֱ�, ��ȭ, TV��, ���, �ִϸ��̼�, ���, ����, ã��, ����, ���� = �߰� �� ���� ����
echo   - �ֱ�
echo   - ��ȭ
echo   - TV��
echo   - ���
echo   - �ִϸ��̼�
echo   - ���
echo   - ����
echo   - ���α׷�
echo   - ����
echo   - ����
echo.
pause
echo.

:delete
call :kill
echo ### Kodi ���ʿ� ������ ���� ###
call :rd "%addonsPath%\metadata.album.universal"
call :rd "%addonsPath%\metadata.artists.universal"
call :rd "%addonsPath%\metadata.common.allmusic.com"
call :rd "%addonsPath%\metadata.common.fanart.tv"
call :rd "%addonsPath%\metadata.common.imdb.com"
call :rd "%addonsPath%\metadata.common.musicbrainz.org"
call :rd "%addonsPath%\metadata.common.theaudiodb.com"
call :rd "%addonsPath%\metadata.common.themoviedb.org"
call :rd "%addonsPath%\metadata.themoviedb.org"
call :rd "%addonsPath%\metadata.tvdb.com"
call :rd "%addonsPath%\metadata.tvshows.themoviedb.org"
call :rd "%addonsPath%\packages"
rem call :rd "%addonsPath%\script.module.metadatautils"
call :rd "%addonsPath%\service.xbmc.versioncheck"
call :rd "%addonsPath%\temp"
call :rd "%userdataAddonPath%\peripheral.joystick"
call :rd "%userdataAddonPath%\plugin.program.autocompletion\Google"
call :rd "%userdataAddonPath%\plugin.video.youtube\kodion"
call :rd "%userdataAddonPath%\script.extendedinfo\TheMovieDB"
call :rd "%userdataAddonPath%\script.module.youtube.dl\tmp"
call :rd "%userdataAddonPath%\script.skin.helper.colorpicker"
call :rd "%userdataAddonPath%\service.xbmc.versioncheck"
call :rd "%userdataAddonPath%\weather.gismeteo\cache"
call :del "%userdataAddonPath%\plugin.video.youtube\*.json"
call :del "%userdataAddonPath%\weather.gismeteo\*.pcl"
echo.
pause
echo.

:disableAddons
echo ### Kodi �ֵ�� Disable ###
sqlite3.exe "%addonsDb%" "delete from installed where addonid = 'service.xbmc.versioncheck';" >nul 2>nul
echo.
sqlite3.exe "%addonsDb%" "update installed set enabled = 0 where addonid = 'service.xbmc.versioncheck';" >nul 2>nul

call :start

goto :eof

:kill
taskkill /im kodi.exe /t /f >nul 2>nul
:wait
timeout /t 1 /nobreak >nul 2>nul
tasklist /fi "IMAGENAME eq kodi.exe" | find /i "kodi.exe" >nul 2>nul
if %errorlevel% equ 0 goto :wait
timeout /t 2 /nobreak >nul 2>nul
exit /b

:start
start "" /b "%kodiPath%\kodi.exe"
exit /b

:blacklist
sqlite3.exe "%addonsDb%" "delete from blacklist where addonid = '%~2';" >nul 2>nul
sqlite3.exe "%addonsDb%" "insert into blacklist(id, addonID) values(%~1, '%~2');" >nul 2>nul
exit /b

:rd
rd /s /q "%~1" >nul 2>nul
exit /b

:del
del /f /q "%~1" >nul 2>nul
exit /b
