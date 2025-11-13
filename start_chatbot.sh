#!/bin/bash
# Start all components for the banking chatbot

echo "================================================"
echo "Starting Banking Chatbot System"
echo "================================================"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  ERROR: .env file not found!"
    echo ""
    echo "Please create a .env file with your Balance API URL:"
    echo "  cp .env.example .env"
    echo "  # Then edit .env and set BALANCE_API_URL"
    echo ""
    exit 1
fi

# Check if API URL is configured
if grep -q "localhost:7860" .env; then
    echo "⚠️  WARNING: Balance API URL is set to localhost"
    echo "   Make sure to update .env with your HF Spaces URL"
    echo ""
fi

# Check if we're in a terminal that supports background jobs
if [ -t 0 ]; then
    echo "Starting Rasa Action Server..."
    cd rasa_chatbot
    rasa run actions > ../logs/actions.log 2>&1 &
    ACTIONS_PID=$!
    cd ..

    echo ""
    echo "Waiting for action server to start..."
    sleep 5

    echo ""
    echo "✅ Service started!"
    echo "  - Rasa Actions: http://localhost:5055 (PID: $ACTIONS_PID)"
    echo ""
    echo "Logs available in logs/ directory"
    echo ""
    echo "Test PINs:"
    echo "  1234 - John Doe (USD)"
    echo "  5678 - Jane Smith (EUR)"
    echo "  9012 - Bob Johnson (GBP)"
    echo ""
    echo "Starting Rasa chatbot..."
    echo ""

    cd rasa_chatbot
    rasa shell

    # Cleanup on exit
    echo ""
    echo "Shutting down services..."
    kill $ACTIONS_PID 2>/dev/null
    echo "✅ Shutdown complete"
else
    echo "⚠️  This script requires an interactive terminal."
    echo ""
    echo "Please run the components in separate terminals:"
    echo "  Terminal 1: ./start_actions.sh"
    echo "  Terminal 2: ./start_rasa.sh"
fi
