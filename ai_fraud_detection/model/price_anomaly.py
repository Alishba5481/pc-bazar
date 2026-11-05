import pandas as pd


def price_anomaly(category, price, csv_path):
    df = pd.read_csv(csv_path)

    category_prices = df[df["category"] == category]["price"]

    mean = category_prices.mean()
    std = category_prices.std()

    if std == 0 or pd.isna(std):
        return 0.0

    z_score = (price - mean) / std

    return float(abs(z_score))
