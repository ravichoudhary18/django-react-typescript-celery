#!/bin/bash

# Exit if any command fails
set -e

echo "Setting up environment files..."

# Backend .env
if [ -f ".env.example" ]; then
    if [ ! -f ".env.dev" ]; then
        cp .env.example .env.dev
        echo "Backend .env.dev created from .env.example"
    else
        echo "Backend .env.dev already exists, skipping copy."
    fi
else
    echo ".env.example not found in backend!"
fi

# Frontend .env
if [ -f "frontend/.env.example" ]; then
    if [ ! -f "frontend/.env.dev" ]; then
        cp frontend/.env.example frontend/.env.dev
        echo "Frontend .env.dev created from frontend/.env.example"
    else
        echo "Frontend .env.dev already exists, skipping copy."
    fi
else
    echo "frontend/.env.example not found!"
fi

# Redis config
echo "Setting up Redis configuration..."
if [ -f "redis.conf.example" ]; then
    if [ ! -f "redis.conf" ]; then
        cp redis.conf.example redis.conf
        echo "redis.conf created from redis.conf.example"
    else
        echo "redis.conf already exists, skipping copy."
    fi
else
    echo "redis.conf.example not found!"
fi

# Backend virtual environment
echo "🔧 Setting up Python virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "Virtual environment created at .venv"
else
    echo "Virtual environment already exists, skipping creation."
fi

# Install backend requirements
if [ -f "backend/requirements.txt" ]; then
    source .venv/bin/activate
    pip install --upgrade pip
    pip install -r backend/requirements.txt
    deactivate
    echo "Dependencies installed from backend/requirements.txt"
else
    echo "backend/requirements.txt not found!"
fi

echo "Setup complete!"
