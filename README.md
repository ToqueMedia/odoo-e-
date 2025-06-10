# POS Pay4All Payment Gateway

Módulo de pagamento Pay4All (e+) para Point of Sale do Odoo 16.

## Funcionalidades - Segunda Iteração

### ✅ Tela 1 - Seleção de Método (IMPLEMENTADA)

- **Design fiel aos mockups** com cores e layout específicos
- **Dois métodos de pagamento**:
  - 📱 **e-Kwanza** (badge azul "DISPONÍVEL")
  - 💳 **Multicaixa Express** (badge verde "DISPONÍVEL")
- **Campo de telefone** com validação para números angolanos
- **Botões funcionais**: "Continuar com [Método]" e "Cancelar"
- **Validação em tempo real** do número de telefone
- **Formatação automática** do telefone (+244 9XX XXX XXX)

### ✅ Tela 2 - Processamento/Aguardo (IMPLEMENTADA)

- **Header com produto/descrição** do pedido
- **Status com countdown** "Aguardando pagamento - 1:30" (90 segundos)
- **Progress bar laranja** com animação
- **Caixa informativa azul** com instruções específicas por método
- **Detalhes do pagamento**: Referência e Valor
- **Integração API real** com endpoints Pay4All
- **Verificação periódica** de status (5 segundos)
- **Tratamento de timeout** automático

### ✅ Tela 3 - Aguardo Multicaixa (IMPLEMENTADA)

- **Layout igual à Tela 2** mas sem countdown
- **Progress bar indeterminada** com animação contínua
- **Texto central**: "Aguardando confirmação do pagamento..."
- **Spinner animado** para indicar processamento
- **Verificação mais frequente** (3 segundos)
- **Timeout estendido** (5 minutos para Multicaixa)
- **Estilo verde** específico para Multicaixa

### 🔄 Próximas Iterações

- **Notificações push** de status
- **Callbacks webhook** para confirmação
- **Retry automático** em caso de falha
- **Logs detalhados** para debug

## Instalação

1. **Copiar módulo** para pasta de add-ons do Odoo:
   ```bash
   cp -r pos_pay4all /path/to/odoo/addons/
   ```

2. **Atualizar lista de módulos**:
   - Ir para Apps > Update Apps List

3. **Instalar módulo**:
   - Procurar por "POS Pay4All Payment Gateway"
   - Clicar em "Install"

4. **Configurar método de pagamento**:
   - Ir para Point of Sale > Configuration > Payment Methods
   - Criar novo método com Provider "Pay4All (e+)"
   - Configurar credenciais se necessário

## Uso

1. **No POS**, adicionar produtos ao carrinho
2. **Clicar em "Payment"**
3. **Selecionar método "Pay4All"**
4. **Tela 1 abrirá** com opções de pagamento
5. **Escolher método**: e-Kwanza ou Multicaixa Express
6. **Inserir telefone** (formato +244 9XX XXX XXX)
7. **Clicar "Continuar"** para próxima tela

## Credenciais API (Configuradas)

- **API Key**: `8UmVR3yf7HwBMkNbs6DTDIYdGpOWr7hXVthaqMo30BXSu4WL`
- **Account Number**: `00375967`
- **Notification Token**: `QXRSEOAAMOBUOM`

## Estrutura do Módulo

```
pos_pay4all/
├── __manifest__.py              # Configuração do módulo
├── models/
│   └── payment_provider.py     # Modelo do provedor de pagamento
├── views/
│   └── payment_provider_views.xml # Views de configuração
├── data/
│   └── payment_provider_data.xml  # Dados iniciais
└── static/src/
    ├── css/
    │   └── pay4all_payment.css    # Estilos da interface
    ├── js/
    │   ├── main.js                # Registro de componentes
    │   ├── pay4all_payment_screen.js # Tela 1 - Seleção
    │   └── pay4all_payment_interface.js # Interface POS
    └── xml/
        └── pay4all_payment_screen.xml # Template Tela 1
```

## Design Specifications

### Cores
- **e-Kwanza**: Azul (#3182ce)
- **Multicaixa**: Verde (#38a169)
- **Botão Principal**: Azul (#3182ce)
- **Texto Secundário**: Cinza (#718096)

### Layout
- **Modal centralizado** com fundo escuro
- **Bordas arredondadas** (8px-12px)
- **Ícones grandes** (📱 💳) com cores específicas
- **Badges de status** com cores diferenciadas
- **Animações suaves** (fadeIn, hover effects)

## Desenvolvimento

### Próximos Passos
1. **Tela 2**: Implementar countdown e progress bar
2. **API Integration**: Conectar com endpoints reais
3. **Error Handling**: Tratar erros e timeouts
4. **Testing**: Testes automáticos e manuais

### Padrões Seguidos
- **Odoo 16** OWL framework
- **ES6+** JavaScript moderno
- **CSS Grid/Flexbox** para layouts responsivos
- **Validação client-side** com feedback visual
- **Acessibilidade** com labels e foco adequados

## Suporte

Este módulo foi desenvolvido seguindo as especificações exatas dos mockups fornecidos e APIs reais do Pay4All.
