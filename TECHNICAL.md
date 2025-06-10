# 🛠️ Pay4All - Documentação Técnica para Desenvolvedores

## 🏗️ Arquitetura Detalhada

### 📋 **Stack Tecnológico**

```yaml
Backend:
  - Python 3.8+
  - Odoo 16.0 Framework
  - PostgreSQL Database

Frontend:
  - JavaScript ES6+
  - OWL Framework (Odoo)
  - CSS3 + Flexbox/Grid
  - XML Templates

APIs:
  - RESTful APIs (Pay4All)
  - JSON Payloads
  - HTTP/HTTPS Protocol

Dependencies:
  - point_of_sale (Odoo module)
  - payment (Odoo module)
```

### 🔄 **Fluxo de Dados Detalhado**

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│     POS     │───▶│ PaymentInterface │───▶│     Tela 1      │
│ (Operador)  │    │  (Orquestrador)  │    │   (Seleção)     │
└─────────────┘    └──────────────────┘    └─────────────────┘
                            │                        │
                            │                        ▼
                            │               ┌─────────────────┐
                            │               │     Tela 2      │
                            │               │ (Processamento) │
                            │               └─────────────────┘
                            │                        │
                            │                        ▼
                            │               ┌─────────────────┐
                            │               │     Tela 3      │
                            │               │ (Multicaixa)    │
                            │               └─────────────────┘
                            │                        │
                            ▼                        ▼
                   ┌─────────────────┐    ┌─────────────────┐
                   │   API Pay4All   │◀───│  Status Check   │
                   │   (Externa)     │    │   (Polling)     │
                   └─────────────────┘    └─────────────────┘
```

## 🧩 **Componentes Principais**

### 1. **PaymentProvider (Backend)**

```python
# models/payment_provider.py
class PaymentProvider(models.Model):
    _inherit = 'payment.provider'
    
    code = fields.Selection(selection_add=[('pay4all', 'Pay4All (e+)')])
    pay4all_api_key = fields.Char(string='API Key')
    pay4all_account_number = fields.Char(string='Account Number')
    pay4all_notification_token = fields.Char(string='Notification Token')
    
    def _get_supported_currencies(self):
        # Suporte específico para AOA (Kwanza angolano)
        if self.code == 'pay4all':
            return self.env['res.currency'].search([('name', '=', 'AOA')])
        return super()._get_supported_currencies()
```

### 2. **PaymentInterface (Frontend)**

```javascript
// static/src/js/pay4all_payment_interface.js
export class Pay4AllPaymentInterface extends PaymentInterface {
    
    async send_payment_request(cid) {
        // 1. Coletar dados do pedido
        const paymentData = this.buildPaymentData();
        
        // 2. Abrir Tela 1 (Seleção)
        const selection = await this.showSelectionScreen(paymentData);
        
        // 3. Abrir Tela 2 (Processamento)
        const processing = await this.showProcessingScreen(selection);
        
        // 4. Abrir Tela 3 (Multicaixa) se necessário
        if (processing.nextScreen === 'multicaixa_wait') {
            return await this.showMulticaixaWaitScreen(processing.data);
        }
        
        // 5. Finalizar pagamento
        return this.finalizePay(processing);
    }
}
```

### 3. **Pay4AllPaymentScreen (Tela 1)**

```javascript
// static/src/js/pay4all_payment_screen.js
export class Pay4AllPaymentScreen extends AbstractAwaitablePopup {
    static template = 'Pay4AllPaymentScreen';
    
    setup() {
        this.state = useState({
            selectedMethod: null,     // 'ekwanza' | 'multicaixa'
            phoneNumber: '',          // Formatted phone
            phoneError: null,         // Validation error
            isProcessing: false       // Loading state
        });
    }
    
    // Métodos principais
    selectMethod(method) { /* ... */ }
    validatePhone() { /* ... */ }
    formatPhoneNumber(value) { /* ... */ }
    continuePayment() { /* ... */ }
}
```

### 4. **Pay4AllProcessingScreen (Tela 2)**

```javascript
// static/src/js/pay4all_processing_screen.js
export class Pay4AllProcessingScreen extends AbstractAwaitablePopup {
    static template = 'Pay4AllProcessingScreen';
    
    setup() {
        this.state = useState({
            timeRemaining: 90,        // Countdown seconds
            reference: null,          // Payment reference
            paymentStatus: 'pending', // 'pending'|'success'|'failed'|'timeout'
            progressPercentage: 100   // Progress bar
        });
        
        // Configurações
        this.TOTAL_TIME = 90;                // 90 segundos
        this.API_CHECK_INTERVAL = 5000;      // 5 segundos
        this.COUNTDOWN_INTERVAL = 1000;      // 1 segundo
    }
    
    // Métodos principais
    async startPaymentProcess() { /* API Request */ }
    startCountdown() { /* Timer management */ }
    startStatusCheck() { /* Polling */ }
    async checkPaymentStatus() { /* API Status */ }
}
```

### 5. **Pay4AllMulticaixaWaitScreen (Tela 3)**

```javascript
// static/src/js/pay4all_multicaixa_wait_screen.js
export class Pay4AllMulticaixaWaitScreen extends AbstractAwaitablePopup {
    static template = 'Pay4AllMulticaixaWaitScreen';
    
    setup() {
        this.state = useState({
            reference: null,
            isWaiting: true,
            paymentStatus: 'pending'
        });
        
        // Configurações específicas Multicaixa
        this.API_CHECK_INTERVAL = 3000;     // 3 segundos (mais frequente)
        this.MAX_WAIT_TIME = 300000;        // 5 minutos
    }
    
    // Métodos específicos
    async makeMulticaixaRequest() { /* Multicaixa API */ }
    async checkMulticaixaStatus() { /* Status específico */ }
}
```

## 🔌 **Integração API Detalhada**

### 📡 **Request Builders**

```javascript
// Construtor de payload e-Kwanza
buildEkwanzaPayload() {
    return {
        api_key: this.getApiKey(),
        account_number: this.getAccountNumber(),
        amount: parseFloat(this.props.amount),
        description: this.props.description,
        order_id: this.props.order_id,
        customer_phone: this.cleanPhoneNumber(this.props.phone),
        payment_method: 'ekwanza',
        callback_url: this.buildCallbackUrl()
    };
}

// Construtor de payload Multicaixa
buildMulticaixaPayload() {
    return {
        api_key: this.getApiKey(),
        account_number: this.getAccountNumber(),
        amount: parseFloat(this.props.amount),
        description: this.props.description,
        order_id: this.props.order_id,
        customer_phone: this.cleanPhoneNumber(this.props.phone),
        payment_method: 'multicaixa_express',
        callback_url: this.buildCallbackUrl()
    };
}
```

### 🔄 **Error Handling**

```javascript
class Pay4AllErrorHandler {
    
    handleApiError(error, context) {
        const errorMap = {
            'INVALID_PHONE': 'Número de telefone inválido',
            'INSUFFICIENT_FUNDS': 'Saldo insuficiente na carteira',
            'NETWORK_ERROR': 'Erro de conexão. Tente novamente.',
            'INVALID_API_KEY': 'Credenciais inválidas',
            'TIMEOUT': 'Tempo limite excedido',
            'UNKNOWN': 'Erro desconhecido. Contate o suporte.'
        };
        
        const userMessage = errorMap[error.code] || errorMap['UNKNOWN'];
        
        console.error(`Pay4All Error [${context}]:`, error);
        
        return {
            success: false,
            error: userMessage,
            code: error.code,
            context: context
        };
    }
    
    handleNetworkError(error) {
        if (error.name === 'TypeError' && error.message.includes('fetch')) {
            return this.handleApiError({ code: 'NETWORK_ERROR' }, 'network');
        }
        return this.handleApiError({ code: 'UNKNOWN' }, 'network');
    }
}
```

### ⏰ **Timer Management**

```javascript
class Pay4AllTimerManager {
    
    constructor() {
        this.timers = new Map();
    }
    
    startCountdown(name, duration, callback, onTick) {
        this.clearTimer(name);
        
        let remaining = duration;
        const timer = setInterval(() => {
            remaining--;
            
            if (onTick) onTick(remaining);
            
            if (remaining <= 0) {
                this.clearTimer(name);
                if (callback) callback();
            }
        }, 1000);
        
        this.timers.set(name, timer);
        return timer;
    }
    
    startPolling(name, interval, callback) {
        this.clearTimer(name);
        
        const timer = setInterval(async () => {
            try {
                await callback();
            } catch (error) {
                console.error(`Polling error [${name}]:`, error);
            }
        }, interval);
        
        this.timers.set(name, timer);
        return timer;
    }
    
    clearTimer(name) {
        if (this.timers.has(name)) {
            clearInterval(this.timers.get(name));
            this.timers.delete(name);
        }
    }
    
    clearAllTimers() {
        for (const [name, timer] of this.timers) {
            clearInterval(timer);
        }
        this.timers.clear();
    }
}
```

## 🎨 **CSS Architecture**

### 📐 **Design Tokens**

```css
:root {
  /* Cores principais */
  --pay4all-primary-blue: #3182ce;
  --pay4all-primary-green: #38a169;
  --pay4all-warning-orange: #ed8936;
  
  /* Texto */
  --pay4all-text-primary: #2d3748;
  --pay4all-text-secondary: #718096;
  --pay4all-text-light: #a0aec0;
  
  /* Backgrounds */
  --pay4all-bg-white: #ffffff;
  --pay4all-bg-light: #f7fafc;
  --pay4all-bg-blue-light: #ebf8ff;
  --pay4all-bg-green-light: #f0fff4;
  
  /* Borders */
  --pay4all-border-light: #e2e8f0;
  --pay4all-border-medium: #cbd5e0;
  
  /* Shadows */
  --pay4all-shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
  --pay4all-shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.2);
  
  /* Spacing */
  --pay4all-space-xs: 4px;
  --pay4all-space-sm: 8px;
  --pay4all-space-md: 16px;
  --pay4all-space-lg: 24px;
  --pay4all-space-xl: 32px;
  
  /* Radius */
  --pay4all-radius-sm: 4px;
  --pay4all-radius-md: 8px;
  --pay4all-radius-lg: 12px;
  
  /* Transitions */
  --pay4all-transition-fast: 0.2s ease;
  --pay4all-transition-normal: 0.3s ease;
}
```

### 🧱 **Component Structure**

```css
/* Base modal */
.pay4all-modal {
  /* Layout */
  display: flex;
  flex-direction: column;
  max-height: 90vh;
  overflow: hidden;
  
  /* Visual */
  background: var(--pay4all-bg-white);
  border-radius: var(--pay4all-radius-lg);
  box-shadow: var(--pay4all-shadow-lg);
  
  /* Animation */
  animation: fadeInScale var(--pay4all-transition-normal);
}

/* Method selection cards */
.pay4all-method-option {
  /* Layout */
  display: flex;
  align-items: center;
  padding: var(--pay4all-space-md);
  
  /* Visual */
  border: 2px solid var(--pay4all-border-light);
  border-radius: var(--pay4all-radius-md);
  background: var(--pay4all-bg-white);
  
  /* Interaction */
  cursor: pointer;
  transition: all var(--pay4all-transition-fast);
}

.pay4all-method-option:hover {
  border-color: var(--pay4all-border-medium);
  transform: translateY(-1px);
}

.pay4all-method-option.selected.ekwanza {
  border-color: var(--pay4all-primary-blue);
  background: var(--pay4all-bg-blue-light);
}

.pay4all-method-option.selected.multicaixa {
  border-color: var(--pay4all-primary-green);
  background: var(--pay4all-bg-green-light);
}
```

## 🧪 **Testing Strategy**

### 🎯 **Unit Tests (JavaScript)**

```javascript
// tests/pay4all_phone_validation.test.js
describe('Pay4All Phone Validation', () => {
    
    test('should format Angolan phone numbers correctly', () => {
        const formatter = new Pay4AllPhoneFormatter();
        
        expect(formatter.format('921785735')).toBe('+244 921 785 735');
        expect(formatter.format('244921785735')).toBe('+244 921 785 735');
        expect(formatter.format('+244921785735')).toBe('+244 921 785 735');
    });
    
    test('should validate Angolan phone numbers', () => {
        const validator = new Pay4AllPhoneValidator();
        
        expect(validator.isValid('+244921785735')).toBe(true);
        expect(validator.isValid('921785735')).toBe(true);
        expect(validator.isValid('123456789')).toBe(false);
    });
    
    test('should handle edge cases', () => {
        const formatter = new Pay4AllPhoneFormatter();
        
        expect(formatter.format('')).toBe('');
        expect(formatter.format('92178')).toBe('92178');
        expect(formatter.format('921785735123')).toBe('+244 921 785 735');
    });
});
```

### 🧪 **Integration Tests (Python)**

```python
# tests/test_payment_provider.py
from odoo.tests.common import TransactionCase

class TestPay4AllProvider(TransactionCase):
    
    def setUp(self):
        super().setUp()
        self.provider = self.env['payment.provider'].create({
            'name': 'Test Pay4All',
            'code': 'pay4all',
            'state': 'test',
            'pay4all_api_key': 'test_key',
            'pay4all_account_number': 'test_account',
        })
    
    def test_provider_creation(self):
        """Test if Pay4All provider is created correctly"""
        self.assertEqual(self.provider.code, 'pay4all')
        self.assertEqual(self.provider.name, 'Test Pay4All')
    
    def test_supported_currencies(self):
        """Test if AOA currency is supported"""
        aoa = self.env['res.currency'].search([('name', '=', 'AOA')])
        if aoa:
            supported = self.provider._get_supported_currencies()
            self.assertIn(aoa, supported)
    
    def test_payment_flow(self):
        """Test complete payment flow"""
        # Create order
        order = self._create_test_order()
        
        # Create payment line
        payment_line = self._create_payment_line(order)
        
        # Simulate payment request
        result = self.provider._process_payment_request(payment_line)
        
        self.assertTrue(result)
```

### 🎭 **E2E Tests (Selenium)**

```python
# tests/test_pos_flow.py
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TestPay4AllPOSFlow:
    
    def test_complete_payment_flow(self):
        """Test complete POS payment flow"""
        driver = self.setup_driver()
        
        try:
            # 1. Login to POS
            self.login_pos(driver)
            
            # 2. Add product to cart
            self.add_product_to_cart(driver)
            
            # 3. Start payment
            self.click_payment_button(driver)
            
            # 4. Select Pay4All
            self.select_pay4all_method(driver)
            
            # 5. Verify Tela 1 opens
            modal = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CLASS_NAME, "pay4all-modal"))
            )
            self.assertTrue(modal.is_displayed())
            
            # 6. Select e-Kwanza
            ekwanza_option = driver.find_element(By.CSS_SELECTOR, 
                ".pay4all-method-option.ekwanza")
            ekwanza_option.click()
            
            # 7. Enter phone number
            phone_input = driver.find_element(By.ID, "pay4all-phone")
            phone_input.send_keys("921785735")
            
            # 8. Verify formatting
            self.assertEqual(phone_input.get_attribute("value"), 
                           "+244 921 785 735")
            
            # 9. Continue to Tela 2
            continue_btn = driver.find_element(By.CSS_SELECTOR,
                ".pay4all-btn-primary")
            continue_btn.click()
            
            # 10. Verify Tela 2 opens
            countdown = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CLASS_NAME, "pay4all-countdown"))
            )
            self.assertTrue(countdown.is_displayed())
            
        finally:
            driver.quit()
```

## 📊 **Performance Optimization**

### ⚡ **JavaScript Optimizations**

```javascript
// Debounced phone validation
class Pay4AllOptimizer {
    
    constructor() {
        this.debounceTimers = new Map();
    }
    
    debounce(key, func, delay = 300) {
        if (this.debounceTimers.has(key)) {
            clearTimeout(this.debounceTimers.get(key));
        }
        
        const timer = setTimeout(() => {
            func();
            this.debounceTimers.delete(key);
        }, delay);
        
        this.debounceTimers.set(key, timer);
    }
    
    // Optimized phone validation
    validatePhoneDebounced(phoneNumber, callback) {
        this.debounce('phone_validation', () => {
            const isValid = this.validatePhone(phoneNumber);
            callback(isValid);
        }, 300);
    }
    
    // Memoized API responses
    memoizeApiResponse(key, apiCall, ttl = 60000) {
        const cache = this.apiCache || new Map();
        
        if (cache.has(key)) {
            const cached = cache.get(key);
            if (Date.now() - cached.timestamp < ttl) {
                return Promise.resolve(cached.data);
            }
        }
        
        return apiCall().then(data => {
            cache.set(key, {
                data: data,
                timestamp: Date.now()
            });
            return data;
        });
    }
}
```

### 🗃️ **Database Optimizations**

```python
# models/payment_provider.py
class PaymentProvider(models.Model):
    _inherit = 'payment.provider'
    
    # Índices para performance
    pay4all_api_key = fields.Char(string='API Key', index=True)
    pay4all_account_number = fields.Char(string='Account Number', index=True)
    
    @api.model
    def _get_pay4all_provider(self):
        """Cached provider lookup"""
        return self.env['payment.provider'].search([
            ('code', '=', 'pay4all'),
            ('state', 'in', ['enabled', 'test'])
        ], limit=1)
    
    @tools.ormcache('provider_id')
    def _get_pay4all_config(self, provider_id):
        """Cached configuration lookup"""
        provider = self.browse(provider_id)
        return {
            'api_key': provider.pay4all_api_key,
            'account_number': provider.pay4all_account_number,
            'notification_token': provider.pay4all_notification_token,
        }
```

## 🔒 **Security Considerations**

### 🛡️ **Input Validation**

```javascript
class Pay4AllSecurity {
    
    // Sanitize phone input
    sanitizePhoneNumber(phone) {
        if (typeof phone !== 'string') return '';
        
        // Remove all non-digit characters except +
        return phone.replace(/[^\d+]/g, '').substring(0, 15);
    }
    
    // Validate amount
    validateAmount(amount) {
        const parsed = parseFloat(amount);
        
        if (isNaN(parsed) || parsed <= 0) {
            throw new Error('Invalid amount');
        }
        
        if (parsed > 1000000) { // 1M AOA limit
            throw new Error('Amount exceeds limit');
        }
        
        return parsed;
    }
    
    // Sanitize description
    sanitizeDescription(description) {
        if (typeof description !== 'string') return '';
        
        // Remove HTML tags and limit length
        return description
            .replace(/<[^>]*>/g, '')
            .substring(0, 255)
            .trim();
    }
}
```

### 🔐 **API Security**

```python
# models/payment_provider.py
class PaymentProvider(models.Model):
    _inherit = 'payment.provider'
    
    def _pay4all_make_request(self, endpoint, payload):
        """Secure API request with rate limiting"""
        
        # Rate limiting check
        if not self._check_rate_limit():
            raise UserError(_('Too many requests. Please wait.'))
        
        # Encrypt sensitive data
        encrypted_payload = self._encrypt_payload(payload)
        
        # Add security headers
        headers = {
            'Content-Type': 'application/json',
            'User-Agent': 'Odoo-Pay4All/1.0',
            'X-Request-ID': str(uuid.uuid4()),
            'X-Timestamp': str(int(time.time())),
        }
        
        try:
            response = requests.post(
                endpoint,
                json=encrypted_payload,
                headers=headers,
                timeout=30,
                verify=True  # SSL verification
            )
            response.raise_for_status()
            return response.json()
            
        except requests.RequestException as e:
            _logger.error(f'Pay4All API Error: {e}')
            raise UserError(_('Payment service unavailable'))
    
    def _check_rate_limit(self):
        """Simple rate limiting implementation"""
        cache_key = f'pay4all_rate_limit_{self.id}'
        last_request = request.env.registry.cache.get(cache_key, 0)
        
        if time.time() - last_request < 1:  # 1 request per second
            return False
            
        request.env.registry.cache[cache_key] = time.time()
        return True
```

## 🚀 **Deployment Guide**

### 📦 **Production Checklist**

```bash
# 1. Backup database
pg_dump -U odoo -h localhost your_database > backup_$(date +%Y%m%d_%H%M%S).sql

# 2. Copy module to production
rsync -av pos_pay4all/ production_server:/opt/odoo/addons/

# 3. Set permissions
sudo chown -R odoo:odoo /opt/odoo/addons/pos_pay4all/
sudo chmod -R 755 /opt/odoo/addons/pos_pay4all/

# 4. Update Odoo
sudo -u odoo /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf -u pos_pay4all -d your_database --stop-after-init

# 5. Restart Odoo service
sudo systemctl restart odoo

# 6. Verify logs
sudo tail -f /var/log/odoo/odoo.log
```

### 🌐 **Environment Variables**

```bash
# /etc/odoo/odoo.conf
[options]
addons_path = /opt/odoo/addons,/opt/odoo/custom-addons

# Pay4All specific configs
pay4all_api_base_url = https://payment.momenu.space
pay4all_timeout = 30
pay4all_retry_attempts = 3
pay4all_log_level = INFO
```

### 📊 **Monitoring**

```python
# monitoring/pay4all_metrics.py
import logging
import time
from functools import wraps

_logger = logging.getLogger(__name__)

def track_payment_metrics(func):
    """Decorator to track payment performance"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        method = kwargs.get('payment_method', 'unknown')
        
        try:
            result = func(*args, **kwargs)
            duration = time.time() - start_time
            
            _logger.info(f'Pay4All Success: {method} - {duration:.2f}s')
            
            # Send to monitoring system
            # send_metric('pay4all.payment.success', 1, tags={'method': method})
            # send_metric('pay4all.payment.duration', duration, tags={'method': method})
            
            return result
            
        except Exception as e:
            duration = time.time() - start_time
            
            _logger.error(f'Pay4All Error: {method} - {duration:.2f}s - {str(e)}')
            
            # Send error metrics
            # send_metric('pay4all.payment.error', 1, tags={'method': method, 'error': type(e).__name__})
            
            raise
    
    return wrapper
```

---

## 📚 **Recursos Adicionais**

### 🔗 **Links Úteis**

- **[Odoo Development Documentation](https://www.odoo.com/documentation/16.0/developer.html)**
- **[OWL Framework Guide](https://github.com/odoo/owl/blob/master/doc/reference/readme.md)**
- **[JavaScript ES6+ Features](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)**
- **[CSS Grid and Flexbox](https://css-tricks.com/snippets/css/complete-guide-grid/)**

### 🛠️ **Development Tools**

```bash
# Linting JavaScript
npm install -g eslint
eslint static/src/js/

# Formatting Python
pip install black
black models/

# Testing
pip install pytest
pytest tests/

# Documentation
pip install sphinx
sphinx-build docs/ docs/_build/
```

### 📈 **Future Enhancements**

1. **WebSocket Integration** para notificações em tempo real
2. **PWA Support** para funcionamento offline
3. **Multi-currency** support além de AOA
4. **Advanced Analytics** dashboard
5. **White-label** customization options
6. **API v2** with GraphQL
7. **Mobile App** integration
8. **Blockchain** transaction verification

---

**🎯 Esta documentação técnica fornece todas as informações necessárias para desenvolvedores trabalharem, modificarem e estenderem o módulo Pay4All.**
