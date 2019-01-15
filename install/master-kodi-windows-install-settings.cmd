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
echo ### Kodi 버전 확인 ###
echo.
for /f "usebackq" %%i in (`powershell -command ^(Get-Item \"%kodiPath%\kodi.exe\"^).VersionInfo.FileVersion`) do if %%i==%kodiVer% goto :reset

:download
echo ### Kodi 다운로드 ###
set kodiDown=http://mirrors.kodi.tv/releases/windows/win64/kodi-18.0-Leia_rc4-x64.exe
if not exist "%SystemRoot%\SysWOW64" set kodiDown=http://mirrors.kodi.tv/releases/windows/win32/kodi-18.0-Leia_rc4-x86.exe
%wget% "%tempPath%\%kodi%-%kodiVer%.exe" %kodiDown%
echo.

:install
call :kill
echo ### Kodi 설치 ###
"%ProgramFiles(x86)%\kodi\Uninstall.exe" /S >nul 2>nul
"%ProgramFiles%\kodi\Uninstall.exe" /S >nul 2>nul
"%tempPath%\%kodi%-%kodiVer%.exe" /S
timeout /t 2 /nobreak >nul 2>nul
echo.
if not exist "%kodiPath%\kodi.exe" goto :eof

:reset
call :kill
if %pass% equ pass goto :fonts
echo ### Kodi 초기화 ###
%sudo% sed.exe -i "s/\"true\"/\"false\"/i" "%kodiPath%\addons\service.xbmc.versioncheck\resources\settings.xml"
rd /s /q "%APPDATA%\kodi" >nul 2>nul
echo.

:fonts
call :kill
if %pass% equ pass goto :installAddons
echo ### Kodi 글꼴 다운로드 ###
mkdir "%fontsPath%" >nul 2>nul
echo + 시스템 글꼴 %sysFont% 다운로드 ###
%wget% "%fontsPath%\arial.ttf" %fontsUrl%/%sysFont%"
echo + 자막 글꼴 %smiFont% 다운로드 ###
%wget% "%fontsPath%\%smiFont%" %fontsUrl%/%smiFont%
echo.

:installAddons
call :start
echo ### Kodi 기본 애드온 설치 [수동] ###
echo - 애드온 (Add-ons)
echo   - 압축 파일에서 설치 (Install from zip file)
echo   - https://forum.kodi.tv/showthread.php?tid=307568
echo     + https://github.com/Alanon202/repository.alanon/raw/master/leia/repository.alanon/repository.alanon-1.0.2.zip
echo     + https://github.com/marcelveldt/repository.marcelveldt/raw/master/repository.marcelveldt/repository.marcelveldt-1.0.1.zip
echo - 저장소에서 설치 (Install from repository) - 모든 저장소 (All repositories)
echo   - 모양새 (Look and feel)
echo     - 스킨 (Skin)
echo         + Eminence 2 MOD 3.X + 아니요 (No)
echo     - 이미지 컬렉션 (Image collections)
echo       + Movie Genre Icons - White
echo       + Weather Fanart - Faded
echo       + Weather Icons - 3D Coloured
echo     - 언어 (Languages)
echo         + Korean + 아니요 (No)
echo   - 프로그램 애드온 (Program add-ons)
echo     + Global Search
echo     + Keymap Editor
rem echo   - 서비스 (Services)
rem echo     + Nextup Service Notification
echo   - 비디오 애드온 (Video add-ons)
rem echo     + Library Data Provider
echo     + Google Drive
echo     + YouTube
echo   - 날씨 (Weather)
echo     + Gismeteo
echo.
pause
echo.

:settingAddonsManual
call :start
echo ### Kodi 애드온 설정 [수동] ###
echo - 애드온 (Add-ons) - 내 애드온 (My add-ons) - 전체 (All)
echo   - AutoCompletion for virtual keyboard (plugin.program.autocompletion)
echo     - Autocompletion
echo       + Autocompletion language = ko
echo   - ExtendedInfo Script (script.extendedinfo)
echo     - TheMovieDB
echo       + Language for TheMovieDB requests = ko
echo       + Include adult actors / movies = 체크
echo     - Autocompletion
echo       + Autocompletion language = ko
echo   - Global Search (script.globalsearch)
echo     - 일반 (General)
echo       + 배우 검색 (Search Actor) = 체크
echo       + Search Directors = 체크
rem echo   - Nextup Service Notification (service.nextup.notification)
rem echo     - Settings
rem echo       + The number of seconds before the end to show the notification = 15
rem echo       + Include watched episode = 체크
rem echo   - Skin Helper Service Widgets (script.skin.helper.widgets)
echo   - Google Drive (plugin.googledrive)
echo     - Services
echo       + Source server port - http://localhost:<port>/source = 18587
echo   - The Movie Database (metadata.themoviedb.org)
echo     - 일반
echo       + 선호 언어 (Preferred Language) = ko
echo       + 등급 기준 국가 (Preferred Certification Country) = kr
echo       + Add also IMDb ratings = 체크
echo   - The TVDB (metadata.tvdb.com)
echo     - 일반
echo       + 언어 = ko
echo       + Also get ratings from IMDb = 체크
echo   - Version Check (service.xbmc.versioncheck)
echo     - 일반 (General)
echo       + Kodi 버전을 검사하겠습니까? (Enable Kodi version check?) = 체크 해제
echo   - YouTube (plugin.video.youtube)
echo     - 고급 (Advenced)
echo       + 설정 마법사 켬 (Enable setup-wizard) = 체크 해제
echo.
pause
echo.

:setting
call :kill
echo ### Kodi XML 수정 ###
set xml=%kodiPath%\addons\skin.estuary\xml\Font.xml
echo + %xml% = 3,130 Arial - Default
%sudo% sed.exe -i -e "s/\"Default\" idloc[^>]*>/\"Arial\">/" -e "s/\"Arial\" idloc[^>]*>/\"Default\">/i" "%xml%"
set xml=%APPDATA%\Kodi\addons\skin.eminence.2.mod\16x9\Font.xml
echo + %xml% = 4,531 Arial - Default
sed.exe -i -e "1,20s/\"Default\"/\"Arial\"/" -e "21,$s/\"Arial\"/\"Default\"/i" "%xml%"
set xml=%APPDATA%\Kodi\addons\resource.language.ko_kr\resources\langinfo.xml
echo + %xml% = 6,13 M'월' D'일' - MM'월' DD'일' / 7 xx h - hh
sed.exe -i -e "s/ M'/ MM'/" -e "s/ D'/ DD'/" -e "s/xx h\:/hh\:/i" "%xml%"
echo.
pause
echo.

:guisettings
call :kill
echo ### Kodi 기본 설정 - Eminence 2.0 MOD 스킨 기준 ###
echo - %guisettins%
echo - 인터페이스 (Interface)
echo   + 전문가 (Expert)
echo   - 스킨 (Skin)
echo     + 스킨 (Skin) = Eminence 2.0 MOD + 예 (Yes)
echo   - 지역 (Regional)
echo     + 언어 (Language) = Korean
echo     + 키보드 레이아웃 (Keyboard layouts) = Korean ㄱㄴㄷ, English QWERTY
echo - 라이브러리 (Library)
echo   - 일반 (General)
echo     + 파일 확장자 보기 (Show file extensions) = 체크 해제
echo - 시스템 (System)
echo   - 애드온 (Add-ons)
rem echo     + 업데이트 (Updates) =  (Never check for updates)
rem -e "s/\(<addonupdates\) [^>]*>[^<]*/\1>2/" ^
echo     + 알 수 없는 소스 (Unknown sources) = 체크 + 예 (Yes)
echo - 플레이어 (Player)
echo   - 비디오 (Videos)
echo     + 화면에 재생 동기 (Sync playback to display) = 체크
echo   - 언어 (Language)
echo     + 선호하는 자막 언어 (Preferred subtitle language) = Korean
echo     + 텍스트 자막에 사용할 글꼴 (Font to use for text subtitle) = cinema.ttf
echo     + 크기 (Size) = 42
echo     + 스타일 (Style) = 보통
echo - 서비스 (Services)
echo   - 컨트롤 (Control)
echo     + HTTP를 통한 원격 제어 허용 (Allow remote control via HTTP) = 체크
echo     + 사용자명 (Username) = 빈칸
echo     + 다른 시스템의 프로그램에 의한 원격 제어 허용 (Allow remote control from applications on other systems) = 체크
echo   - UPnP / DLNA
echo     + UPnP 지원 사용 (Enable UPnP support) = 체크
echo     + 내 라이브러리 공유 (Share my libraries) = 체크
echo     + 원격 UPnP 플레이어 검색 (Look for remote UPnP players) = 체크
echo     + UPnP를 통한 원격 제어 허용 (Allow remote control via UPnP) = 체크
echo   - 날씨 (Weather)
echo      + 날씨 정보 서비스 (Service for weather information) = Gismeteo
file-convert.exe ansi "%guisettins%"
sed.exe -i ^
-e "s/\(<settinglevel>\)[^<]*/\13/i" ^
-e "s/\(\"lookandfeel.skin\"\)[^<]*/\1>skin.eminence.2.mod/i" ^
-e "s/\(\"locale.country\"\)[^<]*/\1>Korea (12h)/i" ^
-e "s/\(\"locale.language\"\)[^<]*/\1>resource.language.ko_kr/i" ^
-e "s/\(\"locale.keyboardlayouts\"\)[^<]*/\1>Korean ㄱㄴㄷ|English QWERTY/i" ^
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
rem echo ### Kodi 애드온 설정 ###
rem echo   - Eminence 2.0 MOD (skin.eminence.2.mod)
rem echo     + 자동 업데이트 = 체크 해제
rem call :blacklist 1 skin.eminence.2.mod
rem echo.

:editSkin
call :kill
echo ### Eminence 2.0 MOD 스킨 XML 수정 ###
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
echo ### Eminence 2.0 MOD 스킨 설정 ###
set skinSettingPath=%userdataAddonPath%\skin.eminence.2.mod\settings.xml
echo - %skinSettingPath%
echo - 스킨 설정
echo   - 홈
echo     + Home tile icon = special://skin/icons/홈.png
echo     + Home hearder text = 미디어 센터
echo     + Home bar colour and opacity = b2181818
echo   - Widgets
echo     + Show showcase widget on down = 체크 해제
echo     + Allow widget reloading = 체크 해제
echo     + Show widget posters = On Up
echo     + Show the widget item duration = 체크
echo     + Colour and opacity of the primary widget tile = b2181818
echo     + Colour and opacity of the secondary widget tile = b2181818
echo   - Background
echo     + Backgrounds rotation time = 15 seconds
echo     + Use dark interface = 체크
echo     + Show background video = 체크
echo     + Dim the settings screen = 체크
echo     + Background colour and opacity = b2181818
echo   - Library options
echo     + Show media flags = 체크
echo       + Choose flags = Coloured flags
echo     + Show duration flags = 체크
echo     + Use HH:MM duration format = 체크
echo     + Info displayed for episodes = Total Episodes
echo   - Video OSD
echo     + Show infos when pressing info = 체크
echo     + Show the info panel when video is paused = 체크
echo     + OSD Opacity = 70%
echo   - Headder ^& Hubs
echo     + Match header tile with highlight colour = 체크
echo     + Use bar in Hub menus = 체크
echo   - Colours
echo     + Pramary highlight colour = b323729b
echo   - Resources
echo     + Genre icons = Movie Genre Icons - White
echo     + Weather fanart = Weather Fanart - Faded
echo     + Weather icons = Weather Icons - 3D Colored
echo     + Show studio icons on video info screens = 체크
echo     + Studio icons = Studio Icons - White
echo.
rem -e "s/\(\"AlphabetScrollbar\"[^>]*\)>[^<]*/\1>true/i" ^
rem -e "s/\(\"showscrollbars\"[^>]*\)>[^<]*/\1>true/i" ^
file-convert.exe ansi "%skinSettingPath%"
sed.exe -i ^
-e "s/Media Center/미디어 센터/i" ^
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
echo ### Eminence 2.0 MOD 스킨 메뉴 수정 [수동] ###
echo - https://icons8.com/icons/
echo - 스킨 설정 - 홈 - Customise home menu
echo   + 비디오, 음악, Live TV, 사진, 프로그램 = 삭제
echo   + 최근, 영화, TV쇼, 드라마, 애니메이션, 어린이, 날씨, 찾기, 설정, 전원 = 추가 및 순서 수정
echo   - 최근
echo   - 영화
echo   - TV쇼
echo   - 드라마
echo   - 애니메이션
echo   - 어린이
echo   - 날씨
echo   - 프로그램
echo   - 설정
echo   - 전원
echo.
pause
echo.

:delete
call :kill
echo ### Kodi 불필요 데이터 삭제 ###
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
echo ### Kodi 애드온 Disable ###
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
