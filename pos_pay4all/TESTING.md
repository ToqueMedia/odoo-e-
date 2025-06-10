# Teste da Tela 1 - Pay4All Payment Gateway

## Como Testar a Primeira Iteração

### 1. Instalação e Configuração

```bash
# Navegar para o diretório
cd /Users/ithustle/dev/extensions/pos_pay4all

# Verificar estrutura criada
ls -la

# Confirmar arquivos principais
ls -la static/src/js/
ls -la static/src/css/
ls -la static/src/xml/
```

### 2. Instalar no Odoo

1. **Copiar para addons** (se não estiver já no path):
   ```bash
   # Se necessário, copiar para pasta addons do Odoo
   cp -r /Users/ithustle/dev/extensions/pos_pay4all /path/to/odoo/addons/
   ```

2. **Reiniciar Odoo** com update:
   ```bash
   ./odoo-bin -c odoo.conf -u pos_pay4all
   ```

3. **Ou via interface**:
   - Apps > Update Apps List
   - Procurar "POS Pay4All"
   - Install

### 3. Configurar Método de Pagamento

1. **Ir para**: Point of Sale > Configuration > Payment Methods
2. **Criar novo método**:
   - Name: "Pay4All (e+)"
   - Use a Payment Terminal: ✓
   - Payment Provider: "Pay4All (e+)"

### 4. Testar a Tela 1

1. **Abrir POS**
2. **Adicionar produto** ao carrinho
3. **Clicar "Payment"**
4. **Selecionar "Pay4All"**

### 5. Verificar Funcionalidades

#### ✅ Layout e Design
- [ ] Modal centralizado aparece
- [ ] Título: "Escolha seu método de pagamento preferido:"
- [ ] Opção e-Kwanza com ícone 📱 e badge azul "DISPONÍVEL"
- [ ] Opção Multicaixa com ícone 💳 e badge verde "DISPONÍVEL"
- [ ] Campo telefone com placeholder "+244 XXX XXX XXX"

#### ✅ Interatividade
- [ ] Clicar e-Kwanza seleciona (borda azul)
- [ ] Clicar Multicaixa seleciona (borda verde)
- [ ] Campo telefone aceita digitação
- [ ] Botão "Continuar" muda texto baseado na seleção
- [ ] Botão "Cancelar" funciona

#### ✅ Validação
- [ ] Telefone inválido mostra erro
- [ ] Telefone válido (+244 9XX XXX XXX) aceita
- [ ] Botão "Continuar" desabilitado sem seleção + telefone
- [ ] Botão "Continuar" habilitado com dados válidos

#### ✅ Formatação
- [ ] Telefone formata automaticamente
- [ ] "9XXXXXXXX" vira "+244 9XX XXX XXX"
- [ ] Validação em tempo real

### 6. Debugging (se necessário)

1. **Console do navegador**:
   ```javascript
   // Verificar se componentes carregaram
   console.log('Pay4All loaded:', window.Pay4AllPaymentScreen);
   ```

2. **Logs do Odoo**:
   ```bash
   # Verificar logs de erro
   tail -f /var/log/odoo/odoo.log
   ```

3. **Verificar assets**:
   - Ir para Settings > Technical > User Interface > Assets
   - Procurar "pos_pay4all"

### 7. Resultados Esperados

Após clicar "Continuar":
- **Tela 1 fecha**
- **Dados são passados** para próxima tela
- **Por enquanto**: Pagamento marca como "done" (simulado)
- **Próxima iteração**: Implementar Tela 2

### 8. Próximos Passos

Se Tela 1 funcionar perfeitamente:
1. **Implementar Tela 2** (processamento com countdown)
2. **Adicionar API calls** reais
3. **Implementar Tela 3** (aguardo Multicaixa)
4. **Adicionar tratamento de erros**

### 9. Troubleshooting

#### Problema: Tela não abre
- Verificar se módulo está instalado
- Verificar logs do Odoo
- Verificar se assets foram carregados

#### Problema: Estilos não aparecem
- Verificar se CSS foi carregado
- Inspecionar elemento no navegador
- Verificar path dos assets

#### Problema: Botões não funcionam
- Verificar console do navegador
- Verificar se JavaScript carregou
- Verificar se eventos estão bindados

### 10. Validação Final

✅ **Tela 1 deve replicar exatamente** o mockup fornecido
✅ **Todas as funcionalidades** devem estar operacionais
✅ **Validação de telefone** deve ser robusta
✅ **Transição para próxima tela** deve funcionar

Esta é a base sólida para as próximas iterações!
