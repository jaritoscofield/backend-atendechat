import { Sequelize } from "sequelize";
import Whatsapp from "../models/Whatsapp";
import { logger } from "../utils/logger";

const clearConflictSessions = async () => {
  try {
    logger.info("Iniciando limpeza de sessões conflitantes...");
    
    // Buscar todas as sessões com status CONNECTED ou OPENING
    const activeSessions = await Whatsapp.findAll({
      where: {
        status: ["CONNECTED", "OPENING"]
      }
    });
    
    logger.info(`Encontradas ${activeSessions.length} sessões ativas`);
    
    for (const session of activeSessions) {
      logger.info(`Limpando sessão: ${session.name} (ID: ${session.id})`);
      
      // Limpar dados da sessão
      await session.update({
        status: "PENDING",
        session: "",
        qrcode: "",
        retries: 0
      });
      
      logger.info(`Sessão ${session.name} limpa com sucesso`);
    }
    
    logger.info("Limpeza de sessões conflitantes concluída");
  } catch (error) {
    logger.error("Erro ao limpar sessões conflitantes:", error);
    throw error;
  }
};

// Executar se chamado diretamente
if (require.main === module) {
  clearConflictSessions()
    .then(() => {
      logger.info("Script executado com sucesso");
      process.exit(0);
    })
    .catch((error) => {
      logger.error("Erro na execução do script:", error);
      process.exit(1);
    });
}

export default clearConflictSessions; 