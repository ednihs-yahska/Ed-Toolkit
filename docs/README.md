# Ed-Toolkit Website

This is the GitHub Pages website for Ed-Toolkit, a comprehensive suite of developer tools for macOS.

## Features

- **Marketing Homepage**: Showcases app features, screenshots, and accessibility features
- **Support Page**: Contact form for user support and FAQ section
- **Responsive Design**: Works on all devices and screen sizes
- **Accessibility**: Built with accessibility best practices
- **Email Integration**: Support form sends emails to hello@ed-yahska.xyz

## Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository settings
2. Scroll down to "Pages" section
3. Select "Deploy from a branch"
4. Choose "main" branch and "/docs" folder
5. Click "Save"

### 2. Configure Email Service

The support form is set up to work with multiple email services. Choose one:

#### Option A: EmailJS (Recommended)
1. Sign up at [EmailJS](https://www.emailjs.com/)
2. Create a service and template
3. Replace placeholders in `support.js`:
   - `YOUR_SERVICE_ID`
   - `YOUR_TEMPLATE_ID`
4. Add EmailJS script to `support.html`:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
   <script>
     emailjs.init("YOUR_PUBLIC_KEY");
   </script>
   ```

#### Option B: Formspree
1. Sign up at [Formspree](https://formspree.io/)
2. Create a new form
3. Replace `YOUR_FORM_ID` in `support.js`

#### Option C: Netlify Forms (if hosting on Netlify)
1. Add `netlify` attribute to the form in `support.html`
2. Deploy to Netlify
3. Forms will automatically work

#### Option D: Mailto Fallback (Default)
- Currently configured to open the user's email client
- No additional setup required
- Works immediately but provides less seamless experience

### 3. Update Configuration

1. Update `_config.yml` with your GitHub username
2. Update image paths if needed
3. Customize content in `index.html` and `support.html`

## File Structure

```
docs/
├── index.html          # Homepage
├── support.html        # Support page with contact form
├── styles.css         # CSS styling
├── support.js         # JavaScript for form functionality
├── images/            # Images and screenshots
│   ├── icon.png
│   ├── url-decoder-english.png
│   ├── json-formatter-hindi.png
│   └── diff-spanish.png
├── _config.yml        # GitHub Pages configuration
└── README.md          # This file
```

## Customization

### Adding New Screenshots
1. Add images to `docs/images/` folder
2. Update references in `index.html`
3. Optimize images for web (recommended: 800px width max)

### Updating Content
- Edit `index.html` for homepage content
- Edit `support.html` for support page content
- Update `styles.css` for styling changes

### Email Configuration
The current setup sends emails to `hello@ed-yahska.xyz`. To change this:
1. Update the email address in `support.js`
2. Configure your chosen email service

## Testing Locally

To test the website locally:

1. Install Jekyll: `gem install jekyll bundler`
2. Navigate to docs folder: `cd docs`
3. Run: `bundle exec jekyll serve`
4. Open: `http://localhost:4000`

## Support

For technical support with the website, check the GitHub repository issues or contact the development team.