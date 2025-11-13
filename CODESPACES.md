# Running in GitHub Codespaces

This guide explains how to run the Banking Chatbot in GitHub Codespaces.

## 📋 Prerequisites

Before starting, you need to deploy the Balance API to Hugging Face Spaces:
1. Deploy the `bank_api/` folder to HF Spaces
2. Get your HF Spaces URL (e.g., `https://your-username-balance-api.hf.space`)

See the [bank_api/README_API.md](bank_api/README_API.md) for deployment instructions.

## 🚀 Quick Start

### 1. Open in Codespaces

Click the "Code" button on GitHub and select "Create codespace on [branch-name]"

The environment will automatically set up:
- Install Rasa and action server dependencies
- Train the Rasa model
- Create a `.env` configuration file
- Configure port forwarding

This takes about 5-10 minutes on first launch.

### 2. Configure the Balance API URL

Edit the `.env` file and set your Hugging Face Spaces URL:

```bash
# Edit .env file
nano .env
```

Update the `BALANCE_API_URL` line:
```
BALANCE_API_URL=https://your-username-balance-api.hf.space
```

Save and exit (Ctrl+X, then Y, then Enter).

### 3. Run the Chatbot

Once configured, you have two options:

#### Option A: All-in-One (Recommended)

Run everything with a single command:

```bash
./start_chatbot.sh
```

This will:
- Check that `.env` is configured
- Start the Rasa Action Server in the background
- Launch the Rasa chatbot in your terminal

Logs are saved to `logs/` directory.

#### Option B: Separate Terminals

For more control, run each component in a separate terminal:

**Terminal 1 - Rasa Actions:**
```bash
./start_actions.sh
```

**Terminal 3 - Rasa Chatbot:**
```bash
./start_rasa.sh
```

## 💬 Using the Chatbot

Once started, you can chat with the bot:

```
Your input -> hello
Bot: Hello! I'm your banking assistant. How can I help you today?

Your input -> check my balance
Bot: Please provide your 4-digit PIN number to check your balance.

Your input -> 1234
Bot: Account holder: John Doe
     Your current balance is: 15420.50 USD
```

### Test PINs

| PIN  | Balance    | Currency | Account Name     |
|------|------------|----------|------------------|
| 1234 | 15,420.50  | USD      | John Doe         |
| 5678 | 8,932.75   | EUR      | Jane Smith       |
| 9012 | 23,500.00  | GBP      | Bob Johnson      |
| 3456 | 567.25     | USD      | Alice Williams   |
| 7890 | 45,123.80  | CAD      | Charlie Brown    |

### Features to Try

1. **Balance Check**: "check my balance" → provide PIN
2. **Opening Hours**: "what are your opening hours?"
3. **Card Blocking**: "I lost my card"
4. **General**: "hello", "goodbye", "what can you do?"

## 🔧 Port Forwarding

Codespaces automatically forwards these ports:

- **5055** - Rasa Action Server
- **5005** - Rasa API Server (if you run `rasa run`)

You can view these in the "Ports" tab in VS Code.

## 📊 Accessing the Rasa Action Server

The Rasa Action Server runs on port 5055. You can check if it's running:

```bash
curl http://localhost:5055/health
```

## 🛠️ Development

### Retrain the Model

After making changes to `data/`, `domain.yml`, or `config.yml`:

```bash
cd rasa_chatbot
rasa train
```

### Configure Balance API URL

Edit the `.env` file to set your HF Spaces URL:

```bash
nano .env
# Set BALANCE_API_URL=https://your-username-balance-api.hf.space
```

### View Logs

Logs are saved in the `logs/` directory:

```bash
tail -f logs/actions.log  # Rasa actions logs
```

### Stop Services

If you ran `./start_chatbot.sh`, the action server will stop when you exit the Rasa shell.

To manually stop background processes:

```bash
# Find the processes
ps aux | grep rasa

# Kill specific processes
kill <PID>
```

## 🐛 Troubleshooting

### "Model not found"

Train the model:
```bash
cd rasa_chatbot
rasa train
```

### ".env file not found"

Create it from the example:
```bash
cp .env.example .env
# Then edit .env and set your HF Spaces URL
```

### "Connection refused" to Balance API

1. Check your `.env` file has the correct HF Spaces URL
2. Verify your HF Spaces deployment is running
3. Test the API directly:
```bash
curl https://your-username-balance-api.hf.space/health
```

### Action server not responding

Check if it's running:
```bash
curl http://localhost:5055/health
```

Restart it:
```bash
./start_actions.sh
```

### Port already in use

Find and kill the process:
```bash
lsof -i :5055  # or :5005
kill -9 <PID>
```

## 📝 File Structure

```
conv_ai/
├── .devcontainer/
│   ├── devcontainer.json    # Codespaces configuration
│   └── setup.sh             # Auto-setup script
├── .env.example             # Environment config template
├── .env                     # Your configuration (created during setup)
├── bank_api/                # Balance API (deploy to HF Spaces)
├── rasa_chatbot/            # Rasa chatbot
├── logs/                    # Log files (auto-created)
├── start_actions.sh         # Start Rasa Actions
├── start_rasa.sh            # Start Rasa chatbot
└── start_chatbot.sh         # Start everything
```

## 🔄 Rebuilding the Container

If you make changes to `.devcontainer/devcontainer.json`:

1. Press `F1` or `Ctrl+Shift+P`
2. Type "Codespaces: Rebuild Container"
3. Select and confirm

This will rebuild and restart your environment.

## 💡 Tips

- Use the **integrated terminal** in VS Code for better experience
- **Edit .env file** immediately after setup to set your HF Spaces URL
- Open **multiple terminals** if you want to see action server output separately
- The **Ports** tab shows which ports are forwarded
- Logs are useful for debugging - check `logs/actions.log` if something fails
- The chatbot connects to your deployed HF Spaces API - make sure it's running!

## 📚 Additional Resources

- [Rasa Chatbot README](rasa_chatbot/README.md)
- [Balance API Documentation](bank_api/README_API.md)
- [LLM Prompt Alternative](llm_chatbot_prompt/README.md)
