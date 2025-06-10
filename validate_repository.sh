#!/bin/bash

# Script de Validação Final - Repositório Reestruturado
# Verifica se a estrutura está correta para Odoo Apps Store

echo "🔍 VALIDAÇÃO FINAL - Repositório Reestruturado"
echo "=============================================="

# Verificar se estamos no branch correto
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📍 Branch atual: $BRANCH"

if [ "$BRANCH" != "8.0" ]; then
    echo "❌ ERRO: Deve estar no branch 8.0"
    exit 1
fi

# Verificar se a pasta do módulo existe
if [ ! -d "pos_pay4all" ]; then
    echo "❌ ERRO: Pasta pos_pay4all/ não encontrada"
    exit 1
fi

echo "✅ Pasta do módulo: pos_pay4all/ encontrada"

# Verificar arquivos obrigatórios do módulo
REQUIRED_FILES=(
    "pos_pay4all/__init__.py"
    "pos_pay4all/__manifest__.py"
    "pos_pay4all/LICENSE"
    "pos_pay4all/models/__init__.py"
    "pos_pay4all/models/payment_provider.py"
    "pos_pay4all/views/payment_provider_views.xml"
    "pos_pay4all/data/payment_provider_data.xml"
    "pos_pay4all/static/description/index.html"
    "pos_pay4all/static/description/icon.png"
    "pos_pay4all/static/description/main_screenshot.png"
)

echo ""
echo "🔍 Verificando arquivos obrigatórios:"

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - AUSENTE"
        MISSING=true
    fi
done

if [ "$MISSING" = true ]; then
    echo "❌ ERRO: Arquivos obrigatórios ausentes"
    exit 1
fi

# Verificar manifest
echo ""
echo "🔍 Validando __manifest__.py:"

if python3 -c "exec(open('pos_pay4all/__manifest__.py').read())" 2>/dev/null; then
    echo "✅ Sintaxe do manifest válida"
else
    echo "❌ ERRO: Sintaxe do manifest inválida"
    exit 1
fi

# Verificar licença no manifest
if grep -q "license.*OPL-1" pos_pay4all/__manifest__.py; then
    echo "✅ Licença OPL-1 definida no manifest"
else
    echo "❌ ERRO: Licença OPL-1 não encontrada no manifest"
    exit 1
fi

# Verificar assets estáticos
echo ""
echo "🔍 Verificando assets estáticos:"

STATIC_FILES=(
    "pos_pay4all/static/src/js/main.js"
    "pos_pay4all/static/src/js/pay4all_payment_screen.js"
    "pos_pay4all/static/src/js/pay4all_processing_screen.js"
    "pos_pay4all/static/src/js/pay4all_multicaixa_wait_screen.js"
    "pos_pay4all/static/src/css/pay4all_payment.css"
)

for file in "${STATIC_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - AUSENTE"
        MISSING_STATIC=true
    fi
done

if [ "$MISSING_STATIC" = true ]; then
    echo "❌ ERRO: Assets estáticos ausentes"
    exit 1
fi

# Verificar imagens da description
echo ""
echo "🔍 Verificando imagens do Apps Store:"

IMAGES=(
    "pos_pay4all/static/description/icon.png"
    "pos_pay4all/static/description/main_screenshot.png"
    "pos_pay4all/static/description/screenshot_1.png"
    "pos_pay4all/static/description/screenshot_2.png"
    "pos_pay4all/static/description/screenshot_3.png"
)

for img in "${IMAGES[@]}"; do
    if [ -f "$img" ]; then
        SIZE=$(du -h "$img" | cut -f1)
        echo "✅ $img ($SIZE)"
    else
        echo "❌ $img - AUSENTE"
        MISSING_IMAGES=true
    fi
done

if [ "$MISSING_IMAGES" = true ]; then
    echo "❌ ERRO: Imagens do Apps Store ausentes"
    exit 1
fi

# Verificar se há arquivos na raiz que deveriam estar no módulo
echo ""
echo "🔍 Verificando limpeza da raiz:"

ROOT_ODOO_FILES=(
    "__init__.py"
    "__manifest__.py"
    "models"
    "views"
    "data"
    "static"
)

FOUND_ROOT_FILES=false
for item in "${ROOT_ODOO_FILES[@]}"; do
    if [ -e "$item" ]; then
        echo "⚠️  AVISO: $item ainda na raiz (deveria estar em pos_pay4all/)"
        FOUND_ROOT_FILES=true
    fi
done

if [ "$FOUND_ROOT_FILES" = false ]; then
    echo "✅ Raiz limpa - apenas documentação e módulo em pasta separada"
fi

# Verificar status Git
echo ""
echo "🔍 Verificando status Git:"

if git diff --quiet && git diff --cached --quiet; then
    echo "✅ Nenhuma mudança pendente"
else
    echo "⚠️  AVISO: Existem mudanças não commitadas"
    git status --porcelain
fi

# Verificar se está sincronizado com remoto
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/8.0 2>/dev/null)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Sincronizado com origin/8.0"
else
    echo "⚠️  AVISO: Não sincronizado com origin/8.0"
fi

# Estatísticas finais
echo ""
echo "📊 ESTATÍSTICAS FINAIS:"
echo "======================="

MODULE_FILES=$(find pos_pay4all -type f | wc -l | tr -d ' ')
MODULE_SIZE=$(du -sh pos_pay4all | cut -f1)
REPO_SIZE=$(du -sh . --exclude='.git' | cut -f1)

echo "📁 Arquivos no módulo: $MODULE_FILES"
echo "📦 Tamanho do módulo: $MODULE_SIZE"
echo "🗂️  Tamanho do repositório: $REPO_SIZE"

# URL do repositório
REPO_URL=$(git remote get-url origin 2>/dev/null)
echo "🔗 Repositório: $REPO_URL#8.0"

# Resultado final
echo ""
echo "🎯 RESULTADO FINAL:"
echo "=================="

if [ "$MISSING" != true ] && [ "$MISSING_STATIC" != true ] && [ "$MISSING_IMAGES" != true ]; then
    echo "✅ SUCESSO: Repositório 100% pronto para Odoo Apps Store!"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Submeter repositório: $REPO_URL#8.0"
    echo "2. Especificar módulo: pos_pay4all/"
    echo "3. Aguardar validação automática"
    echo ""
    echo "🚀 PRONTO PARA PUBLICAÇÃO!"
    exit 0
else
    echo "❌ ERRO: Repositório não está pronto"
    echo "Corrija os problemas listados acima"
    exit 1
fi
