#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Push Frontend to GitHub ===${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    echo "Please run this script from the project root directory."
    exit 1
fi

# Check if there are any commits
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    echo -e "${RED}❌ Error: No commits found${NC}"
    echo "Please make sure you have committed your changes."
    exit 1
fi

echo -e "${YELLOW}📋 Instructions to create GitHub repository:${NC}"
echo ""
echo "1. Go to https://github.com/new"
echo "2. Repository name: ${BLUE}serverless-user-frontend${NC}"
echo "3. Description: ${BLUE}React frontend for Serverless User API with AWS Amplify deployment${NC}"
echo "4. Set to ${BLUE}Public${NC} (so Amplify can access it)"
echo "5. ${YELLOW}DO NOT${NC} initialize with README, .gitignore, or license (we already have them)"
echo "6. Click ${GREEN}Create repository${NC}"
echo ""

read -p "Have you created the GitHub repository? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Please create the GitHub repository first, then run this script again.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Enter your GitHub repository URL:${NC}"
echo "Format: https://github.com/YOUR_USERNAME/serverless-user-frontend.git"
read -p "Repository URL: " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}❌ Error: Repository URL cannot be empty${NC}"
    exit 1
fi

# Validate URL format
if [[ ! $REPO_URL =~ ^https://github\.com/.+/.+\.git$ ]]; then
    echo -e "${RED}❌ Error: Invalid GitHub repository URL format${NC}"
    echo "Expected format: https://github.com/USERNAME/REPOSITORY.git"
    exit 1
fi

echo ""
echo -e "${YELLOW}Adding remote origin...${NC}"

# Remove existing origin if it exists
git remote remove origin 2>/dev/null || true

# Add new origin
git remote add origin "$REPO_URL"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error: Failed to add remote origin${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Remote origin added successfully${NC}"
echo ""

echo -e "${YELLOW}Pushing to GitHub...${NC}"

# Push to GitHub
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Successfully pushed to GitHub!${NC}"
    echo ""
    echo -e "${BLUE}Repository URL: $REPO_URL${NC}"
    echo -e "${BLUE}Web URL: ${REPO_URL%.git}${NC}"
    echo ""
    
    echo -e "${YELLOW}=== Next Steps for AWS Amplify ===${NC}"
    echo ""
    echo "1. ${GREEN}Open AWS Amplify Console${NC}"
    echo "   https://console.aws.amazon.com/amplify/"
    echo ""
    echo "2. ${GREEN}Click 'New app' → 'Host web app'${NC}"
    echo ""
    echo "3. ${GREEN}Select GitHub as source${NC}"
    echo ""
    echo "4. ${GREEN}Authorize AWS Amplify to access your GitHub${NC}"
    echo ""
    echo "5. ${GREEN}Select repository: serverless-user-frontend${NC}"
    echo ""
    echo "6. ${GREEN}Select branch: main${NC}"
    echo ""
    echo "7. ${GREEN}Configure build settings (amplify.yml will be auto-detected)${NC}"
    echo ""
    echo "8. ${GREEN}Add environment variables:${NC}"
    echo "   - REACT_APP_API_URL: (your backend API URL)"
    echo "   - REACT_APP_NAME: Serverless User Management"
    echo "   - REACT_APP_VERSION: 1.0.0"
    echo ""
    echo "9. ${GREEN}Deploy and test!${NC}"
    echo ""
    
    echo -e "${BLUE}📚 For detailed instructions, see: AMPLIFY-SETUP.md${NC}"
    
else
    echo ""
    echo -e "${RED}❌ Failed to push to GitHub${NC}"
    echo ""
    echo -e "${YELLOW}Common solutions:${NC}"
    echo "1. Check if the repository URL is correct"
    echo "2. Make sure you have push access to the repository"
    echo "3. Check your GitHub authentication (token/SSH key)"
    echo "4. Try: git push origin main --force (if needed)"
    exit 1
fi
