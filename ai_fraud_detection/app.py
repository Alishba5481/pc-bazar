from flask import Flask, request, jsonify, make_response
import model.duplicate_detector as duplicate_detector
import model.price_anomaly as price_anomaly

app = Flask(__name__)

DATASET_PATH = "dataset/products.csv"


# Allow the Flutter app (including Flutter web) to call this API
@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type,Authorization"
    response.headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
    return response


@app.route("/check_fraud", methods=["POST", "OPTIONS"])
def check_fraud():
    # Handle the browser preflight request
    if request.method == "OPTIONS":
        return make_response("", 204)

    data = request.get_json(force=True)

    similarity_score = duplicate_detector.check_duplicate(
        data["title"],
        data["description"],
        DATASET_PATH
    )

    price_score = price_anomaly.price_anomaly(
        data["category"],
        data["price"],
        DATASET_PATH
    )

    fraud_score = (0.6 * similarity_score) + (0.4 * (price_score / 3))

    if fraud_score > 0.7:
        result = "high_risk"
    elif fraud_score > 0.4:
        result = "medium_risk"
    else:
        result = "safe"

    return jsonify({
        "duplicate_similarity": similarity_score,
        "price_anomaly": price_score,
        "fraud_score": fraud_score,
        "result": result
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
