from flask import Flask, request, jsonify, render_template
import json, os
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)
app.config["SECRET_KEY"] = os.environ.get('SECRET_KEY', '')

@app.route('/write', methods=['GET'])
def write_file():
    key = request.args.get('key')
    print(key)
    print(app.config["SECRET_KEY"])
    if (key != app.config["SECRET_KEY"]):
        return jsonify({'success': False})
    # act, scene, page
    a = request.args.get('a')
    s = request.args.get('s')
    p = request.args.get('p')
    data = {
        'a': a,
        's': s,
        'p': p
    }
    try:
        with open('tracker.json', 'w+') as f:
            json.dump(data, f)
        response = {'success': True}
    except:
        response = {'success': False}
    return jsonify(response)

@app.route('/json', methods=['GET'])
def read_json():
    with open('tracker.json', 'r') as f:
        data = json.load(f)
    return jsonify(data)

@app.route('/', methods=['GET'])
def read_html():
    t = request.args.get('t')
    try:
        with open('tracker.json', 'r') as f:
            data = json.load(f)
    except IOError:
        data = {'a':0,'s':0,'p':0}
    return render_template('index.html', data=data)

if __name__ == '__main__':
    app.run(debug=True)