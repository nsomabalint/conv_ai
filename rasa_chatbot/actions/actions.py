from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import requests


class ActionCheckBalance(Action):
    """Custom action to check bank balance using the Balance API"""

    def name(self) -> Text:
        return "action_check_balance"

    def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:

        # Get the PIN from the slot
        pin = tracker.get_slot("pin")

        if not pin:
            dispatcher.utter_message(text="I couldn't find your PIN. Please try again.")
            return []

        # Validate PIN format
        if not pin.isdigit() or len(pin) != 4:
            dispatcher.utter_message(text="Invalid PIN format. Please provide a 4-digit PIN number.")
            return []

        # Call the Balance API
        api_url = "http://localhost:7860/api/balance"

        try:
            response = requests.post(
                api_url,
                json={"pin": pin},
                timeout=5
            )

            if response.status_code == 200:
                data = response.json()

                if data.get("success"):
                    balance = data.get("balance")
                    currency = data.get("currency")
                    account_name = data.get("account_name")

                    message = (
                        f"Account holder: {account_name}\n"
                        f"Your current balance is: {balance:.2f} {currency}"
                    )
                    dispatcher.utter_message(text=message)
                else:
                    # Invalid PIN
                    dispatcher.utter_message(
                        text="Access denied. The PIN you provided is not valid. Please check and try again."
                    )
            else:
                dispatcher.utter_message(
                    text="Sorry, I couldn't retrieve your balance at this time. Please try again later."
                )

        except requests.exceptions.ConnectionError:
            dispatcher.utter_message(
                text="I'm having trouble connecting to the banking system. Please make sure the Balance API is running on http://localhost:7860"
            )
        except requests.exceptions.Timeout:
            dispatcher.utter_message(
                text="The request timed out. Please try again."
            )
        except Exception as e:
            dispatcher.utter_message(
                text=f"An error occurred: {str(e)}"
            )

        return []
