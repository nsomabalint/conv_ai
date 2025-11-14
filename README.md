# Conversational AI Banking Demo

This repository demonstrates building banking chatbots using two different approaches: Rasa (open-source framework) and LLM-based systems (ChatGPT Custom GPTs).

## Project Components

### 1. Balance API (FastAPI)

A REST API that returns account balance information using PIN authentication.

- Located in `bank_api/`
- Designed for deployment to Hugging Face Spaces
- Provides endpoint: `POST /api/balance`
- Returns balance, currency, and account holder information

### 2. Rasa Chatbot

A traditional conversational AI bot using Rasa framework.

- Located in `rasa_chatbot/`
- Runs in GitHub Codespaces or locally
- Connects to Balance API for account queries
- Handles balance checks, opening hours, card blocking

### 3. LLM System Prompt

Ready-to-use system prompt for ChatGPT Custom GPTs or similar LLM platforms.

- Located in `llm_chatbot_prompt/`
- Includes system prompt, OpenAPI schema, and knowledge base
- Same functionality as Rasa bot but requires no training
- Works with deployed Balance API

## Quick Start with GitHub Codespaces

For the Rasa chatbot:

1. Deploy Balance API to Hugging Face Spaces (see `bank_api/`)
2. Open this repository in GitHub Codespaces
3. Configure API URL in `.env` file
4. Run `./start_chatbot.sh`

The Codespaces environment automatically installs dependencies and trains the model.

## Repository Structure

```
conv_ai/
├── bank_api/              # FastAPI balance service
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── rasa_chatbot/          # Rasa implementation
│   ├── actions/
│   ├── data/
│   ├── config.yml
│   └── domain.yml
├── llm_chatbot_prompt/    # LLM/GPT implementation
│   ├── system_prompt.txt
│   ├── openapi_schema.json
│   ├── bank_knowledge_base.txt
│   └── investment_advice_section.txt
└── .devcontainer/         # Codespaces configuration
```

## Deployment

### Balance API to Hugging Face Spaces

1. Create new Space with Docker SDK
2. Upload files from `bank_api/` directory
3. Space automatically builds and deploys
4. Use the URL for chatbot configuration

### Rasa in GitHub Codespaces

Automatically configured through `.devcontainer/` settings. Just open and run.

### LLM with ChatGPT GPTs

1. Copy content from `system_prompt.txt`
2. Paste into GPT instructions
3. Add action using `openapi_schema.json`
4. Update server URL in schema to your HF Spaces deployment
5. Upload `bank_knowledge_base.txt` to knowledge
6. Optionally append `investment_advice_section.txt`

## Test Accounts

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

## Documentation

- [Rasa Chatbot Details](rasa_chatbot/README.md)
- [Balance API Documentation](bank_api/README_API.md)
- [LLM Prompt Guide](llm_chatbot_prompt/README.md)
- [Codespaces Setup](CODESPACES.md)

## Comparing Approaches

**Rasa:**
- Full control over conversation logic
- Requires training data and model training
- Self-hosted, no API costs
- More complex setup

**LLM (GPTs):**
- Natural language understanding out of the box
- No training required
- API costs per use
- Simpler setup

Both approaches use the same Balance API backend.
