# 🔍 Diagnóstico: Flow não está sendo ativado

## 📋 Checklist de Verificação

### 1. **Configuração do WhatsApp**
Verifique se o WhatsApp está configurado com os flows:

```sql
-- Verificar se o WhatsApp tem flowIdWelcome e flowIdNotPhrase configurados
SELECT id, name, "flowIdWelcome", "flowIdNotPhrase" 
FROM "Whatsapps" 
WHERE id = [SEU_WHATSAPP_ID];
```

### 2. **Configuração da Fila**
Verifique se a fila tem uma integração do tipo "flowbuilder":

```sql
-- Verificar se a fila tem integrationId
SELECT q.id, q.name, q."integrationId", qi.type, qi.name as integration_name
FROM "Queues" q
LEFT JOIN "QueueIntegrations" qi ON q."integrationId" = qi.id
WHERE q.id = [SUA_FILA_ID];
```

### 3. **Flows Criados**
Verifique se os flows existem no banco:

```sql
-- Verificar flows existentes
SELECT id, name, "companyId" 
FROM "FlowBuilders" 
WHERE "companyId" = [SUA_COMPANY_ID];
```

### 4. **Frases de Campanha**
Verifique se há frases de campanha configuradas:

```sql
-- Verificar frases de campanha
SELECT id, phrase, "flowId", "whatsappId"
FROM "FlowCampaigns" 
WHERE "whatsappId" = [SEU_WHATSAPP_ID];
```

## 🚨 Possíveis Problemas

### **Problema 1: WhatsApp sem flow configurado**
- **Sintoma:** `flowIdWelcome` ou `flowIdNotPhrase` são NULL
- **Solução:** Configure os flows no WhatsApp através do painel administrativo

### **Problema 2: Fila sem integração**
- **Sintoma:** `integrationId` é NULL na fila
- **Solução:** Crie uma integração do tipo "flowbuilder" e associe à fila

### **Problema 3: Flow não existe**
- **Sintoma:** Flow referenciado não existe no banco
- **Solução:** Crie o flow ou corrija a referência

### **Problema 4: Primeira mensagem**
- **Sintoma:** `isFirstMsg` é true, então o welcome flow não ativa
- **Solução:** Envie uma segunda mensagem para testar

## 🔧 Como Testar

1. **Envie uma mensagem** para o WhatsApp
2. **Verifique os logs** no console do servidor
3. **Procure pelos logs** que começam com `🔍 [FLOW DEBUG]`
4. **Identifique onde** o processo está parando

## 📝 Logs Esperados

Se tudo estiver configurado corretamente, você deve ver:

```
🔍 [FLOW DEBUG] flowbuilderIntegration iniciado
🔍 [FLOW DEBUG] WhatsApp ID: [ID]
🔍 [FLOW DEBUG] flowIdWelcome: [ID]
🔍 [FLOW DEBUG] Verificando Welcome Flow...
🔍 [FLOW DEBUG] Condições do Welcome Flow atendidas!
🔍 [FLOW DEBUG] Flow encontrado: true
```

## 🛠️ Próximos Passos

1. Execute as consultas SQL acima
2. Verifique se todas as configurações estão corretas
3. Envie uma mensagem de teste
4. Analise os logs do servidor
5. Me informe o que os logs mostram 