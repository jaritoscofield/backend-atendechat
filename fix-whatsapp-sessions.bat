@echo off
echo ========================================
echo    RESOLUCAO DE CONFLITOS DE SESSAO
echo ========================================
echo.

echo 1. Parando o servidor (se estiver rodando)...
taskkill /f /im node.exe 2>nul
timeout /t 3 /nobreak >nul

echo.
echo 2. Executando diagnostico de sessoes...
npm run diagnose-sessions

echo.
echo 3. Limpando sessoes conflitantes...
npm run clear-sessions

echo.
echo 4. Iniciando o servidor...
echo.
echo ========================================
echo    SERVIDOR INICIANDO...
echo ========================================
echo.
echo Aguarde alguns segundos para as sessoes se conectarem...
echo.
echo Para verificar o status, execute: npm run diagnose-sessions
echo Para ver os logs, monitore a saida do servidor
echo.

npm run dev:server

pause 