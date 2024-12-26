@echo off

for /D %%i in (.\solutions\*) do (
        @echo %%~ni
        @.\scripts\run.bat %%~ni
)
