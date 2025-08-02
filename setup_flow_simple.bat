@echo off
echo ========================================
echo    CONFIGURACAO DO FLOW BUILDER
echo ========================================
echo.

echo Executando script SQL para configurar o flow...
echo.

REM Substitua as credenciais do seu banco de dados
psql -h localhost -U postgres -d atendechat -f setup_flow_simple.sql

echo.
echo ========================================
echo    CONFIGURACAO CONCLUIDA
echo ========================================
echo.
echo Agora reinicie o servidor e teste o flow!
echo.

pause 