# AI Fraud Detection

A small Flask API that flags suspicious product listings. Built for the PC Bazar final year project (a Flutter marketplace app for PC parts): see [`../pc_bazaar`](../pc_bazaar).

## How it works
- **Duplicate detection:** TF-IDF + cosine similarity between the new listing and existing listings
- **Price anomaly detection:** z-score of the price within its category
- Both scores are combined into a fraud score: `0.6 * similarity + 0.4 * (price z-score / 3)`
- Risk level: `high_risk` (> 0.7), `medium_risk` (> 0.4), otherwise `safe`

## Tech Stack
Python 3.10+, Flask, pandas, scikit-learn

## Run
```bash
pip install -r requirements.txt
python app.py
```
The API runs on `http://localhost:5000`. CORS is enabled so the Flutter app can call it.

## Example
`POST /check_fraud`
```json
{
  "title": "RTX 3060 Graphic Card",
  "description": "Brand new sealed RTX 3060 card",
  "category": "GPU",
  "price": 40000
}
```
Response:
```json
{
  "duplicate_similarity": 0.968,
  "price_anomaly": 3.108,
  "fraud_score": 0.995,
  "result": "high_risk"
}
```

## Project Structure
```
ai-fraud-detection/
├── app.py
├── model/
│   ├── duplicate_detector.py
│   └── price_anomaly.py
├── dataset/
│   └── products.csv
└── requirements.txt
```

`dataset/products.csv` is a small sample dataset (6 products).
