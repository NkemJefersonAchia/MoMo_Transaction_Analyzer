# Team 5 MoMo Transactions Analyzer

## Project Description

A full-stack application that processes Mobile Money SMS transactions, stores them in a database, and visualizes spending patterns.

## Team Members
- Nkem Jeferson Achia
- Muhammed Awwal Achuja
- Philbert Kuria

## Project Resources

- **Trello Scrum Board:** https://trello.com/invite/b/6962aee2b234ced12549c24c/ATTIf1d0632ffd45321b8642afce072cc62274550814/team-5
- **Miro Diagram:** https://miro.com/app/board/uXjVGUdVhZI=/?share_link_id=83189650634
- **Team Tasksheet:** https://docs.google.com/spreadsheets/d/12QK9rFzr45NwA9IXL3wIgM60ONJPslisKoZHr04at5s/edit?gid=0#gid=0

---


## Assignment 1: XML Parser & RESTful API

### Features Implemented
1. **XML to JSON Parser:** Automatically converts `modified_sms_v2.xml` into a usable JSON database.
2. **RESTful API:** Built using Python's `http.server`, supporting GET, POST, PUT, and DELETE.
3. **Security:** Implemented Basic Authentication to protect financial data.
4. **DSA Optimization:** Integrated a dual-storage system (List and Dictionary) to compare search algorithm efficiencies.

### Challenges & Solutions
- **Socket Hang Up Errors:** Implemented explicit `Content-Length` headers in API responses.
- **Data Synchronization:** Created unified update logic for both `transactions` list and `transactions_dict`.
- **Parse Errors:** Enforced `utf-8` encoding on all `wfile.write` calls.

### Setup
1. Place `modified_sms_v2.xml` in the `dsa/` folder.
2. Run `python dsa/parser_script.py`.
3. Run `python api/rest_api.py`.
4. Access via Postman at `http://localhost:8000/transactions`.

---

## Assignment 2: Database Design & Implementation

### Overview
The database schema was designed and implemented in MySQL based on the ERD.

### Key Features
- **Tables:** `users`, `categories`, `transactions`, `labels`, `transaction_labels` (junction), `system_logs`
- **Referential Integrity:** FOREIGN KEY constraints with appropriate ON DELETE/UPDATE rules
- **Performance:** Indexes on `timestamp`, `sender_id`, `receiver_id`, `tx_ref`
- **Data Types:** DECIMAL(15,2) for amounts, BIGINT for phone numbers
- **Constraints:** UNIQUE constraints and CHECK constraints (e.g., amount >= 0)
- **Documentation:** Column comments for clarity

### Deliverables
- Database Design Document: `docs/`
- ERD Diagram: `docs/erd_diagram.png`
- SQL Setup Script: `database/database_setup.sql`
- JSON Schemas: `examples/json_schemas.json`

### Running the SQL Script

#### Prerequisites
1. **Install MySQL Server**
  - **macOS:** `brew install mysql`
  - **Linux:** `sudo apt-get install mysql-server`
  - **Windows:** Download from https://dev.mysql.com/downloads/mysql/

2. **Start MySQL Server**
  - **macOS/Linux:** `mysql.server start` or `sudo service mysql start`
  - **Windows:** MySQL service starts automatically

3. **Log in to MySQL**
  ```bash
  mysql -u root -p
  ```
  Enter your MySQL root password when prompted.

#### Execute the SQL Script

**Option 1: From MySQL CLI**
```bash
mysql -u root -p < database/database_setup.sql
```

**Option 2: Inside MySQL Shell**
```bash
mysql -u root -p
mysql> source database/database_setup.sql;
```

**Option 3: Using Python**
```bash
python database/run_database_setup.py
```

### Testing
- Basic CRUD operations executed successfully (SELECT with joins, UPDATE description, DELETE label associations)
- Screenshots included in documentation


### Data Serialization

The following table demonstrates the mapping between SQL database schema and JSON API responses, illustrating serialization understanding:

| SQL Table | SQL Column | JSON Key | Data Type | Implementation Note |
|-----------|-----------|----------|-----------|-------------------|
| Transactions | txn_id | transaction_id | Integer | Direct mapping of Primary Key |
| Transactions | ext_ref | external_id | String | MoMo unique reference string |
| Users | full_name | sender.name | Object/String | Nested via FK Join on sender_id |
| Categories | cat_name | category.name | Object/String | Nested via FK Join on category_id |
| Transactions | txn_date | date | String | Formatted to ISO 8601 for API |

---

## Documentation

All project documentation, including the AI usage log and other project documents, can be found in the `docs/` folder.
