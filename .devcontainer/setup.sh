#!/bin/bash
# Setup script for Codespaces - installs all dependencies

echo "================================================"
echo "Setting up Banking Chatbot Development Environment"
echo "================================================"
echo ""

# Create .env file from example if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env configuration file..."
    cp .env.example .env
    echo "⚠️  Please edit .env and set your Hugging Face Spaces API URL!"
fi

# Install Rasa and action server dependencies
echo "📦 Installing Rasa..."
pip install --quiet -r rasa_chatbot/requirements.txt

echo "📦 Installing Rasa action server dependencies..."
pip install --quiet -r rasa_chatbot/actions/requirements-actions.txt

# Train the Rasa model
echo "🎓 Training Rasa model (this may take a few minutes)..."
cd rasa_chatbot
rasa train --quiet
cd ..

echo ""
echo "================================================"
echo "✅ Setup complete!"
echo "================================================"
echo ""
echo "⚠️  IMPORTANT: Configure your Balance API URL"
echo ""
echo "1. Edit the .env file:"
echo "   - Set BALANCE_API_URL to your Hugging Face Spaces URL"
echo "   - Example: BALANCE_API_URL=https://your-username-balance-api.hf.space"
echo ""
echo "2. Run the chatbot:"
echo "   ./start_chatbot.sh"
echo ""
echo "Or run components individually:"
echo "  ./start_actions.sh   - Start Rasa Actions (port 5055)"
echo "  ./start_rasa.sh      - Start Rasa chatbot"
echo ""
