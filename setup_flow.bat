@echo off
echo =====================================================
echo 🛠️ CONFIGURAÇÃO DO FLOW BUILDER
echo =====================================================
echo.

REM Verificar se as variáveis de ambiente estão definidas
if "%DB_HOST%"=="" (
    echo ❌ Variável DB_HOST não encontrada!
    echo Por favor, configure as variáveis de ambiente do banco de dados
    echo ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

if "%DB_USER%"=="" (
    echo ❌ Variável DB_USER não encontrada!
    echo Por favor, configure as variáveis de ambiente do banco de dados
    echo ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

if "%DB_PASS%"=="" (
    echo ❌ Variável DB_PASS não encontrada!
    echo Por favor, configure as variáveis de ambiente do banco de dados
    echo ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

if "%DB_NAME%"=="" (
    echo ❌ Variável DB_NAME não encontrada!
    echo Por favor, configure as variáveis de ambiente do banco de dados
    echo ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

echo ✅ Variáveis de ambiente encontradas!
echo.
echo 📊 Configurando Flow Builder...
echo.

REM Executar o arquivo SQL
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f setup_flow.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Flow configurado com sucesso!
    echo.
    echo 🚀 Agora reinicie o servidor e teste enviando "oi" no WhatsApp
    echo.
) else (
    echo.
    echo ❌ Erro ao configurar o flow!
    echo Verifique as credenciais do banco de dados
    echo.
)

pause 