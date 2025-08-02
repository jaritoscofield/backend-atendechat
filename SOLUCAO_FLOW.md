# 🛠️ Solução: Configurar Flow Builder com Palavras-Chave

## 🎯 **Nova Funcionalidade Implementada**

Agora o flow pode ser ativado na **primeira mensagem** quando o usuário enviar uma **palavra-chave específica**!

### **Palavras-chave que ativam o flow:**
- "oi", "olá", "ola"
- "hello", "hi" 
- "ajuda", "help"
- "iniciar", "começar", "start"
- "bom dia", "boa tarde", "boa noite"
- "atendimento", "suporte"
- "informação", "informacoes"
- "quero saber", "preciso de ajuda"
- "como funciona"

## 📋 **Passos para Resolver o Problema**

### **1. Criar um Flow no Banco de Dados**

```sql
-- Inserir um flow de exemplo
INSERT INTO "FlowBuilders" (user_id, name, company_id, active, flow, variables, "createdAt", "updatedAt")
VALUES (
  1, -- user_id (substitua pelo ID do usuário correto)
  'Flow de Boas-vindas', 
  1, -- company_id (substitua pelo ID da empresa correta)
  true,
  '{"nodes": [{"id": "1", "type": "message", "data": {"message": "Olá! Como posso ajudar você hoje?"}}], "connections": []}',
  '{}',
  NOW(),
  NOW()
);
```

### **2. Configurar o WhatsApp com o Flow**

```sql
-- Atualizar o WhatsApp com o flowIdWelcome
UPDATE "Whatsapps" 
SET "flowIdWelcome" = 1 -- Substitua pelo ID do flow criado
WHERE id = 1; -- Substitua pelo ID do seu WhatsApp
```

### **3. Verificar a Configuração**

```sql
-- Verificar se está configurado corretamente
SELECT w.id, w.name, w."flowIdWelcome", w."flowIdNotPhrase", f.name as flow_name
FROM "Whatsapps" w
LEFT JOIN "FlowBuilders" f ON w."flowIdWelcome" = f.id
WHERE w.id = 1;
```

## 🔧 **Como Funciona Agora**

### **Condições para ativar o flow:**

1. **Primeira mensagem + Palavra-chave**: Se for a primeira mensagem E contiver uma palavra-chave
2. **Mensagens subsequentes**: Se não for primeira mensagem E não for frase de campanha

### **Exemplo de uso:**
- Usuário envia: "oi" → **Flow ativa** ✅
- Usuário envia: "ajuda" → **Flow ativa** ✅  
- Usuário envia: "quero saber mais" → **Flow ativa** ✅
- Usuário envia: "teste" → **Flow não ativa** ❌ (não é palavra-chave)

## 🧪 **Como Testar**

1. **Configure o flow** seguindo os passos acima
2. **Reinicie o servidor**: `npm run dev:server`
3. **Envie uma palavra-chave** para o WhatsApp (ex: "oi", "ajuda")
4. **Verifique os logs** - deve aparecer:
   ```
   🔍 [FLOW DEBUG] É primeira mensagem: true
   🔍 [FLOW DEBUG] Contém palavra-chave: true
   🔍 [FLOW DEBUG] Palavra-chave encontrada: oi
   🔍 [FLOW DEBUG] Condições do Welcome Flow atendidas!
   🔍 [FLOW DEBUG] Flow encontrado: true
   ```

## 🔧 **Personalizar Palavras-Chave**

Para adicionar ou modificar palavras-chave, edite o arquivo `src/config/flowTriggers.ts`:

```typescript
export const FLOW_TRIGGER_KEYWORDS = [
  "oi",
  "olá", 
  "ola",
  "hello",
  "hi",
  "ajuda",
  "help",
  "iniciar",
  "começar",
  "start",
  "bom dia",
  "boa tarde", 
  "boa noite",
  "atendimento",
  "suporte",
  "informação",
  "informacoes",
  "quero saber",
  "preciso de ajuda",
  "como funciona",
  // Adicione suas palavras-chave aqui
  "minha palavra chave"
];
```

## 📝 **Comandos SQL para Executar**

Execute estes comandos no seu banco de dados PostgreSQL:

```sql
-- 1. Criar o flow
INSERT INTO "FlowBuilders" (user_id, name, company_id, active, flow, variables, "createdAt", "updatedAt")
VALUES (1, 'Flow de Boas-vindas', 1, true, '{"nodes": [{"id": "1", "type": "message", "data": {"message": "Olá! Como posso ajudar você hoje?"}}], "connections": []}', '{}', NOW(), NOW());

-- 2. Configurar o WhatsApp
UPDATE "Whatsapps" SET "flowIdWelcome" = 1 WHERE id = 1;

-- 3. Verificar
SELECT w.id, w.name, w."flowIdWelcome", f.name as flow_name
FROM "Whatsapps" w
LEFT JOIN "FlowBuilders" f ON w."flowIdWelcome" = f.id
WHERE w.id = 1;
```

## 🚨 **Importante**

- Substitua os IDs (user_id, company_id, whatsapp_id) pelos valores corretos do seu sistema
- O flow JSON é um exemplo básico - você pode criar flows mais complexos
- Após configurar, reinicie o servidor para aplicar as mudanças
- As palavras-chave são case-insensitive (não diferenciam maiúsculas/minúsculas)
- Para adicionar novas palavras-chave, edite `src/config/flowTriggers.ts` e recompile 