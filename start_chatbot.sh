#!/bin/bash
# Start all components for the banking chatbot

echo "================================================"
echo "Starting Banking Chatbot System"
echo "================================================"
echo ""

# Check if we're in a terminal that supports background jobs
if [ -t 0 ]; then
    echo "Starting Balance API..."
    cd bank_api
    python app.py > ../logs/api.log 2>&1 &
    API_PID=$!
    cd ..

    echo "Starting Rasa Action Server..."
    cd rasa_chatbot
    rasa run actions > ../logs/actions.log 2>&1 &
    ACTIONS_PID=$!
    cd ..

    echo ""
    echo "Waiting for services to start..."
    sleep 5

    echo ""
    echo "✅ Services started!"
    echo "  - Balance API: http://localhost:7860 (PID: $API_PID)"
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
    kill $API_PID 2>/dev/null
    kill $ACTIONS_PID 2>/dev/null
    echo "✅ Shutdown complete"
else
    echo "⚠️  This script requires an interactive terminal."
    echo ""
    echo "Please run the components in separate terminals:"
    echo "  Terminal 1: ./start_api.sh"
    echo "  Terminal 2: ./start_actions.sh"
    echo "  Terminal 3: ./start_rasa.sh"
fi
