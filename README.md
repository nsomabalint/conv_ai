# Conversational AI Projects

This repository contains conversational AI projects and tools, including chatbot integrations and API endpoints.

## 🏦 Bank Balance API

A FastAPI-based chatbot tool that simulates bank account balance queries using PIN authentication. Perfect for testing chatbot integrations and function calling.

### Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Run the API server
python app.py

# Access the API at http://localhost:7860
# View interactive docs at http://localhost:7860/docs
```

### Test the API

```bash
# Run automated tests
python test_api.py
```

### Features

- ✅ PIN-based authentication
- ✅ Multiple currency support (USD, EUR, GBP, CAD)
- ✅ RESTful API with POST and GET endpoints
- ✅ Interactive API documentation (Swagger UI)
- ✅ Ready for Hugging Face Spaces deployment
- ✅ Example test accounts with various balances

### Test Accounts

| PIN  | Balance    | Currency |
|------|------------|----------|
| 1234 | 15,420.50  | USD      |
| 5678 | 8,932.75   | EUR      |
| 9012 | 23,500.00  | GBP      |
| 3456 | 567.25     | USD      |
| 7890 | 45,123.80  | CAD      |

### Documentation

See [README_API.md](README_API.md) for detailed API documentation, usage examples, and deployment instructions.

## 📚 Additional Resources

- [Conversational_AI.ipynb](Conversational_AI.ipynb) - Jupyter notebook with conversational AI examples

## 🚀 Deployment

### Hugging Face Spaces

1. Create a new Space with Docker SDK
2. Upload: `app.py`, `requirements.txt`, `Dockerfile`
3. Your API will be available at `https://your-username-space-name.hf.space`

### Docker

```bash
docker build -t bank-balance-api .
docker run -p 7860:7860 bank-balance-api
```

## ⚠️ Security Notice

This is a **demo application for educational purposes only**. Do not use with real financial data or in production environments without implementing proper security measures.
