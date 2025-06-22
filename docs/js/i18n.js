// Internationalization (i18n) functionality for Ed-Toolkit website
// Handles language detection, switching, and URL routing

(function() {
    'use strict';

    // Language configuration - all languages now have subdirectories
    const LANGUAGES = {
        'en': {
            name: 'English',
            dir: 'en/'
        },
        'es': {
            name: 'Español',
            dir: 'es/'
        },
        'hi': {
            name: 'हिंदी',
            dir: 'hi/'
        }
    };

    // Get current language from URL path
    function getCurrentLanguage() {
        const path = window.location.pathname;
        
        // Check if we're in a language subdirectory
        if (path.includes('/en/')) return 'en';
        if (path.includes('/es/')) return 'es';
        if (path.includes('/hi/')) return 'hi';
        
        // If we're in root, default to English
        return 'en';
    }

    // Get current page (index or support)
    function getCurrentPage() {
        const path = window.location.pathname;
        if (path.includes('support.html')) return 'support.html';
        return 'index.html';
    }

    // Detect browser language preference
    function detectBrowserLanguage() {
        const browserLang = navigator.language || navigator.userLanguage;
        const langCode = browserLang.split('-')[0].toLowerCase();
        
        // Return supported language or default to English
        return LANGUAGES[langCode] ? langCode : 'en';
    }

    // Get saved language preference
    function getSavedLanguage() {
        try {
            return localStorage.getItem('ed-toolkit-language');
        } catch (e) {
            return null;
        }
    }

    // Save language preference
    function saveLanguage(langCode) {
        try {
            localStorage.setItem('ed-toolkit-language', langCode);
        } catch (e) {
            // localStorage not available, continue without saving
        }
    }

    // Build URL for language and page
    function buildLanguageURL(langCode, page) {
        const currentPath = window.location.pathname;
        const langDir = LANGUAGES[langCode].dir;
        
        // Find the base path (everything before the language directory)
        let basePath = '';
        
        // Check if we're already in a language directory
        const langMatch = currentPath.match(/^(.*)\/(?:en|es|hi)\//);
        if (langMatch) {
            basePath = langMatch[1] + '/';
        } else {
            // We're in root, find the base path
            const pathParts = currentPath.split('/');
            // Remove the last part if it's a file
            if (pathParts[pathParts.length - 1].includes('.html')) {
                pathParts.pop();
            }
            basePath = pathParts.join('/');
            if (!basePath.endsWith('/')) {
                basePath += '/';
            }
        }
        
        // Build the complete URL
        const newURL = basePath + langDir + page;
        
        return newURL;
    }

    // Switch to different language
    function switchLanguage(targetLang) {
        if (!LANGUAGES[targetLang]) {
            console.warn('Unsupported language:', targetLang);
            return;
        }

        const currentPage = getCurrentPage();
        const newURL = buildLanguageURL(targetLang, currentPage);
        
        // Save language preference
        saveLanguage(targetLang);
        
        // Navigate to new language
        console.log('Switching to:', targetLang, 'URL:', newURL); // Debug log
        window.location.href = newURL;
    }

    // Initialize language selector
    function initializeLanguageSelector() {
        const selector = document.getElementById('languageSelect');
        if (!selector) return;

        const currentLang = getCurrentLanguage();
        
        // Set current language in selector
        selector.value = currentLang;
        
        // Add change event listener
        selector.addEventListener('change', function() {
            switchLanguage(this.value);
        });
    }

    // Auto-redirect based on language preference (DISABLED to prevent issues)
    function handleLanguageRedirect() {
        // DISABLED: Auto-redirect causes issues with GitHub Pages
        // Users can manually select their preferred language
        return;
        
        /* 
        // Only redirect from root pages
        const currentLang = getCurrentLanguage();
        const currentPath = window.location.pathname;
        
        // Don't redirect if we're already in a language directory
        if (currentPath.includes('/en/') || currentPath.includes('/es/') || currentPath.includes('/hi/')) {
            return;
        }
        
        // Check if this is a direct visit (not navigation within site)
        const isDirectVisit = !document.referrer || 
                            !document.referrer.includes(window.location.hostname);
        
        if (!isDirectVisit) return;

        // Get language preference (saved > browser > default)
        const savedLang = getSavedLanguage();
        const preferredLang = savedLang || detectBrowserLanguage();
        
        // Redirect to preferred language
        if (LANGUAGES[preferredLang]) {
            const currentPage = getCurrentPage();
            const newURL = buildLanguageURL(preferredLang, currentPage);
            window.location.replace(newURL);
        }
        */
    }

    // Add language switcher styles
    function addLanguageSelectorStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .language-selector select {
                background: transparent;
                border: 1px solid rgba(107, 114, 128, 0.3);
                border-radius: 4px;
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                color: #6b7280;
                cursor: pointer;
                transition: border-color 0.2s;
            }
            
            .language-selector select:hover,
            .language-selector select:focus {
                outline: none;
                border-color: #f59e0b;
            }
            
            .language-selector option {
                background: white;
                color: #1a1a1a;
            }
            
            @media (max-width: 768px) {
                .language-selector {
                    margin-top: 1rem;
                }
                
                .nav-links {
                    flex-direction: column;
                    gap: 1rem;
                }
            }
        `;
        document.head.appendChild(style);
    }

    // Update page meta tags for SEO
    function updateMetaTags() {
        const currentLang = getCurrentLanguage();
        
        // Update html lang attribute
        document.documentElement.lang = currentLang;
        
        // Update page direction for RTL languages (if needed in future)
        if (currentLang === 'ar' || currentLang === 'he') {
            document.documentElement.dir = 'rtl';
        }
    }

    // Initialize internationalization
    function initialize() {
        // Add styles
        addLanguageSelectorStyles();
        
        // Update meta tags
        updateMetaTags();
        
        // Initialize language selector
        initializeLanguageSelector();
        
        // Handle automatic language redirect (currently disabled)
        handleLanguageRedirect();
    }

    // Make switchLanguage globally available
    window.switchLanguage = switchLanguage;

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

})();

// Debug helper
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1' || window.location.hostname.includes('github')) {
    window.i18nDebug = {
        getCurrentLanguage: function() {
            const path = window.location.pathname;
            if (path.includes('/en/')) return 'en';
            if (path.includes('/es/')) return 'es';
            if (path.includes('/hi/')) return 'hi';
            return 'en';
        },
        getAvailableLanguages: function() {
            return ['en', 'es', 'hi'];
        },
        switchToLanguage: function(lang) {
            window.switchLanguage(lang);
        },
        testURL: function(lang, page) {
            console.log('Current path:', window.location.pathname);
            console.log('Target language:', lang);
            console.log('Target page:', page);
            const buildLanguageURL = function(langCode, page) {
                const currentPath = window.location.pathname;
                const LANGUAGES = {
                    'en': { dir: 'en/' },
                    'es': { dir: 'es/' },
                    'hi': { dir: 'hi/' }
                };
                const langDir = LANGUAGES[langCode].dir;
                
                let basePath = '';
                const langMatch = currentPath.match(/^(.*)\/(?:en|es|hi)\//);
                if (langMatch) {
                    basePath = langMatch[1] + '/';
                } else {
                    const pathParts = currentPath.split('/');
                    if (pathParts[pathParts.length - 1].includes('.html')) {
                        pathParts.pop();
                    }
                    basePath = pathParts.join('/');
                    if (!basePath.endsWith('/')) {
                        basePath += '/';
                    }
                }
                
                return basePath + langDir + page;
            };
            console.log('Generated URL:', buildLanguageURL(lang, page || 'index.html'));
        }
    };
}