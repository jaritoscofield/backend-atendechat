Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RESOLUCAO DE CONFLITOS DE SESSAO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Parando o servidor (se estiver rodando)..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "2. Executando diagnostico de sessoes..." -ForegroundColor Yellow
npm run diagnose-sessions

Write-Host ""
Write-Host "3. Limpando sessoes conflitantes..." -ForegroundColor Yellow
npm run clear-sessions

Write-Host ""
Write-Host "4. Iniciando o servidor..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "    SERVIDOR INICIANDO..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Aguarde alguns segundos para as sessoes se conectarem..." -ForegroundColor White
Write-Host ""
Write-Host "Para verificar o status, execute: npm run diagnose-sessions" -ForegroundColor Gray
Write-Host "Para ver os logs, monitore a saida do servidor" -ForegroundColor Gray
Write-Host ""

npm run dev:server

Read-Host "Pressione Enter para sair" 