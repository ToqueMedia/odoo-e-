# -*- coding: utf-8 -*-
{
    'name': 'POS Pay4All Payment Gateway',
    'version': '16.0.2.0.0',
    'category': 'Point of Sale',
    'summary': 'Integração completa Pay4All (e-Kwanza, Multicaixa Express) para POS',
    'description': '''
        Módulo completo de pagamento Pay4All para Point of Sale do Odoo
        
        🎯 Funcionalidades:
        ✅ e-Kwanza (pagamento via carteira móvel)
        ✅ Multicaixa Express (pagamento via terminal)
        ✅ 3 telas especializadas com design pixel-perfect
        ✅ Validação robusta de números angolanos  
        ✅ Integração API real com endpoints oficiais
        ✅ Timeouts inteligentes por método
        ✅ Interface moderna seguindo mockups profissionais
        ✅ Suporte completo a AOA (Kwanza angolano)
        
        🚀 Pronto para produção!
    ''',
    'author': 'Pay4All Development Team',
    'website': 'https://pay4all.ao',
    'depends': ['point_of_sale', 'payment'],
    'data': [
        'views/payment_provider_views.xml',
        'data/payment_provider_data.xml',
    ],
    'assets': {
        'point_of_sale.assets': [
            'pos_pay4all/static/src/js/main.js',
            'pos_pay4all/static/src/js/pay4all_payment_screen.js',
            'pos_pay4all/static/src/js/pay4all_processing_screen.js',
            'pos_pay4all/static/src/js/pay4all_multicaixa_wait_screen.js',
            'pos_pay4all/static/src/js/pay4all_payment_interface.js',
            'pos_pay4all/static/src/css/pay4all_payment.css',
            'pos_pay4all/static/src/xml/pay4all_payment_screen.xml',
            'pos_pay4all/static/src/xml/pay4all_processing_screen.xml',
            'pos_pay4all/static/src/xml/pay4all_multicaixa_wait_screen.xml',
        ],
    },
    'installable': True,
    'application': False,
    'auto_install': False,
}
