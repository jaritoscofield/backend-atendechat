# =====================================================
# 🛠️ CONFIGURAÇÃO DO FLOW BUILDER - VERSÃO SIMPLES
# =====================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   CONFIGURACAO DO FLOW BUILDER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Executando script SQL para configurar o flow..." -ForegroundColor Yellow
Write-Host ""

# Substitua as credenciais do seu banco de dados
try {
    psql -h localhost -U postgres -d atendechat -f setup_flow_simple.sql
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "    CONFIGURACAO CONCLUIDA" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Agora reinicie o servidor e teste o flow!" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host "Erro ao executar o script SQL:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique se:" -ForegroundColor Yellow
    Write-Host "1. O PostgreSQL está instalado" -ForegroundColor White
    Write-Host "2. O psql está no PATH" -ForegroundColor White
    Write-Host "3. As credenciais estão corretas" -ForegroundColor White
    Write-Host ""
}

Read-Host "Pressione Enter para sair" 