#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Amplify Issues Troubleshooting ===${NC}"
echo ""

echo -e "${YELLOW}🔍 Checking common Amplify issues...${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found${NC}"
    echo "Please run this script from the React project root directory."
    exit 1
fi

# Check amplify.yml
echo -e "${BLUE}1. Checking amplify.yml configuration...${NC}"
if [ -f "amplify.yml" ]; then
    echo -e "${GREEN}✅ amplify.yml exists${NC}"
    
    # Check for common issues
    if grep -q "appRoot:" amplify.yml; then
        echo -e "${YELLOW}⚠️  Found appRoot in amplify.yml - this might cause issues${NC}"
        echo -e "${YELLOW}   Creating fixed version...${NC}"
        
        # Create fixed version
        cat > amplify-fixed.yml << 'EOF'
version: 1
frontend:
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
EOF
        
        echo -e "${GREEN}✅ Created amplify-fixed.yml${NC}"
        echo -e "${YELLOW}   Replace amplify.yml content with amplify-fixed.yml content${NC}"
    else
        echo -e "${GREEN}✅ amplify.yml looks good${NC}"
    fi
else
    echo -e "${RED}❌ amplify.yml not found${NC}"
    echo -e "${YELLOW}   Creating amplify.yml...${NC}"
    
    cat > amplify.yml << 'EOF'
version: 1
frontend:
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
EOF
    
    echo -e "${GREEN}✅ Created amplify.yml${NC}"
fi

echo ""

# Check package.json
echo -e "${BLUE}2. Checking package.json...${NC}"
if [ -f "package.json" ]; then
    echo -e "${GREEN}✅ package.json exists${NC}"
    
    # Check for required scripts
    if grep -q '"build"' package.json; then
        echo -e "${GREEN}✅ Build script found${NC}"
    else
        echo -e "${RED}❌ Build script not found in package.json${NC}"
    fi
    
    # Check for React dependencies
    if grep -q '"react"' package.json; then
        echo -e "${GREEN}✅ React dependency found${NC}"
    else
        echo -e "${RED}❌ React dependency not found${NC}"
    fi
else
    echo -e "${RED}❌ package.json not found${NC}"
fi

echo ""

# Check build directory
echo -e "${BLUE}3. Testing local build...${NC}"
if [ -d "build" ]; then
    echo -e "${YELLOW}⚠️  Build directory exists, removing for clean build...${NC}"
    rm -rf build
fi

echo -e "${YELLOW}Running npm run build...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Local build successful${NC}"
    
    if [ -d "build" ]; then
        echo -e "${GREEN}✅ Build directory created${NC}"
        
        # Check build contents
        BUILD_SIZE=$(du -sh build | cut -f1)
        echo -e "${BLUE}   Build size: $BUILD_SIZE${NC}"
        
        if [ -f "build/index.html" ]; then
            echo -e "${GREEN}✅ index.html found in build${NC}"
        else
            echo -e "${RED}❌ index.html not found in build${NC}"
        fi
        
        if [ -d "build/static" ]; then
            echo -e "${GREEN}✅ Static assets found${NC}"
        else
            echo -e "${YELLOW}⚠️  No static assets directory${NC}"
        fi
    else
        echo -e "${RED}❌ Build directory not created${NC}"
    fi
else
    echo -e "${RED}❌ Local build failed${NC}"
    echo -e "${YELLOW}   Check the error messages above${NC}"
fi

echo ""

# Check environment variables
echo -e "${BLUE}4. Checking environment variables...${NC}"
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
    
    if grep -q "REACT_APP_" .env; then
        echo -e "${GREEN}✅ REACT_APP_ variables found${NC}"
        echo -e "${BLUE}   Environment variables:${NC}"
        grep "REACT_APP_" .env | sed 's/^/   /'
    else
        echo -e "${YELLOW}⚠️  No REACT_APP_ variables found${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  .env file not found${NC}"
    echo -e "${YELLOW}   You'll need to set environment variables in Amplify Console${NC}"
fi

echo ""

# Check _redirects file
echo -e "${BLUE}5. Checking SPA routing configuration...${NC}"
if [ -f "public/_redirects" ]; then
    echo -e "${GREEN}✅ _redirects file exists${NC}"
    echo -e "${BLUE}   Content:${NC}"
    cat public/_redirects | sed 's/^/   /'
else
    echo -e "${YELLOW}⚠️  _redirects file not found${NC}"
    echo -e "${YELLOW}   Creating _redirects for SPA routing...${NC}"
    
    mkdir -p public
    echo "/*    /index.html   200" > public/_redirects
    
    echo -e "${GREEN}✅ Created public/_redirects${NC}"
fi

echo ""

# Summary and recommendations
echo -e "${GREEN}=== Summary and Recommendations ===${NC}"
echo ""

echo -e "${YELLOW}📋 Common Amplify Issues and Solutions:${NC}"
echo ""

echo -e "${BLUE}1. appRoot Error:${NC}"
echo "   - Remove 'appRoot' from amplify.yml"
echo "   - Use simple frontend configuration"
echo ""

echo -e "${BLUE}2. Build Failures:${NC}"
echo "   - Ensure 'npm ci' is used instead of 'npm install'"
echo "   - Check that all dependencies are in package.json"
echo "   - Verify build script exists and works locally"
echo ""

echo -e "${BLUE}3. Environment Variables:${NC}"
echo "   - Add REACT_APP_* variables in Amplify Console"
echo "   - Don't include .env in Git (it's in .gitignore)"
echo ""

echo -e "${BLUE}4. SPA Routing:${NC}"
echo "   - Ensure _redirects file exists in public/"
echo "   - Content should be: /*    /index.html   200"
echo ""

echo -e "${YELLOW}🔧 Next Steps:${NC}"
echo ""
echo "1. ${GREEN}Update amplify.yml${NC} with the fixed configuration"
echo "2. ${GREEN}Commit and push${NC} the changes:"
echo "   git add ."
echo "   git commit -m 'Fix Amplify configuration'"
echo "   git push origin main"
echo ""
echo "3. ${GREEN}In Amplify Console${NC}:"
echo "   - Go to App Settings → Build settings"
echo "   - Verify the amplify.yml is detected"
echo "   - Add environment variables if needed"
echo "   - Trigger a new build"
echo ""

echo -e "${GREEN}=== Troubleshooting Complete ===${NC}"
