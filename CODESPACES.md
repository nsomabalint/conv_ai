# Running in GitHub Codespaces

This guide explains how to run the Banking Chatbot in GitHub Codespaces.

## 🚀 Quick Start

### 1. Open in Codespaces

Click the "Code" button on GitHub and select "Create codespace on [branch-name]"

The environment will automatically set up:
- Install Python dependencies
- Install Rasa and action server
- Train the Rasa model
- Configure port forwarding

This takes about 5-10 minutes on first launch.

### 2. Run the Chatbot

Once setup is complete, you have two options:

#### Option A: All-in-One (Recommended)

Run everything with a single command:

```bash
./start_chatbot.sh
```

This will:
- Start the Balance API in the background
- Start the Rasa Action Server in the background
- Launch the Rasa chatbot in your terminal

Logs are saved to `logs/` directory.

#### Option B: Separate Terminals

For more control, run each component in a separate terminal:

**Terminal 1 - Balance API:**
```bash
./start_api.sh
```

**Terminal 2 - Rasa Actions:**
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

- **7860** - Balance API (FastAPI)
- **5055** - Rasa Action Server
- **5005** - Rasa API Server (if you run `rasa run`)

You can view these in the "Ports" tab in VS Code.

## 📊 Accessing the APIs

### Balance API

Once running, you can access:

- **Swagger Docs**: Open the forwarded port 7860 in your browser
- **Health Check**: `http://localhost:7860/health`
- **API Endpoint**: `http://localhost:7860/api/balance`

### Test the API Directly

```bash
curl -X POST http://localhost:7860/api/balance \
  -H "Content-Type: application/json" \
  -d '{"pin": "1234"}'
```

## 🛠️ Development

### Retrain the Model

After making changes to `data/`, `domain.yml`, or `config.yml`:

```bash
cd rasa_chatbot
rasa train
```

### View Logs

Logs are saved in the `logs/` directory:

```bash
tail -f logs/api.log      # Balance API logs
tail -f logs/actions.log  # Rasa actions logs
```

### Stop Services

If you ran `./start_chatbot.sh`, services will stop when you exit the Rasa shell.

To manually stop background processes:

```bash
# Find the processes
ps aux | grep python

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

### "Connection refused" to Balance API

Ensure the API is running:
```bash
curl http://localhost:7860/health
```

If not running, start it:
```bash
./start_api.sh
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
lsof -i :7860  # or :5055, :5005
kill -9 <PID>
```

## 📝 File Structure

```
conv_ai/
├── .devcontainer/
│   ├── devcontainer.json    # Codespaces configuration
│   └── setup.sh             # Auto-setup script
├── bank_api/                # Balance API
├── rasa_chatbot/            # Rasa chatbot
├── logs/                    # Log files (auto-created)
├── start_api.sh             # Start Balance API
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
- Open **multiple terminals** to see each component's output
- The **Ports** tab shows which ports are forwarded
- **Port 7860** (Balance API) has a direct link in the Ports tab
- Logs are useful for debugging - check them first if something fails

## 🌐 Accessing from Outside

If you want to access the APIs from outside Codespaces:

1. Go to the "Ports" tab
2. Right-click on a port
3. Select "Port Visibility" → "Public"
4. Copy the forwarded URL

⚠️ **Security Note**: Only make ports public if needed, and never in production!

## 📚 Additional Resources

- [Rasa Chatbot README](rasa_chatbot/README.md)
- [Balance API Documentation](bank_api/README_API.md)
- [LLM Prompt Alternative](llm_chatbot_prompt/README.md)
