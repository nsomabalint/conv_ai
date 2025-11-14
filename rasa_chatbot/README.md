# Banking Chatbot with Rasa

This chatbot demonstrates building a conversational AI assistant with Rasa that integrates with an external API. The bot can check bank account balances, provide opening hours, and assist with card blocking.

## What This Bot Does

- Check account balance by calling the Balance API with PIN authentication
- Provide bank opening hours (static information)
- Assist with blocking lost or stolen cards (static information)

## Architecture

The bot uses three components:

1. **Rasa NLU** - Understands user messages and extracts intents/entities
2. **Rasa Core** - Manages conversation flow based on stories and rules
3. **Action Server** - Executes custom Python code to call the Balance API

The action server connects to a deployed Balance API (on Hugging Face Spaces) to retrieve actual balance information.

## Project Structure

```
rasa_chatbot/
├── actions/
│   ├── actions.py              # Custom action for API calls
│   └── requirements-actions.txt
├── data/
│   ├── nlu.yml                 # Training examples for intents
│   ├── rules.yml               # Simple intent-to-action mappings
│   └── stories.yml             # Multi-turn conversation examples
├── config.yml                  # NLU pipeline and dialogue policies
├── domain.yml                  # Intents, entities, slots, responses, actions
├── credentials.yml             # Channel configurations
└── endpoints.yml               # Action server connection
```

## Setup in GitHub Codespaces

1. Open repository in Codespaces
2. Wait for automatic setup (installs dependencies, trains model)
3. Run the bot:
   ```bash
   ./start_chatbot.sh
   ```

The bot is configured to use the deployed Balance API at https://nsomabalint-bank-api.hf.space

## Local Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   pip install -r actions/requirements-actions.txt
   ```

2. Train the model:
   ```bash
   rasa train
   ```

3. Run components (in separate terminals):
   ```bash
   # Terminal 1: Action server
   rasa run actions

   # Terminal 2: Chatbot
   rasa shell
   ```

The action server is configured to use the Balance API at https://nsomabalint-bank-api.hf.space

## How It Works

### Intent Recognition

The `data/nlu.yml` file defines intents with training examples:

```yaml
- intent: check_balance
  examples: |
    - check my balance
    - what's my balance
    - how much money do I have

- intent: provide_pin
  examples: |
    - my pin is [1234](pin)
    - [5678](pin)
    - the pin is [9012](pin)
```

Entity annotations like `[1234](pin)` train the model to extract PIN numbers from user messages.

### Conversation Flow

Rules in `data/rules.yml` define simple mappings:

```yaml
- rule: Ask for PIN when checking balance
  steps:
  - intent: check_balance
  - action: utter_ask_pin

- rule: Provide opening hours
  steps:
  - intent: ask_opening_hours
  - action: utter_opening_hours
```

Stories in `data/stories.yml` define multi-turn conversations:

```yaml
- story: Check balance flow
  steps:
  - intent: greet
  - action: utter_greet
  - intent: check_balance
  - action: utter_ask_pin
  - intent: provide_pin
  - action: action_check_balance
  - intent: goodbye
  - action: utter_goodbye
```

### Custom Action for API Integration

The `actions/actions.py` file contains the balance check action:

```python
class ActionCheckBalance(Action):
    def name(self) -> Text:
        return "action_check_balance"

    def run(self, dispatcher, tracker, domain):
        pin = tracker.get_slot("pin")
        base_url = os.getenv("BALANCE_API_URL")
        api_url = f"{base_url}/api/balance"

        response = requests.post(api_url, json={"pin": pin})
        data = response.json()

        if data.get("success"):
            message = f"Account holder: {data['account_name']}\n"
            message += f"Balance: {data['balance']} {data['currency']}"
            dispatcher.utter_message(text=message)
        else:
            dispatcher.utter_message(text="Invalid PIN")

        return []
```

The action retrieves the PIN from the conversation slot, calls the external API, and returns the formatted response to the user.

### Domain Configuration

The `domain.yml` file defines all components:

```yaml
intents:
  - greet
  - goodbye
  - check_balance
  - provide_pin
  - ask_opening_hours
  - block_card
  - bot_challenge

entities:
  - pin

slots:
  pin:
    type: text
    influence_conversation: true
    mappings:
      - type: from_entity
        entity: pin

responses:
  utter_greet:
    - text: "Hello! I'm your banking assistant."

  utter_ask_pin:
    - text: "Please provide your 4-digit PIN."

actions:
  - action_check_balance
```

## Configuration Details

The `config.yml` defines the NLU pipeline and dialogue policies:

```yaml
pipeline:
  - name: WhitespaceTokenizer
  - name: RegexFeaturizer
  - name: CountVectorsFeaturizer
  - name: DIETClassifier
    epochs: 100

policies:
  - name: MemoizationPolicy
  - name: RulePolicy
  - name: TEDPolicy
    max_history: 5
    epochs: 100
```

- **DIETClassifier**: Handles both intent classification and entity extraction
- **RulePolicy**: Executes rule-based conversations
- **TEDPolicy**: Learns patterns from story examples

## Test PINs

The Balance API includes test accounts:

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

## Example Conversations

**Balance Check:**
```
User: hello
Bot: Hello! I'm your banking assistant. How can I help you today?
User: check my balance
Bot: Please provide your 4-digit PIN number.
User: 1234
Bot: Account holder: John Doe
     Your current balance is: 15,420.50 USD
```

**Opening Hours:**
```
User: when are you open?
Bot: Monday-Friday: 9:00 AM - 5:00 PM
     Saturday: 9:00 AM - 1:00 PM
     Sunday: Closed
```

**Card Blocking:**
```
User: I lost my card
Bot: Your card has been blocked. Please visit a branch with ID
     or call 1-800-BANK-HELP.
```

## Useful Commands

- `rasa train` - Train the model with current data
- `rasa shell` - Talk to the bot in terminal
- `rasa run actions` - Start the action server
- `rasa data validate` - Check training data for errors
- `rasa test` - Evaluate model performance
