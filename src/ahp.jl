function ahp()
    random_index = Dict(
        1 => 0.00,
        2 => 0.00,
        3 => 0.58,
        4 => 0.90,
        5 => 1.12,
        6 => 1.24,
        7 => 1.32,
        8 => 1.41,
        9 => 1.45
    )
    
    sum_matrix_columns = sum(comparison_matrix, dims=1)

    normalized_matrix = comparison_matrix ./ sum_matrix_columns
    
    priority_vector = (sum(normalized_matrix, dims=2) / number_of_criteria)'

    largest_eigen_value = sum([priority_vector[index] * sum_matrix_columns[index] for index in 1:number_of_criteria])

    consistency_index = (largest_eigen_value - number_of_criteria) / (number_of_criteria - 1)
    
    consistency_ratio = consistency_index / random_index[number_of_criteria]

    return Dict("priority_vector" => priority_vector, "consistency_ratio" => consistency_ratio)
end
