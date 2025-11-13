#!/bin/bash
# Start the Rasa Action Server

echo "Starting Rasa Action Server on port 5055..."
cd rasa_chatbot
rasa run actions
