@echo off
chcp 65001 >nul
echo =====================================================
echo 🛠️ CONFIGURAÇÃO DO FLOW BUILDER
echo =====================================================
echo.

REM Carregar variáveis do arquivo .env
if exist ".env" (
    echo ✅ Arquivo .env encontrado!
    echo Carregando variáveis de ambiente...
    
    for /f "tokens=1,2 delims==" %%a in (.env) do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
        )
    )
    
    echo ✅ Variáveis carregadas com sucesso!
    echo.
) else (
    echo ❌ Arquivo .env não encontrado!
    echo Certifique-se de que o arquivo .env existe no diretório atual.
    pause
    exit /b 1
)

REM Verificar se as variáveis foram carregadas
if "%DB_HOST%"=="" (
    echo ❌ Variável DB_HOST não encontrada!
    echo Verifique se o arquivo .env está correto.
    pause
    exit /b 1
)

if "%DB_USER%"=="" (
    echo ❌ Variável DB_USER não encontrada!
    echo Verifique se o arquivo .env está correto.
    pause
    exit /b 1
)

if "%DB_PASS%"=="" (
    echo ❌ Variável DB_PASS não encontrada!
    echo Verifique se o arquivo .env está correto.
    pause
    exit /b 1
)

if "%DB_NAME%"=="" (
    echo ❌ Variável DB_NAME não encontrada!
    echo Verifique se o arquivo .env está correto.
    pause
    exit /b 1
)

echo ✅ Todas as variáveis de ambiente encontradas!
echo.
echo 📊 Configurando Flow Builder...
echo.

REM Verificar se o psql está disponível
psql --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ PostgreSQL client (psql) não encontrado!
    echo Instale o PostgreSQL client ou execute manualmente o arquivo setup_flow.sql
    pause
    exit /b 1
)

echo ✅ PostgreSQL client encontrado!
echo.

REM Executar o arquivo SQL
echo 🔧 Executando setup_flow.sql...
echo.

set PGPASSWORD=%DB_PASS%
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f setup_flow.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Flow configurado com sucesso!
    echo.
    echo 🚀 Próximos passos:
    echo   1. Reinicie o servidor: npm run dev:server
    echo   2. Envie 'oi' no WhatsApp
    echo   3. Verifique se o flow ativa
    echo.
) else (
    echo.
    echo ❌ Erro ao configurar o flow!
    echo Verifique as credenciais do banco de dados
    echo.
)

pause 