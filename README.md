# Team 5 MoMo Transactions Analyzer

## Project Description

A full-stack application that processes Mobile Money SMS transactions, 
stores them in a database, and visualizes spending patterns.

## Team Members
- Nkem Jeferson Achia
- Muhammed Awwal Achuja
- Philbert Kuria

## Link to our Trello Scrum Board

Link: https://trello.com/invite/b/6962aee2b234ced12549c24c/ATTIf1d0632ffd45321b8642afce072cc62274550814/team-5

## Link to our Miro Diagram
 
Link: https://miro.com/app/board/uXjVGUdVhZI=/?share_link_id=83189650634
##  Features Implemented
1. **XML to JSON Parser:** Automatically converts `modified_sms_v2.xml` into a usable JSON database.
2. **RESTful API:** Built using Python's `http.server`, supporting GET, POST, PUT, and DELETE.
3. **Security:** Implemented Basic Authentication to protect financial data.
4. **DSA Optimization:** Integrated a dual-storage system (List and Dictionary) to compare search algorithm efficiencies.

##  Challenges & Solutions
- **Challenge: Large Dataset Handling.** Sending 1,600+ records caused "Socket Hang Up" errors in Postman.
  - **Solution:** Implemented explicit `Content-Length` headers in the API response so the client knows exactly when the data stream ends.
- **Challenge: Data Synchronization.** Keeping the Dictionary and the List in sync during POST/DELETE operations.
  - **Solution:** Created a unified update logic where every write operation updates both the `transactions` list and the `transactions_dict` simultaneously.
- **Challenge: Parse Errors.** Encountered "Invalid character" errors in Postman.
  - **Solution:** Enforced `utf-8` encoding on all `wfile.write` calls to handle special characters found in SMS bodies.

##  Setup
1. Place `modified_sms_v2.xml` in the `dsa/` folder.
2. Run `python dsa/parser_script.py`.
3. Run `python api/rest_api.py`.
4. Access via Postman at `http://localhost:8000/transactions`.
