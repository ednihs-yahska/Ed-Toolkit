// Email Configuration Example
// Copy this file to email-config.js and configure your email service

// Option 1: EmailJS Configuration
// Sign up at https://www.emailjs.com/
window.EMAILJS_SERVICE_ID = 'your_service_id_here';
window.EMAILJS_TEMPLATE_ID = 'your_template_id_here';
window.EMAILJS_PUBLIC_KEY = 'your_public_key_here';

// Option 2: Formspree Configuration  
// Sign up at https://formspree.io/
// window.FORMSPREE_FORM_ID = 'your_form_id_here';

// If using EmailJS, add this script tag to support.html before the closing </body> tag:
/*
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
<script src="email-config.js"></script>
<script>
  if (window.EMAILJS_PUBLIC_KEY) {
    emailjs.init(window.EMAILJS_PUBLIC_KEY);
  }
</script>
*/

// EmailJS Template Example:
/*
Subject: {{subject}}

From: {{from_name}} ({{from_email}})

{{message}}
*/