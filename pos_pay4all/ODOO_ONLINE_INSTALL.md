# Instalação do Módulo Pay4All no Odoo Online

## 📋 Pré-requisitos

### 1. Verificação de Compatibilidade
- **Versão Odoo**: 16.0 ou superior
- **Módulos necessários**: `point_of_sale`, `payment`
- **Permissões**: Acesso de administrador ao banco de dados

### 2. Credenciais Pay4All
Antes da instalação, certifique-se de ter:
- **API_KEY**: Chave de API fornecida pela Pay4All
- **ACCOUNT_NUMBER**: Número da conta Pay4All
- **Ambiente**: Produção ou Sandbox

## 📦 Processo de Instalação

### Passo 1: Download do Módulo
1. Baixe o arquivo `pos_pay4all.zip` (versão para Odoo Online)
2. Verifique a integridade do arquivo (deve ter aproximadamente 50KB)

### Passo 2: Upload no Odoo Online
1. **Acesse o Odoo Online** como administrador
2. Vá para **Aplicações** → **Atualizar Lista de Aplicações**
3. Clique em **Carregar Módulo** (ícone de upload)
4. Selecione o arquivo `pos_pay4all.zip`
5. Aguarde o upload completar

### Passo 3: Instalação do Módulo
1. Após o upload, vá para **Aplicações**
2. Procure por "Pay4All" ou "POS Pay4All"
3. Clique em **Instalar**
4. Aguarde a instalação completar (pode levar 1-2 minutos)

## ⚙️ Configuração Inicial

### Passo 1: Configurar Provedor de Pagamento
1. Vá para **Ponto de Venda** → **Configuração** → **Provedores de Pagamento**
2. Clique em **Novo** ou procure por "Pay4All"
3. Preencha os campos:
   - **Nome**: Pay4All
   - **Tipo**: Pay4All
   - **Estado**: Ativado
   - **API Key**: Sua chave de API
   - **Account Number**: Seu número de conta
   - **Ambiente**: Produção/Sandbox

### Passo 2: Configurar Ponto de Venda
1. Vá para **Ponto de Venda** → **Configuração** → **Pontos de Venda**
2. Selecione seu POS
3. Na aba **Pagamentos**, adicione o provedor Pay4All
4. Salve as configurações

### Passo 3: Reiniciar Sessão POS
1. Feche todas as sessões POS ativas
2. Abra uma nova sessão POS
3. Verifique se o botão Pay4All aparece na tela de pagamento

## 🔧 Configurações Avançadas

### Timeouts
- **Processamento**: 90 segundos (padrão)
- **Multicaixa**: 5 minutos (padrão)
- **Polling**: 5 segundos (padrão)

### Personalização
Para alterar timeouts ou outras configurações:
1. Vá para **Definições** → **Técnico** → **Parâmetros do Sistema**
2. Crie novos parâmetros:
   - `pos_pay4all.processing_timeout`: Timeout de processamento (segundos)
   - `pos_pay4all.multicaixa_timeout`: Timeout Multicaixa (segundos)
   - `pos_pay4all.polling_interval`: Intervalo de polling (segundos)

## 🧪 Teste da Instalação

### Teste Básico
1. Abra o POS
2. Adicione um produto ao carrinho
3. Clique em **Pagamento**
4. Selecione **Pay4All**
5. Verifique se as telas aparecem corretamente

### Teste de Integração
1. Use números de teste fornecidos pela Pay4All
2. Teste ambos os métodos: e-Kwanza e Multicaixa Express
3. Verifique os timeouts e transições entre telas

## ❗ Resolução de Problemas

### Módulo não aparece após upload
1. Verifique se o arquivo ZIP está correto
2. Limpe o cache do navegador
3. Atualize a lista de aplicações

### Erro de dependências
1. Certifique-se de que `point_of_sale` está instalado
2. Verifique se a versão do Odoo é compatível (16.0+)

### Botão Pay4All não aparece no POS
1. Verifique se o provedor está ativo
2. Confirme se está adicionado ao POS
3. Reinicie a sessão POS

### Erro de API
1. Verifique as credenciais Pay4All
2. Teste a conectividade com a API
3. Confirme se o ambiente (produção/sandbox) está correto

## 📞 Suporte

### Logs do Sistema
Para debug, acesse:
1. **Definições** → **Técnico** → **Logs**
2. Filtre por "pay4all"

### Contato
- **Email**: suporte@pay4all.ao
- **Website**: https://pay4all.ao
- **Documentação**: Consulte README.md e TECHNICAL.md

## 🔄 Atualizações

### Como Atualizar
1. Baixe a nova versão do módulo
2. Vá para **Aplicações** → **Pay4All**
3. Clique em **Atualizar**
4. Aguarde o processo completar

### Backup
Antes de atualizar:
1. Faça backup do banco de dados
2. Teste em ambiente de homologação
3. Verifique compatibilidade com customizações

## ✅ Checklist de Instalação

- [ ] Módulo uploaded com sucesso
- [ ] Instalação completada sem erros
- [ ] Provedor de pagamento configurado
- [ ] Credenciais API inseridas
- [ ] POS configurado com Pay4All
- [ ] Sessão POS reiniciada
- [ ] Teste básico executado
- [ ] Both métodos (e-Kwanza/Multicaixa) testados
- [ ] Timeouts verificados
- [ ] Documentação lida

---

**Versão**: 16.0.2.0.0  
**Data**: Dezembro 2024  
**Compatibilidade**: Odoo 16.0+ Online
