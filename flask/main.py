from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/')
def top():
    return 'deploy 1'


@app.route('/healthcheck')
def healthcheck():
    return jsonify({'status': 'healthy'}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, threaded=True)
