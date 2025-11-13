#!/bin/bash
# Quick start script for the Banking Chatbot Demo

echo "================================================"
echo "Banking Chatbot with Rasa - Quick Start"
echo "================================================"
echo ""

# Check if we're in the right directory
if [ ! -f "domain.yml" ]; then
    echo "Error: Please run this script from the rasa_chatbot directory"
    exit 1
fi

echo "Step 1/4: Checking if Balance API is running..."
if curl -s http://localhost:7860/health > /dev/null 2>&1; then
    echo "✓ Balance API is running on http://localhost:7860"
else
    echo "✗ Balance API is not running!"
    echo ""
    echo "Please start the Balance API first:"
    echo "  cd ../bank_api"
    echo "  python app.py"
    echo ""
    exit 1
fi

echo ""
echo "Step 2/4: Checking for trained model..."
if [ -d "models" ] && [ "$(ls -A models)" ]; then
    echo "✓ Trained model found"
else
    echo "No trained model found. Training now..."
    rasa train
    if [ $? -ne 0 ]; then
        echo "✗ Training failed!"
        exit 1
    fi
    echo "✓ Training complete"
fi

echo ""
echo "Step 3/4: Starting Rasa Action Server..."
echo "(This will run in the background)"
rasa run actions > actions.log 2>&1 &
ACTION_PID=$!
echo "✓ Action server started (PID: $ACTION_PID)"
echo "  Logs available in: actions.log"

# Wait for action server to be ready
echo "  Waiting for action server to be ready..."
sleep 5

if ps -p $ACTION_PID > /dev/null; then
    echo "✓ Action server is running"
else
    echo "✗ Action server failed to start. Check actions.log for details."
    exit 1
fi

echo ""
echo "Step 4/4: Starting Rasa chatbot..."
echo ""
echo "================================================"
echo "Test PINs you can use:"
echo "  1234 - John Doe (USD)"
echo "  5678 - Jane Smith (EUR)"
echo "  9012 - Bob Johnson (GBP)"
echo "  3456 - Alice Williams (USD)"
echo "  7890 - Charlie Brown (CAD)"
echo "================================================"
echo ""
echo "Starting chat session..."
echo ""

# Start rasa shell
rasa shell

# Cleanup when user exits
echo ""
echo "Shutting down action server..."
kill $ACTION_PID 2>/dev/null
echo "✓ Action server stopped"
echo ""
echo "Goodbye!"
