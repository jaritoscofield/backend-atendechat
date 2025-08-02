import { logger } from "../utils/logger";
import diagnoseSessions from "./diagnose-sessions";

const startupCheck = async () => {
  try {
    logger.info("=== VERIFICAÇÃO DE INICIALIZAÇÃO ===");
    
    // Executar apenas diagnóstico - SEM limpeza automática
    await diagnoseSessions();
    
    logger.info("=== VERIFICAÇÃO CONCLUÍDA ===");
    
  } catch (error) {
    logger.error("Erro na verificação de inicialização:", error);
    // Não falhar a inicialização por causa deste erro
  }
};

export default startupCheck; 