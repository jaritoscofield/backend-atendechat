# Flow Ativa Com Qualquer Palavra

## Descrição
Esta funcionalidade permite que o flow seja ativado com **qualquer palavra** enviada pelo usuário, não apenas com palavras-chave específicas.

## Como Funciona

### Configuração
A funcionalidade é controlada pela constante `ACTIVATE_WITH_ANY_WORD` no arquivo `src/config/flowTriggers.ts`:

```typescript
export const ACTIVATE_WITH_ANY_WORD = true; // true = ativa com qualquer palavra
```

### Lógica de Ativação
Quando `ACTIVATE_WITH_ANY_WORD` está definido como `true`:

1. **Para TODAS as mensagens**: Qualquer palavra enviada pelo usuário ativará o flow
2. **Comportamento anterior**: Apenas palavras-chave específicas ativavam o flow na primeira mensagem

### Código Modificado

#### 1. `src/config/flowTriggers.ts`
```typescript
// Função para verificar se uma mensagem contém palavra-chave
export const containsTriggerKeyword = (message: string): boolean => {
  // Se ACTIVATE_WITH_ANY_WORD estiver ativado, qualquer mensagem é considerada palavra-chave
  if (ACTIVATE_WITH_ANY_WORD) {
    return true;
  }
  
  // Lógica original para palavras-chave específicas
  const messageLower = message.toLowerCase();
  return FLOW_TRIGGER_KEYWORDS.some(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
};

// Função para obter a palavra-chave encontrada
export const getTriggerKeyword = (message: string): string | null => {
  // Se ACTIVATE_WITH_ANY_WORD estiver ativado, retorna a própria mensagem
  if (ACTIVATE_WITH_ANY_WORD) {
    return message;
  }
  
  // Lógica original
  const messageLower = message.toLowerCase();
  const foundKeyword = FLOW_TRIGGER_KEYWORDS.find(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
  return foundKeyword || null;
};
```

#### 2. `src/services/WbotServices/wbotMessageListener.ts`
```typescript
// Ativa o flow para qualquer mensagem quando ACTIVATE_WITH_ANY_WORD está ativo
// OU para primeira mensagem com palavra-chave OU mensagens subsequentes que não são frases de campanha
if (
  isTriggerKeyword || // Qualquer palavra quando ACTIVATE_WITH_ANY_WORD está ativo
  (!isFirstMsg && isNotCampaignPhrase) // Mensagens subsequentes que não são frases de campanha
) {
  // Executa o flow
}
```

## Como Testar

1. **Configure o flow no banco de dados**:
   ```sql
   UPDATE Whatsapps SET flowIdWelcome = [ID_DO_SEU_FLOW] WHERE id = [ID_DO_WHATSAPP];
   ```

2. **Envie qualquer mensagem** para o WhatsApp conectado
3. **Verifique os logs** para confirmar a ativação:
   ```
   🔍 [FLOW DEBUG] Contém palavra-chave: true
   🔍 [FLOW DEBUG] Palavra-chave encontrada: [mensagem_enviada]
   🔍 [FLOW DEBUG] Condições do Welcome Flow atendidas!
   ```

## Como Desativar

Para voltar ao comportamento original (apenas palavras-chave específicas):

1. **Edite** `src/config/flowTriggers.ts`
2. **Altere** `ACTIVATE_WITH_ANY_WORD` para `false`:
   ```typescript
   export const ACTIVATE_WITH_ANY_WORD = false;
   ```

## Palavras-Chave Originais

Quando `ACTIVATE_WITH_ANY_WORD` está `false`, apenas estas palavras ativam o flow:
- "oi", "olá", "ola", "hello", "hi"
- "ajuda", "help", "iniciar", "começar", "start"
- "bom dia", "boa tarde", "boa noite"
- "atendimento", "suporte", "informação", "informacoes"
- "quero saber", "preciso de ajuda", "como funciona"

## Importante

- **Configuração do Flow**: Certifique-se de que o `flowIdWelcome` está configurado corretamente na tabela `Whatsapps`
- **Logs**: Use os logs de debug para verificar se o flow está sendo ativado corretamente
- **Compatibilidade**: Esta funcionalidade não quebra o comportamento existente quando desativada 