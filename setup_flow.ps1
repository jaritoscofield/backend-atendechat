# =====================================================
# 🛠️ CONFIGURAÇÃO DO FLOW BUILDER
# =====================================================
# Script PowerShell para configurar o Flow Builder
# =====================================================

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "🛠️ CONFIGURAÇÃO DO FLOW BUILDER" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o arquivo .env existe
if (Test-Path ".env") {
    Write-Host "✅ Arquivo .env encontrado!" -ForegroundColor Green
    
    # Carregar variáveis do .env
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
    
    Write-Host "✅ Variáveis do .env carregadas!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Arquivo .env não encontrado!" -ForegroundColor Yellow
    Write-Host "Certifique-se de que as variáveis de ambiente estão configuradas:" -ForegroundColor Yellow
    Write-Host "  - DB_HOST" -ForegroundColor Yellow
    Write-Host "  - DB_USER" -ForegroundColor Yellow
    Write-Host "  - DB_PASS" -ForegroundColor Yellow
    Write-Host "  - DB_NAME" -ForegroundColor Yellow
    Write-Host ""
}

# Verificar se as variáveis estão definidas
$requiredVars = @("DB_HOST", "DB_USER", "DB_PASS", "DB_NAME")
$missingVars = @()

foreach ($var in $requiredVars) {
    if (-not $env:$var) {
        $missingVars += $var
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host "❌ Variáveis de ambiente faltando:" -ForegroundColor Red
    foreach ($var in $missingVars) {
        Write-Host "  - $var" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "💡 Dicas:" -ForegroundColor Yellow
    Write-Host "  1. Configure as variáveis no arquivo .env" -ForegroundColor Yellow
    Write-Host "  2. Ou execute manualmente o arquivo setup_flow.sql" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "✅ Todas as variáveis de ambiente encontradas!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Configurando Flow Builder..." -ForegroundColor Cyan
Write-Host ""

# Verificar se o psql está disponível
try {
    $psqlVersion = & psql --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ PostgreSQL client encontrado!" -ForegroundColor Green
    } else {
        throw "psql não encontrado"
    }
} catch {
    Write-Host "❌ PostgreSQL client (psql) não encontrado!" -ForegroundColor Red
    Write-Host "Instale o PostgreSQL client ou execute manualmente o arquivo setup_flow.sql" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Executar o arquivo SQL
Write-Host "🔧 Executando setup_flow.sql..." -ForegroundColor Cyan
Write-Host ""

$env:PGPASSWORD = $env:DB_PASS
& psql -h $env:DB_HOST -U $env:DB_USER -d $env:DB_NAME -f "setup_flow.sql"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Flow configurado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Próximos passos:" -ForegroundColor Cyan
    Write-Host "  1. Reinicie o servidor: npm run dev:server" -ForegroundColor White
    Write-Host "  2. Envie 'oi' no WhatsApp" -ForegroundColor White
    Write-Host "  3. Verifique se o flow ativa" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Erro ao configurar o flow!" -ForegroundColor Red
    Write-Host "Verifique as credenciais do banco de dados" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Pressione Enter para sair" 