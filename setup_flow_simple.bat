@echo off
echo =====================================================
echo CONFIGURACAO DO FLOW BUILDER
echo =====================================================
echo.

REM Carregar variáveis do arquivo .env
if exist ".env" (
    echo Arquivo .env encontrado!
    echo Carregando variaveis de ambiente...
    
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
        )
    )
    
    echo Variaveis carregadas com sucesso!
    echo.
) else (
    echo Arquivo .env nao encontrado!
    pause
    exit /b 1
)

REM Verificar se as variáveis foram carregadas
if "%DB_HOST%"=="" (
    echo Variavel DB_HOST nao encontrada!
    pause
    exit /b 1
)

if "%DB_USER%"=="" (
    echo Variavel DB_USER nao encontrada!
    pause
    exit /b 1
)

if "%DB_PASS%"=="" (
    echo Variavel DB_PASS nao encontrada!
    pause
    exit /b 1
)

if "%DB_NAME%"=="" (
    echo Variavel DB_NAME nao encontrada!
    pause
    exit /b 1
)

echo Todas as variaveis de ambiente encontradas!
echo.
echo Configurando Flow Builder...
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