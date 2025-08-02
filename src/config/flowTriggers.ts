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

// Função para verificar se uma mensagem contém palavra-chave
export const containsTriggerKeyword = (message: string): boolean => {
  const messageLower = message.toLowerCase();
  return FLOW_TRIGGER_KEYWORDS.some(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
};

// Função para obter a palavra-chave encontrada (útil para logs)
export const getTriggerKeyword = (message: string): string | null => {
  const messageLower = message.toLowerCase();
  const foundKeyword = FLOW_TRIGGER_KEYWORDS.find(keyword => 
    messageLower.includes(keyword.toLowerCase())
  );
  return foundKeyword || null;
}; 