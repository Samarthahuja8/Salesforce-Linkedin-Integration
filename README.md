# Salesforce-Linkedin-Integration

## Project Structure

```
Salesforce-Linkedin-Integration/
├── LinkedinPostRequest.cls
├── LinkedinPostRequest.cls-meta.xml
├── README.md
├── linkedinPostRequest/
│   ├── linkedinPostRequest.css
│   ├── linkedinPostRequest.html
│   ├── linkedinPostRequest.js
│   ├── linkedinPostRequest.js-meta.xml
│   └── __tests__/
│       └── linkedinPostRequest.test.js
```

## Description
This project integrates Salesforce with LinkedIn to enable seamless posting and interaction between the two platforms. It includes Apex classes and Lightning Web Components (LWC) for handling LinkedIn post requests.

## Files and Directories
- **LinkedinPostRequest.cls**: Apex class for handling LinkedIn post requests.
- **linkedinPostRequest/**: Contains the Lightning Web Component (LWC) for LinkedIn post integration.
  - **linkedinPostRequest.css**: Styles for the LWC.
  - **linkedinPostRequest.html**: Markup for the LWC.
  - **linkedinPostRequest.js**: JavaScript controller for the LWC.
  - **linkedinPostRequest.js-meta.xml**: Metadata configuration for the LWC.
  - **__tests__/linkedinPostRequest.test.js**: Unit tests for the LWC.

## Usage
1. Deploy the Apex class and LWC to your Salesforce org.
2. Configure the necessary LinkedIn API credentials.
3. Use the component to post updates to LinkedIn directly from Salesforce.