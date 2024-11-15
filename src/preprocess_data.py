import pandas as pd
import argparse

def preprocess_data(expression_file, pathway_file, mutation_file, output_file):
    # Load data
    expression = pd.read_csv(expression_file)
    pathway = pd.read_csv(pathway_file)
    mutation = pd.read_csv(mutation_file)

    # Filter genes in the pathway
    pathway_genes = pathway['Gene']
    expression = expression[expression['Gene'].isin(pathway_genes)]

    # Merge mutation data
    data = pd.merge(expression, mutation, on='Gene', how='left')
    data.fillna(0, inplace=True)  # Fill missing mutation data with 0

    # Save preprocessed data
    data.to_csv(output_file, index=False)
    print(f"Preprocessed data saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Preprocess data for drug target prediction.")
    parser.add_argument("--expression", required=True, help="Path to gene expression data.")
    parser.add_argument("--pathway", required=True, help="Path to pathway gene data.")
    parser.add_argument("--mutation", required=True, help="Path to mutation data.")
    parser.add_argument("--output", required=True, help="Path to save preprocessed data.")
    args = parser.parse_args()

    preprocess_data(args.expression, args.pathway, args.mutation, args.output)
