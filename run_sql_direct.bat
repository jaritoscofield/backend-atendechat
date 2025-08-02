@echo off
echo =====================================================
echo EXECUTANDO SETUP DO FLOW BUILDER
echo =====================================================
echo.

REM Definir variáveis diretamente
set DB_HOST=69.62.94.121
set DB_USER=atendechatpostgresql
set DB_PASS=atendechat-postgresql
set DB_NAME=atendechat-postgresql

echo Variaveis configuradas:
echo DB_HOST=%DB_HOST%
echo DB_USER=%DB_USER%
echo DB_NAME=%DB_NAME%
echo.

REM Verificar se o psql está disponível
psql --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo PostgreSQL client (psql) nao encontrado!
    echo Instale o PostgreSQL client ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

echo PostgreSQL client encontrado!
echo.

REM Executar o arquivo SQL
echo Executando setup_flow.sql...
echo.

set PGPASSWORD=%DB_PASS%
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f setup_flow.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Flow configurado com sucesso!
    echo.
    echo Proximos passos:
    echo   1. Reinicie o servidor: npm run dev:server
    echo   2. Envie 'oi' no WhatsApp
    echo   3. Verifique se o flow ativa
    echo.
) else (
    echo.
    echo Erro ao configurar o flow!
    echo Verifique as credenciais do banco de dados
    echo.
)

pause 