# MoMo Transaction REST API Documentation

**Version:** 1.0  
**Base URL:** `http://localhost:8000`  
**Auth Type:** HTTP Basic Authentication

##  Table of Contents
- [Getting Started](#getting-started)
- [Authentication](#security-overview)
- [Endpoints](#endpoints)
- [Data Models](#data-models)
- [Error Codes](#error-codes)

---

##  Getting Started
To get this API running on your local machine:
1. Ensure `transactions.json` exists in the `dsa/` directory.
2. If not, go to `dsa/`  and run `pythom3 xml_parser` to generate one.
3. Open your terminal in the `api/` folder.
4. Run: `python3 rest_api.py`.
5. The server will start on `http://localhost:8000`.

## Security Overview
To access any endpoint, the `Authorization` header must be present.
- **Username:** `team5`
- **Password:** `ALU2025`

---

##  Data Models

### Transaction Object
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | Integer | Unique identifier for the transaction. |
| `sender` | String | Name or Number of the sender. |
| `amount` | String | Amount with currency (e.g., "5000 RWF"). |
| `type` | String | Type of transaction (e.g., Transfer, Payment). |
| `readable_date` | String | Formatted timestamp of the transaction. |

---

## Endpoints

### 1. Retrieve All Transactions
- **Method:** `GET`
- **URL:** `/transactions`
- **Description:** Returns a full list of all 1,691 parsed SMS records.
- **Example cURL Request:**
  ```bash
  curl -u team5:ALU2025 http://localhost:8000/transactions
  ```
- **Response (200 OK):**
  ```json
  [
    {
      "id": 1,
      "sender": "M-Money",
      "amount": "5000 RWF",
      "type": "Transfer",
      "readable_date": "2026-01-22 10:00:00"
    }
  ]
  ```

### 2. View Single Transaction (Optimized)
- **Method:** `GET`
- **URL:** `/transactions/{id}`
- **Description:** Fetches one record using a specific ID.
- **DSA Implementation:** Uses O(1) Dictionary Lookup for instant retrieval regardless of dataset size.
- **Example cURL Request:**
  ```bash
  curl -u team5:ALU2025 http://localhost:8000/transactions/1
  ```
- **Response (200 OK):**
  ```json
  {
    "id": 1,
    "sender": "M-Money",
    "amount": "5000 RWF",
    "type": "Transfer",
    "readable_date": "2026-01-22 10:00:00"
  }
  ```
- **Error (404 Not Found):**
  ```json
  {"error": "Transaction not found"}
  ```

### 3. Create New Transaction
- **Method:** `POST`
- **URL:** `/transactions`
- **Description:** Adds a new transaction to the memory.
- **Payload (JSON):**
  ```json
  {
    "sender": "250780000000",
    "amount": "2000",
    "type": "Payment",
    "body": "Airtime Purchase"
  }
  ```
- **Response (201 Created):** Returns the object with the newly assigned unique ID.

### 4. Update Record
- **Method:** `PUT`
- **URL:** `/transactions/{id}`
- **Description:** Updates specific fields of an existing transaction.
- **DSA Implementation:** Uses Linear Search to locate the record within the list (O(n) complexity).
- **Response (200 OK):**
  ```json
  {
    "id": 1,
    "sender": "M-Money",
    "amount": "3500 RWF",
    "type": "Transfer",
    "readable_date": "2026-01-22 10:00:00"
  }
  ```

### 5. Remove Record
- **Method:** `DELETE`
- **URL:** `/transactions/{id}`
- **Description:** Permanently deletes a record from both the list and the dictionary.
- **Response (200 OK):**
  ```json
  {"message": "Deleted"}
  ```

##  Error Codes
- `200 OK` – Request successful.
- `201 Created` – Resource created successfully.
- `404 Not Found` – Transaction does not exist.
- `400 Bad Request` – Invalid request payload.
- `401 Unauthorized` – Missing or incorrect authentication.

