from flask import Flask, jsonify, request

app = Flask(__name__)

@app.get("/")
def hello():
    return jsonify({"message": "Hello from Docker API!", "status": "running"})

@app.get("/hello/<name>")
def hello_name(name):
    return jsonify({"message": f"Hello, {name}!"})

@app.get("/items")
def get_items():
    items = ["apple", "banana", "orange"]
    return jsonify({"items": items})

@app.post("/add")
def add_item():
    data = request.get_json()
    return jsonify({
        "received": data,
        "info": "Data successfully processed!"
    })
