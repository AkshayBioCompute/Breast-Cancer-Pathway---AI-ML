import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
import argparse
import joblib

def train_model(input_file, model_file, predictions_file):
    # Load features
    data = pd.read_csv(input_file)
    X = data[['Expression_Mean', 'Expression_Std', 'Mutation_Sum']]
    y = (data['Gene'].str.contains("Target")).astype(int)  # Example target variable

    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train model
    model = RandomForestClassifier(random_state=42)
    model.fit(X_train, y_train)

    # Evaluate model
    y_pred = model.predict(X_test)
    print("Model Evaluation:")
    print(classification_report(y_test, y_pred))

    # Save model
    joblib.dump(model, model_file)
    print(f"Model saved to {model_file}")

    # Save predictions
    predictions = pd.DataFrame({"Gene": data['Gene'], "Prediction": model.predict(X)})
    predictions.to_csv(predictions_file, index=False)
    print(f"Predictions saved to {predictions_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Train a Random Forest model for drug target prediction.")
    parser.add_argument("--input", required=True, help="Path to feature data.")
    parser.add_argument("--model", required=True, help="Path to save trained model.")
    parser.add_argument("--predictions", required=True, help="Path to save predictions.")
    args = parser.parse_args()

    train_model(args.input, args.model, args.predictions)
