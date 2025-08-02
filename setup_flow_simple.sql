-- =====================================================
-- 🛠️ CONFIGURAÇÃO SIMPLES DO FLOW BUILDER
-- =====================================================
-- Execute este arquivo no seu banco de dados PostgreSQL
-- para configurar o flow de boas-vindas e associar ao WhatsApp
-- =====================================================

-- 1. Verificar se já existe um flow
SELECT 'Flows existentes:' as info;
SELECT id, name, "companyId", active FROM "FlowBuilders" ORDER BY id;

-- 2. Criar um flow de exemplo (se não existir)
INSERT INTO "FlowBuilders" (user_id, name, company_id, active, flow, variables, "createdAt", "updatedAt")
VALUES (
  1, -- user_id
  'Flow de Boas-vindas', 
  1, -- company_id
  true,
  '{"nodes": [{"id": "1", "type": "start", "position": {"x": 250, "y": 100}, "data": {"label": "Inicio do fluxo"}, "width": 229, "height": 58, "style": {"backgroundColor": "#13111C", "padding": 0, "borderRadius": 8}}, {"id": "jQH1wQZg7wUGdz26hDpqUCmacV3pWM", "type": "menu", "position": {"x": 519, "y": 100}, "data": {"message": "Olá, seja bem-vindo(a) à Santé Beauté.\\nMeu nome é Queen, será um prazer atendê-lo(a).\\n\\nPor gentileza, selecione uma das opções abaixo para que eu possa auxiliá-lo(a):", "arrayOption": [{"value": "1", "label": "Produtos"}, {"value": "2", "label": "Preços"}, {"value": "3", "label": "Atendimento"}]}, "width": 155, "height": 239, "style": {"backgroundColor": "#13111C", "padding": 0, "borderRadius": 8}}], "connections": [{"id": "reactflow__edge-1a-jQH1wQZg7wUGdz26hDpqUCmacV3pWM", "source": "1", "sourceHandle": "a", "target": "jQH1wQZg7wUGdz26hDpqUCmacV3pWM", "targetHandle": null, "style": {"color": "#ff0000", "strokeWidth": "6px"}, "animated": false}]}',
  '{}',
  NOW(),
  NOW()
) ON CONFLICT DO NOTHING;

-- 3. Verificar o ID do flow criado
SELECT 'Flow criado/verificado:' as info;
SELECT id, name, "companyId", active FROM "FlowBuilders" WHERE name = 'Flow de Boas-vindas';

-- 4. Configurar o WhatsApp com o flow criado
UPDATE "Whatsapps" 
SET "flowIdWelcome" = (SELECT id FROM "FlowBuilders" WHERE name = 'Flow de Boas-vindas' LIMIT 1)
WHERE id = 1;

-- 5. Verificar se a configuração foi aplicada corretamente
SELECT 'Configuração final:' as info;
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
-- 1           | santebeaute1  | 1             | Flow de Boas-vindas | true
-- ===================================================== 