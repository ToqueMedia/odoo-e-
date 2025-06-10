# 🚀 Pay4All - Guia de Instalação Rápida

## ⚡ Instalação em 5 Minutos

### 1️⃣ **Preparar Ambiente**
```bash
# Parar o Odoo (se estiver rodando)
sudo systemctl stop odoo

# Navegar para diretório de addons
cd /opt/odoo/addons/
# ou onde estejam seus addons customizados
```

### 2️⃣ **Instalar Módulo**
```bash
# Copiar módulo para addons
sudo cp -r /Users/ithustle/dev/extensions/pos_pay4all ./

# Ajustar permissões
sudo chown -R odoo:odoo pos_pay4all/
sudo chmod -R 755 pos_pay4all/
```

### 3️⃣ **Reiniciar Odoo**
```bash
# Reiniciar com atualização de módulos
sudo systemctl start odoo

# Ou via comando direto
sudo -u odoo /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf -u base -d your_database
```

### 4️⃣ **Instalar via Interface**
1. Acessar Odoo como administrador
2. Ir em **Apps**
3. Clicar **Update Apps List**
4. Pesquisar "**Pay4All**"
5. Clicar **Install**

### 5️⃣ **Configurar POS**
```
Point of Sale > Configuration > Payment Methods
┌─ Create ─────────────────────────┐
│ Name: Pay4All (e+)               │
│ Provider: Pay4All (e+)           │
│ Journal: Bank (or create new)    │
│ ✓ Use a Payment Terminal: Yes    │
└──────────────────────────────────┘
```

### 6️⃣ **Ativar no POS**
```
Point of Sale > Configuration > Point of Sale
┌─ [Sua Loja POS] ─────────────────┐
│ Payment Methods:                 │
│ ✓ Cash                          │
│ ✓ Bank                          │
│ ✓ Pay4All (e+)  ← ADICIONAR     │
└──────────────────────────────────┘
```

## ✅ **Teste Rápido**

1. **Abrir POS**
2. **Adicionar produto**
3. **Clicar Payment**
4. **Selecionar Pay4All (e+)**
5. **Verificar se modal abre** ✨

## 🆘 **Problemas Comuns**

### ❌ **Módulo não aparece na lista**
```bash
# Limpar cache
sudo rm -rf /opt/odoo/.local/share/Odoo/filestore/*/
sudo systemctl restart odoo
```

### ❌ **Erro de permissão**
```bash
sudo chown -R odoo:odoo /opt/odoo/addons/pos_pay4all/
sudo chmod -R 755 /opt/odoo/addons/pos_pay4all/
```

### ❌ **Modal não abre**
- Abrir **F12** (Developer Tools)
- Verificar **Console** por erros JavaScript
- Limpar cache do navegador

## 📞 **Suporte Rápido**

- **📧 Email:** support@pay4all.ao
- **📱 WhatsApp:** +244 XXX XXX XXX
- **🕐 Horário:** 8h às 18h (GMT+1)

---

## 🎯 **Checklist de Verificação**

- [ ] Odoo 16.0+ instalado
- [ ] Módulo Point of Sale ativo
- [ ] Pay4All copiado para addons
- [ ] Permissões corretas (odoo:odoo)
- [ ] Módulo instalado via Apps
- [ ] Payment Method configurado
- [ ] Method ativo no POS
- [ ] Teste básico funcionando

**✅ Se todos os itens estiverem marcados, o Pay4All está pronto para uso!**
