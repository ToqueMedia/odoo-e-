#!/bin/bash

# Script de Empacotamento para Odoo Online
# Módulo: pos_pay4all
# Versão: 16.0.2.0.0

echo "🚀 Iniciando empacotamento do módulo Pay4All para Odoo Online..."

# Definir variáveis
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_NAME="pos_pay4all"
VERSION="16.0.2.0.0"
PACKAGE_NAME="${MODULE_NAME}_v${VERSION}_odoo_online"
TEMP_DIR="${SCRIPT_DIR}/temp_package"
FINAL_ZIP="${SCRIPT_DIR}/${PACKAGE_NAME}.zip"

# Limpeza de arquivos temporários
echo "🧹 Limpando arquivos temporários..."
rm -rf "$TEMP_DIR"
rm -f "$FINAL_ZIP"

# Criar diretório temporário
mkdir -p "$TEMP_DIR/$MODULE_NAME"

echo "📋 Copiando arquivos essenciais..."

# Arquivos principais (obrigatórios)
cp "$SCRIPT_DIR/__init__.py" "$TEMP_DIR/$MODULE_NAME/"
cp "$SCRIPT_DIR/__manifest__.py" "$TEMP_DIR/$MODULE_NAME/"

# Modelos Python
echo "📁 Copiando modelos Python..."
cp -r "$SCRIPT_DIR/models" "$TEMP_DIR/$MODULE_NAME/"

# Views XML
echo "📁 Copiando views XML..."
cp -r "$SCRIPT_DIR/views" "$TEMP_DIR/$MODULE_NAME/"

# Dados iniciais
echo "📁 Copiando dados iniciais..."
cp -r "$SCRIPT_DIR/data" "$TEMP_DIR/$MODULE_NAME/"

# Arquivos estáticos (JS, CSS, XML templates, description)
echo "📁 Copiando arquivos estáticos..."
cp -r "$SCRIPT_DIR/static" "$TEMP_DIR/$MODULE_NAME/"

# Documentação essencial
echo "📄 Copiando documentação..."
cp "$SCRIPT_DIR/README.md" "$TEMP_DIR/$MODULE_NAME/"
cp "$SCRIPT_DIR/ODOO_ONLINE_INSTALL.md" "$TEMP_DIR/$MODULE_NAME/"
cp "$SCRIPT_DIR/LICENSE" "$TEMP_DIR/$MODULE_NAME/"

# Criar arquivo de informações do pacote
echo "📝 Criando informações do pacote..."
cat > "$TEMP_DIR/$MODULE_NAME/PACKAGE_INFO.txt" << EOF
Módulo Pay4All para Odoo 16
===========================

Versão: $VERSION
Data de empacotamento: $(date)
Tipo: Odoo Online Package

Arquivos incluídos:
- __init__.py (inicialização)
- __manifest__.py (manifesto do módulo)
- models/ (modelos Python)
- views/ (views XML)
- data/ (dados iniciais)
- static/ (JS, CSS, templates)
- README.md (documentação principal)
- ODOO_ONLINE_INSTALL.md (guia de instalação)

Instalação:
1. Faça upload do ZIP no Odoo Online
2. Instale via Apps
3. Configure credenciais Pay4All
4. Adicione ao POS

Suporte: suporte@pay4all.ao
EOF

# Limpeza de arquivos desnecessários para produção
echo "🧹 Removendo arquivos desnecessários..."
find "$TEMP_DIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null
find "$TEMP_DIR" -name "*.pyc" -delete 2>/dev/null
find "$TEMP_DIR" -name ".DS_Store" -delete 2>/dev/null
find "$TEMP_DIR" -name "*.log" -delete 2>/dev/null

# Verificar estrutura de arquivos
echo "🔍 Verificando estrutura do módulo..."
REQUIRED_FILES=(
    "__init__.py"
    "__manifest__.py"
    "models/__init__.py"
    "models/payment_provider.py"
    "views/payment_provider_views.xml"
    "data/payment_provider_data.xml"
    "static/src/css/pay4all_payment.css"
    "static/src/js/main.js"
    "static/description/index.html"
    "static/description/icon.png"
    "static/description/main_screenshot.png"
    "LICENSE"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$TEMP_DIR/$MODULE_NAME/$file" ]]; then
        echo "❌ ERRO: Arquivo obrigatório não encontrado: $file"
        exit 1
    else
        echo "✅ $file"
    fi
done

# Validar manifest.py
echo "🔍 Validando __manifest__.py..."
python3 -c "
import sys
sys.path.insert(0, '$TEMP_DIR/$MODULE_NAME')
try:
    exec(open('$TEMP_DIR/$MODULE_NAME/__manifest__.py').read())
    print('✅ __manifest__.py válido')
except Exception as e:
    print(f'❌ ERRO no __manifest__.py: {e}')
    sys.exit(1)
"

# Contar arquivos e calcular tamanho
FILE_COUNT=$(find "$TEMP_DIR/$MODULE_NAME" -type f | wc -l)
SIZE_KB=$(du -sk "$TEMP_DIR/$MODULE_NAME" | cut -f1)

echo "📊 Estatísticas do pacote:"
echo "   Arquivos: $FILE_COUNT"
echo "   Tamanho: ${SIZE_KB}KB"

# Criar ZIP otimizado
echo "📦 Criando arquivo ZIP..."
cd "$TEMP_DIR"
zip -r "$FINAL_ZIP" "$MODULE_NAME" -x "*.pyc" "*__pycache__*" "*.DS_Store*" >/dev/null 2>&1

# Verificar ZIP criado
if [[ -f "$FINAL_ZIP" ]]; then
    FINAL_SIZE=$(du -sh "$FINAL_ZIP" | cut -f1)
    echo "✅ Pacote criado com sucesso: $PACKAGE_NAME.zip ($FINAL_SIZE)"
else
    echo "❌ ERRO: Falha ao criar o arquivo ZIP"
    exit 1
fi

# Limpeza final
rm -rf "$TEMP_DIR"

# Testar ZIP
echo "🧪 Testando integridade do ZIP..."
if unzip -t "$FINAL_ZIP" >/dev/null 2>&1; then
    echo "✅ ZIP íntegro"
else
    echo "❌ ERRO: ZIP corrompido"
    exit 1
fi

# Resumo final
echo ""
echo "🎉 EMPACOTAMENTO CONCLUÍDO COM SUCESSO!"
echo "────────────────────────────────────────"
echo "📦 Arquivo: $PACKAGE_NAME.zip"
echo "📂 Localização: $FINAL_ZIP"
echo "📊 Tamanho: $FINAL_SIZE"
echo "🔢 Arquivos: $FILE_COUNT"
echo ""
echo "📋 Próximos passos:"
echo "1. Faça upload do ZIP no Odoo Online"
echo "2. Instale via menu Aplicações"
echo "3. Configure credenciais Pay4All"
echo "4. Consulte ODOO_ONLINE_INSTALL.md para detalhes"
echo ""
echo "🚀 Pronto para instalação no Odoo Online!"
