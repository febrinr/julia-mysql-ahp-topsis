function calculate_normalized_matrix(decision_matrix)
    denominators = sum(x -> x^2, decision_matrix, dims=1).^0.5

    return decision_matrix ./ denominators
end

function get_ideal_solutions(weighted_normalized_matrix)
    positive_ideal_solutions = zeros(Float64, number_of_criteria, 1)
    negative_ideal_solutions = zeros(Float64, number_of_criteria, 1)
    
    for index in 1:number_of_criteria
        if criteria_type[index] == "benefit"
            positive_ideal_solutions[index] = maximum(weighted_normalized_matrix[:, index])
            negative_ideal_solutions[index] = minimum(weighted_normalized_matrix[:, index])
        else
            positive_ideal_solutions[index] = minimum(weighted_normalized_matrix[:, index])
            negative_ideal_solutions[index] = maximum(weighted_normalized_matrix[:, index])
        end
    end
    
    return positive_ideal_solutions, negative_ideal_solutions
end

function get_distance_from_ideal_solutions(number_of_alternatives, weighted_normalized_matrix, positive_ideal_solutions, negative_ideal_solutions)
    distance_from_positive = zeros(Float64, number_of_alternatives, 1)
    distance_from_negative = zeros(Float64, number_of_alternatives, 1)

    for index in 1:number_of_alternatives
        distance_from_positive[index] = sum((weighted_normalized_matrix[index, :] - positive_ideal_solutions).^2)^0.5
        distance_from_negative[index] = sum((weighted_normalized_matrix[index, :] - negative_ideal_solutions).^2)^0.5
    end

    return distance_from_positive, distance_from_negative
end

function get_performance_scores(number_of_alternatives, distance_from_positive, distance_from_negative)
    performance_scores = zeros(Float64, number_of_alternatives, 1)

    for index in 1:number_of_alternatives
        performance_scores[index] = distance_from_negative[index] / (distance_from_positive[index] + distance_from_negative[index])
    end

    return performance_scores
end

function topsis(decision_matrix, priority_vector, number_of_alternatives)
    normalized_matrix = calculate_normalized_matrix(decision_matrix)

    weighted_normalized_matrix = normalized_matrix .* priority_vector

    positive_ideal_solutions, negative_ideal_solutions = get_ideal_solutions(weighted_normalized_matrix)

    distance_from_positive, distance_from_negative = get_distance_from_ideal_solutions(
        number_of_alternatives,
        weighted_normalized_matrix,
        positive_ideal_solutions,
        negative_ideal_solutions
    )

    performance_scores = get_performance_scores(number_of_alternatives, distance_from_positive, distance_from_negative)
    ranks = ordinalrank(performance_scores, rev=true)
    
    return performance_scores, ranks
end
