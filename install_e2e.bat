@echo off
echo === Installation des tests E2E ===
cd /d %~dp0e2e
npm install
echo.
echo === Installation du navigateur ===
npx playwright install chromium
echo.
echo === Lancement des tests ===
npx playwright test --headed
pause