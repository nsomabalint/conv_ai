# Bank Balance API for Chatbots

A simple FastAPI application that provides a bank balance checking endpoint for chatbot integration. This is a demo/play tool that simulates bank account balance queries using PIN authentication.

## Features

- **POST /api/balance**: Check account balance using PIN
- **GET /api/balance/{pin}**: Alternative GET endpoint (demo only)
- **GET /health**: Health check endpoint
- **GET /docs**: Interactive API documentation (Swagger UI)
- **GET /redoc**: Alternative API documentation

## Test Accounts

The following PINs are available for testing:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

## Local Testing

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the application:
```bash
python app.py
```

3. Access the API at `http://localhost:7860`

4. View interactive docs at `http://localhost:7860/docs`

## API Usage Examples

### Using cURL (POST)

```bash
# Valid PIN
curl -X POST "http://localhost:7860/api/balance" \
  -H "Content-Type: application/json" \
  -d '{"pin": "1234"}'

# Invalid PIN
curl -X POST "http://localhost:7860/api/balance" \
  -H "Content-Type: application/json" \
  -d '{"pin": "0000"}'
```

### Using cURL (GET)

```bash
curl "http://localhost:7860/api/balance/1234"
```

### Using Python

```python
import requests

# Check balance
response = requests.post(
    "http://localhost:7860/api/balance",
    json={"pin": "1234"}
)

data = response.json()
if data["success"]:
    print(f"Balance: {data['balance']} {data['currency']}")
    print(f"Account: {data['account_name']}")
else:
    print(f"Error: {data['message']}")
```

### Using JavaScript/Fetch

```javascript
fetch('http://localhost:7860/api/balance', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({ pin: '1234' })
})
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      console.log(`Balance: ${data.balance} ${data.currency}`);
      console.log(`Account: ${data.account_name}`);
    } else {
      console.log(`Error: ${data.message}`);
    }
  });
```

## Response Format

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
```json
{
  "detail": "Invalid PIN format. PIN must be a 4-digit number."
}
```

## Deploying to Hugging Face Spaces

1. Create a new Space on Hugging Face
2. Select "Gradio" or "Docker" as the SDK (Docker recommended for FastAPI)
3. Upload these files:
   - `app.py`
   - `requirements.txt`
   - `README.md` (optional)

4. If using Docker SDK, create a `Dockerfile`:

```dockerfile
FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
```

## Chatbot Integration

For chatbot integration (e.g., with LangChain, OpenAI Functions, etc.), the API can be described as:

```json
{
  "name": "check_bank_balance",
  "description": "Check a user's bank account balance using their PIN number. Returns the balance amount and currency type.",
  "parameters": {
    "type": "object",
    "properties": {
      "pin": {
        "type": "string",
        "description": "The 4-digit PIN number for the bank account"
      }
    },
    "required": ["pin"]
  }
}
```

## Security Notes

⚠️ **This is a demo application for educational purposes only!**

- PINs are stored in plain text
- No actual authentication/authorization
- No rate limiting
- No encryption
- Not suitable for production use with real financial data

For production applications, implement:
- Proper authentication (OAuth2, JWT)
- Encrypted PIN storage
- Rate limiting
- HTTPS only
- Audit logging
- Multi-factor authentication
