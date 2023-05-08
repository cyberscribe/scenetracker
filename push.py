import sys, requests, os, json, urllib.parse
from dotenv import load_dotenv
load_dotenv()

SECRET_KEY = os.environ.get('SECRET_KEY', '')
WRITE_URL = os.environ.get('WRITE_URL', 'http://127.0.0.1:5000/write')
# Check if all three arguments were passed
if len(sys.argv) != 4:
    print("Usage: python write.py <act> <scene> <page>")
    sys.exit(1)

# Assign the command-line arguments to variables
a = urllib.parse.quote(sys.argv[1])
s = urllib.parse.quote(sys.argv[2])
p = urllib.parse.quote(sys.argv[3])

# Build the URL with the three arguments
url = f"{WRITE_URL}?a={a}&s={s}&p={p}&key={SECRET_KEY}"

# Make the GET request
response = requests.get(url)
if (response.json()["success"]):
    sys.exit(0)

sys.exit(1)
