# Solução para Conflito de Sessões do WhatsApp

## Problema Identificado

O erro `"stream errored out"` com `"conflict":{"type":"replaced"}` indica que há um conflito de sessão do WhatsApp. Isso acontece quando:

1. **Múltiplas instâncias** tentam usar a mesma sessão simultaneamente
2. **A sessão é substituída** por outra instância (ex: WhatsApp Web em outro dispositivo)
3. **Dados de sessão corrompidos** no banco de dados
4. **Reconexão automática** conflitando com sessão existente

## Sintomas

- Logs mostrando: `{"level":50,"msg":"stream errored out","node":{"tag":"conflict","attrs":{"type":"replaced"}}}`
- Sessões que conectam e desconectam rapidamente
- Status inconsistente entre banco de dados e memória
- QR codes que não funcionam

## Soluções Implementadas

### 1. Tratamento Automático de Conflitos

O código foi atualizado para detectar e tratar automaticamente conflitos de sessão:

```typescript
// Listener para erros de stream
wsocket.ev.on("stream:error", async (error) => {
  if (error?.node?.content?.[0]?.tag === "conflict" && 
      error?.node?.content?.[0]?.attrs?.type === "replaced") {
    // Limpar dados da sessão e reconectar
    await whatsapp.update({ 
      status: "PENDING", 
      session: "",
      qrcode: "" 
    });
    // Aguardar 5 segundos antes de tentar reconectar
    setTimeout(() => StartWhatsAppSession(whatsapp, whatsapp.companyId), 5000);
  }
});
```

### 2. Scripts de Diagnóstico e Limpeza

#### Diagnóstico de Sessões
```bash
npm run diagnose-sessions
```
Este comando mostra:
- Status de todas as sessões
- Sessões com problemas
- Resumo por status
- Verificação de sessões na memória

#### Limpeza de Sessões Conflitantes
```bash
npm run clear-sessions
```
Este comando:
- Limpa todas as sessões ativas
- Reseta status para PENDING
- Remove dados de sessão corrompidos
- Prepara para nova conexão

## Como Resolver o Problema

### Opção 1: Script Automático (Recomendado)

#### Windows (PowerShell):
```powershell
.\fix-whatsapp-sessions.ps1
```

#### Windows (CMD):
```cmd
fix-whatsapp-sessions.bat
```

### Opção 2: Manual

#### Passo 1: Diagnosticar
```bash
npm run diagnose-sessions
```

#### Passo 2: Limpar Sessões (se necessário)
```bash
npm run clear-sessions
```

#### Passo 3: Reiniciar o Serviço
```bash
# Parar o serviço atual
# Reiniciar com:
npm run dev:server
```

### Passo 4: Verificar Logs
Monitorar os logs para confirmar que:
- Não há mais erros de conflito
- Sessões conectam corretamente
- QR codes são gerados quando necessário

## Prevenção

### 1. Evitar Múltiplas Instâncias
- Certifique-se de que apenas uma instância do backend está rodando
- Use `pm2` ou similar para gerenciar processos

### 2. Monitoramento
- Configure alertas para erros de conflito
- Monitore logs regularmente
- Use o script de diagnóstico periodicamente

### 3. Verificação Automática de Inicialização

O sistema agora executa automaticamente uma verificação de sessões na inicialização:
- Diagnostica todas as sessões
- Limpa automaticamente sessões conflitantes
- Prepara o sistema para conexão

### 4. Configurações Recomendadas
```typescript
// Aumentar tempo de espera entre tentativas
setTimeout(() => StartWhatsAppSession(whatsapp, whatsapp.companyId), 10000);

// Limpar listeners adequadamente
wsocket.ev.removeAllListeners("stream:error");
```

## Troubleshooting

### Se o problema persistir:

1. **Verificar WhatsApp Web**: Certifique-se de que não há outras sessões ativas
2. **Limpar cache do navegador**: Se usando WhatsApp Web
3. **Verificar rede**: Problemas de conectividade podem causar conflitos
4. **Reiniciar completamente**: Parar serviço, limpar sessões, reiniciar

### Logs Importantes para Monitorar:
- `Session conflict detected`
- `Stream error for session`
- `Socket Connection Update close`

## Contato

Se o problema persistir após seguir estas instruções, verifique:
1. Versão do Baileys (atualmente: 6.7.18)
2. Logs completos do sistema
3. Status do WhatsApp Business API 