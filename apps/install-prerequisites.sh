#!/bin/bash

# BestCity Project - Prerequisites Installation Script for Linux/Ubuntu/WSL
# This script installs all necessary prerequisites for the BestCity project

set -e  # Exit on error

echo "=========================================="
echo "BestCity Project - Prerequisites Installer"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root"
    exit 1
fi

# Update package list
print_info "Updating package list..."
sudo apt-get update -qq

# Check and install Node.js
print_info "Checking Node.js installation..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -ge 16 ]; then
        print_success "Node.js $(node -v) is already installed"
    else
        print_info "Node.js version is too old. Installing Node.js 18.x LTS..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
        print_success "Node.js $(node -v) installed"
    fi
else
    print_info "Installing Node.js 18.x LTS..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    print_success "Node.js $(node -v) installed"
fi

# Check and install npm
print_info "Checking npm installation..."
if command -v npm &> /dev/null; then
    print_success "npm $(npm -v) is already installed"
else
    print_info "Installing npm..."
    sudo apt-get install -y npm
    print_success "npm $(npm -v) installed"
fi

# Install build essentials (required for native modules like sqlite3)
print_info "Installing build essentials (required for native modules)..."
sudo apt-get install -y build-essential python3 make g++

# Check and install MongoDB
print_info "Checking MongoDB installation..."
if command -v mongod &> /dev/null; then
    print_success "MongoDB is already installed"
else
    print_info "Installing MongoDB..."
    
    # Import MongoDB public GPG key
    curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
    
    # Create MongoDB repository list file
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    
    # Update package list
    sudo apt-get update -qq
    
    # Install MongoDB
    sudo apt-get install -y mongodb-org
    
    # Start MongoDB service
    sudo systemctl start mongod 2>/dev/null || sudo service mongod start 2>/dev/null || print_info "MongoDB installed. Please start it manually with: sudo systemctl start mongod"
    
    print_success "MongoDB installed"
    print_info "To enable MongoDB on startup: sudo systemctl enable mongod"
fi

# Install Git (usually pre-installed, but checking anyway)
print_info "Checking Git installation..."
if command -v git &> /dev/null; then
    print_success "Git $(git --version | cut -d' ' -f3) is already installed"
else
    print_info "Installing Git..."
    sudo apt-get install -y git
    print_success "Git installed"
fi

# Install additional utilities
print_info "Installing additional utilities..."
sudo apt-get install -y curl wget

# Install project dependencies
print_info "Installing project dependencies..."
if [ -f "package.json" ]; then
    npm install
    print_success "Project dependencies installed"
else
    print_error "package.json not found. Please run this script from the project root directory."
    exit 1
fi

# Setup environment file
print_info "Setting up environment configuration..."
if [ ! -f "server/config/config.env" ]; then
    if [ -f "server/config/config.env.example" ]; then
        cp server/config/config.env.example server/config/config.env
        print_success "Created server/config/config.env from example"
        print_info "Please update server/config/config.env with your actual configuration values"
    else
        print_error "config.env.example not found"
    fi
else
    print_info "config.env already exists, skipping..."
fi

echo ""
echo "=========================================="
print_success "Prerequisites installation completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update server/config/config.env with your configuration"
echo "2. Ensure MongoDB is running: sudo systemctl start mongod"
echo "3. Start the development server: npm start"
echo ""
echo "Required environment variables to configure:"
echo "  - MONGO_URI (MongoDB connection string)"
echo "  - JWT_SECRET (Secret key for JWT tokens)"
echo "  - CLOUDINARY_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET"
echo "  - SENDGRID_API_KEY (for email functionality)"
echo "  - PAYTM credentials (for payment processing)"
echo ""

