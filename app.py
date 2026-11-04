from flask import Flask, jsonify, render_template_string
from datetime import datetime, timezone
import os

app = Flask(__name__)
PAGE = """<!doctype html><html><head><title>Cloud DevOps Capstone</title>
<style>body{font-family:Arial;margin:8vh auto;max-width:760px;padding:24px;color:#183153}
.card{border:1px solid #d7e0ea;border-radius:14px;padding:28px}</style></head>
<body><div class="card"><h1>AWS Cloud Admin & DevOps Capstone</h1>
<p>Application is running.</p><p>Environment: {{ env }}</p>
<p>Build: {{ build }}</p><small>UTC: {{ now }}</small></div></body></html>"""

@app.get("/")
def home():
    return render_template_string(PAGE, env=os.getenv("APP_ENV", "dev"),
                                  build=os.getenv("APP_BUILD", "local"),
                                  now=datetime.now(timezone.utc).isoformat())

@app.get("/health")
def health():
    return jsonify(status="ok", service="cloud-devops-capstone"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")))
