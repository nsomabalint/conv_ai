from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import uvicorn

app = FastAPI(
    title="Bank Balance API",
    description="A simple API endpoint for chatbots to query bank account balances using PIN authentication",
    version="1.0.0"
)

# Mock database of account balances
# In production, this would be a real database with encrypted PINs
ACCOUNT_DATA = {
    "1234": {"balance": 15420.50, "currency": "USD", "account_name": "John Doe"},
    "5678": {"balance": 8932.75, "currency": "EUR", "account_name": "Jane Smith"},
    "9012": {"balance": 23500.00, "currency": "GBP", "account_name": "Bob Johnson"},
    "3456": {"balance": 567.25, "currency": "USD", "account_name": "Alice Williams"},
    "7890": {"balance": 45123.80, "currency": "CAD", "account_name": "Charlie Brown"},
}


class BalanceRequest(BaseModel):
    pin: str

    class Config:
        json_schema_extra = {
            "example": {
                "pin": "1234"
            }
        }


class BalanceResponse(BaseModel):
    success: bool
    balance: Optional[float] = None
    currency: Optional[str] = None
    account_name: Optional[str] = None
    message: Optional[str] = None


@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "Bank Balance API",
        "version": "1.0.0",
        "endpoints": {
            "check_balance": "/api/balance (POST)",
            "docs": "/docs",
            "health": "/health"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}


@app.post("/api/balance", response_model=BalanceResponse)
async def check_balance(request: BalanceRequest):
    """
    Check bank account balance using PIN authentication.

    - **pin**: 4-digit PIN number (as string)

    Returns:
    - **success**: Whether the request was successful
    - **balance**: Account balance (if PIN is valid)
    - **currency**: Currency type (USD, EUR, GBP, etc.)
    - **account_name**: Account holder name
    - **message**: Status message

    Example PINs for testing:
    - 1234 (USD account)
    - 5678 (EUR account)
    - 9012 (GBP account)
    - 3456 (USD account)
    - 7890 (CAD account)
    """

    # Validate PIN format
    if not request.pin or len(request.pin) != 4 or not request.pin.isdigit():
        raise HTTPException(
            status_code=400,
            detail="Invalid PIN format. PIN must be a 4-digit number."
        )

    # Check if PIN exists in database
    if request.pin not in ACCOUNT_DATA:
        return BalanceResponse(
            success=False,
            message="Access denied. Invalid PIN."
        )

    # Return account balance information
    account = ACCOUNT_DATA[request.pin]
    return BalanceResponse(
        success=True,
        balance=account["balance"],
        currency=account["currency"],
        account_name=account["account_name"],
        message="Balance retrieved successfully"
    )


@app.get("/api/balance/{pin}")
async def check_balance_get(pin: str):
    """
    Alternative GET endpoint to check balance (less secure, for demo purposes only).

    - **pin**: 4-digit PIN number
    """
    request = BalanceRequest(pin=pin)
    return await check_balance(request)


if __name__ == "__main__":
    # For local testing
    uvicorn.run(app, host="0.0.0.0", port=7860)
