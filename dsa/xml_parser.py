import xml.etree.ElementTree as ET
import json
import os

def parse_sms_xml():
    # 1. Dynamically find the file path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, 'modified_sms_v2.xml')
    output_path = os.path.join(script_dir, 'transactions.json')

    if not os.path.exists(file_path):
        print(f"Error: Could not find '{file_path}'")
        print("Please ensure the XML file is in the same folder as this script.")
        return

    try:
        # 2. Parse the XML
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        transactions = []
        
        # Loop through each <sms> tag
        for index, sms in enumerate(root.findall('sms')):
            transaction = {
                "id": index + 1,  # Unique ID for Task 2 CRUD
                "sender": sms.get('address'),
                "date_ms": sms.get('date'),
                "readable_date": sms.get('readable_date'),
                "body": sms.get('body'),
                "type": sms.get('type')
            }
            transactions.append(transaction)
            
        # 3. Save to JSON
        with open(output_path, 'w') as f:
            json.dump(transactions, f, indent=4)

        print(f"Task 1 Complete: {len(transactions)} records converted to {output_path}")

    except Exception as e:
        print(f"Error parsing XML: {e}")

if __name__ == "__main__":
    parse_sms_xml()

