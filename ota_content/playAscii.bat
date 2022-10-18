@echo off
PAUSE
for /f tokens^=* %%f in ('where allxonAscii:*') do (
    CALL :PLAY "%%f"
)

GOTO :EXIT

:PLAY
type "%~1"
for /l %%x in (1, 1, 4000) do (
    break
)
cls
:EXIT