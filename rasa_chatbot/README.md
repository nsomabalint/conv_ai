# Banking Chatbot with Rasa

A simple English banking chatbot built with Rasa that demonstrates the integration with the Bank Balance API. The chatbot can check account balances by querying the custom API through Rasa custom actions.

## Features

- **Simple conversational flow** with greetings, balance checks, and goodbyes
- **Custom action** that queries the Bank Balance API for account balances
- **Entity extraction** for PIN numbers
- **Bank opening hours** information (static response)
- **Card blocking** functionality (static response)
- **Multiple intents** for natural conversation
- **Rules and stories** for consistent responses

## Project Structure

```
rasa_chatbot/
├── actions/
│   ├── __init__.py
│   ├── actions.py              # Custom action to query Balance API
│   └── requirements-actions.txt
├── data/
│   ├── nlu.yml                 # NLU training data
│   ├── rules.yml               # Conversation rules
│   └── stories.yml             # Training stories
├── config.yml                  # Pipeline and policy configuration
├── domain.yml                  # Domain definition
├── credentials.yml             # Channel credentials
├── endpoints.yml               # Action server endpoint
└── requirements.txt
```

## Intents

- **greet**: Greeting the bot
- **goodbye**: Saying goodbye
- **check_balance**: Request to check account balance
- **provide_pin**: Providing PIN number
- **ask_opening_hours**: Ask about bank opening hours
- **block_card**: Request to block a card
- **bot_challenge**: Asking if the bot is a bot

## Prerequisites

1. Python 3.8 or higher
2. The Bank Balance API running on `http://localhost:7860`

## Setup and Installation

### 1. Install Rasa

```bash
cd rasa_chatbot
pip install -r requirements.txt
```

### 2. Install Action Server Dependencies

```bash
pip install -r actions/requirements-actions.txt
```

### 3. Train the Model

```bash
rasa train
```

This will create a trained model in the `models/` directory.

## Running the Chatbot

You need to run three separate components:

### Terminal 1: Start the Bank Balance API

```bash
cd ../bank_api
python app.py
```

The API should be running on `http://localhost:7860`

### Terminal 2: Start the Rasa Action Server

```bash
cd rasa_chatbot
rasa run actions
```

This starts the action server on `http://localhost:5055`

### Terminal 3: Start the Rasa Server

```bash
cd rasa_chatbot
rasa shell
```

Or to run with debugging:

```bash
rasa shell --debug
```

## Example Conversations

### Balance Check

```
Your input ->  hello
Hello! I'm your banking assistant. How can I help you today?

Your input ->  I want to check my balance
Please provide your 4-digit PIN number to check your balance.

Your input ->  1234
Account holder: John Doe
Your current balance is: 15420.50 USD

Your input ->  thanks, bye
Goodbye! Have a great day!
```

### Opening Hours

```
Your input ->  hi
Hello! I'm your banking assistant. How can I help you today?

Your input ->  what are your opening hours?
Our bank is open Monday to Friday from 9:00 AM to 5:00 PM, and Saturday from 9:00 AM to 1:00 PM. We are closed on Sundays and public holidays.

Your input ->  thanks
Goodbye! Have a great day!
```

### Card Blocking

```
Your input ->  hello
Hi there! Welcome to your banking assistant. What can I do for you?

Your input ->  I lost my card, please block it
Card blocked! For your security, your card is now deactivated. To get a new card, please visit any branch with your ID or contact us at 1-800-BANK-HELP.

Your input ->  bye
See you later! Take care!
```

## Test PINs

Use these PINs to test the chatbot:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

## Custom Action Details

The `action_check_balance` custom action:

1. Extracts the PIN from the conversation slot
2. Validates the PIN format (4 digits)
3. Makes a POST request to the Balance API
4. Formats and returns the balance information to the user
5. Handles errors gracefully (invalid PIN, connection errors, timeouts)

## Configuration

### API Endpoint

The Balance API endpoint is configured in `actions/actions.py`:

```python
api_url = "http://localhost:7860/api/balance"
```

To change the API location, edit this line in the `ActionCheckBalance` class.

### Action Server

The action server endpoint is configured in `endpoints.yml`:

```yaml
action_endpoint:
  url: "http://localhost:5055/webhook"
```

## Troubleshooting

### "I'm having trouble connecting to the banking system"

- Make sure the Balance API is running on port 7860
- Check that you can access `http://localhost:7860/health`

### Action Server Not Found

- Ensure the action server is running with `rasa run actions`
- Check that `endpoints.yml` has the correct action server URL

### Model Not Found

- Train the model first with `rasa train`
- Check that a model file exists in the `models/` directory

## Development

### Adding New Intents

1. Add the intent to `domain.yml`
2. Add training examples to `data/nlu.yml`
3. Add stories/rules to `data/stories.yml` or `data/rules.yml`
4. Retrain with `rasa train`

### Modifying the Custom Action

Edit `actions/actions.py` and restart the action server:

```bash
# Stop the action server (Ctrl+C)
rasa run actions
```

## Interactive Learning

You can use Rasa's interactive learning to improve the bot:

```bash
rasa interactive
```

This allows you to chat with the bot and correct its behavior in real-time.

## Testing

Test the NLU model:

```bash
rasa test nlu
```

Test the dialogue model:

```bash
rasa test
```

## Notes

- This is a **demonstration chatbot** for learning Rasa
- The chatbot uses simple rules and stories for predictable behavior
- For production use, add more training data, implement form actions for PIN collection, and add proper authentication
- The Balance API should be replaced with a real banking system in production
