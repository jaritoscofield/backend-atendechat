import { logger } from "../utils/logger";
import { Sequelize } from "sequelize";
import Whatsapp from "../models/Whatsapp";
import { FlowBuilderModel } from "../models/FlowBuilder";

const setupFlowDirect = async () => {
  try {
    logger.info("=== CONFIGURAÇÃO DIRETA DO FLOW BUILDER ===");

    // 1. Verificar se existe um flow
    const existingFlow = await FlowBuilderModel.findOne({
      where: {
        companyId: 1 // Assumindo company ID 1
      }
    });

    let flowId = null;

    if (existingFlow) {
      flowId = existingFlow.id;
      logger.info(`Flow existente encontrado: ${existingFlow.name} (ID: ${flowId})`);
    } else {
      logger.info("Nenhum flow encontrado. Criando um flow padrão...");

      // Criar um flow padrão
      const newFlow = await FlowBuilderModel.create({
        userId: 1,
        name: "Flow de Boas-vindas",
        companyId: 1,
        active: true,
        flow: {
          "nodes": [
            {
              "id": "1",
              "type": "start",
              "position": {"x": 250, "y": 100},
              "data": {"label": "Inicio do fluxo"},
              "width": 229,
              "height": 58,
              "style": {"backgroundColor": "#13111C", "padding": 0, "borderRadius": 8}
            },
            {
              "id": "jQH1wQZg7wUGdz26hDpqUCmacV3pWM",
              "type": "menu",
              "position": {"x": 519, "y": 100},
              "data": {
                "message": "Olá, seja bem-vindo(a) à Santé Beauté.\nMeu nome é Queen, será um prazer atendê-lo(a).\n\nPor gentileza, selecione uma das opções abaixo para que eu possa auxiliá-lo(a):",
                "arrayOption": [
                  {"value": "1", "label": "Produtos"},
                  {"value": "2", "label": "Preços"},
                  {"value": "3", "label": "Atendimento"}
                ]
              },
              "width": 155,
              "height": 239,
              "style": {"backgroundColor": "#13111C", "padding": 0, "borderRadius": 8}
            }
          ],
          "connections": [
            {
              "id": "reactflow__edge-1a-jQH1wQZg7wUGdz26hDpqUCmacV3pWM",
              "source": "1",
              "sourceHandle": "a",
              "target": "jQH1wQZg7wUGdz26hDpqUCmacV3pWM",
              "targetHandle": null,
              "style": {"color": "#ff0000", "strokeWidth": "6px"},
              "animated": false
            }
          ]
        },
        variables: {}
      });

      flowId = newFlow.id;
      logger.info(`Flow criado com sucesso: ${newFlow.name} (ID: ${flowId})`);
    }

    // 2. Configurar o WhatsApp com o flow
    const whatsapp = await Whatsapp.findOne({
      where: {
        id: 1 // Assumindo WhatsApp ID 1
      }
    });

    if (!whatsapp) {
      logger.error("WhatsApp não encontrado!");
      return;
    }

    logger.info(`WhatsApp encontrado: ${whatsapp.name} (ID: ${whatsapp.id})`);
    logger.info(`Flow ID atual: ${whatsapp.flowIdWelcome}`);

    if (whatsapp.flowIdWelcome !== flowId) {
      await whatsapp.update({
        flowIdWelcome: flowId
      });
      logger.info(`WhatsApp configurado com flow ID: ${flowId}`);
    } else {
      logger.info("WhatsApp já está configurado corretamente");
    }

    // 3. Verificar configuração final
    const finalCheck = await Whatsapp.findOne({
      where: { id: 1 }
    });

    const flowCheck = await FlowBuilderModel.findByPk(finalCheck.flowIdWelcome);

    logger.info("\n=== CONFIGURAÇÃO FINAL ===");
    logger.info(`WhatsApp: ${finalCheck.name}`);
    logger.info(`Flow ID: ${finalCheck.flowIdWelcome}`);
    logger.info(`Flow Name: ${flowCheck?.name || 'N/A'}`);
    logger.info(`Flow Active: ${flowCheck?.active || 'N/A'}`);

    logger.info("\n=== CONFIGURAÇÃO CONCLUÍDA ===");

  } catch (error) {
    logger.error("Erro na configuração do flow:", error);
    throw error;
  }
};

// Executar se chamado diretamente
if (require.main === module) {
  setupFlowDirect()
    .then(() => {
      logger.info("Configuração executada com sucesso");
      process.exit(0);
    })
    .catch((error) => {
      logger.error("Erro na execução da configuração:", error);
      process.exit(1);
    });
}

export default setupFlowDirect; 