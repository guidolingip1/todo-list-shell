@echo off
setlocal enabledelayedexpansion

rem create files to store the todos and categories
if not exist todos.txt type nul > todos.txt
if not exist categories.txt type nul > categories.txt

rem define the main menu
:menu
cls
rem display the todos with line numbers at the top of the shell
echo Your todos:
for /f "tokens=*" %%a in (categories.txt) do (
    echo.
    echo [101;93m %%a [0m
    for /f "tokens=*" %%b in ('type todos.txt ^| find " [%%a]"') do (
        for /f "tokens=1 delims=[" %%c in ("%%b") do echo %%c
    )
)
echo.
echo Choose an option:
echo 1. Add a todo
echo 2. Remove a todo
echo 3. Add a category
echo 4. Exit
echo.
set /p choice=Enter your choice: 

rem validate the choice
if "%choice%"=="1" goto add_todo
if "%choice%"=="2" goto remove
if "%choice%"=="3" goto add_category
if "%choice%"=="4" goto end
echo Invalid choice, please try again.
pause
goto menu

rem define the add_todo function
:add_todo
cls
rem display the todos with line numbers at the top of the shell
echo Your todos:
for /f "tokens=*" %%a in (categories.txt) do (
    echo.
    echo [101;93m %%a [0m
    for /f "tokens=*" %%b in ('type todos.txt ^| find " [%%a]"') do (
        for /f "tokens=1 delims=[" %%c in ("%%b") do echo %%c
    )
)
echo.
echo Add a todo
echo.
set /p todo=Enter your todo: 
rem list existing categories as options and prompt for category selection or new category entry
set /a count=0
for /f "tokens=*" %%a in (categories.txt) do (
    set /a count+=1
    set category[!count!]=%%a
    echo !count!. %%a
)
set /p category_choice=Enter the number of the category: 
set category=!category[%category_choice%]!

rem append the todo to the file with a line number and category
set /a count=0
for /f "delims=" %%a in (todos.txt) do set /a count+=1
set /a count+=1
echo %count%. %todo% [%category%] >> todos.txt

echo Todo added successfully!
pause 
goto menu

rem define the add_category function 
:add_category 
cls 
rem display the categories at the top of the shell 
echo Your categories: 
type categories.txt 
echo. 
echo Add a category 
echo. 
set /p category=Enter your category:  
rem append the category to the file 
echo %category% >> categories.txt 

echo Category added successfully! 
pause  
goto menu 

rem define the remove function
:remove
cls
rem display the todos with line numbers at the top of the shell
echo Your todos:
type todos.txt
echo.
echo Remove a todo
echo.
set /p num=Enter the number of the todo to remove: 
rem validate the number
set /a count=0
for /f "delims=" %%a in (todos.txt) do set /a count+=1
if %num% LSS 1 goto invalid
if %num% GTR %count% goto invalid

rem create a temporary file to store the updated todos
type nul > temp.txt

rem loop through the todos and copy only those that do not match the number to remove
set /a n=0
for /f "tokens=1* delims=. " %%a in (todos.txt) do (
    set /a n+=1
    if not !n!==%num% echo %%a. %%b >> temp.txt
)

rem overwrite the original file with the temporary file and delete the temporary file
move /y temp.txt todos.txt >nul

echo Todo removed successfully!
pause
goto menu

rem define the invalid input handler
:invalid
echo Invalid input, please try again.
pause 
goto remove

rem define the end function  
:end  
cls  
echo Thank you for using the todo-list app!  
exit  
