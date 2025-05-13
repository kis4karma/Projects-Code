import streamlit as st
import pandas as pd
import numpy as np
import joblib
import random

# Load pre-trained model and feature structure
kmeans = joblib.load("kmeans_cluster_model.pkl")
feature_columns = joblib.load("feature_columns_template.pkl")

# Simulate or input dice rolls
st.title("🎲 Stake Seed Classifier & Strategy Recommender")
st.markdown("Upload or simulate 1000 dice rolls (values from 0 to 99.9999)")

roll_source = st.radio("How do you want to provide rolls?", ["Simulate", "Upload CSV"])

if roll_source == "Simulate":
    rolls = [random.uniform(0, 99.9999) for _ in range(1000)]
else:
    uploaded_file = st.file_uploader("Upload CSV with one column of rolls")
    if uploaded_file:
        df_upload = pd.read_csv(uploaded_file)
        rolls = df_upload.iloc[:, 0].tolist()
    else:
        rolls = []

if len(rolls) == 1000:
    win_loss = ["Win" if r < 50 else "Loss" for r in rolls]

    # Feature extraction
    low = sum(1 for r in rolls if r < 33.33)
    mid = sum(1 for r in rolls if 33.33 <= r < 66.66)
    high = sum(1 for r in rolls if r >= 66.66)

    repeats = sum(1 for i in range(1, len(win_loss)) if win_loss[i] == win_loss[i - 1])
    reversals = sum(1 for i in range(2, len(win_loss)) if win_loss[i-2] != win_loss[i-1] and win_loss[i-2] == win_loss[i])

    streaks = []
    current = win_loss[0]
    streak_len = 1
    for outcome in win_loss[1:]:
        if outcome == current:
            streak_len += 1
        else:
            streaks.append((current, streak_len))
            current = outcome
            streak_len = 1
    streaks.append((current, streak_len))

    win_streaks = [s for r, s in streaks if r == "Win"]
    loss_streaks = [s for r, s in streaks if r == "Loss"]

    feature_vector = pd.DataFrame([{
        "Low Zone %": low / 1000,
        "Mid Zone %": mid / 1000,
        "High Zone %": high / 1000,
        "Repeats": repeats,
        "Reversals": reversals,
        "Avg Win Streak": np.mean(win_streaks),
        "Avg Loss Streak": np.mean(loss_streaks),
        "Longest Win Streak": max(win_streaks),
        "Longest Loss Streak": max(loss_streaks)
    }])[feature_columns]

    predicted_cluster = kmeans.predict(feature_vector)[0]

    strategy_map = {
        0: "🔐 Conservative: Bet only after 2+ win streaks",
        1: "⚡ Aggressive: Bet on win-loss flips",
        2: "📈 Trend Rider: Bet same as last outcome"
    }

    st.success(f"Predicted Cluster: {predicted_cluster}")
    st.info(f"Recommended Strategy: {strategy_map[predicted_cluster]}")

    st.subheader("Extracted Features")
    st.dataframe(feature_vector)

else:
    if roll_source == "Upload CSV":
        st.warning("Please upload a CSV file with 1000 numeric dice rolls")
    else:
        st.info("Click the button to simulate 1000 rolls.")
