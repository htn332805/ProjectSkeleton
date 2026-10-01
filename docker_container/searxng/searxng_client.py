#!/usr/bin/env python3
"""
Simple SearXNG Command-Line Client
A practical example of how to use the SearXNG API
"""

import urllib.request
import urllib.parse
import json
import sys

def search(query, format='json', language='en'):
    """
    Perform a search using the SearXNG API
    
    Args:
        query: Search terms
        format: Response format ('json' or 'html')
        language: Language code (e.g., 'en', 'vi')
    
    Returns:
        Parsed response or HTML string
    """
    base_url = "http://localhost:8080/search"
    params = {
        'q': query,
        'format': format,
        'lang': language
    }
    
    # Build URL with parameters
    query_string = urllib.parse.urlencode(params)
    url = f"{base_url}?{query_string}"
    
    try:
        # Create request with proper headers to avoid bot detection
        request = urllib.request.Request(url)
        request.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36')
        request.add_header('X-Forwarded-For', '203.0.113.42')  # Fake IP to avoid localhost bot detection
        request.add_header('Accept', 'application/json' if format == 'json' else 'text/html')
        
        response = urllib.request.urlopen(request, timeout=30)
        content = response.read().decode('utf-8')
        
        if format == 'json':
            return json.loads(content)
        else:
            return content
            
    except Exception as e:
        print(f"Error: {e}")
        return None

def print_results(data):
    """Pretty-print search results"""
    if not data:
        print("❌ No response received")
        return
    
    if isinstance(data, str):
        print(data[:500])  # Show first 500 chars of HTML
        return
    
    print(f"\n📊 Search Results for: '{data.get('query')}'")
    print("=" * 70)
    
    results = data.get('results', [])
    if not results:
        print("⚠️  No results found")
        return
    
    for i, result in enumerate(results[:5], 1):
        print(f"\n{i}. {result.get('title', 'No title')}")
        print(f"   🔗 {result.get('url', 'No URL')}")
        print(f"   📌 {result.get('engine', 'Unknown engine')}")
        if result.get('content'):
            print(f"   📝 {result['content'][:100]}...")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 searxng_client.py '<query>' [format] [language]")
        print("Example: python3 searxng_client.py 'python programming'")
        sys.exit(1)
    
    query = sys.argv[1]
    format_type = sys.argv[2] if len(sys.argv) > 2 else 'json'
    language = sys.argv[3] if len(sys.argv) > 3 else 'en'
    
    print(f"🔍 Searching for: '{query}' (format: {format_type})")
    results = search(query, format_type, language)
    print_results(results)
