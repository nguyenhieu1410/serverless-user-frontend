#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Update API URL for Frontend ===${NC}"
echo ""

# Check if backend API is deployed
API_URL=$(aws cloudformation describe-stacks \
    --stack-name serverless-user-api \
    --region us-east-1 \
    --query 'Stacks[0].Outputs[?OutputKey==`UserApi`].OutputValue' \
    --output text 2>/dev/null)

if [ -z "$API_URL" ]; then
    echo -e "${RED}❌ Error: Backend API not found${NC}"
    echo ""
    echo -e "${YELLOW}Please deploy the backend API first:${NC}"
    echo "1. Go to serverless-user-api directory"
    echo "2. Run: ./cloudshell-deploy.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Backend API found!${NC}"
echo -e "${BLUE}API URL: $API_URL${NC}"
echo ""

# Update .env file
echo -e "${YELLOW}Updating .env file...${NC}"

# Create or update .env file
cat > .env << EOF
# API Configuration
REACT_APP_API_URL=$API_URL

# App Configuration
REACT_APP_NAME=Serverless User Management
REACT_APP_VERSION=1.0.0

# Development Configuration
GENERATE_SOURCEMAP=false
SKIP_PREFLIGHT_CHECK=true
EOF

echo -e "${GREEN}✅ .env file updated successfully!${NC}"
echo ""

# Test API connection
echo -e "${YELLOW}Testing API connection...${NC}"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/users")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ API is responding correctly${NC}"
else
    echo -e "${YELLOW}⚠️  API returned status code: $HTTP_STATUS${NC}"
    echo "This might be normal if there are no users yet."
fi

echo ""
echo -e "${BLUE}=== Next Steps ===${NC}"
echo ""
echo -e "${YELLOW}1. Start development server:${NC}"
echo "   npm start"
echo ""
echo -e "${YELLOW}2. Or build for production:${NC}"
echo "   npm run build"
echo ""
echo -e "${YELLOW}3. Deploy to Amplify:${NC}"
echo "   - Push to GitHub"
echo "   - Amplify will auto-deploy"
echo ""

echo -e "${GREEN}=== Configuration Complete! ===${NC}"
