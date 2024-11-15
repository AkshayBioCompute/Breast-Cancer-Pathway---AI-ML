# workflows/Snakefile
rule all:
    input:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/predictions.csv",
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/feature_importance.png",
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/ppi_network.png"

# Step 1: Data Collection and Preprocessing
rule preprocess_data:
    input:
        expression="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/gene_expression.csv",
        pathway="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/pathway_genes.csv",
        mutation="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/mutation_data.csv"
    output:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/preprocessed_data.csv"
    script:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/preprocess_data.py"

# Step 2: Feature Engineering
rule feature_engineering:
    input:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/preprocessed_data.csv"
    output:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/features.csv"
    script:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/feature_engineering.py"

# Step 3: Model Training and Evaluation
rule train_model:
    input:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/features.csv"
    output:
        model="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/model.pkl",
        predictions="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/predictions.csv"
    script:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/train_model.py"

# Step 4: Validation
rule validate_predictions:
    input:
        predictions="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/predictions.csv"
    output:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/validation_report.txt"
    script:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/validate_predictions.py"

# Step 5: Visualization
rule visualize_results:
    input:
        predictions="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/predictions.csv"
    output:
        importance_plot="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/feature_importance.png",
        ppi_plot="/home/akshay/Akshay/Breast_cancer_patway_AI_ML/results/ppi_network.png"
    script:
        "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/visualize_results.py"

