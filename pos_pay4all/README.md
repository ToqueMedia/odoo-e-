# Odoo E+ Modules Repository

This repository contains Odoo modules for the E+ platform.

## Modules

### pos_pay4all
Complete Pay4All payment integration for Odoo Point of Sale, supporting:
- e-Kwanza mobile wallet payments
- Multicaixa Express terminal payments
- 3 specialized payment screens
- Real API integration with Pay4All endpoints

**Version**: 16.0.2.0.0  
**Compatibility**: Odoo 16.0+  
**License**: OPL-1

## Installation

Each module is contained in its own folder. To install:

1. Copy the module folder to your Odoo addons directory
2. Update the apps list in Odoo
3. Install the module from the Apps menu

## Module Structure

```
pos_pay4all/
├── __init__.py                 # Module initialization
├── __manifest__.py            # Module manifest
├── LICENSE                    # Module license
├── models/                    # Python models
├── views/                     # XML views
├── data/                      # Data files
└── static/                    # Frontend assets
    ├── src/                   # Source files
    └── description/           # App store description
```

## Documentation

Each module contains its own documentation in the repository root:
- ODOO_ONLINE_INSTALL.md - Installation guide for Odoo Online
- DEPLOYMENT_GUIDE.md - Complete deployment guide
- TECHNICAL.md - Technical documentation
- COMPLIANCE_FINAL.md - Odoo Apps Store compliance

## Support

For support and questions:
- Email: suporte@pay4all.ao
- Website: https://pay4all.ao

## License

Modules are licensed under OPL-1 (Odoo Proprietary License) unless otherwise specified.
