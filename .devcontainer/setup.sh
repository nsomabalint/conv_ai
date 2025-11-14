#!/bin/bash
# Setup script for Codespaces - installs all dependencies

echo "================================================"
echo "Setting up Banking Chatbot Development Environment"
echo "================================================"
echo ""

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
echo "Run the chatbot:"
echo "  ./start_chatbot.sh"
echo ""
echo "Or run components individually:"
echo "  ./start_actions.sh   - Start Rasa Actions (port 5055)"
echo "  ./start_rasa.sh      - Start Rasa chatbot"
echo ""
