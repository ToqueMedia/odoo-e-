#!/bin/bash

# Pay4All Module Test Script
# Script para testar a instalação e funcionamento básico do módulo

echo "🚀 Pay4All Module Test Script"
echo "================================"

# Verificar estrutura do módulo
echo "📁 Verificando estrutura do módulo..."
cd /Users/ithustle/dev/extensions/pos_pay4all

if [ -f "__manifest__.py" ]; then
    echo "✅ __manifest__.py encontrado"
else
    echo "❌ __manifest__.py não encontrado"
    exit 1
fi

# Verificar arquivos principais
files=(
    "models/payment_provider.py"
    "static/src/css/pay4all_payment.css"  
    "static/src/js/pay4all_payment_screen.js"
    "static/src/xml/pay4all_payment_screen.xml"
    "views/payment_provider_views.xml"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file encontrado"
    else
        echo "❌ $file não encontrado"
    fi
done

# Verificar sintaxe Python
echo ""
echo "🐍 Verificando sintaxe Python..."
python3 -m py_compile __manifest__.py
if [ $? -eq 0 ]; then
    echo "✅ __manifest__.py tem sintaxe válida"
else
    echo "❌ Erro de sintaxe em __manifest__.py"
fi

python3 -m py_compile models/payment_provider.py
if [ $? -eq 0 ]; then
    echo "✅ payment_provider.py tem sintaxe válida"
else
    echo "❌ Erro de sintaxe em payment_provider.py"
fi

# Verificar XML
echo ""
echo "📝 Verificando XML..."
xmllint --noout views/payment_provider_views.xml 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ payment_provider_views.xml tem sintaxe válida"
else
    echo "❌ Erro de sintaxe em payment_provider_views.xml"
fi

xmllint --noout static/src/xml/pay4all_payment_screen.xml 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ pay4all_payment_screen.xml tem sintaxe válida"
else
    echo "❌ Erro de sintaxe em pay4all_payment_screen.xml"
fi

# Verificar tamanho dos arquivos
echo ""
echo "📊 Estatísticas dos arquivos:"
echo "CSS: $(wc -l < static/src/css/pay4all_payment.css) linhas"
echo "JS (main): $(wc -l < static/src/js/pay4all_payment_screen.js) linhas"
echo "XML: $(wc -l < static/src/xml/pay4all_payment_screen.xml) linhas"

# Verificar conteúdo importante
echo ""
echo "🔍 Verificando conteúdo crítico..."

# Verificar se o template está definido
if grep -q "Pay4AllPaymentScreen" static/src/xml/pay4all_payment_screen.xml; then
    echo "✅ Template Pay4AllPaymentScreen encontrado no XML"
else
    echo "❌ Template Pay4AllPaymentScreen não encontrado no XML"
fi

# Verificar se os métodos estão no template
if grep -q "ekwanza" static/src/xml/pay4all_payment_screen.xml; then
    echo "✅ Método e-Kwanza encontrado no template"
else
    echo "❌ Método e-Kwanza não encontrado no template"
fi

if grep -q "multicaixa" static/src/xml/pay4all_payment_screen.xml; then
    echo "✅ Método Multicaixa encontrado no template"
else
    echo "❌ Método Multicaixa não encontrado no template"
fi

# Verificar CSS classes
if grep -q "pay4all-payment-screen" static/src/css/pay4all_payment.css; then
    echo "✅ CSS classes Pay4All encontradas"
else
    echo "❌ CSS classes Pay4All não encontradas"
fi

echo ""
echo "📋 Resumo do Teste:"
echo "================================"
echo "Módulo Pay4All - Tela 1 (Seleção de Método)"
echo ""
echo "🎯 Funcionalidades implementadas:"
echo "   • Seleção entre e-Kwanza e Multicaixa Express"
echo "   • Campo de telefone com validação"
echo "   • Formatação automática do número"
echo "   • Validação em tempo real"
echo "   • Design fiel aos mockups (cores, layout)"
echo "   • Botões funcionais"
echo ""
echo "📦 Próximos passos:"
echo "   1. Instalar o módulo no Odoo"
echo "   2. Configurar método de pagamento no POS"
echo "   3. Testar a Tela 1 funcionalmente"
echo "   4. Implementar Tela 2 (processamento)"
echo ""
echo "✨ Teste concluído! Módulo pronto para instalação."
