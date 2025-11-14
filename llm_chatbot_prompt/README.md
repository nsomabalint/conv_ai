# Banking Chatbot System Prompt for LLMs

This directory contains everything needed to create a banking chatbot using ChatGPT Custom GPTs or similar LLM platforms with function calling capabilities.

## Files

- `system_prompt.txt` - Main instructions for the chatbot
- `openapi_schema.json` - API schema for the balance check function
- `bank_knowledge_base.txt` - General banking information for RAG
- `investment_advice_section.txt` - Optional policy section for investment queries

## Quick Setup with ChatGPT GPTs

1. Create a new Custom GPT
2. Copy entire contents of `system_prompt.txt` into the Instructions field
3. Configure Actions:
   - Create new action
   - Paste `openapi_schema.json` content
   - Update the server URL to your Hugging Face Spaces deployment
4. Upload `bank_knowledge_base.txt` to Knowledge
5. (Optional) Append `investment_advice_section.txt` to system prompt if needed

## What the Bot Does

Same capabilities as the Rasa chatbot:
- Check account balance via API call
- Provide bank opening hours
- Assist with card blocking
- Answer general banking questions using knowledge base

## System Prompt Structure

The system prompt defines:
- Bot personality (friendly banking assistant)
- Three main capabilities
- Tool usage instructions for balance API
- Static information (opening hours, card blocking procedure)
- Response guidelines and examples

## OpenAPI Schema

Defines the balance check function:
- Endpoint: `POST /api/balance`
- Parameter: `pin` (4-digit string)
- Returns: `success`, `balance`, `currency`, `account_name`, `message`

Remember to update the server URL in the schema:
```json
"servers": [
  {
    "url": "https://your-username-balance-api.hf.space"
  }
]
```

## Knowledge Base

Contains information about SecureBank including:
- Account types and fees
- Loan and mortgage rates
- Credit card offerings
- ATM network details
- Customer service information
- Security features
- Additional banking services

The LLM uses this information to answer questions beyond the three core functions.

## Investment Advice Policy

Optional addition that:
- Explicitly prohibits providing investment advice
- Redirects investment queries to specialists
- Provides phone number: 1-800-INVEST
- Includes response template for handling such requests

Append this to the system prompt if your use case requires strict boundaries on financial advice.

## Test PINs

Same test accounts as the Rasa chatbot:

| PIN  | Balance    | Currency |
|------|------------|----------|
| 1234 | 15,420.50  | USD      |
| 5678 | 8,932.75   | EUR      |
| 9012 | 23,500.00  | GBP      |
| 3456 | 567.25     | USD      |
| 7890 | 45,123.80  | CAD      |

## Customization

To modify the chatbot:
- Edit `system_prompt.txt` for behavior changes
- Update `bank_knowledge_base.txt` for different information
- Modify `openapi_schema.json` if API changes
- Add `investment_advice_section.txt` for additional policies
