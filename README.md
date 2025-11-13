# Conversational AI Projects

This repository contains conversational AI projects and tools, including a Rasa-based banking chatbot and a FastAPI balance checking service.

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

A complete system prompt for implementing the same banking chatbot using generative AI models (GPT-4, Claude, Gemini, etc.) with function/tool calling.

### Quick Start

```python
import openai

# Load system prompt
with open('llm_chatbot_prompt/system_prompt.txt') as f:
    system_prompt = f.read()

# Use with your LLM API
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": "Check my balance"}
    ],
    functions=[...] # Load from openai_function_definition.json
)
```

### What's Included

- **system_prompt.txt** - Complete system prompt with persona, capabilities, and guidelines
- **openai_function_definition.json** - Function definition for OpenAI/compatible models
- **anthropic_tool_definition.json** - Tool definition for Anthropic Claude
- **api_integration.md** - Complete integration guide with code examples
- **conversation_examples.md** - 8 detailed example conversations

### Features

- 🎭 Same functionality as Rasa chatbot (balance check, hours, card blocking)
- 🔧 Ready-to-use with GPT-4, Claude, Gemini, or compatible models
- 📝 No training data required - just use the prompt
- 🔗 Function calling for Balance API integration
- 📚 Comprehensive documentation and examples

### LLM vs Rasa Comparison

| Feature | LLM Prompt | Rasa |
|---------|-----------|------|
| Setup Time | Minutes | Hours |
| Training Required | No | Yes |
| Flexibility | High | Medium |
| Cost | API fees | Free (self-hosted) |
| Customization | Prompt editing | Code + data |

### Documentation

See [llm_chatbot_prompt/README.md](llm_chatbot_prompt/README.md) for complete documentation, integration examples, and usage guide.

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

To run the complete banking chatbot system:

1. **Terminal 1 - Bank API**:
   ```bash
   cd bank_api
   python app.py
   ```

2. **Terminal 2 - Rasa Actions**:
   ```bash
   cd rasa_chatbot
   rasa run actions
   ```

3. **Terminal 3 - Rasa Chatbot**:
   ```bash
   cd rasa_chatbot
   rasa shell
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
