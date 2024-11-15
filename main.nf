nextflow.enable.dsl=2

workflow {
    preprocess_data()
    feature_engineering()
    train_model()
    validate_predictions()
    visualize_results()
}

process preprocess_data {
    input:
    path expression
    path pathway
    path mutation

    output:
    path "${params.results}/preprocessed_data.csv"

    script:
    """
    python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/preprocess_data.py \
        --expression $expression \
        --pathway $pathway \
        --mutation $mutation \
        --output ${params.results}/preprocessed_data.csv
    """
}

process feature_engineering {
    input:
    path "${params.results}/preprocessed_data.csv"

    output:
    path "${params.results}/features.csv"

    script:
    """
    python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/feature_engineering.py \
        --input ${params.results}/preprocessed_data.csv \
        --output ${params.results}/features.csv
    """
}

process train_model {
    input:
    path "${params.results}/features.csv"

    output:
    path "${params.results}/model.pkl"
    path "${params.results}/predictions.csv"

    script:
    """
    python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/train_model.py \
        --input ${params.results}/features.csv \
        --model ${params.results}/model.pkl \
        --predictions ${params.results}/predictions.csv
    """
}

process validate_predictions {
    input:
    path "${params.results}/predictions.csv"

    output:
    path "${params.results}/validation_report.txt"

    script:
    """
    python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/validate_predictions.py \
        --input ${params.results}/predictions.csv \
        --output ${params.results}/validation_report.txt
    """
}

process visualize_results {
    input:
    path "${params.results}/predictions.csv"

    output:
    path "${params.results}/feature_importance.png"
    path "${params.results}/ppi_network.png"

    script:
    """
    python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/visualize_results.py \
        --input ${params.results}/predictions.csv \
        --importance_plot ${params.results}/feature_importance.png \
        --ppi_plot ${params.results}/ppi_network.png
    """
}
