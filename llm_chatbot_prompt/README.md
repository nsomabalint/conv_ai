# Banking Chatbot System Prompt for GPTs

This folder contains a ready-to-use system prompt for creating a banking chatbot with ChatGPT or other LLM platforms.

## 📄 File

**`system_prompt.txt`** - Copy this entire file and paste it as your GPT's instructions.

## 🎯 What This Chatbot Does

1. **Check Account Balance** - Uses a custom action/tool to query balances with PIN
2. **Provide Bank Opening Hours** - Shares static schedule information
3. **Block Lost/Stolen Cards** - Provides card blocking assistance

## 🚀 How to Use with ChatGPT GPTs

### Step 1: Create a Custom GPT

1. Go to [chat.openai.com/gpts/editor](https://chat.openai.com/gpts/editor)
2. Click "Create a GPT"
3. Switch to "Configure" tab

### Step 2: Add the System Prompt

1. Copy the entire contents of `system_prompt.txt`
2. Paste it into the "Instructions" field

### Step 3: Configure the Action (for Balance Check)

1. Click "Create new action"
2. Set up the API endpoint to point to your Balance API:
   - Server: `http://localhost:7860` (or your deployed API URL)
   - Endpoint: `/api/balance`
   - Method: POST

3. Add the schema:
```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "Bank Balance API",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "http://localhost:7860"
    }
  ],
  "paths": {
    "/api/balance": {
      "post": {
        "operationId": "check_bank_balance",
        "summary": "Check account balance with PIN",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "pin": {
                    "type": "string",
                    "description": "4-digit PIN number"
                  }
                },
                "required": ["pin"]
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Balance information",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "success": {"type": "boolean"},
                    "balance": {"type": "number"},
                    "currency": {"type": "string"},
                    "account_name": {"type": "string"},
                    "message": {"type": "string"}
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

### Step 4: Name Your GPT

Give it a name like "Banking Assistant" or "Bank Helper Bot"

### Step 5: Save and Test

Click "Save" and start chatting with your banking bot!

## 🧪 Test PINs

Once your GPT is set up and the Balance API is running, test with these PINs:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

## 💬 Example Conversations

Try these:
- "Hello"
- "Check my balance" → provide PIN when asked
- "What are your opening hours?"
- "I lost my card"

## ⚙️ Prerequisites

**For balance checking to work**, you need:

1. The Balance API running (see `../bank_api/`)
2. The API accessible from where your GPT runs (may need deployment for production)

**Note:** Opening hours and card blocking work without the API (they're static responses).

## 🔗 Related

- **Balance API**: See `../bank_api/` for the FastAPI backend
- **Rasa Alternative**: See `../rasa_chatbot/` for a traditional chatbot framework implementation

## 📝 Customization

To modify the chatbot:

1. Edit `system_prompt.txt`
2. Change opening hours, phone numbers, or other static info
3. Update the personality/tone section
4. Copy the updated prompt to your GPT

## 🌐 Deployment

For production use:

1. Deploy the Balance API to a public URL (Hugging Face Spaces, Railway, etc.)
2. Update the GPT action server URL to your deployed API
3. Consider adding authentication to your API
