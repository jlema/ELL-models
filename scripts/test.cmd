setlocal

set "model_path=%cd%"
call :file_name_from_path model %model_path%
set ip=%1
set ell_root=c:\work\ELL

pushd %ell_root%\build\tools\utilities\pitest
python drivetest.py %ip% --config %model_path%\%model%_config.json --labels %model_path%\..\ImageNetLabels.txt --model %model_path%\%model%.ell.zip
popd

REM Assumes one-time copy of validation set to /home/pi/validation
REM 
REM pushd %ell_root%\build\tools\utilities\pythonlibs\gallery
REM python copy_validation_set.py path_to_val_map.txt folder_path_to_unzipped_validation_set %ip% --maxfiles 50
REM popd
REM

pushd %ell_root%\build\tools\utilities\pythonlibs\gallery
python run_validation.py %model% %ip% --maxfiles 30 --labels ImageNetLabels.txt
move %model%_validation.json %model_path%\%model%_validation_pi3.json
popd
goto :eof

:file_name_from_path <resultVar> <pathVar>
(
    set "%~1=%~nx2"
    exit /b
)

endlocal