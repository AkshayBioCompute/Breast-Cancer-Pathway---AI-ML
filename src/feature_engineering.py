import pandas as pd
import argparse

def generate_features(input_file, output_file):
    # Load preprocessed data
    data = pd.read_csv(input_file)

    # Calculate basic statistics
    data['Expression_Mean'] = data.iloc[:, 1:].mean(axis=1)
    data['Expression_Std'] = data.iloc[:, 1:].std(axis=1)
    data['Mutation_Sum'] = data['Mutation'].sum(axis=1)

    # Select relevant columns for features
    features = data[['Gene', 'Expression_Mean', 'Expression_Std', 'Mutation_Sum']]
    features.to_csv(output_file, index=False)
    print(f"Features saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate features for machine learning models.")
    parser.add_argument("--input", required=True, help="Path to preprocessed data.")
    parser.add_argument("--output", required=True, help="Path to save features.")
    args = parser.parse_args()

    generate_features(args.input, args.output)
