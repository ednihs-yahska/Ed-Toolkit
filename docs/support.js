// Support form functionality with abuse prevention
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('supportForm');
    const formStatus = document.getElementById('form-status');
    
    // Rate limiting configuration
    const RATE_LIMIT_KEY = 'ed-toolkit-support-submissions';
    const RATE_LIMIT_WINDOW = 15 * 60 * 1000; // 15 minutes
    const MAX_SUBMISSIONS = 3; // Max 3 submissions per 15 minutes
    
    // Detect current language from page
    const currentLang = document.documentElement.lang || 'en';
    
    // Internationalization messages
    const messages = {
        en: {
            rateLimitError: 'Too many submissions. Please wait 15 minutes before submitting again.',
            captchaError: 'Please solve the math problem correctly.',
            spamError: 'Spam detected.',
            messageTooShort: 'Message must be at least 10 characters long.',
            messageTooLong: 'Message is too long. Please keep it under 5000 characters.',
            spamContent: 'Message appears to contain spam content.',
            repeatedChars: 'Message contains too many repeated characters.',
            success: 'Thank you! Your message has been sent successfully. We\'ll get back to you soon.',
            error: 'Sorry, there was an error sending your message. Please try again or contact us directly at hello@ed-yahska.xyz',
            sending: 'Sending...',
            sendMessage: 'Send Message'
        },
        es: {
            rateLimitError: 'Demasiados envíos. Por favor espera 15 minutos antes de enviar nuevamente.',
            captchaError: 'Por favor resuelve el problema matemático correctamente.',
            spamError: 'Spam detectado.',
            messageTooShort: 'El mensaje debe tener al menos 10 caracteres.',
            messageTooLong: 'El mensaje es demasiado largo. Por favor manténlo bajo 5000 caracteres.',
            spamContent: 'El mensaje parece contener contenido de spam.',
            repeatedChars: 'El mensaje contiene demasiados caracteres repetidos.',
            success: '¡Gracias! Tu mensaje ha sido enviado exitosamente. Te responderemos pronto.',
            error: 'Lo sentimos, hubo un error al enviar tu mensaje. Por favor intenta nuevamente o contáctanos directamente en hello@ed-yahska.xyz',
            sending: 'Enviando...',
            sendMessage: 'Enviar Mensaje'
        },
        hi: {
            rateLimitError: 'बहुत सारे सबमिशन। कृपया दोबारा सबमिट करने से पहले 15 मिनट प्रतीक्षा करें।',
            captchaError: 'कृपया गणित की समस्या को सही तरीके से हल करें।',
            spamError: 'स्पैम का पता चला।',
            messageTooShort: 'संदेश कम से कम 10 अक्षर लंबा होना चाहिए।',
            messageTooLong: 'संदेश बहुत लंबा है। कृपया इसे 5000 अक्षरों के अंतर्गत रखें।',
            spamContent: 'संदेश में स्पैम सामग्री होने की संभावना है।',
            repeatedChars: 'संदेश में बहुत सारे दोहराए गए अक्षर हैं।',
            success: 'धन्यवाद! आपका संदेश सफलतापूर्वक भेजा गया है। हम जल्द ही आपसे संपर्क करेंगे।',
            error: 'क्षमा करें, आपका संदेश भेजने में त्रुटि हुई। कृपया दोबारा कोशिश करें या सीधे hello@ed-yahska.xyz पर संपर्क करें',
            sending: 'भेजा जा रहा है...',
            sendMessage: 'संदेश भेजें'
        }
    };
    
    // Get localized message
    function getMessage(key) {
        return messages[currentLang]?.[key] || messages.en[key] || key;
    }
    
    // Generate simple math captcha
    function generateCaptcha() {
        const num1 = Math.floor(Math.random() * 10) + 1;
        const num2 = Math.floor(Math.random() * 10) + 1;
        const operators = ['+', '-'];
        const operator = operators[Math.floor(Math.random() * operators.length)];
        
        let answer;
        if (operator === '+') {
            answer = num1 + num2;
        } else {
            answer = num1 - num2;
        }
        
        return {
            question: `${num1} ${operator} ${num2} = ?`,
            answer: answer
        };
    }
    
    // Initialize captcha
    let currentCaptcha = generateCaptcha();
    document.getElementById('captcha-question').textContent = currentCaptcha.question;
    
    // Refresh captcha button
    document.getElementById('refresh-captcha').addEventListener('click', function() {
        currentCaptcha = generateCaptcha();
        document.getElementById('captcha-question').textContent = currentCaptcha.question;
        document.getElementById('captcha-answer').value = '';
    });
    
    // Check rate limiting
    function checkRateLimit() {
        try {
            const submissions = JSON.parse(localStorage.getItem(RATE_LIMIT_KEY) || '[]');
            const now = Date.now();
            
            // Remove old submissions outside the window
            const recentSubmissions = submissions.filter(time => now - time < RATE_LIMIT_WINDOW);
            
            // Update storage
            localStorage.setItem(RATE_LIMIT_KEY, JSON.stringify(recentSubmissions));
            
            return recentSubmissions.length < MAX_SUBMISSIONS;
        } catch (e) {
            // If localStorage is not available, allow submission
            return true;
        }
    }
    
    // Record submission
    function recordSubmission() {
        try {
            const submissions = JSON.parse(localStorage.getItem(RATE_LIMIT_KEY) || '[]');
            submissions.push(Date.now());
            localStorage.setItem(RATE_LIMIT_KEY, JSON.stringify(submissions));
        } catch (e) {
            // Ignore if localStorage is not available
        }
    }
    
    // Validate form with abuse prevention
    function validateForm(formData) {
        const errors = [];
        
        // Check rate limiting
        if (!checkRateLimit()) {
            errors.push(getMessage('rateLimitError'));
        }
        
        // Check captcha
        const captchaAnswer = parseInt(formData.get('captcha-answer'));
        if (isNaN(captchaAnswer) || captchaAnswer !== currentCaptcha.answer) {
            errors.push(getMessage('captchaError'));
        }
        
        // Check honeypot (should be empty)
        const honeypot = formData.get('website');
        if (honeypot && honeypot.trim() !== '') {
            errors.push(getMessage('spamError'));
        }
        
        // Basic content validation
        const message = formData.get('message');
        const name = formData.get('name');
        const email = formData.get('email');
        
        if (message.length < 10) {
            errors.push(getMessage('messageTooShort'));
        }
        
        if (message.length > 5000) {
            errors.push(getMessage('messageTooLong'));
        }
        
        // Simple spam keyword detection
        const spamKeywords = ['casino', 'viagra', 'lottery', 'winner', 'congratulations', 'click here', 'free money'];
        const messageText = message.toLowerCase();
        const hasSpam = spamKeywords.some(keyword => messageText.includes(keyword));
        if (hasSpam) {
            errors.push(getMessage('spamContent'));
        }
        
        // Check for repeated characters (simple spam detection)
        const repeatedChars = /(..).*\1.*\1.*\1/;
        if (repeatedChars.test(message)) {
            errors.push(getMessage('repeatedChars'));
        }
        
        return errors;
    }

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(form);
        
        // Validate form and check for abuse
        const validationErrors = validateForm(formData);
        if (validationErrors.length > 0) {
            showStatus('error', validationErrors.join(' '));
            // Refresh captcha on error
            currentCaptcha = generateCaptcha();
            document.getElementById('captcha-question').textContent = currentCaptcha.question;
            document.getElementById('captcha-answer').value = '';
            return;
        }
        
        const data = {
            name: formData.get('name'),
            email: formData.get('email'),
            subject: formData.get('subject'),
            message: formData.get('message'),
            systemInfo: formData.get('system-info') || 'Not provided'
        };

        // Show loading state
        const submitButton = form.querySelector('button[type="submit"]');
        const originalText = submitButton.textContent;
        submitButton.textContent = getMessage('sending');
        submitButton.disabled = true;

        // Record submission for rate limiting
        recordSubmission();
        
        // Send email using EmailJS or similar service
        sendSupportEmail(data)
            .then(() => {
                showStatus('success', getMessage('success'));
                form.reset();
                // Generate new captcha after successful submission
                currentCaptcha = generateCaptcha();
                document.getElementById('captcha-question').textContent = currentCaptcha.question;
            })
            .catch((error) => {
                console.error('Error sending email:', error);
                showStatus('error', getMessage('error'));
            })
            .finally(() => {
                submitButton.textContent = originalText;
                submitButton.disabled = false;
            });
    });

    function sendSupportEmail(data) {
        const emailBody = `
Name: ${data.name}
Email: ${data.email}
Subject: ${data.subject}
System Info: ${data.systemInfo}

Message:
${data.message}

---
Sent from Ed-Toolkit Support Form
        `.trim();

        // Option 1: Using EmailJS (if configured)
        if (typeof emailjs !== 'undefined' && window.EMAILJS_SERVICE_ID && window.EMAILJS_TEMPLATE_ID) {
            const emailParams = {
                to_email: 'hello@ed-yahska.xyz',
                from_name: data.name,
                from_email: data.email,
                subject: `Ed-Toolkit Support: ${data.subject}`,
                message: emailBody
            };
            return emailjs.send(window.EMAILJS_SERVICE_ID, window.EMAILJS_TEMPLATE_ID, emailParams);
        }
        
        // Option 2: Using Formspree (if configured)
        if (window.FORMSPREE_FORM_ID) {
            return fetch(`https://formspree.io/f/${window.FORMSPREE_FORM_ID}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email: data.email,
                    name: data.name,
                    subject: `Ed-Toolkit Support: ${data.subject}`,
                    message: emailBody
                })
            }).then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            });
        }
        
        // Default: Fallback to mailto (most reliable)
        const subject = encodeURIComponent(`Ed-Toolkit Support: ${data.subject}`);
        const body = encodeURIComponent(emailBody);
        const mailtoLink = `mailto:hello@ed-yahska.xyz?subject=${subject}&body=${body}`;
        
        // Open email client
        window.open(mailtoLink, '_blank');
        
        // Return a resolved promise for consistency
        return Promise.resolve();
    }

    function showStatus(type, message) {
        formStatus.className = `form-status ${type}`;
        formStatus.textContent = message;
        formStatus.style.display = 'block';
        
        // Auto-hide success messages after 5 seconds
        if (type === 'success') {
            setTimeout(() => {
                formStatus.style.display = 'none';
            }, 5000);
        }
    }

    // Auto-fill system information if possible
    function autoFillSystemInfo() {
        const systemInfoField = document.getElementById('system-info');
        if (systemInfoField && !systemInfoField.value) {
            const userAgent = navigator.userAgent;
            let systemInfo = '';
            
            // Detect macOS version
            const macMatch = userAgent.match(/Mac OS X (\d+[._]\d+[._]\d+)/);
            if (macMatch) {
                const version = macMatch[1].replace(/_/g, '.');
                systemInfo += `macOS ${version}`;
            }
            
            // Detect architecture
            if (userAgent.includes('Intel')) {
                systemInfo += ', Intel';
            } else if (userAgent.includes('arm64') || userAgent.includes('Apple Silicon')) {
                systemInfo += ', Apple Silicon';
            }
            
            if (systemInfo) {
                systemInfoField.placeholder = systemInfo;
            }
        }
    }

    // Initialize system info detection
    autoFillSystemInfo();
});