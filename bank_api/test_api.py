"""
Simple test script for the Bank Balance API
"""
import requests
import json
import time


def test_balance_api(base_url="http://localhost:7860"):
    """Test the bank balance API endpoints"""

    print("=" * 60)
    print("Testing Bank Balance API")
    print("=" * 60)

    # Test 1: Health check
    print("\n1. Testing health endpoint...")
    try:
        response = requests.get(f"{base_url}/health")
        print(f"   Status: {response.status_code}")
        print(f"   Response: {response.json()}")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 2: Root endpoint
    print("\n2. Testing root endpoint...")
    try:
        response = requests.get(base_url)
        print(f"   Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 3: Valid PIN (POST)
    print("\n3. Testing with valid PIN (1234) via POST...")
    try:
        response = requests.post(
            f"{base_url}/api/balance",
            json={"pin": "1234"}
        )
        print(f"   Status: {response.status_code}")
        data = response.json()
        print(f"   Response: {json.dumps(data, indent=2)}")

        if data.get("success"):
            print(f"   ✓ Balance: {data['balance']} {data['currency']}")
            print(f"   ✓ Account: {data['account_name']}")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 4: Another valid PIN (5678 - EUR account)
    print("\n4. Testing with valid PIN (5678) - EUR account...")
    try:
        response = requests.post(
            f"{base_url}/api/balance",
            json={"pin": "5678"}
        )
        data = response.json()
        print(f"   Status: {response.status_code}")
        if data.get("success"):
            print(f"   ✓ Balance: {data['balance']} {data['currency']}")
            print(f"   ✓ Account: {data['account_name']}")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 5: Invalid PIN
    print("\n5. Testing with invalid PIN (0000)...")
    try:
        response = requests.post(
            f"{base_url}/api/balance",
            json={"pin": "0000"}
        )
        print(f"   Status: {response.status_code}")
        data = response.json()
        print(f"   Response: {json.dumps(data, indent=2)}")

        if not data.get("success"):
            print(f"   ✓ Correctly denied access")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 6: Invalid PIN format
    print("\n6. Testing with invalid PIN format (123)...")
    try:
        response = requests.post(
            f"{base_url}/api/balance",
            json={"pin": "123"}
        )
        print(f"   Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")

        if response.status_code == 400:
            print(f"   ✓ Correctly rejected invalid format")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 7: GET endpoint
    print("\n7. Testing GET endpoint with PIN 7890...")
    try:
        response = requests.get(f"{base_url}/api/balance/7890")
        print(f"   Status: {response.status_code}")
        data = response.json()
        if data.get("success"):
            print(f"   ✓ Balance: {data['balance']} {data['currency']}")
            print(f"   ✓ Account: {data['account_name']}")
    except Exception as e:
        print(f"   Error: {e}")

    # Test 8: All available test accounts
    print("\n8. Testing all available test accounts...")
    test_pins = ["1234", "5678", "9012", "3456", "7890"]
    for pin in test_pins:
        try:
            response = requests.post(
                f"{base_url}/api/balance",
                json={"pin": pin}
            )
            data = response.json()
            if data.get("success"):
                print(f"   PIN {pin}: {data['balance']} {data['currency']} ({data['account_name']})")
        except Exception as e:
            print(f"   PIN {pin}: Error - {e}")

    print("\n" + "=" * 60)
    print("Testing complete!")
    print("=" * 60)


if __name__ == "__main__":
    # Wait a moment for server to be ready if just started
    print("Waiting for server to be ready...")
    time.sleep(2)

    test_balance_api()
