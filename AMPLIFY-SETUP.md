# 🚀 AWS Amplify Setup Guide

Hướng dẫn chi tiết để deploy React frontend lên AWS Amplify với CI/CD và custom domain.

## 📋 **Prerequisites**

- ✅ AWS Account với quyền truy cập Amplify
- ✅ GitHub account và repository
- ✅ Backend API đã được deploy (serverless-user-api)
- ✅ Custom domain đã mua trên Route53 (optional)

## 🎯 **Step 1: Chuẩn bị Repository**

### 1.1 Push code lên GitHub

```bash
# Add all files
git add .

# Commit
git commit -m "Initial commit: React frontend for Serverless User API

- Add React components for user management
- Add responsive design with modern UI
- Add API integration with error handling
- Add Amplify configuration files
- Ready for Amplify deployment"

# Add remote origin (replace with your GitHub repo)
git remote add origin https://github.com/YOUR_USERNAME/serverless-user-frontend.git

# Push to GitHub
git push -u origin main
```

### 1.2 Verify Repository Structure

Đảm bảo repository có cấu trúc như sau:

```
serverless-user-frontend/
├── public/
│   ├── index.html
│   └── _redirects
├── src/
│   ├── components/
│   │   ├── CreateUser.js
│   │   └── UserList.js
│   ├── App.js
│   ├── App.css
│   ├── index.js
│   └── index.css
├── amplify.yml
├── package.json
├── .env.example
└── README.md
```

## 🌐 **Step 2: Setup AWS Amplify**

### 2.1 Mở Amplify Console

1. **Đăng nhập AWS Console**
2. **Tìm service "AWS Amplify"**
3. **Click "Get started" → "Host your web app"**

### 2.2 Connect Repository

1. **Select Git provider**: GitHub
2. **Authorize AWS Amplify**: Click "Authorize aws-amplify-console"
3. **Select repository**: `serverless-user-frontend`
4. **Select branch**: `main`
5. **Click "Next"**

### 2.3 Configure Build Settings

Amplify sẽ tự động detect `amplify.yml`. Verify configuration:

```yaml
version: 1
applications:
  - frontend:
      phases:
        preBuild:
          commands:
            - echo "Installing dependencies..."
            - npm ci
        build:
          commands:
            - echo "Building React application..."
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
    appRoot: /
```

**Click "Next"**

### 2.4 Review và Deploy

1. **App name**: `serverless-user-frontend`
2. **Environment name**: `main`
3. **Review settings**
4. **Click "Save and deploy"**

## ⚙️ **Step 3: Configure Environment Variables**

### 3.1 Get Backend API URL

```bash
# Trong backend directory
cd ../serverless-user-api
./get-api-url.sh
```

Copy API URL (ví dụ: `https://abc123def4.execute-api.us-east-1.amazonaws.com/dev`)

### 3.2 Add Environment Variables

1. **Trong Amplify Console** → **App settings** → **Environment variables**
2. **Add variables**:

| Key | Value |
|-----|-------|
| `REACT_APP_API_URL` | `https://your-api-id.execute-api.us-east-1.amazonaws.com/dev` |
| `REACT_APP_NAME` | `Serverless User Management` |
| `REACT_APP_VERSION` | `1.0.0` |

3. **Click "Save"**

### 3.3 Redeploy với Environment Variables

1. **Amplify Console** → **Main branch**
2. **Click "Redeploy this version"**

## 🌍 **Step 4: Setup Custom Domain (Optional)**

### 4.1 Prerequisites

- Domain đã mua trên Route53 (ví dụ: `yourdomain.xyz`)
- Domain đã được verify trong Route53

### 4.2 Add Custom Domain

1. **Amplify Console** → **Domain management**
2. **Click "Add domain"**
3. **Enter domain**: `yourdomain.xyz`
4. **Configure subdomains**:
   - `yourdomain.xyz` → `main` branch
   - `www.yourdomain.xyz` → `main` branch (optional)

### 4.3 DNS Configuration

Amplify sẽ cung cấp CNAME records:

```
Type: CNAME
Name: yourdomain.xyz
Value: d1234567890.cloudfront.net
```

**Cập nhật trong Route53**:

1. **Route53 Console** → **Hosted zones**
2. **Select your domain**
3. **Create record**:
   - **Record type**: CNAME
   - **Record name**: (empty for root domain)
   - **Value**: (Amplify CNAME value)
4. **Save**

### 4.4 SSL Certificate

- Amplify tự động tạo SSL certificate
- Quá trình verification có thể mất 24-48 giờ
- Certificate sẽ auto-renew

## 🔄 **Step 5: Setup CI/CD**

### 5.1 Automatic Deployments

CI/CD đã được setup tự động:

```
GitHub Push → Amplify Build → Deploy → Live Update
```

### 5.2 Build Process

Mỗi khi push code:

1. **Trigger**: Git push to `main` branch
2. **Provision**: Amplify tạo build environment
3. **Build**: Chạy `amplify.yml` commands
4. **Deploy**: Update live application
5. **Notify**: Email notification (optional)

### 5.3 Branch Strategy

- **`main`** → Production (yourdomain.xyz)
- **`develop`** → Staging (develop.yourdomain.xyz) - optional
- **Feature branches** → Preview URLs - optional

## 🧪 **Step 6: Testing**

### 6.1 Test Deployment

1. **Open Amplify URL**: `https://main.d1234567890.amplifyapp.com`
2. **Test functionality**:
   - Create user form
   - User list display
   - API connectivity
   - Responsive design

### 6.2 Test Custom Domain

1. **Open custom domain**: `https://yourdomain.xyz`
2. **Verify SSL certificate**: Green lock icon
3. **Test all functionality**

### 6.3 Test CI/CD

1. **Make a small change** (e.g., update title)
2. **Commit and push**:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. **Watch Amplify Console** for build progress
4. **Verify changes** on live site

## 📊 **Step 7: Monitoring và Analytics**

### 7.1 Amplify Metrics

**Amplify Console** → **Monitoring**:

- **Build success rate**
- **Build duration**
- **Deploy frequency**
- **Error rates**

### 7.2 CloudWatch Integration

- **Custom metrics** for API calls
- **Error tracking**
- **Performance monitoring**

### 7.3 Real User Monitoring

Add to `src/App.js`:

```javascript
// Track page views
useEffect(() => {
  // Add your analytics code here
  console.log('Page loaded:', window.location.href);
}, []);
```

## 🔒 **Step 8: Security Configuration**

### 8.1 HTTPS Enforcement

- **Amplify** tự động redirect HTTP → HTTPS
- **HSTS headers** được enable mặc định

### 8.2 CORS Configuration

Verify backend CORS includes Amplify domain:

```yaml
# In backend template.yaml
Cors:
  AllowOrigin: "'*'"  # Or specific domains
  AllowMethods: "'GET,POST,OPTIONS'"
  AllowHeaders: "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
```

### 8.3 Content Security Policy

Add to `public/index.html`:

```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; 
               script-src 'self' 'unsafe-inline'; 
               style-src 'self' 'unsafe-inline'; 
               connect-src 'self' https://*.execute-api.us-east-1.amazonaws.com;">
```

## 🐛 **Troubleshooting**

### Common Issues

#### 1. **Build Failures**

```
Error: npm ERR! code ELIFECYCLE
```

**Solutions**:
- Check `package.json` dependencies
- Verify `amplify.yml` syntax
- Check build logs in Amplify Console

#### 2. **API Connection Issues**

```
Failed to fetch users. Please check if the API is running.
```

**Solutions**:
- Verify `REACT_APP_API_URL` environment variable
- Check backend API is deployed
- Verify CORS configuration

#### 3. **Domain Issues**

```
This site can't be reached
```

**Solutions**:
- Check DNS propagation (can take 24-48 hours)
- Verify CNAME records in Route53
- Check SSL certificate status

#### 4. **Environment Variables Not Working**

**Solutions**:
- Ensure variables start with `REACT_APP_`
- Redeploy after adding variables
- Check variables in Amplify Console

### Debug Steps

1. **Check Amplify Console** → **Build logs**
2. **Check Browser DevTools** → **Console** for errors
3. **Check Network Tab** for API calls
4. **Verify Environment Variables** in build logs

## 📈 **Performance Optimization**

### 1. **Build Optimization**

```json
// package.json
{
  "scripts": {
    "build": "GENERATE_SOURCEMAP=false react-scripts build"
  }
}
```

### 2. **Caching Strategy**

Amplify automatically configures:
- **Static assets**: 1 year cache
- **HTML files**: No cache
- **Service worker**: For offline support

### 3. **Bundle Analysis**

```bash
# Analyze bundle size
npm install -g webpack-bundle-analyzer
npx webpack-bundle-analyzer build/static/js/*.js
```

## 🎯 **Best Practices**

### 1. **Environment Management**

- Use different environments for different branches
- Keep sensitive data in environment variables
- Use `.env.example` for documentation

### 2. **Code Quality**

- Add ESLint configuration
- Add Prettier for code formatting
- Add pre-commit hooks

### 3. **Monitoring**

- Set up CloudWatch alarms
- Monitor build success rates
- Track user engagement

### 4. **Security**

- Regular dependency updates
- Security headers configuration
- Input validation and sanitization

## 🚀 **Next Steps**

After successful deployment:

- [ ] **Test all functionality** thoroughly
- [ ] **Set up monitoring** and alerts
- [ ] **Configure backup strategy**
- [ ] **Add more features** (user editing, deletion, etc.)
- [ ] **Implement analytics** tracking
- [ ] **Add unit tests** and E2E tests
- [ ] **Set up staging environment**
- [ ] **Document API integration**

## 📞 **Support**

If you encounter issues:

1. **Check AWS Amplify Documentation**
2. **Review build logs** in Amplify Console
3. **Check GitHub Issues** for similar problems
4. **Contact AWS Support** for infrastructure issues

---

**🎉 Congratulations!** Your React frontend is now deployed with AWS Amplify, complete with CI/CD pipeline and custom domain!
