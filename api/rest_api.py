import base64
import json
from  http.server import HTTPServer, BaseHTTPRequestHandler

transactions = [] #list for linear search
transactions_dict = {} #for disctionary lookup

class APIHandler(BaseHTTPRequestHandler):
    def check_login(self):
        authentication_header = self.headers.get('Authorization')
        if not authentication_header:
            return False
        encoder = authentication_header.split('')[1]
        decoder = base64.b64decode(encoder).decode('utf-8')
        return decoder == "team5:ALU2025"
    def do_GET(self):
        if not self.check_login():
            self.send_response(401)
            self.end_headers()
            return
        #show all transactions
        if self.path == '/transactions':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(transactions).encode)
        elif self.path.startswith('/transaction/'):
            txn_id = int(self.path.split('/')[-1])
            
            txn=next((t for t in transactions if t['id']==txn_id), None)
            if txn:
                self.send_response(200)
                self.end_headers()
                self.wfile.write(json.dumps(txn).encode())
            else:
                self.send_response(404)
                self.end_headers()
            
    def do_POST(self):
        if not self.check_login():
            self.send_response(401)
            self.end_headers()
            return
        content_length = int(self.headers['Content-Length'])
        body = self.efile.read(content_length)
        new_data = json.loads(body)
        new_data['id'] = len(transactions) + 1
        transactions.append(new_data)