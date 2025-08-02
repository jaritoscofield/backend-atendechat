# =====================================================
# 🛠️ CONFIGURAÇÃO DO FLOW BUILDER - COM .ENV
# =====================================================

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "🛠️ CONFIGURAÇÃO DO FLOW BUILDER" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o arquivo .env existe
if (Test-Path ".env") {
    Write-Host "✅ Arquivo .env encontrado!" -ForegroundColor Green
    Write-Host "Carregando variáveis de ambiente..." -ForegroundColor Yellow
    
    # Carregar variáveis do .env
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "  $name = $value" -ForegroundColor Gray
        }
    }
    
    Write-Host "✅ Variáveis carregadas com sucesso!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "❌ Arquivo .env não encontrado!" -ForegroundColor Red
    Write-Host "Certifique-se de que o arquivo .env existe no diretório atual." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Verificar se as variáveis foram carregadas
$dbHost = $env:DB_HOST
$dbUser = $env:DB_USER
$dbPass = $env:DB_PASS
$dbName = $env:DB_NAME

if (-not $dbHost -or -not $dbUser -or -not $dbPass -or -not $dbName) {
    Write-Host "❌ Variáveis de ambiente faltando:" -ForegroundColor Red
    if (-not $dbHost) { Write-Host "  - DB_HOST" -ForegroundColor Red }
    if (-not $dbUser) { Write-Host "  - DB_USER" -ForegroundColor Red }
    if (-not $dbPass) { Write-Host "  - DB_PASS" -ForegroundColor Red }
    if (-not $dbName) { Write-Host "  - DB_NAME" -ForegroundColor Red }
    Write-Host ""
    Write-Host "💡 Verifique se o arquivo .env está correto" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "✅ Todas as variáveis de ambiente encontradas!" -ForegroundColor Green
Write-Host ""

# Verificar se o psql está disponível
try {
    $null = & psql --version 2>$null
    Write-Host "✅ PostgreSQL client encontrado!" -ForegroundColor Green
} catch {
    Write-Host "❌ PostgreSQL client (psql) não encontrado!" -ForegroundColor Red
    Write-Host "Instale o PostgreSQL client ou execute manualmente o arquivo setup_flow.sql" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""
Write-Host "🔧 Executando setup_flow.sql..." -ForegroundColor Cyan
Write-Host ""

# Executar o arquivo SQL
$env:PGPASSWORD = $dbPass
& psql -h $dbHost -U $dbUser -d $dbName -f "setup_flow.sql"

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