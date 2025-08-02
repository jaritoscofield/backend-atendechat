// Configuração das palavras-chave que ativam o flow na primeira mensagem
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
  "como funciona"
];

// Configuração para ativar o flow com qualquer palavra
// Se definido como true, qualquer mensagem ativará o flow na primeira mensagem
export const ACTIVATE_WITH_ANY_WORD = true;

// Configuração para ativar o flow com qualquer mensagem, mesmo frases de campanha
// Se definido como true, o flow será ativado para TODAS as mensagens
export const ACTIVATE_FLOW_WITH_ALL_MESSAGES = true;

// Função para verificar se uma mensagem contém palavra-chave
export const containsTriggerKeyword = (message: string): boolean => {
  // Se ACTIVATE_WITH_ANY_WORD estiver ativado, qualquer mensagem é considerada palavra-chave
  if (ACTIVATE_WITH_ANY_WORD) {
    return true;
  }
  
  const messageLower = message.toLowerCase();
  return FLOW_TRIGGER_KEYWORDS.some(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
};

// Função para obter a palavra-chave encontrada (útil para logs)
export const getTriggerKeyword = (message: string): string | null => {
  // Se ACTIVATE_WITH_ANY_WORD estiver ativado, retorna a própria mensagem
  if (ACTIVATE_WITH_ANY_WORD) {
    return message;
  }
  
  const messageLower = message.toLowerCase();
  const foundKeyword = FLOW_TRIGGER_KEYWORDS.find(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
  return foundKeyword || null;
}; 