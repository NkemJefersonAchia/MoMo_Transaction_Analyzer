import time
import random
from xml_parser import parse_sms_xml   # ← imports the real parser

def compare_search_performance():
    print("Loading transactions...")
    transactions = parse_sms_xml()
    if not transactions:
        print("No transactions loaded → cannot benchmark.")
        return
    
    print(f"\nTotal records: {len(transactions)}")
    
    tx_dict = {tx["id"]: tx for tx in transactions}
    
    # Pick IDs to search (all if small, sample if large)
    if len(transactions) <= 200:
        search_ids = [tx["id"] for tx in transactions]
    else:
        search_ids = random.sample([tx["id"] for tx in transactions], 200)
    
    random.shuffle(search_ids)
    
    # Linear search
    start = time.perf_counter()
    for sid in search_ids:
        for tx in transactions:
            if tx["id"] == sid:
                break
    linear_time = time.perf_counter() - start
    
    # Dictionary lookup
    start = time.perf_counter()
    for sid in search_ids:
        _ = tx_dict.get(sid)
    dict_time = time.perf_counter() - start
    
    print(f"\nPerformance ({len(search_ids)} lookups):")
    print(f"  Linear search:     {linear_time:.6f} s")
    print(f"  Dictionary lookup: {dict_time:.6f} s")
    if dict_time > 0:
        print(f"  → Dict is {linear_time / dict_time:.1f}x faster")

if __name__ == "__main__":
    compare_search_performance()
