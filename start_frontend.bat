@echo off
cd /d "%~dp0frontend"
npm.cmd install
npm.cmd run dev -- --host 127.0.0.1 --port 5173
