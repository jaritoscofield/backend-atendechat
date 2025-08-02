import { logger } from "../utils/logger";
import { containsTriggerKeyword, getTriggerKeyword, ACTIVATE_WITH_ANY_WORD, ACTIVATE_FLOW_WITH_ALL_MESSAGES } from "../config/flowTriggers";

const testFlowActivation = async () => {
  try {
    logger.info("=== TESTE DE ATIVAÇÃO DE FLOW ===");
    
    const testMessages = [
      "oi",
      "olá",
      "Teste",
      "qualquer coisa",
      "ajuda",
      "bom dia",
      "123",
      "😊",
      "mensagem qualquer"
    ];
    
    logger.info(`ACTIVATE_WITH_ANY_WORD: ${ACTIVATE_WITH_ANY_WORD}`);
    logger.info(`ACTIVATE_FLOW_WITH_ALL_MESSAGES: ${ACTIVATE_FLOW_WITH_ALL_MESSAGES}`);
    logger.info("");
    
    for (const message of testMessages) {
      const isTriggerKeyword = containsTriggerKeyword(message);
      const keywordFound = getTriggerKeyword(message);
      
      logger.info(`Mensagem: "${message}"`);
      logger.info(`  - Contém palavra-chave: ${isTriggerKeyword}`);
      logger.info(`  - Palavra-chave encontrada: ${keywordFound || 'N/A'}`);
      logger.info(`  - Deve ativar flow: ${ACTIVATE_FLOW_WITH_ALL_MESSAGES ? 'SIM (todas as mensagens)' : isTriggerKeyword ? 'SIM' : 'NÃO'}`);
      logger.info("");
    }
    
    logger.info("=== TESTE CONCLUÍDO ===");
    
  } catch (error) {
    logger.error("Erro no teste de ativação:", error);
    throw error;
  }
};

// Executar se chamado diretamente
if (require.main === module) {
  testFlowActivation()
    .then(() => {
      logger.info("Teste executado com sucesso");
      process.exit(0);
    })
    .catch((error) => {
      logger.error("Erro na execução do teste:", error);
      process.exit(1);
    });
}

export default testFlowActivation; 