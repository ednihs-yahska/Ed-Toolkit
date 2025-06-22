// Support form functionality
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('supportForm');
    const formStatus = document.getElementById('form-status');

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(form);
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
        submitButton.textContent = 'Sending...';
        submitButton.disabled = true;

        // Send email using EmailJS or similar service
        sendSupportEmail(data)
            .then(() => {
                showStatus('success', 'Thank you! Your message has been sent successfully. We\'ll get back to you soon.');
                form.reset();
            })
            .catch((error) => {
                console.error('Error sending email:', error);
                showStatus('error', 'Sorry, there was an error sending your message. Please try again or contact us directly at hello@ed-yahska.xyz');
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