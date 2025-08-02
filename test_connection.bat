@echo off
echo Testando conexao com PostgreSQL...
echo.

set DB_HOST=69.62.94.121
set DB_USER=atendechatpostgresql
set DB_PASS=atendechat-postgresql
set DB_NAME=atendechat-postgresql

echo Conectando ao banco...
echo Host: %DB_HOST%
echo User: %DB_USER%
echo Database: %DB_NAME%
echo.

set PGPASSWORD=%DB_PASS%
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -c "SELECT version();"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Conexao OK! Executando setup...
    echo.
    psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f setup_flow.sql
) else (
    echo.
    echo Erro na conexao!
    echo Verifique se:
    echo - A VPS esta online
    echo - O PostgreSQL esta rodando
    echo - As credenciais estao corretas
    echo - A porta 5432 esta aberta
)

pause 