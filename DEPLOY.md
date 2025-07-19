# Deploying Applying Pressure to Firebase Hosting

## Prerequisites
- Firebase CLI installed (`npm install -g firebase-tools`)
- Logged in to Firebase (`firebase login`)

## Steps to Deploy

1. **Ensure you're in the project directory**:
   ```bash
   cd /Users/garry/Documents/AndroidStudioProjects/applying_pressure
   ```

2. **Build the web release** (already done):
   ```bash
   flutter build web --release
   ```

3. **Deploy to Firebase Hosting**:
   ```bash
   firebase deploy --only hosting
   ```

## What This Does
- Uploads the contents of `build/web/` to Firebase Hosting
- Your app will be available at: https://applyingpressure-a0205.web.app

## After Deployment
- The deployment URL will be shown in the terminal
- You can also view hosting details in the Firebase Console

## Version Deployed
- Version: 1.1.0+2
- Build Date: July 19, 2025

## Release Notes
- Job status tracking with visual progression
- Real-time updates for all edit operations
- Improved customer-to-job workflow
- Better time formatting (24-hour)
- Cyclical status flow
- Bug fixes for null value errors