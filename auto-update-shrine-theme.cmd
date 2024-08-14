@echo off
:: Đặt biến cho thư mục làm việc hiện tại
set "current_dir=%~dp0"
set "output_dir=%current_dir%Update"
set "old_theme_dir=%output_dir%\old_theme"
set "new_theme_dir=%output_dir%\new_theme"

:: Tìm file zip của old theme và new theme trong thư mục hiện tại
for %%f in ("%current_dir%theme_export*.zip") do (
    set "old_theme_zip=%%f"
)

for %%f in ("%current_dir%Shrine_Theme*.zip") do (
    set "new_theme_zip=%%f"
)

:: Kiểm tra nếu file zip được tìm thấy
if not defined old_theme_zip (
    echo "Không tìm thấy file zip của old theme."
    pause
    exit /b
)

if not defined new_theme_zip (
    echo "Không tìm thấy file zip của new theme."
    pause
    exit /b
)

:: Tạo thư mục output nếu chưa tồn tại
if not exist "%output_dir%" mkdir "%output_dir%"
if not exist "%old_theme_dir%" mkdir "%old_theme_dir%"
if not exist "%new_theme_dir%" mkdir "%new_theme_dir%"

:: Bước 1: Giải nén các file
tar -xf "%old_theme_zip%" -C "%old_theme_dir%"
tar -xf "%new_theme_zip%" -C "%new_theme_dir%"

:: Bước 2: Xóa các thư mục cũ
rmdir /S /Q "%old_theme_dir%\assets"
rmdir /S /Q "%old_theme_dir%\snippets"
rmdir /S /Q "%old_theme_dir%\sections"

:: Bước 3: Sao chép các thư mục mới
xcopy /E /I /Y "%new_theme_dir%\assets" "%old_theme_dir%\assets"
xcopy /E /I /Y "%new_theme_dir%\snippets" "%old_theme_dir%\snippets"
xcopy /E /I /Y "%new_theme_dir%\sections" "%old_theme_dir%\sections"

:: Bước 4: Thay thế file settings_schema.json
del "%old_theme_dir%\config\settings_schema.json"
copy "%new_theme_dir%\config\settings_schema.json" "%old_theme_dir%\config\"

:: Bước 5: Thay thế file theme.liquid
del "%old_theme_dir%\layout\theme.liquid"
copy "%new_theme_dir%\layout\theme.liquid" "%old_theme_dir%\layout\"

:: Bước 6: Tạo file zip mới từ 7 thư mục bên trong mà không bao gồm thư mục cha
cd /d "%old_theme_dir%"
tar -cf "%output_dir%\updated_theme.zip" -C "%old_theme_dir%" assets config layout locales sections snippets templates
echo Update xong theme Shrine. Luong Yen chuc ban mot ngay lam viec hieu qua!
pause
