-- =====================================================
-- 🛠️ CONFIGURAÇÃO DO FLOW BUILDER
-- =====================================================
-- Execute este arquivo no seu banco de dados PostgreSQL
-- para configurar o flow de boas-vindas e associar ao WhatsApp
-- =====================================================

-- 1. Criar um flow de exemplo
INSERT INTO "FlowBuilders" (user_id, name, company_id, active, flow, variables, "createdAt", "updatedAt")
VALUES (
  1, -- user_id (substitua pelo ID correto do seu usuário)
  'Flow de Boas-vindas', 
  1, -- company_id (substitua pelo ID correto da sua empresa)
  true,
  '{"nodes": [{"id": "1", "type": "message", "data": {"message": "Olá! Como posso ajudar você hoje?"}}], "connections": []}',
  '{}',
  NOW(),
  NOW()
);

-- 2. Configurar o WhatsApp com o flow criado
UPDATE "Whatsapps" 
SET "flowIdWelcome" = 1 -- Substitua pelo ID do flow criado (geralmente 1 se for o primeiro)
WHERE id = 1; -- Substitua pelo ID do seu WhatsApp

-- 3. Verificar se a configuração foi aplicada corretamente
SELECT 
    w.id as whatsapp_id, 
    w.name as whatsapp_name, 
    w."flowIdWelcome", 
    f.name as flow_name,
    f.active as flow_active
FROM "Whatsapps" w
LEFT JOIN "FlowBuilders" f ON w."flowIdWelcome" = f.id
WHERE w.id = 1;

-- =====================================================
-- 📋 RESULTADO ESPERADO:
-- =====================================================
-- whatsapp_id | whatsapp_name | flowIdWelcome | flow_name | flow_active
-- 1           | Nome do WhatsApp | 1           | Flow de Boas-vindas | true
-- =====================================================

-- 4. Verificar todos os flows disponíveis (opcional)
SELECT id, name, active, "createdAt" 
FROM "FlowBuilders" 
ORDER BY id;

-- 5. Verificar todos os WhatsApps (opcional)
SELECT id, name, "flowIdWelcome", "flowIdNotPhrase" 
FROM "Whatsapps" 
ORDER BY id; 