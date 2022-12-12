@echo off

:: get directory name
SET yyyymm=202212
SET dd=0%1
SET yyyymmdd=%yyyymm%%dd:~-2%
md %yyyymmdd%

:: create part1.jl
echo #=>> %yyyymmdd%\part1.jl
echo.>> %yyyymmdd%\part1.jl
echo =#>> %yyyymmdd%\part1.jl

:: create part2.jl
echo #=>> %yyyymmdd%\part2.jl
echo.>> %yyyymmdd%\part2.jl
echo =#>> %yyyymmdd%\part2.jl

:: create empty file for ex.txt
type NUL >> %yyyymmdd%\ex.txt

echo New directory %yyyymmdd% populated.
