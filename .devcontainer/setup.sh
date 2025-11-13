#!/bin/bash
# Setup script for Codespaces - installs all dependencies

echo "================================================"
echo "Setting up Banking Chatbot Development Environment"
echo "================================================"
echo ""

# Install Balance API dependencies
echo "📦 Installing Balance API dependencies..."
pip install --quiet -r bank_api/requirements.txt

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
echo "To run the banking chatbot:"
echo "  ./start_chatbot.sh"
echo ""
echo "Or run components individually:"
echo "  ./start_api.sh       - Start Balance API (port 7860)"
echo "  ./start_actions.sh   - Start Rasa Actions (port 5055)"
echo "  ./start_rasa.sh      - Start Rasa chatbot"
echo ""
