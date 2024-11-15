version 1.0

workflow drug_target_prediction {
    input {
        File expression = "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/gene_expression.csv"
        File pathway = "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/pathway_genes.csv"
        File mutation = "/home/akshay/Akshay/Breast_cancer_patway_AI_ML/data/mutation_data.csv"
    }

    call PreprocessData {
        input:
            expression = expression,
            pathway = pathway,
            mutation = mutation
    }

    call FeatureEngineering {
        input:
            preprocessed_data = PreprocessData.preprocessed_data
    }

    call TrainModel {
        input:
            features = FeatureEngineering.features
    }

    call ValidatePredictions {
        input:
            predictions = TrainModel.predictions
    }

    call VisualizeResults {
        input:
            predictions = TrainModel.predictions
    }

    output {
        File predictions = TrainModel.predictions
        File feature_importance = VisualizeResults.feature_importance
        File ppi_network = VisualizeResults.ppi_network
    }
}

task PreprocessData {
    input {
        File expression
        File pathway
        File mutation
    }

    command {
        python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/preprocess_data.py \
            --expression ~{expression} \
            --pathway ~{pathway} \
            --mutation ~{mutation} \
            --output preprocessed_data.csv
    }

    output {
        File preprocessed_data = "preprocessed_data.csv"
    }
}

task FeatureEngineering {
    input {
        File preprocessed_data
    }

    command {
        python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/feature_engineering.py \
            --input ~{preprocessed_data} \
            --output features.csv
    }

    output {
        File features = "features.csv"
    }
}

task TrainModel {
    input {
        File features
    }

    command {
        python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/train_model.py \
            --input ~{features} \
            --model model.pkl \
            --predictions predictions.csv
    }

    output {
        File model = "model.pkl"
        File predictions = "predictions.csv"
    }
}

task ValidatePredictions {
    input {
        File predictions
    }

    command {
        python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/validate_predictions.py \
            --input ~{predictions} \
            --output validation_report.txt
    }

    output {
        File validation_report = "validation_report.txt"
    }
}

task VisualizeResults {
    input {
        File predictions
    }

    command {
        python3 /home/akshay/Akshay/Breast_cancer_patway_AI_ML/src/visualize_results.py \
            --input ~{predictions} \
            --importance_plot feature_importance.png \
            --ppi_plot ppi_network.png
    }

    output {
        File feature_importance = "feature_importance.png"
        File ppi_network = "ppi_network.png"
    }
}
