# API Integration Guide

This document explains how to integrate the `check_bank_balance` tool with the Balance API.

## API Endpoint

```
POST http://localhost:7860/api/balance
Content-Type: application/json
```

## Request Format

```json
{
  "pin": "1234"
}
```

## Response Formats

### Successful Response

```json
{
  "success": true,
  "balance": 15420.50,
  "currency": "USD",
  "account_name": "John Doe",
  "message": "Balance retrieved successfully"
}
```

### Failed Response (Invalid PIN)

```json
{
  "success": false,
  "balance": null,
  "currency": null,
  "account_name": null,
  "message": "Access denied. Invalid PIN."
}
```

### Error Response (Invalid Format)

HTTP Status: 400

```json
{
  "detail": "Invalid PIN format. PIN must be a 4-digit number."
}
```

## Test PINs

Use these PINs for testing:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

Any other PIN will be rejected.

## Implementation Examples

### Python (OpenAI)

```python
import openai
import requests

def check_bank_balance(pin):
    """Call the Balance API"""
    try:
        response = requests.post(
            "http://localhost:7860/api/balance",
            json={"pin": pin},
            timeout=5
        )

        if response.status_code == 200:
            return response.json()
        else:
            return {
                "success": False,
                "message": "Failed to retrieve balance"
            }
    except Exception as e:
        return {
            "success": False,
            "message": f"Error: {str(e)}"
        }

# Function calling setup
functions = [
    {
        "name": "check_bank_balance",
        "description": "Check account balance using PIN",
        "parameters": {
            "type": "object",
            "properties": {
                "pin": {
                    "type": "string",
                    "description": "4-digit PIN"
                }
            },
            "required": ["pin"]
        }
    }
]

# Chat completion with function calling
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": open("system_prompt.txt").read()},
        {"role": "user", "content": "Check my balance, PIN is 1234"}
    ],
    functions=functions,
    function_call="auto"
)

# Handle function call
if response.choices[0].message.get("function_call"):
    function_name = response.choices[0].message["function_call"]["name"]
    function_args = json.loads(response.choices[0].message["function_call"]["arguments"])

    if function_name == "check_bank_balance":
        result = check_bank_balance(function_args["pin"])

        # Send result back to get final response
        second_response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": open("system_prompt.txt").read()},
                {"role": "user", "content": "Check my balance, PIN is 1234"},
                response.choices[0].message,
                {
                    "role": "function",
                    "name": function_name,
                    "content": json.dumps(result)
                }
            ]
        )

        print(second_response.choices[0].message["content"])
```

### Python (Anthropic Claude)

```python
import anthropic
import requests
import json

def check_bank_balance(pin):
    """Call the Balance API"""
    try:
        response = requests.post(
            "http://localhost:7860/api/balance",
            json={"pin": pin},
            timeout=5
        )

        if response.status_code == 200:
            return response.json()
        else:
            return {
                "success": False,
                "message": "Failed to retrieve balance"
            }
    except Exception as e:
        return {
            "success": False,
            "message": f"Error: {str(e)}"
        }

client = anthropic.Anthropic()

# Tool definition
tools = [
    {
        "name": "check_bank_balance",
        "description": "Check account balance using PIN",
        "input_schema": {
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
]

# Initial message
message = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    system=open("system_prompt.txt").read(),
    messages=[
        {"role": "user", "content": "Check my balance, PIN is 1234"}
    ],
    tools=tools
)

# Handle tool use
if message.stop_reason == "tool_use":
    tool_use = next(block for block in message.content if block.type == "tool_use")

    if tool_use.name == "check_bank_balance":
        result = check_bank_balance(tool_use.input["pin"])

        # Send result back
        final_message = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1024,
            system=open("system_prompt.txt").read(),
            messages=[
                {"role": "user", "content": "Check my balance, PIN is 1234"},
                {"role": "assistant", "content": message.content},
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "tool_result",
                            "tool_use_id": tool_use.id,
                            "content": json.dumps(result)
                        }
                    ]
                }
            ],
            tools=tools
        )

        print(final_message.content[0].text)
```

### JavaScript (Node.js with OpenAI)

```javascript
const OpenAI = require('openai');
const axios = require('axios');

const openai = new OpenAI();

async function checkBankBalance(pin) {
  try {
    const response = await axios.post('http://localhost:7860/api/balance', {
      pin: pin
    });
    return response.data;
  } catch (error) {
    return {
      success: false,
      message: `Error: ${error.message}`
    };
  }
}

const tools = [
  {
    type: "function",
    function: {
      name: "check_bank_balance",
      description: "Check account balance using PIN",
      parameters: {
        type: "object",
        properties: {
          pin: {
            type: "string",
            description: "4-digit PIN number"
          }
        },
        required: ["pin"]
      }
    }
  }
];

async function chat(userMessage) {
  const messages = [
    {
      role: "system",
      content: require('fs').readFileSync('system_prompt.txt', 'utf8')
    },
    { role: "user", content: userMessage }
  ];

  let response = await openai.chat.completions.create({
    model: "gpt-4",
    messages: messages,
    tools: tools,
    tool_choice: "auto"
  });

  // Handle tool calls
  while (response.choices[0].finish_reason === "tool_calls") {
    const toolCall = response.choices[0].message.tool_calls[0];

    if (toolCall.function.name === "check_bank_balance") {
      const args = JSON.parse(toolCall.function.arguments);
      const result = await checkBankBalance(args.pin);

      messages.push(response.choices[0].message);
      messages.push({
        role: "tool",
        tool_call_id: toolCall.id,
        content: JSON.stringify(result)
      });

      response = await openai.chat.completions.create({
        model: "gpt-4",
        messages: messages,
        tools: tools
      });
    }
  }

  return response.choices[0].message.content;
}

// Usage
chat("Check my balance, PIN is 1234").then(console.log);
```

## Error Handling

Your implementation should handle:

1. **Network errors** - API is not running or unreachable
2. **Invalid PIN format** - Not 4 digits
3. **Invalid PIN** - PIN doesn't exist in the system
4. **Timeouts** - API takes too long to respond

Present errors to users in a friendly, helpful manner as per the system prompt guidelines.
