import os

from flask import Flask, Response, jsonify

app = Flask(__name__)

REQUEST_COUNT = 0


@app.after_request
def count_request(response):
    global REQUEST_COUNT
    REQUEST_COUNT += 1
    return response


@app.get("/")
def index():
    return jsonify({"message": "Hello World from DevOps"})


@app.get("/health")
def health():
    return jsonify({"status": "ok"})


@app.get("/metrics")
def metrics():
    body = (
        "# HELP demo_requests_total Total HTTP requests handled.\n"
        "# TYPE demo_requests_total counter\n"
        f"demo_requests_total {REQUEST_COUNT}\n"
    )
    return Response(body, mimetype="text/plain; version=0.0.4")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "8000")))  # nosec B104
