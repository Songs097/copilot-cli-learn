@echo off
cd /d "C:\Users\hzhang208\Documents\CLI-LEARN"
echo Checking for Git...
git --version >nul 2>&1 || (
  echo Git not found. Install Git: https://git-scm.com/download/win
  pause
  exit /b 1
)
echo Initializing git repository...
git init
git config user.name "hongsong97@163.com"
git config user.email "hongsong97@163.com"
echo Current git config:
git config --list
echo.
echo Initialization complete. Press any key to exit.
pause
