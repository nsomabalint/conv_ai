#!/bin/bash
# Start the Rasa chatbot in shell mode

echo "Starting Rasa chatbot..."
echo ""
echo "Test PINs:"
echo "  1234 - John Doe (USD)"
echo "  5678 - Jane Smith (EUR)"
echo "  9012 - Bob Johnson (GBP)"
echo ""
cd rasa_chatbot
rasa shell
