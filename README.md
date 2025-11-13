# Conversational AI Projects

This repository contains conversational AI projects and tools, including a Rasa-based banking chatbot and a FastAPI balance checking service.

## 🚀 Quick Start with GitHub Codespaces

**The easiest way to run this project:**

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new)

1. Deploy the Balance API to Hugging Face Spaces (see `bank_api/`)
2. Click "Code" → "Create codespace"
3. Wait for setup to complete (5-10 minutes)
4. Edit `.env` and set your HF Spaces URL
5. Run: `./start_chatbot.sh`
6. Start chatting!

Everything is pre-configured and ready to use. See [CODESPACES.md](CODESPACES.md) for detailed instructions.

## 📋 Project Structure

```
conv_ai/
├── bank_api/              # Bank Balance API (FastAPI)
├── rasa_chatbot/          # Rasa Banking Chatbot
├── llm_chatbot_prompt/    # LLM/Generative AI System Prompt
└── Conversational_AI.ipynb
```

## 🤖 Rasa Banking Chatbot

A simple demonstration chatbot built with Rasa that can check bank account balances through natural conversation. The chatbot queries the Bank Balance API using custom actions.

### Quick Start

**Option 1: GitHub Codespaces (Easiest)**

```bash
# Everything is auto-installed!
./start_chatbot.sh
```

See [CODESPACES.md](CODESPACES.md) for details.

**Option 2: Local Setup**

```bash
# 1. Install Rasa and dependencies
cd rasa_chatbot
pip install -r requirements.txt
pip install -r actions/requirements-actions.txt

# 2. Train the model
rasa train

# 3. Start the Balance API (in a separate terminal)
cd ../bank_api
python app.py

# 4. Start the action server (in another terminal)
cd rasa_chatbot
rasa run actions

# 5. Chat with the bot
rasa shell
```

### Example Conversation

```
You: hello
Bot: Hello! I'm your banking assistant. How can I help you today?

You: check my balance
Bot: Please provide your 4-digit PIN number to check your balance.

You: 1234
Bot: Account holder: John Doe
     Your current balance is: 15420.50 USD

You: goodbye
Bot: Goodbye! Have a great day!
```

### Features

- 🗣️ Natural language understanding with Rasa NLU
- 🔢 PIN number entity extraction
- 🔗 Custom action integration with Balance API
- 📝 Simple intents: greet, goodbye, check_balance, provide_pin, ask_opening_hours, block_card
- 🎯 Rules and stories for consistent responses
- ⏰ Bank opening hours information
- 🔒 Card blocking functionality
- ⚠️ Error handling for invalid PINs and connection issues

### Documentation

See [rasa_chatbot/README.md](rasa_chatbot/README.md) for detailed setup instructions, conversation flows, and development guide.

---

## 🤖 LLM Chatbot System Prompt

A ready-to-use system prompt for creating the same banking chatbot using ChatGPT Custom GPTs or other LLM platforms.

### Quick Start

1. Open the file: `llm_chatbot_prompt/system_prompt.txt`
2. Copy the entire contents
3. Paste into your ChatGPT GPT instructions or LLM system prompt
4. Configure the action/tool for the Balance API

That's it! No coding or training required.

### What's Included

- **system_prompt.txt** - Complete instructions for the chatbot
- **README.md** - Step-by-step guide for setting up with ChatGPT GPTs

### Features

- 🎭 Same functionality as Rasa chatbot
- 📋 Just copy and paste - no coding needed
- 🔧 Works with ChatGPT Custom GPTs
- ⚡ Quick setup (minutes, not hours)
- 🔗 Includes API action configuration for balance checking

### Perfect For

- ChatGPT Custom GPTs
- Claude Projects
- Quick prototyping
- Non-technical users

### Documentation

See [llm_chatbot_prompt/README.md](llm_chatbot_prompt/README.md) for complete setup instructions with ChatGPT GPTs.

---

## 🏦 Bank Balance API

A FastAPI-based service that provides account balance information. Used by the Rasa chatbot to retrieve balance data.

### Quick Start

```bash
cd bank_api
pip install -r requirements.txt
python app.py
```

Access the API at `http://localhost:7860` and view docs at `http://localhost:7860/docs`

### API Endpoints

- `POST /api/balance` - Check balance with PIN (recommended)
- `GET /api/balance/{pin}` - Check balance via GET (demo only)
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation

### Test Accounts

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

### Features

- ✅ PIN-based authentication
- ✅ Multiple currency support (USD, EUR, GBP, CAD)
- ✅ RESTful API with proper error handling
- ✅ Interactive API documentation (Swagger UI)
- ✅ Ready for Hugging Face Spaces deployment

### Documentation

See [bank_api/README_API.md](bank_api/README_API.md) for detailed API documentation and deployment instructions.

---

## 🚀 Complete System Setup

**Easy Way (Codespaces or after setup):**
```bash
./start_chatbot.sh  # Starts everything automatically
```

**Manual Way (3 separate terminals):**

1. **Terminal 1 - Bank API**:
   ```bash
   ./start_api.sh
   ```

2. **Terminal 2 - Rasa Actions**:
   ```bash
   ./start_actions.sh
   ```

3. **Terminal 3 - Rasa Chatbot**:
   ```bash
   ./start_rasa.sh
   ```

## 📚 Additional Resources

- [Conversational_AI.ipynb](Conversational_AI.ipynb) - Jupyter notebook with conversational AI examples
- [rasa_chatbot/README.md](rasa_chatbot/README.md) - Detailed Rasa chatbot documentation
- [llm_chatbot_prompt/README.md](llm_chatbot_prompt/README.md) - LLM system prompt and integration guide
- [bank_api/README_API.md](bank_api/README_API.md) - API documentation and usage examples

## 🎯 Use Cases

- **Learning Rasa**: Simple example of Rasa chatbot with custom actions
- **API Integration**: Demonstrates how to integrate external APIs with Rasa
- **Chatbot Testing**: Ready-to-use chatbot for testing conversational AI flows
- **Function Calling**: Example for LLM function calling patterns

## ⚠️ Security Notice

This is a **demonstration application for educational purposes only**. Do not use with real financial data or in production environments without implementing proper security measures including:

- Encrypted PIN storage
- OAuth2/JWT authentication
- Rate limiting
- HTTPS only
- Audit logging
- Multi-factor authentication
