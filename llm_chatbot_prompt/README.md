# LLM Banking Chatbot System Prompt

This folder contains everything you need to implement a banking chatbot using generative AI models (like GPT-4, Claude, Gemini, etc.) with function/tool calling capabilities.

## 📁 Contents

### Core Files

- **`system_prompt.txt`** - The main system prompt defining the chatbot's personality, capabilities, and behavior guidelines
- **`openai_function_definition.json`** - Function definition for OpenAI/compatible models
- **`anthropic_tool_definition.json`** - Tool definition for Anthropic Claude models
- **`api_integration.md`** - Complete guide for integrating with the Balance API, including code examples
- **`conversation_examples.md`** - 8 detailed conversation examples showing expected behavior

## 🎯 Chatbot Capabilities

This system prompt enables the chatbot to:

1. **Check Account Balances** - Query balances using PIN authentication via API tool calling
2. **Provide Bank Opening Hours** - Share static information about operating hours
3. **Block Lost/Stolen Cards** - Assist customers with card blocking procedures

## 🚀 Quick Start

### Option 1: OpenAI (GPT-4, GPT-3.5)

```python
import openai
import json

# Load the system prompt
with open('system_prompt.txt', 'r') as f:
    system_prompt = f.read()

# Load function definition
with open('openai_function_definition.json', 'r') as f:
    function_def = json.load(f)

# Create chat completion
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": "Check my balance, PIN 1234"}
    ],
    functions=[function_def],
    function_call="auto"
)
```

### Option 2: Anthropic (Claude)

```python
import anthropic
import json

# Load the system prompt
with open('system_prompt.txt', 'r') as f:
    system_prompt = f.read()

# Load tool definition
with open('anthropic_tool_definition.json', 'r') as f:
    tool_def = json.load(f)

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    system=system_prompt,
    messages=[
        {"role": "user", "content": "Check my balance, PIN 1234"}
    ],
    tools=[tool_def]
)
```

## 📋 Prerequisites

To use this chatbot system, you need:

1. **An LLM API key** - OpenAI, Anthropic, or compatible provider
2. **The Balance API running** - See `../bank_api/` for setup instructions
3. **Function/tool calling support** - Your chosen model must support function calling

## 🔧 Implementation Steps

### Step 1: Set Up the Balance API

```bash
# Start the Balance API
cd ../bank_api
python app.py
```

The API will run on `http://localhost:7860`

### Step 2: Choose Your LLM Provider

Select one of the function/tool definitions:
- `openai_function_definition.json` for OpenAI/compatible models
- `anthropic_tool_definition.json` for Claude models

### Step 3: Implement the Tool Callback

Create a function that calls the Balance API when the LLM requests it:

```python
import requests

def check_bank_balance(pin):
    response = requests.post(
        "http://localhost:7860/api/balance",
        json={"pin": pin},
        timeout=5
    )
    return response.json()
```

### Step 4: Handle the Conversation Loop

Implement the function calling loop (see `api_integration.md` for complete examples).

## 📚 Documentation

### Detailed Files

- **`system_prompt.txt`** - Read this to understand the chatbot's persona and guidelines
- **`conversation_examples.md`** - Study 8 example conversations covering all scenarios
- **`api_integration.md`** - Complete integration guide with Python and JavaScript examples

### Key Features of the System Prompt

✅ **Personality**: Friendly, professional, and helpful banking assistant
✅ **Natural conversation**: Handles greetings, questions, and multi-turn dialogs
✅ **Tool usage**: Clear guidance on when to call the balance checking tool
✅ **Static responses**: Built-in knowledge for opening hours and card blocking
✅ **Error handling**: Graceful handling of invalid PINs and API errors
✅ **Security awareness**: Appropriate handling of sensitive information

## 🧪 Testing

### Test PINs

Use these PINs to test the chatbot:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

### Test Scenarios

Try these conversation starters:
- "Hello" (greeting)
- "Check my balance" (balance inquiry)
- "What are your opening hours?" (static info)
- "I lost my card" (card blocking)
- "Are you a bot?" (bot challenge)

## 🔄 Comparison with Rasa Implementation

This LLM-based approach differs from the Rasa implementation in `../rasa_chatbot/`:

| Aspect | Rasa | LLM (This Implementation) |
|--------|------|---------------------------|
| **NLU** | Trained model | Pre-trained LLM |
| **Training Data** | Required | Not required |
| **Intent Classification** | Explicit | Implicit |
| **Dialog Management** | Stories & Rules | Natural conversation |
| **Flexibility** | Structured | Free-form |
| **Setup Complexity** | Higher | Lower |
| **Cost** | Free (self-hosted) | API costs |
| **Customization** | Fine-grained | Prompt-based |

### When to Use LLM vs. Rasa

**Use LLM (this implementation) when:**
- You want quick setup without training
- You need natural, flexible conversations
- You're okay with API costs
- You want easy updates (just change the prompt)

**Use Rasa when:**
- You need full control and customization
- You want no ongoing API costs
- You require on-premise deployment
- You need strict conversation flows

## 🔐 Security Considerations

⚠️ **This is a demonstration system**

For production use, implement:
- Rate limiting on API calls
- Request validation and sanitization
- Encrypted PIN storage
- Session management
- Audit logging
- OAuth2/JWT authentication
- HTTPS only
- PII data handling compliance

## 🎨 Customization

### Modifying the Prompt

To customize the chatbot:

1. Edit `system_prompt.txt` to change personality or add capabilities
2. Update function definitions if you add new tool-based features
3. Add new static information (like FAQs, policies) directly in the prompt

### Adding New Features

To add a new feature:

1. If it requires an API call → Add a new function/tool definition
2. If it's static info → Add it to the system prompt under "Static Information"
3. Update `conversation_examples.md` with new example dialogs

## 📖 Further Reading

- [OpenAI Function Calling Guide](https://platform.openai.com/docs/guides/function-calling)
- [Anthropic Tool Use Guide](https://docs.anthropic.com/claude/docs/tool-use)
- [Balance API Documentation](../bank_api/README_API.md)
- [Rasa Implementation](../rasa_chatbot/README.md)

## 💡 Tips for Best Results

1. **Test thoroughly** with the provided test PINs
2. **Study the examples** in `conversation_examples.md`
3. **Handle errors gracefully** as shown in the system prompt
4. **Keep context** across multi-turn conversations
5. **Monitor token usage** to optimize costs
6. **Log conversations** for quality improvement

## 🤝 Contributing

To improve this prompt:
1. Test with various conversation patterns
2. Note any edge cases or issues
3. Update the system prompt accordingly
4. Add new examples to `conversation_examples.md`

## 📞 Support

For questions about:
- **This prompt system**: Review the documentation files
- **The Balance API**: See `../bank_api/README_API.md`
- **Rasa comparison**: See `../rasa_chatbot/README.md`
