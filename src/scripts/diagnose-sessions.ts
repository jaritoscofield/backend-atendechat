import Whatsapp from "../models/Whatsapp";
import { logger } from "../utils/logger";
import { getWbot, removeWbot } from "../libs/wbot";

const diagnoseSessions = async () => {
  try {
    logger.info("=== DIAGNÓSTICO DE SESSÕES WHATSAPP ===");
    
    // Buscar todas as sessões
    const allSessions = await Whatsapp.findAll({
      order: [['companyId', 'ASC'], ['name', 'ASC']]
    });
    
    logger.info(`Total de sessões encontradas: ${allSessions.length}`);
    
    const statusCount = {};
    
    for (const session of allSessions) {
      const status = session.status || 'UNKNOWN';
      statusCount[status] = (statusCount[status] || 0) + 1;
      
      logger.info(`\n--- Sessão: ${session.name} (ID: ${session.id}) ---`);
      logger.info(`Status: ${session.status}`);
      logger.info(`Company ID: ${session.companyId}`);
      logger.info(`Provider: ${session.provider}`);
      logger.info(`Tem sessão salva: ${session.session ? 'SIM' : 'NÃO'}`);
      logger.info(`QR Code: ${session.qrcode ? 'PRESENTE' : 'AUSENTE'}`);
      logger.info(`Tentativas: ${session.retries || 0}`);
      
      // Verificar se a sessão está ativa na memória
      try {
        const wbot = getWbot(session.id);
        logger.info(`Status na memória: ATIVA`);
      } catch (error) {
        logger.info(`Status na memória: INATIVA`);
      }
    }
    
    logger.info("\n=== RESUMO POR STATUS ===");
    Object.entries(statusCount).forEach(([status, count]) => {
      logger.info(`${status}: ${count} sessões`);
    });
    
    // Verificar sessões com possíveis problemas
    const problematicSessions = allSessions.filter(session => 
      session.status === 'CONNECTED' && !session.session
    );
    
    if (problematicSessions.length > 0) {
      logger.warn(`\n⚠️  SESSÕES COM POSSÍVEIS PROBLEMAS:`);
      problematicSessions.forEach(session => {
        logger.warn(`- ${session.name} (ID: ${session.id}): Status CONNECTED mas sem dados de sessão`);
      });
    }
    
    logger.info("\n=== DIAGNÓSTICO CONCLUÍDO ===");
    
  } catch (error) {
    logger.error("Erro no diagnóstico de sessões:", error);
    throw error;
  }
};

// Executar se chamado diretamente
if (require.main === module) {
  diagnoseSessions()
    .then(() => {
      logger.info("Diagnóstico executado com sucesso");
      process.exit(0);
    })
    .catch((error) => {
      logger.error("Erro na execução do diagnóstico:", error);
      process.exit(1);
    });
}

export default diagnoseSessions; 