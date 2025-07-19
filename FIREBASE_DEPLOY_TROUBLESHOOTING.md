# Firebase Deployment Troubleshooting

## Issue
Getting error: "Failed to get Firebase project applyingpressure-a0205. Please make sure the project exists and your account has permission to access it."

## Solutions to Try

### 1. Re-authenticate with Firebase
```bash
firebase logout
firebase login
```
This will open a browser window for authentication.

### 2. Check if you're using the right Google account
Make sure you're logged in with the account that has access to the Firebase project.

### 3. List your projects to verify access
```bash
firebase projects:list
```

### 4. Try setting the project explicitly
```bash
firebase use --add
# Select your project from the list
```

### 5. If the above doesn't work, try:
```bash
# Remove the .firebaserc file temporarily
mv .firebaserc .firebaserc.backup

# Re-initialize Firebase
firebase init hosting

# When prompted:
# - Choose "Use an existing project"
# - Select "applyingpressure-a0205"
# - Keep "build/web" as the public directory
# - Configure as single-page app: Yes
# - Don't overwrite index.html

# Then deploy
firebase deploy --only hosting
```

### 6. Alternative: Deploy using Firebase Console
If command line doesn't work:
1. Go to https://console.firebase.google.com
2. Select your project
3. Go to Hosting
4. Click "Get started" or find the manual upload option
5. Upload the contents of `build/web/`

### 7. Check Project Permissions
1. Go to https://console.firebase.google.com
2. Select the project
3. Go to Project Settings > Users and permissions
4. Verify your email has the necessary permissions

## Your Web Build is Ready
The release build is in `build/web/` and ready to deploy once the authentication issue is resolved.