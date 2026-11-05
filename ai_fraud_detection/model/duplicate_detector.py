import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity


def check_duplicate(new_title, new_description, csv_path):
    df = pd.read_csv(csv_path)

    df["text"] = df["title"] + " " + df["description"]

    texts = df["text"].tolist()
    texts.append(new_title + " " + new_description)

    vectorizer = TfidfVectorizer(stop_words="english")
    tfidf_matrix = vectorizer.fit_transform(texts)

    similarity = cosine_similarity(tfidf_matrix[-1], tfidf_matrix[:-1])

    return float(similarity.max())
